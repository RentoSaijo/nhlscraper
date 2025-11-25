# Access the playoff schedule for a season and series

`series_schedule()` scrapes the playoff schedule for a given set of
`season` and `series`.

## Usage

``` r
series_schedule(season = season_now(), series = "a")
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

- series:

  one-letter code (e.g., 'O'); see
  [`series()`](https://rentosaijo.github.io/nhlscraper/reference/series.md)
  and/or
  [`bracket()`](https://rentosaijo.github.io/nhlscraper/reference/bracket.md)
  for reference

## Value

data.frame with one row per game

## Examples

``` r
SCF_schedule_20212022 <- series_schedule(
  season = 20212022, 
  series = 'O'
)
```
