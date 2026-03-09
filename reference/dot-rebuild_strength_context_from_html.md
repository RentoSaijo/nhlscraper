# Rebuild strength context from HTML on-ice players

`.rebuild_strength_context_from_html()` reconstructs
situation-code-derived strength columns from resolved home and away
on-ice goalie and skater IDs.

## Usage

``` r
.rebuild_strength_context_from_html(
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

  integer vector of home skater IDs

- away_skaters:

  integer vector of away skater IDs

## Value

data.frame with rebuilt strength context for the selected row
