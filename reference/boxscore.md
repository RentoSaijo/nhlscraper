# Access the boxscore for a game, team, and position

`boxscore()` scrapes the boxscore for a given set of `game`, `team`, and
`position`.

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
