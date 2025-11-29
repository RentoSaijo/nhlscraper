#' Save an Instagram (IG) share-able shot-location plot for a game
#'
#' `ig_game_shot_locations()` saves an IG share-able shot location plot for a 
#' given `game`.
#' 
#' @inheritParams boxscore
#' @param model integer in 1:3 indicating which expected goals model to use 
#' (e.g., 1); see [calculate_expected_goals_v1()], 
#' [calculate_expected_goals_v2()], and/or [calculate_expected_goals_v3()] for 
#' reference
#' @param save logical only FALSE for tests
#' @returns `NULL`
#' @examples
#' # May take >5s, so skip.
#' \donttest{ig_game_shot_locations(
#'   game  = 2023030417, 
#'   model = 1, 
#'   team  = 'H', 
#'   save  = FALSE
#' )}
#' @export

ig_game_shot_locations <- function(
  game  = 2023030417,
  team  = 'home',
  model = 1,
  save  = TRUE
) {
  tryCatch(
    expr = {
      model <- as.integer(model)
      team <- switch(
        substring(tolower(team), 1, 1),
        h = 'home',
        a = 'away'
      )
      model_label <- paste0('xG_v', model)
      file_name <- sprintf(
        'ig_shot_locs_%s_%s_%s.png',
        as.character(game),
        team,
        model_label
      )
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
          '%s %s Shots vs. %s by Outcome and xG, jittered',
          game_date,
          shooting_abbrev,
          opp_abbrev
        )
      } else {
        plot_title <- sprintf(
          '%s Shots vs. %s by Outcome and xG, jittered',
          shooting_abbrev,
          opp_abbrev
        )
      }
      if (isTRUE(save)) {
        grDevices::png(
          filename = file_name,
          width    = 1080 * 1.25,
          height   = 566 * 1.25,
          res      = 144
        )
        on.exit(grDevices::dev.off(), add = TRUE)
      }
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
          color_labels[i] <- sprintf('\u2264 %.2f xG', hi)
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
      draw_NHL_rink()
      graphics::title(main = plot_title, line = 2.8, cex.main = 1.2)
      graphics::points(
        x_j,
        y_j,
        pch = pch_vec,
        col = col_vec
      )
      usr   <- graphics::par('usr')
      rng_y <- usr[4] - usr[3]
      x_mid <- (usr[1] + usr[2]) / 2
      y_top_shapes <- usr[4] + 0.12 * rng_y
      y_top_colors <- usr[4] + 0.06 * rng_y
      old_xpd <- graphics::par('xpd')
      graphics::par(xpd = NA)
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
      graphics::par(xpd = old_xpd)
      invisible(NULL)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      invisible(NULL)
    }
  )
}

#' @rdname ig_game_shot_locations
#' @export

ig_game_shot_locs <- function(game = 2023030417, team = 'home', model = 1) {
  ig_game_shot_locations(game, team, model)
}

#' Save an X (Twitter) share-able shot-location plot for a game
#'
#' `x_game_shot_locations()` saves an X share-able shot-location plot for a 
#' given `game`.
#' 
#' @inheritParams ig_game_shot_locations
#' @returns `NULL`
#' @examples
#' # May take >5s, so skip.
#' \donttest{x_game_shot_locations(
#'   game  = 2023030417, 
#'   model = 1, 
#'   team  = 'H',
#'   save  = FALSE
#' )}
#' @export

