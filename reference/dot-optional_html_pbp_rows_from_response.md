# Parse optional HTML on-ice rows from a parallel response

`.optional_html_pbp_rows_from_response()` parses a fetched HTML
play-by-play response when it succeeded and otherwise returns an empty
data frame.

## Usage

``` r
.optional_html_pbp_rows_from_response(
  resp,
  game,
  rosters,
  home_team_id,
  away_team_id,
  home_abbrev,
  away_abbrev
)
```

## Arguments

- resp:

  response or failure object

- game:

  game ID

- rosters:

  roster data.frame from play-by-play metadata

- home_team_id:

  home-team ID

- away_team_id:

  away-team ID

- home_abbrev:

  home-team abbreviation

- away_abbrev:

  away-team abbreviation

## Value

data.frame of parsed HTML rows or an empty data.frame
