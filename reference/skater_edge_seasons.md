# Access the season(s) and game type(s) in which there exists skater EDGE statistics

`skater_edge_seasons()` returns the seasons and game type IDs for which
the NHL EDGE skater endpoints expose data.

## Usage

``` r
skater_edge_seasons()
```

## Value

data.frame with one row per season

## Examples

``` r
skater_EDGE_seasons <- skater_edge_seasons()
```
