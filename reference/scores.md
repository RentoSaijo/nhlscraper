# Access the scores for a date

`scores()` retrieves the scores for a date as a `data.frame` where each
row represents game and includes detail on game timeline state,
period/clock progression, and matchup flow, date/season filtering
windows and chronological context, and team identity, affiliation, and
matchup-side context.

## Usage

``` r
scores(date = "now")
```

## Arguments

- date:

  character in 'YYYY-MM-DD' (e.g., '2025-01-01'); see
  [`seasons()`](https://rentosaijo.github.io/nhlscraper/reference/seasons.md)
  for reference

## Value

data.frame with one row per game

## Examples

``` r
scores_Halloween_2025 <- scores(date = '2025-10-31')
```
