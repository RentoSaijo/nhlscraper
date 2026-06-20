# Draw a shareable shot-location plot

`.draw_share_shot_locations()` renders one team's shot attempts on the
NHL rink with outcome symbols and xG color.

## Usage

``` r
.draw_share_shot_locations(shots, plot_title, spec)
```

## Arguments

- shots:

  data.frame of team-filtered shot attempts

- plot_title:

  character scalar

- spec:

  list returned by
  [`.share_plot_spec()`](https://rentosaijo.github.io/nhlscraper/reference/dot-share_plot_spec.md)

## Value

`NULL`, invisibly
