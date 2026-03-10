# Mask HTML on-ice columns on unsupported events

`.mask_strength_context_block()` sets HTML-derived on-ice player-ID and
timing columns to `NA` on event types that are not supported by the HTML
on-ice player pipeline.

## Usage

``` r
.mask_strength_context_block(play_by_play)
```

## Arguments

- play_by_play:

  data.frame play-by-play object

## Value

data.frame with unsupported rows masked
