#' xG Model Feature Importance and Calibration Analysis
#'
#' This file contains functions for visualizing feature importance
#' and assessing calibration of the xG models against real NHL data.

#' Get model coefficients for all xG model versions
#'
#' @returns data.frame with coefficients for all models
#' @keywords internal

get_xg_coefficients <- function() {
  data.frame(
    feature = c(
      'Intercept', 'Distance', 'Angle', 'Empty Net',
      'Penalty Kill', 'Power Play', 'Rebound', 'Rush', 'Goal Differential'
    ),
    v1 = c(-1.8999656, -0.0337112, -0.0077118, 4.3321873,
           0.6454842, 0.4080557, NA, NA, NA),
    v2 = c(-1.9963221, -0.0315542, -0.0080897, 4.2879873,
           0.6673946, 0.4089630, 0.4133378, -0.0657790, NA),
    v3 = c(-1.9942500, -0.0315190, -0.0080823, 4.2126061,
           0.6601609, 0.4106154, 0.4172151, -0.0709434, 0.0424470)
  )
}

#' Plot feature importance for xG models
#'
#' Creates a horizontal bar chart showing the relative importance
#' (absolute coefficient values) of each feature in the xG models.
#'
#' @param model integer version (1, 2, or 3) or 'all' for comparison
#' @param save_path optional path to save the plot as PNG
#' @returns ggplot object
#' @examples
#' \donttest{plot_feature_importance(model = 'all')}
#' @export

plot_feature_importance <- function(model = 'all', save_path = NULL) {
  if (!requireNamespace('ggplot2', quietly = TRUE)) {
    stop('Package ggplot2 is required for this function.')
  }

  coeffs <- get_xg_coefficients()

  # Remove intercept for importance comparison
  coeffs <- coeffs[coeffs$feature != 'Intercept', ]

  if (model == 'all') {
    # Reshape for comparison plot
    plot_data <- data.frame(
      feature = rep(coeffs$feature, 3),
      coefficient = c(coeffs$v1, coeffs$v2, coeffs$v3),
      abs_coefficient = c(abs(coeffs$v1), abs(coeffs$v2), abs(coeffs$v3)),
      model = rep(c('v1', 'v2', 'v3'), each = nrow(coeffs))
    )
    plot_data <- plot_data[!is.na(plot_data$coefficient), ]

    # Order features by v3 importance (or v2 if v3 NA)
    feature_order <- coeffs$feature[order(abs(
      ifelse(is.na(coeffs$v3), coeffs$v2, coeffs$v3)
    ), decreasing = FALSE)]
    plot_data$feature <- factor(plot_data$feature, levels = feature_order)

    p <- ggplot2::ggplot(
      plot_data,
      ggplot2::aes(x = feature, y = coefficient, fill = model)
    ) +
      ggplot2::geom_bar(stat = 'identity', position = 'dodge', width = 0.7) +
      ggplot2::geom_hline(yintercept = 0, linetype = 'dashed', color = 'gray40') +
      ggplot2::coord_flip() +
      ggplot2::scale_fill_manual(
        values = c('v1' = '#1f77b4', 'v2' = '#ff7f0e', 'v3' = '#2ca02c'),
        labels = c('v1' = 'Model v1', 'v2' = 'Model v2', 'v3' = 'Model v3')
      ) +
      ggplot2::labs(
        title = 'xG Model Feature Coefficients',
        subtitle = 'Positive = increases goal probability, Negative = decreases',
        x = NULL,
        y = 'Coefficient (log-odds scale)',
        fill = 'Model'
      ) +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(
        plot.title = ggplot2::element_text(face = 'bold', size = 14),
        legend.position = 'bottom',
        panel.grid.minor = ggplot2::element_blank()
      )
  } else {
    model_col <- paste0('v', model)
    plot_data <- data.frame(
      feature = coeffs$feature,
      coefficient = coeffs[[model_col]],
      abs_coefficient = abs(coeffs[[model_col]])
    )
    plot_data <- plot_data[!is.na(plot_data$coefficient), ]
    plot_data <- plot_data[order(plot_data$abs_coefficient), ]
    plot_data$feature <- factor(plot_data$feature, levels = plot_data$feature)
    plot_data$direction <- ifelse(plot_data$coefficient > 0, 'Positive', 'Negative')

    p <- ggplot2::ggplot(
      plot_data,
      ggplot2::aes(x = feature, y = coefficient, fill = direction)
    ) +
      ggplot2::geom_bar(stat = 'identity', width = 0.7) +
      ggplot2::geom_hline(yintercept = 0, linetype = 'dashed', color = 'gray40') +
      ggplot2::coord_flip() +
      ggplot2::scale_fill_manual(
        values = c('Positive' = '#2ca02c', 'Negative' = '#d62728')
      ) +
      ggplot2::labs(
        title = sprintf('xG Model v%s Feature Coefficients', model),
        subtitle = 'Positive = increases goal probability, Negative = decreases',
        x = NULL,
        y = 'Coefficient (log-odds scale)',
        fill = 'Effect Direction'
      ) +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(
        plot.title = ggplot2::element_text(face = 'bold', size = 14),
        legend.position = 'bottom',
        panel.grid.minor = ggplot2::element_blank()
      )
  }

  if (!is.null(save_path)) {
    ggplot2::ggsave(save_path, p, width = 10, height = 6, dpi = 150)
  }

  p
}

