#' Access all contracts from packaged internal data
#'
#' `contracts()` loads preprocessed contract records bundled with the package and returns a cleaned `data.frame` with package-consistent column names, season IDs, numeric money fields, and team/player identifiers.
#'
#' @returns data.frame with one row per contract
#' @examples
#' \donttest{all_contracts <- contracts()}
#' @export

contracts <- function() {
  tryCatch(
    expr = {
      normalize_person_key <- function(x) {
        x <- as.character(x)
        x <- iconv(x, from = '', to = 'ASCII//TRANSLIT')
        x[is.na(x)] <- ''
        x <- tolower(trimws(x))
        x <- gsub('[^a-z0-9]', '', x)
        x
      }
      allowed_positions <- function(pos) {
        switch(
          toupper(trimws(as.character(pos))),
          C  = 'C',
          D  = 'D',
          G  = 'G',
          LW = c('L', 'LW'),
          RW = c('R', 'RW'),
          F  = c('C', 'L', 'R', 'F'),
          character(0)
        )
      }
      out <- get('.contracts_base', inherits = TRUE)
      dropped_duplicate_rows <- attr(out, 'droppedDuplicateRows')
      dropped_invalid_season <- attr(out, 'droppedInvalidSeasonRows')
      if (is.null(dropped_duplicate_rows)) dropped_duplicate_rows <- NA_integer_
      if (is.null(dropped_invalid_season)) dropped_invalid_season <- NA_integer_
      if (!is.data.frame(out) || !nrow(out)) {
        out <- data.frame(
          playerId = integer(),
          playerFullName = character(),
          positionCode = character(),
          ageAtSigning = integer(),
          signedWithTeamId = integer(),
          signedWithTeamTriCode = character(),
          startSeasonId = integer(),
          endSeasonId = integer(),
          term = integer(),
          aav = numeric(),
          value = numeric(),
          bonus = numeric(),
          twoYearCash = numeric(),
          threeYearCash = numeric(),
          stringsAsFactors = FALSE
        )
        attr(out, 'droppedDuplicateRows') <- dropped_duplicate_rows
        attr(out, 'droppedInvalidSeasonRows') <- dropped_invalid_season
        attr(out, 'droppedUnresolvedPlayers') <- NA_integer_
        return(out)
      }
      players_tbl  <- players()
      out$playerId <- NA_integer_
      dropped_unresolved <- NA_integer_
      if (is.data.frame(players_tbl) && nrow(players_tbl) > 0L) {
        req_cols <- c(
          'playerId',
          'playerFullName',
          'playerFirstName',
          'playerLastName',
          'positionCode',
          'birthDate',
          'currentTeamId',
          'careerTeamId',
          'firstSignedByTeamId',
          'lastNHLTeamId',
          'onRoster'
        )
        req_cols <- req_cols[req_cols %in% names(players_tbl)]
        p <- players_tbl[, req_cols, drop = FALSE]
        p$birthYear <- suppressWarnings(as.integer(substr(as.character(p$birthDate), 1L, 4L)))
        p$key1  <- normalize_person_key(p$playerFullName)
        p$key2  <- normalize_person_key(paste(p$playerFirstName, p$playerLastName))
        idx_tbl <- rbind(
          data.frame(key = p$key1, idx = seq_len(nrow(p)), stringsAsFactors = FALSE),
          data.frame(key = p$key2, idx = seq_len(nrow(p)), stringsAsFactors = FALSE)
        )
        idx_tbl <- idx_tbl[nzchar(idx_tbl$key), , drop = FALSE]
        idx_tbl <- unique(idx_tbl)
        key_map <- split(idx_tbl$idx, idx_tbl$key)
        c_key <- normalize_person_key(out$playerFullName)
        c_pos <- out$positionCode
        c_tid <- out$teamId
        c_start_year <- out$startSeasonId %/% 10000L
        c_age <- out$ageAtSigning
        matched_player_id <- rep(NA_integer_, nrow(out))
        matched_player_full_name <- rep(NA_character_, nrow(out))
        for (i in seq_len(nrow(out))) {
          idx <- key_map[[c_key[[i]]]]
          if (is.null(idx) || !length(idx)) next
          idx <- unique(idx)
          pos_allowed <- allowed_positions(c_pos[[i]])
          if (length(pos_allowed) && 'positionCode' %in% names(p)) {
            pos_keep <- p$positionCode[idx] %in% pos_allowed
            if (any(pos_keep, na.rm = TRUE)) idx <- idx[pos_keep]
          }
          if ('birthYear' %in% names(p) && !is.na(c_start_year[[i]]) && !is.na(c_age[[i]])) {
            expected <- c(
              c_start_year[[i]] - c_age[[i]] - 1L,
              c_start_year[[i]] - c_age[[i]],
              c_start_year[[i]] - c_age[[i]] + 1L
            )
            by_keep <- p$birthYear[idx] %in% expected
            if (any(by_keep, na.rm = TRUE)) idx <- idx[by_keep]
          }
          if (!is.na(c_tid[[i]])) {
            team_hits <- rep(FALSE, length(idx))
            team_cols <- c('currentTeamId', 'careerTeamId', 'firstSignedByTeamId', 'lastNHLTeamId')
            team_cols <- team_cols[team_cols %in% names(p)]
            if (length(team_cols)) {
              for (tc in team_cols) {
                team_hits <- team_hits | (p[[tc]][idx] == c_tid[[i]])
              }
              if (any(team_hits, na.rm = TRUE)) idx <- idx[team_hits]
            }
          }
          if (length(idx) > 1L && 'onRoster' %in% names(p) && !is.na(c_start_year[[i]]) && c_start_year[[i]] >= 2020L) {
            roster_keep <- p$onRoster[idx] == 'Y'
            if (any(roster_keep, na.rm = TRUE)) idx <- idx[roster_keep]
          }
          idx <- unique(idx)
          if (length(idx) == 1L) {
            matched_player_id[[i]] <- suppressWarnings(as.integer(p$playerId[idx]))
            matched_player_full_name[[i]] <- as.character(p$playerFullName[idx])
          }
        }
        out$playerId <- matched_player_id
        out$playerFullName <- ifelse(
          is.na(matched_player_full_name) | matched_player_full_name == '',
          out$playerFullName,
          matched_player_full_name
        )
        unresolved <- is.na(out$playerId)
        dropped_unresolved <- sum(unresolved)
        out <- out[!unresolved, , drop = FALSE]
        message(
          sprintf(
            'Dropped %s row(s) with unresolved/ambiguous playerId matches.',
            dropped_unresolved
          )
        )
      } else {
        message(
          'Unable to access players() for playerId matching; ',
          'returning cleaned contracts with NA playerId.'
        )
      }
      out <- out[, c(
        'playerId',
        'playerFullName',
        'positionCode',
        'ageAtSigning',
        'signedWithTeamId',
        'signedWithTriCode',
        'startSeasonId',
        'endSeasonId',
        'contractYears',
        'contractAAV',
        'contractValue',
        'signingBonus',
        'twoYearCash',
        'threeYearCash'
      )]
      names(out)[names(out) == 'signedWithTriCode'] <- 'signedWithTeamTriCode'
      names(out)[names(out) == 'contractYears'] <- 'term'
      names(out)[names(out) == 'contractAAV']   <- 'aav'
      names(out)[names(out) == 'contractValue'] <- 'value'
      names(out)[names(out) == 'signingBonus']  <- 'bonus'
      out <- out[order(out$playerFullName, out$startSeasonId), , drop = FALSE]
      rownames(out) <- NULL
      attr(out, 'droppedDuplicateRows') <- dropped_duplicate_rows
      attr(out, 'droppedInvalidSeasonRows') <- dropped_invalid_season
      attr(out, 'droppedUnresolvedPlayers') <- dropped_unresolved
      out
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the GameCenter (GC) play-by-plays for a season
#' 
#' `gc_play_by_plays()` loads the GC play-by-plays for a given `season`.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per event (play) per game
#' @examples
#' # May take >5s, so skip.
#' \donttest{gc_pbps_20212022 <- gc_play_by_plays(season = 20212022)}
#' @export

gc_play_by_plays <- function(season = 20242025) {
  tryCatch(
    expr = {
      u <- paste0(
        'https://huggingface.co/datasets/RentoSaijo/NHL_DB/resolve/main/',
        'data/game/pbps/gc/NHL_PBPS_GC_',
        season,
        '.parquet'
      )
      tmp <- tempfile(fileext = '.parquet')
      utils::download.file(u, tmp, mode = 'wb', quiet = TRUE)
      pbps <- as.data.frame(arrow::read_parquet(tmp), stringsAsFactors = FALSE)
      raw_situation <- pbps[['situationCode']]
      situation_chr <- as.character(raw_situation)
      situation_pad <- rep(NA_character_, length(situation_chr))
      valid         <- !is.na(situation_chr) & nchar(situation_chr) > 0
      if (any(valid)) {
        situation_pad[valid] <- sprintf('%04d', as.integer(situation_chr[valid]))
      }
      pbps[['situationCode']] <- situation_pad
      pbps
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' @rdname gc_play_by_plays
#' @export

gc_pbps <- function(season = 20242025) {
  gc_play_by_plays(season)
}

#' Access the World Showcase (WSC) play-by-plays for a season
#' 
#' `wsc_play_by_plays()` loads the WSC play-by-plays for a given `season`.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per event (play) per game
#' @examples
#' # May take >5s, so skip.
#' \donttest{wsc_pbps_20212022 <- wsc_play_by_plays(season = 20212022)}
#' @export

wsc_play_by_plays <- function(season = 20242025) {
  tryCatch(
    expr = {
      u <- paste0(
        'https://huggingface.co/datasets/RentoSaijo/NHL_DB/resolve/main/',
        'data/game/pbps/wsc/NHL_PBPS_WSC_',
        season,
        '.parquet'
      )
      tmp <- tempfile(fileext = '.parquet')
      utils::download.file(u, tmp, mode = 'wb', quiet = TRUE)
      pbps <- as.data.frame(arrow::read_parquet(tmp), stringsAsFactors = FALSE)
      raw_situation <- pbps[['situationCode']]
      situation_chr <- as.character(raw_situation)
      situation_pad <- rep(NA_character_, length(situation_chr))
      valid         <- !is.na(situation_chr) & nchar(situation_chr) > 0
      if (any(valid)) {
        situation_pad[valid] <- sprintf('%04d', as.integer(situation_chr[valid]))
      }
      pbps[['situationCode']] <- situation_pad
      pbps
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' @rdname wsc_play_by_plays
#' @export

wsc_pbps <- function(season = 20242025) {
  wsc_play_by_plays(season)
}

#' Access the shift charts for a season
#' 
#' `shift_charts()` loads the shift charts for a given `season`.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per event (play) per game
#' @examples
#' # May take >5s, so skip.
#' \donttest{shift_charts_20212022 <- shift_charts(season = 20212022)}
#' @export

shift_charts <- function(season = 20242025) {
  tryCatch(
    expr = {
      u <- paste0(
        'https://huggingface.co/datasets/RentoSaijo/NHL_DB/resolve/main/',
        'data/game/scs/NHL_SCS_',
        season,
        '.parquet'
      )
      tmp <- tempfile(fileext = '.parquet')
      utils::download.file(u, tmp, mode = 'wb', quiet = TRUE)
      shifts <- as.data.frame(arrow::read_parquet(tmp), stringsAsFactors = FALSE)
      shifts$id <- NULL
      shifts
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the replays for a season
#' 
#' `replays()` loads the replays for a given `season`.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per decisecond
#' @examples
#' # May take >5s, so skip.
#' \donttest{replays_20252026 <- replays(season = 20252026)}
#' @export

replays <- function(season = 20242025) {
  old_timeout <- getOption('timeout')
  on.exit(options(timeout = old_timeout), add = TRUE)
  options(timeout = 600)
  tryCatch(
    expr = {
      u <- paste0(
        'https://huggingface.co/datasets/RentoSaijo/NHL_DB/resolve/main/',
        'data/event/replays/NHL_REPLAYS_', 
        season, 
        '.parquet'
      )
      tmp <- tempfile(fileext = '.parquet')
      utils::download.file(u, tmp, mode = 'wb', quiet = TRUE, method = 'libcurl')
      as.data.frame(arrow::read_parquet(tmp), stringsAsFactors = FALSE)
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
