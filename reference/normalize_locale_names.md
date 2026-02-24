# Normalize locale-style dotted columns to camelCase

Converts dotted names (e.g., firstName.default, name.cs) to camelCase
and removes trailing `Default` from default-language fields.

## Usage

``` r
normalize_locale_names(x)
```

## Arguments

- x:

  character vector

## Value

character vector
