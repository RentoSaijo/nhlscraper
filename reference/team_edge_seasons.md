# Access the season(s) and game type(s) in which there exists team EDGE statistics

`team_edge_seasons()` returns the seasons and game type IDs for which
the NHL EDGE team endpoints expose data.

## Usage

``` r
team_edge_seasons()
```

## Value

data.frame with one row per season

## Examples

``` r
team_EDGE_seasons <- team_edge_seasons()
```
