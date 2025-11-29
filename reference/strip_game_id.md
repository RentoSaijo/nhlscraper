# Strip the game ID into the season ID, game type ID, and game number for all the events (plays) in a play-by-play

`strip_game_id()` strips the game ID into the season ID, game type ID,
and game number for all the events (plays) in a play-by-play.

## Usage

``` r
strip_game_id(play_by_play)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md)
  and/or
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md)
  for reference; must be untouched by non-nhlscraper functions

## Value

data.frame with one row per event (play) and added columns: `seasonId`,
`gameTypeId`, and `gameNumber`

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  test                  <- gc_play_by_play()
  test_game_id_stripped <- strip_game_id(test)
# }
```
