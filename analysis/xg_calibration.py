"""
xG Model Calibration Analysis for NHL Scraper

This script analyzes the calibration of the three xG models by comparing
predicted expected goals against actual goals across NHL seasons.

Usage:
    python xg_calibration.py

Requirements:
    pip install pandas numpy requests matplotlib seaborn
"""

import pandas as pd
import numpy as np
import requests
import gzip
import io
from dataclasses import dataclass
from typing import Optional
import json

# =============================================================================
# MODEL COEFFICIENTS (from R/Model.R)
# =============================================================================

XG_COEFFICIENTS = {
    'v1': {
        'intercept': -1.8999656,
        'distance': -0.0337112,
        'angle': -0.0077118,
        'empty_net': 4.3321873,
        'penalty_kill': 0.6454842,
        'power_play': 0.4080557,
    },
    'v2': {
        'intercept': -1.9963221,
        'distance': -0.0315542,
        'angle': -0.0080897,
        'empty_net': 4.2879873,
        'penalty_kill': 0.6673946,
        'power_play': 0.4089630,
        'rebound': 0.4133378,
        'rush': -0.0657790,
    },
    'v3': {
        'intercept': -1.9942500,
        'distance': -0.0315190,
        'angle': -0.0080823,
        'empty_net': 4.2126061,
        'penalty_kill': 0.6601609,
        'power_play': 0.4106154,
        'rebound': 0.4172151,
        'rush': -0.0709434,
        'goal_differential': 0.0424470,
    }
}

SHOT_TYPES = ['goal', 'shot-on-goal', 'missed-shot', 'blocked-shot']
EXCLUDED_SITUATIONS = ['0101', '1010']  # Shootouts and penalty shots


# =============================================================================
# DATA LOADING
# =============================================================================

def load_season_pbp(season: int) -> pd.DataFrame:
    """Load play-by-play data for a season from HuggingFace."""
    url = (
        f"https://huggingface.co/datasets/RentoSaijo/NHL_DB/resolve/main/"
        f"data/game/pbps/gc/NHL_PBPS_GC_{season}.csv.gz"
    )

    print(f"Loading season {season}...")
    response = requests.get(url)
    response.raise_for_status()

    with gzip.GzipFile(fileobj=io.BytesIO(response.content)) as f:
        df = pd.read_csv(f)

    # Pad situation code to 4 digits
    df['situationCode'] = df['situationCode'].apply(
        lambda x: f"{int(x):04d}" if pd.notna(x) else None
    )

    print(f"  Loaded {len(df):,} events")
    return df


def filter_shots(df: pd.DataFrame) -> pd.DataFrame:
    """Filter to shot attempts only, excluding shootouts/penalty shots."""
    shots = df[df['typeDescKey'].isin(SHOT_TYPES)].copy()
    shots = shots[~shots['situationCode'].isin(EXCLUDED_SITUATIONS)]
    shots = shots.dropna(subset=['situationCode'])
    return shots


# =============================================================================
# FEATURE ENGINEERING
# =============================================================================

def calculate_distance(df: pd.DataFrame) -> pd.DataFrame:
    """Calculate Euclidean distance to net."""
    net_x = 89

    # Normalize coordinates if not already done
    if 'xCoordNorm' not in df.columns:
        df = normalize_coordinates(df)

    df['distance'] = np.sqrt(
        (net_x - df['xCoordNorm'])**2 + df['yCoordNorm']**2
    )
    return df


def calculate_angle(df: pd.DataFrame) -> pd.DataFrame:
    """Calculate shot angle from center of net."""
    net_x = 89

    if 'xCoordNorm' not in df.columns:
        df = normalize_coordinates(df)

    dx = net_x - df['xCoordNorm']
    df['angle'] = np.degrees(np.arctan2(np.abs(df['yCoordNorm']), dx))
    return df


def normalize_coordinates(df: pd.DataFrame) -> pd.DataFrame:
    """Normalize coordinates so all shots attack toward +x."""
    df = df.copy()

    # Determine if we need to flip based on period and home/away
    # This is simplified - the R version is more sophisticated
    if 'xCoord' in df.columns and 'yCoord' in df.columns:
        df['xCoordNorm'] = df['xCoord'].abs()
        df['yCoordNorm'] = df['yCoord']
    else:
        df['xCoordNorm'] = 0
        df['yCoordNorm'] = 0

    return df


