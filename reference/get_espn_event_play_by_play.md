# Access the ESPN play-by-play for an event (game)

`get_espn_event_play_by_play()` is deprecated. Use
[`espn_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/espn_play_by_play.md)
instead.

## Usage

``` r
get_espn_event_play_by_play(event = 401777460)
```

## Arguments

- event:

  integer ID (e.g., 401777460); see
  [`espn_games()`](https://rentosaijo.github.io/nhlscraper/reference/espn_games.md)
  for reference

## Value

data.frame with one row per play
