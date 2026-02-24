# Access the ESPN transactions for a season

`espn_transactions()` retrieves the ESPN transactions for a season as a
`data.frame` where each row represents transaction and includes detail
on availability and transaction-status tracking detail.

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
