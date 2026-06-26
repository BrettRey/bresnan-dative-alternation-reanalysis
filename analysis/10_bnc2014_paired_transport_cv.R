# Paired same-row BNC2014 transport/native evaluation and model ablations.

source(file.path("analysis", "lib_languageR_dative.R"))

if (!requireNamespace("jsonlite", quietly = TRUE)) {
  stop("Package 'jsonlite' is required to read Figshare API metadata.")
}

set.seed(20260625)

derived_dir <- file.path("data", "derived")
dir.create(derived_dir, recursive = TRUE, showWarnings = FALSE)

bnc_article_id <- "7353164"
bnc_dataset_file_id <- 16713434L
bnc_files_api <- sprintf(
  "https://api.figshare.com/v2/articles/%s/files",
  bnc_article_id
)
bnc_files <- jsonlite::fromJSON(bnc_files_api)
bnc_dataset_file <- bnc_files[bnc_files$id == bnc_dataset_file_id, , drop = FALSE]
if (nrow(bnc_dataset_file) != 1L) {
  stop("Could not uniquely identify the BNC2014 CSV in Figshare file metadata.")
}

download_figshare_file <- function(file_id, fileext = "") {
  row <- bnc_files[bnc_files$id == file_id, , drop = FALSE]
  if (nrow(row) != 1L) {
    stop(sprintf("Could not uniquely identify Figshare file %s.", file_id))
  }
  path <- tempfile(fileext = fileext)
  utils::download.file(row$download_url, path, quiet = TRUE, mode = "wb")
  md5 <- unname(tools::md5sum(path))
  if (!identical(md5, row$computed_md5)) {
    stop(sprintf("Downloaded Figshare file %s failed MD5 validation.", file_id))
  }
  list(path = path, row = row, md5 = md5)
}

bnc_csv <- download_figshare_file(bnc_dataset_file_id, ".csv")
on.exit(unlink(bnc_csv$path), add = TRUE)

bnc_raw <- utils::read.csv(
  bnc_csv$path,
  stringsAsFactors = FALSE,
  check.names = FALSE,
  fileEncoding = "UTF-8-BOM"
)
if (nrow(bnc_raw) != 1839L || ncol(bnc_raw) != 44L) {
  stop("Unexpected BNC2014 dimensions.")
}

yes_no_levels <- c("no", "yes")
shared_verbs <- c("give", "send", "show", "sell", "offer", "lend")

logical_yes_no <- function(x) {
  factor(
    ifelse(is.na(x), NA_character_, ifelse(x, "yes", "no")),
    levels = yes_no_levels
  )
}

level_yes_no <- function(x, positive) {
  factor(ifelse(x == positive, "yes", "no"), levels = yes_no_levels)
}

word_count <- function(x) {
  x <- trimws(x)
  x[x == ""] <- NA_character_
  out <- rep(NA_integer_, length(x))
  ok <- !is.na(x)
  out[ok] <- lengths(regmatches(x[ok], gregexpr("\\S+", x[ok], perl = TRUE)))
  out
}

definite_proxy <- function(x) {
  x <- trimws(x)
  x[x == ""] <- NA_character_
  logical_yes_no(grepl("\\b(the|these|this|those|that)\\b", x, ignore.case = TRUE))
}

harmonize_languageR <- function(dative) {
  d <- dative[
    dative$Modality == "spoken" & as.character(dative$Verb) %in% shared_verbs,
  ]
  d <- droplevels(d)

  data.frame(
    y_np = as.integer(d$RealizationOfRecipient == "NP"),
    Verb = factor(as.character(d$Verb), levels = shared_verbs),
    rec_len_words = d$LengthOfRecipient,
    theme_len_words = d$LengthOfTheme,
    rec_anim = level_yes_no(d$AnimacyOfRec, "animate"),
    rec_def = level_yes_no(d$DefinOfRec, "definite"),
    rec_pron = level_yes_no(d$PronomOfRec, "pronominal"),
    theme_anim = level_yes_no(d$AnimacyOfTheme, "animate"),
    theme_def = level_yes_no(d$DefinOfTheme, "definite"),
    theme_pron = level_yes_no(d$PronomOfTheme, "pronominal"),
    stringsAsFactors = FALSE
  )
}

