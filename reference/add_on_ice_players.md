# Add on-ice player IDs to a play-by-play by merging with shift charts

`add_on_ice_players()` merges a play-by-play with a shift chart to
determine which players are on the ice at each event. It adds home- and
away-team on-ice player ID lists, event-perspective for/against player
ID lists, elapsed time in the current shift for each listed player, and
elapsed time since the end of the player's prior shift within the same
period. For the first shift of a period, the "since last shift" value is
set to `300 + secondsElapsedInPeriod`. For shootout and penalty-shot
rows (where `situationCode` is either `0101` or `1010`), the
elapsed-time list-columns are returned as `NA`.

## Usage

``` r
add_on_ice_players(play_by_play = NULL, shift_chart = NULL)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s); see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md),
  [`gc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_plays.md),
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md),
  or
  [`wsc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_plays.md)
  for reference; the original columns must exist

- shift_chart:

  data.frame of shift chart(s); see
  [`shift_chart()`](https://rentosaijo.github.io/nhlscraper/reference/shift_chart.md)
  or
  [`shift_charts()`](https://rentosaijo.github.io/nhlscraper/reference/shift_charts.md)
  for reference; the original columns must exist

## Value

data.frame with one row per event (play) and added list-columns:
`homePlayerIds`, `awayPlayerIds`, `playerIdsFor`, `playerIdsAgainst`,
`homeSkaterPlayerIds`, `awaySkaterPlayerIds`, `skaterPlayerIdsFor`,
`skaterPlayerIdsAgainst`, `homeGoaliePlayerId`, `awayGoaliePlayerId`,
`goaliePlayerIdFor`, `goaliePlayerIdAgainst`,
`homeSecondsElapsedInShift`, `awaySecondsElapsedInShift`,
`secondsElapsedInShiftFor`, `secondsElapsedInShiftAgainst`,
`homeSecondsElapsedInPeriodSinceLastShift`,
`awaySecondsElapsedInPeriodSinceLastShift`,
`secondsElapsedInPeriodSinceLastShiftFor`, and
`secondsElapsedInPeriodSinceLastShiftAgainst`

## Examples

``` r
# May take >5s, so skip.
gc_pbp_enhanced <- add_on_ice_players(gc_pbp(), shift_chart())
```
