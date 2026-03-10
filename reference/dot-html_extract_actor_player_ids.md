# Extract actor player IDs from an HTML event

`.html_extract_actor_player_ids()` resolves primary, secondary, and
tertiary actor player IDs from HTML event descriptions using the roster
lookup.

## Usage

``` r
.html_extract_actor_player_ids(
  description,
  type_desc_key,
  owner_team_id,
  home_team_id,
  away_team_id,
  home_abbrev,
  away_abbrev,
  roster_lookup
)
```

## Arguments

- description:

  HTML event description

- type_desc_key:

  internal event type key

- owner_team_id:

  owner team ID

- home_team_id:

  home-team ID

- away_team_id:

  away-team ID

- home_abbrev:

  home-team abbreviation

- away_abbrev:

  away-team abbreviation

- roster_lookup:

  standardized roster lookup data.frame

## Value

named list of actor player IDs
