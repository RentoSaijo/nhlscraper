# Access the summary for a player

`player_summary()` scrapes the summary for a given `player`.

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
