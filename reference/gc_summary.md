# Access the GameCenter (GC) summary for a game

`gc_summary()` retrieves the GameCenter (GC) summary for a game as a
nested `list` that separates summary and detail blocks for game timeline
state, period/clock progression, and matchup flow, date/season filtering
windows and chronological context, and venue/location geography and
regional metadata.

## Usage

``` r
gc_summary(game = 2023030417)
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

## Value

list of various items

## Examples

``` r
gc_summary_Martin_Necas_legacy_game <- gc_summary(game = 2025020275)
```
