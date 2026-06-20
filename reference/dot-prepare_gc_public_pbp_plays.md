# Prepare raw GameCenter rows for public cleanup

`.prepare_gc_public_pbp_plays()` normalizes the flattened GameCenter
event names and source-specific quirks before the shared public
play-by-play cleaning pipeline runs.

## Usage

``` r
.prepare_gc_public_pbp_plays(plays, game)
```

## Arguments

- plays:

  raw GameCenter play data.frame

- game:

  game ID

## Value

data.frame
