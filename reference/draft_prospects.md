# Access all the draft prospects

`draft_prospects()` retrieves all the draft prospects as a `data.frame`
where each row represents player and includes detail on player identity,
role, handedness, and biographical profile plus broadcast carriage,
media availability, and viewing-link metadata.

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
