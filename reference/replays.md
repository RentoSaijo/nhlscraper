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
#> Warning: downloaded length 0 != reported length 15
#> Warning: cannot open URL 'https://huggingface.co/datasets/RentoSaijo/NHL_DB/resolve/main/data/event/replays/NHL_REPLAYS_20232024.csv.gz': HTTP status was '404 Not Found'
#> Invalid argument(s); refer to help file.
```