#' Plot feature importance by effect size (odds ratios)
#'
#' Creates a forest plot showing odds ratios for each feature,
#' which is more interpretable than raw coefficients.
#'
#' @param model integer version (1, 2, or 3)
#' @param save_path optional path to save the plot as PNG
#' @returns ggplot object
#' @examples
#' \donttest{plot_odds_ratios(model = 3)}
#' @export

plot_odds_ratios <- function(model = 3, save_path = NULL) {
  if (!requireNamespace('ggplot2', quietly = TRUE)) {
    stop('Package ggplot2 is required for this function.')
  }

  coeffs <- get_xg_coefficients()
  model_col <- paste0('v', model)

  # Calculate odds ratios (exp of coefficients)
  # For distance/angle, show per-unit change meaningfully
  plot_data <- data.frame(
    feature = c(
      'Distance (-10 ft)', 'Angle (-10 deg)', 'Empty Net',
      'Penalty Kill', 'Power Play', 'Rebound', 'Rush', 'Goal Diff (+1)'
    ),
    odds_ratio = c(
      exp(coeffs[coeffs$feature == 'Distance', model_col] * -10),
      exp(coeffs[coeffs$feature == 'Angle', model_col] * -10),
      exp(coeffs[coeffs$feature == 'Empty Net', model_col]),
      exp(coeffs[coeffs$feature == 'Penalty Kill', model_col]),
      exp(coeffs[coeffs$feature == 'Power Play', model_col]),
      exp(coeffs[coeffs$feature == 'Rebound', model_col]),
      exp(coeffs[coeffs$feature == 'Rush', model_col]),
      exp(coeffs[coeffs$feature == 'Goal Differential', model_col])
    )
  )

  plot_data <- plot_data[!is.na(plot_data$odds_ratio), ]
  plot_data <- plot_data[order(plot_data$odds_ratio), ]
  plot_data$feature <- factor(plot_data$feature, levels = plot_data$feature)

  p <- ggplot2::ggplot(
    plot_data,
    ggplot2::aes(x = feature, y = odds_ratio)
  ) +
    ggplot2::geom_segment(
      ggplot2::aes(xend = feature, y = 1, yend = odds_ratio),
      color = 'gray60', linewidth = 1
    ) +
    ggplot2::geom_point(size = 4, color = '#1f77b4') +
    ggplot2::geom_hline(yintercept = 1, linetype = 'dashed', color = 'red') +
    ggplot2::coord_flip() +
    ggplot2::scale_y_log10(
      breaks = c(0.5, 1, 1.5, 2, 5, 10, 50, 100),
      labels = c('0.5x', '1x', '1.5x', '2x', '5x', '10x', '50x', '100x')
    ) +
    ggplot2::labs(
      title = sprintf('xG Model v%s - Odds Ratios', model),
      subtitle = 'Values >1 increase goal probability, <1 decrease it',
      x = NULL,
      y = 'Odds Ratio (log scale)'
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = 'bold', size = 14),
      panel.grid.minor = ggplot2::element_blank()
    )

  if (!is.null(save_path)) {
    ggplot2::ggsave(save_path, p, width = 10, height = 6, dpi = 150)
  }

  p
}