x_game_shot_locations <- function(
  game  = 2023030417,
  team  = 'home',
  model = 1,
  save  = TRUE
) {
  tryCatch(
    expr = {
      model <- as.integer(model)
      team <- switch(
        substring(tolower(team), 1, 1),
        h = 'home',
        a = 'away'
      )
      model_label <- paste0('xG_v', model)
      file_name <- sprintf(
        'x_shot_locs_%s_%s_%s.png',
        as.character(game),
        team,
        model_label
      )
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
          '%s %s Shots vs. %s by Outcome and xG, jittered',
          game_date,
          shooting_abbrev,
          opp_abbrev
        )
      } else {
        plot_title <- sprintf(
          '%s Shots vs. %s by Outcome and xG, jittered',
          shooting_abbrev,
          opp_abbrev
        )
      }
      if (isTRUE(save)) {
        grDevices::png(
          filename = file_name,
          width    = 1200 * 1.25,
          height   = 675 * 1.25,
          res      = 144
        )
        on.exit(grDevices::dev.off(), add = TRUE)
      }
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
          color_labels[i] <- sprintf('\u2264 %.2f xG', hi)
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
      draw_NHL_rink()
      graphics::title(main = plot_title, line = 2.8, cex.main = 1.2)
      graphics::points(
        x_j,
        y_j,
        pch = pch_vec,
        col = col_vec
      )
      usr   <- graphics::par('usr')
      rng_y <- usr[4] - usr[3]
      x_mid <- (usr[1] + usr[2]) / 2
      y_top_shapes <- usr[4] + 0.12 * rng_y
      y_top_colors <- usr[4] + 0.06 * rng_y
      old_xpd <- graphics::par('xpd')
      graphics::par(xpd = NA)
      graphics::legend(
        x      = x_mid,
        y      = y_top_shapes - 8,
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
        y      = y_top_colors - 9,
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
        y      = -51,
        labels = 'Data acquired and modeled via R package \'nhlscraper\'',
        cex    = 0.7
      )
      graphics::par(xpd = old_xpd)
      invisible(NULL)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      invisible(NULL)
    }
  )
}

#' @rdname x_game_shot_locations
#' @export

x_game_shot_locs <- function(game = 2023030417, team = 'home', model = 1) {
  x_game_shot_locations(game, team, model)
}

#' Save an Instagram (IG) share-able cumulative expected goals (xG) time-series 
#' plot for a game
#'
#' `ig_game_cumulative_expected_goals()` saves an IG share-able cumulative xG 
#' time-series plot for a given `game` as a PNG.
#'
#' @inheritParams ig_game_shot_locations
#' @returns `NULL`
#' @examples
#' # May take >5s, so skip.
#' \donttest{ig_game_cumulative_expected_goals(
#'   game  = 2023030417, 
#'   model = 1, 
#'   save  = FALSE
#' )}
#' @export

