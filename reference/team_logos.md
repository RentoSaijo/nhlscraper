# Access all the team logos

`team_logos()` returns records-site logo metadata with one row per team
logo interval, including team ID, logo URL fields, and start/end season
IDs.

## Usage

``` r
team_logos()
```

## Value

data.frame with one row per logo

## Examples

``` r
all_team_logos <- team_logos()
```
