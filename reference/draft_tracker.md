# Access the real-time draft tracker

`draft_tracker()` retrieves the real-time draft tracker as a
`data.frame` where each row represents player and includes detail on
team identity, affiliation, and matchup-side context, player identity,
role, handedness, and biographical profile, and venue/location geography
and regional metadata.

## Usage

``` r
draft_tracker()
```

## Value

data.frame with one row per player

## Examples

``` r
draft_tracker <- draft_tracker()
```
