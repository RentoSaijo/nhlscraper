# Save an Instagram (IG) share-able shot summary for a game

`ig_game_shot_location_summary()` saves an IG share-able shot summary
for a game as a PNG.

## Usage

``` r
ig_game_shot_location_summary(game = 2023030417, team = "home", model = 1)
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

- team:

  character of 'h'/'home' or 'a'/'away'

- model:

  integer in 1:3 indicating which expected goals model to use (e.g., 1);
  see
  [`calculate_expected_goals_v1()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals_v1.md),
  [`calculate_expected_goals_v2()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals_v2.md),
  and/or
  [`calculate_expected_goals_v3()`](https://rentosaijo.github.io/nhlscraper/reference/calculate_expected_goals_v3.md)
  for reference

## Value

`NULL`

## Examples

``` r
# Saves PNG file, so skip.
ig_game_shot_location_summary(2023030417, model = 1, team = 'H')
```
