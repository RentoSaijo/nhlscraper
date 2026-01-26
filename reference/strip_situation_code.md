# Strip the situation code into goalie and skater counts, man differential, and strength state for all the events (plays) in a play-by-play by perspective

`strip_situation_code()` strips the situation code into goalie and
skater counts for home and away teams, then (from the event owner's
perspective) computes man differential and a strength state
classification.

## Usage

``` r
strip_situation_code(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference

## Value

data.frame with one row per event (play) and added columns:
`homeIsEmptyNet`, `awayIsEmptyNet`, `homeSkaterCount`,
`awaySkaterCount`, `isEmptyNetFor`, `isEmptyNetAgainst`,
`skaterCountFor`, `skaterCountAgainst`, `manDifferential`, and
`strengthState`
