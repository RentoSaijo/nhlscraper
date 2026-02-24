# Save an Instagram (IG) share-able cumulative expected goals (xG) time-series plot for a game

`ig_game_cumulative_expected_goals()` saves an IG share-able cumulative
xG time-series plot for a given `game` as a PNG.

## Usage

``` r
ig_game_cumulative_expected_goals(game = 2023030417, model = 1, save = TRUE)

ig_game_cum_xG(game = 2023030417, model = 1)
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

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
ig_game_cumulative_expected_goals(
  game  = 2023030417, 
  model = 1, 
  save  = FALSE
)
```
