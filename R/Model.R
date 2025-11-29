#' Calculate version 1 of the expected goals for all the events (plays) in a 
#' play-by-play
#' 
#' `calculate_expected_goals_v1()` calculates version 1 of the expected goals 
#' for all the events (plays) in a play-by-play using a pre-estimated logistic 
#' regression model of goal probability on distance, angle, empty net, and 
#' strength state.
#'
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] 
#' and/or [wsc_play_by_play()] for reference; must be untouched by 
#' non-nhlscraper functions; saves time if [calculate_distance()], 
#' [calculate_angle()], and/or [strip_situation_code()] have already been called
#'
#' @returns data.frame with one row per event (play) and added `xG_v1` column
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test <- gc_play_by_play()
#'   test <- calculate_expected_goals_v1(test)
#' }
#' @export

calculate_expected_goals_v1 <- function(play_by_play) {
  tryCatch(
    expr = {
      beta0   <- -1.8999656
      beta_d  <- -0.0337112
      beta_a  <- -0.0077118
      beta_en <-  4.3321873
      beta_pk <-  0.6454842
      beta_pp <-  0.4080557
      original_names <- names(play_by_play)
      had_is_home   <- 'isHome'            %in% names(play_by_play)
      had_distance  <- 'distance'          %in% names(play_by_play)
      had_angle     <- 'angle'             %in% names(play_by_play)
      had_ena       <- 'isEmptyNetAgainst' %in% names(play_by_play)
      had_strength  <- 'strengthState'     %in% names(play_by_play)
      if (!had_is_home) {
        play_by_play <- flag_is_home(play_by_play)
      }
      if (!had_ena || !had_strength) {
        play_by_play <- strip_situation_code(play_by_play)
      }
      if (!had_distance) {
        play_by_play <- calculate_distance(play_by_play)
      }
      if (!had_angle) {
        play_by_play <- calculate_angle(play_by_play)
      }
      n  <- nrow(play_by_play)
      xg <- rep(NA_real_, n)
      distance <- as.numeric(play_by_play[['distance']])
      angle    <- as.numeric(play_by_play[['angle']])
      ena      <- as.logical(play_by_play[['isEmptyNetAgainst']])
      strength <- as.character(play_by_play[['strengthState']])
      raw_situation <- play_by_play[['situationCode']]
      situation_chr <- as.character(raw_situation)
      situation_pad <- rep(NA_character_, length(situation_chr))
      valid_sit     <- !is.na(situation_chr) & nchar(situation_chr) > 0L
      if (any(valid_sit)) {
        situation_pad[valid_sit] <- sprintf(
          '%04d',
          as.integer(situation_chr[valid_sit])
        )
      }
      situation <- situation_pad
      type <- as.character(play_by_play[['typeDescKey']])
      bad_situation <- situation %in% c('0101', '1010')
      shot_types    <- c('goal', 'shot-on-goal', 'missed-shot', 'blocked-shot')
      is_shot       <- !is.na(type) & type %in% shot_types
      idx <- !is.na(situation) & !bad_situation & is_shot
      if (!any(idx)) {
        play_by_play[['xG_v1']] <- xg
        final_names <- names(play_by_play)
        new_names   <- setdiff(final_names, original_names)
        allowed_new <- c('xG_v1')
        drop_names  <- setdiff(new_names, allowed_new)
        if (length(drop_names) > 0L) {
          play_by_play[drop_names] <- NULL
        }
        if (!had_is_home && 'isHome' %in% names(play_by_play)) {
          play_by_play[['isHome']] <- NULL
        }
        return(play_by_play)
      }
      ii <- which(idx)
      lp <- rep(beta0, length(ii))
      lp <- lp + beta_d * distance[ii]
      lp <- lp + beta_a * angle[ii]
      lp <- lp + beta_en * as.numeric(!is.na(ena[ii]) & ena[ii])
      st     <- strength[ii]
      pk_idx <- !is.na(st) & st == 'penalty-kill'
      pp_idx <- !is.na(st) & st == 'power-play'
      if (any(pk_idx)) {
        lp[pk_idx] <- lp[pk_idx] + beta_pk
      }
      if (any(pp_idx)) {
        lp[pp_idx] <- lp[pp_idx] + beta_pp
      }
      xg[ii] <- 1 / (1 + exp(-lp))
      play_by_play[['xG_v1']] <- xg
      final_names <- names(play_by_play)
      new_names   <- setdiff(final_names, original_names)
      allowed_new <- c('xG_v1')
      drop_names  <- setdiff(new_names, allowed_new)
      if (length(drop_names) > 0L) {
        play_by_play[drop_names] <- NULL
      }
      if (!had_is_home && 'isHome' %in% names(play_by_play)) {
        play_by_play[['isHome']] <- NULL
      }
      play_by_play
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      play_by_play
    }
  )
}

