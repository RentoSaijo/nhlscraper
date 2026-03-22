# Access the World Showcase (WSC) play-by-play for a game

`wsc_play_by_play()` retrieves the World Showcase (WSC) play-by-play for
a game as a `data.frame` where each row represents an event. The
returned schema follows the same cleaned public-facing naming as
[`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md),
including `servedByPlayerId`, `goalieInNetId`, and `utc` immediately
after `secondsElapsedInGame` while omitting GC-only clip fields. It also
includes the same HTML-report-derived on-ice player ID columns added to
the GC output, including dynamically expanded overflow skater slots when
needed. HTML report skater and goalie IDs are returned whenever they can
be matched back to a supported row, even when the raw `situationCode` is
stale. Use
[`add_shift_times()`](https://rentosaijo.github.io/nhlscraper/reference/add_shift_times.md)
with
[`shift_chart()`](https://rentosaijo.github.io/nhlscraper/reference/shift_chart.md)
(or
[`shift_charts()`](https://rentosaijo.github.io/nhlscraper/reference/shift_charts.md))
to add on-ice shift timing columns.

## Usage

``` r
wsc_play_by_play(game = 2023030417)

wsc_pbp(game = 2023030417)
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
wsc_pbp_Martin_Necas_legacy_game <- wsc_play_by_play(game = 2025020275)
```
