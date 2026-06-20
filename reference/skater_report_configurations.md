# Access the configurations for skater reports

`skater_report_configurations()` returns the skater-report configuration
block from the stats API, including valid report categories, fields,
filters, and split options accepted by
[`skater_season_report()`](https://rentosaijo.github.io/nhlscraper/reference/skater_season_report.md)
and
[`skater_game_report()`](https://rentosaijo.github.io/nhlscraper/reference/skater_game_report.md).

## Usage

``` r
skater_report_configurations()

skater_report_configs()
```

## Value

list with various items

## Examples

``` r
skater_report_configs <- skater_report_configurations()
```
