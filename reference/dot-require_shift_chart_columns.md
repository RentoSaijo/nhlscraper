# Validate required shift-chart columns

`.require_shift_chart_columns()` errors when a helper is called with a
shift chart missing required public schema columns.

## Usage

``` r
.require_shift_chart_columns(shift_chart, cols, fn_name)
```

## Arguments

- shift_chart:

  data.frame shift chart object

- cols:

  character vector of required columns

- fn_name:

  calling function name used in the error message

## Value

`NULL`, invisibly, or an error if required columns are missing
