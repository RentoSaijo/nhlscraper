# Access the raw World Showcase (WSC) play-by-plays for a season

`wsc_play_by_plays_raw()` loads the raw WSC play-by-plays for a given
`season`.

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
