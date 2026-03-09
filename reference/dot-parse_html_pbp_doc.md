# Parse an HTML play-by-play document

`.parse_html_pbp_doc()` extracts event rows, actor IDs, and on-ice
player lists from an NHL HTML play-by-play report.

## Usage

``` r
.parse_html_pbp_doc(
  doc,
  roster_lookup,
  home_team_id,
  away_team_id,
  home_abbrev,
  away_abbrev,
  is_playoffs = FALSE
)
```

## Arguments

- doc:

  parsed HTML document

- roster_lookup:

  standardized roster lookup data.frame

- home_team_id:

  home-team ID

- away_team_id:

  away-team ID

- home_abbrev:

  home-team abbreviation

- away_abbrev:

  away-team abbreviation

- is_playoffs:

  logical; whether the game is a playoff game

## Value

data.frame of parsed HTML play-by-play rows
