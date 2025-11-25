# Get ESPN information on transactions for an interval of dates

`get_espn_transactions()` retrieves ESPN information on each transaction
for an interval of dates bound by a given set of `start_date` and
`end_date`, including but not limited to their date, description, and
involved teams. Access
[`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
for `start_date` and `end_date` references. Note the date format differs
from the NHL API; will soon be fixed to accept both.

## Usage

``` r
get_espn_transactions(start_date = 20241004, end_date = 20250624)
```

## Arguments

- start_date:

  integer in YYYYMMDD (e.g., 20241004)

- end_date:

  integer in YYYYMMDD (e.g., 20250624)

## Value

data.frame with one row per transaction

## Examples

``` r
ESPN_transactio20242025 <- get_espn_transactions(
  start_date = 20241004, 
  end_date   = 20250624
)
```
