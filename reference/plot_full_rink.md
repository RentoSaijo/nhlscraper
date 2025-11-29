# Draw a full NHL rink using base graphics

`plot_full_rink()` opens a blank plotting region with NHL rink
coordinates and draws a full rink outline using base graphics. The
centre line, blue lines, goal lines, faceoff circles and creases, and
rounded corners are all drawn at NHL-standard locations (in feet,
centred at centre ice).

## Usage

``` r
plot_full_rink()
```

## Value

Invisibly returns `NULL`. Called for its side effect of creating an
empty full-rink plot on the current graphics device.

## Details

The function sets up a square-aspect plotting window with x-limits
`[-100, 100]` and y-limits `[-43, 43]`, hides axes and labels, and draws
the boards and markings. It temporarily adjusts graphical parameters and
restores them on exit.

The coordinate system assumes the origin at centre ice, with the x-axis
running from one end board to the other and the y-axis running from side
board to side board. Distances are drawn in feet and are intended to
match common NHL rink dimensions.

## Examples

``` r
# \donttest{
  plot_full_rink()

# }
```
