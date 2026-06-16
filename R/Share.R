# ----- Share Helpers ----- #

#' Normalize share-plot team selector
#'
#' `.share_team_key()` converts home/away shorthands into the canonical team
#' key used by share plots.
#'
#' @param team character scalar
#' @returns character scalar, either `home` or `away`
#' @keywords internal
.share_team_key <- function(team) {
  switch(
    substring(tolower(team), 1, 1),
    h = 'home',
    a = 'away'
  )
}

#' Build share-plot output settings
#'
#' `.share_plot_spec()` returns file naming, canvas size, and legend offsets for
#' an IG or X plot.
#'
#' @param platform character of `ig` or `x`
#' @param plot_type character of `shots` or `cumulative`
#' @returns named list of plot settings
#' @keywords internal
.share_plot_spec <- function(platform, plot_type) {
  platform <- match.arg(platform, c('ig', 'x'))
  plot_type <- match.arg(plot_type, c('shots', 'cumulative'))
  if (platform == 'ig') {
    list(
      file_prefix = if (plot_type == 'shots') 'ig_shot_locs' else 'ig_cum_xG',
      width = 1080 * 1.25,
      height = 566 * 1.25,
      legend_shape_offset = 3,
      legend_bar_offset = 7,
      footer_y = if (plot_type == 'shots') -49 else NA_real_
    )
  } else {
    list(
      file_prefix = if (plot_type == 'shots') 'x_shot_locs' else 'x_cum_xG',
      width = 1200 * 1.25,
      height = 675 * 1.25,
      legend_shape_offset = 8,
      legend_bar_offset = 13,
      footer_y = if (plot_type == 'shots') -51 else NA_real_
    )
  }
}

#' Open a PNG device for a share plot
#'
#' `.open_share_png()` opens the output device only when `save` is `TRUE`.
#'
#' @param file_name character output file name
#' @param spec list returned by `.share_plot_spec()`
#' @param save logical
#' @returns logical indicating whether a device was opened
#' @keywords internal
.open_share_png <- function(file_name, spec, save) {
  if (!isTRUE(save)) {
    return(FALSE)
  }
  grDevices::png(
    filename = file_name,
    width    = spec$width,
    height   = spec$height,
    res      = 144
  )
  TRUE
}

#' Read game labels for share plots
#'
#' `.share_game_labels()` fetches the GameCenter summary and extracts the team
#' abbreviations and game date used in plot titles.
#'
#' @param game game ID
#' @returns named list of game labels
#' @keywords internal
.share_game_labels <- function(game) {
  game_sum <- gc_summary(game)
  list(
    home_abbrev = tryCatch(game_sum$homeTeam$abbrev, error = function(e) 'HOME'),
    away_abbrev = tryCatch(game_sum$awayTeam$abbrev, error = function(e) 'AWAY'),
    game_date = tryCatch(as.character(game_sum$gameDate), error = function(e) '')
  )
}

#' Build a shot-location title
#'
#' `.share_shot_location_title()` builds the title for a team-specific shot map.
#'
#' @param labels list returned by `.share_game_labels()`
#' @param team character of `home` or `away`
#' @returns character scalar
#' @keywords internal
.share_shot_location_title <- function(labels, team) {
  if (team == 'home') {
    shooting_abbrev <- labels$home_abbrev
    opp_abbrev      <- labels$away_abbrev
  } else {
    shooting_abbrev <- labels$away_abbrev
    opp_abbrev      <- labels$home_abbrev
  }
  if (nzchar(labels$game_date)) {
    sprintf(
      '%s %s Shots vs. %s by Outcome and xG, jittered',
      labels$game_date,
      shooting_abbrev,
      opp_abbrev
    )
  } else {
    sprintf(
      '%s Shots vs. %s by Outcome and xG, jittered',
      shooting_abbrev,
      opp_abbrev
    )
  }
}

