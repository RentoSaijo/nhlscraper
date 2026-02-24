# Access the location for a zip code

`location()` retrieves the location for a zip code as a `data.frame`
where each row represents team and includes detail on venue/location
geography and regional metadata.

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
