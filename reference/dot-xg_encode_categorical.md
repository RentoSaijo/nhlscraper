# Encode categorical xG feature

`.xg_encode_categorical()` is an internal helper for
[`calculate_expected_goals()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals.md).

## Usage

``` r
.xg_encode_categorical(values, var, spec, n)
```

## Arguments

- values:

  vector feature values

- var:

  character feature name

- spec:

  xG preprocessing specification

- n:

  integer row count

## Value

Internal helper output.
