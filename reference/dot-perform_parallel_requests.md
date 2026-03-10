# Perform multiple requests concurrently

`.perform_parallel_requests()` executes a list of `httr2` requests with
libcurl multi support and preserves the input names on the output.

## Usage

``` r
.perform_parallel_requests(reqs, on_error = c("stop", "return", "continue"))
```

## Arguments

- reqs:

  list of httr2 request objects

- on_error:

  forwarded to
  [`httr2::req_perform_parallel()`](https://httr2.r-lib.org/reference/req_perform_parallel.html)

## Value

list of responses or httr2 failure objects
