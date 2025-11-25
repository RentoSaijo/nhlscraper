# Access the EDGE summary for a skater, season, and game type

`skater_edge_summary()` scrapes the EDGE summary for a given set of
`skater`, `season`, and `game_type`.

## Usage

``` r
skater_edge_summary(player = 8478402, season = "now", game_type = "")
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

## Value

list of various items

## Examples

``` r
Martin_Necas_EDGE_summary_regular_20242025 <- skater_edge_summary(
  player    = 8480039, 
  season    = 20242025,
  game_type = 2
)
```
