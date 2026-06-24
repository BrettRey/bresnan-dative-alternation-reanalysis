# Sampling-scope and complete-case sensitivity checks for BNC2014 transport.

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

mode_level <- function(x) {
  counts <- sort(table(x, useNA = "no"), decreasing = TRUE)
  names(counts)[1]
}

impute_core <- function(data, binary_policy = c("mode", "no", "yes")) {
  binary_policy <- match.arg(binary_policy)
  out <- data
  out$rec_len_words[is.na(out$rec_len_words)] <- stats::median(
    out$rec_len_words,
    na.rm = TRUE
  )
  out$theme_len_words[is.na(out$theme_len_words)] <- stats::median(
    out$theme_len_words,
    na.rm = TRUE
  )

  binary_vars <- c(
    "rec_anim",
    "rec_pron",
    "theme_anim",
    "theme_def",
    "theme_pron"
  )
  for (var in binary_vars) {
    fill <- if (binary_policy == "mode") mode_level(out[[var]]) else binary_policy
    out[[var]] <- as.character(out[[var]])
    out[[var]][is.na(out[[var]])] <- fill
    out[[var]] <- factor(out[[var]], levels = yes_no_levels)
  }

  out
}

metric_row <- function(label, test, pred) {
  metrics <- classification_metrics(test$y_np, pred)
  data.frame(
    evaluation = label,
    rows = nrow(test),
    np_rate = mean(test$y_np),
    mean_prediction = mean(pred),
    log_loss = metrics$log_loss,
    auc = metrics$auc,
    accuracy = metrics$accuracy,
    stringsAsFactors = FALSE
  )
}

dative <- load_languageR_dative()
validate_languageR_dative(dative)

shared_verbs <- c("give", "send", "show", "sell", "offer", "lend")
dative$shared_verb <- as.character(dative$Verb) %in% shared_verbs
dative$y_np <- as.integer(dative$RealizationOfRecipient == "NP")

scope_rows <- data.frame(
  comparison = c(
    "languageR all rows",
    "languageR shared verbs",
    "languageR spoken rows",
    "languageR spoken shared verbs",
    "languageR spoken non-shared verbs"
  ),
  rows = c(
    nrow(dative),
    sum(dative$shared_verb),
    sum(dative$Modality == "spoken"),
    sum(dative$Modality == "spoken" & dative$shared_verb),
    sum(dative$Modality == "spoken" & !dative$shared_verb)
  ),
  denominator = c(
    nrow(dative),
    nrow(dative),
    nrow(dative),
    sum(dative$Modality == "spoken"),
    sum(dative$Modality == "spoken")
  ),
  np_rate = c(
    mean(dative$y_np),
    mean(dative$y_np[dative$shared_verb]),
    mean(dative$y_np[dative$Modality == "spoken"]),
    mean(dative$y_np[dative$Modality == "spoken" & dative$shared_verb]),
    mean(dative$y_np[dative$Modality == "spoken" & !dative$shared_verb])
  ),
  stringsAsFactors = FALSE
)
scope_rows$share <- scope_rows$rows / scope_rows$denominator

lang_shared <- dative[
  dative$Modality == "spoken" & dative$shared_verb,
]
lang_h <- data.frame(
  y_np = as.integer(lang_shared$RealizationOfRecipient == "NP"),
  Verb = factor(as.character(lang_shared$Verb), levels = shared_verbs),
  rec_len_words = lang_shared$LengthOfRecipient,
  theme_len_words = lang_shared$LengthOfTheme,
  rec_anim = level_yes_no(lang_shared$AnimacyOfRec, "animate"),
  rec_pron = level_yes_no(lang_shared$PronomOfRec, "pronominal"),
  theme_anim = level_yes_no(lang_shared$AnimacyOfTheme, "animate"),
  theme_def = level_yes_no(lang_shared$DefinOfTheme, "definite"),
  theme_pron = level_yes_no(lang_shared$PronomOfTheme, "pronominal"),
  stringsAsFactors = FALSE
)

bnc_h <- data.frame(
  y_np = as.integer(bnc_raw$Pattern == "VNN"),
  Verb = factor(bnc_raw$Verb, levels = shared_verbs),
  rec_len_words = word_count(bnc_raw$Recipient),
  theme_len_words = word_count(bnc_raw$Theme),
  rec_anim = logical_yes_no(bnc_raw$AnimateRec),
  rec_pron = logical_yes_no(bnc_raw$RecPrn),
  theme_anim = logical_yes_no(bnc_raw$AnimateTheme),
  theme_def = logical_yes_no(bnc_raw$DefTheme),
  theme_pron = logical_yes_no(bnc_raw$ThemePrn),
  stringsAsFactors = FALSE
)

core_formula <- y_np ~ Verb + rec_len_words + theme_len_words +
  rec_anim + rec_pron + theme_anim + theme_def + theme_pron

bnc_complete <- stats::complete.cases(bnc_h[, all.vars(core_formula), drop = FALSE])
bnc_scope_rows <- data.frame(
  comparison = c(
    "BNC2014 all released dative rows",
    "BNC2014 complete core rows",
    "BNC2014 incomplete core rows"
  ),
  rows = c(nrow(bnc_h), sum(bnc_complete), sum(!bnc_complete)),
  denominator = nrow(bnc_h),
  np_rate = c(
    mean(bnc_h$y_np),
    mean(bnc_h$y_np[bnc_complete]),
    mean(bnc_h$y_np[!bnc_complete])
  ),
  stringsAsFactors = FALSE
)
bnc_scope_rows$share <- bnc_scope_rows$rows / bnc_scope_rows$denominator

core_fit <- stats::glm(core_formula, data = lang_h, family = stats::binomial())

complete_pred <- stats::predict(
  core_fit,
  newdata = bnc_h[bnc_complete, ],
  type = "response"
)
mode_pred <- stats::predict(core_fit, newdata = impute_core(bnc_h, "mode"), type = "response")
no_pred <- stats::predict(core_fit, newdata = impute_core(bnc_h, "no"), type = "response")
yes_pred <- stats::predict(core_fit, newdata = impute_core(bnc_h, "yes"), type = "response")

sensitivity_rows <- rbind(
  metric_row("core complete-case", bnc_h[bnc_complete, ], complete_pred),
  metric_row("all rows with median/mode imputation", bnc_h, mode_pred),
  metric_row("all rows with median/no imputation", bnc_h, no_pred),
  metric_row("all rows with median/yes imputation", bnc_h, yes_pred)
)

utils::write.csv(
  rbind(scope_rows, bnc_scope_rows),
  file.path(derived_dir, "sampling_tilt_scope_summary.csv"),
  row.names = FALSE
)
utils::write.csv(
  sensitivity_rows,
  file.path(derived_dir, "sampling_tilt_sensitivity_metrics.csv"),
  row.names = FALSE
)
