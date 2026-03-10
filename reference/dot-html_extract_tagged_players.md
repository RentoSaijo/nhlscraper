# Extract team-tagged player references from HTML

`.html_extract_tagged_players()` resolves explicitly team-tagged HTML
player references such as `TOR #42` into ordered team/player pairs.

## Usage

``` r
.html_extract_tagged_players(
  description,
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

data.frame of ordered team/player references
