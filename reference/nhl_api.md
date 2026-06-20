# Call the NHL API

`nhl_api()` performs a retrying request against one of the NHL API hosts
and parses the JSON response with the package's standard flattening
rules.

## Usage

``` r
nhl_api(path, query = list(), type)
```

## Arguments

- path:

  character path relative to the selected API host

- query:

  named list of URL query parameters

- type:

  character of 'w' for the web API, 's' for the stats API, or 'r' for
  the records API

## Value

parsed JSON object, usually a data.frame or nested list
