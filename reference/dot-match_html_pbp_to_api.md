# Match HTML play-by-play rows to API rows

`.match_html_pbp_to_api()` aligns parsed HTML play-by-play rows back to
API play-by-play rows using exact keys, greedy scoring, and a
reciprocal-best fallback for duplicate clusters.

## Usage

``` r
.match_html_pbp_to_api(play_by_play, html_rows)
```

## Arguments

- play_by_play:

  data.frame API play-by-play object

- html_rows:

  data.frame parsed HTML play-by-play rows

## Value

data.frame of matched HTML rows with `apiIndex`
