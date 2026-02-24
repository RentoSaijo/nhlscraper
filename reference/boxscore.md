# Access the boxscore for a game, team, and position

`boxscore()` retrieves the boxscore for a game, team, and position as a
`data.frame` where each row represents player and includes detail on
player identity, role, handedness, and biographical profile plus
production, workload, efficiency, and result-level performance outcomes.

## Usage

``` r
boxscore(game = 2023030417, team = "home", position = "forwards")
```

## Arguments

- game:

  integer ID (e.g., 2025020275); see
  [`games()`](https://rentosaijo.github.io/nhlscraper/reference/games.md)
  for reference

- team:

  character of 'h'/'home' or 'a'/'away'

- position:

  character of 'f'/'forwards', 'd'/'defensemen', or 'g'/'goalies'

## Value

data.frame with one row per player

## Examples

``` r
boxscore_COL_forwards_Martin_Necas_legacy_game <- boxscore(
  game     = 2025020275,
  team     = 'H',
  position = 'F'
)
```
