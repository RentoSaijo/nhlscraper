# Call the ESPN API

`.espn_api()` performs a retrying request against the ESPN site or core
API and parses the JSON response with the same flattening rules used for
NHL API calls.

## Usage

``` r
.espn_api(path, query = list(), type)
```

## Arguments

- path:

  character path relative to the selected ESPN API host

- query:

  named list of URL query parameters

- type:

  character of 'g' for the site API or 'c' for the core API

## Value

parsed JSON object, usually a data.frame or nested list
