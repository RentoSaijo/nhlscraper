#' Draw a circle on the rink
#'
#' `rink_draw_circle()` draws a circle using base graphics, typically as a
#' helper for rink outlines or faceoff circles.
#'
#' @param x Numeric scalar giving the x-coordinate of the circle centre.
#' @param y Numeric scalar giving the y-coordinate of the circle centre.
#' @param r Numeric scalar giving the radius of the circle (in rink
#'   coordinate units).
#' @param n Integer number of points used to approximate the circle. Larger
#'   values produce smoother circles at the cost of more drawing operations.
#'   Default is `200`.
#' @param col Character or colour value passed to [graphics::lines()] for the
#'   circle outline. Default is `'black'`.
#' @param lwd Numeric line width passed to [graphics::lines()]. Default is `1`.
#'
#' @return Invisibly returns `NULL`. Called for its side effect of drawing a
#'   circle on the current graphics device.
#'
#' @seealso [rink_draw_arc()], [plot_full_rink()]
#'
#' @keywords internal

rink_draw_circle <- function(x, y, r, n = 200, col = 'black', lwd = 1) {
  theta <- seq(0, 2 * pi, length.out = n)
  lines(x + r * cos(theta), y + r * sin(theta), col = col, lwd = lwd)
}

#' Draw a circular arc on the rink
#'
#' `rink_draw_arc()` draws a circular arc using base graphics, typically as a
#' helper for the rounded rink corners.
#'
#' @param cx Numeric scalar giving the x-coordinate of the circle centre
#'   from which the arc is taken.
#' @param cy Numeric scalar giving the y-coordinate of the circle centre
#'   from which the arc is taken.
#' @param r Numeric scalar giving the radius of the underlying circle (in rink
#'   coordinate units).
#' @param theta1,theta2 Numeric scalars giving the start and end angles of the
#'   arc, in radians, measured in the usual mathematical sense (counterclockwise
#'   from the positive x-axis).
#' @param n Integer number of points used to approximate the arc. Larger values
#'   produce smoother arcs. Default is `100`.
#' @param col Character or colour value passed to [graphics::lines()] for the
#'   arc outline. Default is `'black'`.
#' @param lwd Numeric line width passed to [graphics::lines()]. Default is `1`.
#'
#' @return Invisibly returns `NULL`. Called for its side effect of drawing an
#'   arc on the current graphics device.
#'
#' @seealso [rink_draw_circle()], [plot_full_rink()]
#'
#' @keywords internal

rink_draw_arc <- function(
  cx, cy, r, theta1, theta2, n = 100, col = 'black', lwd = 1
) {
  theta <- seq(theta1, theta2, length.out = n)
  lines(cx + r * cos(theta), cy + r * sin(theta), col = col, lwd = lwd)
}

#' Draw a full NHL rink using base graphics
#'
#' `plot_full_rink()` opens a blank plotting region with NHL rink coordinates
#' and draws a full rink outline using base graphics. The centre line, blue
#' lines, goal lines, faceoff circles and creases, and rounded corners are
#' all drawn at NHL-standard locations (in feet, centred at centre ice).
#'
#' The function sets up a square-aspect plotting window with x-limits
#' `[-100, 100]` and y-limits `[-43, 43]`, hides axes and labels, and draws the
#' boards and markings. It temporarily adjusts graphical parameters and restores
#' them on exit.
#'
#' @details
#' The coordinate system assumes the origin at centre ice, with the x-axis
#' running from one end board to the other and the y-axis running from side
#' board to side board. Distances are drawn in feet and are intended to match
#' common NHL rink dimensions.
#'
#' @return Invisibly returns `NULL`. Called for its side effect of creating an
#'   empty full-rink plot on the current graphics device.
#'
#' @examples
#' \donttest{
#'   plot_full_rink()
#' }
#'
#' @export

