# Access the configurations for team reports

`team_report_configurations()` returns the team-report configuration
block from the stats API, including valid report categories, fields,
filters, and split options accepted by
[`team_season_report()`](https://rentosaijo.github.io/nhlscraper/reference/team_season_report.md)
and
[`team_game_report()`](https://rentosaijo.github.io/nhlscraper/reference/team_game_report.md).

## Usage

``` r
team_report_configurations()

team_report_configs()
```

## Value

list with various items

## Examples

``` r
team_report_configs <- team_report_configurations()
```