#' Calculate calibration statistics for xG models
#'
#' Compares total expected goals vs actual goals across seasons.
#'
#' @param seasons vector of season IDs (e.g., c(20222023, 20232024, 20242025))
#' @param verbose logical to print progress
#' @returns data.frame with calibration statistics by season and model
#' @examples
#' \donttest{stats <- calculate_calibration_stats(seasons = 20232024)}
#' @export

calculate_calibration_stats <- function(
    seasons = c(20222023, 20232024, 20242025),
    verbose = TRUE
) {
  results <- list()


  for (season in seasons) {
    if (verbose) message(sprintf('Processing season %s...', season))

    # Load play-by-play data
    pbps <- tryCatch(
      gc_pbps(season),
      error = function(e) {
        message(sprintf('Could not load season %s: %s', season, e$message))
        return(NULL)
      }
    )

    if (is.null(pbps) || nrow(pbps) == 0) next

    # Filter to shots only (excluding shootouts/penalty shots)
    shot_types <- c('goal', 'shot-on-goal', 'missed-shot', 'blocked-shot')
    shots <- pbps[pbps$typeDescKey %in% shot_types, ]

    # Ensure situationCode is padded
    if (!'situationCode' %in% names(shots)) next
    situation_chr <- as.character(shots$situationCode)
    situation_pad <- sprintf('%04d', as.integer(situation_chr))
    shots <- shots[!situation_pad %in% c('0101', '1010'), ]

    if (nrow(shots) == 0) next

    # Calculate xG for all three models
    if (verbose) message('  Calculating xG v1...')
    shots <- calculate_expected_goals_v1(shots)
    if (verbose) message('  Calculating xG v2...')
    shots <- calculate_expected_goals_v2(shots)
    if (verbose) message('  Calculating xG v3...')
    shots <- calculate_expected_goals_v3(shots)

    # Count actual goals
    actual_goals <- sum(shots$typeDescKey == 'goal', na.rm = TRUE)
    total_shots <- nrow(shots)

    # Sum xG for each model
    xg_v1_total <- sum(shots$xG_v1, na.rm = TRUE)
    xg_v2_total <- sum(shots$xG_v2, na.rm = TRUE)
    xg_v3_total <- sum(shots$xG_v3, na.rm = TRUE)

    results[[as.character(season)]] <- data.frame(
      season = season,
      total_shots = total_shots,
      actual_goals = actual_goals,
      actual_rate = actual_goals / total_shots,
      xG_v1_total = round(xg_v1_total, 1),
      xG_v2_total = round(xg_v2_total, 1),
      xG_v3_total = round(xg_v3_total, 1),
      diff_v1 = round(actual_goals - xg_v1_total, 1),
      diff_v2 = round(actual_goals - xg_v2_total, 1),
      diff_v3 = round(actual_goals - xg_v3_total, 1),
      pct_diff_v1 = round((actual_goals - xg_v1_total) / actual_goals * 100, 2),
      pct_diff_v2 = round((actual_goals - xg_v2_total) / actual_goals * 100, 2),
      pct_diff_v3 = round((actual_goals - xg_v3_total) / actual_goals * 100, 2)
    )
  }

  if (length(results) == 0) {
    message('No data could be loaded.')
    return(data.frame())
  }

  do.call(rbind, results)
}

