# Access all the ESPN teams

`espn_teams()` pages ESPN's team index and returns one row per team
containing the ESPN team ID used by
[`espn_team_summary()`](https://rentosaijo.github.io/nhlscraper/reference/espn_team_summary.md).

## Usage

``` r
espn_teams()
```

## Value

data.frame with one row per ESPN team

## Examples

``` r
all_ESPN_teams <- espn_teams()
```
