# Access the season(s) and game type(s) in which there exists goalie EDGE statistics

`goalie_edge_seasons()` retrieves the season(s) and game type(s) in
which there exists goalie EDGE statistics as a `data.frame` where each
row represents season and includes detail on date/season filtering
windows and chronological context plus NHL EDGE style tracking outputs
and relative-performance context.

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
