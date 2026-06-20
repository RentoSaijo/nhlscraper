# Access the replays for a season

`replays()` downloads the stored season-level puck/player tracking
parquet snapshot and returns one row per tracked decisecond.

## Usage

``` r
replays(season = 20242025)
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per decisecond

## Examples

``` r
# May take >5s, so skip.
replays_20252026 <- replays(season = 20252026)
```
