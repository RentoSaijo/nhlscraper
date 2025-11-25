# Access the boxscore for a game, team, and player type

`get_game_boxscore()` is deprecated. Use
[`boxscore()`](https://rentosaijo.github.io/nhlscraper/reference/boxscore.md)
instead.

## Usage

``` r
get_game_boxscore(game = 2023030417, team = "home", player_type = "forwards")
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

- team:

  character of 'home' or 'away'

- player_type:

  character of 'forwards', 'defense', or 'goalies'

## Value

data.frame with one row per player
