# Save an X (Twitter) shareable shot-location plot for a game

`x_game_shot_locations()` is the X/Twitter-sized companion to
[`ig_game_shot_locations()`](https://rentosaijo.github.io/nhlscraper/reference/ig_game_shot_locations.md).
It uses the same xG-scored shot map and legend logic on a
1200-by-675-style canvas.

## Usage

``` r
x_game_shot_locations(
  game = 2023030417,
  team = "home",
  model = NULL,
  save = TRUE
)

x_game_shot_locs(game = 2023030417, team = "home", model = NULL)
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

- team:

  character of 'h'/'home' or 'a'/'away'

- model:

  deprecated legacy model selector; ignored

- save:

  logical; use `FALSE` to draw on the active graphics device during
  tests or custom workflows

## Value

`NULL`, invisibly

## Examples

``` r
# May take >5s, so skip.
x_game_shot_locations(
  game  = 2023030417,
  team  = 'H',
  save  = FALSE
)
```
