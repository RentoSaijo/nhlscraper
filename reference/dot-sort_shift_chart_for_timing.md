# Sort shift data for timing lookups

`.sort_shift_chart_for_timing()` filters incomplete shift rows and sorts
the remainder into the order expected by the timing resolvers.

## Usage

``` r
.sort_shift_chart_for_timing(shift_data)
```

## Arguments

- shift_data:

  data.frame shift chart data

## Value

filtered and sorted shift data.frame
