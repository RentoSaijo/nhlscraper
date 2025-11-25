# Get the odds of an ESPN event

`get_espn_event_odds()` retrieves information on each provider for a
given `event`, including but not limited to its name, favorite and
underdog teams, and money-line and spread odds. Access
[`get_espn_events()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_events.md)
for `event` reference.

## Usage

``` r
get_espn_event_odds(event = 401687600)
```

## Arguments

- event:

  integer ESPN Event ID (e.g., 401687600)

## Value

data.frame with one row per provider

## Examples

``` r
NJD_BUF_2024_10_04_odds <- get_espn_event_odds(event=401687600)
```
