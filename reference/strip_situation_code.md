# Strip the situation code into goalie and skater counts, man differential, and strength state for all the events (plays) in a play-by-play by perspective

`strip_situation_code()` strip the situation code into goalie and skater
counts, man differential, and strength state for all the events (plays)
in a play-by-play by perspective.

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
  for reference; must be untouched by non-nhlscraper functions; saves
  time if
  [`flag_is_home()`](https://rentosaijo.github.io/nhlscraper/reference/flag_is_home.md)
  has already been called

## Value

data.frame with one row per event (play) and added columns:
`homeIsEmptyNet`, `awayIsEmptyNet`, `homeSkaterCount`,
`awaySkaterCount`, `isEmptyNetFor`, `isEmptyNetAgainst`,
`skaterCountFor`, `skaterCountAgainst`, `manDifferential`, and
`strengthState`

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  test                         <- gc_play_by_play()
  test_is_home_flagged         <- flag_is_home(test)
  test_situation_code_stripped <- strip_situation_code(test_is_home_flagged)
# }
```
