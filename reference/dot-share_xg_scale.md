# Build xG color scaling metadata

`.share_xg_scale()` caps xG at the 98th percentile of positive attempts
and returns colors plus legend labels on a log-like scale.

## Usage

``` r
.share_xg_scale(xg)
```

## Arguments

- xg:

  numeric expected-goals vector

## Value

named list of color and legend metadata
