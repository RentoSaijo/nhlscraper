# Access the raw GameCenter (GC) play-by-play for a game

`gc_play_by_play_raw()` returns the raw flattened GameCenter
play-by-play as served by the NHL API for one game. Use
[`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
for the cleaned public schema that repairs common clock/order defects
and appends the derived public columns.

## Usage

``` r
gc_play_by_play_raw(game = 2023030417)

gc_pbp_raw(game = 2023030417)
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
gc_raw_Martin_Necas_legacy_game <- gc_play_by_play_raw(game = 2025020275)
```
