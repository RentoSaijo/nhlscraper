# Access the playoff bracket for a season

`bracket()` retrieves the playoff bracket for a season as a `data.frame`
where each row represents series and includes detail on team identity,
affiliation, and matchup-side context.

## Usage

``` r
bracket(season = season_now())
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per series

## Examples

``` r
bracket_20242025 <- bracket(season = 20242025)
```
