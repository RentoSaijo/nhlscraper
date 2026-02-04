# Expected Goals (xG) Model Documentation

## Overview

This document provides a comprehensive breakdown of the expected goals (xG) models implemented in the `nhlscraper` R package. The models predict the probability that a shot attempt will result in a goal based on various spatial, situational, and contextual features.

**Important Note:** All three xG models in this repository are **logistic regression models** (not linear regression). They use the standard logistic function to convert a linear predictor into a probability between 0 and 1.

---

## Model Architecture

### Formula

All models use the **logistic regression formula**:

```
xG = 1 / (1 + exp(-lp))
```

Where `lp` (linear predictor) is:

```
lp = β₀ + β₁·distance + β₂·angle + β₃·emptyNet + β₄·penaltyKill + β₅·powerPlay + ...
```

### Model Files

| File | Purpose |
|------|---------|
| `R/Model.R` | Main xG calculation functions (lines 1-417) |
| `R/Clean.R` | Feature engineering functions (lines 1-564) |
| `R/Share.R` | Visualization functions (lines 1-852) |
| `vignettes/example.Rmd` | Full documentation and model building workflow |

---

## The Three Model Versions

### Model v1: Baseline (`calculate_expected_goals_v1`)
**Location:** `R/Model.R` lines 23-119

**Features (4 predictors):**
| Feature | Coefficient | Effect |
|---------|-------------|--------|
| Intercept | -1.8999656 | Baseline log-odds |
| `distance` | -0.0337112 | Farther shots = lower xG |
| `angle` | -0.0077118 | Sharper angles = lower xG |
| `isEmptyNetAgainst` | +4.3321873 | Empty net = much higher xG |
| `strengthState` (penalty-kill) | +0.6454842 | PK shots convert better |
| `strengthState` (power-play) | +0.4080557 | PP shots convert better |

---

### Model v2: Extended (`calculate_expected_goals_v2`)
**Location:** `R/Model.R` lines 150-260

**Additional Features (6 predictors):**
| Feature | Coefficient | Effect |
|---------|-------------|--------|
| All v1 features | (similar) | Same direction |
| `isRebound` | +0.4133378 | **Rebounds are dangerous!** |
| `isRush` | -0.0657790 | Rush shots slightly less efficient (marginal significance) |

---

### Model v3: Contextual (`calculate_expected_goals_v3`)
**Location:** `R/Model.R` lines 292-410

**Additional Features (7 predictors):**
| Feature | Coefficient | Effect |
|---------|-------------|--------|
| All v2 features | (similar) | Same direction |
| `goalDifferential` | +0.0424470 | Teams ahead convert at slightly higher rates |

---

## Feature Engineering Functions

### Currently Used Features

| Function | Location | Description | Definition |
|----------|----------|-------------|------------|
| `calculate_distance()` | `R/Clean.R:341-348` | Euclidean distance to net | `sqrt((89 - xCoordNorm)² + yCoordNorm²)` |
| `calculate_angle()` | `R/Clean.R:358-366` | Shot angle from center | `atan2(abs(yCoordNorm), 89 - xCoordNorm) × 180/π` |
| `flag_is_rush()` | `R/Clean.R:187-222` | Rush shot indicator | Shot within **4 seconds** of prior event in neutral/defensive zone |
| `flag_is_rebound()` | `R/Clean.R:232-276` | Rebound indicator | Shot within **3 seconds** of prior blocked/missed/saved shot |
| `strip_situation_code()` | `R/Clean.R:57-135` | Extracts strength state | Parses situationCode into empty net, skater counts, PP/PK/EV |
| `count_goals_shots()` | `R/Clean.R:376-423` | Goal differential | Running score differential from shooting team perspective |
| `normalize_coordinates()` | `R/Clean.R:289-330` | Standardize coordinates | All shots attacking toward +x direction |

### Feature Calculation Details

**Distance Formula:**
```r
net_x <- 89
distance <- sqrt((net_x - xCoordNorm)^2 + yCoordNorm^2)
```

**Angle Formula:**
```r
net_x <- 89
dx <- net_x - xCoordNorm
angle <- atan2(abs(yCoordNorm), dx) * 180 / pi
```

**Rebound Definition:**
- Shot taken within 3 seconds of prior shot attempt
- Same team
- No stoppage in between
- Excludes penalty shots and shootouts

**Rush Definition:**
- Shot taken within 4 seconds of prior event in neutral or defensive zone
- No stoppage in between
- Excludes penalty shots and shootouts

---

## Available But UNUSED NHL API Fields

The NHL API provides many additional fields that are **not currently used** in the xG models. These represent opportunities to build your own enhanced model:

### Shot-Specific Fields

| Field | Description | Potential Use |
|-------|-------------|---------------|
| **`shotType`** | Type of shot (wrist, slap, snap, backhand, tip-in, deflected, wrap-around, bat, poke, between-legs, cradle) | Different shot types have different conversion rates |
| `shootingPlayerId` | Player who took the shot | Player-specific shooting talent |
| `goalieInNetId` | Goalie facing the shot | Goalie-specific save ability |
| `blockingPlayerId` | Player who blocked (for blocked shots) | Could derive traffic/screening metrics |
| `reason` / `secondaryReason` | Why shot missed (wide-right, above-crossbar, etc.) | Shot quality indicators |

### Contextual Fields

