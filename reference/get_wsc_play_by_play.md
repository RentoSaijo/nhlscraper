# Access the World Showcase (WSC) play-by-play for a game

`get_wsc_play_by_play()` is deprecated. Use
[`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
instead.

## Usage

``` r
get_wsc_play_by_play(game = 2023030417)
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

## Value

data.frame with one row per event (play)
