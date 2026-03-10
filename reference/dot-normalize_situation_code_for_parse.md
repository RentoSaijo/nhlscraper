# Normalize situation codes for parsing

`.normalize_situation_code_for_parse()` pads 1-4 digit situation codes
to four characters for internal parsing without rewriting the source
column.

## Usage

``` r
.normalize_situation_code_for_parse(situation_code)
```

## Arguments

- situation_code:

  vector of raw situation codes

## Value

character vector of parse-ready situation codes
