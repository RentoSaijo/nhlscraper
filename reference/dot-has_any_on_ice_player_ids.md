# Identify populated on-ice player rows

`.has_any_on_ice_player_ids()` returns a logical vector indicating
whether a play-by-play row already has any scalar on-ice player IDs
assigned.

## Usage

``` r
.has_any_on_ice_player_ids(play_by_play)
```

## Arguments

- play_by_play:

  data.frame play-by-play object

## Value

logical vector
