# Access the shift chart time-on-ice summary for a game

`shift_chart_summary()` retrieves per-player, per-period time-on-ice
splits from the NHL HTML shift reports.

## Usage

``` r
shift_chart_summary(game = 2023030417)
```

## Arguments

- game:

  game ID

## Value

data.frame with one row per player per period

## Examples

``` r
shift_summary_2023030417 <- shift_chart_summary(game = 2023030417)
```
