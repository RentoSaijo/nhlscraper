# Access the summary for a player

`player_summary()` retrieves the summary for a player as a nested `list`
that separates summary and detail blocks for player identity, role,
handedness, and biographical profile.

## Usage

``` r
player_summary(player = 8478402)
```

## Arguments

- player:

  integer ID (e.g., 8480039); see
  [`players()`](https://rentosaijo.github.io/nhlscraper/reference/players.md)
  for reference

## Value

list with various items

## Examples

``` r
Martin_Necas_summary <- player_summary(player = 8480039)
```
