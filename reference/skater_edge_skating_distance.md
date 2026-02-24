# Access the EDGE skating distance statistics for a skater, season, game type, and category

`skater_edge_skating_distance()` retrieves the EDGE skating distance
statistics for a skater, season, game type, and category as a
`data.frame` where each row represents strength state and includes
detail on team identity, affiliation, and matchup-side context, player
identity, role, handedness, and biographical profile, and
tracking/spatial detail such as location, speed, distance, and zone
distribution.

## Usage

``` r
skater_edge_skating_distance(
  player = 8478402,
  season = "now",
  game_type = "",
  category = "details"
)
```

## Arguments

- player:

  integer ID (e.g., 8480039); see
  [`players()`](https://rentosaijo.github.io/nhlscraper/reference/players.md)
  for reference

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`skater_edge_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/skater_edge_seasons.md)
  for reference

- game_type:

  integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 =
  playoff/post-season) OR character of 'pre', 'regular', or
  'playoff'/'post'; see
  [`skater_edge_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/skater_edge_seasons.md)
  for reference; most functions will NOT support pre-season

- category:

  character of 'd'/'details' or 'l'/'l10'/'last 10'

## Value

data.frame with one row per strength state (category = 'details') or
game (category = 'last 10')

## Examples

``` r
Martin_Necas_L10_skating_distance_regular_20242025 <- 
  skater_edge_skating_distance(
    player    = 8480039,
    season    = 20242025,
    game_type = 2,
    category  = 'L'
  )
```
