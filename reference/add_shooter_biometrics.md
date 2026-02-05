# Add shooter biometrics to (a) play-by-play(s)

`add_shooter_biometrics()` adds shooter biometrics (height, weight, age
at game date, and onwing/offwing/neutral side) to (a) play-by-play(s)
for Fenwick events.

## Usage

``` r
add_shooter_biometrics(play_by_play, neutral_threshold = 5)
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

- neutral_threshold:

  integer; absolute yCoordNorm at or below which `shooterSide` is set to
  'neutral'

## Value

data.frame with one row per event (play) and added columns:
`shooterHeight`, `shooterWeight`, `shooterAge`, `shooterSide`
