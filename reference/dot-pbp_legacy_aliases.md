# Normalize legacy internal play-by-play aliases

`.pbp_legacy_aliases()` backfills older internal column names so helper
pipelines can work against a consistent internal schema.

## Usage

``` r
.pbp_legacy_aliases(play_by_play)
```

## Arguments

- play_by_play:

  data.frame play-by-play object

## Value

data.frame with internal aliases backfilled where available
