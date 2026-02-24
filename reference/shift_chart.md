# Access the shift chart for a game

`shift_chart()` retrieves the shift chart for a game as a `data.frame`
where each row represents shift and includes detail on game timeline
state, period/clock progression, and matchup flow, date/season filtering
windows and chronological context, and team identity, affiliation, and
matchup-side context.

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
