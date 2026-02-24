# Access the game log for a player, season, and game type

`player_game_log()` retrieves the game log for a player, season, and
game type as a `data.frame` where each row represents game and includes
detail on game timeline state, period/clock progression, and matchup
flow plus production, workload, efficiency, and result-level performance
outcomes.

## Usage

``` r
player_game_log(player = 8478402, season = "now", game_type = "")
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

## Examples

``` r
Martin_Necas_game_log_regular_20242025 <- player_game_log(
  player    = 8480039,
  season    = 20242025,
  game_type = 2
)
```
