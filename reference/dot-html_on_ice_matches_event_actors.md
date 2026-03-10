# Check required event actors against resolved HTML on-ice IDs

`.html_on_ice_matches_event_actors()` validates that the key API event
actors for a matched row are present on the corresponding HTML on-ice
team sets. It is intentionally narrow and only returns `TRUE` when at
least one informative actor field is available for the event type.

## Usage

``` r
.html_on_ice_matches_event_actors(
  play_by_play,
  idx,
  home_goalie_player_id,
  away_goalie_player_id,
  home_skater_player_ids,
  away_skater_player_ids
)
```

## Arguments

- play_by_play:

  data.frame cleaned internal play-by-play object

- idx:

  row index in the play-by-play

- home_goalie_player_id:

  parsed home goalie player ID

- away_goalie_player_id:

  parsed away goalie player ID

- home_skater_player_ids:

  parsed home skater IDs

- away_skater_player_ids:

  parsed away skater IDs

## Value

logical scalar
