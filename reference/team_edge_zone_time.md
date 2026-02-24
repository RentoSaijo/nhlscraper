# Access the EDGE zone time statistics for a team, season, game type, and category

`team_edge_zone_time()` retrieves the EDGE zone time statistics for a
team, season, game type, and category as a `data.frame` where each row
represents strength state and includes detail on NHL EDGE style tracking
outputs and relative-performance context.

## Usage

``` r
team_edge_zone_time(
  team = 1,
  season = "now",
  game_type = "",
  category = "details"
)
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

- category:

  character of 'd'/'details' or 'dS'/'dSOG'/'dShot'/'shot differential'

## Value

data.frame with one row per strength state (category = 'details') or
list with four items (category = 'shot differential')

## Examples

``` r
COL_dS_regular_20242025 <- team_edge_zone_time(
  team      = 21,
  season    = 20242025,
  game_type = 2,
  category  = 'dS'
)
```
