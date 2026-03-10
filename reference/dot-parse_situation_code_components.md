# Parse situation-code components

`.parse_situation_code_components()` converts situation codes into
away/home goalie and skater counts without mutating the original source
vector.

## Usage

``` r
.parse_situation_code_components(situation_code)
```

## Arguments

- situation_code:

  vector of raw situation codes

## Value

integer matrix with away/home goalie and skater counts
