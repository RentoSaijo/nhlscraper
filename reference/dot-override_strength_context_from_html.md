# Override derived strength context from resolved on-ice players

`.override_strength_context_from_html()` updates the derived
strength/count columns from a resolved HTML on-ice signature while
leaving the raw `situationCode` column untouched.

## Usage

``` r
.override_strength_context_from_html(
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

data.frame with derived strength context updated for `idx`
