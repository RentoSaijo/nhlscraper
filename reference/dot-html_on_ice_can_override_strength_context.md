# Check whether an HTML on-ice signature can override derived strength context

`.html_on_ice_can_override_strength_context()` allows the HTML on-ice
skater and goalie counts to replace derived strength context when the
resolved signature still looks like a plausible hockey state. Overflow
rows with more than six skaters are preserved in the scalar player-ID
output but do not rewrite the derived count columns.

## Usage

``` r
.html_on_ice_can_override_strength_context(
  situation_code,
  home_goalie_player_id,
  away_goalie_player_id,
  home_skater_player_ids,
  away_skater_player_ids
)
```

## Arguments

- situation_code:

  raw API situation code

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
