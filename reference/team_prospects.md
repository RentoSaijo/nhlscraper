# Access the prospects for a team and position

`team_prospects()` retrieves the prospects for a team and position as a
`data.frame` where each row represents player and includes detail on
player identity, role, handedness, and biographical profile.

## Usage

``` r
team_prospects(team = 1, position = "forwards")
```

## Arguments

- team:

  integer ID (e.g., 21), character full name (e.g., 'Colorado
  Avalanche'), OR three-letter code (e.g., 'COL'); see
  [`teams()`](https://rentosaijo.github.io/nhlscraper/reference/teams.md)
  for reference; ID is preferable as there now exists duplicate
  three-letter codes (i.e., 'UTA' for 'Utah Hockey Club' and 'Utah
  Mammoth')

- position:

  character of 'f'/'forwards', 'd'/'defensemen', or 'g'/'goalies'

## Value

data.frame with one row per player

## Examples

``` r
COL_forward_prospects <- team_prospects(
  team     = 21,
  position = 'F'
)
```
