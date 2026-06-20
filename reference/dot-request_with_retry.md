# Add the package retry policy to a request

`.request_with_retry()` retries transient 429 rate-limit responses with
a short exponential backoff.

## Usage

``` r
.request_with_retry(req)
```

## Arguments

- req:

  httr2 request object

## Value

httr2 request object