ig_game_cumulative_expected_goals <- function(
  game  = 2023030417,
  model = 1,
  save  = TRUE
) {
  tryCatch(
    expr = {
      model <- as.integer(model)
      model_label <- paste0('xG_v', model)
      file_name <- sprintf(
        'ig_cum_xG_%s_%s.png',
        as.character(game),
        model_label
      )
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
      if (nzchar(game_date)) {
        plot_title <- sprintf(
          '%s %s @ %s xG over Seconds Elapsed',
          game_date,
          away_abbrev,
          home_abbrev
        )
      } else {
        plot_title <- sprintf(
          '%s @ %s xG over Seconds Elapsed',
          away_abbrev,
          home_abbrev
        )
      }
      if (isTRUE(save)) {
        grDevices::png(
          filename = file_name,
          width    = 1080 * 1.25,
          height   = 566 * 1.25,
          res      = 144
        )
        on.exit(grDevices::dev.off(), add = TRUE)
      }
      pbp <- gc_play_by_play(game)
      pbp <- flag_is_home(pbp)
      pbp <- strip_time_period(pbp)
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
        return(invisible(NULL))
      }
      shots <- pbp[idx_shot, , drop = FALSE]
      sec   <- as.numeric(shots[['secondsElapsedInGame']])
      xg    <- as.numeric(shots[[xg_col]])
      is_h  <- as.logical(shots[['isHome']])
      valid <- !is.na(sec) & !is.na(xg) & !is.na(is_h)
      if (!any(valid)) {
        return(invisible(NULL))
      }
      sec  <- sec[valid]
      xg   <- xg[valid]
      is_h <- is_h[valid]
      home_sec <- sec[is_h]
      home_xg  <- xg[is_h]
      away_sec <- sec[!is_h]
      away_xg  <- xg[!is_h]
      if (length(home_sec) > 0L) {
        o_h <- order(home_sec)
        home_sec <- home_sec[o_h]
        home_xg  <- home_xg[o_h]
        home_t   <- c(0, home_sec)
        home_cum <- c(0, cumsum(home_xg))
      } else {
        home_t   <- 0
        home_cum <- 0
      }
      if (length(away_sec) > 0L) {
        o_a <- order(away_sec)
        away_sec <- away_sec[o_a]
        away_xg  <- away_xg[o_a]
        away_t   <- c(0, away_sec)
        away_cum <- c(0, cumsum(away_xg))
      } else {
        away_t   <- 0
        away_cum <- 0
      }
      game_end_sec <- suppressWarnings(
        max(as.numeric(pbp[['secondsElapsedInGame']]), na.rm = TRUE)
      )
      if (!is.finite(game_end_sec) || game_end_sec <= 0) {
        game_end_sec <- 3600
      }
      if (utils::tail(home_t, 1L) < game_end_sec) {
        home_t   <- c(home_t, game_end_sec)
        home_cum <- c(home_cum, utils::tail(home_cum, 1L))
      }
      if (utils::tail(away_t, 1L) < game_end_sec) {
        away_t   <- c(away_t, game_end_sec)
        away_cum <- c(away_cum, utils::tail(away_cum, 1L))
      }
      max_time <- game_end_sec
      max_xg   <- max(c(home_cum, away_cum), na.rm = TRUE)
      if (!is.finite(max_xg) || max_xg <= 0) {
        max_xg <- 1
      }
      graphics::plot(
        NA_real_, NA_real_,
        xlim = c(0, max_time),
        ylim = c(0, max_xg),
        xlab = 'Seconds Elapsed in Game',
        ylab = 'Cumulative Expected Goals',
        xaxs = 'i',
        yaxs = 'i',
        xaxt = 'n'
      )
      graphics::axis(
        side = 1,
        at   = seq(0, max_time, by = 600)
      )
      graphics::title(main = plot_title, line = 1.8, cex.main = 1.2)
      if (length(home_t) > 1L) {
        graphics::lines(home_t, home_cum, col = 'red', lwd = 2)
      }
      if (length(away_t) > 1L) {
        graphics::lines(away_t, away_cum, col = 'blue', lwd = 2)
      }
      graphics::legend(
        'topleft',
        legend = c(home_abbrev, away_abbrev),
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
      graphics::text(
        x      = x_mid,
        y      = usr[4] + 0.04 * rng_y,
        labels = "Data acquired and modeled via R package 'nhlscraper'",
        cex    = 0.7,
        adj    = c(0.5, 0)
      )
      graphics::par(xpd = old_xpd)
      invisible(NULL)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      invisible(NULL)
    }
  )
}

#' @rdname ig_game_cumulative_expected_goals
#' @export

ig_game_cum_xG <- function(game = 2023030417, model = 1) {
  ig_game_cumulative_expected_goals(game, model)
}

#' Save an X (Twitter) share-able cumulative expected goals (xG) time-series 
#' plot for a game
#'
#' `x_game_cumulative_expected_goals()` saves an X share-able cumulative xG 
#' time-series plot for a given `game` as a PNG.
#'
#' @inheritParams ig_game_shot_locations
#' @returns `NULL`
#' @examples
#' # May take >5s, so skip.
#' \donttest{x_game_cumulative_expected_goals(
#'   game  = 2023030417, 
#'   model = 1,
#'   save  = FALSE
#' )}
#' @export