#' Build a cumulative xG title
#'
#' `.share_cumulative_title()` builds the title for a game-level cumulative xG
#' time series.
#'
#' @param labels list returned by `.share_game_labels()`
#' @returns character scalar
#' @keywords internal
.share_cumulative_title <- function(labels) {
  if (nzchar(labels$game_date)) {
    sprintf(
      '%s %s @ %s xG over Seconds Elapsed',
      labels$game_date,
      labels$away_abbrev,
      labels$home_abbrev
    )
  } else {
    sprintf(
      '%s @ %s xG over Seconds Elapsed',
      labels$away_abbrev,
      labels$home_abbrev
    )
  }
}

#' Fetch shot attempts with xG for a game
#'
#' `.share_game_shots()` retrieves a game play-by-play, scores expected goals,
#' and keeps public shot-attempt rows used by share plots.
#'
#' @param game game ID
#' @returns named list containing the full play-by-play and shot rows
#' @keywords internal
.share_game_shots <- function(game) {
  pbp <- gc_play_by_play(game)
  pbp <- calculate_expected_goals(pbp)
  shot_types <- c('goal', 'shot-on-goal', 'missed-shot', 'blocked-shot')
  idx_shot <- .shot_event_mask(pbp, shot_types)
  list(
    play_by_play = pbp,
    shots = pbp[idx_shot, , drop = FALSE]
  )
}

#' Filter share shots to one team
#'
#' `.share_filter_team_shots()` keeps home or away shot-attempt rows.
#'
#' @param shots data.frame of shot-attempt rows
#' @param team character of `home` or `away`
#' @returns data.frame
#' @keywords internal
.share_filter_team_shots <- function(shots, team) {
  is_home_vec <- as.logical(shots[['isHome']])
  if (team == 'home') {
    keep <- !is.na(is_home_vec) & is_home_vec
  } else {
    keep <- !is.na(is_home_vec) & !is_home_vec
  }
  shots[keep, , drop = FALSE]
}

#' Build xG color scaling metadata
#'
#' `.share_xg_scale()` caps xG at the 98th percentile of positive attempts and
#' returns colors plus legend labels on a log-like scale.
#'
#' @param xg numeric expected-goals vector
#' @returns named list of color and legend metadata
#' @keywords internal
.share_xg_scale <- function(xg) {
  xg <- as.numeric(xg)
  xg[!is.finite(xg) | xg < 0] <- 0
  xg[xg > 1] <- 1
  pos_xg <- xg[is.finite(xg) & xg > 0]
  xg_cap <- suppressWarnings(stats::quantile(
    pos_xg,
    probs = 0.98,
    na.rm = TRUE,
    names = FALSE
  ))
  if (!is.finite(xg_cap) || xg_cap <= 0) {
    xg_cap <- 0.20
  }
  xg_cap <- min(1, xg_cap)
  scale_xg <- function(v) {
    vv <- pmax(0, pmin(v, xg_cap))
    log1p(99 * (vv / xg_cap)) / log(100)
  }
  palette <- grDevices::colorRampPalette(
    c('#2166AC', '#67A9CF', '#D1E5F0', '#FDAE61', '#B2182B')
  )(256)
  col_idx <- 1L + floor(scale_xg(xg) * 255)
  col_idx[!is.finite(col_idx)] <- 1L
  col_idx <- pmax(1L, pmin(256L, as.integer(col_idx)))
  legend_scaled <- seq(0, 1, length.out = 4L)
  legend_vals <- xg_cap * (exp(legend_scaled * log(100)) - 1) / 99
  legend_vals[1] <- 0
  legend_vals[4L] <- xg_cap
  label_fmt <- if (xg_cap < 0.1) '%.3f xG' else '%.2f xG'
  top_fmt <- if (xg_cap < 0.1) '%.3f+ xG' else '%.2f+ xG'
  color_labels <- sprintf(label_fmt, legend_vals)
  color_labels[length(color_labels)] <- sprintf(top_fmt, xg_cap)
  list(
    colors = palette[col_idx],
    palette = palette,
    legend_scaled = legend_scaled,
    color_labels = color_labels
  )
}

