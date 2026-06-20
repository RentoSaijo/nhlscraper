# Access all the drafts

`drafts()` merges the records draft master and stats draft-round
endpoints, returning one row per draft year with IDs, dates, location,
and round metadata.

## Usage

``` r
drafts()
```

## Value

data.frame with one row per draft

## Examples

``` r
all_drafts <- drafts()
```
