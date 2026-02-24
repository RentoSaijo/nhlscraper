# Access the configurations for goalie reports

`goalie_report_configurations()` retrieves the configurations for goalie
reports as a nested `list` that separates summary and detail blocks for
situational splits across home/road, strength state, and
overtime/shootout states plus configuration catalogs for valid report
categories and filters.

## Usage

``` r
goalie_report_configurations()

goalie_report_configs()
```

## Value

list with various items

## Examples

``` r
goalie_report_configs <- goalie_report_configurations()
```
