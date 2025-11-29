# Draw a circular arc on the rink

`rink_draw_arc()` draws a circular arc using base graphics, typically as
a helper for the rounded rink corners.

## Usage

``` r
rink_draw_arc(cx, cy, r, theta1, theta2, n = 100, col = "black", lwd = 1)
```

## Arguments

- cx:

  Numeric scalar giving the x-coordinate of the circle centre from which
  the arc is taken.

- cy:

  Numeric scalar giving the y-coordinate of the circle centre from which
  the arc is taken.

- r:

  Numeric scalar giving the radius of the underlying circle (in rink
  coordinate units).

- theta1, theta2:

  Numeric scalars giving the start and end angles of the arc, in
  radians, measured in the usual mathematical sense (counterclockwise
  from the positive x-axis).

- n:

  Integer number of points used to approximate the arc. Larger values
  produce smoother arcs. Default is `100`.

- col:

  Character or colour value passed to
  [`graphics::lines()`](https://rdrr.io/r/graphics/lines.html) for the
  arc outline. Default is `'black'`.

- lwd:

  Numeric line width passed to
  [`graphics::lines()`](https://rdrr.io/r/graphics/lines.html). Default
  is `1`.

## Value

Invisibly returns `NULL`. Called for its side effect of drawing an arc
on the current graphics device.

## See also

[`rink_draw_circle()`](https://rentosaijo.github.io/nhlscraper/reference/rink_draw_circle.md),
[`plot_full_rink()`](https://rentosaijo.github.io/nhlscraper/reference/plot_full_rink.md)
