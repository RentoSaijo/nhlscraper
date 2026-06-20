# Access the real-time draft tracker

`draft_tracker()` returns the live NHL draft tracker picks for the
current draft, with normalized player, team, round, and pick fields.

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
