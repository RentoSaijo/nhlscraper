# Draw a circle on the rink

`rink_draw_circle()` draws a circle using base graphics, typically as a
helper for rink outlines or faceoff circles.

## Usage

``` r
rink_draw_circle(x, y, r, n = 200, col = "black", lwd = 1)
```

## Arguments

- x:

  Numeric scalar giving the x-coordinate of the circle centre.

- y:

  Numeric scalar giving the y-coordinate of the circle centre.

- r:

  Numeric scalar giving the radius of the circle (in rink coordinate
  units).

- n:

  Integer number of points used to approximate the circle. Larger values
  produce smoother circles at the cost of more drawing operations.
  Default is `200`.

- col:

  Character or colour value passed to
  [`graphics::lines()`](https://rdrr.io/r/graphics/lines.html) for the
  circle outline. Default is `'black'`.

- lwd:

  Numeric line width passed to
  [`graphics::lines()`](https://rdrr.io/r/graphics/lines.html). Default
  is `1`.

## Value

Invisibly returns `NULL`. Called for its side effect of drawing a circle
on the current graphics device.

## See also

[`rink_draw_arc()`](https://rentosaijo.github.io/nhlscraper/reference/rink_draw_arc.md),
[`plot_full_rink()`](https://rentosaijo.github.io/nhlscraper/reference/plot_full_rink.md)
