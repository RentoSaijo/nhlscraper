# Get all the ESPN athletes

`get_espn_athletes()` retrieves the ESPN ID for each athlete.
Temporarily deprecated while we re-evaluate the practicality of ESPN API
information. Use
[`players()`](https://rentosaijo.github.io/nhlscraper/reference/players.md)
instead.

## Usage

``` r
get_espn_athletes()
```

## Value

data.frame with one row per athlete

## Examples

``` r
all_ESPN_athletes <- get_espn_athletes()
#> Warning: `get_espn_athletes()` is temporarily deprecated. Re-evaluating the practicality of ESPN API inforamtion. Use `players()` instead.
```
