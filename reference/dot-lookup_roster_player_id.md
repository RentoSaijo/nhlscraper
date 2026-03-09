# Resolve a roster player ID

`.lookup_roster_player_id()` resolves a player ID from team, sweater
number, and optional name information within a roster lookup table.

## Usage

``` r
.lookup_roster_player_id(
  roster_lookup,
  team_id,
  sweater_number,
  player_name = NA_character_
)
```

## Arguments

- roster_lookup:

  standardized roster lookup data.frame

- team_id:

  team ID

- sweater_number:

  sweater number

- player_name:

  optional player name

## Value

integer player ID or `NA_integer_`