plot_full_rink <- function() {
  old_par <- par(
    xaxs = 'r',
    yaxs = 'r',
    mar  = c(1, 1, 3, 1),
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

#' Plot all shot attempts in a game on a full rink
#'
#' `plot_game_xG()` plots all shot attempts (goal, shot-on-goal, missed-shot,
#' blocked-shot) for a single game on a full NHL rink, colours them according
#' to an expected goals (xG) model, and saves the result as a PNG file.
#'
#' For the selected team (home or away), the function:
#' \itemize{
#'   \item loads play-by-play data via [gc_play_by_play()],
#'   \item flags which team is at home using [flag_is_home()],
#'   \item normalises coordinates with [normalize_coordinates()] so all shots
#'         attack toward +x,
#'   \item computes the chosen xG model via one of
#'         [calculate_expected_goals_v1()], [calculate_expected_goals_v2()],
#'         or [calculate_expected_goals_v3()],
#'   \item filters to events with `typeDescKey` equal to `'goal'`,
#'         `'shot-on-goal'`, `'missed-shot'`, or `'blocked-shot'`,
#'   \item jitters shot coordinates slightly to reduce overplotting, and
#'   \item draws a full rink via [plot_full_rink()] and overlays the shots.
#' }
#'
#' Shot marker shapes are:
#' \itemize{
#'   \item goal         – star (`pch = 8`),
#'   \item shot-on-goal – filled circle (`pch = 16`),
#'   \item missed-shot  – filled triangle (`pch = 17`),
#'   \item blocked-shot – filled square (`pch = 15`).
#' }
#'
#' Expected-goals values are binned into up to five game-specific ranges and
#' mapped to a blue-to-red palette, with low-xG attempts drawn in blue and
#' high-xG attempts in red. A title is constructed from [gc_summary()] using
#' the game date and team abbreviations, e.g.
#' `"2024-06-24 FLA Shots vs. EDM by Result and xG, jittered"`.
#'
#' The plot is written to a PNG file of fixed size (approximately 1080 x 566
#' pixels at 144 dpi) in the working directory. The filename has the form
#' `shots_{game}_{team}_xG_v{model}.png`, for example
#' `"shots_2023030417_home_xG_v1.png"`.
#'
#' @param game Integer or character game ID understood by [gc_play_by_play()]
#'   and [gc_summary()]. Default is `2023030417`.
#' @param model Integer indicating which expected goals model to use:
#'   `1L` for `xG_v1`, `2L` for `xG_v2`, `3L` for `xG_v3`. Default is `1L`.
#' @param team Character string indicating which team’s shots to plot,
#'   either `'home'` or `'away'` (case-insensitive). Default is `'home'`.
#'
#' @return Invisibly returns `NULL`. Called for its side effect of creating a
#'   PNG file in the working directory containing the rink and shot map.
#'
#' @examples
#' \donttest{
#'   # Home team, xG_v1
#'   plot_game_xG(2023030417, model = 1, team = 'home')
#'
#'   # Away team, xG_v2
#'   plot_game_xG(2023030417, model = 2, team = 'away')
#' }
#'
#' @export

plot_game_xG <- function(
    game  = 2023030417,
    model = 1L,
    team  = 'home'
) {
  model <- as.integer(model)
  team  <- tolower(team)
  
  if (!model %in% c(1L, 2L, 3L)) {
    stop('`model` must be 1, 2, or 3.')
  }
  if (!team %in% c('home', 'away')) {
    stop('`team` must be either "home" or "away".')
  }
  
  model_label <- paste0('xG_v', model)
  file_name <- sprintf(
    'shots_%s_%s_%s.png',
    as.character(game),
    team,
    model_label
  )
  
  tryCatch(
    expr = {
      game_sum <- gc_summary(game)
      home_abbrev <- tryCatch(
        game_sum$homeTeam$abbrev,
        error = function(e) 'HOME'
      )
      away_abbrev <- tryCatch(
        game_sum$awayTeam$abbrev,
        error = function(e) 'AWAY'
      )
      game_date <- tryCatch(
        as.character(game_sum$gameDate),
        error = function(e) ''
      )
      
      if (team == 'home') {
        shooting_abbrev <- home_abbrev
        opp_abbrev      <- away_abbrev
      } else {
        shooting_abbrev <- away_abbrev
        opp_abbrev      <- home_abbrev
      }
      
      if (nzchar(game_date)) {
        plot_title <- sprintf(
          '%s %s Shots vs. %s by Result and xG, jittered',
          game_date,
          shooting_abbrev,
          opp_abbrev
        )
      } else {
        plot_title <- sprintf(
          '%s Shots vs. %s by Result and xG, jittered',
          shooting_abbrev,
          opp_abbrev
        )
      }
      
      grDevices::png(
        filename = file_name,
        width    = 1080 * 1.25,
        height   = 566 * 1.25,
        res      = 144
      )
      on.exit(grDevices::dev.off(), add = TRUE)
      
      pbp <- gc_play_by_play(game)
      pbp <- flag_is_home(pbp)
      pbp <- normalize_coordinates(pbp)
      x_col <- 'xCoordNorm'
      y_col <- 'yCoordNorm'
      
      if (model == 1L) {
        pbp   <- calculate_expected_goals_v1(pbp)
        xg_col <- 'xG_v1'
      } else if (model == 2L) {
        pbp   <- calculate_expected_goals_v2(pbp)
        xg_col <- 'xG_v2'
      } else {
        pbp   <- calculate_expected_goals_v3(pbp)
        xg_col <- 'xG_v3'
      }
      
      type <- as.character(pbp[['typeDescKey']])
      shot_types <- c('goal', 'shot-on-goal', 'missed-shot', 'blocked-shot')
      idx_shot <- !is.na(type) & type %in% shot_types
      if (!any(idx_shot)) {
        message('No shot attempts found for this game.')
        return(invisible(NULL))
      }
      shots <- pbp[idx_shot, , drop = FALSE]
      
      is_home_vec <- as.logical(shots[['isHome']])
      if (team == 'home') {
        keep <- !is.na(is_home_vec) & is_home_vec
      } else {
        keep <- !is.na(is_home_vec) & !is_home_vec
      }
      if (!any(keep)) {
        message('No shot attempts found for the selected team in this game.')
        return(invisible(NULL))
      }
      shots <- shots[keep, , drop = FALSE]
      type_shot <- as.character(shots[['typeDescKey']])
      
      x <- as.numeric(shots[[x_col]])
      y <- as.numeric(shots[[y_col]])
      
      x_j <- x + stats::runif(length(x), -0.8, 0.8)
      y_j <- y + stats::runif(length(y), -0.4, 0.4)
      
      xg <- as.numeric(shots[[xg_col]])
      xg[is.na(xg) | xg < 0] <- 0
      xg[xg > 1] <- 1
      
      nz <- xg[xg > 0]
      
      if (length(nz) < 5L) {
        breaks <- c(0, 0.02, 0.05, 0.10, 0.20, 1.00)
      } else {
        qs <- unname(stats::quantile(
          nz,
          probs = c(0.20, 0.40, 0.60, 0.80),
          na.rm = TRUE
        ))
        breaks <- c(0, qs, 1)
      }
      
      breaks <- sort(unique(breaks))
      
      bin <- cut(
        xg,
        breaks = breaks,
        include.lowest = TRUE,
        labels = FALSE
      )
      
      base_pal <- c('blue', '#4B6FD8', '#A15DD5', '#F8766D', 'red')
      pal <- base_pal[seq_len(max(bin, na.rm = TRUE))]
      
      col_vec <- pal[bin]
      col_vec[is.na(col_vec)] <- 'blue'
      col_vec <- grDevices::adjustcolor(col_vec, alpha.f = 0.9)
      
      k <- length(breaks) - 1L
      color_labels <- character(k)
      for (i in seq_len(k)) {
        lo <- breaks[i]
        hi <- breaks[i + 1L]
        if (i == 1L) {
          color_labels[i] <- sprintf('≤ %.2f xG', hi)
        } else if (i == k) {
          color_labels[i] <- sprintf('> %.2f xG', lo)
        } else {
          color_labels[i] <- sprintf('%.2f-%.2f xG', lo, hi)
        }
      }
      
      pch_vec <- rep(16L, length(type_shot))
      pch_vec[type_shot == 'goal']         <- 8
      pch_vec[type_shot == 'shot-on-goal'] <- 16
      pch_vec[type_shot == 'missed-shot']  <- 17
      pch_vec[type_shot == 'blocked-shot'] <- 15
      
      plot_full_rink()
      
      graphics::title(main = plot_title, line = 2.8, cex.main = 1.2)
      
      graphics::points(
        x_j,
        y_j,
        pch = pch_vec,
        col = col_vec
      )
      
      usr   <- par('usr')
      rng_y <- usr[4] - usr[3]
      x_mid <- (usr[1] + usr[2]) / 2
      
      y_top_shapes <- usr[4] + 0.12 * rng_y
      y_top_colors <- usr[4] + 0.06 * rng_y
      
      old_xpd <- par('xpd')
      par(xpd = NA)
      
      graphics::legend(
        x      = x_mid,
        y      = y_top_shapes - 3,
        horiz  = TRUE,
        xjust  = 0.5,
        legend = c('Goal', 'SOG', 'Missed', 'Blocked'),
        pch    = c(8, 16, 17, 15),
        col    = 'black',
        pt.cex = 0.75,
        bty    = 'n',
        cex    = 0.8
      )
      
      graphics::legend(
        x      = x_mid,
        y      = y_top_colors - 3,
        horiz  = TRUE,
        xjust  = 0.5,
        legend = color_labels,
        pch    = 18,
        col    = pal,
        pt.cex = 1.25,
        bty    = 'n',
        cex    = 0.8
      )
      
      graphics::text(
        x      = 65,
        y      = -49,
        labels = 'Data acquired and modeled via R package \'nhlscraper\'',
        cex    = 0.7
      )
      
      par(xpd = old_xpd)
      
      invisible(NULL)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      invisible(NULL)
    }
  )
}
