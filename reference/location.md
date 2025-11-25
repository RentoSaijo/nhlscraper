# Access the location for a zip code

`location()` scrapes the location for a given `zip` code.

## Usage

``` r
location(zip = 10001)
```

## Arguments

- zip:

  integer (e.g., 48304)

## Value

data.frame with one row per team

## Examples

``` r
Cranbrook_Schools <- location(48304)
```
