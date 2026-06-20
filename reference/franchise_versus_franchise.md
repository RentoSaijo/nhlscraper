# Access the all-time statistics versus other franchises for all the franchises by game type

`franchise_versus_franchise()` returns all-time head-to-head records by
franchise, opponent franchise, and game type.

## Usage

``` r
franchise_versus_franchise()

franchise_vs_franchise()
```

## Value

data.frame with one row per franchise per franchise per game type

## Examples

``` r
# May take >5s, so skip.
franchise_vs_franchise <- franchise_versus_franchise()
```