#' @rdname calculate_expected_goals_v1
#' @export

calculate_xG_v1 <- function(play_by_play) {
  calculate_expected_goals_v1(play_by_play)
}

#' Calculate version 2 of the expected goals for all the events (plays) in a 
#' play-by-play
#' 
#' `calculate_expected_goals_v2()` calculates version 2 of the expected goals 
#' for all the events (plays) in a play-by-play using a pre-estimated logistic 
#' regression model of goal probability on distance, angle, empty net, strength 
#' state, rebound, and rush indicators.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] 
#' and/or [wsc_play_by_play()] for reference; must be untouched by 
#' non-nhlscraper functions; saves time if [calculate_distance()], 
#' [calculate_angle()], [strip_situation_code()], [flag_is_rebound()], and/or 
#' [flag_is_rush()] have already been called
#' @returns data.frame with one row per event (play) and added `xG_v2` column
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test <- gc_play_by_play()
#'   test <- calculate_expected_goals_v2(test)
#' }
#' @export

calculate_expected_goals_v2 <- function(play_by_play) {
  tryCatch(
    expr = {
      beta0   <- -1.9963221
      beta_d  <- -0.0315542
      beta_a  <- -0.0080897
      beta_en <-  4.2879873
      beta_pk <-  0.6673946
      beta_pp <-  0.4089630
      beta_rb <-  0.4133378
      beta_rs <- -0.0657790
      original_names <- names(play_by_play)
      had_is_home  <- 'isHome'            %in% names(play_by_play)
      had_distance <- 'distance'          %in% names(play_by_play)
      had_angle    <- 'angle'             %in% names(play_by_play)
      had_ena      <- 'isEmptyNetAgainst' %in% names(play_by_play)
      had_strength <- 'strengthState'     %in% names(play_by_play)
      had_rebound  <- 'isRebound'         %in% names(play_by_play)
      had_rush     <- 'isRush'            %in% names(play_by_play)
      if (!had_is_home) {
        play_by_play <- flag_is_home(play_by_play)
      }
      if (!had_ena || !had_strength) {
        play_by_play <- strip_situation_code(play_by_play)
      }
      if (!had_distance) {
        play_by_play <- calculate_distance(play_by_play)
      }
      if (!had_angle) {
        play_by_play <- calculate_angle(play_by_play)
      }
      if (!had_rebound) {
        play_by_play <- flag_is_rebound(play_by_play)
      }
      if (!had_rush) {
        play_by_play <- flag_is_rush(play_by_play)
      }
      n  <- nrow(play_by_play)
      xg <- rep(NA_real_, n)
      distance <- as.numeric(play_by_play[['distance']])
      angle    <- as.numeric(play_by_play[['angle']])
      ena      <- as.logical(play_by_play[['isEmptyNetAgainst']])
      strength <- as.character(play_by_play[['strengthState']])
      rebound  <- as.logical(play_by_play[['isRebound']])
      rush     <- as.logical(play_by_play[['isRush']])
      raw_situation <- play_by_play[['situationCode']]
      situation_chr <- as.character(raw_situation)
      situation_pad <- rep(NA_character_, length(situation_chr))
      valid_sit     <- !is.na(situation_chr) & nchar(situation_chr) > 0L
      if (any(valid_sit)) {
        situation_pad[valid_sit] <- sprintf(
          '%04d', 
          as.integer(situation_chr[valid_sit])
        )
      }
      situation <- situation_pad
      type <- as.character(play_by_play[['typeDescKey']])
      bad_situation <- situation %in% c('0101', '1010')
      shot_types    <- c('goal', 'shot-on-goal', 'missed-shot', 'blocked-shot')
      is_shot       <- !is.na(type) & type %in% shot_types
      idx <- !is.na(situation) & !bad_situation & is_shot
      if (!any(idx)) {
        play_by_play[['xG_v2']] <- xg
        final_names <- names(play_by_play)
        new_names   <- setdiff(final_names, original_names)
        allowed_new <- c('xG_v2')
        drop_names  <- setdiff(new_names, allowed_new)
        if (length(drop_names) > 0L) {
          play_by_play[drop_names] <- NULL
        }
        if (!had_is_home && 'isHome' %in% names(play_by_play)) {
          play_by_play[['isHome']] <- NULL
        }
        return(play_by_play)
      }
      ii <- which(idx)
      lp <- rep(beta0, length(ii))
      lp <- lp + beta_d * distance[ii]
      lp <- lp + beta_a * angle[ii]
      lp <- lp + beta_en * as.numeric(!is.na(ena[ii]) & ena[ii])
      st     <- strength[ii]
      pk_idx <- !is.na(st) & st == 'penalty-kill'
      pp_idx <- !is.na(st) & st == 'power-play'
      if (any(pk_idx)) {
        lp[pk_idx] <- lp[pk_idx] + beta_pk
      }
      if (any(pp_idx)) {
        lp[pp_idx] <- lp[pp_idx] + beta_pp
      }
      lp <- lp + beta_rb * as.numeric(!is.na(rebound[ii]) & rebound[ii])
      lp <- lp + beta_rs * as.numeric(!is.na(rush[ii]) & rush[ii])
      xg[ii] <- 1 / (1 + exp(-lp))
      play_by_play[['xG_v2']] <- xg
      final_names <- names(play_by_play)
      new_names   <- setdiff(final_names, original_names)
      allowed_new <- c('xG_v2')
      drop_names  <- setdiff(new_names, allowed_new)
      if (length(drop_names) > 0L) {
        play_by_play[drop_names] <- NULL
      }
      if (!had_is_home && 'isHome' %in% names(play_by_play)) {
        play_by_play[['isHome']] <- NULL
      }
      play_by_play
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      play_by_play
    }
  )
}

