# Access the season(s) and game type(s) in which there exists skater EDGE statistics

`skater_edge_seasons()` retrieves the season(s) and game type(s) in
which there exists skater EDGE statistics as a `data.frame` where each
row represents season and includes detail on date/season filtering
windows and chronological context plus NHL EDGE style tracking outputs
and relative-performance context.

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
