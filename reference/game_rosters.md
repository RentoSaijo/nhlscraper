# Access the game rosters for a season

`game_rosters()` downloads the stored season-level GameCenter roster
parquet snapshot with one row per dressed player per game.

## Usage

``` r
game_rosters(season = 20242025)
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per player per game

## Examples

``` r
# May take >5s, so skip.
game_rosters_20212022 <- game_rosters(season = 20212022)
```
