# Get the ESPN events for an interval of dates

`get_espn_events()` retrieves the ESPN ID for each event for an interval
of dates bound by a given set of `start_date` and `end_date`. Access
[`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
for `start_date` and `end_date` references. Note the date format differs
from the NHL API; will soon be fixed to accept both. Temporarily
deprecated while we re-evaluate the practicality of ESPN API
information. Use
[`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
instead.

## Usage

``` r
get_espn_events(start_date = 20241004, end_date = 20250624)
```

## Arguments

- start_date:

  integer in YYYYMMDD (e.g., 20241004)

- end_date:

  integer in YYYYMMDD (e.g., 20250624)

## Value

data.frame with one row per ESPN event

## Examples

``` r
ESPN_events_20242025 <- get_espn_events(
  start_date = 20241004, 
  end_date   = 20250624
)
#> Warning: `get_espn_events()` is temporarily deprecated. Re-evaluating the practicality of ESPN API inforamtion. Use `games()` instead.
```