def extract_strength_state(df: pd.DataFrame) -> pd.DataFrame:
    """Extract strength state from situation code."""
    df = df.copy()

    def parse_situation(code):
        if pd.isna(code) or len(str(code)) < 4:
            return 'even-strength', False

        code = str(code).zfill(4)
        away_goalie = int(code[0])
        away_skaters = int(code[1])
        home_skaters = int(code[2])
        home_goalie = int(code[3])

        return code, away_goalie, away_skaters, home_skaters, home_goalie

    # Simplified strength state calculation
    def get_strength_state(row):
        code = str(row.get('situationCode', '')).zfill(4)
        if len(code) < 4:
            return 'even-strength'

        away_skaters = int(code[1])
        home_skaters = int(code[2])

        is_home = row.get('eventOwnerTeamId') == row.get('homeTeamId')

        if is_home:
            team_skaters = home_skaters
            opp_skaters = away_skaters
        else:
            team_skaters = away_skaters
            opp_skaters = home_skaters

        if team_skaters > opp_skaters:
            return 'power-play'
        elif team_skaters < opp_skaters:
            return 'penalty-kill'
        else:
            return 'even-strength'

    def get_empty_net(row):
        code = str(row.get('situationCode', '')).zfill(4)
        if len(code) < 4:
            return False

        away_goalie = int(code[0])
        home_goalie = int(code[3])

        is_home = row.get('eventOwnerTeamId') == row.get('homeTeamId')

        # Empty net against means opponent has no goalie
        if is_home:
            return away_goalie == 0
        else:
            return home_goalie == 0

    df['strengthState'] = df.apply(get_strength_state, axis=1)
    df['isEmptyNetAgainst'] = df.apply(get_empty_net, axis=1)

    return df


def flag_rebounds(df: pd.DataFrame) -> pd.DataFrame:
    """Flag shots that are rebounds (within 3 seconds of prior shot)."""
    df = df.copy()
    df['isRebound'] = False

    if 'secondsElapsedInGame' not in df.columns:
        df['isRebound'] = False
        return df

    # Group by game and check time differences
    for game_id, group in df.groupby('gameId'):
        shots = group[group['typeDescKey'].isin(SHOT_TYPES)].sort_values('secondsElapsedInGame')

        if len(shots) < 2:
            continue

        times = shots['secondsElapsedInGame'].values
        indices = shots.index.values

        for i in range(1, len(times)):
            if times[i] - times[i-1] <= 3:
                df.loc[indices[i], 'isRebound'] = True

    return df


def flag_rush(df: pd.DataFrame) -> pd.DataFrame:
    """Flag shots that are rush chances (within 4 seconds of zone entry)."""
    df = df.copy()
    df['isRush'] = False
    # Simplified - would need zone tracking for accurate calculation
    return df


def calculate_goal_differential(df: pd.DataFrame) -> pd.DataFrame:
    """Calculate goal differential at time of shot."""
    df = df.copy()
    df['goalDifferential'] = 0

    if 'homeScore' in df.columns and 'awayScore' in df.columns:
        # Calculate from shooting team's perspective
        is_home = df.get('eventOwnerTeamId') == df.get('homeTeamId')
        df.loc[is_home, 'goalDifferential'] = (
            df.loc[is_home, 'homeScore'] - df.loc[is_home, 'awayScore']
        )
        df.loc[~is_home, 'goalDifferential'] = (
            df.loc[~is_home, 'awayScore'] - df.loc[~is_home, 'homeScore']
        )

    return df


# =============================================================================
# xG CALCULATION
# =============================================================================