#' Draw the shot-map legends
#'
#' `.draw_share_shot_legends()` draws outcome symbols and the xG color ramp
#' above the rink.
#'
#' @param scale list returned by `.share_xg_scale()`
#' @param spec list returned by `.share_plot_spec()`
#' @keywords internal
.draw_share_shot_legends <- function(scale, spec) {
  usr   <- graphics::par('usr')
  rng_y <- usr[4] - usr[3]
  x_mid <- (usr[1] + usr[2]) / 2
  y_top_shapes <- usr[4] + 0.12 * rng_y
  y_top_colors <- usr[4] + 0.06 * rng_y
  graphics::legend(
    x      = x_mid,
    y      = y_top_shapes - spec$legend_shape_offset,
    horiz  = TRUE,
    xjust  = 0.5,
    legend = c('Goal', 'SOG', 'Missed', 'Blocked'),
    pch    = c(8, 16, 17, 15),
    col    = 'black',
    pt.cex = 0.75,
    bty    = 'n',
    cex    = 0.8
  )
  y_bar_center <- y_top_colors - spec$legend_bar_offset
  rng_x <- usr[2] - usr[1]
  bar_half_w <- 0.20 * rng_x
  bar_h <- 1.7
  x_left <- x_mid - bar_half_w
  x_right <- x_mid + bar_half_w
  y_bottom <- y_bar_center - bar_h / 2
  y_top <- y_bar_center + bar_h / 2
  graphics::rasterImage(
    image       = grDevices::as.raster(matrix(scale$palette, nrow = 1L)),
    xleft       = x_left,
    ybottom     = y_bottom,
    xright      = x_right,
    ytop        = y_top,
    interpolate = FALSE
  )
  graphics::rect(
    xleft   = x_left,
    ybottom = y_bottom,
    xright  = x_right,
    ytop    = y_top,
    border  = 'black',
    lwd     = 0.75
  )
  tick_x <- x_left + scale$legend_scaled * (x_right - x_left)
  graphics::segments(
    x0 = tick_x,
    y0 = y_bottom,
    x1 = tick_x,
    y1 = y_bottom - 0.8
  )
  graphics::text(
    x      = tick_x,
    y      = y_bottom - 1.4,
    labels = scale$color_labels,
    cex    = 0.7,
    adj    = c(0.5, 1)
  )
}

#' Draw a shareable shot-location plot
#'
#' `.draw_share_shot_locations()` renders one team's shot attempts on the NHL
#' rink with outcome symbols and xG color.
#'
#' @param shots data.frame of team-filtered shot attempts
#' @param plot_title character scalar
#' @param spec list returned by `.share_plot_spec()`
#' @returns `NULL`, invisibly
#' @keywords internal
.draw_share_shot_locations <- function(shots, plot_title, spec) {
  type_shot <- as.character(shots[['eventTypeDescKey']])
  x <- as.numeric(shots[['xCoordNorm']])
  y <- as.numeric(shots[['yCoordNorm']])
  x_j <- x + stats::runif(length(x), -0.6, 0.6)
  y_j <- y + stats::runif(length(y), -0.3, 0.3)
  scale <- .share_xg_scale(shots[['xG']])
  pch_vec <- rep(16L, length(type_shot))
  pch_vec[type_shot == 'goal']         <- 8
  pch_vec[type_shot == 'shot-on-goal'] <- 16
  pch_vec[type_shot == 'missed-shot']  <- 17
  pch_vec[type_shot == 'blocked-shot'] <- 15
  draw_NHL_rink()
  graphics::title(main = plot_title, line = 2.8, cex.main = 1.2)
  graphics::points(
    x_j,
    y_j,
    pch = pch_vec,
    col = scale$colors
  )
  old_xpd <- graphics::par('xpd')
  graphics::par(xpd = NA)
  on.exit(graphics::par(xpd = old_xpd), add = TRUE)
  .draw_share_shot_legends(scale, spec)
  graphics::text(
    x      = 65,
    y      = spec$footer_y,
    labels = 'Data acquired and modeled via R package \'nhlscraper\'',
    cex    = 0.7
  )
  invisible(NULL)
}

