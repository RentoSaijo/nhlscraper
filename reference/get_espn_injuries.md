# Get the real-time ESPN injury reports

`get_espn_injuries()` retrieves real-time ESPN injury reports for all
the teams.

## Usage

``` r
get_espn_injuries()
```

## Value

nested data.frame with one row per team (outer) and player (inner)

## Examples

``` r
ESPN_injuries_now <- get_espn_injuries()
```
