# First cross-corpus transport check from languageR::dative to BNC2014.

source(file.path("analysis", "lib_languageR_dative.R"))

if (!requireNamespace("jsonlite", quietly = TRUE)) {
  stop("Package 'jsonlite' is required to read Figshare API metadata.")
}

set.seed(20260623)

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

bnc_csv_path <- tempfile(fileext = ".csv")
on.exit(unlink(bnc_csv_path), add = TRUE)
utils::download.file(
  bnc_dataset_file$download_url,
  bnc_csv_path,
  quiet = TRUE,
  mode = "wb"
)

downloaded_md5 <- unname(tools::md5sum(bnc_csv_path))
if (!identical(downloaded_md5, bnc_dataset_file$computed_md5)) {
  stop("Downloaded BNC2014 CSV failed MD5 validation.")
}

bnc_raw <- utils::read.csv(
  bnc_csv_path,
  stringsAsFactors = FALSE,
  check.names = FALSE,
  fileEncoding = "UTF-8-BOM"
)

if (nrow(bnc_raw) != 1839L || ncol(bnc_raw) != 44L) {
  stop("Unexpected BNC2014 dimensions.")
}

yes_no_levels <- c("no", "yes")

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

harmonize_languageR <- function(dative, shared_verbs) {
  d <- dative[
    dative$Modality == "spoken" & as.character(dative$Verb) %in% shared_verbs,
  ]
  d <- droplevels(d)

  data.frame(
    corpus = "languageR_spoken_shared",
    y_np = as.integer(d$RealizationOfRecipient == "NP"),
    outcome = as.character(d$RealizationOfRecipient),
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

harmonize_bnc2014 <- function(bnc, shared_verbs) {
  data.frame(
    corpus = "BNC2014",
    y_np = as.integer(bnc$Pattern == "VNN"),
    outcome = ifelse(bnc$Pattern == "VNN", "NP", "PP"),
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

complete_for_formula <- function(data, formula) {
  vars <- all.vars(formula)
  data[stats::complete.cases(data[, vars, drop = FALSE]), , drop = FALSE]
}

fit_glm <- function(model_name, formula, data) {
  warnings <- character()
  model <- withCallingHandlers(
    stats::glm(formula, data = data, family = stats::binomial()),
    warning = function(w) {
      warnings <<- c(warnings, conditionMessage(w))
      invokeRestart("muffleWarning")
    }
  )
  list(model = model, warnings = warning_rows(model_name, unique(warnings)))
}

predict_glm <- function(fit, newdata) {
  stats::predict(fit$model, newdata = newdata, type = "response")
}

metric_row <- function(
    model_name,
    formula_label,
    train_corpus,
    test_corpus,
    train_rows,
    test_rows,
    y,
    p,
    df = NA_integer_,
    aic = NA_real_) {
  metrics <- classification_metrics(y, p)
  data.frame(
    model = model_name,
    formula = formula_label,
    train_corpus = train_corpus,
    test_corpus = test_corpus,
    train_rows = train_rows,
    test_rows = test_rows,
    test_log_loss = metrics$log_loss,
    test_brier = metrics$brier,
    test_accuracy = metrics$accuracy,
    test_auc = metrics$auc,
    df = df,
    aic = aic,
    stringsAsFactors = FALSE
  )
}

coef_rows <- function(model_name, formula_label, fit) {
  coef_summary <- summary(fit$model)$coefficients
  data.frame(
    model = model_name,
    formula = formula_label,
    term = rownames(coef_summary),
    estimate = coef_summary[, "Estimate"],
    std_error = coef_summary[, "Std. Error"],
    z_value = coef_summary[, "z value"],
    p_value = coef_summary[, "Pr(>|z|)"],
    row.names = NULL
  )
}

stratified_split <- function(data, group, prop = 0.8, seed = 20260623) {
  set.seed(seed)
  groups <- split(seq_len(nrow(data)), data[[group]], drop = TRUE)
  train_idx <- sort(unlist(lapply(groups, function(idx) {
    sample(idx, max(1L, ceiling(prop * length(idx))))
  }), use.names = FALSE))
  list(
    train = data[train_idx, , drop = FALSE],
    test = data[setdiff(seq_len(nrow(data)), train_idx), , drop = FALSE]
  )
}

feature_coverage_rows <- function(corpus_name, formula_label, formula, data) {
  vars <- all.vars(formula)
  complete_rows <- nrow(complete_for_formula(data, formula))
  do.call(rbind, lapply(vars, function(var) {
    data.frame(
      corpus = corpus_name,
      formula = formula_label,
      variable = var,
      rows = nrow(data),
      complete_formula_rows = complete_rows,
      n_missing = sum(is.na(data[[var]])),
      n_distinct = length(unique(data[[var]][!is.na(data[[var]])])),
      stringsAsFactors = FALSE
    )
  }))
}

dative <- load_languageR_dative()
validate_languageR_dative(dative)

shared_verbs <- c("give", "send", "show", "sell", "offer", "lend")
languageR_h <- harmonize_languageR(dative, shared_verbs)
bnc_h <- harmonize_bnc2014(bnc_raw, shared_verbs)

core_formula <- y_np ~ Verb + rec_len_words + theme_len_words +
  rec_anim + rec_pron + theme_anim + theme_def + theme_pron
rec_def_formula <- y_np ~ Verb + rec_len_words + theme_len_words +
  rec_anim + rec_pron + theme_anim + theme_def + theme_pron + rec_def

formula_specs <- list(
  core = core_formula,
  plus_rec_def_proxy = rec_def_formula
)

metrics_list <- list()
warnings_list <- list()
coef_list <- list()
calibration_list <- list()
coverage_list <- list()

for (formula_label in names(formula_specs)) {
  formula <- formula_specs[[formula_label]]
  languageR_cc <- complete_for_formula(languageR_h, formula)
  bnc_cc <- complete_for_formula(bnc_h, formula)

  coverage_list[[paste0("languageR_", formula_label)]] <- feature_coverage_rows(
    "languageR_spoken_shared",
    formula_label,
    formula,
    languageR_h
  )
  coverage_list[[paste0("bnc_", formula_label)]] <- feature_coverage_rows(
    "BNC2014",
    formula_label,
    formula,
    bnc_h
  )

  marginal_p <- rep(mean(languageR_cc$y_np), nrow(bnc_cc))
  lang_marginal_name <- paste0(
    "languageR_spoken_shared_",
    formula_label,
    "_marginal_to_bnc2014"
  )
  metrics_list[[paste0("marginal_", formula_label)]] <- metric_row(
    lang_marginal_name,
    formula_label,
    "languageR_spoken_shared",
    "BNC2014",
    nrow(languageR_cc),
    nrow(bnc_cc),
    bnc_cc$y_np,
    marginal_p,
    df = 1L
  )

  lang_model_name <- paste0(
    "languageR_spoken_shared_",
    formula_label,
    "_to_bnc2014"
  )
  lang_fit <- fit_glm(lang_model_name, formula, languageR_cc)
  lang_pred <- predict_glm(lang_fit, bnc_cc)
  metrics_list[[lang_model_name]] <- metric_row(
    lang_model_name,
    formula_label,
    "languageR_spoken_shared",
    "BNC2014",
    nrow(languageR_cc),
    nrow(bnc_cc),
    bnc_cc$y_np,
    lang_pred,
    df = length(stats::coef(lang_fit$model)),
    aic = stats::AIC(lang_fit$model)
  )
  warnings_list[[lang_model_name]] <- lang_fit$warnings
  coef_list[[lang_model_name]] <- coef_rows(lang_model_name, formula_label, lang_fit)
  calibration_list[[lang_model_name]] <- calibration_by_group(
    bnc_cc$Verb,
    bnc_cc$y_np,
    lang_model_name,
    lang_pred
  )

  set.seed(20260624)
  scrambled_y <- sample(bnc_cc$y_np)
  metrics_list[[paste0(lang_model_name, "_scrambled_bnc_outcome")]] <- metric_row(
    paste0(lang_model_name, "_scrambled_bnc_outcome"),
    formula_label,
    "languageR_spoken_shared",
    "BNC2014_scrambled_outcome",
    nrow(languageR_cc),
    nrow(bnc_cc),
    scrambled_y,
    lang_pred,
    df = length(stats::coef(lang_fit$model)),
    aic = stats::AIC(lang_fit$model)
  )

  split <- stratified_split(bnc_cc, "Verb", seed = 20260625)
  bnc_marginal_p <- rep(mean(split$train$y_np), nrow(split$test))
  bnc_marginal_name <- paste0("bnc2014_", formula_label, "_marginal_holdout")
  metrics_list[[paste0("bnc2014_marginal_holdout_", formula_label)]] <- metric_row(
    bnc_marginal_name,
    formula_label,
    "BNC2014",
    "BNC2014",
    nrow(split$train),
    nrow(split$test),
    split$test$y_np,
    bnc_marginal_p,
    df = 1L
  )

  bnc_model_name <- paste0("bnc2014_native_", formula_label, "_holdout")
  bnc_fit <- fit_glm(bnc_model_name, formula, split$train)
  bnc_pred <- predict_glm(bnc_fit, split$test)
  metrics_list[[bnc_model_name]] <- metric_row(
    bnc_model_name,
    formula_label,
    "BNC2014",
    "BNC2014",
    nrow(split$train),
    nrow(split$test),
    split$test$y_np,
    bnc_pred,
    df = length(stats::coef(bnc_fit$model)),
    aic = stats::AIC(bnc_fit$model)
  )
  warnings_list[[bnc_model_name]] <- bnc_fit$warnings
  coef_list[[bnc_model_name]] <- coef_rows(bnc_model_name, formula_label, bnc_fit)
  calibration_list[[bnc_model_name]] <- calibration_by_group(
    split$test$Verb,
    split$test$y_np,
    bnc_model_name,
    bnc_pred
  )

  set.seed(20260626)
  scrambled_train <- split$train
  scrambled_train$y_np <- sample(scrambled_train$y_np)
  scrambled_model_name <- paste0("bnc2014_native_", formula_label, "_scrambled_train")
  scrambled_fit <- fit_glm(scrambled_model_name, formula, scrambled_train)
  scrambled_pred <- predict_glm(scrambled_fit, split$test)
  metrics_list[[scrambled_model_name]] <- metric_row(
    scrambled_model_name,
    formula_label,
    "BNC2014_scrambled_train",
    "BNC2014",
    nrow(scrambled_train),
    nrow(split$test),
    split$test$y_np,
    scrambled_pred,
    df = length(stats::coef(scrambled_fit$model)),
    aic = stats::AIC(scrambled_fit$model)
  )
  warnings_list[[scrambled_model_name]] <- scrambled_fit$warnings

  bnc_full_name <- paste0("bnc2014_native_", formula_label, "_full")
  bnc_full_fit <- fit_glm(bnc_full_name, formula, bnc_cc)
  warnings_list[[bnc_full_name]] <- bnc_full_fit$warnings
  coef_list[[bnc_full_name]] <- coef_rows(
    bnc_full_name,
    formula_label,
    bnc_full_fit
  )
}

metrics <- do.call(rbind, metrics_list)
warnings <- do.call(rbind, warnings_list)
coefficients <- do.call(rbind, coef_list)
calibration <- do.call(rbind, calibration_list)
coverage <- do.call(rbind, coverage_list)

utils::write.csv(
  metrics,
  file.path(derived_dir, "bnc2014_transport_metrics.csv"),
  row.names = FALSE
)
utils::write.csv(
  warnings,
  file.path(derived_dir, "bnc2014_transport_warnings.csv"),
  row.names = FALSE
)
utils::write.csv(
  coefficients,
  file.path(derived_dir, "bnc2014_transport_coefficients.csv"),
  row.names = FALSE
)
utils::write.csv(
  calibration,
  file.path(derived_dir, "bnc2014_transport_calibration_by_verb.csv"),
  row.names = FALSE
)
utils::write.csv(
  coverage,
  file.path(derived_dir, "bnc2014_transport_feature_coverage.csv"),
  row.names = FALSE
)

print(metrics, row.names = FALSE)
print(coverage[coverage$variable == "y_np", ], row.names = FALSE)
