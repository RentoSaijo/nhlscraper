# Assign scalar on-ice timing metrics

`.assign_on_ice_shift_metric()` copies goalie and skater timing matrices
into home, away, for, and against scalar play-by-play columns.

## Usage

``` r
.assign_on_ice_shift_metric(
  play_by_play,
  home_matrix,
  away_matrix,
  metric_suffix
)
```

## Arguments

- play_by_play:

  data.frame play-by-play object

- home_matrix:

  numeric matrix for home on-ice players

- away_matrix:

  numeric matrix for away on-ice players

- metric_suffix:

  scalar timing suffix

## Value

data.frame with timing columns assigned
