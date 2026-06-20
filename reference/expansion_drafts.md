# Access all the expansion drafts

`expansion_drafts()` returns expansion-draft rule records by season,
including the rule text and season identifiers exposed by the records
endpoint.

## Usage

``` r
expansion_drafts()
```

## Value

data.frame with one row per expansion draft

## Examples

``` r
all_expansion_drafts <- expansion_drafts()
```
