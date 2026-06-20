# Access the raw World Showcase (WSC) play-by-plays for a season

`wsc_play_by_plays_raw()` downloads the stored season-level World
Showcase parquet snapshot and returns the raw rows without public-schema
cleanup or situation-code padding.

## Usage

``` r
wsc_play_by_plays_raw(season = 20242025)

wsc_pbps_raw(season = 20242025)
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per raw event (play) per game

## Examples

``` r
# May take >5s, so skip.
wsc_pbps_raw_20212022 <- wsc_play_by_plays_raw(season = 20212022)
```
