# Access the ESPN transactions for a season

`espn_transactions()` pages ESPN's transaction feed across a season
window and returns one row per transaction with normalized team fields.

## Usage

``` r
espn_transactions(season = season_now())
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); the summer of the latter year is
  included

## Value

data.frame with one row per transaction

## Examples

``` r
ESPN_transactions_20242025 <- espn_transactions(season = 20242025)
```
