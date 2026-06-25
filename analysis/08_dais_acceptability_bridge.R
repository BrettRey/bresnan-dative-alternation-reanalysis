# Compact DAIS bridge: compare production-model NP probability with human
# double-object preference for the six verbs shared with languageR and BNC2014.

source(file.path("analysis", "lib_languageR_dative.R"))

derived_dir <- file.path("data", "derived")
dir.create(derived_dir, recursive = TRUE, showWarnings = FALSE)

dais_repo <- "https://github.com/taka-yamakoshi/neural_constructions"
dais_commit <- "16ef145b71d1f6e6d755ad0f5ff822327639af0a"
dais_csv_url <- sprintf(
  "https://raw.githubusercontent.com/taka-yamakoshi/neural_constructions/%s/DAIS/data/generated_pairs_with_results.csv",
  dais_commit
)
dais_csv_md5 <- "46af310f1633b8784f897e4482faed84"
dais_cleaned_zip_url <- sprintf(
  "https://raw.githubusercontent.com/taka-yamakoshi/neural_constructions/%s/DAIS/data/experiment_output/data_cleaned.zip",
  dais_commit
)
dais_cleaned_zip_md5 <- "e7b3ac6f2dd8e85bc93e6e20fc0f6ec1"

dais_csv_path <- tempfile(fileext = ".csv")
on.exit(unlink(dais_csv_path), add = TRUE)
utils::download.file(dais_csv_url, dais_csv_path, quiet = TRUE, mode = "wb")

downloaded_md5 <- unname(tools::md5sum(dais_csv_path))
if (!identical(downloaded_md5, dais_csv_md5)) {
  stop("Downloaded DAIS item-level CSV failed MD5 validation.")
}

dais <- utils::read.csv(
  dais_csv_path,
  stringsAsFactors = FALSE,
  check.names = FALSE
)
if (nrow(dais) != 5000L) {
  stop("Unexpected number of DAIS item rows.")
}

dais_cleaned_zip_path <- tempfile(fileext = ".zip")
dais_cleaned_dir <- tempfile()
dir.create(dais_cleaned_dir)
on.exit(unlink(dais_cleaned_zip_path), add = TRUE)
on.exit(unlink(dais_cleaned_dir, recursive = TRUE), add = TRUE)
utils::download.file(
  dais_cleaned_zip_url,
  dais_cleaned_zip_path,
  quiet = TRUE,
  mode = "wb"
)

downloaded_cleaned_md5 <- unname(tools::md5sum(dais_cleaned_zip_path))
if (!identical(downloaded_cleaned_md5, dais_cleaned_zip_md5)) {
  stop("Downloaded DAIS cleaned judgement ZIP failed MD5 validation.")
}

utils::unzip(dais_cleaned_zip_path, exdir = dais_cleaned_dir)
dais_cleaned_path <- file.path(dais_cleaned_dir, "data_cleaned.csv")
if (!file.exists(dais_cleaned_path)) {
  stop("Could not find data_cleaned.csv inside DAIS cleaned judgement ZIP.")
}

dais_cleaned <- utils::read.csv(
  dais_cleaned_path,
  stringsAsFactors = FALSE,
  check.names = FALSE
)
if (nrow(dais_cleaned) != 50136L) {
  stop("Unexpected number of DAIS cleaned judgement rows.")
}

yes_no_levels <- c("no", "yes")

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

extract_pd_parts <- function(pd_sentence) {
  matches <- regexec(
    "^[^[:space:]]+[[:space:]]+([^[:space:]]+)[[:space:]]+(.*)[[:space:]]+to[[:space:]]+(.*)$",
    pd_sentence,
    perl = TRUE
  )
  parts <- regmatches(pd_sentence, matches)

  data.frame(
    verb_past = vapply(
      parts,
      function(x) if (length(x) == 4L) x[2] else NA_character_,
      character(1)
    ),
    theme_phrase = vapply(
      parts,
      function(x) if (length(x) == 4L) x[3] else NA_character_,
      character(1)
    ),
    recipient_phrase = vapply(
      parts,
      function(x) if (length(x) == 4L) x[4] else NA_character_,
      character(1)
    ),
    stringsAsFactors = FALSE
  )
}

harmonize_languageR <- function(dative, shared_verbs) {
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
    rec_pron = level_yes_no(d$PronomOfRec, "pronominal"),
    theme_anim = level_yes_no(d$AnimacyOfTheme, "animate"),
    theme_def = level_yes_no(d$DefinOfTheme, "definite"),
    theme_pron = level_yes_no(d$PronomOfTheme, "pronominal"),
    stringsAsFactors = FALSE
  )
}

