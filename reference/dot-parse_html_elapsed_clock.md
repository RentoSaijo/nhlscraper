# Parse an HTML elapsed clock

`.parse_html_elapsed_clock()` extracts the elapsed `MM:SS` clock from an
HTML report time field and converts it to elapsed seconds in period.

## Usage

``` r
.parse_html_elapsed_clock(x)
```

## Arguments

- x:

  HTML time field

## Value

integer seconds elapsed in period or `NA_integer_`
