rink_draw_circle <- function(x, y, r, n = 200, col = 'black', lwd = 1) {
  theta <- seq(0, 2 * pi, length.out = n)
  lines(x + r * cos(theta), y + r * sin(theta), col = col, lwd = lwd)
}

rink_draw_arc <- function(
  cx, cy, r, theta1, theta2, n = 100, col = 'black', lwd = 1
) {
  theta <- seq(theta1, theta2, length.out = n)
  lines(cx + r * cos(theta), cy + r * sin(theta), col = col, lwd = lwd)
}

plot_full_rink <- function() {
  old_par <- par(
    xaxs = 'r',
    yaxs = 'r',
    mar  = c(1, 1, 1, 1),
    oma  = c(0, 0, 0, 0)
  )
  on.exit(par(old_par))
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
  segments(
    center_line, y_min, center_line, y_max,
    col = center_line_col, lwd = line_lwd
  )
  segments(
    blue_line, y_min,  blue_line, y_max,
    col = blue_line_col, lwd = line_lwd
  )
  segments(
    -blue_line, y_min, -blue_line, y_max,
    col = blue_line_col, lwd = line_lwd
  )
  dx_goal  <- goal_line - cx_right
  dy_goal  <- sqrt(corner_r^2 - dx_goal^2)
  y_goal_top    <- cy_top + dy_goal
  y_goal_bottom <- cy_bot - dy_goal
  segments(
    goal_line,  y_goal_bottom,  goal_line,  y_goal_top,
    col = goal_line_col, lwd = line_lwd
  )
  segments(
    -goal_line,  y_goal_bottom, -goal_line,  y_goal_top,
    col = goal_line_col, lwd = line_lwd
  )
  rink_draw_circle(
    0, 0, circle_r,
    col = faceoff_center_col, lwd = line_lwd
  )
  rink_draw_circle(
    off_x,  off_y, circle_r,
    col = faceoff_other_col, lwd = line_lwd
  )
  rink_draw_circle(
    off_x, -off_y, circle_r,
    col = faceoff_other_col, lwd = line_lwd
  )
  rink_draw_circle(
    -off_x,  off_y, circle_r,
    col = faceoff_other_col, lwd = line_lwd
  )
  rink_draw_circle(
    -off_x, -off_y, circle_r,
    col = faceoff_other_col, lwd = line_lwd
  )
  crease_r <- 6
  theta <- seq(-pi / 2, pi / 2, length.out = 200)
  lines(
    goal_line - crease_r * cos(theta),
    0         + crease_r * sin(theta),
    col = crease_col,
    lwd = line_lwd
  )
  lines(
    -goal_line + crease_r * cos(theta),
    0          + crease_r * sin(theta),
    col = crease_col,
    lwd = line_lwd
  )
  segments(
    -straight_top_bottom_x,  y_max, straight_top_bottom_x,  y_max,
    col = board_col, lwd = line_lwd
  )
  segments(
    -straight_top_bottom_x,  y_min, straight_top_bottom_x,  y_min,
    col = board_col, lwd = line_lwd
  )
  segments(
    x_min, -straight_side_y, x_min, straight_side_y,
    col = board_col, lwd = line_lwd
  )
  segments(
    x_max, -straight_side_y, x_max,  straight_side_y,
    col = board_col, lwd = line_lwd
  )
  rink_draw_arc(
    cx_right, cy_top, corner_r, theta1 = pi / 2, theta2 = 0,
    col = board_col, lwd = line_lwd
  )
  rink_draw_arc(
    cx_left, cy_top, corner_r, theta1 = pi / 2, theta2 = pi,
    col = board_col, lwd = line_lwd
  )
  rink_draw_arc(
    cx_left, cy_bot, corner_r, theta1 = pi, theta2 = 3 * pi / 2,
    col = board_col, lwd = line_lwd
  )
  rink_draw_arc(
    cx_right, cy_bot, corner_r, theta1 = 3 * pi / 2, theta2 = 2 * pi,
    col = board_col, lwd = line_lwd
  )
  invisible(NULL)
}

plot_shots <- function(
    data,
    team                         = 1L,
    event_owner_team_id_name     = 'eventOwnerTeamId',
    type_description_name        = 'typeDescKey',
    x_coordinate_normalized_name = 'xCoordNorm',
    y_coordinate_normalized_name = 'yCoordNorm',
    expected_goals_name          = 'xG'
) {
  tryCatch(
    expr = {
      # Check columns exist
      needed <- c(event_owner_team_id_name,
                  type_description_name,
                  x_coordinate_normalized_name,
                  y_coordinate_normalized_name,
                  expected_goals_name)
      missing <- needed[!(needed %in% names(data))]
      if (length(missing) > 0L) {
        stop('Missing required column(s).')
      }
      
      # Extract columns
      owner_id <- data[[event_owner_team_id_name]]
      type     <- as.character(data[[type_description_name]])
      x        <- as.numeric(data[[x_coordinate_normalized_name]])
      y        <- as.numeric(data[[y_coordinate_normalized_name]])
      xg       <- as.numeric(data[[expected_goals_name]])
      
      # Filter: team + shot attempts
      shot_types <- c('goal', 'shot-on-goal', 'missed-shot', 'blocked-shot')
      
      team_match <- !is.na(owner_id) &
        as.character(owner_id) == as.character(team)
      
      shot_match <- !is.na(type) & type %in% shot_types
      
      idx <- team_match & shot_match & !is.na(x) & !is.na(y)
      
      if (!any(idx)) {
        message('No matching shots found for specified team / filters.')
        return(invisible(NULL))
      }
      
      x_shot  <- x[idx]
      y_shot  <- y[idx]
      xg_shot <- xg[idx]
      
      # Map xG to alpha (0.1–1.0), clamp xG to [0,1]
      xg_clamped <- pmax(pmin(xg_shot, 1), 0)
      alpha <- ifelse(
        is.na(xg_clamped),
        0.3,
        0.1 + 0.9 * xg_clamped
      )
      
      cols <- rgb(1, 0, 0, alpha = alpha)  # red, intensity by xG
      
      # Draw rink, then overlay shots
      plot_full_rink()
      points(x_shot, y_shot, pch = 16, col = cols, cex = 1)
      
      invisible(data[idx, , drop = FALSE])
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      invisible(NULL)
    }
  )
}

