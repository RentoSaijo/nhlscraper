# Add HTML-derived on-ice players to play-by-play

`.add_html_on_ice_players()` resolves HTML on-ice goalie and skater IDs,
matches them to API rows, and injects the resulting scalar on-ice
columns into play-by-play output.

## Usage

``` r
.add_html_on_ice_players(
  play_by_play,
  game,
  rosters = NULL,
  home_team = NULL,
  away_team = NULL
)
```

## Arguments

- play_by_play:

  data.frame play-by-play object

- game:

  game ID

- rosters:

  optional roster data.frame

- home_team:

  optional home-team metadata

- away_team:

  optional away-team metadata

## Value

data.frame enriched with HTML-derived on-ice columns
