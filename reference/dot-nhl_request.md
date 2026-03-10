# Build an NHL API request

`.nhl_request()` constructs an NHL API request with the standard retry
policy used throughout the package.

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
