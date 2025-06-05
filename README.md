# nhlscraper: Scraper for NHL Data

## Overview
NHLScraper is a public scraper for NHL data on R; with this, you will have relatively easy access to all sorts of data from high-level multi-season statistics to low-level play-by-play statistics.

## Installation
You can install the development version of NHLScraper from GitHub with:
```
#install.packages('devtools')
devtools::install_github('RentoSaijo/nhlscraper')
```
I am submitting it to CRAN soon.

## Example
Below are basic examples that show you how to use some of the functions.

### League Data
```
standings_2025_01_01 <- get_standings()
schedule_2025_01_01 <- get_schedule()
```

### Team Data
```
COL_seasons <- get_team_seasons(team='COL')
COL_skater_statistics_20242025 <- get_team_roster_statistics(
  team='COL',
  season=20242025,
)
COL_defensemen_20242025 <- get_team_roster(
  team='COL',
  season=20242025,
  player_type='defensemen'
)
COL_goalie_prospects <- get_team_prospects(
  team='COL',
  player_type='goalies'
)
COL_schedule_20242025 <- get_team_schedule(
  team='COL',
  season=20242025
)
playoff_team_statistics_20242025 <- get_team_statistics(
  season=20242025,
  is_aggregate=T,
  game_types=c(3)
)
```

### Player Data
```
Martin_Necas_game_log_20242025 <- get_player_game_log(season=20242025)
Martin_Necas_landing <- get_player_landing()
spotlight_players <- get_spotlight_players()
```

### Skater Data
```
skaters_20242025 <- get_skaters(
  start_season=20242025, end_season=20242025
)
playoff_toi_leaders_20242025 <- get_skater_leaders(
  season=20242025, category='toi'
)
skater_milestones <- get_skater_milestones()
playoff_skater_statistics_20242025 <- get_skater_statistics(
  season=20242025,
  is_game=T,
  dates=c('2025-05-21', '2025-05-22', '2025-05-23', '2025-05-24', '2025-05-25'),
  game_types=c(3)
)
```

### Goalie Data
```
goalies_20242025 <- get_goalies(
  start_season=20242025, end_season=20242025
)
playoff_savePctg_leaders_20242025 <- get_goalie_leaders(
  season=20242025, category='savePctg'
)
goalie_milestones <- get_goalie_milestones()
playoff_goalie_statistics_20242025 <- get_goalie_statistics(
  season=20242025,
  is_game=T,
  dates=c('2025-05-21', '2025-05-22', '2025-05-23', '2025-05-24', '2025-05-25'),
  game_types=c(3)
)
```

### Game Data
```
scores_2025_01_01 <- get_scores()
gc_pbp_2024020602 <- get_gc_play_by_play()
boxscore_2024020602 <- get_game_boxscore()
game_story_2024020602 <- get_game_story()
shift_charts_2024020602 <- get_shift_charts()
```

### Playoff Data
```
series_carousel_20242025_1 <- get_series_carousel(season=20242025)
playoff_schedule_TOR_OTT_20242025 <- get_series_schedule(season=20242025)
playoff_bracket_2025 <- get_playoff_bracket(year=2025)
```

### Draft Data
```
draft_rankings_2025 <- get_draft_rankings(year=2025)
draft_picks_2024 <- get_draft_picks(year=2024, round='all')
```

### Other Data
```
tv_schedule_2025_01_01 <- get_tv_schedule()
partner_odds_latest <- get_partner_odds()
```
