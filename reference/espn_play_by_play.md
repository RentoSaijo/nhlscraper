# Access the ESPN play-by-play for a game

`espn_play_by_play()` scrapes the ESPN play-by-play for a given `game`.

## Usage

``` r
espn_play_by_play(game = 401777460)

espn_pbp(game = 401777460)
```

## Arguments

- game:

  integer ID (e.g., 401777460); see
  [`espn_games()`](https://rentosaijo.github.io/nhlscraper/reference/espn_games.md)
  for reference

## Value

data.frame with one row per event (play)

## Examples

``` r
ESPN_pbp_SCF_20242025 <- espn_play_by_play(game = 401777460)
```
