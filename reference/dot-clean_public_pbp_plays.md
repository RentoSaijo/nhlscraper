# Run shared public play-by-play cleanup

`.clean_public_pbp_plays()` applies the common clock, ordering,
strength, coordinate, shot-context, and HTML on-ice enrichment pipeline
used by both GameCenter and World Showcase public play-by-play
functions.

## Usage

``` r
.clean_public_pbp_plays(
  plays,
  game,
  pbp_meta,
  html_rows,
  source = c("gc", "wsc")
)
```

## Arguments

- plays:

  source-normalized play data.frame

- game:

  game ID

- pbp_meta:

  GameCenter metadata list containing roster and team metadata

- html_rows:

  optional parsed HTML on-ice rows

- source:

  output source, either `gc` or `wsc`

## Value

data.frame in the finalized public play-by-play schema
