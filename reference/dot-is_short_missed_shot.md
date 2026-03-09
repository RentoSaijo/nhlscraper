# Identify short missed shots

`.is_short_missed_shot()` flags missed shots with reason `short`, which
are excluded from Fenwick and Corsi calculations.

## Usage

``` r
.is_short_missed_shot(play_by_play)
```

## Arguments

- play_by_play:

  data.frame play-by-play object

## Value

logical vector
