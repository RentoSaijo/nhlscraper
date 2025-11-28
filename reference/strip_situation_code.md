# Strip the situation code into goalie and skater counts, man differential, and strength state for all the events (plays) in a play-by-play by perspective

`strip_situation_code()` strip the situation code into goalie and skater
counts, man differential, and strength state for all the events (plays)
in a play-by-play by perspective.

## Usage

``` r
strip_situation_code(
  data,
  is_home_name = "isHome",
  situation_code_name = "situationCode",
  home_is_empty_net_name = "homeIsEmptyNet",
  away_is_empty_net_name = "awayIsEmptyNet",
  home_skater_count_name = "homeSkaterCount",
  away_skater_count_name = "awaySkaterCount",
  is_empty_net_for_name = "isEmptyNetFor",
  is_empty_net_against_name = "isEmptyNetAgainst",
  skater_count_for_name = "skaterCountFor",
  skater_count_against_name = "skaterCountAgainst",
  man_differential_name = "manDifferential",
  strength_state_name = "strengthState"
)
```

## Arguments

- data:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference

- is_home_name:

  name of column that contains home/not logical indicator; see
  [`flag_is_home()`](https://rentosaijo.github.io/nhlscraper/reference/flag_is_home.md)
  for reference

- situation_code_name:

  name of column that contains situation code

- home_is_empty_net_name:

  name of column that you want contain empty net indicator for home team

- away_is_empty_net_name:

  name of column that you want contain empty net indicator for away team

- home_skater_count_name:

  name of column that you want contain skater count for home team

- away_skater_count_name:

  name of column that you want contain skater count for away team

- is_empty_net_for_name:

  name of column that you want contain empty net indicator for
  event-owning team

- is_empty_net_against_name:

  name of column that you want contain empty net indicator for opposing
  team

- skater_count_for_name:

  name of column that you want contain skater count for event-owning
  team

- skater_count_against_name:

  name of column that you want contain skater count for opposing team

- man_differential_name:

  name of column that you want contain man differential

- strength_state_name:

  name of column that you want contain strength state

## Value

data.frame with one row per event (play)

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  test                         <- gc_play_by_play()
  test_is_home_flagged         <- flag_is_home(test)
  test_situation_code_stripped <- strip_situation_code(test_is_home_flagged)
# }
```
