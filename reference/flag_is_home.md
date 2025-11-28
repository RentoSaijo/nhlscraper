# Flag if the event belongs to the home team or not for all the events (plays) in a play-by-play

`flag_is_home()` flags if the event belongs to the home team or not for
all the events (plays) in a play-by-play.

## Usage

``` r
flag_is_home(
  data,
  game_id_name = "gameId",
  event_owner_team_id_name = "eventOwnerTeamId",
  is_home_name = "isHome"
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

- event_owner_team_id_name:

  name of column that contains event-owning team's ID

- is_home_name:

  name of column that you want contain home/not logical indicator

## Value

data.frame with one row per event (play)

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  test                 <- gc_play_by_play()
  test_is_home_flagged <- flag_is_home(test)
# }
```
