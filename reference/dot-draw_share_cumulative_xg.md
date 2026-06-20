# Draw a shareable cumulative xG plot

`.draw_share_cumulative_xg()` renders a home/away cumulative
expected-goals time series.

## Usage

``` r
.draw_share_cumulative_xg(series, labels, plot_title)
```

## Arguments

- series:

  list returned by
  [`.share_cumulative_xg_series()`](https://rentosaijo.github.io/nhlscraper/reference/dot-share_cumulative_xg_series.md)

- labels:

  list returned by
  [`.share_game_labels()`](https://rentosaijo.github.io/nhlscraper/reference/dot-share_game_labels.md)

- plot_title:

  character scalar

## Value

`NULL`, invisibly
