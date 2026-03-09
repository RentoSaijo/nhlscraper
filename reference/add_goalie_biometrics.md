# Add goalie biometrics to (a) play-by-play(s)

`add_goalie_biometrics()` adds goalie biometrics (height, weight, hand,
and age at game date) to (a) play-by-play(s) for shot attempts. If
`goaliePlayerIdAgainst` is missing on a row, the added goalie biometrics
are left as `NA`.

## Usage

``` r
add_goalie_biometrics(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s) using the current public schema returned
  by
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md),
  [`gc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_plays.md),
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md),
  or
  [`wsc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_plays.md)

## Value

data.frame with one row per event (play) and added columns:
`goalieHeight`, `goalieWeight`, `goalieHandCode`, and `goalieAge`