| Field | Description | Potential Use |
|-------|-------------|---------------|
| `period` | Game period (1, 2, 3, OT) | Period effects on conversion |
| `secondsElapsedInPeriod` | Time within period | Late-period effects |
| `homeTeamDefendingSide` | Which side home defends | Rink effects |
| `assist1PlayerId` / `assist2PlayerId` | Players who assisted | Pass quality proxy |

### Game State Fields

| Field | Description | Potential Use |
|-------|-------------|---------------|
| `situationCode` (full) | 4-digit code for exact player counts | More granular than PP/PK/EV |
| `homeSkaterCount` / `awaySkaterCount` | Exact skater counts | 4v3, 5v3, 6v5, etc. |
| `awaySOG` / `homeSOG` | Running shot count | Game flow/momentum |

### NHL EDGE Data (Advanced)

The NHL EDGE system provides additional tracking data:

| Metric | Description |
|--------|-------------|
| Shot speed | Velocity of the shot |
| Skating speed | Player speed at shot time |
| Shot location details | More precise coordinates |

Access via: `skater_edge_summary()`, `goalie_edge_summary()`

---

## Excluded Situations

The models explicitly exclude:
- **Shootouts** (situationCode = '0101')
- **Penalty shots** (situationCode = '1010')

These are excluded because they represent fundamentally different shooting situations with predetermined 1-on-1 scenarios.

---

## Visualizations

### Shot Location Plot
**Functions:** `ig_game_shot_locations()`, `x_game_shot_locations()`
**Location:** `R/Share.R:23-453`

Features:
- Marker shape encodes outcome (goal, SOG, missed, blocked)
- Color encodes xG value (blue = low danger, red = high danger)
- Coordinates normalized so team always attacks right
- Supports all 3 model versions

**Example:**
```r
ig_game_shot_locations(
  game  = 2023030417,  # Game 7 Stanley Cup Finals 2025
  model = 1,
  team  = 'home'
)
```

### Cumulative xG Over Time
**Functions:** `ig_game_cumulative_expected_goals()`, `x_game_cumulative_expected_goals()`
**Location:** `R/Share.R:455-852`

Features:
- X-axis: Seconds elapsed in game
- Y-axis: Cumulative xG for each team
- Shows "deserve-to-win-o-meter" view
- Tick marks every 600 seconds (10 minutes)

**Example:**
```r
ig_game_cumulative_expected_goals(
  game  = 2023030417,
  model = 1
)
```

---

## Building Your Own xG Model

### Recommended Additional Features to Try

1. **Shot Type** - The `shotType` field is available but unused
   - Wrist shots: most common
   - Snap shots: higher conversion (~9%)
   - Slap shots: lower conversion (~5%)
   - Tip-ins/deflections: often high-danger

2. **Shooter Quality** - Use `shootingPlayerId` to add shooter fixed effects or career shooting percentage

3. **Goalie Quality** - Use `goalieInNetId` to add goalie fixed effects or save percentage

4. **Time Effects** - Add period number, time remaining, or overtime indicators

5. **Specific Manpower** - Instead of PP/PK binary, use exact skater counts (5v4, 5v3, 4v4, etc.)

6. **Pre-shot Events** - Sequence features like:
   - Faceoff win leading to shot
   - Giveaway/takeaway before shot
   - Time since last stoppage

7. **Traffic/Screens** - Derive from blocked shot data or on-ice player positions

### Sample Model Extension Code

```r
# Load and clean data
gc_pbps <- nhlscraper::gc_pbps(20242025)
gc_pbps <- nhlscraper::flag_is_home(gc_pbps)
# ... other cleaning steps ...

# Keep shots and add binary outcome
shots <- gc_pbps[gc_pbps$typeDescKey %in%
  c('goal', 'shot-on-goal', 'missed-shot', 'blocked-shot'), ]
shots <- shots[!(shots$situationCode %in% c('0101', '1010')), ]
shots$isGoal <- as.integer(shots$typeDescKey == 'goal')

# Build enhanced model with shot type
xG_enhanced <- glm(
  isGoal ~
    distance +
    angle +
    isEmptyNetAgainst +
    strengthState +
    isRebound +
    isRush +
    goalDifferential +
    shotType,  # NEW FEATURE
  family = binomial,
  data   = shots
)

summary(xG_enhanced)
```

---

## Key Insights from Current Models

1. **Empty net is the biggest factor** - Coefficient ~4.2-4.3 means dramatic increase in xG
2. **Distance and angle are fundamental** - Closer, more central shots are much more dangerous
3. **Rebounds are high-danger** - +0.41 coefficient shows rebounds convert at higher rates
4. **Rush shots are NOT more efficient** - Slightly negative coefficient when controlling for location
5. **Score effects are modest** - Goal differential adds information but spatial features dominate

---

## API References

- NHL GameCenter API: `https://api-web.nhle.com/v1/gamecenter/{game-id}/play-by-play`
- NHL Stats API: `https://api.nhle.com/stats/rest/`
- [NHL API Reference (Unofficial)](https://github.com/Zmalski/NHL-API-Reference)

---

## Summary

The current `nhlscraper` xG models are intentionally simple logistic regressions using 4-7 features. This makes them interpretable and fast to compute, but leaves significant room for improvement by incorporating additional available features like shot type, shooter/goalie identity, and more granular game state information.
