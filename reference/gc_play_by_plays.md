# Access the GameCenter (GC) play-by-plays for a season

`gc_play_by_plays()` downloads the cleaned season-level GameCenter
parquet snapshot and pads `situationCode` to the four-character public
format. For `blocked-shot` rows, `xCoord`, `yCoord`, `xCoordNorm`,
`yCoordNorm`, `distance`, and `angle` describe the recorded block
location, not the original shot-release location.

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
