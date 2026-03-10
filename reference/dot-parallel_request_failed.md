# Check whether a parallel request failed

`.parallel_request_failed()` returns `TRUE` when a response object from
[`.perform_parallel_requests()`](https://rentosaijo.github.io/nhlscraper/reference/dot-perform_parallel_requests.md)
is an httr2 failure.

## Usage

``` r
.parallel_request_failed(resp)
```

## Arguments

- resp:

  response or failure object

## Value

logical scalar
