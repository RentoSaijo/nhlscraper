# Calculate the expected goals for all the shots in (a) play-by-plays

`calculate_expected_goals()` calculates the expected goals for all the
shots in (a) play-by-play(s) using the provided `model`.

## Usage

``` r
calculate_expected_goals(play_by_play, model = 1)

calculate_xG(play_by_play, model = 1)
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

- model:

  integer in 1:4 indicating which expected goals model to use; see web
  documentation for what variables each model considers

## Value

data.frame with one row per event (play) and added `xG` column

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  pbp <- gc_play_by_play()
  pbp_with_xG_v3 <- calculate_expected_goals(play_by_play = pbp, model = 3)
# }
```
