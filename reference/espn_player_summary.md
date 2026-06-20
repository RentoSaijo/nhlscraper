# Access the ESPN summary for a player

`espn_player_summary()` returns a compact one-row ESPN athlete profile
with name, birth, size, handedness, draft, debut, position, experience,
and active status fields.

## Usage

``` r
espn_player_summary(player = 3988803)
```

## Arguments

- player:

  integer ID (e.g., 3988803); see
  [`espn_players()`](https://rentosaijo.github.io/nhlscraper/reference/espn_players.md)
  for reference

## Value

data.frame with one row

## Examples

``` r
ESPN_summary_Charlie_McAvoy <- espn_player_summary(player = 3988803)
```
