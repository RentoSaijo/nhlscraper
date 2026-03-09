# Finalize public play-by-play output

`.finalize_pbp_output()` renames internal columns to the public schema
and selects the final GC or WSC play-by-play column set.

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
