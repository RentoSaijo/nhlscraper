# Add on-ice player IDs to a play-by-play by merging with shift charts

`add_on_ice_players()` merges a play-by-play with a shift chart to
determine which players are on the ice at each event. It adds home- and
away-team on-ice player ID lists, as well as event-perspective
for/against player ID lists when `isHome` is available.

## Usage

``` r
add_on_ice_players(play_by_play, shift_chart)
```

## Arguments

- play_by_play:

  data.frame of shift chart rows; see
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md),
  [`gc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_plays.md),
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md),
  or
  [`wsc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_plays.md)
  for reference; the original columns must exist

- shift_chart:

  data.frame of shift chart rows; see
  [`shift_chart()`](https://rentosaijo.github.io/nhlscraper/reference/shift_chart.md)
  or
  [`shift_charts()`](https://rentosaijo.github.io/nhlscraper/reference/shift_charts.md)
  for reference; the original columns must exist

## Value

data.frame with one row per event (play) and added list-columns:
`homePlayerIds`, `awayPlayerIds`, `playerIdsFor`, and `playerIdsAgainst`

## Examples

``` r
# May take >5s, so skip.
gc_pbp_enhanced <- add_on_ice_players(gc_pbp(), shift_chart())
```
