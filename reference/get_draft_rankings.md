# Access the draft rankings for a year and player type

`get_draft_rankings()` is deprecated. Use
[`draft_rankings()`](https://rentosaijo.github.io/nhlscraper/reference/draft_rankings.md)
instead.

## Usage

``` r
get_draft_rankings(year = season_now()%/%10000, player_type = 1)
```

## Arguments

- year:

  integer in YYYY (e.g., 2017); see
  [`drafts()`](https://rentosaijo.github.io/nhlscraper/reference/drafts.md)
  for reference

- player_type:

  integer in 1:4 (where 1 = North American Skaters, 2 = International
  Skaters, 3 = North American Goalies, and 4 = International Goalies)

## Value

data.frame with one row per player
