# Access the EDGE summary for a team, season, and game type

`team_edge_summary()` retrieves the EDGE summary for a team, season, and
game type as a nested `list` that separates summary and detail blocks
for team identity, affiliation, and matchup-side context plus NHL EDGE
style tracking outputs and relative-performance context.

## Usage

``` r
team_edge_summary(team = 1, season = "now", game_type = "")
```

## Arguments

- team:

  integer ID (e.g., 21), character full name (e.g., 'Colorado
  Avalanche'), OR three-letter code (e.g., 'COL'); see
  [`teams()`](https://rentosaijo.github.io/nhlscraper/reference/teams.md)
  for reference; ID is preferable as there now exists duplicate
  three-letter codes (i.e., 'UTA' for 'Utah Hockey Club' and 'Utah
  Mammoth')

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`team_edge_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/team_edge_seasons.md)
  for reference

- game_type:

  integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 =
  playoff/post-season) OR character of 'pre', 'regular', or
  'playoff'/'post'; see
  [`team_edge_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/team_edge_seasons.md)
  for reference; most functions will NOT support pre-season

## Value

list of various items

## Examples

``` r
COL_EDGE_summary_regular_20242025 <- team_edge_summary(
  team      = 21, 
  season    = 20242025,
  game_type = 2
)
```