#' @rdname calculate_expected_goals_v2
#' @export

calculate_xG_v2 <- function(play_by_play) {
  calculate_expected_goals_v2(play_by_play)
}

#' Calculate version 3 of the expected goals for all the events (plays) in a 
#' play-by-play
#' 
#' `calculate_expected_goals_v3()` calculates version 3 of the expected goals 
#' for all the events (plays) in a play-by-play using a pre-estimated logistic 
#' regression model of goal probability on distance, angle, empty net, strength 
#' state, rebound, rush, and goal differential.
#' 
#' @param play_by_play data.frame of play-by-play(s); see [gc_play_by_play()] 
#' and/or [wsc_play_by_play()] for reference; must be untouched by 
#' non-nhlscraper functions; saves time if [calculate_distance()], 
#' [calculate_angle()], [strip_situation_code()], [flag_is_rebound()], 
#' [flag_is_rush()], and/or [count_goals_shots()] have already been called
#' @returns data.frame with one row per event (play) and an added `xG_v3` 
#' column containing expected goals for applicable shot attempts.
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   test <- gc_play_by_play()
#'   test <- calculate_expected_goals_v3(test)
#' }
#' @export

calculate_expected_goals_v3 <- function(play_by_play) {
  tryCatch(
    expr = {
      beta0   <- -1.9942500
      beta_d  <- -0.0315190
      beta_a  <- -0.0080823
      beta_en <-  4.2126061
      beta_pk <-  0.6601609
      beta_pp <-  0.4106154
      beta_rb <-  0.4172151
      beta_rs <- -0.0709434
      beta_gd <-  0.0424470
      original_names <- names(play_by_play)
      had_is_home  <- 'isHome'            %in% names(play_by_play)
      had_distance <- 'distance'          %in% names(play_by_play)
      had_angle    <- 'angle'             %in% names(play_by_play)
      had_ena      <- 'isEmptyNetAgainst' %in% names(play_by_play)
      had_strength <- 'strengthState'     %in% names(play_by_play)
      had_rebound  <- 'isRebound'         %in% names(play_by_play)
      had_rush     <- 'isRush'            %in% names(play_by_play)
      had_gd       <- 'goalDifferential'  %in% names(play_by_play)
      if (!had_is_home) {
        play_by_play <- flag_is_home(play_by_play)
      }
      if (!had_ena || !had_strength) {
        play_by_play <- strip_situation_code(play_by_play)
      }
      if (!had_distance) {
        play_by_play <- calculate_distance(play_by_play)
      }
      if (!had_angle) {
        play_by_play <- calculate_angle(play_by_play)
      }
      if (!had_rebound) {
        play_by_play <- flag_is_rebound(play_by_play)
      }
      if (!had_rush) {
        play_by_play <- flag_is_rush(play_by_play)
      }
      if (!had_gd) {
        play_by_play <- count_goals_shots(play_by_play)
      }
      n  <- nrow(play_by_play)
      xg <- rep(NA_real_, n)
      distance <- as.numeric(play_by_play[['distance']])
      angle    <- as.numeric(play_by_play[['angle']])
      ena      <- as.logical(play_by_play[['isEmptyNetAgainst']])
      strength <- as.character(play_by_play[['strengthState']])
      rebound  <- as.logical(play_by_play[['isRebound']])
      rush     <- as.logical(play_by_play[['isRush']])
      gd       <- as.numeric(play_by_play[['goalDifferential']])
      raw_situation <- play_by_play[['situationCode']]
      situation_chr <- as.character(raw_situation)
      situation_pad <- rep(NA_character_, length(situation_chr))
      valid_sit     <- !is.na(situation_chr) & nchar(situation_chr) > 0L
      if (any(valid_sit)) {
        situation_pad[valid_sit] <- sprintf(
          '%04d',
          as.integer(situation_chr[valid_sit])
        )
      }
      situation <- situation_pad
      type <- as.character(play_by_play[['typeDescKey']])
      bad_situation <- situation %in% c('0101', '1010')
      shot_types    <- c('goal', 'shot-on-goal', 'missed-shot', 'blocked-shot')
      is_shot       <- !is.na(type) & type %in% shot_types
      idx <- !is.na(situation) & !bad_situation & is_shot
      if (!any(idx)) {
        play_by_play[['xG_v3']] <- xg
        final_names <- names(play_by_play)
        new_names   <- setdiff(final_names, original_names)
        allowed_new <- c('xG_v3')
        drop_names  <- setdiff(new_names, allowed_new)
        if (length(drop_names) > 0L) {
          play_by_play[drop_names] <- NULL
        }
        if (!had_is_home && 'isHome' %in% names(play_by_play)) {
          play_by_play[['isHome']] <- NULL
        }
        return(play_by_play)
      }
      ii <- which(idx)
      lp <- rep(beta0, length(ii))
      lp <- lp + beta_d * distance[ii]
      lp <- lp + beta_a * angle[ii]
      lp <- lp + beta_en * as.numeric(!is.na(ena[ii]) & ena[ii])
      st     <- strength[ii]
      pk_idx <- !is.na(st) & st == 'penalty-kill'
      pp_idx <- !is.na(st) & st == 'power-play'
      
      if (any(pk_idx)) {
        lp[pk_idx] <- lp[pk_idx] + beta_pk
      }
      if (any(pp_idx)) {
        lp[pp_idx] <- lp[pp_idx] + beta_pp
      }
      lp <- lp + beta_rb * as.numeric(!is.na(rebound[ii]) & rebound[ii])
      lp <- lp + beta_rs * as.numeric(!is.na(rush[ii]) & rush[ii])
      lp <- lp + beta_gd * gd[ii]
      xg[ii] <- 1 / (1 + exp(-lp))
      play_by_play[['xG_v3']] <- xg
      final_names <- names(play_by_play)
      new_names   <- setdiff(final_names, original_names)
      allowed_new <- c('xG_v3')
      drop_names  <- setdiff(new_names, allowed_new)
      if (length(drop_names) > 0L) {
        play_by_play[drop_names] <- NULL
      }
      if (!had_is_home && 'isHome' %in% names(play_by_play)) {
        play_by_play[['isHome']] <- NULL
      }
      play_by_play
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      play_by_play
    }
  )
}

#' @rdname calculate_expected_goals_v3
#' @export

calculate_xG_v3 <- function(play_by_play) {
  calculate_expected_goals_v2(play_by_play)
}
