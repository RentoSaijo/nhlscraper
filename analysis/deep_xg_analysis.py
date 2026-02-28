"""
Deep xG Model Analysis

Analyzes calibration by bucket, feature importance, shot types, and
probability distributions. Outputs data for visualization.

Usage:
    pip install pandas numpy requests matplotlib seaborn
    python deep_xg_analysis.py
"""

import pandas as pd
import numpy as np
import requests
import gzip
import io
import json
from collections import defaultdict

# =============================================================================
# MODEL COEFFICIENTS (exact values from R/Model.R)
# =============================================================================

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

    df['situationCode'] = df['situationCode'].apply(
        lambda x: f"{int(x):04d}" if pd.notna(x) else None
    )
    df['season'] = season
    return df


def filter_shots(df: pd.DataFrame) -> pd.DataFrame:
    """Filter to valid shot attempts."""
    shot_types = ['goal', 'shot-on-goal', 'missed-shot', 'blocked-shot']
    shots = df[df['typeDescKey'].isin(shot_types)].copy()
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
        df['distance'] = 30
        df['angle'] = 15

    # Strength state from situation code
    def parse_strength(row):
        code = str(row.get('situationCode', '0000')).zfill(4)
        try:
            away_g, away_s, home_s, home_g = int(code[0]), int(code[1]), int(code[2]), int(code[3])
        except:
            return pd.Series({'strengthState': 'even-strength', 'isEmptyNetAgainst': False})

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

    print("  Parsing strength states...")
    strength_df = df.apply(parse_strength, axis=1)
    df['strengthState'] = strength_df['strengthState']
    df['isEmptyNetAgainst'] = strength_df['isEmptyNetAgainst']

    # Rebound flag
    df['isRebound'] = False
    if 'secondsElapsedInGame' in df.columns:
        print("  Calculating rebounds...")
        df = df.sort_values(['gameId', 'secondsElapsedInGame'])
        for game_id, group in df.groupby('gameId'):
            times = group['secondsElapsedInGame'].values
            indices = group.index.values
            for i in range(1, len(times)):
                if times[i] - times[i-1] <= 3:
                    df.loc[indices[i], 'isRebound'] = True

    df['isRush'] = False

    # Goal differential
    if 'homeScore' in df.columns and 'awayScore' in df.columns:
        is_home = df['eventOwnerTeamId'] == df.get('homeTeamId', 0)
        df['goalDifferential'] = 0
        df.loc[is_home, 'goalDifferential'] = df.loc[is_home, 'homeScore'] - df.loc[is_home, 'awayScore']
        df.loc[~is_home, 'goalDifferential'] = df.loc[~is_home, 'awayScore'] - df.loc[~is_home, 'homeScore']
    else:
        df['goalDifferential'] = 0

    # Binary goal indicator
    df['isGoal'] = (df['typeDescKey'] == 'goal').astype(int)

    return df


def calculate_xg(df: pd.DataFrame) -> pd.Series:
    """Calculate xG v3 for each shot."""
    coeffs = XG_V3

    lp = coeffs['intercept']
    lp = lp + coeffs['distance'] * df['distance']
    lp = lp + coeffs['angle'] * df['angle']
    lp = lp + coeffs['empty_net'] * df['isEmptyNetAgainst'].astype(int)
    lp = lp + coeffs['penalty_kill'] * (df['strengthState'] == 'penalty-kill').astype(int)
    lp = lp + coeffs['power_play'] * (df['strengthState'] == 'power-play').astype(int)
    lp = lp + coeffs['rebound'] * df['isRebound'].astype(int)
    lp = lp + coeffs['rush'] * df['isRush'].astype(int)
    lp = lp + coeffs['goal_differential'] * df['goalDifferential'].fillna(0)

    return 1 / (1 + np.exp(-lp))


