"""
xG Model Calibration - ACTUAL DATA

Run this script on your machine to calculate real xG calibration.
It downloads shot data from HuggingFace and applies the xG models.

Usage:
    pip install pandas numpy requests
    python calculate_real_xg.py
"""

import pandas as pd
import numpy as np
import requests
import gzip
import io

# =============================================================================
# MODEL COEFFICIENTS (exact values from R/Model.R)
# =============================================================================

XG_V1 = {
    'intercept': -1.8999656,
    'distance': -0.0337112,
    'angle': -0.0077118,
    'empty_net': 4.3321873,
    'penalty_kill': 0.6454842,
    'power_play': 0.4080557,
}

XG_V2 = {
    'intercept': -1.9963221,
    'distance': -0.0315542,
    'angle': -0.0080897,
    'empty_net': 4.2879873,
    'penalty_kill': 0.6673946,
    'power_play': 0.4089630,
    'rebound': 0.4133378,
    'rush': -0.0657790,
}

XG_V3 = {
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


def load_season(season: int) -> pd.DataFrame:
    """Load play-by-play data from HuggingFace."""
    url = (
        f"https://huggingface.co/datasets/RentoSaijo/NHL_DB/resolve/main/"
        f"data/game/pbps/gc/NHL_PBPS_GC_{season}.csv.gz"
    )
    print(f"Downloading season {season}...")
    response = requests.get(url, timeout=120)
    response.raise_for_status()

    with gzip.GzipFile(fileobj=io.BytesIO(response.content)) as f:
        df = pd.read_csv(f)

    # Pad situation code
    df['situationCode'] = df['situationCode'].apply(
        lambda x: f"{int(x):04d}" if pd.notna(x) else None
    )
    return df


def filter_shots(df: pd.DataFrame) -> pd.DataFrame:
    """Filter to valid shot attempts."""
    shot_types = ['goal', 'shot-on-goal', 'missed-shot', 'blocked-shot']
    shots = df[df['typeDescKey'].isin(shot_types)].copy()

    # Remove shootouts and penalty shots
    shots = shots[~shots['situationCode'].isin(['0101', '1010'])]
    shots = shots.dropna(subset=['situationCode'])

    return shots


def calculate_features(df: pd.DataFrame) -> pd.DataFrame:
    """Calculate all features needed for xG."""
    df = df.copy()

    # Distance to net (net at x=89)
    if 'xCoord' in df.columns:
        x_norm = df['xCoord'].abs()
        y_norm = df['yCoord'].fillna(0)
        df['distance'] = np.sqrt((89 - x_norm)**2 + y_norm**2)
        df['angle'] = np.degrees(np.arctan2(np.abs(y_norm), 89 - x_norm))
    else:
        df['distance'] = 30  # default
        df['angle'] = 15

    # Strength state from situation code
    def parse_strength(row):
        code = str(row.get('situationCode', '0000')).zfill(4)
        away_g, away_s, home_s, home_g = int(code[0]), int(code[1]), int(code[2]), int(code[3])

        # Determine if shooting team is home
        is_home = row.get('eventOwnerTeamId') == row.get('homeTeamId', 0)

        if is_home:
            team_skaters, opp_skaters = home_s, away_s
            empty_net = away_g == 0
        else:
            team_skaters, opp_skaters = away_s, home_s
            empty_net = home_g == 0

        if team_skaters > opp_skaters:
            strength = 'power-play'
        elif team_skaters < opp_skaters:
            strength = 'penalty-kill'
        else:
            strength = 'even-strength'

        return pd.Series({'strengthState': strength, 'isEmptyNetAgainst': empty_net})

    strength_df = df.apply(parse_strength, axis=1)
    df['strengthState'] = strength_df['strengthState']
    df['isEmptyNetAgainst'] = strength_df['isEmptyNetAgainst']

    # Rebound flag (simplified - shot within 3 sec of prior shot)
    df['isRebound'] = False
    if 'secondsElapsedInGame' in df.columns:
        df = df.sort_values(['gameId', 'secondsElapsedInGame'])
        for game_id, group in df.groupby('gameId'):
            times = group['secondsElapsedInGame'].values
            indices = group.index.values
            for i in range(1, len(times)):
                if times[i] - times[i-1] <= 3:
                    df.loc[indices[i], 'isRebound'] = True

    # Rush flag (simplified)
    df['isRush'] = False

    # Goal differential
    if 'homeScore' in df.columns and 'awayScore' in df.columns:
        is_home = df['eventOwnerTeamId'] == df.get('homeTeamId', 0)
        df.loc[is_home, 'goalDifferential'] = df.loc[is_home, 'homeScore'] - df.loc[is_home, 'awayScore']
        df.loc[~is_home, 'goalDifferential'] = df.loc[~is_home, 'awayScore'] - df.loc[~is_home, 'homeScore']
    else:
        df['goalDifferential'] = 0

    return df


def calculate_xg(df: pd.DataFrame, version: int = 3) -> pd.Series:
    """Calculate xG for each shot."""
    coeffs = {1: XG_V1, 2: XG_V2, 3: XG_V3}[version]

    lp = coeffs['intercept']
    lp = lp + coeffs['distance'] * df['distance']
    lp = lp + coeffs['angle'] * df['angle']
    lp = lp + coeffs['empty_net'] * df['isEmptyNetAgainst'].astype(int)
    lp = lp + coeffs['penalty_kill'] * (df['strengthState'] == 'penalty-kill').astype(int)
    lp = lp + coeffs['power_play'] * (df['strengthState'] == 'power-play').astype(int)

    if version >= 2:
        lp = lp + coeffs['rebound'] * df['isRebound'].astype(int)
        lp = lp + coeffs['rush'] * df['isRush'].astype(int)

    if version >= 3:
        lp = lp + coeffs['goal_differential'] * df['goalDifferential'].fillna(0)

    return 1 / (1 + np.exp(-lp))


def main():
    seasons = [20192020, 20202021, 20212022, 20222023, 20232024, 20242025]

    results = []

    print("=" * 70)
    print("xG MODEL CALIBRATION - REAL DATA")
    print("=" * 70)

    for season in seasons:
        try:
            # Load data
            df = load_season(season)
            print(f"  Loaded {len(df):,} events")

            # Filter to shots
            shots = filter_shots(df)
            print(f"  Filtered to {len(shots):,} shots")

            # Calculate features
            shots = calculate_features(shots)

            # Calculate xG for all versions
            shots['xG_v1'] = calculate_xg(shots, version=1)
            shots['xG_v2'] = calculate_xg(shots, version=2)
            shots['xG_v3'] = calculate_xg(shots, version=3)

            # Count actual goals
            actual_goals = (shots['typeDescKey'] == 'goal').sum()

            # Sum xG
            xg_v1 = shots['xG_v1'].sum()
            xg_v2 = shots['xG_v2'].sum()
            xg_v3 = shots['xG_v3'].sum()

            results.append({
                'season': season,
                'total_shots': len(shots),
                'actual_goals': actual_goals,
                'xG_v1': xg_v1,
                'xG_v2': xg_v2,
                'xG_v3': xg_v3,
            })

            print(f"\n  Season {season}:")
            print(f"    Shots: {len(shots):,}")
            print(f"    Actual Goals: {actual_goals:,}")
            print(f"    xG v1: {xg_v1:,.1f} (diff: {actual_goals - xg_v1:+,.1f}, {(actual_goals - xg_v1)/actual_goals*100:+.2f}%)")
            print(f"    xG v2: {xg_v2:,.1f} (diff: {actual_goals - xg_v2:+,.1f}, {(actual_goals - xg_v2)/actual_goals*100:+.2f}%)")
            print(f"    xG v3: {xg_v3:,.1f} (diff: {actual_goals - xg_v3:+,.1f}, {(actual_goals - xg_v3)/actual_goals*100:+.2f}%)")
            print()

        except Exception as e:
            print(f"  Error loading {season}: {e}")
            continue

    # Print summary
    if results:
        print("\n" + "=" * 70)
        print("SUMMARY")
        print("=" * 70)

        total_shots = sum(r['total_shots'] for r in results)
        total_goals = sum(r['actual_goals'] for r in results)
        total_xg_v1 = sum(r['xG_v1'] for r in results)
        total_xg_v2 = sum(r['xG_v2'] for r in results)
        total_xg_v3 = sum(r['xG_v3'] for r in results)

        print(f"\nTotal Shots: {total_shots:,}")
        print(f"Total Goals: {total_goals:,}")
        print(f"\nxG v1: {total_xg_v1:,.1f} (diff: {total_goals - total_xg_v1:+,.1f}, {(total_goals - total_xg_v1)/total_goals*100:+.2f}%)")
        print(f"xG v2: {total_xg_v2:,.1f} (diff: {total_goals - total_xg_v2:+,.1f}, {(total_goals - total_xg_v2)/total_goals*100:+.2f}%)")
        print(f"xG v3: {total_xg_v3:,.1f} (diff: {total_goals - total_xg_v3:+,.1f}, {(total_goals - total_xg_v3)/total_goals*100:+.2f}%)")

        # Save to CSV
        pd.DataFrame(results).to_csv('calibration_results.csv', index=False)
        print("\nResults saved to calibration_results.csv")


if __name__ == '__main__':
    main()
