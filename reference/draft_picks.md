# Access all the draft picks

`draft_picks()` returns the historical draft-pick table with one row per
pick, including draft year/round/overall slot, team, player, position,
and biographical fields.

## Usage

``` r
draft_picks()
```

## Value

data.frame with one row per pick

## Examples

``` r
# May take >5s, so skip.
all_draft_picks <- draft_picks()
```