harmonize_bnc2014 <- function(bnc) {
  data.frame(
    row_id = seq_len(nrow(bnc)),
    y_np = as.integer(bnc$Pattern == "VNN"),
    Verb = factor(bnc$Verb, levels = shared_verbs),
    rec_len_words = word_count(bnc$Recipient),
    theme_len_words = word_count(bnc$Theme),
    rec_anim = logical_yes_no(bnc$AnimateRec),
    rec_def = definite_proxy(bnc$Recipient),
    rec_pron = logical_yes_no(bnc$RecPrn),
    theme_anim = logical_yes_no(bnc$AnimateTheme),
    theme_def = logical_yes_no(bnc$DefTheme),
    theme_pron = logical_yes_no(bnc$ThemePrn),
    stringsAsFactors = FALSE
  )
}

formula_specs <- list(
  marginal = NULL,
  verb_only = y_np ~ Verb,
  nonverb = y_np ~ rec_len_words + theme_len_words +
    rec_anim + rec_pron + theme_anim + theme_def + theme_pron,
  full_core = y_np ~ Verb + rec_len_words + theme_len_words +
    rec_anim + rec_pron + theme_anim + theme_def + theme_pron,
  plus_rec_def_proxy = y_np ~ Verb + rec_len_words + theme_len_words +
    rec_anim + rec_pron + theme_anim + theme_def + theme_pron + rec_def
)

headline_formula <- formula_specs$full_core

complete_for_formula <- function(data, formula) {
  if (is.null(formula)) {
    return(rep(TRUE, nrow(data)))
  }
  stats::complete.cases(data[, all.vars(formula), drop = FALSE])
}

fit_predict_glm <- function(formula, train, test) {
  fit <- stats::glm(formula, data = train, family = stats::binomial())
  as.numeric(stats::predict(fit, newdata = test, type = "response"))
}

source_predictions <- function(formula, train, test) {
  if (is.null(formula)) {
    return(rep(mean(train$y_np), nrow(test)))
  }
  fit_predict_glm(formula, train, test)
}

make_stratified_folds <- function(data, k = 10L, repeats = 5L, seed = 20260625L) {
  out <- list()
  for (r in seq_len(repeats)) {
    set.seed(seed + r - 1L)
    fold <- rep(NA_integer_, nrow(data))
    groups <- split(seq_len(nrow(data)), data$Verb, drop = TRUE)
    for (idx in groups) {
      shuffled <- sample(idx)
      fold[shuffled] <- rep(seq_len(k), length.out = length(shuffled))
    }
    out[[r]] <- data.frame(
      repeat_id = r,
      row_id = data$row_id,
      Verb = as.character(data$Verb),
      fold = fold,
      stringsAsFactors = FALSE
    )
  }
  do.call(rbind, out)
}

native_oof_predictions <- function(formula, data, folds) {
  pred_sum <- rep(0, nrow(data))
  pred_n <- rep(0L, nrow(data))
  warnings <- character()

  for (r in sort(unique(folds$repeat_id))) {
    fold_rows <- folds[folds$repeat_id == r, , drop = FALSE]
    for (fold_id in sort(unique(fold_rows$fold))) {
      test_row_ids <- fold_rows$row_id[fold_rows$fold == fold_id]
      test_idx <- match(test_row_ids, data$row_id)
      train_idx <- setdiff(seq_len(nrow(data)), test_idx)
      train <- data[train_idx, , drop = FALSE]
      test <- data[test_idx, , drop = FALSE]
      p <- if (is.null(formula)) {
        rep(mean(train$y_np), nrow(test))
      } else {
        withCallingHandlers(
          fit_predict_glm(formula, train, test),
          warning = function(w) {
            warnings <<- c(warnings, conditionMessage(w))
            invokeRestart("muffleWarning")
          }
        )
      }
      pred_sum[test_idx] <- pred_sum[test_idx] + p
      pred_n[test_idx] <- pred_n[test_idx] + 1L
    }
  }

  if (any(pred_n == 0L)) {
    stop("At least one BNC2014 row did not receive an out-of-fold prediction.")
  }

  list(pred = pred_sum / pred_n, warnings = unique(warnings))
}

