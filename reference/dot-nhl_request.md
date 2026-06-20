# Build an NHL API request

`.nhl_request()` selects the requested NHL API host and constructs a
retrying request object. It is used by public wrappers that need to
fetch requests in parallel before parsing the body.

## Usage

``` r
.nhl_request(path, query = list(), type)
```

## Arguments

- path:

  character

- query:

  list

- type:

  character of 'w' for web, 's' for stats, and 'r' for records

## Value

httr2 request object