def calculate_xg(df: pd.DataFrame, model_version: int = 3) -> pd.DataFrame:
    """Calculate expected goals using specified model version."""
    df = df.copy()
    coeffs = XG_COEFFICIENTS[f'v{model_version}']

    # Ensure required columns exist
    if 'distance' not in df.columns:
        df = calculate_distance(df)
    if 'angle' not in df.columns:
        df = calculate_angle(df)
    if 'strengthState' not in df.columns:
        df = extract_strength_state(df)

    # Calculate linear predictor
    lp = coeffs['intercept']
    lp = lp + coeffs['distance'] * df['distance']
    lp = lp + coeffs['angle'] * df['angle']
    lp = lp + coeffs['empty_net'] * df['isEmptyNetAgainst'].astype(int)

    # Strength state
    lp = lp + coeffs['penalty_kill'] * (df['strengthState'] == 'penalty-kill').astype(int)
    lp = lp + coeffs['power_play'] * (df['strengthState'] == 'power-play').astype(int)

    # Model v2+ features
    if model_version >= 2:
        if 'isRebound' not in df.columns:
            df = flag_rebounds(df)
        lp = lp + coeffs['rebound'] * df['isRebound'].astype(int)

        if 'isRush' not in df.columns:
            df = flag_rush(df)
        lp = lp + coeffs['rush'] * df['isRush'].astype(int)

    # Model v3 features
    if model_version >= 3:
        if 'goalDifferential' not in df.columns:
            df = calculate_goal_differential(df)
        lp = lp + coeffs['goal_differential'] * df['goalDifferential']

    # Apply logistic function
    df[f'xG_v{model_version}'] = 1 / (1 + np.exp(-lp))

    return df


# =============================================================================
# CALIBRATION ANALYSIS
# =============================================================================

def calculate_calibration_stats(seasons: list[int]) -> pd.DataFrame:
    """Calculate calibration statistics across seasons."""
    results = []

    for season in seasons:
        try:
            pbp = load_season_pbp(season)
            shots = filter_shots(pbp)

            print(f"  Processing {len(shots):,} shots...")

            # Calculate xG for all models
            for v in [1, 2, 3]:
                shots = calculate_xg(shots, model_version=v)

            # Count actual goals
            shots['isGoal'] = (shots['typeDescKey'] == 'goal').astype(int)
            actual_goals = shots['isGoal'].sum()
            total_shots = len(shots)

            # Sum xG
            xg_v1 = shots['xG_v1'].sum()
            xg_v2 = shots['xG_v2'].sum()
            xg_v3 = shots['xG_v3'].sum()

            results.append({
                'season': season,
                'total_shots': total_shots,
                'actual_goals': actual_goals,
                'actual_rate': actual_goals / total_shots,
                'xG_v1_total': round(xg_v1, 1),
                'xG_v2_total': round(xg_v2, 1),
                'xG_v3_total': round(xg_v3, 1),
                'diff_v1': round(actual_goals - xg_v1, 1),
                'diff_v2': round(actual_goals - xg_v2, 1),
                'diff_v3': round(actual_goals - xg_v3, 1),
                'pct_diff_v1': round((actual_goals - xg_v1) / actual_goals * 100, 2),
                'pct_diff_v2': round((actual_goals - xg_v2) / actual_goals * 100, 2),
                'pct_diff_v3': round((actual_goals - xg_v3) / actual_goals * 100, 2),
            })

        except Exception as e:
            print(f"  Error processing season {season}: {e}")
            continue

    return pd.DataFrame(results)


def calculate_calibration_bins(
    seasons: list[int],
    model_version: int = 3,
    n_bins: int = 10
) -> pd.DataFrame:
    """Calculate calibration by xG probability bins."""
    all_shots = []

    for season in seasons:
        try:
            pbp = load_season_pbp(season)
            shots = filter_shots(pbp)
            shots = calculate_xg(shots, model_version=model_version)
            shots['isGoal'] = (shots['typeDescKey'] == 'goal').astype(int)
            shots['season'] = season
            all_shots.append(shots[['season', f'xG_v{model_version}', 'isGoal']])
        except Exception as e:
            print(f"Error loading season {season}: {e}")
            continue

    if not all_shots:
        return pd.DataFrame()

    combined = pd.concat(all_shots, ignore_index=True)
    combined = combined.rename(columns={f'xG_v{model_version}': 'xG'})
    combined = combined.dropna(subset=['xG'])

    # Create bins
    combined['bin'] = pd.cut(
        combined['xG'],
        bins=n_bins,
        labels=range(1, n_bins + 1)
    )

    # Aggregate by bin
    bin_stats = combined.groupby('bin').agg({
        'xG': ['mean', 'sum', 'count'],
        'isGoal': ['mean', 'sum']
    }).reset_index()

    bin_stats.columns = ['bin', 'predicted_rate', 'predicted_goals', 'n_shots',
                         'actual_rate', 'actual_goals']
    bin_stats['calibration_error'] = bin_stats['actual_rate'] - bin_stats['predicted_rate']

    return bin_stats


