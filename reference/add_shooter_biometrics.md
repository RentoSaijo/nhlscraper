# Add shooter biometrics to (a) play-by-play(s)

`add_shooter_biometrics()` adds shooter biometrics (height, weight,
hand, age at game date, and position) to (a) play-by-play(s) for shot
attempts.

## Usage

``` r
add_shooter_biometrics(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md),
  [`gc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_plays.md),
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md),
  or
  [`wsc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_plays.md)
  for reference; the original columns must exist

## Value

data.frame with one row per event (play) and added columns:
`shooterHeight`, `shooterWeight`, `shooterHandCode`, `shooterAge`, and
`shooterPositionCode`