#' Calculate calibration by xG bin
#'
#' Groups shots into xG probability bins and compares predicted vs actual
#' conversion rates within each bin.
#'
#' @param seasons vector of season IDs
#' @param model integer version (1, 2, or 3)
#' @param n_bins number of bins (default 10 for deciles)
#' @param verbose logical to print progress
#' @returns data.frame with calibration by bin
#' @examples
#' \donttest{bins <- calculate_calibration_bins(20232024, model = 3)}
#' @export

calculate_calibration_bins <- function(
    seasons = c(20222023, 20232024, 20242025),
    model = 3,
    n_bins = 10,
    verbose = TRUE
) {
  all_shots <- list()

  for (season in seasons) {
    if (verbose) message(sprintf('Loading season %s...', season))

    pbps <- tryCatch(
      gc_pbps(season),
      error = function(e) {
        message(sprintf('Could not load season %s', season))
        return(NULL)
      }
    )

    if (is.null(pbps) || nrow(pbps) == 0) next

    shot_types <- c('goal', 'shot-on-goal', 'missed-shot', 'blocked-shot')
    shots <- pbps[pbps$typeDescKey %in% shot_types, ]

    situation_chr <- as.character(shots$situationCode)
    situation_pad <- sprintf('%04d', as.integer(situation_chr))
    shots <- shots[!situation_pad %in% c('0101', '1010'), ]

    if (nrow(shots) == 0) next

    # Calculate xG
    xg_col <- paste0('xG_v', model)
    if (model == 1) shots <- calculate_expected_goals_v1(shots)
    if (model == 2) shots <- calculate_expected_goals_v2(shots)
    if (model == 3) shots <- calculate_expected_goals_v3(shots)

    shots$isGoal <- as.integer(shots$typeDescKey == 'goal')
    shots$xG <- shots[[xg_col]]
    shots$season <- season

    all_shots[[as.character(season)]] <- shots[, c('season', 'xG', 'isGoal')]
  }

  if (length(all_shots) == 0) {
    message('No data could be loaded.')
    return(data.frame())
  }

  combined <- do.call(rbind, all_shots)
  combined <- combined[!is.na(combined$xG), ]

  # Create bins
  breaks <- seq(0, 1, length.out = n_bins + 1)
  combined$bin <- cut(
    combined$xG,
    breaks = breaks,
    include.lowest = TRUE,
    labels = FALSE
  )

  # Calculate stats per bin
  bin_stats <- aggregate(
    cbind(xG, isGoal) ~ bin,
    data = combined,
    FUN = function(x) c(mean = mean(x), sum = sum(x), n = length(x))
  )

  result <- data.frame(
    bin = 1:n_bins,
    bin_lower = breaks[1:n_bins],
    bin_upper = breaks[2:(n_bins + 1)],
    predicted_rate = bin_stats$xG[, 'mean'],
    actual_rate = bin_stats$isGoal[, 'mean'],
    n_shots = bin_stats$isGoal[, 'n'],
    predicted_goals = bin_stats$xG[, 'sum'],
    actual_goals = bin_stats$isGoal[, 'sum']
  )

  result$calibration_error <- result$actual_rate - result$predicted_rate

  result
}

#' Plot calibration curve
#'
#' Creates a calibration plot comparing predicted xG vs actual goal rate.
#'
#' @param seasons vector of season IDs
#' @param model integer version (1, 2, or 3) or 'all'
#' @param n_bins number of bins
#' @param save_path optional path to save plot
#' @returns ggplot object
#' @examples
#' \donttest{plot_calibration_curve(20232024, model = 'all')}
#' @export

