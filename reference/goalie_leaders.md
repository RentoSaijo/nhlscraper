# Access the goalie statistics leaders for a season, game type, and category

`goalie_leaders()` scrapes the goalie statistics leaders for a given set
of `season`, `game_type`, and `category`.

## Usage

``` r
goalie_leaders(season = "current", game_type = "", category = "wins")
```

## Arguments

- season:

  integer in YYYYYYYY (e.g., 20242025); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

- game_type:

  integer in 1:3 (where 1 = pre-season, 2 = regular season, 3 =
  playoff/post-season) OR character of 'pre', 'regular', or
  playoff'/'post'; see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference; most functions will NOT support pre-season

- category:

  character of 'w'/'wins', 's'/shutouts', 's%'/'sP'/'save %'/'save
  percentage', or 'gaa'/'goals against average'

## Value

data.frame with one row per player

## Examples

``` r
GAA_leaders_regular_20242025 <- goalie_leaders(
  season    = 20242025,
  game_type = 2,
  category  = 'GAA'
)
```
