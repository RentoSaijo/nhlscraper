[![CRAN Status](https://www.r-pkg.org/badges/version/nhlscraper)](https://CRAN.R-project.org/package=nhlscraper)
[![Dev Version](https://img.shields.io/badge/dev%20ver-0.1.1.9000-red.svg)](https://github.com/nhlscraper)
[![Downloads](https://cranlogs.r-pkg.org/badges/grand-total/nhlscraper)

# nhlscraper: Scraper for National Hockey League (NHL) Data

## Overview
nhlscraper is a CRAN-approved R-package for scraping NHL data using the NHL API. It primarily wraps [endpoints documented by Zach Maludzinski](https://github.com/Zmalski/NHL-API-Reference). It covers data from high-level multi-season summaries to low-level play-by-play logs. Since the API endpoints got reworked in 2023, many of the earlier scrapers became deprecated; this one should be updated for the new endpoints.

## Prerequisite

- R/RStudio; you can check out my [tutorial](https://youtu.be/hGM1t6usDQ8) if you are not familiar!

## Installation
Install the official version from [CRAN](https://cran.r-project.org) with:
```
install.packages('nhlscraper')
```

Install the development version from [GitHub](https://github.com/) with:
```
install.packages('devtools')
devtools::install_github('RentoSaijo/nhlscraper')
```

## Example
Below are basic examples that show you how to use some of the functions.

### Setup
```
library(nhlscraper)
```

### League Data
```
schedule_2025_01_02 <- get_schedule(date='2025-01-02')
standings_2025_01_02 <- get_standings(date='2025-01-02')
```

### Team Data
```
COL_seasons <- get_team_seasons(team='COL')
playoff_team_stf_20242025 <- get_team_statistics(
  season=20242025,
  report='scoretrailfirst',
  game_types=c(3)
)
COL_defensemen_20242025 <- get_team_roster(
  team='COL',
  season=20242025,
  player_type='defensemen'
)
regular_COL_goalies_statistics_20242025 <- get_team_roster_statistics(
  team='COL',
  season=20242025,
  game_type=2,
  player_type='goalies'
)
COL_defensemen_prospects <- get_team_prospects(
  team='COL',
  player_type='defensemen'
)
COL_schedule_20242025 <- get_team_schedule(team='COL', season=20242025)
```

### Player Data
```
playoff_Mikko_Rantanen_gl_20242025 <- get_player_game_log(
  player=8478420,
  season=20242025,
  game_type=3
)
Mikko_Rantanen_landing <- get_player_landing(player=8478420)
spotlight_players_now <- get_spotlight_players()
```

### Skater Data
```
skaters_2000s <- get_skaters(start_season=20002001, end_season=20242025)
regular_skater_shootout_20242025 <- get_skater_statistics(
  season=20242025,
  report='shootout',
  game_types=c(2)
)
playoff_toi_leaders_20242025 <- get_skater_leaders(
  season=20242025,
  game_type=3,
  category='toi'
)
skater_milestones <- get_skater_milestones()
```

### Goalie Data
```
goalies_2000s <- get_goalies(start_season=20002001, end_season=20242025)
playoff_goalie_svr_20242025 <- get_goalie_statistics(
  season=20242025,
  report='startedVsRelieved',
  game_types=c(3)
)
playoff_savePctg_leaders_20242025 <- get_goalie_leaders(
  season=20242025,
  game_type=3,
  category='savePctg'
)
goalie_milestones <- get_goalie_milestones()
```

### Game Data
```
scores_2025_01_02 <- get_scores(date='2025-01-02')
boxscore_2024030411_FLA_defensemen <- get_game_boxscore(
  game=2024030411,
  team='away',
  player_type='defense'
)
gc_pbp_2024030411 <- get_gc_play_by_play(game=2024030411)
shift_charts_2024030411 <- get_shift_charts(game=2024030411)
game_story_2024030411 <- get_game_story(game=2024030411)
```

### Playoff Data
```
bracket_2025 <- get_playoff_bracket(year=2025)
COL_DAL_schedule_20242025 <- get_series_schedule(season=20242025, series='f')
carousel_20242025_2 <- get_series_carousel(season=20242025, round=2)
```

### Draft Data
```
draft_picks_2024 <- get_draft_picks(year=2024, round='all')
draft_rankings_2025 <- get_draft_rankings(year=2025)
```

### Other Data
```
tv_schedule_2025_01_02 <- get_tv_schedule(date='2025-01-02')
partner_odds_now_CA <- get_partner_odds(country='CA')
```
