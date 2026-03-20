# Add on-ice shift times to a play-by-play

`add_shift_times()` adds `SecondsRemainingInShift`,
`SecondsElapsedInShift`, and `SecondsElapsedInPeriodSinceLastShift`
columns for the on-ice goalies and skaters already present in a public
play-by-play. It accepts either a single game play-by-play plus
[`shift_chart()`](https://rentosaijo.github.io/nhlscraper/reference/shift_chart.md)
data or a season aggregate plus
[`shift_charts()`](https://rentosaijo.github.io/nhlscraper/reference/shift_charts.md)
data.

## Usage

``` r
add_shift_times(play_by_play, shift_chart)
```

## Arguments

- play_by_play:

  data.frame of play-by-play(s) using the current public schema returned
  by
  [`gc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_play.md),
  [`gc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/gc_play_by_plays.md),
  [`wsc_play_by_play()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_play.md),
  or
  [`wsc_play_by_plays()`](https://rentosaijo.github.io/nhlscraper/reference/wsc_play_by_plays.md)

- shift_chart:

  data.frame returned by
  [`shift_chart()`](https://rentosaijo.github.io/nhlscraper/reference/shift_chart.md)
  or
  [`shift_charts()`](https://rentosaijo.github.io/nhlscraper/reference/shift_charts.md)

## Value

data.frame with one row per event (play) and added or updated scalar
on-ice shift timing columns

## Examples

``` r
# \donttest{
  pbp <- gc_play_by_play(game = 2023030417)
  sc  <- shift_chart(game = 2023030417)
  pbp <- add_shift_times(pbp, sc)
# }
```
