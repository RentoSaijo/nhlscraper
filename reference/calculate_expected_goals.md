# Calculate the expected goals for all the shots in (a) play-by-plays

`calculate_expected_goals()` scores shot events with `nhlscraper`'s
built-in ridge expected-goals model. The runtime model is a fixed
six-partition system: `sd` (5v5), `ev` (other even strength), `pp`
(power play), `sh` (short-handed), `en` (empty net against), and `so`
(shootout / penalty shot). The legacy `model` argument is accepted for
backward compatibility but ignored.

## Usage

``` r
calculate_expected_goals(play_by_play, model = NULL)

calculate_xG(play_by_play, model = NULL)
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

- model:

  deprecated legacy model selector; ignored

## Value

data.frame with one row per event (play) and added `xG` column

## Examples

``` r
# May take >5s, so skip.
# \donttest{
  pbp <- gc_play_by_play()
  pbp_with_xg <- calculate_expected_goals(play_by_play = pbp)
# }
```
