# Save an Instagram (IG) shareable cumulative expected goals (xG) plot

`ig_game_cumulative_expected_goals()` fetches one GameCenter
play-by-play, scores shot attempts with
[`calculate_expected_goals()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals.md),
and renders a home/away cumulative xG time series on a 1080-by-566-style
PNG canvas.

## Usage

``` r
ig_game_cumulative_expected_goals(game = 2023030417, model = NULL, save = TRUE)

ig_game_cum_xG(game = 2023030417, model = NULL)
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
ig_game_cumulative_expected_goals(
  game  = 2023030417,
  save  = FALSE
)
```