per_row_log_loss <- function(y, p) {
  p <- clip_prob(p)
  -(y * log(p) + (1 - y) * log(1 - p))
}

metric_row <- function(model, origin, family, y, p, train_rows, resampling) {
  metrics <- classification_metrics(y, p)
  data.frame(
    model = model,
    origin = origin,
    family = family,
    train_rows = train_rows,
    test_rows = length(y),
    np_rate = mean(y),
    mean_prediction = mean(p),
    test_log_loss = metrics$log_loss,
    test_brier = metrics$brier,
    test_accuracy = metrics$accuracy,
    test_auc = metrics$auc,
    resampling = resampling,
    stringsAsFactors = FALSE
  )
}

paired_metric_diff <- function(y, p_a, p_b, model_a, model_b,
                               B = 2000L, seed = 20260625L) {
  set.seed(seed)
  n <- length(y)
  ll_a <- per_row_log_loss(y, p_a)
  ll_b <- per_row_log_loss(y, p_b)
  ll_diff <- ll_a - ll_b
  auc_diff <- auc_score(y, p_a) - auc_score(y, p_b)
  boot_ll <- numeric(B)
  boot_auc <- numeric(B)
  for (b in seq_len(B)) {
    idx <- sample.int(n, n, replace = TRUE)
    boot_ll[b] <- mean(ll_diff[idx])
    boot_auc[b] <- auc_score(y[idx], p_a[idx]) - auc_score(y[idx], p_b[idx])
  }
  data.frame(
    model_a = model_a,
    model_b = model_b,
    n = n,
    mean_log_loss_a_minus_b = mean(ll_diff),
    log_loss_diff_lo = stats::quantile(boot_ll, 0.025, names = FALSE, na.rm = TRUE),
    log_loss_diff_hi = stats::quantile(boot_ll, 0.975, names = FALSE, na.rm = TRUE),
    auc_a_minus_b = auc_diff,
    auc_diff_lo = stats::quantile(boot_auc, 0.025, names = FALSE, na.rm = TRUE),
    auc_diff_hi = stats::quantile(boot_auc, 0.975, names = FALSE, na.rm = TRUE),
    bootstrap = "paired row bootstrap",
    B = B,
    stringsAsFactors = FALSE
  )
}

wilson_interval <- function(x, n, conf = 0.95) {
  if (n == 0L) {
    return(c(NA_real_, NA_real_))
  }
  z <- stats::qnorm(1 - (1 - conf) / 2)
  p <- x / n
  denom <- 1 + z^2 / n
  centre <- (p + z^2 / (2 * n)) / denom
  half <- z * sqrt((p * (1 - p) + z^2 / (4 * n)) / n) / denom
  c(max(0, centre - half), min(1, centre + half))
}

calibration_by_verb <- function(data, pred, model) {
  rows <- data.frame(
    model = model,
    Verb = as.character(data$Verb),
    y_np = data$y_np,
    pred = pred
  )
  do.call(rbind, lapply(split(rows, rows$Verb), function(x) {
    ci <- wilson_interval(sum(x$y_np), nrow(x))
    data.frame(
      model = unique(x$model),
      group = unique(x$Verb),
      n = nrow(x),
      observed = mean(x$y_np),
      observed_lo = ci[1],
      observed_hi = ci[2],
      predicted = mean(x$pred),
      stringsAsFactors = FALSE
    )
  }))
}

