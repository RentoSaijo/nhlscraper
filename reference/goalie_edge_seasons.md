# Access the season(s) and game type(s) in which there exists goalie EDGE statistics

`goalie_edge_seasons()` returns the seasons and game type IDs for which
the NHL EDGE goalie endpoints expose data.

## Usage

``` r
goalie_edge_seasons()
```

## Value

data.frame with one row per season

## Examples

``` r
goalie_EDGE_seasons <- goalie_edge_seasons()
```
