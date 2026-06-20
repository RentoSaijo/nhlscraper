# Calculate shift times by exact situation code

`calculate_shift_times_by_situation()` returns one row per player per
period and splits time on ice by the exact play-by-play `situationCode`
in effect during that player's shifts. This differs from
[`shift_chart_summary()`](https://rentosaijo.github.io/nhlscraper/reference/shift_chart_summary.md),
which reads the NHL HTML report's broad EV/PP/SH totals. Here, shift
seconds come from
[`shift_chart()`](https://rentosaijo.github.io/nhlscraper/reference/shift_chart.md)
and strength state comes from
[`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md).
When `season` is supplied, it overrides `game` and the function uses
[`gc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_plays.md)
with
[`shift_charts()`](https://rentosaijo.github.io/nhlscraper/reference/shift_charts.md)
for the full season.

## Usage

``` r
calculate_shift_times_by_situation(game = 2023030417, season = NULL)
```

## Arguments

- game:

  integer ID (e.g., 2023030417); ignored when `season` is supplied

- season:

  optional integer season ID (e.g., 20232024)

## Value

data.frame with one row per player per period and situation-specific
`TimeOnIce` columns

## Details

In the play-by-play, the four `situationCode` digits mean away goalie
count, away skater count, home skater count, and home goalie count. In
this output, the four digits in each situation-specific column mean
player-team goalie count, player-team skater count, opponent skater
count, and opponent goalie count. For example, raw `1451` means home
skaters are on a 5-on-4 power play; those seconds are written to
`1541TimeOnIce` for home players and `1451TimeOnIce` for away players.

## Examples

``` r
# \donttest{
shift_situations_2023030417 <- calculate_shift_times_by_situation(
  game = 2023030417
)
# }
```
