# Access the skater statistics leaders for a season, game type, and category

`skater_leaders()` scrapes the skater statistics leaders for a given set
of `season`, `game_type`, and `category`.

## Usage

``` r
skater_leaders(season = "current", game_type = "", category = "points")
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

  string of 'a'/'assists', 'g'/goals', 'shg'/'shorthanded goals',
  'ppg'/'powerplay goals', 'p'/'points', 'pim'/penalty minutes'/'penalty
  infraction minutes', 'toi'/'time on ice', 'pm'/'plus minus', or
  'f'/'faceoffs'

## Value

data.frame with one row per player

## Examples

``` r
TOI_leaders_regular_20242025 <- skater_leaders(
  season    = 20242025,
  game_type = 2,
  category  = 'TOI'
)
```
