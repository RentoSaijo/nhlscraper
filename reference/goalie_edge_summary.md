# Access the EDGE summary for a goalie, season, and game type

`goalie_edge_summary()` retrieves the EDGE summary for a goalie, season,
and game type as a nested `list` that separates summary and detail
blocks for player identity, role, handedness, and biographical profile
plus NHL EDGE style tracking outputs and relative-performance context.

## Usage

``` r
goalie_edge_summary(player = 8476945, season = "now", game_type = "")
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

## Value

list of various items

## Examples

``` r
Mackenzie_Blackwood_EDGE_summary_regular_20242025 <- goalie_edge_summary(
  player    = 8478406, 
  season    = 20242025,
  game_type = 2
)
```
