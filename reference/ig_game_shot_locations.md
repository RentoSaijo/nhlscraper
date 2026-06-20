# Save an Instagram (IG) shareable shot-location plot for a game

`ig_game_shot_locations()` fetches one GameCenter play-by-play, scores
its shot attempts with
[`calculate_expected_goals()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals.md),
filters to the selected home or away team, and renders a
1080-by-566-style PNG shot map. Points are jittered for readability,
shaped by event result, and colored by capped xG.

## Usage

``` r
ig_game_shot_locations(
  game = 2023030417,
  team = "home",
  model = NULL,
  save = TRUE
)

ig_game_shot_locs(game = 2023030417, team = "home", model = NULL)
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
ig_game_shot_locations(
  game  = 2023030417,
  team  = 'H',
  save  = FALSE
)
```
