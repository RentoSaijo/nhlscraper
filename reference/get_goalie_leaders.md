# Access the goalie statistics leaders for a season, game type, and category

`get_goalie_leaders()` is deprecated. Use
[`goalie_leaders()`](https://rentosaijo.github.io/nhlscraper/reference/goalie_leaders.md)
instead.

## Usage

``` r
get_goalie_leaders(season = "current", game_type = "", category = "wins")
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

  character of 'wins', 'shutouts', 'savePctg', or 'goalsAgainstAverage'

## Value

data.frame with one row per player
