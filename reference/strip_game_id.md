# Strip the game ID into the season ID, game type ID, and game number for all the events (plays) in a play-by-play

`strip_game_id()` strips the game ID into the season ID, game type ID,
and game number for all the events (plays) in a play-by-play.

## Usage

``` r
strip_game_id(
  data,
  game_id_name = "gameId",
  season_id_name = "seasonId",
  game_type_id_name = "gameTypeId",
  game_number_name = "gameNumber"
)
```

## Arguments

- data:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference

- game_id_name:

  name of column that contains game ID

- season_id_name:

  name of column that you want contain season ID

- game_type_id_name:

  name of column that you want contain game type ID

- game_number_name:

  name of column that you want contain game number

## Value

data.frame with one row per event (play)

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  test                 <- gc_play_by_play()
  test_gameId_stripped <- strip_game_id(test)
# }
```
