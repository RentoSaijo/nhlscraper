# Access the all-time statistics versus other franchises for all the franchises by game type

`franchise_versus_franchise()` retrieves the all-time statistics versus
other franchises for all the franchises by game type as a `data.frame`
where each row represents franchise per franchise per game type and
includes detail on date/season filtering windows and chronological
context plus team identity, affiliation, and matchup-side context.

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