plot_calibration_curve <- function(
    seasons = c(20222023, 20232024, 20242025),
    model = 'all',
    n_bins = 10,
    save_path = NULL
) {
  if (!requireNamespace('ggplot2', quietly = TRUE)) {
    stop('Package ggplot2 is required for this function.')
  }

  if (model == 'all') {
    models_to_plot <- 1:3
  } else {
    models_to_plot <- model
  }

  all_bins <- list()
  for (m in models_to_plot) {
    bins <- calculate_calibration_bins(seasons, model = m, n_bins = n_bins)
    if (nrow(bins) > 0) {
      bins$model <- paste0('v', m)
      all_bins[[as.character(m)]] <- bins
    }
  }

  if (length(all_bins) == 0) {
    message('No calibration data available.')
    return(NULL)
  }

  plot_data <- do.call(rbind, all_bins)

  p <- ggplot2::ggplot(
    plot_data,
    ggplot2::aes(x = predicted_rate, y = actual_rate, color = model)
  ) +
    ggplot2::geom_abline(
      intercept = 0, slope = 1,
      linetype = 'dashed', color = 'gray40', linewidth = 1
    ) +
    ggplot2::geom_point(ggplot2::aes(size = n_shots), alpha = 0.7) +
    ggplot2::geom_line(linewidth = 1) +
    ggplot2::scale_color_manual(
      values = c('v1' = '#1f77b4', 'v2' = '#ff7f0e', 'v3' = '#2ca02c'),
      labels = c('v1' = 'Model v1', 'v2' = 'Model v2', 'v3' = 'Model v3')
    ) +
    ggplot2::scale_size_continuous(
      name = 'Shots',
      labels = scales::comma_format()
    ) +
    ggplot2::scale_x_continuous(
      labels = scales::percent_format(),
      limits = c(0, NA)
    ) +
    ggplot2::scale_y_continuous(
      labels = scales::percent_format(),
      limits = c(0, NA)
    ) +
    ggplot2::labs(
      title = 'xG Model Calibration Curve',
      subtitle = sprintf(
        'Seasons: %s | Perfect calibration = diagonal line',
        paste(seasons, collapse = ', ')
      ),
      x = 'Predicted Goal Probability (xG)',
      y = 'Actual Goal Rate',
      color = 'Model'
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = 'bold', size = 14),
      legend.position = 'right',
      panel.grid.minor = ggplot2::element_blank()
    )

  if (!is.null(save_path)) {
    ggplot2::ggsave(save_path, p, width = 10, height = 8, dpi = 150)
  }

  p
}

#' Plot calibration summary table
#'
#' Creates a visual summary table of xG vs actual goals by season.
#'
#' @param stats data.frame from calculate_calibration_stats()
#' @param save_path optional path to save plot
#' @returns ggplot object
#' @examples
#' \donttest{
#'   stats <- calculate_calibration_stats(20232024)
#'   plot_calibration_summary(stats)
#' }
#' @export

plot_calibration_summary <- function(stats, save_path = NULL) {
  if (!requireNamespace('ggplot2', quietly = TRUE)) {
    stop('Package ggplot2 is required for this function.')
  }

  # Reshape for plotting
  plot_data <- data.frame(
    season = rep(stats$season, 4),
    metric = rep(c('Actual Goals', 'xG v1', 'xG v2', 'xG v3'), each = nrow(stats)),
    value = c(stats$actual_goals, stats$xG_v1_total, stats$xG_v2_total, stats$xG_v3_total)
  )

  plot_data$metric <- factor(
    plot_data$metric,
    levels = c('Actual Goals', 'xG v1', 'xG v2', 'xG v3')
  )

  p <- ggplot2::ggplot(
    plot_data,
    ggplot2::aes(x = factor(season), y = value, fill = metric)
  ) +
    ggplot2::geom_bar(stat = 'identity', position = 'dodge', width = 0.7) +
    ggplot2::geom_text(
      ggplot2::aes(label = scales::comma(round(value))),
      position = ggplot2::position_dodge(width = 0.7),
      vjust = -0.5, size = 3
    ) +
    ggplot2::scale_fill_manual(
      values = c(
        'Actual Goals' = '#d62728',
        'xG v1' = '#1f77b4',
        'xG v2' = '#ff7f0e',
        'xG v3' = '#2ca02c'
      )
    ) +
    ggplot2::scale_y_continuous(
      labels = scales::comma_format(),
      expand = ggplot2::expansion(mult = c(0, 0.15))
    ) +
    ggplot2::labs(
      title = 'xG Model Calibration: Predicted vs Actual Goals',
      subtitle = 'Comparison across NHL seasons',
      x = 'Season',
      y = 'Total Goals',
      fill = NULL
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = 'bold', size = 14),
      legend.position = 'bottom',
      panel.grid.minor = ggplot2::element_blank()
    )

  if (!is.null(save_path)) {
    ggplot2::ggsave(save_path, p, width = 12, height = 7, dpi = 150)
  }

  p
}

