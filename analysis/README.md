# xG Model Analysis

This folder contains tools to analyze and visualize the calibration of the nhlscraper expected goals (xG) models.

## Quick Start

### View Visualizations (No Code Required)

Open these files in your browser:

| File | Description |
|------|-------------|
| `xg_deep_analysis.html` | **Main dashboard** - Calibration by feature, shot type analysis, recommendations |
| `xg_visualization.html` | Feature importance and model coefficients |

```bash
open xg_deep_analysis.html
```

---

## Key Findings

The xG model **overestimates goals by 22.5%** (predicts 31,578 vs actual 25,785).

### What's Broken

| Issue | Predicted | Actual | Error |
|-------|-----------|--------|-------|
| Empty Net | 82.2% | 13.6% | -68.7% |
| Penalty Kill | 20.6% | 8.4% | -12.2% |

### What Works Well

| Feature | Predicted | Actual | Error |
|---------|-----------|--------|-------|
| Even Strength | 4.5% | 4.4% | -0.1% |
| Power Play | 7.2% | 8.3% | +1.1% |
| 0-10ft Distance | 11.1% | 11.1% | 0.0% |

---

## Run Your Own Analysis

### 1. Calculate xG Calibration
```bash
pip install pandas numpy requests
python calculate_real_xg.py
```
Outputs total xG vs actual goals by season.

### 2. Deep Feature Analysis
```bash
python deep_xg_analysis.py
```
Outputs:
- `deep_analysis_results.json` - All calibration stats
- `shots_for_modeling.csv` - 500K+ shots with features for building your own model

---

## Files

| File | Purpose |
|------|---------|
| `xg_deep_analysis.html` | Interactive dashboard with real data |
| `xg_visualization.html` | Model coefficients and feature importance |
| `calculate_real_xg.py` | Calculate xG vs actual goals |
| `deep_xg_analysis.py` | Detailed feature-by-feature analysis |
| `xg_calibration.py` | Original calibration script |
| `shots_for_modeling.csv` | Raw shot data for building new models |
| `deep_analysis_results.json` | Calibration results in JSON |

---

## Building a Better Model

The `shots_for_modeling.csv` file contains all shots with:
- `distance`, `angle` - Spatial features
- `strengthState` - PP/PK/EV
- `isEmptyNetAgainst`, `isRebound`
- `shotType` - wrist, snap, slap, etc. (NOT in current model)
- `isGoal` - Target variable

### Quick Fix (Scale Factor)
Multiply all xG by **0.816** (25785/31578) to match actual goals.

### Retrain Model
```python
import pandas as pd
from sklearn.linear_model import LogisticRegression

shots = pd.read_csv('shots_for_modeling.csv')
X = shots[['distance', 'angle', 'isEmptyNetAgainst', 'isRebound']]
y = shots['isGoal']

model = LogisticRegression()
model.fit(X, y)
print(model.coef_)
```

---

## Data Source

All data is downloaded from HuggingFace:
```
https://huggingface.co/datasets/RentoSaijo/NHL_DB
```

Seasons available: 2019-2025
