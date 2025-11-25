# Access the game log for a player, season, and game type

`get_player_game_log()` is deprecated. Use
[`player_game_log()`](https://rentosaijo.github.io/nhlscraper/reference/player_game_log.md)
instead.

## Usage

``` r
get_player_game_log(player = 8478402, season = "now", game_type = "")
```

## Arguments

- player:

  integer ID (e.g., 8480039); see
  [`players()`](https://rentosaijo.github.io/nhlscraper/reference/players.md)
  for reference

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

## Value

data.frame with one row per game
