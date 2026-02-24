# Access the EDGE save percentage statistics for a goalie, season, game type, and category

`goalie_edge_save_percentage()` retrieves the EDGE save percentage
statistics for a goalie, season, game type, and category as a nested
`list` that separates summary and detail blocks for NHL EDGE style
tracking outputs and relative-performance context.

## Usage

``` r
goalie_edge_save_percentage(
  player = 8476945,
  season = "now",
  game_type = "",
  category = "details"
)
```

## Arguments

- player:

  integer ID (e.g., 8478406)

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`goalie_edge_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_edge_seasons.md)
  for reference

- game_type:

  integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 =
  playoff/post-season) OR character of 'pre', 'regular', or
  'playoff'/'post'; see
  [`goalie_edge_seasons()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_edge_seasons.md)
  for reference; most functions will NOT support pre-season

- category:

  character of 'd'/'details' or 'l'/'l10'/'last 10'

## Value

list with two items (category = 'details') or data.frame with one row
per game (category = 'last 10')

## Examples

``` r
Mackenzie_Blackwood_L10_sP_regular_20242025 <- 
  goalie_edge_save_percentage(
    player    = 8478406,
    season    = 20242025,
    game_type = 2,
    category  = 'L'
  )
```