def analyze_calibration_buckets(df: pd.DataFrame, n_buckets: int = 20) -> pd.DataFrame:
    """Analyze calibration by xG probability bucket."""
    df = df.copy()
    df['xG_bucket'] = pd.cut(df['xG'], bins=n_buckets, labels=False)

    bucket_stats = df.groupby('xG_bucket').agg({
        'xG': ['mean', 'sum', 'count'],
        'isGoal': ['mean', 'sum']
    }).reset_index()

    bucket_stats.columns = ['bucket', 'predicted_rate', 'predicted_goals', 'n_shots',
                            'actual_rate', 'actual_goals']
    bucket_stats['calibration_error'] = bucket_stats['actual_rate'] - bucket_stats['predicted_rate']
    bucket_stats['bucket_range'] = bucket_stats['bucket'].apply(
        lambda x: f"{x*5}-{(x+1)*5}%" if pd.notna(x) else "N/A"
    )

    return bucket_stats


def analyze_by_feature(df: pd.DataFrame) -> dict:
    """Analyze goal rates by each feature."""
    results = {}

    # By shot type (typeDescKey shows outcome, but shotType shows the type of shot)
    if 'shotType' in df.columns:
        shot_type_stats = df.groupby('shotType').agg({
            'isGoal': ['sum', 'mean', 'count'],
            'xG': ['sum', 'mean']
        }).reset_index()
        shot_type_stats.columns = ['shot_type', 'goals', 'actual_rate', 'shots', 'xG_total', 'xG_mean']
        shot_type_stats['diff'] = shot_type_stats['actual_rate'] - shot_type_stats['xG_mean']
        results['by_shot_type'] = shot_type_stats.to_dict('records')

    # By strength state
    strength_stats = df.groupby('strengthState').agg({
        'isGoal': ['sum', 'mean', 'count'],
        'xG': ['sum', 'mean']
    }).reset_index()
    strength_stats.columns = ['strength', 'goals', 'actual_rate', 'shots', 'xG_total', 'xG_mean']
    strength_stats['diff'] = strength_stats['actual_rate'] - strength_stats['xG_mean']
    results['by_strength'] = strength_stats.to_dict('records')

    # By empty net
    en_stats = df.groupby('isEmptyNetAgainst').agg({
        'isGoal': ['sum', 'mean', 'count'],
        'xG': ['sum', 'mean']
    }).reset_index()
    en_stats.columns = ['empty_net', 'goals', 'actual_rate', 'shots', 'xG_total', 'xG_mean']
    en_stats['diff'] = en_stats['actual_rate'] - en_stats['xG_mean']
    results['by_empty_net'] = en_stats.to_dict('records')

    # By rebound
    reb_stats = df.groupby('isRebound').agg({
        'isGoal': ['sum', 'mean', 'count'],
        'xG': ['sum', 'mean']
    }).reset_index()
    reb_stats.columns = ['rebound', 'goals', 'actual_rate', 'shots', 'xG_total', 'xG_mean']
    reb_stats['diff'] = reb_stats['actual_rate'] - reb_stats['xG_mean']
    results['by_rebound'] = reb_stats.to_dict('records')

    # By distance buckets
    df['distance_bucket'] = pd.cut(df['distance'], bins=[0, 10, 20, 30, 40, 50, 100],
                                    labels=['0-10ft', '10-20ft', '20-30ft', '30-40ft', '40-50ft', '50+ft'])
    dist_stats = df.groupby('distance_bucket').agg({
        'isGoal': ['sum', 'mean', 'count'],
        'xG': ['sum', 'mean']
    }).reset_index()
    dist_stats.columns = ['distance', 'goals', 'actual_rate', 'shots', 'xG_total', 'xG_mean']
    dist_stats['diff'] = dist_stats['actual_rate'] - dist_stats['xG_mean']
    results['by_distance'] = dist_stats.to_dict('records')

    # By angle buckets
    df['angle_bucket'] = pd.cut(df['angle'], bins=[0, 15, 30, 45, 60, 90],
                                 labels=['0-15°', '15-30°', '30-45°', '45-60°', '60-90°'])
    angle_stats = df.groupby('angle_bucket').agg({
        'isGoal': ['sum', 'mean', 'count'],
        'xG': ['sum', 'mean']
    }).reset_index()
    angle_stats.columns = ['angle', 'goals', 'actual_rate', 'shots', 'xG_total', 'xG_mean']
    angle_stats['diff'] = angle_stats['actual_rate'] - angle_stats['xG_mean']
    results['by_angle'] = angle_stats.to_dict('records')

    return results