#' Build cumulative xG series
#'
#' `.share_cumulative_xg_series()` converts shot-attempt rows into home and away
#' step-series vectors.
#'
#' @param shots data.frame of shot-attempt rows
#' @param play_by_play full game play-by-play
#' @returns named list of cumulative xG series
#' @keywords internal
.share_cumulative_xg_series <- function(shots, play_by_play) {
  sec   <- as.numeric(shots[['secondsElapsedInGame']])
  xg    <- as.numeric(shots[['xG']])
  is_h  <- as.logical(shots[['isHome']])
  valid <- !is.na(sec) & !is.na(xg) & !is.na(is_h)
  if (!any(valid)) {
    return(NULL)
  }
  sec  <- sec[valid]
  xg   <- xg[valid]
  is_h <- is_h[valid]
  build_side <- function(side_sec, side_xg) {
    if (!length(side_sec)) {
      return(list(time = 0, xg = 0))
    }
    ord <- order(side_sec)
    list(
      time = c(0, side_sec[ord]),
      xg = c(0, cumsum(side_xg[ord]))
    )
  }
  home <- build_side(sec[is_h], xg[is_h])
  away <- build_side(sec[!is_h], xg[!is_h])
  game_end_sec <- suppressWarnings(
    max(as.numeric(play_by_play[['secondsElapsedInGame']]), na.rm = TRUE)
  )
  if (!is.finite(game_end_sec) || game_end_sec <= 0) {
    game_end_sec <- 3600
  }
  if (utils::tail(home$time, 1L) < game_end_sec) {
    home$time <- c(home$time, game_end_sec)
    home$xg   <- c(home$xg, utils::tail(home$xg, 1L))
  }
  if (utils::tail(away$time, 1L) < game_end_sec) {
    away$time <- c(away$time, game_end_sec)
    away$xg   <- c(away$xg, utils::tail(away$xg, 1L))
  }
  list(home = home, away = away, game_end_sec = game_end_sec)
}

#' Draw a shareable cumulative xG plot
#'
#' `.draw_share_cumulative_xg()` renders a home/away cumulative expected-goals
#' time series.
#'
#' @param series list returned by `.share_cumulative_xg_series()`
#' @param labels list returned by `.share_game_labels()`
#' @param plot_title character scalar
#' @returns `NULL`, invisibly
#' @keywords internal
.draw_share_cumulative_xg <- function(series, labels, plot_title) {
  max_xg <- max(c(series$home$xg, series$away$xg), na.rm = TRUE)
  if (!is.finite(max_xg) || max_xg <= 0) {
    max_xg <- 1
  }
  graphics::plot(
    NA_real_,
    NA_real_,
    xlim = c(0, series$game_end_sec),
    ylim = c(0, max_xg),
    xlab = 'Seconds Elapsed in Game',
    ylab = 'Cumulative Expected Goals',
    xaxs = 'i',
    yaxs = 'i',
    xaxt = 'n'
  )
  graphics::axis(
    side = 1,
    at   = seq(0, series$game_end_sec, by = 600)
  )
  graphics::title(main = plot_title, line = 1.8, cex.main = 1.2)
  if (length(series$home$time) > 1L) {
    graphics::lines(series$home$time, series$home$xg, col = 'red', lwd = 2)
  }
  if (length(series$away$time) > 1L) {
    graphics::lines(series$away$time, series$away$xg, col = 'blue', lwd = 2)
  }
  graphics::legend(
    'topleft',
    legend = c(labels$home_abbrev, labels$away_abbrev),
    col    = c('red', 'blue'),
    lty    = 1,
    lwd    = 2,
    bty    = 'n',
    cex    = 0.9
  )
  usr   <- graphics::par('usr')
  rng_y <- usr[4] - usr[3]
  x_mid <- (usr[1] + usr[2]) / 2
  old_xpd <- graphics::par('xpd')
  graphics::par(xpd = NA)
  on.exit(graphics::par(xpd = old_xpd), add = TRUE)
  graphics::text(
    x      = x_mid,
    y      = usr[4] + 0.04 * rng_y,
    labels = 'Data acquired and modeled via R package \'nhlscraper\'',
    cex    = 0.7,
    adj    = c(0.5, 0)
  )
  invisible(NULL)
}

