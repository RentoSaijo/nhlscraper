#' Draw a circle on the rink
#'
#' `draw_rink_circle()` draws a circle on the rink.
#'
#' @param x numeric x coordinate of the circle center
#' @param y numeric y coordinate of the circle center
#' @param r numeric radius
#' @param n integer number of points used to approximate circle
#' @param col character color
#' @param lwd numeric line width
#' @returns `NULL`
#' @keywords internal

draw_rink_circle <- function(x, y, r, n = 200, col = 'black', lwd = 1) {
  theta <- seq(0, 2 * pi, length.out = n)
  graphics::lines(x + r * cos(theta), y + r * sin(theta), col = col, lwd = lwd)
}

#' Draw an arc on the rink
#'
#' `draw_rink_arc()` draws an arc on the rink.
#'
#' @param cx numeric x coordinate of the circle center
#' @param cy numeric y coordinate of the circle center
#' @param r numeric radius
#' @param theta1 numeric start angle of arc
#' @param theta2 numeric end angle of arc
#' @param n integer number of points used to approximate arc
#' @param col character color
#' @param lwd numeric line width
#' @returns `NULL`
#' @keywords internal

draw_rink_arc <- function(
  cx, cy, r, theta1, theta2, n = 100, col = 'black', lwd = 1
) {
  theta <- seq(theta1, theta2, length.out = n)
  graphics::lines(
    cx + r * cos(theta), cy + r * sin(theta), 
    col = col, lwd = lwd
  )
}

#' Draw a full NHL rink
#'
#' `draw_NHL_rink()` draws a full NHL rink such that the x and y coordinates 
#' span -100 to 100 and -43 to +43, respectively. Use [graphics::points()] 
#' to create custom graphs; check out an example on the online documentation!
#'
#' @returns `NULL`
#' @examples
#' draw_NHL_rink()
#' @export

draw_NHL_rink <- function() {
  old_par <- graphics::par(
    xaxs = 'r',
    yaxs = 'r',
    mar  = c(1, 1, 3, 1),
    oma  = c(0, 0, 0, 0)
  )
  on.exit(graphics::par(old_par))
  plot(
    NA, NA,
    xlim = c(-100, 100),
    ylim = c(-43, 43),
    asp  = 1,
    xlab = '',
    ylab = '',
    axes = FALSE
  )
  board_col          <- 'black'
  center_line_col    <- 'red'
  blue_line_col      <- 'blue'
  goal_line_col      <- 'red'
  faceoff_center_col <- 'blue'
  faceoff_other_col  <- 'red'
  crease_col         <- 'blue'
  line_lwd <- 1
  x_min <- -100
  x_max <-  100
  y_min <- -43
  y_max <-  43
  corner_r <- 28
  straight_top_bottom_x <- 100 - corner_r
  straight_side_y       <- 43  - corner_r
  goal_line   <- 89
  blue_line   <- 25
  center_line <- 0
  circle_r <- 15
  off_x    <- 69
  off_y    <- 22
  cx_right <- x_max - corner_r
  cx_left  <- x_min + corner_r
  cy_top   <- y_max - corner_r
  cy_bot   <- y_min + corner_r
  graphics::segments(
    center_line, y_min, center_line, y_max,
    col = center_line_col, lwd = line_lwd
  )
  graphics::segments(
    blue_line, y_min,  blue_line, y_max,
    col = blue_line_col, lwd = line_lwd
  )
  graphics::segments(
    -blue_line, y_min, -blue_line, y_max,
    col = blue_line_col, lwd = line_lwd
  )
  dx_goal  <- goal_line - cx_right
  dy_goal  <- sqrt(corner_r^2 - dx_goal^2)
  y_goal_top    <- cy_top + dy_goal
  y_goal_bottom <- cy_bot - dy_goal
  graphics::segments(
    goal_line,  y_goal_bottom,  goal_line,  y_goal_top,
    col = goal_line_col, lwd = line_lwd
  )
  graphics::segments(
    -goal_line,  y_goal_bottom, -goal_line,  y_goal_top,
    col = goal_line_col, lwd = line_lwd
  )
  draw_rink_circle(
    0, 0, circle_r,
    col = faceoff_center_col, lwd = line_lwd
  )
  draw_rink_circle(
    off_x,  off_y, circle_r,
    col = faceoff_other_col, lwd = line_lwd
  )
  draw_rink_circle(
    off_x, -off_y, circle_r,
    col = faceoff_other_col, lwd = line_lwd
  )
  draw_rink_circle(
    -off_x,  off_y, circle_r,
    col = faceoff_other_col, lwd = line_lwd
  )
  draw_rink_circle(
    -off_x, -off_y, circle_r,
    col = faceoff_other_col, lwd = line_lwd
  )
  crease_r <- 6
  theta <- seq(-pi / 2, pi / 2, length.out = 200)
  graphics::lines(
    goal_line - crease_r * cos(theta),
    0         + crease_r * sin(theta),
    col = crease_col,
    lwd = line_lwd
  )
  graphics::lines(
    -goal_line + crease_r * cos(theta),
    0          + crease_r * sin(theta),
    col = crease_col,
    lwd = line_lwd
  )
  graphics::segments(
    -straight_top_bottom_x,  y_max, straight_top_bottom_x,  y_max,
    col = board_col, lwd = line_lwd
  )
  graphics::segments(
    -straight_top_bottom_x,  y_min, straight_top_bottom_x,  y_min,
    col = board_col, lwd = line_lwd
  )
  graphics::segments(
    x_min, -straight_side_y, x_min, straight_side_y,
    col = board_col, lwd = line_lwd
  )
  graphics::segments(
    x_max, -straight_side_y, x_max,  straight_side_y,
    col = board_col, lwd = line_lwd
  )
  draw_rink_arc(
    cx_right, cy_top, corner_r, theta1 = pi / 2, theta2 = 0,
    col = board_col, lwd = line_lwd
  )
  draw_rink_arc(
    cx_left, cy_top, corner_r, theta1 = pi / 2, theta2 = pi,
    col = board_col, lwd = line_lwd
  )
  draw_rink_arc(
    cx_left, cy_bot, corner_r, theta1 = pi, theta2 = 3 * pi / 2,
    col = board_col, lwd = line_lwd
  )
  draw_rink_arc(
    cx_right, cy_bot, corner_r, theta1 = 3 * pi / 2, theta2 = 2 * pi,
    col = board_col, lwd = line_lwd
  )
  invisible(NULL)
}
