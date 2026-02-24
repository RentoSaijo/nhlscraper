# Access the season(s) and game type(s) in which there exists team EDGE statistics

`team_edge_seasons()` retrieves the season(s) and game type(s) in which
there exists team EDGE statistics as a `data.frame` where each row
represents season and includes detail on date/season filtering windows
and chronological context plus NHL EDGE style tracking outputs and
relative-performance context.

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