prepare_dais_newdata <- function(dais_shared, shared_verbs, something_pronominal) {
  data.frame(
    Verb = factor(dais_shared$Verb, levels = shared_verbs),
    rec_len_words = word_count(dais_shared$recipient_phrase),
    theme_len_words = word_count(dais_shared$theme_phrase),
    rec_anim = factor("yes", levels = yes_no_levels),
    rec_pron = factor(
      ifelse(dais_shared$recipient_id == "pronoun", "yes", "no"),
      levels = yes_no_levels
    ),
    theme_anim = factor("no", levels = yes_no_levels),
    theme_def = factor(
      ifelse(dais_shared$theme_type == "def", "yes", "no"),
      levels = yes_no_levels
    ),
    theme_pron = factor(
      ifelse(something_pronominal & dais_shared$theme_phrase == "something",
             "yes", "no"),
      levels = yes_no_levels
    ),
    stringsAsFactors = FALSE
  )
}

score_dais <- function(dais_shared, fit, shared_verbs, coding, something_pronominal) {
  newdata <- prepare_dais_newdata(
    dais_shared,
    shared_verbs,
    something_pronominal = something_pronominal
  )
  scored <- dais_shared
  scored$coding <- coding
  scored$production_np_prob <- as.numeric(stats::predict(
    fit,
    newdata = newdata,
    type = "response"
  ))
  scored$human_do_preference <- scored$BehavDOpreference / 100
  scored$gap_production_minus_human <-
    scored$production_np_prob - scored$human_do_preference
  scored$abs_gap <- abs(scored$gap_production_minus_human)
  scored$rec_len_words <- newdata$rec_len_words
  scored$theme_len_words <- newdata$theme_len_words
  scored
}

summary_rows <- function(scored, all_item_count) {
  data.frame(
    coding = unique(scored$coding),
    metric = c(
      "all_dais_item_rows",
      "shared_verb_item_rows",
      "pearson_production_human",
      "spearman_production_human",
      "mean_production_np_prob",
      "mean_human_do_preference",
      "mean_abs_gap"
    ),
    value = c(
      all_item_count,
      nrow(scored),
      stats::cor(scored$production_np_prob, scored$human_do_preference),
      stats::cor(
        scored$production_np_prob,
        scored$human_do_preference,
        method = "spearman"
      ),
      mean(scored$production_np_prob),
      mean(scored$human_do_preference),
      mean(scored$abs_gap)
    ),
    stringsAsFactors = FALSE
  )
}

mean_aggregate <- function(group_vars, data) {
  mean_rows <- stats::aggregate(
    cbind(
      production_np_prob,
      human_do_preference,
      gap_production_minus_human,
      abs_gap
    ) ~ .,
    data = data[, c(group_vars, "production_np_prob",
                    "human_do_preference", "gap_production_minus_human",
                    "abs_gap")],
    mean
  )
  count_rows <- stats::aggregate(
    production_np_prob ~ .,
    data = data[, c(group_vars, "production_np_prob")],
    length
  )
  names(count_rows)[ncol(count_rows)] <- "n_items"
  merge(count_rows, mean_rows, by = group_vars)
}

source_rows <- data.frame(
  source = "DAIS item-level generated pairs with behavioral means",
  repository = dais_repo,
  commit = dais_commit,
  file = "DAIS/data/generated_pairs_with_results.csv",
  md5 = dais_csv_md5,
  cleaned_zip_md5 = dais_cleaned_zip_md5,
  licence = "CC BY 4.0",
  licence_commit_date = "2026-06-24",
  permission_email_date = "2026-06-25",
  stringsAsFactors = FALSE
)

shared_verbs <- c("give", "send", "show", "sell", "offer", "lend")
past_to_base <- c(
  gave = "give",
  sent = "send",
  showed = "show",
  sold = "sell",
  offered = "offer",
  lent = "lend"
)

parts <- extract_pd_parts(dais$PDsentence)
dais$Verb <- unname(past_to_base[parts$verb_past])
dais$theme_phrase <- parts$theme_phrase
dais$recipient_phrase <- parts$recipient_phrase

dais_shared <- dais[!is.na(dais$Verb), , drop = FALSE]
if (nrow(dais_shared) != 150L) {
  stop("Unexpected number of DAIS rows for the six shared verbs.")
}

dative <- load_languageR_dative()
validate_languageR_dative(dative)
languageR_h <- harmonize_languageR(dative, shared_verbs)

core_formula <- y_np ~ Verb + rec_len_words + theme_len_words +
  rec_anim + rec_pron + theme_anim + theme_def + theme_pron

