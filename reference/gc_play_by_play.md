# Access the GameCenter (GC) play-by-play for a game

`gc_play_by_play()` scrapes the GC play-by-play for a given `game`.

## Usage

``` r
gc_play_by_play(game = 2023030417)

gc_pbp(game = 2023030417)
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
gc_pbp_Martin_Necas_legacy_game <- gc_play_by_play(game = 2025020275)
```
