# Access the raw World Showcase (WSC) play-by-play for a game

`wsc_play_by_play_raw()` returns the raw flattened World Showcase
play-by-play as served by the NHL API for one game. Use
[`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
for the cleaned public schema that repairs common clock/order defects
and appends the derived public columns.

## Usage

``` r
wsc_play_by_play_raw(game = 2023030417)

wsc_pbp_raw(game = 2023030417)
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

## Value

data.frame with one row per event (play)

## Examples

``` r
wsc_raw_Martin_Necas_legacy_game <- wsc_play_by_play_raw(game = 2025020275)
```
