# Calculate shift times by situation from supplied data

`.calculate_shift_times_by_situation_data()` is an internal helper for
[`calculate_shift_times_by_situation()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_shift_times_by_situation.md).

## Usage

``` r
.calculate_shift_times_by_situation_data(
  play_by_play,
  shift_chart,
  roster = NULL
)
```

## Arguments

- play_by_play:

  data.frame play-by-play input

- shift_chart:

  data.frame shift-chart input

- roster:

  optional data.frame roster input

## Value

Internal helper output.