calibration_model <- function(y, p, model, type) {
  p <- clip_prob(p)
  lp <- stats::qlogis(p)
  data <- data.frame(y = y, lp = lp)
  if (type == "intercept_only") {
    fit <- stats::glm(y ~ 1 + offset(lp), data = data, family = stats::binomial())
    pred <- stats::plogis(lp + stats::coef(fit)[["(Intercept)"]])
    coefs <- summary(fit)$coefficients
    slope <- 1
    slope_se <- NA_real_
  } else if (type == "intercept_plus_slope") {
    fit <- stats::glm(y ~ lp, data = data, family = stats::binomial())
    pred <- stats::predict(fit, type = "response")
    coefs <- summary(fit)$coefficients
    slope <- stats::coef(fit)[["lp"]]
    slope_se <- coefs["lp", "Std. Error"]
  } else {
    stop("Unknown calibration model type.")
  }
  metrics <- classification_metrics(y, pred)
  data.frame(
    model = model,
    calibration = type,
    evaluation = "apparent (recalibration fit and scored on the same BNC2014 rows)",
    intercept = stats::coef(fit)[["(Intercept)"]],
    intercept_se = coefs["(Intercept)", "Std. Error"],
    slope = slope,
    slope_se = slope_se,
    log_loss = metrics$log_loss,
    auc = metrics$auc,
    stringsAsFactors = FALSE
  )
}

formula_text <- function(formula) {
  if (is.null(formula)) {
    "intercept-only marginal probability"
  } else {
    paste(deparse(formula), collapse = " ")
  }
}

spec_rows <- do.call(rbind, lapply(names(formula_specs), function(name) {
  data.frame(
    family = name,
    formula = formula_text(formula_specs[[name]]),
    outcome = "NP recipient realization (languageR NP; BNC2014 VNN)",
    link = "logit",
    length_scale = "raw word counts derived from phrase strings for BNC2014; languageR packaged token-like counts",
    factor_contrasts = "R treatment contrasts",
    verb_reference = shared_verbs[1],
    binary_reference = yes_no_levels[1],
    interactions = "none",
    stringsAsFactors = FALSE
  )
}))

support_audit <- function() {
  combine <- download_figshare_file(16709726L, ".py")
  clean <- download_figshare_file(16713599L, ".rmd")
  on.exit(unlink(c(combine$path, clean$path)), add = TRUE)
  combine_text <- paste(readLines(combine$path, warn = FALSE), collapse = "\n")
  clean_text <- paste(readLines(clean$path, warn = FALSE), collapse = "\n")
  data.frame(
    check = c(
      "final_csv_has_speaker_id",
      "combine_script_constructs_main_speaker_id",
      "cleaning_script_selects_main_speaker_id",
      "released_final_csv_keeps_main_speaker_id",
      "recoverable_group_id_from_released_files"
    ),
    value = c(
      "FALSE",
      as.character(grepl("main_speaker_id", combine_text, fixed = TRUE)),
      as.character(grepl("main_speaker_id", clean_text, fixed = TRUE)),
      as.character("main_speaker_id" %in% names(bnc_raw)),
      "FALSE"
    ),
    note = c(
      "The released 44-column CSV contains no stable speaker/text/conversation ID.",
      "The Python combine script derives main_speaker_id from CQPweb speaker IDs.",
      "The R cleaning script includes main_speaker_id in an intermediate selected-column vector.",
      "The final cleaned data frame renames/drops the intermediate main_speaker_id before the public CSV.",
      "The intermediate combined verb files needed to join IDs back to rows are not included in the Figshare release."
    ),
    stringsAsFactors = FALSE
  )
}

dative <- load_languageR_dative()
validate_languageR_dative(dative)
languageR_h <- harmonize_languageR(dative)
bnc_h <- harmonize_bnc2014(bnc_raw)

headline_complete <- complete_for_formula(bnc_h, headline_formula)
bnc_eval <- bnc_h[headline_complete, , drop = FALSE]

folds <- make_stratified_folds(bnc_eval, k = 10L, repeats = 5L)

