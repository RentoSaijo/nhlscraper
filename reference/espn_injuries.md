# Access the real-time ESPN injury reports

`espn_injuries()` returns ESPN's current injury report with one outer
row per team and nested player injury details where ESPN includes them.

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
