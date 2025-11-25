# Access the skater statistics leaders for a season, game type, and category

`get_skater_leaders()` is deprecated. Use
[`skater_leaders()`](https://rentosaijo.github.io/nhlscraper/reference/skater_leaders.md)
instead.

## Usage

``` r
get_skater_leaders(season = "current", game_type = "", category = "points")
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

- game_type:

  integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 =
  playoff/post-season) OR character of 'pre', 'regular', or
  playoff'/'post'; see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference; most functions will NOT support pre-season

- category:

  character of 'assists', 'goals', 'goalsSh', 'goalsPp', 'points,
  'penaltyMins', 'toi', 'plusMinus', or 'faceoffLeaders'

## Value

data.frame with one row per player