predictions <- list()
metrics <- list()
warnings_out <- list()
for (family in names(formula_specs)) {
  formula <- formula_specs[[family]]
  lang_train <- languageR_h[complete_for_formula(languageR_h, formula), , drop = FALSE]

  source_model <- paste0("source_", family)
  predictions[[source_model]] <- source_predictions(formula, lang_train, bnc_eval)
  metrics[[source_model]] <- metric_row(
    source_model,
    "languageR_spoken_shared",
    family,
    bnc_eval$y_np,
    predictions[[source_model]],
    nrow(lang_train),
    "fixed source-trained model scored on BNC2014 full-core complete rows"
  )

  if (family != "plus_rec_def_proxy") {
    native_model <- paste0("native_oof_", family)
    native <- native_oof_predictions(formula, bnc_eval, folds)
    predictions[[native_model]] <- native$pred
    metrics[[native_model]] <- metric_row(
      native_model,
      "BNC2014",
      family,
      bnc_eval$y_np,
      predictions[[native_model]],
      NA_integer_,
      "5 x 10-fold verb-stratified row-level out-of-fold predictions"
    )
    if (length(native$warnings)) {
      warnings_out[[native_model]] <- data.frame(
        model = native_model,
        warning = native$warnings,
        stringsAsFactors = FALSE
      )
    }
  }
}

prediction_rows <- do.call(rbind, lapply(names(predictions), function(model) {
  data.frame(
    row_id = bnc_eval$row_id,
    Verb = as.character(bnc_eval$Verb),
    y_np = bnc_eval$y_np,
    model = model,
    pred = predictions[[model]],
    log_loss = per_row_log_loss(bnc_eval$y_np, predictions[[model]]),
    stringsAsFactors = FALSE
  )
}))

# --- Fold-level AUC aggregation (corrects the pooled OOF AUC artifact) -------
# AUC must be computed within each held-out fold. Pooling out-of-fold
# predictions from models with fold-specific intercepts can drag an
# intercept-only model below 0.5, because the leave-one-fold-out prevalence is
# mechanically anti-correlated with the held-out outcomes. Log loss is
# decomposable, so it is pooled per repeat. The source models are single fixed
# models whose pooled AUC is valid; we also score the source model within each
# fold for a matched paired comparison on identical held-out rows.
native_families <- setdiff(names(formula_specs), "plus_rec_def_proxy")
fold_metric_recs <- list()
for (r in sort(unique(folds$repeat_id))) {
  fr <- folds[folds$repeat_id == r, , drop = FALSE]
  for (fold_id in sort(unique(fr$fold))) {
    test_row_ids <- fr$row_id[fr$fold == fold_id]
    test_idx <- match(test_row_ids, bnc_eval$row_id)
    train_idx <- setdiff(seq_len(nrow(bnc_eval)), test_idx)
    train <- bnc_eval[train_idx, , drop = FALSE]
    test <- bnc_eval[test_idx, , drop = FALSE]
    y <- test$y_np
    for (family in native_families) {
      formula <- formula_specs[[family]]
      p <- if (is.null(formula)) {
        rep(mean(train$y_np), nrow(test))
      } else {
        withCallingHandlers(
          fit_predict_glm(formula, train, test),
          warning = function(w) invokeRestart("muffleWarning")
        )
      }
      fold_metric_recs[[length(fold_metric_recs) + 1L]] <- data.frame(
        repeat_id = r,
        fold = fold_id,
        family = family,
        n = length(y),
        native_log_loss = mean(per_row_log_loss(y, p)),
        native_auc = auc_score(y, p),
        source_auc = auc_score(y, predictions[[paste0("source_", family)]][test_idx]),
        stringsAsFactors = FALSE
      )
    }
  }
}
fold_metrics <- do.call(rbind, fold_metric_recs)

