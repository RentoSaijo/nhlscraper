# Save an X (Twitter) share-able cumulative expected goals (xG) time-series plot for a game

`x_game_cumulative_expected_goals()` saves an X share-able cumulative xG
time-series plot for a given `game` as a PNG.

## Usage

``` r
x_game_cumulative_expected_goals(game = 2023030417, model = NULL, save = TRUE)

x_game_cum_xG(game = 2023030417, model = NULL)
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

- model:

  deprecated legacy model selector; ignored

- save:

  logical only FALSE for tests

## Value

`NULL`

## Examples

``` r
# May take >5s, so skip.
x_game_cumulative_expected_goals(
  game  = 2023030417, 
  save  = FALSE
)
```
