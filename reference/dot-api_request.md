# Build a retrying API request

`.api_request()` appends URL query parameters to a host/path pair and
applies the package retry policy.

## Usage

``` r
.api_request(base_url, path, query = list())
```

## Arguments

- base_url:

  character API host

- path:

  character path relative to `base_url`

- query:

  named list of URL query parameters

## Value

httr2 request object