native_agg <- do.call(rbind, lapply(native_families, function(family) {
  fm <- fold_metrics[fold_metrics$family == family, , drop = FALSE]
  data.frame(
    family = family,
    native_oof_log_loss = stats::weighted.mean(fm$native_log_loss, fm$n),
    native_oof_auc = mean(fm$native_auc, na.rm = TRUE),
    source_fold_auc = mean(fm$source_auc, na.rm = TRUE),
    native_minus_source_auc = mean(fm$native_auc - fm$source_auc, na.rm = TRUE),
    stringsAsFactors = FALSE
  )
}))

# Overwrite the pooled native AUC/log loss with the fold-aggregated values.
for (family in native_families) {
  m <- paste0("native_oof_", family)
  agg <- native_agg[native_agg$family == family, , drop = FALSE]
  metrics[[m]]$test_auc <- agg$native_oof_auc
  metrics[[m]]$test_log_loss <- agg$native_oof_log_loss
  metrics[[m]]$resampling <-
    "5 x 10-fold OOF; AUC averaged within fold, log loss pooled per repeat"
}

# Fold bootstrap CI for the matched native-minus-source full-core AUC gap.
fm_full <- fold_metrics[fold_metrics$family == "full_core", , drop = FALSE]
set.seed(20260625L)
boot_auc_gap <- numeric(2000L)
for (b in seq_len(2000L)) {
  idx <- sample.int(nrow(fm_full), nrow(fm_full), replace = TRUE)
  boot_auc_gap[b] <- mean(fm_full$native_auc[idx] - fm_full$source_auc[idx])
}
native_source_auc_gap <- data.frame(
  comparison = "native_oof_full_core_minus_source_full_core",
  fold_auc_gap = mean(fm_full$native_auc - fm_full$source_auc),
  gap_lo = stats::quantile(boot_auc_gap, 0.025, names = FALSE),
  gap_hi = stats::quantile(boot_auc_gap, 0.975, names = FALSE),
  native_fold_auc = mean(fm_full$native_auc),
  source_fold_auc = mean(fm_full$source_auc),
  stringsAsFactors = FALSE
)

# --- Matched missing-data denominator check ---------------------------------
# The same reduced common-predictor model, scored on the 1,621 complete-case
# rows and on all rows that carry the common predictors. Holding the model fixed
# isolates the effect of expanding the row denominator from the effect of
# dropping recipient length, theme length, and the pronominality predictors.
common_formula <- y_np ~ Verb + theme_anim + theme_def
lang_common <- languageR_h[complete_for_formula(languageR_h, common_formula), , drop = FALSE]
common_fit <- stats::glm(common_formula, data = lang_common, family = stats::binomial())
common_predict <- function(newdata) {
  as.numeric(stats::predict(common_fit, newdata = newdata, type = "response"))
}
bnc_all_common <- bnc_h[complete_for_formula(bnc_h, common_formula), , drop = FALSE]
matched_denominator <- rbind(
  data.frame(
    evaluation = "reduced_common_complete_case",
    rows = nrow(bnc_eval),
    classification_metrics(bnc_eval$y_np, common_predict(bnc_eval)),
    stringsAsFactors = FALSE
  ),
  data.frame(
    evaluation = "reduced_common_all_rows",
    rows = nrow(bnc_all_common),
    classification_metrics(bnc_all_common$y_np, common_predict(bnc_all_common)),
    stringsAsFactors = FALSE
  )
)

metric_rows <- do.call(rbind, metrics)
warning_rows_out <- if (length(warnings_out)) {
  do.call(rbind, warnings_out)
} else {
  data.frame(model = character(), warning = character())
}

pair_specs <- list(
  c("source_full_core", "source_marginal"),
  c("source_full_core", "source_verb_only"),
  c("source_full_core", "source_nonverb"),
  c("source_nonverb", "source_marginal"),
  c("source_verb_only", "source_marginal"),
  c("native_oof_full_core", "source_full_core"),
  c("native_oof_full_core", "native_oof_marginal"),
  c("native_oof_full_core", "native_oof_verb_only"),
  c("native_oof_full_core", "native_oof_nonverb")
)
loss_differences <- do.call(rbind, lapply(seq_along(pair_specs), function(i) {
  a <- pair_specs[[i]][1]
  b <- pair_specs[[i]][2]
  paired_metric_diff(
    bnc_eval$y_np,
    predictions[[a]],
    predictions[[b]],
    a,
    b,
    seed = 20260625L + i
  )
}))

