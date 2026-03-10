# Assign resolved HTML on-ice IDs to scalar columns

`.assign_html_on_ice_player_ids()` copies resolved HTML goalie and
skater IDs into the public scalar on-ice player-ID columns for one
play-by-play row.

## Usage

``` r
.assign_html_on_ice_player_ids(
  play_by_play,
  idx,
  home_goalie,
  away_goalie,
  home_skaters,
  away_skaters
)
```

## Arguments

- play_by_play:

  data.frame play-by-play object

- idx:

  row index to update

- home_goalie:

  resolved home goalie player ID

- away_goalie:

  resolved away goalie player ID

- home_skaters:

  integer vector of resolved home skater IDs

- away_skaters:

  integer vector of resolved away skater IDs

## Value

data.frame with scalar on-ice player-ID columns assigned for `idx`
