# Backfill unmatched delayed-penalty rows from nearby populated rows

`.backfill_delayed_penalty_on_ice_players()` fills unmatched
delayed-penalty rows from the nearest previous populated supported row
in the same game and period when the raw `situationCode` and
goalie/skater counts are unchanged.

## Usage

``` r
.backfill_delayed_penalty_on_ice_players(play_by_play, max_gap_seconds = 15L)
```

## Arguments

- play_by_play:

  data.frame play-by-play object

- max_gap_seconds:

  integer scalar time window

## Value

data.frame with delayed-penalty rows backfilled where possible
