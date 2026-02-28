# Access the replays for a season

`replays()` loads the replays for a given `season`.

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
replays_20232024 <- replays(season = 20232024)
```
