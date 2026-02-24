# Access the real-time ESPN injury reports

`espn_injuries()` retrieves the real-time ESPN injury reports as a
`data.frame` where each row represents team and includes detail on
availability status tracking for injuries or transactions.

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
