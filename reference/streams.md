# Access all the streams

`streams()` returns the public "where to watch" payload for the current
region, including broadcast/streaming providers when the endpoint is
available.

## Usage

``` r
streams()
```

## Value

data.frame with one row per stream

## Examples

``` r
all_streams <- streams()
```