def get_feature_importance_data() -> dict:
    """Get feature importance data for visualization."""
    features = ['Distance', 'Angle', 'Empty Net', 'Penalty Kill',
                'Power Play', 'Rebound', 'Rush', 'Goal Differential']

    data = {
        'features': features,
        'v1': [-0.0337112, -0.0077118, 4.3321873, 0.6454842, 0.4080557, None, None, None],
        'v2': [-0.0315542, -0.0080897, 4.2879873, 0.6673946, 0.4089630, 0.4133378, -0.0657790, None],
        'v3': [-0.0315190, -0.0080823, 4.2126061, 0.6601609, 0.4106154, 0.4172151, -0.0709434, 0.0424470],
    }

    # Calculate odds ratios
    odds_ratios = {
        'features': [
            'Distance (-10 ft)', 'Angle (-10 deg)', 'Empty Net',
            'Penalty Kill', 'Power Play', 'Rebound', 'Rush', 'Goal Diff (+1)'
        ],
        'v3': [
            np.exp(-0.0315190 * -10),  # Distance
            np.exp(-0.0080823 * -10),  # Angle
            np.exp(4.2126061),          # Empty net
            np.exp(0.6601609),          # PK
            np.exp(0.4106154),          # PP
            np.exp(0.4172151),          # Rebound
            np.exp(-0.0709434),         # Rush
            np.exp(0.0424470),          # Goal diff
        ]
    }

    return {'coefficients': data, 'odds_ratios': odds_ratios}


# =============================================================================
# MAIN EXECUTION
# =============================================================================

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='xG Model Calibration Analysis')
    parser.add_argument('--seasons', nargs='+', type=int,
                        default=[20222023, 20232024, 20242025],
                        help='Seasons to analyze')
    parser.add_argument('--output', type=str, default='calibration_results.json',
                        help='Output JSON file')
    args = parser.parse_args()

    print("=" * 60)
    print("xG MODEL CALIBRATION ANALYSIS")
    print("=" * 60)

    # Calculate calibration stats
    print("\nCalculating calibration statistics...")
    stats = calculate_calibration_stats(args.seasons)

    if not stats.empty:
        print("\n" + "=" * 60)
        print("CALIBRATION RESULTS")
        print("=" * 60)

        for _, row in stats.iterrows():
            print(f"\nSeason {row['season']}:")
            print(f"  Total shots: {row['total_shots']:,}")
            print(f"  Actual goals: {row['actual_goals']:,}")
            print(f"  xG v1: {row['xG_v1_total']:,.1f} (diff: {row['diff_v1']:+.1f}, {row['pct_diff_v1']:+.2f}%)")
            print(f"  xG v2: {row['xG_v2_total']:,.1f} (diff: {row['diff_v2']:+.1f}, {row['pct_diff_v2']:+.2f}%)")
            print(f"  xG v3: {row['xG_v3_total']:,.1f} (diff: {row['diff_v3']:+.1f}, {row['pct_diff_v3']:+.2f}%)")

        # Calculate totals
        print("\n" + "-" * 60)
        print("TOTALS ACROSS ALL SEASONS:")
        total_shots = stats['total_shots'].sum()
        total_goals = stats['actual_goals'].sum()
        total_xg_v1 = stats['xG_v1_total'].sum()
        total_xg_v2 = stats['xG_v2_total'].sum()
        total_xg_v3 = stats['xG_v3_total'].sum()

        print(f"  Total shots: {total_shots:,}")
        print(f"  Actual goals: {total_goals:,}")
        print(f"  xG v1: {total_xg_v1:,.1f} (diff: {total_goals - total_xg_v1:+.1f})")
        print(f"  xG v2: {total_xg_v2:,.1f} (diff: {total_goals - total_xg_v2:+.1f})")
        print(f"  xG v3: {total_xg_v3:,.1f} (diff: {total_goals - total_xg_v3:+.1f})")

        # Save results
        results = {
            'calibration_stats': stats.to_dict('records'),
            'totals': {
                'total_shots': int(total_shots),
                'actual_goals': int(total_goals),
                'xG_v1': float(total_xg_v1),
                'xG_v2': float(total_xg_v2),
                'xG_v3': float(total_xg_v3),
            },
            'feature_importance': get_feature_importance_data(),
        }

        with open(args.output, 'w') as f:
            json.dump(results, f, indent=2)

        print(f"\nResults saved to {args.output}")

    print("\n" + "=" * 60)
    print("ANALYSIS COMPLETE")
    print("=" * 60)
