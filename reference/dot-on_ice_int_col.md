# Extract an integer on-ice column

`.on_ice_int_col()` safely extracts an integer column from a data frame
and returns `NA` values when the column is absent.

## Usage

``` r
.on_ice_int_col(df, name)
```

## Arguments

- df:

  data.frame source object

- name:

  column name to extract

## Value

integer vector
