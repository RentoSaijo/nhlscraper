# Add on-ice shift timing context

`.add_on_ice_shift_timing_context()` enriches play-by-play rows with
scalar shift elapsed and since-last-shift columns for the on-ice goalies
and skaters.

## Usage

``` r
.add_on_ice_shift_timing_context(play_by_play, game, shift_data = NULL)
```

## Arguments

- play_by_play:

  data.frame play-by-play object with on-ice player IDs

- game:

  game ID

- shift_data:

  optional shift chart data.frame

## Value

data.frame with scalar on-ice timing columns added
