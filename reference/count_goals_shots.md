# Count the as-of-event goal, shots on goal, Fenwick, and Corsi attempts and differentials for all the events (plays) in a play-by-play by perspective

`count_goals_shots()` counts the as-of-event goal, shots on goal,
Fenwick, and Corsi attempts and differentials for all the events (plays)
in a play-by-play by perspective

## Usage

``` r
count_goals_shots(
  data,
  is_home_name = "isHome",
  game_id_name = "gameId",
  sort_order_name = "sortOrder",
  type_description_name = "typeDescKey",
  home_goals_name = "homeGoals",
  away_goals_name = "awayGoals",
  home_shots_on_goal_name = "homeSOG",
  away_shots_on_goal_name = "awaySOG",
  home_fenwick_name = "homeFenwick",
  away_fenwick_name = "awayFenwick",
  home_corsi_name = "homeCorsi",
  away_corsi_name = "awayCorsi",
  goals_for_name = "goalsFor",
  goals_against_name = "goalsAgainst",
  shots_on_goal_for_name = "SOGFor",
  shots_on_goal_against_name = "SOGAgainst",
  fenwick_for_name = "fenwickFor",
  fenwick_against_name = "fenwickAgainst",
  corsi_for_name = "corsiFor",
  corsi_against_name = "corsiAgainst",
  goal_differential_name = "goalDifferential",
  shots_on_goal_differential_name = "SOGDifferential",
  fenwick_differential_name = "fenwickDifferential",
  corsi_differential_name = "corsiDifferential"
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

- game_id_name:

  name of column that contains game ID

- sort_order_name:

  name of column that contains sort order

- type_description_name:

  name of column that contains event type description

- home_goals_name:

  name of column that you want contain goal count for home team

- away_goals_name:

  name of column that you want contain goal count for away team

- home_shots_on_goal_name:

  name of column that you want contain shots on goal count for home team

- away_shots_on_goal_name:

  name of column that you want contain shots on goal count for away team

- home_fenwick_name:

  name of column that you want contain Fenwick count for home team

- away_fenwick_name:

  name of column that you want contain Fenwick count for away team

- home_corsi_name:

  name of column that you want contain Corsi count for home team

- away_corsi_name:

  name of column that you want contain Corsi count for away team

- goals_for_name:

  name of column that you want contain goal count for event-owning team

- goals_against_name:

  name of column that you want contain goal count for opposing team

- shots_on_goal_for_name:

  name of column that you want contain shots on goal count for
  event-owning team

- shots_on_goal_against_name:

  name of column that you want contain shots on goal count for opposing
  team

- fenwick_for_name:

  name of column that you want contain Fenwick count for event-owning
  team

- fenwick_against_name:

  name of column that you want contain Fenwick

- corsi_for_name:

  name of column that you want contain Corsi count for event-owning team

- corsi_against_name:

  name of column that you want contain Corsi count for opposing team

- goal_differential_name:

  name of column that you want contain goal differential

- shots_on_goal_differential_name:

  name of column that you want contain shots on goal differential

- fenwick_differential_name:

  name of column that you want contain Fenwick differential

- corsi_differential_name:

  name of column that you want contain Corsi differential

## Value

data.frame with one row per event (play)

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  test                     <- gc_play_by_play()
  test_is_home_flagged     <- flag_is_home(test)
  test_goals_shots_counted <- count_goals_shots(test_is_home_flagged)
# }
```
