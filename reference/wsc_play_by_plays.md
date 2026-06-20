# Access the World Showcase (WSC) play-by-plays for a season

`wsc_play_by_plays()` downloads the cleaned season-level World Showcase
parquet snapshot and pads `situationCode` to the four-character public
format.

## Usage

``` r
wsc_play_by_plays(season = 20242025)

wsc_pbps(season = 20242025)
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
wsc_pbps_20212022 <- wsc_play_by_plays(season = 20212022)
```
