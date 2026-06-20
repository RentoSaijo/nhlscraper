# Access the shift chart for a game

`shift_chart()` returns one row per player shift for a game with
`gameId`, `teamId`, `playerId`, shift number, period, start/end clocks,
elapsed period/game seconds, and duration. It uses the stats API when
available and falls back to the NHL HTML shift reports for older or
missing games.

## Usage

``` r
shift_chart(game = 2023030417)
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

## Value

data.frame with one row per shift

## Examples

``` r
shifts_Martin_Necas_legacy_game <- shift_chart(game = 2025020275)
```
