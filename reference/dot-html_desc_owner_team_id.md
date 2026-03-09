# Resolve the owner team from an HTML description

`.html_desc_owner_team_id()` infers the event owner team ID from the
leading team abbreviation embedded in an HTML event description.

## Usage

``` r
.html_desc_owner_team_id(
  description,
  home_abbrev,
  away_abbrev,
  home_team_id,
  away_team_id
)
```

## Arguments

- description:

  HTML event description

- home_abbrev:

  home-team abbreviation

- away_abbrev:

  away-team abbreviation

- home_team_id:

  home-team ID

- away_team_id:

  away-team ID

## Value

integer team ID or `NA_integer_`