calibration <- rbind(
  calibration_model(
    bnc_eval$y_np,
    predictions[["source_full_core"]],
    "source_full_core",
    "intercept_only"
  ),
  calibration_model(
    bnc_eval$y_np,
    predictions[["source_full_core"]],
    "source_full_core",
    "intercept_plus_slope"
  ),
  calibration_model(
    bnc_eval$y_np,
    predictions[["native_oof_full_core"]],
    "native_oof_full_core",
    "intercept_plus_slope"
  )
)

calibration_verb <- rbind(
  calibration_by_verb(bnc_eval, predictions[["source_full_core"]], "source_full_core"),
  calibration_by_verb(bnc_eval, predictions[["native_oof_full_core"]], "native_oof_full_core"),
  calibration_by_verb(bnc_eval, predictions[["source_verb_only"]], "source_verb_only"),
  calibration_by_verb(bnc_eval, predictions[["source_nonverb"]], "source_nonverb")
)
calibration_verb$group <- factor(
  calibration_verb$group,
  levels = c("give", "show", "offer", "lend", "send", "sell")
)
calibration_verb <- calibration_verb[order(calibration_verb$model, calibration_verb$group), ]
calibration_verb$group <- as.character(calibration_verb$group)

utils::write.csv(
  spec_rows,
  file.path(derived_dir, "bnc2014_model_specifications.csv"),
  row.names = FALSE
)
utils::write.csv(
  support_audit(),
  file.path(derived_dir, "bnc2014_grouping_id_audit.csv"),
  row.names = FALSE
)
utils::write.csv(
  folds,
  file.path(derived_dir, "bnc2014_paired_transport_cv_folds.csv"),
  row.names = FALSE
)
utils::write.csv(
  prediction_rows,
  file.path(derived_dir, "bnc2014_paired_transport_cv_predictions.csv"),
  row.names = FALSE
)
utils::write.csv(
  metric_rows,
  file.path(derived_dir, "bnc2014_paired_transport_cv_metrics.csv"),
  row.names = FALSE
)
utils::write.csv(
  loss_differences,
  file.path(derived_dir, "bnc2014_paired_transport_cv_loss_differences.csv"),
  row.names = FALSE
)
utils::write.csv(
  calibration,
  file.path(derived_dir, "bnc2014_paired_transport_cv_calibration.csv"),
  row.names = FALSE
)
utils::write.csv(
  calibration_verb,
  file.path(derived_dir, "bnc2014_paired_transport_cv_calibration_by_verb.csv"),
  row.names = FALSE
)
utils::write.csv(
  warning_rows_out,
  file.path(derived_dir, "bnc2014_paired_transport_cv_warnings.csv"),
  row.names = FALSE
)
utils::write.csv(
  fold_metrics,
  file.path(derived_dir, "bnc2014_paired_transport_cv_fold_metrics.csv"),
  row.names = FALSE
)
utils::write.csv(
  native_agg,
  file.path(derived_dir, "bnc2014_paired_transport_cv_native_agg.csv"),
  row.names = FALSE
)
utils::write.csv(
  native_source_auc_gap,
  file.path(derived_dir, "bnc2014_paired_transport_cv_auc_gap.csv"),
  row.names = FALSE
)
utils::write.csv(
  matched_denominator,
  file.path(derived_dir, "bnc2014_reduced_matched_denominator.csv"),
  row.names = FALSE
)

print(metric_rows, row.names = FALSE)
print(loss_differences, row.names = FALSE)
print(native_agg, row.names = FALSE)
print(native_source_auc_gap, row.names = FALSE)
print(matched_denominator, row.names = FALSE)
