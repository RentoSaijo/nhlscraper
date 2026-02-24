# Access the configurations for skater reports

`skater_report_configurations()` retrieves the configurations for skater
reports as a nested `list` that separates summary and detail blocks for
production, workload, efficiency, and result-level performance outcomes,
situational splits across home/road, strength state, and
overtime/shootout states, and configuration catalogs for valid report
categories and filters.

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
