# Prepare raw World Showcase rows for public cleanup

`.prepare_wsc_public_pbp_plays()` normalizes the World Showcase event
feed and removes source-only fields before the shared public
play-by-play cleanup pipeline runs.

## Usage

``` r
.prepare_wsc_public_pbp_plays(plays, game)
```

## Arguments

- plays:

  raw World Showcase play data.frame

- game:

  game ID

## Value

data.frame
