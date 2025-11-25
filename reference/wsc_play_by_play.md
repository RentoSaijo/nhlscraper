# Access the World Showcase (WSC) play-by-play for a game

`wsc_play_by_play()` scrapes the WSC play-by-play for given `game`.

## Usage

``` r
wsc_play_by_play(game = 2023030417)

wsc_pbp(game = 2023030417)
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
wsc_pbp_Martin_Necas_legacy_game <- wsc_play_by_play(game = 2025020275)
```
