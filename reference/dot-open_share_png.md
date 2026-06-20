# Open a PNG device for a share plot

`.open_share_png()` opens the output device only when `save` is `TRUE`.

## Usage

``` r
.open_share_png(file_name, spec, save)
```

## Arguments

- file_name:

  character output file name

- spec:

  list returned by
  [`.share_plot_spec()`](https://rentosaijo.github.io/nhlscraper/reference/dot-share_plot_spec.md)

- save:

  logical

## Value

logical indicating whether a device was opened
