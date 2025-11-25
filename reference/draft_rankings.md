# Access the draft rankings for a class and category

`draft_rankings()` scrapes the draft rankings for a given set of `class`
and `category`.

## Usage

``` r
draft_rankings(class = season_now()%%10000, category = 1)
```

## Arguments

- class:

  integer in YYYY (e.g., 2017); see
  [`drafts()`](https://rentosaijo.github.io/nhlscraper/reference/drafts.md)
  for reference

- category:

  integer in 1:4 (where 1 = North American Skaters, 2 = International
  Skaters, 3 = North American Goalies, and 4 = International Goalies) OR
  character of 'NAS'/'NA Skaters'/'North American Skaters',
  'INTLS'/'INTL Skaters'/'International Skaters', 'NAG'/'NA
  Goalies'/'North American Goalies', 'INTLG'/'INTL
  Goalies'/'International Goalies'

## Value

data.frame with one row per player

## Examples

``` r
draft_rankings_INTL_Skaters_2017 <- draft_rankings(
  class    = 2017, 
  category = 2
)
```
