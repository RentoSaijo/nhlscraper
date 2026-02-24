# Access all the draft picks

`draft_picks()` retrieves all the draft picks as a `data.frame` where
each row represents pick and includes detail on team identity,
affiliation, and matchup-side context plus player identity, role,
handedness, and biographical profile.

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