x_game_cumulative_expected_goals <- function(
  game  = 2023030417,
  model = 1,
  save  = TRUE
) {
  tryCatch(
    expr = {
      model <- as.integer(model)
      model_label <- paste0('xG_v', model)
      file_name <- sprintf(
        'x_cum_xG_%s_%s.png',
        as.character(game),
        model_label
      )
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
      if (nzchar(game_date)) {
        plot_title <- sprintf(
          '%s %s @ %s xG over Seconds Elapsed',
          game_date,
          away_abbrev,
          home_abbrev
        )
      } else {
        plot_title <- sprintf(
          '%s @ %s xG over Seconds Elapsed',
          away_abbrev,
          home_abbrev
        )
      }
      if (isTRUE(save)) {
        grDevices::png(
          filename = file_name,
          width    = 1200 * 1.25,
          height   = 675 * 1.25,
          res      = 144
        )
        on.exit(grDevices::dev.off(), add = TRUE)
      }
      pbp <- gc_play_by_play(game)
      pbp <- flag_is_home(pbp)
      pbp <- strip_time_period(pbp)
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
        return(invisible(NULL))
      }
      shots <- pbp[idx_shot, , drop = FALSE]
      sec   <- as.numeric(shots[['secondsElapsedInGame']])
      xg    <- as.numeric(shots[[xg_col]])
      is_h  <- as.logical(shots[['isHome']])
      valid <- !is.na(sec) & !is.na(xg) & !is.na(is_h)
      if (!any(valid)) {
        return(invisible(NULL))
      }
      sec  <- sec[valid]
      xg   <- xg[valid]
      is_h <- is_h[valid]
      home_sec <- sec[is_h]
      home_xg  <- xg[is_h]
      away_sec <- sec[!is_h]
      away_xg  <- xg[!is_h]
      if (length(home_sec) > 0L) {
        o_h <- order(home_sec)
        home_sec <- home_sec[o_h]
        home_xg  <- home_xg[o_h]
        home_t   <- c(0, home_sec)
        home_cum <- c(0, cumsum(home_xg))
      } else {
        home_t   <- 0
        home_cum <- 0
      }
      if (length(away_sec) > 0L) {
        o_a <- order(away_sec)
        away_sec <- away_sec[o_a]
        away_xg  <- away_xg[o_a]
        away_t   <- c(0, away_sec)
        away_cum <- c(0, cumsum(away_xg))
      } else {
        away_t   <- 0
        away_cum <- 0
      }
      game_end_sec <- suppressWarnings(
        max(as.numeric(pbp[['secondsElapsedInGame']]), na.rm = TRUE)
      )
      if (!is.finite(game_end_sec) || game_end_sec <= 0) {
        game_end_sec <- 3600
      }
      if (utils::tail(home_t, 1L) < game_end_sec) {
        home_t   <- c(home_t, game_end_sec)
        home_cum <- c(home_cum, utils::tail(home_cum, 1L))
      }
      if (utils::tail(away_t, 1L) < game_end_sec) {
        away_t   <- c(away_t, game_end_sec)
        away_cum <- c(away_cum, utils::tail(away_cum, 1L))
      }
      max_time <- game_end_sec
      max_xg   <- max(c(home_cum, away_cum), na.rm = TRUE)
      if (!is.finite(max_xg) || max_xg <= 0) {
        max_xg <- 1
      }
      graphics::plot(
        NA_real_, NA_real_,
        xlim = c(0, max_time),
        ylim = c(0, max_xg),
        xlab = 'Seconds Elapsed in Game',
        ylab = 'Cumulative Expected Goals',
        xaxs = 'i',
        yaxs = 'i',
        xaxt = 'n'
      )
      graphics::axis(
        side = 1,
        at   = seq(0, max_time, by = 600)
      )
      graphics::title(main = plot_title, line = 1.8, cex.main = 1.2)
      if (length(home_t) > 1L) {
        graphics::lines(home_t, home_cum, col = 'red', lwd = 2)
      }
      if (length(away_t) > 1L) {
        graphics::lines(away_t, away_cum, col = 'blue', lwd = 2)
      }
      graphics::legend(
        'topleft',
        legend = c(home_abbrev, away_abbrev),
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
      graphics::text(
        x      = x_mid,
        y      = usr[4] + 0.04 * rng_y,
        labels = "Data acquired and modeled via R package 'nhlscraper'",
        cex    = 0.7,
        adj    = c(0.5, 0)
      )
      graphics::par(xpd = old_xpd)
      invisible(NULL)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      invisible(NULL)
    }
  )
}

#' @rdname x_game_cumulative_expected_goals
#' @export

x_game_cum_xG <- function(game = 2023030417, model = 1) {
  x_game_cumulative_expected_goals(game, model)
}