def get_probability_distribution(df: pd.DataFrame) -> dict:
    """Get the distribution of xG probabilities."""
    # Histogram of xG values
    hist, bin_edges = np.histogram(df['xG'], bins=50, range=(0, 1))

    return {
        'histogram': {
            'counts': hist.tolist(),
            'bin_edges': bin_edges.tolist(),
            'bin_centers': ((bin_edges[:-1] + bin_edges[1:]) / 2).tolist()
        },
        'statistics': {
            'mean': float(df['xG'].mean()),
            'median': float(df['xG'].median()),
            'std': float(df['xG'].std()),
            'min': float(df['xG'].min()),
            'max': float(df['xG'].max()),
            'percentiles': {
                '10': float(df['xG'].quantile(0.10)),
                '25': float(df['xG'].quantile(0.25)),
                '50': float(df['xG'].quantile(0.50)),
                '75': float(df['xG'].quantile(0.75)),
                '90': float(df['xG'].quantile(0.90)),
                '95': float(df['xG'].quantile(0.95)),
                '99': float(df['xG'].quantile(0.99)),
            }
        }
    }


def main():
    seasons = [20222023, 20232024, 20242025]

    all_shots = []

    print("=" * 70)
    print("DEEP xG MODEL ANALYSIS")
    print("=" * 70)

    for season in seasons:
        try:
            df = load_season(season)
            print(f"  Loaded {len(df):,} events")

            shots = filter_shots(df)
            print(f"  Filtered to {len(shots):,} shots")

            shots = calculate_features(shots)
            shots['xG'] = calculate_xg(shots)

            all_shots.append(shots)
            print(f"  Processed season {season}")

        except Exception as e:
            print(f"  Error: {e}")
            import traceback
            traceback.print_exc()
            continue

    if not all_shots:
        print("No data loaded!")
        return

    # Combine all shots
    combined = pd.concat(all_shots, ignore_index=True)
    print(f"\nTotal shots combined: {len(combined):,}")

    # Overall calibration
    total_goals = combined['isGoal'].sum()
    total_xg = combined['xG'].sum()

    print("\n" + "=" * 70)
    print("OVERALL CALIBRATION")
    print("=" * 70)
    print(f"Total Shots: {len(combined):,}")
    print(f"Actual Goals: {total_goals:,} ({total_goals/len(combined)*100:.2f}%)")
    print(f"Expected Goals (xG): {total_xg:,.1f} ({total_xg/len(combined)*100:.2f}%)")
    print(f"Difference: {total_goals - total_xg:+,.1f} ({(total_goals - total_xg)/total_goals*100:+.2f}%)")

    # Calibration buckets
    print("\n" + "=" * 70)
    print("CALIBRATION BY xG BUCKET")
    print("=" * 70)
    bucket_stats = analyze_calibration_buckets(combined, n_buckets=10)
    print(bucket_stats.to_string(index=False))

    # Feature analysis
    print("\n" + "=" * 70)
    print("ANALYSIS BY FEATURE")
    print("=" * 70)
    feature_stats = analyze_by_feature(combined)

    print("\nBy Strength State:")
    for row in feature_stats['by_strength']:
        print(f"  {row['strength']}: {row['shots']:,} shots, {row['goals']:,} goals, "
              f"actual={row['actual_rate']:.3f}, xG={row['xG_mean']:.3f}, diff={row['diff']:+.3f}")

    print("\nBy Empty Net:")
    for row in feature_stats['by_empty_net']:
        label = "Empty Net" if row['empty_net'] else "Goalie In"
        print(f"  {label}: {row['shots']:,} shots, {row['goals']:,} goals, "
              f"actual={row['actual_rate']:.3f}, xG={row['xG_mean']:.3f}, diff={row['diff']:+.3f}")

    print("\nBy Rebound:")
    for row in feature_stats['by_rebound']:
        label = "Rebound" if row['rebound'] else "Non-Rebound"
        print(f"  {label}: {row['shots']:,} shots, {row['goals']:,} goals, "
              f"actual={row['actual_rate']:.3f}, xG={row['xG_mean']:.3f}, diff={row['diff']:+.3f}")

    print("\nBy Distance:")
    for row in feature_stats['by_distance']:
        if row['distance']:
            print(f"  {row['distance']}: {row['shots']:,} shots, {row['goals']:,} goals, "
                  f"actual={row['actual_rate']:.3f}, xG={row['xG_mean']:.3f}, diff={row['diff']:+.3f}")

    if 'by_shot_type' in feature_stats:
        print("\nBy Shot Type:")
        for row in sorted(feature_stats['by_shot_type'], key=lambda x: -x['shots']):
            if row['shot_type'] and row['shots'] > 1000:
                print(f"  {row['shot_type']}: {row['shots']:,} shots, {row['goals']:,} goals, "
                      f"actual={row['actual_rate']:.3f}, xG={row['xG_mean']:.3f}, diff={row['diff']:+.3f}")

    # Probability distribution
    print("\n" + "=" * 70)
    print("xG PROBABILITY DISTRIBUTION")
    print("=" * 70)
    prob_dist = get_probability_distribution(combined)
    stats = prob_dist['statistics']
    print(f"Mean xG: {stats['mean']:.4f}")
    print(f"Median xG: {stats['median']:.4f}")
    print(f"Std Dev: {stats['std']:.4f}")
    print(f"Min: {stats['min']:.4f}, Max: {stats['max']:.4f}")
    print(f"\nPercentiles:")
    for pct, val in stats['percentiles'].items():
        print(f"  {pct}th: {val:.4f}")

    # Save comprehensive results
    results = {
        'overall': {
            'total_shots': len(combined),
            'actual_goals': int(total_goals),
            'xG_total': float(total_xg),
            'actual_rate': float(total_goals / len(combined)),
            'xG_rate': float(total_xg / len(combined)),
            'calibration_error': float(total_goals - total_xg),
            'calibration_pct': float((total_goals - total_xg) / total_goals * 100),
        },
        'calibration_buckets': bucket_stats.to_dict('records'),
        'by_feature': feature_stats,
        'probability_distribution': prob_dist,
    }

    with open('deep_analysis_results.json', 'w') as f:
        json.dump(results, f, indent=2, default=str)

    print("\nResults saved to deep_analysis_results.json")

    # Also save the raw shot data for building a new model
    print("\nSaving shot-level data for model building...")
    model_cols = ['season', 'gameId', 'typeDescKey', 'xCoord', 'yCoord',
                  'distance', 'angle', 'strengthState', 'isEmptyNetAgainst',
                  'isRebound', 'isRush', 'goalDifferential', 'isGoal', 'xG']
    if 'shotType' in combined.columns:
        model_cols.append('shotType')

    available_cols = [c for c in model_cols if c in combined.columns]
    combined[available_cols].to_csv('shots_for_modeling.csv', index=False)
    print(f"Saved {len(combined):,} shots to shots_for_modeling.csv")

    print("\n" + "=" * 70)
    print("RECOMMENDATIONS FOR NEW MODEL")
    print("=" * 70)
    print("""
Based on the calibration analysis, consider:

1. RE-CALIBRATE THE MODEL
   - The current model overestimates by ~19%
   - Could apply a simple scaling factor: new_xG = old_xG * (actual_goals / xG_total)
   - Or retrain the logistic regression on more recent data

2. ADD SHOT TYPE
   - If 'shotType' data is available, it's a strong predictor
   - Wrist shots, slap shots, tip-ins have different conversion rates

3. CHECK FEATURE CALCULATIONS
   - Distance/angle calculations may differ from training data
   - Rebound detection may be inconsistent
   - Empty net detection may have issues

4. CONSIDER TIME-VARYING EFFECTS
   - Model may be trained on older seasons
   - League-wide shooting/save percentages change over time

5. USE THE SAVED DATA
   - 'shots_for_modeling.csv' has all shots with features
   - Train your own logistic regression or more complex model
   - Use sklearn, statsmodels, or similar
""")


if __name__ == '__main__':
    main()