# ----- Package Functions ----- #

#' Save an Instagram (IG) shareable shot-location plot for a game
#'
#' `ig_game_shot_locations()` fetches one GameCenter play-by-play, scores its
#' shot attempts with [calculate_expected_goals()], filters to the selected home
#' or away team, and renders a 1080-by-566-style PNG shot map. Points are
#' jittered for readability, shaped by event result, and colored by capped xG.
#'
#' @inheritParams boxscore
#' @param model deprecated legacy model selector; ignored
#' @param save logical; use `FALSE` to draw on the active graphics device during
#'   tests or custom workflows
#' @returns `NULL`, invisibly
#' @examples
#' # May take >5s, so skip.
#' \donttest{ig_game_shot_locations(
#'   game  = 2023030417,
#'   team  = 'H',
#'   save  = FALSE
#' )}
#' @export
ig_game_shot_locations <- function(
  game  = 2023030417,
  team  = 'home',
  model = NULL,
  save  = TRUE
) {
  tryCatch(
    expr = {
      .xg_warn_ignored_model(model, 'ig_game_shot_locations')
      team <- .share_team_key(team)
      spec <- .share_plot_spec('ig', 'shots')
      file_name <- sprintf('%s_%s_%s.png', spec$file_prefix, as.character(game), team)
      labels <- .share_game_labels(game)
      plot_title <- .share_shot_location_title(labels, team)
      device_open <- .open_share_png(file_name, spec, save)
      if (device_open) {
        on.exit(grDevices::dev.off(), add = TRUE)
      }
      game_shots <- .share_game_shots(game)
      if (!nrow(game_shots$shots)) {
        message('No shot attempts found for this game.')
        return(invisible(NULL))
      }
      shots <- .share_filter_team_shots(game_shots$shots, team)
      if (!nrow(shots)) {
        return(invisible(NULL))
      }
      .draw_share_shot_locations(shots, plot_title, spec)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      invisible(NULL)
    }
  )
}

#' @rdname ig_game_shot_locations
#' @export
ig_game_shot_locs <- function(game = 2023030417, team = 'home', model = NULL) {
  ig_game_shot_locations(game, team, model)
}

#' Save an X (Twitter) shareable shot-location plot for a game
#'
#' `x_game_shot_locations()` is the X/Twitter-sized companion to
#' [ig_game_shot_locations()]. It uses the same xG-scored shot map and legend
#' logic on a 1200-by-675-style canvas.
#'
#' @inheritParams ig_game_shot_locations
#' @returns `NULL`, invisibly
#' @examples
#' # May take >5s, so skip.
#' \donttest{x_game_shot_locations(
#'   game  = 2023030417,
#'   team  = 'H',
#'   save  = FALSE
#' )}
#' @export
x_game_shot_locations <- function(
  game  = 2023030417,
  team  = 'home',
  model = NULL,
  save  = TRUE
) {
  tryCatch(
    expr = {
      .xg_warn_ignored_model(model, 'x_game_shot_locations')
      team <- .share_team_key(team)
      spec <- .share_plot_spec('x', 'shots')
      file_name <- sprintf('%s_%s_%s.png', spec$file_prefix, as.character(game), team)
      labels <- .share_game_labels(game)
      plot_title <- .share_shot_location_title(labels, team)
      device_open <- .open_share_png(file_name, spec, save)
      if (device_open) {
        on.exit(grDevices::dev.off(), add = TRUE)
      }
      game_shots <- .share_game_shots(game)
      if (!nrow(game_shots$shots)) {
        return(invisible(NULL))
      }
      shots <- .share_filter_team_shots(game_shots$shots, team)
      if (!nrow(shots)) {
        return(invisible(NULL))
      }
      .draw_share_shot_locations(shots, plot_title, spec)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      invisible(NULL)
    }
  )
}

