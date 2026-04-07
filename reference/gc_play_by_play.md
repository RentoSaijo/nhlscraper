# Access the GameCenter (GC) play-by-play for a game

`gc_play_by_play()` retrieves the GameCenter (GC) play-by-play for a
game as a `data.frame` where each row represents an event. The returned
schema is the cleaned, public-facing play-by-play schema, including
canonical names such as `periodNumber`, `eventTypeCode`,
`eventTypeDescKey`, `homeShots`, `shotsFor`, `penaltyTypeDescKey`,
`penaltyDuration`, `servedByPlayerId`, `goalieInNetId`, and
HTML-report-derived on-ice player ID columns such as
`homeGoaliePlayerId`, `awayGoaliePlayerId`, `homeSkater1PlayerId`, and
any additional overflow skater slots required by the game. HTML report
skater and goalie IDs are returned whenever they can be matched back to
a supported row, even when the raw `situationCode` is stale. Use
[`add_shift_times()`](https://rentosaijo.github.io/nhlscraper/reference/add_shift_times.md)
with
[`shift_chart()`](https://rentosaijo.github.io/nhlscraper/reference/shift_chart.md)
(or
[`shift_charts()`](https://rentosaijo.github.io/nhlscraper/reference/shift_charts.md))
to add on-ice shift timing columns.

## Usage

``` r
gc_play_by_play(game = 2023030417)

gc_pbp(game = 2023030417)
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

## Value

data.frame with one row per event (play)

## Examples

``` r
# May take >5s, so skip.
gc_pbp_Martin_Necas_legacy_game <- gc_play_by_play(game = 2025020275)
```
