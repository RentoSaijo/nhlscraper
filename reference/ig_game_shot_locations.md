# Save an Instagram (IG) share-able shot-location plot for a game

`ig_game_shot_locations()` saves an IG share-able shot location plot for
a given `game`.

## Usage

``` r
ig_game_shot_locations(
  game = 2023030417,
  team = "home",
  model = 1,
  save = TRUE
)

ig_game_shot_locs(game = 2023030417, team = "home", model = 1)
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

- team:

  character of 'h'/'home' or 'a'/'away'

- model:

  integer in 1:4 indicating which expected goals model to use; see web
  documentation for what variables each version considers

- save:

  logical only FALSE for tests

## Value

`NULL`

## Examples

``` r
# May take >5s, so skip.
ig_game_shot_locations(
  game  = 2023030417, 
  model = 1, 
  team  = 'H', 
  save  = FALSE
)
#> Invalid argument(s); refer to help file.
```