#' @rdname x_game_shot_locations
#' @export
x_game_shot_locs <- function(game = 2023030417, team = 'home', model = NULL) {
  x_game_shot_locations(game, team, model)
}

#' Save an Instagram (IG) shareable cumulative expected goals (xG) plot
#'
#' `ig_game_cumulative_expected_goals()` fetches one GameCenter play-by-play,
#' scores shot attempts with [calculate_expected_goals()], and renders a
#' home/away cumulative xG time series on a 1080-by-566-style PNG canvas.
#'
#' @inheritParams ig_game_shot_locations
#' @returns `NULL`, invisibly
#' @examples
#' # May take >5s, so skip.
#' \donttest{ig_game_cumulative_expected_goals(
#'   game  = 2023030417,
#'   save  = FALSE
#' )}
#' @export
ig_game_cumulative_expected_goals <- function(
  game  = 2023030417,
  model = NULL,
  save  = TRUE
) {
  tryCatch(
    expr = {
      .xg_warn_ignored_model(model, 'ig_game_cumulative_expected_goals')
      spec <- .share_plot_spec('ig', 'cumulative')
      file_name <- sprintf('%s_%s.png', spec$file_prefix, as.character(game))
      labels <- .share_game_labels(game)
      plot_title <- .share_cumulative_title(labels)
      device_open <- .open_share_png(file_name, spec, save)
      if (device_open) {
        on.exit(grDevices::dev.off(), add = TRUE)
      }
      game_shots <- .share_game_shots(game)
      if (!nrow(game_shots$shots)) {
        return(invisible(NULL))
      }
      series <- .share_cumulative_xg_series(
        game_shots$shots,
        game_shots$play_by_play
      )
      if (is.null(series)) {
        return(invisible(NULL))
      }
      .draw_share_cumulative_xg(series, labels, plot_title)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      invisible(NULL)
    }
  )
}

#' @rdname ig_game_cumulative_expected_goals
#' @export
ig_game_cum_xG <- function(game = 2023030417, model = NULL) {
  ig_game_cumulative_expected_goals(game, model)
}

#' Save an X (Twitter) shareable cumulative expected goals (xG) plot
#'
#' `x_game_cumulative_expected_goals()` is the X/Twitter-sized companion to
#' [ig_game_cumulative_expected_goals()]. It uses the same xG-scored cumulative
#' series on a 1200-by-675-style canvas.
#'
#' @inheritParams ig_game_shot_locations
#' @returns `NULL`, invisibly
#' @examples
#' # May take >5s, so skip.
#' \donttest{x_game_cumulative_expected_goals(
#'   game  = 2023030417,
#'   save  = FALSE
#' )}
#' @export
x_game_cumulative_expected_goals <- function(
  game  = 2023030417,
  model = NULL,
  save  = TRUE
) {
  tryCatch(
    expr = {
      .xg_warn_ignored_model(model, 'x_game_cumulative_expected_goals')
      spec <- .share_plot_spec('x', 'cumulative')
      file_name <- sprintf('%s_%s.png', spec$file_prefix, as.character(game))
      labels <- .share_game_labels(game)
      plot_title <- .share_cumulative_title(labels)
      device_open <- .open_share_png(file_name, spec, save)
      if (device_open) {
        on.exit(grDevices::dev.off(), add = TRUE)
      }
      game_shots <- .share_game_shots(game)
      if (!nrow(game_shots$shots)) {
        return(invisible(NULL))
      }
      series <- .share_cumulative_xg_series(
        game_shots$shots,
        game_shots$play_by_play
      )
      if (is.null(series)) {
        return(invisible(NULL))
      }
      .draw_share_cumulative_xg(series, labels, plot_title)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      invisible(NULL)
    }
  )
}

#' @rdname x_game_cumulative_expected_goals
#' @export
x_game_cum_xG <- function(game = 2023030417, model = NULL) {
  x_game_cumulative_expected_goals(game, model)
}
