# Access the playoff schedule for a season and series

`series_schedule()` retrieves the playoff schedule for a season and
series as a `data.frame` where each row represents game and includes
detail on game timeline state, period/clock progression, and matchup
flow, date/season filtering windows and chronological context, and team
identity, affiliation, and matchup-side context.

## Usage

``` r
series_schedule(season = season_now() - 10001, series = "a")
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
