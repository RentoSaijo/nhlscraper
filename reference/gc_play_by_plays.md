# Access the GameCenter (GC) play-by-plays for a season

`gc_play_by_plays()` loads the GC play-by-plays for a given `season`.

## Usage

``` r
gc_play_by_plays(season = 20242025)

gc_pbps(season = 20242025)
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per event (play) per game

## Examples

``` r
# May take >5s, so skip.
gc_pbps_20212022 <- gc_play_by_plays(season = 20212022)
```
