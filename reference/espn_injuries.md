# Access the real-time ESPN injury reports

`espn_injuries()` scrapes the real-time ESPN injury reports for all the
teams.

## Usage

``` r
espn_injuries()
```

## Value

nested data.frame with one row per team (outer) and player (inner)

## Examples

``` r
ESPN_injuries_now <- espn_injuries()
```
