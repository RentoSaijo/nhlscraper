# Call the NHL API with 429 (rate limit) error-handling

Call the NHL API with 429 (rate limit) error-handling

## Usage

``` r
nhl_api(path, query = list(), type)
```

## Arguments

- path:

  character

- query:

  list

- type:

  character of 'w' for web, 's' for stats, and 'r' for records

## Value

parsed JSON (i.e., data.frame or list)
