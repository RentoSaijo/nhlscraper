# Access the ESPN games for a season

`espn_games()` scrapes the ESPN games for a given `season`.

## Usage

``` r
espn_games(season = season_now())
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per ESPN game

## Examples

``` r
ESPN_games_20242025 <- espn_games(season = 20242025)
```
