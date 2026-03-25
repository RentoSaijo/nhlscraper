# Finalize public play-by-play output

`.finalize_pbp_output()` selects and orders the final GC or WSC public
play-by-play column set.

## Usage

``` r
.finalize_pbp_output(play_by_play, source = c("gc", "wsc"))
```

## Arguments

- play_by_play:

  data.frame play-by-play object

- source:

  output source, either `"gc"` or `"wsc"`

## Value

data.frame with the finalized public play-by-play schema