warnings <- character()
fit <- withCallingHandlers(
  stats::glm(
    core_formula,
    data = languageR_h[stats::complete.cases(languageR_h), , drop = FALSE],
    family = stats::binomial()
  ),
  warning = function(w) {
    warnings <<- c(warnings, conditionMessage(w))
    invokeRestart("muffleWarning")
  }
)

scored <- rbind(
  score_dais(
    dais_shared,
    fit,
    shared_verbs,
    coding = "something_pronominal",
    something_pronominal = TRUE
  ),
  score_dais(
    dais_shared,
    fit,
    shared_verbs,
    coding = "something_nonpronominal",
    something_pronominal = FALSE
  )
)

scored_main <- scored[scored$coding == "something_pronominal", , drop = FALSE]

summary_out <- do.call(
  rbind,
  lapply(split(scored, scored$coding), summary_rows, all_item_count = nrow(dais))
)

by_verb <- mean_aggregate(c("coding", "Verb"), scored)
by_condition <- mean_aggregate(c("coding", "recipient_id", "theme_type"), scored)

ranked_cases <- do.call(rbind, lapply(split(scored, scored$coding), function(x) {
  high_production <- x[order(-x$gap_production_minus_human), ]
  high_human <- x[order(x$gap_production_minus_human), ]
  high_production <- head(high_production, 12L)
  high_human <- head(high_human, 12L)
  high_production$direction <- "production_higher_than_human"
  high_human$direction <- "human_higher_than_production"
  rbind(high_production, high_human)
}))

case_cols <- c(
  "coding",
  "direction",
  "Verb",
  "classification",
  "recipient_id",
  "theme_type",
  "DOsentence",
  "PDsentence",
  "production_np_prob",
  "human_do_preference",
  "gap_production_minus_human",
  "abs_gap"
)
ranked_cases <- ranked_cases[, case_cols]

scored_item_cols <- c(
  "coding",
  "Verb",
  "classification",
  "recipient_id",
  "theme_type",
  "DOsentence",
  "PDsentence",
  "production_np_prob",
  "human_do_preference",
  "gap_production_minus_human",
  "abs_gap",
  "rec_len_words",
  "theme_len_words"
)
scored_item_rows <- scored[, scored_item_cols]

dais_cleaned$Verb <- unname(past_to_base[dais_cleaned$verb])
dais_cleaned_shared <- merge(
  dais_cleaned,
  scored_main[, c(
    "DOsentence",
    "PDsentence",
    "Verb",
    "production_np_prob",
    "human_do_preference"
  )],
  by = c("DOsentence", "PDsentence", "Verb"),
  all = FALSE
)
dais_cleaned_shared$DOpreference_01 <- dais_cleaned_shared$DOpreference / 100

participant_summary_out <- data.frame(
  metric = c(
    "cleaned_judgement_rows",
    "cleaned_participants",
    "shared_verb_judgement_rows",
    "shared_verb_participants",
    "shared_verb_items"
  ),
  value = c(
    nrow(dais_cleaned),
    length(unique(dais_cleaned$participant_id)),
    nrow(dais_cleaned_shared),
    length(unique(dais_cleaned_shared$participant_id)),
    length(unique(paste(
      dais_cleaned_shared$DOsentence,
      dais_cleaned_shared$PDsentence,
      sep = "\n"
    )))
  ),
  stringsAsFactors = FALSE
)

mixed_model_out <- data.frame(
  model = character(),
  term = character(),
  estimate = numeric(),
  std_error = numeric(),
  df = numeric(),
  statistic = numeric(),
  p_value = numeric(),
  stringsAsFactors = FALSE
)
mixed_model_diagnostics <- data.frame(
  metric = c("lme4_available", "model_fit", "singular_fit", "rows"),
  value = c(
    requireNamespace("lme4", quietly = TRUE),
    FALSE,
    NA,
    nrow(dais_cleaned_shared)
  ),
  stringsAsFactors = FALSE
)
mixed_model_warnings <- character()

