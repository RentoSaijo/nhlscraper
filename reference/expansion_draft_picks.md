# Access all the expansion draft picks

`expansion_draft_picks()` retrieves all the expansion draft picks as a
`data.frame` where each row represents pick and includes detail on
date/season filtering windows and chronological context plus team
identity, affiliation, and matchup-side context.

## Usage

``` r
expansion_draft_picks()
```

## Value

data.frame with one row per pick

## Examples

``` r
all_expansion_draft_picks <- expansion_draft_picks()
```
