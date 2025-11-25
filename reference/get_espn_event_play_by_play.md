# Get the play-by-play of an ESPN event

`get_espn_event_play_by_play()` retrieves ESPN-provided information on
each play for a given `event`, including but not limited to their ID,
type, time of occurrence, strength-state, participants, and X and Y
coordinates. Access
[`get_espn_events()`](https://rentosaijo.github.io/nhlscraper/reference/get_espn_events.md)
for `event` reference.

## Usage

``` r
get_espn_event_play_by_play(event = 401687600)

get_espn_event_pbp(event = 401687600)
```

## Arguments

- event:

  integer ESPN Event ID (e.g., 401687600)

## Value

data.frame with one row per play

## Examples

``` r
NJD_BUF_2024_10_04_pbp <- get_espn_event_play_by_play(event = 401687600)
```