if (requireNamespace("lme4", quietly = TRUE)) {
  mm_data <- dais_cleaned_shared
  mm_data$participant_id <- factor(mm_data$participant_id)
  mm_data$Verb <- factor(mm_data$Verb, levels = shared_verbs)
  mm_data$recipient_id <- factor(mm_data$recipient_id)
  mm_data$theme_type <- factor(mm_data$theme_type)

  mixed_fit <- tryCatch(
    withCallingHandlers(
      lme4::lmer(
        DOpreference_01 ~ production_np_prob + recipient_id + theme_type +
          (1 | participant_id) + (1 | Verb),
        data = mm_data,
        REML = FALSE
      ),
      warning = function(w) {
        mixed_model_warnings <<- c(mixed_model_warnings, conditionMessage(w))
        invokeRestart("muffleWarning")
      }
    ),
    error = function(e) e
  )

  if (inherits(mixed_fit, "error")) {
    mixed_model_diagnostics$value[
      mixed_model_diagnostics$metric == "model_fit"
    ] <- FALSE
    mixed_model_warnings <- c(mixed_model_warnings, conditionMessage(mixed_fit))
  } else {
    mixed_model_diagnostics$value[
      mixed_model_diagnostics$metric == "model_fit"
    ] <- TRUE
    mixed_model_diagnostics$value[
      mixed_model_diagnostics$metric == "singular_fit"
    ] <- lme4::isSingular(mixed_fit)

    coef_summary <- summary(mixed_fit)$coefficients
    mixed_model_out <- data.frame(
      model = "dais_participant_mixed_bridge",
      term = rownames(coef_summary),
      estimate = coef_summary[, "Estimate"],
      std_error = coef_summary[, "Std. Error"],
      df = if ("df" %in% colnames(coef_summary)) coef_summary[, "df"] else NA_real_,
      statistic = if ("t value" %in% colnames(coef_summary)) {
        coef_summary[, "t value"]
      } else {
        NA_real_
      },
      p_value = if ("Pr(>|t|)" %in% colnames(coef_summary)) {
        coef_summary[, "Pr(>|t|)"]
      } else {
        NA_real_
      },
      row.names = NULL
    )
  }
}

mixed_model_warning_out <- if (length(mixed_model_warnings)) {
  data.frame(
    model = "dais_participant_mixed_bridge",
    warning = unique(mixed_model_warnings),
    stringsAsFactors = FALSE
  )
} else {
  data.frame(model = character(), warning = character())
}

coef_summary <- summary(fit)$coefficients
coef_out <- data.frame(
  model = "languageR_spoken_shared_core_to_dais",
  term = rownames(coef_summary),
  estimate = coef_summary[, "Estimate"],
  std_error = coef_summary[, "Std. Error"],
  z_value = coef_summary[, "z value"],
  p_value = coef_summary[, "Pr(>|z|)"],
  row.names = NULL
)

warning_out <- if (length(warnings)) {
  data.frame(
    model = "languageR_spoken_shared_core_to_dais",
    warning = unique(warnings),
    stringsAsFactors = FALSE
  )
} else {
  data.frame(model = character(), warning = character())
}

utils::write.csv(
  source_rows,
  file.path(derived_dir, "dais_acceptability_bridge_source.csv"),
  row.names = FALSE
)
utils::write.csv(
  summary_out,
  file.path(derived_dir, "dais_acceptability_bridge_summary.csv"),
  row.names = FALSE
)
utils::write.csv(
  by_verb,
  file.path(derived_dir, "dais_acceptability_bridge_by_verb.csv"),
  row.names = FALSE
)
utils::write.csv(
  by_condition,
  file.path(derived_dir, "dais_acceptability_bridge_by_condition.csv"),
  row.names = FALSE
)
utils::write.csv(
  ranked_cases,
  file.path(derived_dir, "dais_acceptability_bridge_divergence_cases.csv"),
  row.names = FALSE
)
utils::write.csv(
  scored_item_rows,
  file.path(derived_dir, "dais_acceptability_bridge_scored_items.csv"),
  row.names = FALSE
)
utils::write.csv(
  participant_summary_out,
  file.path(derived_dir, "dais_acceptability_bridge_participant_summary.csv"),
  row.names = FALSE
)
utils::write.csv(
  mixed_model_out,
  file.path(derived_dir, "dais_acceptability_bridge_mixed_model.csv"),
  row.names = FALSE
)
utils::write.csv(
  mixed_model_diagnostics,
  file.path(derived_dir, "dais_acceptability_bridge_mixed_model_diagnostics.csv"),
  row.names = FALSE
)
utils::write.csv(
  mixed_model_warning_out,
  file.path(derived_dir, "dais_acceptability_bridge_mixed_model_warnings.csv"),
  row.names = FALSE
)
utils::write.csv(
  coef_out,
  file.path(derived_dir, "dais_acceptability_bridge_coefficients.csv"),
  row.names = FALSE
)
utils::write.csv(
  warning_out,
  file.path(derived_dir, "dais_acceptability_bridge_warnings.csv"),
  row.names = FALSE
)

message("Wrote DAIS bridge summaries to ", derived_dir)
