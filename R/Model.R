#' Calculate the expected goals for all the shots in (a) play-by-plays
#' 
#' `calculate_expected_goals()` calculates the expected goals for all the shots in (a) play-by-play(s) using the provided `model`.
#'
#' @inheritParams add_on_ice_players
#' @param model integer in 1:4 indicating which expected goals model to use; see web documentation for what variables each model considers
#' @returns data.frame with one row per event (play) and added `xG` column
#' @examples
#' # May take >5s, so skip.
#' \donttest{
#'   pbp <- gc_play_by_play()
#'   pbp_with_xG_v3 <- calculate_expected_goals(play_by_play = pbp, model = 3)
#' }
#' @export

calculate_expected_goals <- function(play_by_play, model = 1) {
  tryCatch(
    expr = {
      # Clean data.
      model <- as.integer(model[1])
      pbp <- play_by_play |>
        calculate_speed() |>
        add_shooter_biometrics() |>
        add_goalie_biometrics()
      pbp$shotType[is.na(pbp$shotType)] <- 'backhand'
      pbp$shooterSide[is.na(pbp$shooterSide)] <- 'neutral'
      pbp$shooterPositionCode[is.na(pbp$shooterPositionCode)] <- 'C'
      pbp$goalieSide[is.na(pbp$goalieSide)] <- 'blocker'

      # Store coefficients.
      COEFS <- list(
        sd = list(
          v1 = c(
            '(Intercept)' = -0.98490308,
            'distance' = -0.06117233,
            'angle' = -0.01729914,
            'shotTypebat' = 0.34448407,
            'shotTypebetween-legs' = -0.56383023,
            'shotTypecradle' = 1.16205222,
            'shotTypedeflected' = -0.17143865,
            'shotTypepoke' = 0.10484560,
            'shotTypeslap' = 0.99107913,
            'shotTypesnap' = 0.87211406,
            'shotTypetip-in' = -0.32018820,
            'shotTypewrap-around' = -0.33413555,
            'shotTypewrist' = 0.50196909
          ),
          v2 = c(
            '(Intercept)' = -0.851759846,
            'distance' = -0.062748566,
            'angle' = -0.019147181,
            'shotTypebat' = 0.363774969,
            'shotTypebetween-legs' = -0.553760807,
            'shotTypecradle' = 1.146786095,
            'shotTypedeflected' = -0.170002916,
            'shotTypepoke' = 0.138769743,
            'shotTypeslap' = 0.996510214,
            'shotTypesnap' = 0.875946758,
            'shotTypetip-in' = -0.335587108,
            'shotTypewrap-around' = -0.319782711,
            'shotTypewrist' = 0.504137302,
            'dDdT' = 0.005895507,
            'dAdT' = 0.007144895,
            'isRushTRUE' = 0.269619958,
            'isReboundTRUE' = -0.062443827
          ),
          v3 = c(
            '(Intercept)' = -8.591879e-01,
            'distance' = -6.265781e-02,
            'angle' = -1.909957e-02,
            'shotTypebat' = 3.625138e-01,
            'shotTypebetween-legs' = -5.580147e-01,
            'shotTypecradle' = 1.138743e+00,
            'shotTypedeflected' = -1.655748e-01,
            'shotTypepoke' = 1.372451e-01,
            'shotTypeslap' = 9.954958e-01,
            'shotTypesnap' = 8.762127e-01,
            'shotTypetip-in' = -3.322160e-01,
            'shotTypewrap-around' = -3.181418e-01,
            'shotTypewrist' = 5.031961e-01,
            'dDdT' = 5.881723e-03,
            'dAdT' = 7.099477e-03,
            'isRushTRUE' = 2.684510e-01,
            'isReboundTRUE' = -5.805528e-02,
            'isHomeTRUE' = -1.028862e-02,
            'isPlayoffTRUE' = -5.131636e-02,
            'secondsElapsedInGame' = 3.934651e-06,
            'goalsFor' = 2.647579e-02,
            'goalsAgainst' = -2.251840e-02
          ),
          v4 = c(
            '(Intercept)' = 1.358799e+01,
            'distance' = -6.468632e-02,
            'angle' = -2.036697e-02,
            'shotTypebat' = 3.585686e-01,
            'shotTypebetween-legs' = -5.682836e-01,
            'shotTypecradle' = 1.191735e+00,
            'shotTypedeflected' = -1.669111e-01,
            'shotTypepoke' = 1.358653e-01,
            'shotTypeslap' = 9.758869e-01,
            'shotTypesnap' = 8.654233e-01,
            'shotTypetip-in' = -3.342726e-01,
            'shotTypewrap-around' = -3.032518e-01,
            'shotTypewrist' = 4.930872e-01,
            'dDdT' = 5.863702e-03,
            'dAdT' = 7.155146e-03,
            'isRushTRUE' = 2.717119e-01,
            'isReboundTRUE' = -5.023591e-02,
            'isHomeTRUE' = -1.103323e-02,
            'isPlayoffTRUE' = -4.732375e-02,
            'secondsElapsedInGame' = 4.211979e-06,
            'goalsFor' = 2.667161e-02,
            'goalsAgainst' = -2.302126e-02,
            'shooterHeight' = 3.454738e-03,
            'shooterWeight' = -3.524754e-04,
            'shooterSideoffwing' = -1.474600e+01,
            'shooterSideonwing' = -1.484256e+01,
            'shooterPositionCodeD' = 1.085171e-01,
            'shooterPositionCodeG' = 1.068593e-01,
            'shooterPositionCodeL' = 1.133494e-02,
            'shooterPositionCodeR' = 6.167487e-02,
            'goalieHeight' = 5.355993e-03,
            'goalieWeight' = -7.149274e-04,
            'goalieSideglove' = 2.152146e-02,
            'goalieSideneutral' = -1.488056e+01
          )
        ),
        sp = list(
          v1 = c(
            '(Intercept)' = -0.231681304,
            'isEmptyNetForTRUE' = 0.010997208,
            'skaterCountFor' = -0.079911759,
            'skaterCountAgainst' = -0.130329305,
            'distance' = -0.050555300,
            'angle' = -0.009144413,
            'shotTypebat' = 0.286790983,
            'shotTypebetween-legs' = -0.071029117,
            'shotTypecradle' = -8.379670235,
            'shotTypedeflected' = 0.049069014,
            'shotTypepoke' = -0.003736220,
            'shotTypeslap' = 0.944120508,
            'shotTypesnap' = 0.850906556,
            'shotTypetip-in' = -0.013811760,
            'shotTypewrap-around' = 0.006765519,
            'shotTypewrist' = 0.406541000
          ),
          v2 = c(
            '(Intercept)' = -0.179126629,
            'isEmptyNetForTRUE' = 0.011441415,
            'skaterCountFor' = -0.075789473,
            'skaterCountAgainst' = -0.130189129,
            'distance' = -0.051356634,
            'angle' = -0.010407777,
            'shotTypebat' = 0.304715861,
            'shotTypebetween-legs' = -0.073641979,
            'shotTypecradle' = -8.408172791,
            'shotTypedeflected' = 0.039711706,
            'shotTypepoke' = 0.002284196,
            'shotTypeslap' = 0.945995831,
            'shotTypesnap' = 0.850367624,
            'shotTypetip-in' = -0.028192496,
            'shotTypewrap-around' = 0.016365962,
            'shotTypewrist' = 0.405475291,
            'dDdT' = 0.004630362,
            'dAdT' = 0.005238069,
            'isRushTRUE' = 0.253084801,
            'isReboundTRUE' = -0.011364569
          ),
          v3 = c(
            '(Intercept)' = -1.518275e-01,
            'isEmptyNetForTRUE' = 5.117703e-02,
            'skaterCountFor' = -7.795264e-02,
            'skaterCountAgainst' = -1.347474e-01,
            'distance' = -5.128837e-02,
            'angle' = -1.040606e-02,
            'shotTypebat' = 3.036384e-01,
            'shotTypebetween-legs' = -7.778691e-02,
            'shotTypecradle' = -8.392727e+00,
            'shotTypedeflected' = 3.891587e-02,
            'shotTypepoke' = 3.908659e-04,
            'shotTypeslap' = 9.454977e-01,
            'shotTypesnap' = 8.493494e-01,
            'shotTypetip-in' = -2.722527e-02,
            'shotTypewrap-around' = 1.949897e-02,
            'shotTypewrist' = 4.058403e-01,
            'dDdT' = 4.634296e-03,
            'dAdT' = 5.229569e-03,
            'isRushTRUE' = 2.508792e-01,
            'isReboundTRUE' = -8.565525e-03,
            'isHomeTRUE' = 3.274853e-03,
            'isPlayoffTRUE' = 6.925105e-02,
            'secondsElapsedInGame' = -1.574121e-05,
            'goalsFor' = 2.997044e-02,
            'goalsAgainst' = -1.303492e-02
          ),
          v4 = c(
            '(Intercept)' = 1.625248e+01,
            'isEmptyNetForTRUE' = 4.902405e-02,
            'skaterCountFor' = -9.006717e-02,
            'skaterCountAgainst' = -1.213031e-01,
            'distance' = -5.096500e-02,
            'angle' = -1.096294e-02,
            'shotTypebat' = 2.808649e-01,
            'shotTypebetween-legs' = -1.167339e-01,
            'shotTypecradle' = -1.032894e+01,
            'shotTypedeflected' = 1.715449e-02,
            'shotTypepoke' = -2.886184e-02,
            'shotTypeslap' = 8.731276e-01,
            'shotTypesnap' = 8.242781e-01,
            'shotTypetip-in' = -4.734299e-02,
            'shotTypewrap-around' = -9.690236e-03,
            'shotTypewrist' = 3.788254e-01,
            'dDdT' = 4.578223e-03,
            'dAdT' = 5.432974e-03,
            'isRushTRUE' = 2.458077e-01,
            'isReboundTRUE' = -2.676404e-03,
            'isHomeTRUE' = 3.333150e-03,
            'isPlayoffTRUE' = 7.971748e-02,
            'secondsElapsedInGame' = -1.554238e-05,
            'goalsFor' = 3.014479e-02,
            'goalsAgainst' = -1.219582e-02,
            'shooterHeight' = -7.934626e-03,
            'shooterWeight' = 9.449099e-04,
            'shooterSideoffwing' = -1.548852e+01,
            'shooterSideonwing' = -1.572523e+01,
            'shooterPositionCodeD' = -9.456997e-03,
            'shooterPositionCodeG' = -3.205893e+00,
            'shooterPositionCodeL' = -6.091360e-02,
            'shooterPositionCodeR' = 2.934768e-02,
            'goalieHeight' = -6.767774e-05,
            'goalieWeight' = -2.012066e-03,
            'goalieSideglove' = 8.633985e-02,
            'goalieSideneutral' = -1.556393e+01
          )
        ),
        en = list(
          v1 = c(
            '(Intercept)' = 0.56617905,
            'skaterCountFor' = -0.10099230,
            'skaterCountAgainst' = 0.31510574,
            'distance' = -0.01926386,
            'angle' = -0.02735554,
            'shotTypebat' = 0.33808842,
            'shotTypedeflected' = 13.58501688,
            'shotTypepoke' = 1.47199740,
            'shotTypeslap' = 0.48728926,
            'shotTypesnap' = 0.84619740,
            'shotTypetip-in' = 0.13400586,
            'shotTypewrap-around' = 1.35667713,
            'shotTypewrist' = 0.71661735
          ),
          v2 = c(
            '(Intercept)' = 0.619137784,
            'skaterCountFor' = -0.098333748,
            'skaterCountAgainst' = 0.317859331,
            'distance' = -0.019195197,
            'angle' = -0.028756798,
            'shotTypebat' = 0.578877103,
            'shotTypedeflected' = 13.525530973,
            'shotTypepoke' = 1.426099635,
            'shotTypeslap' = 0.526498857,
            'shotTypesnap' = 0.828427490,
            'shotTypetip-in' = 0.084621786,
            'shotTypewrap-around' = 1.338129273,
            'shotTypewrist' = 0.712539681,
            'dDdT' = -0.001502894,
            'dAdT' = 0.008804639,
            'isRushTRUE' = -0.241240648,
            'isReboundTRUE' = -0.641233998
          ),
          v3 = c(
            '(Intercept)' = -0.611008803,
            'skaterCountFor' = -0.114999412,
            'skaterCountAgainst' = 0.336639102,
            'distance' = -0.019144660,
            'angle' = -0.028635430,
            'shotTypebat' = 0.670125310,
            'shotTypedeflected' = 13.475354525,
            'shotTypepoke' = 1.408704963,
            'shotTypeslap' = 0.520973953,
            'shotTypesnap' = 0.824006348,
            'shotTypetip-in' = 0.106795157,
            'shotTypewrap-around' = 1.309763501,
            'shotTypewrist' = 0.709009118,
            'dDdT' = -0.001515512,
            'dAdT' = 0.008845728,
            'isRushTRUE' = -0.244698912,
            'isReboundTRUE' = -0.657496487,
            'isHomeTRUE' = -0.087014921,
            'isPlayoffTRUE' = 0.123455041,
            'secondsElapsedInGame' = 0.000348662,
            'goalsFor' = -0.008033584,
            'goalsAgainst' = 0.022890598
          ),
          v4 = c(
            '(Intercept)' = 1.6096771896,
            'skaterCountFor' = -0.1112421455,
            'skaterCountAgainst' = 0.3593383566,
            'distance' = -0.0202733684,
            'angle' = -0.0277593189,
            'shotTypebat' = 0.6055694218,
            'shotTypedeflected' = 13.6628737240,
            'shotTypepoke' = 1.3866301713,
            'shotTypeslap' = 0.4853466203,
            'shotTypesnap' = 0.8193740874,
            'shotTypetip-in' = 0.0639432597,
            'shotTypewrap-around' = 1.2021841108,
            'shotTypewrist' = 0.7166745313,
            'dDdT' = -0.0014028913,
            'dAdT' = 0.0085313306,
            'isRushTRUE' = -0.2363022067,
            'isReboundTRUE' = -0.7209171660,
            'isHomeTRUE' = -0.0816509141,
            'isPlayoffTRUE' = 0.1354034627,
            'secondsElapsedInGame' = 0.0003364762,
            'goalsFor' = -0.0065399543,
            'goalsAgainst' = 0.0182525747,
            'shooterHeight' = -0.0514558963,
            'shooterWeight' = 0.0078914553,
            'shooterSideoffwing' = -0.0775475227,
            'shooterSideonwing' = -0.1174964023,
            'shooterPositionCodeD' = 0.3775920448,
            'shooterPositionCodeG' = 0.2709200607,
            'shooterPositionCodeL' = -0.1240870481,
            'shooterPositionCodeR' = -0.0004897620
          )
        ),
        so = list(
          v1 = c(
            '(Intercept)' = -0.222554605,
            'distance' = -0.034294858,
            'angle' = -0.009587828,
            'shotTypedeflected' = -12.884874136,
            'shotTypepoke' = 1.825144824,
            'shotTypeslap' = 0.297880577,
            'shotTypesnap' = 0.328662371,
            'shotTypetip-in' = -12.885333899,
            'shotTypewrist' = 0.111021978
          ),
          v3 = c(
            '(Intercept)' = -2.585842e-01,
            'distance' = -3.579157e-02,
            'angle' = -9.718267e-03,
            'shotTypedeflected' = -1.297206e+01,
            'shotTypepoke' = 1.802787e+00,
            'shotTypeslap' = 3.131032e-01,
            'shotTypesnap' = 3.326833e-01,
            'shotTypetip-in' = -1.294245e+01,
            'shotTypewrist' = 1.121971e-01,
            'isHomeTRUE' = -3.197610e-02,
            'isPlayoffTRUE' = 1.903331e+00,
            'secondsElapsedInGame' = 6.479725e-05,
            'goalsFor' = -1.251570e-02,
            'goalsAgainst' = -4.291056e-02
          ),
          v4 = c(
            '(Intercept)' = -4.966866e-01,
            'distance' = -3.478439e-02,
            'angle' = -9.810028e-03,
            'shotTypedeflected' = -1.308337e+01,
            'shotTypepoke' = 1.882952e+00,
            'shotTypeslap' = 3.789456e-01,
            'shotTypesnap' = 3.271954e-01,
            'shotTypetip-in' = -1.283398e+01,
            'shotTypewrist' = 1.139254e-01,
            'isHomeTRUE' = -4.643436e-02,
            'isPlayoffTRUE' = 1.828644e+00,
            'secondsElapsedInGame' = 6.960136e-05,
            'goalsFor' = -1.269702e-02,
            'goalsAgainst' = -3.866093e-02,
            'shooterHeight' = 1.246849e-02,
            'shooterWeight' = -6.799232e-04,
            'shooterSideoffwing' = 1.471420e-04,
            'shooterSideonwing' = 1.925120e-02,
            'shooterPositionCodeD' = -6.684898e-01,
            'shooterPositionCodeL' = 1.344272e-01,
            'shooterPositionCodeR' = -5.787621e-02,
            'goalieHeight' = -2.916080e-02,
            'goalieWeight' = 8.075507e-03
          )
        )
      )

      # Match training factor levels.
      .LEVELS <- list(
        shotType = c("backhand","bat","between-legs","cradle","deflected","poke","slap","snap","tip-in","wrap-around","wrist"),
        shooterSide = c("neutral","offwing","onwing"),
        shooterPositionCode = c("C","D","G","L","R"),
        goalieSide = c("blocker","glove","neutral")
      )
      .REF <- list(
        shotType = "backhand",
        shooterSide = "neutral",
        shooterPositionCode = "C",
        goalieSide = "blocker"
      )

      # ----- Helpers ----- #

      .get_num <- function(df, nm) {
        n <- nrow(df)
        if (!nm %in% names(df)) return(rep(0, n))
        v <- df[[nm]]
        if (is.logical(v)) return(as.numeric(!is.na(v) & v))
        if (is.factor(v)) v <- as.character(v)
        v <- suppressWarnings(as.numeric(v))
        v[is.na(v)] <- 0
        v
      }

      .to01 <- function(v) {
        if (is.logical(v)) return(as.numeric(!is.na(v) & v))
        if (is.numeric(v) || is.integer(v)) return(as.numeric(!is.na(v) & v != 0))
        vv <- as.character(v)
        as.numeric(!is.na(vv) & (vv == 'TRUE' | vv == 'T' | vv == '1'))
      }

      .coerce_factor <- function(x, levels, ref) {
        xx <- as.character(x)
        xx[!(xx %in% levels)] <- NA_character_
        xx[is.na(xx)] <- ref
        factor(xx, levels = levels)
      }

      .prob <- function(df, beta) {
        beta <- beta
        beta[is.na(beta)] <- 0
        m <- nrow(df)
        if (m == 0L) return(numeric(0))
        # Coerce to training levels (prevents baseline drift).
        st <- if ('shotType' %in% names(df)) df$shotType else rep(.REF$shotType, m)
        ss <- if ('shooterSide' %in% names(df)) df$shooterSide else rep(.REF$shooterSide, m)
        spc <- if ('shooterPositionCode' %in% names(df)) df$shooterPositionCode else rep(.REF$shooterPositionCode, m)
        gs <- if ('goalieSide' %in% names(df)) df$goalieSide else rep(.REF$goalieSide, m)
        st <- .coerce_factor(st, .LEVELS$shotType, .REF$shotType)
        ss <- .coerce_factor(ss, .LEVELS$shooterSide, .REF$shooterSide)
        spc <- .coerce_factor(spc, .LEVELS$shooterPositionCode, .REF$shooterPositionCode)
        gs <- .coerce_factor(gs, .LEVELS$goalieSide, .REF$goalieSide)
        eta <- rep(0, m)
        for (nm in names(beta)) {
          b <- beta[[nm]]
          if (b == 0) next
          if (nm == '(Intercept)') {
            eta <- eta + b
            next
          }
          if (substr(nm, 1L, 7L) == 'shotType') {
            lvl <- substr(nm, 8L, nchar(nm))
            eta <- eta + b * (as.character(st) == lvl)
            next
          }
          if (substr(nm, 1L, 10L) == 'shooterSide') {
            lvl <- substr(nm, 11L, nchar(nm))
            eta <- eta + b * (as.character(ss) == lvl)
            next
          }
          if (substr(nm, 1L, 19L) == 'shooterPositionCode') {
            lvl <- substr(nm, 20L, nchar(nm))
            eta <- eta + b * (as.character(spc) == lvl)
            next
          }
          if (substr(nm, 1L, 9L) == 'goalieSide') {
            lvl <- substr(nm, 10L, nchar(nm))
            eta <- eta + b * (as.character(gs) == lvl)
            next
          }
          if (nchar(nm) >= 4L && substr(nm, nchar(nm) - 3L, nchar(nm)) == 'TRUE') {
            var <- substr(nm, 1L, nchar(nm) - 4L)
            v01 <- if (var %in% names(df)) .to01(df[[var]]) else rep(0, m)
            eta <- eta + b * v01
            next
          }
          eta <- eta + b * .get_num(df, nm)
        }
        1 / (1 + exp(-eta))
      }

      # Predict xG.
      n <- nrow(pbp)
      xG <- rep(NA_real_, n)
      typeDescKey <- if ('typeDescKey' %in% names(pbp)) as.character(pbp$typeDescKey) else rep(NA_character_, n)
      is_shot <- !is.na(typeDescKey) & typeDescKey %in% c('goal', 'shot-on-goal', 'missed-shot')
      situationCode <- if ('situationCode' %in% names(pbp)) as.character(pbp$situationCode) else rep(NA_character_, n)
      is_so <- is_shot & !is.na(situationCode) & situationCode %in% c('1010', '0101')
      isEmptyNetAgainst <- if ('isEmptyNetAgainst' %in% names(pbp)) pbp$isEmptyNetAgainst else rep(FALSE, n)
      is_en <- is_shot & !is_so & (.to01(isEmptyNetAgainst) == 1)
      is_sd <- is_shot & !is_so & !is_en & (!is.na(situationCode) & situationCode == '1551')
      is_sp <- is_shot & !is_so & !is_en & !is_sd
      vkey <- paste0('v', model)
      beta_sd <- COEFS$sd[[vkey]]
      beta_sp <- COEFS$sp[[vkey]]
      beta_en <- COEFS$en[[vkey]]
      beta_so <- if (model == 2) COEFS$so$v1 else COEFS$so[[vkey]]
      if (any(is_sd)) xG[is_sd] <- .prob(pbp[is_sd, , drop = FALSE], beta_sd)
      if (any(is_sp)) xG[is_sp] <- .prob(pbp[is_sp, , drop = FALSE], beta_sp)
      if (any(is_en)) xG[is_en] <- .prob(pbp[is_en, , drop = FALSE], beta_en)
      if (any(is_so)) xG[is_so] <- .prob(pbp[is_so, , drop = FALSE], beta_so)
      play_by_play$xG <- xG
      play_by_play
    },
    error = function(e) {
      message(conditionMessage(e))
      message('Invalid argument(s); refer to help file.')
      play_by_play
    }
  )
}

#' @rdname calculate_expected_goals
#' @export

calculate_xG <- function(play_by_play, model = 1) {
  calculate_expected_goals(play_by_play, model)
}
