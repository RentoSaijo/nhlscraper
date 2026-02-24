# Access the configurations for team reports

`team_report_configurations()` retrieves the configurations for team
reports as a nested `list` that separates summary and detail blocks for
situational splits across home/road, strength state, and
overtime/shootout states plus configuration catalogs for valid report
categories and filters.

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
