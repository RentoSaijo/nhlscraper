# Allocate a missing public play-by-play column

`.empty_public_pbp_column()` returns a typed `NA` vector for a public
play-by-play column that is absent in the upstream source data.

## Usage

``` r
.empty_public_pbp_column(name, n)
```

## Arguments

- name:

  public play-by-play column name

- n:

  output row count

## Value

typed vector of missing values
