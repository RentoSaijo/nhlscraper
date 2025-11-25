# Access the playoff bracket for a season

`get_bracket()` is deprecated. Use
[`bracket()`](https://rentosaijo.github.io/nhlscraper/reference/bracket.md)
instead.

## Usage

``` r
get_bracket(season = season_now())
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per series
