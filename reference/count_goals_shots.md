# Count the as-of-event goal, shots on goal, Fenwick, and Corsi attempts and differentials for all the events (plays) in a play-by-play by perspective

`count_goals_shots()` counts the as-of-event goal, shots on goal,
Fenwick, and Corsi attempts and differentials for all the events (plays)
in a play-by-play by perspective.

## Usage

``` r
count_goals_shots(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference

## Value

data.frame with one row per event (play) and added columns: `homeGoals`,
`awayGoals`, `homeSOG`, `awaySOG`, `homeFenwick`, `awayFenwick`,
`homeCorsi`, `awayCorsi`, `goalsFor`, `goalsAgainst`, `SOGFor`,
`SOGAgainst`, `fenwickFor`, `fenwickAgainst`, `corsiFor`,
`corsiAgainst`, `goalDifferential`, `SOGDifferential`,
`fenwickDifferential`, and `corsiDifferential`
