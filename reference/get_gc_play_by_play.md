# Access the GameCenter (GC) play-by-play for a game

`get_gc_play_by_play()` is deprecated. Use
[`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
instead.

## Usage

``` r
get_gc_play_by_play(game = 2023030417)
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

## Value

data.frame with one row per event (play)
