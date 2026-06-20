# Access the location for a zip code

`location()` returns the NHL postal lookup result for one ZIP/postal
code, including country, region, and related local-market fields when
available.

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
