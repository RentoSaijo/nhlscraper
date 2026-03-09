# Build a shot-event mask

`.shot_event_mask()` flags play-by-play rows matching selected event
types while excluding short missed shots.

## Usage

``` r
.shot_event_mask(play_by_play, types)
```

## Arguments

- play_by_play:

  data.frame play-by-play object

- types:

  character vector of event type keys to keep

## Value

logical vector
