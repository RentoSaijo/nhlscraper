# Access all the draft prospects

`draft_prospects()` returns the records-site prospect registry with one
row per prospect and normalized prospect/player IDs, names, birth data,
and profile fields.

## Usage

``` r
draft_prospects()
```

## Value

data.frame with one row per player

## Examples

``` r
# May take >5s, so skip.
all_prospects <- draft_prospects()
```
