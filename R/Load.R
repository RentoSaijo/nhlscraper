# ----- Packaged Data ----- #

#' Access all contracts from packaged internal data
#'
#' `contracts()` loads preprocessed contract records bundled with the package,
#' resolves each row to an NHL player ID when the player registry has a clear
#' match, drops unresolved/ambiguous matches, and returns normalized contract
#' seasons and money fields.
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
        matched_position_code <- rep(NA_character_, nrow(out))
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
            if ('positionCode' %in% names(p)) {
              matched_position_code[[i]] <- as.character(p$positionCode[idx])
            }
          }
        }
        out$playerId <- matched_player_id
        out$playerFullName <- ifelse(
          is.na(matched_player_full_name) | matched_player_full_name == '',
          out$playerFullName,
          matched_player_full_name
        )
        out$positionCode <- ifelse(
          is.na(matched_position_code) | matched_position_code == '',
          out$positionCode,
          matched_position_code
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
        'signingBonus'
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

# ----- Remote Parquet Loaders ----- #

#' Build a Hugging Face NHL_DB parquet URL
#'
#' `.nhldb_url()` builds URLs for the season-level parquet snapshots used by
#' the bulk loaders.
#'
#' @param path character path inside the NHL_DB repository
#' @returns character scalar URL
#' @keywords internal
.nhldb_url <- function(path) {
  paste0(
    'https://huggingface.co/datasets/RentoSaijo/NHL_DB/resolve/main/',
    path
  )
}

#' Download and read a remote parquet file
#'
#' `.read_remote_parquet()` downloads a parquet file to a temporary path and
#' returns it as a base data.frame.
#'
#' @param path character path inside the NHL_DB repository
#' @param timeout optional download timeout in seconds
#' @param method optional `utils::download.file()` method
#' @returns data.frame
#' @keywords internal
.read_remote_parquet <- function(path, timeout = NULL, method = NULL) {
  if (!is.null(timeout)) {
    old_timeout <- getOption('timeout')
    on.exit(options(timeout = old_timeout), add = TRUE)
    options(timeout = timeout)
  }
  tmp <- tempfile(fileext = '.parquet')
  on.exit(unlink(tmp), add = TRUE)
  args <- list(
    url      = .nhldb_url(path),
    destfile = tmp,
    mode     = 'wb',
    quiet    = TRUE
  )
  if (!is.null(method)) {
    args$method <- method
  }
  do.call(utils::download.file, args)
  as.data.frame(arrow::read_parquet(tmp), stringsAsFactors = FALSE)
}

#' Pad public situation codes
#'
#' `.pad_public_situation_code()` preserves missing values and zero-pads
#' nonempty situation codes to the four-character public play-by-play form.
#'
#' @param play_by_plays data.frame containing `situationCode`
#' @returns data.frame
#' @keywords internal
.pad_public_situation_code <- function(play_by_plays) {
  if (!('situationCode' %in% names(play_by_plays))) {
    return(play_by_plays)
  }
  raw_situation <- play_by_plays[['situationCode']]
  situation_chr <- as.character(raw_situation)
  situation_pad <- rep(NA_character_, length(situation_chr))
  valid         <- !is.na(situation_chr) & nchar(situation_chr) > 0
  if (any(valid)) {
    situation_pad[valid] <- sprintf('%04d', as.integer(situation_chr[valid]))
  }
  play_by_plays[['situationCode']] <- situation_pad
  play_by_plays
}

#' Access the raw GameCenter (GC) play-by-plays for a season
#' 
#' `gc_play_by_plays_raw()` downloads the stored season-level GameCenter
#' parquet snapshot and returns the raw rows without public-schema cleanup or
#' situation-code padding.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per raw event (play) per game
#' @examples
#' # May take >5s, so skip.
#' \donttest{gc_pbps_raw_20212022 <- gc_play_by_plays_raw(season = 20212022)}
#' @export

gc_play_by_plays_raw <- function(season = 20242025) {
  tryCatch(
    expr = {
      .read_remote_parquet(sprintf(
        'data/game/pbps/gc/NHL_PBPS_GC_Raw_%s.parquet',
        season
      ))
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' @rdname gc_play_by_plays_raw
#' @export

gc_pbps_raw <- function(season = 20242025) {
  gc_play_by_plays_raw(season)
}

#' Access the GameCenter (GC) play-by-plays for a season
#' 
#' `gc_play_by_plays()` downloads the cleaned season-level GameCenter parquet
#' snapshot and pads `situationCode` to the four-character public format.
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
      .read_remote_parquet(sprintf(
        'data/game/pbps/gc/NHL_PBPS_GC_%s.parquet',
        season
      )) |>
        .pad_public_situation_code()
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

#' Access the raw World Showcase (WSC) play-by-plays for a season
#' 
#' `wsc_play_by_plays_raw()` downloads the stored season-level World Showcase
#' parquet snapshot and returns the raw rows without public-schema cleanup or
#' situation-code padding.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per raw event (play) per game
#' @examples
#' # May take >5s, so skip.
#' \donttest{wsc_pbps_raw_20212022 <- wsc_play_by_plays_raw(season = 20212022)}
#' @export

wsc_play_by_plays_raw <- function(season = 20242025) {
  tryCatch(
    expr = {
      .read_remote_parquet(sprintf(
        'data/game/pbps/wsc/NHL_PBPS_WSC_Raw_%s.parquet',
        season
      ))
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' @rdname wsc_play_by_plays_raw
#' @export

wsc_pbps_raw <- function(season = 20242025) {
  wsc_play_by_plays_raw(season)
}

#' Access the World Showcase (WSC) play-by-plays for a season
#' 
#' `wsc_play_by_plays()` downloads the cleaned season-level World Showcase
#' parquet snapshot and pads `situationCode` to the four-character public
#' format.
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
      .read_remote_parquet(sprintf(
        'data/game/pbps/wsc/NHL_PBPS_WSC_%s.parquet',
        season
      )) |>
        .pad_public_situation_code()
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
#' `shift_charts()` downloads the stored season-level shift-chart parquet
#' snapshot, removes the storage-only `id` column, and returns one row per
#' parsed shift.
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
      shifts <- .read_remote_parquet(sprintf(
        'data/game/scs/NHL_SCS_%s.parquet',
        season
      ))
      shifts$id <- NULL
      shifts
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the shift chart summaries for a season
#' 
#' `shift_chart_summaries()` downloads the stored season-level shift-summary
#' parquet snapshot with per-player, per-period time-on-ice splits.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per player per period
#' @examples
#' # May take >5s, so skip.
#' \donttest{shift_chart_summaries_20212022 <- shift_chart_summaries(season = 20212022)}
#' @export

shift_chart_summaries <- function(season = 20242025) {
  tryCatch(
    expr = {
      .read_remote_parquet(sprintf(
        'data/game/scss/NHL_SCSS_%s.parquet',
        season
      ))
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}

#' Access the replays for a season
#' 
#' `replays()` downloads the stored season-level puck/player tracking parquet
#' snapshot and returns one row per tracked decisecond.
#' 
#' @inheritParams roster
#' @returns data.frame with one row per decisecond
#' @examples
#' # May take >5s, so skip.
#' \donttest{replays_20252026 <- replays(season = 20252026)}
#' @export

replays <- function(season = 20242025) {
  tryCatch(
    expr = {
      .read_remote_parquet(
        path = sprintf('data/event/replays/NHL_REPLAYS_%s.parquet', season),
        timeout = 600,
        method = 'libcurl'
      )
    },
    error = function(e) {
      message('Invalid argument(s); refer to help file.')
      data.frame()
    }
  )
}
