# Save an X (Twitter) shareable cumulative expected goals (xG) plot

`x_game_cumulative_expected_goals()` is the X/Twitter-sized companion to
[`ig_game_cumulative_expected_goals()`](https://rentosaijo.github.io/nhlscraper/reference/ig_game_cumulative_expected_goals.md).
It uses the same xG-scored cumulative series on a 1200-by-675-style
canvas.

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

  logical; use `FALSE` to draw on the active graphics device during
  tests or custom workflows

## Value

`NULL`, invisibly

## Examples

``` r
# May take >5s, so skip.
x_game_cumulative_expected_goals(
  game  = 2023030417,
  save  = FALSE
)
```
