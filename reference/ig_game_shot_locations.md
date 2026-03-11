# Save an Instagram (IG) share-able shot-location plot for a game

`ig_game_shot_locations()` saves an IG share-able shot location plot for
a given `game`.

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

  logical only FALSE for tests

## Value

`NULL`

## Examples

``` r
# May take >5s, so skip.
ig_game_shot_locations(
  game  = 2023030417, 
  team  = 'H', 
  save  = FALSE
)
```
