# Check HTML on-ice counts against a situation code

`.html_on_ice_matches_situation_code()` validates that a parsed HTML
on-ice row is compatible with the source API situation code. Missing or
unparseable situation codes are treated as compatible.

## Usage

``` r
.html_on_ice_matches_situation_code(
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

  parsed home skater player IDs

- away_skater_player_ids:

  parsed away skater player IDs

## Value

logical scalar