#' Generate full calibration report
#'
#' Creates a comprehensive calibration analysis with multiple visualizations.
#'
#' @param seasons vector of season IDs
#' @param output_dir directory to save plots (default: working directory)
#' @param verbose logical to print progress
#' @returns list with stats and file paths
#' @examples
#' \donttest{report <- generate_calibration_report(20232024)}
#' @export

generate_calibration_report <- function(
    seasons = c(20222023, 20232024, 20242025),
    output_dir = '.',
    verbose = TRUE
) {
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  results <- list()

  # 1. Feature importance plot
  if (verbose) message('Creating feature importance plot...')
  p1_path <- file.path(output_dir, 'xg_feature_importance.png')
  plot_feature_importance(model = 'all', save_path = p1_path)
  results$feature_importance_path <- p1_path

  # 2. Odds ratio plot
  if (verbose) message('Creating odds ratio plot...')
  p2_path <- file.path(output_dir, 'xg_odds_ratios.png')
  plot_odds_ratios(model = 3, save_path = p2_path)
  results$odds_ratios_path <- p2_path

  # 3. Calculate calibration stats
  if (verbose) message('Calculating calibration statistics...')
  stats <- calculate_calibration_stats(seasons, verbose = verbose)
  results$calibration_stats <- stats

  if (nrow(stats) > 0) {
    # 4. Calibration summary bar chart
    if (verbose) message('Creating calibration summary plot...')
    p3_path <- file.path(output_dir, 'xg_calibration_summary.png')
    plot_calibration_summary(stats, save_path = p3_path)
    results$calibration_summary_path <- p3_path

    # 5. Calibration curve
    if (verbose) message('Creating calibration curve...')
    p4_path <- file.path(output_dir, 'xg_calibration_curve.png')
    plot_calibration_curve(seasons, model = 'all', save_path = p4_path)
    results$calibration_curve_path <- p4_path
  }

  # Print summary
  if (verbose && nrow(stats) > 0) {
    message('\n========== CALIBRATION SUMMARY ==========')
    for (i in seq_len(nrow(stats))) {
      message(sprintf('\nSeason %s:', stats$season[i]))
      message(sprintf('  Total shots: %s', format(stats$total_shots[i], big.mark = ',')))
      message(sprintf('  Actual goals: %s', format(stats$actual_goals[i], big.mark = ',')))
      message(sprintf('  xG v1 total: %.1f (diff: %+.1f, %+.2f%%)',
                      stats$xG_v1_total[i], stats$diff_v1[i], stats$pct_diff_v1[i]))
      message(sprintf('  xG v2 total: %.1f (diff: %+.1f, %+.2f%%)',
                      stats$xG_v2_total[i], stats$diff_v2[i], stats$pct_diff_v2[i]))
      message(sprintf('  xG v3 total: %.1f (diff: %+.1f, %+.2f%%)',
                      stats$xG_v3_total[i], stats$diff_v3[i], stats$pct_diff_v3[i]))
    }
    message('\n==========================================')
  }

  results
}
