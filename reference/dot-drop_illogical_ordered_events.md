# Remove illogically ordered boundary events from a play-by-play

`.drop_illogical_ordered_events()` removes stray boundary rows that can
appear between a period's `period-end` and the following period's
`period-start`. In practice, these are most often duplicated `0:00`
`faceoff`/`stoppage` rows that are still tagged to the previous period
even though the actual opening sequence for the next period follows
immediately after.

## Usage

``` r
.drop_illogical_ordered_events(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference

## Value

data.frame with illogically ordered boundary events removed
