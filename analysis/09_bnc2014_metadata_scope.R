# Descriptive metadata-scope audit for the BNC2014 dative transport target.

source(file.path("analysis", "lib_languageR_dative.R"))

if (!requireNamespace("jsonlite", quietly = TRUE)) {
  stop("Package 'jsonlite' is required to read Figshare API metadata.")
}

derived_dir <- file.path("data", "derived")
dir.create(derived_dir, recursive = TRUE, showWarnings = FALSE)

shared_verbs <- c("give", "send", "show", "sell", "offer", "lend")
yes_no_levels <- c("no", "yes")

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

blank_to_na <- function(x) {
  if (!is.character(x)) {
    return(x)
  }

  y <- trimws(x)
  y[y == ""] <- NA_character_
  y
}

word_count <- function(x) {
  x <- trimws(x)
  x[x == ""] <- NA_character_
  out <- rep(NA_integer_, length(x))
  ok <- !is.na(x)
  out[ok] <- lengths(regmatches(x[ok], gregexpr("\\S+", x[ok], perl = TRUE)))
  out
}

logical_yes_no <- function(x) {
  factor(
    ifelse(is.na(x), NA_character_, ifelse(x, "yes", "no")),
    levels = yes_no_levels
  )
}

level_yes_no <- function(x, positive) {
  factor(ifelse(x == positive, "yes", "no"), levels = yes_no_levels)
}

definite_proxy <- function(x) {
  x <- trimws(x)
  x[x == ""] <- NA_character_
  out <- rep(NA, length(x))
  ok <- !is.na(x)
  out[ok] <- grepl("\\b(the|these|this|those|that)\\b", x[ok], ignore.case = TRUE)
  logical_yes_no(out)
}

label_missing <- function(x) {
  y <- as.character(x)
  y[is.na(y)] <- "(missing)"
  y
}

shorten_num_speakers <- function(x) {
  sub("^Texts with ([0-9]+) speakers$", "\\1 speakers", x)
}

canonical_metadata <- function(data) {
  data$Relation <- ifelse(
    tolower(data$Relation) == "colleagues",
    "Colleagues",
    data$Relation
  )
  data$NumSpeakers <- shorten_num_speakers(data$NumSpeakers)
  data
}

make_bnc_core <- function(bnc) {
  data.frame(
    y_np = as.integer(bnc$Pattern == "VNN"),
    Verb = factor(bnc$Verb, levels = shared_verbs),
    rec_len_words = word_count(bnc$Recipient),
    theme_len_words = word_count(bnc$Theme),
    rec_anim = logical_yes_no(bnc$AnimateRec),
    rec_pron = logical_yes_no(bnc$RecPrn),
    theme_anim = logical_yes_no(bnc$AnimateTheme),
    theme_def = logical_yes_no(bnc$DefTheme),
    theme_pron = logical_yes_no(bnc$ThemePrn),
    stringsAsFactors = FALSE
  )
}

make_languageR_harmonized <- function(dative) {
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

make_bnc_harmonized <- function(bnc) {
  data.frame(
    row_id = seq_len(nrow(bnc)),
    y_np = as.integer(bnc$Pattern == "VNN"),
    Pattern = bnc$Pattern,
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

metadata_counts <- function(data, complete, field, set_name, min_n = 25L) {
  idx <- if (set_name == "all_released") {
    rep(TRUE, nrow(data))
  } else if (set_name == "core_complete") {
    complete
  } else {
    stop("Unknown set name.")
  }

  d <- data[idx, , drop = FALSE]
  values <- sort(unique(label_missing(d[[field]])))

  rows <- do.call(rbind, lapply(values, function(value) {
    level_idx <- label_missing(d[[field]]) == value
    rows <- sum(level_idx)
    np_rows <- sum(d$y_np[level_idx])
    pp_rows <- rows - np_rows
    data.frame(
      set = set_name,
      field = field,
      value = value,
      rows = rows,
      np_rows = np_rows,
      pp_rows = pp_rows,
      share = rows / nrow(d),
      np_rate = if (rows >= min_n) np_rows / rows else NA_real_,
      rate_min_n = min_n,
      rate_reportable = rows >= min_n,
      stringsAsFactors = FALSE
    )
  }))

  rows[order(-rows$rows, rows$value), ]
}

field_summary <- function(count_rows) {
  do.call(rbind, lapply(split(count_rows, count_rows$field), function(x) {
    x_all <- x[x$set == "all_released", , drop = FALSE]
    x_all <- x_all[order(-x_all$rows, x_all$value), , drop = FALSE]
    missing_rows <- x_all$rows[x_all$value == "(missing)"]
    if (!length(missing_rows)) {
      missing_rows <- 0L
    }
    data.frame(
      field = x_all$field[1],
      levels = nrow(x_all),
      missing_rows = missing_rows,
      largest_level = x_all$value[1],
      largest_rows = x_all$rows[1],
      largest_share = x_all$share[1],
      reportable_cells_all = sum(x_all$rate_reportable),
      stringsAsFactors = FALSE
    )
  }))
}

missingness_by_variable <- function(data, variables) {
  do.call(rbind, lapply(variables, function(var) {
    miss <- is.na(data[[var]])
    data.frame(
      variable = var,
      rows = nrow(data),
      missing_rows = sum(miss),
      missing_share = mean(miss),
      observed_rows = sum(!miss),
      np_rate_missing = if (any(miss)) mean(data$y_np[miss]) else NA_real_,
      np_rate_observed = if (any(!miss)) mean(data$y_np[!miss]) else NA_real_,
      stringsAsFactors = FALSE
    )
  }))
}

missingness_by_verb_pattern <- function(data, variables) {
  rows <- expand.grid(
    variable = variables,
    Verb = as.character(sort(unique(data$Verb))),
    Pattern = sort(unique(data$Pattern)),
    stringsAsFactors = FALSE
  )
  do.call(rbind, lapply(seq_len(nrow(rows)), function(i) {
    row <- rows[i, ]
    idx <- as.character(data$Verb) == row$Verb & data$Pattern == row$Pattern
    miss <- is.na(data[[row$variable]][idx])
    data.frame(
      variable = row$variable,
      Verb = row$Verb,
      Pattern = row$Pattern,
      rows = sum(idx),
      missing_rows = sum(miss),
      missing_share = if (sum(idx)) mean(miss) else NA_real_,
      stringsAsFactors = FALSE
    )
  }))
}

completeness_by_metadata <- function(data, complete, field) {
  values <- sort(unique(label_missing(data[[field]])))
  do.call(rbind, lapply(values, function(value) {
    idx <- label_missing(data[[field]]) == value
    complete_rows <- sum(complete[idx])
    incomplete_rows <- sum(!complete[idx])
    data.frame(
      field = field,
      value = value,
      rows = sum(idx),
      complete_rows = complete_rows,
      incomplete_rows = incomplete_rows,
      incomplete_share = incomplete_rows / sum(idx),
      np_rate_all = mean(data$y_np[idx]),
      np_rate_complete = if (complete_rows) mean(data$y_np[idx & complete]) else NA_real_,
      np_rate_incomplete = if (incomplete_rows) mean(data$y_np[idx & !complete]) else NA_real_,
      stringsAsFactors = FALSE
    )
  }))
}

harmonization_mapping <- function(languageR_h, bnc_h) {
  rows <- data.frame(
    predictor = c(
      "y_np",
      "Verb",
      "rec_len_words",
      "theme_len_words",
      "rec_anim",
      "rec_def",
      "rec_pron",
      "theme_anim",
      "theme_def",
      "theme_pron"
    ),
    languageR_field = c(
      "RealizationOfRecipient",
      "Verb",
      "LengthOfRecipient",
      "LengthOfTheme",
      "AnimacyOfRec",
      "DefinOfRec",
      "PronomOfRec",
      "AnimacyOfTheme",
      "DefinOfTheme",
      "PronomOfTheme"
    ),
    bnc2014_field_or_derivation = c(
      "Pattern",
      "Verb",
      "word count derived from Recipient text",
      "word count derived from Theme text",
      "AnimateRec",
      "proxy from Recipient determiner string",
      "RecPrn",
      "AnimateTheme",
      "DefTheme",
      "ThemePrn"
    ),
    recoding = c(
      "languageR NP = 1; BNC2014 VNN = 1",
      "restricted to six shared verbs",
      "left raw; no centering or scaling",
      "left raw; no centering or scaling",
      "animate = yes; inanimate = no",
      "definite = yes; other = no; BNC proxy uses the/this/that/these/those",
      "pronominal = yes; nonpronominal = no",
      "animate = yes; inanimate = no",
      "definite = yes; indefinite = no",
      "pronominal = yes; nonpronominal = no"
    ),
    headline_role = c(
      "outcome",
      "headline and reduced all-row",
      "headline",
      "headline",
      "headline",
      "sensitivity only",
      "headline",
      "headline and reduced all-row",
      "headline and reduced all-row",
      "headline"
    ),
    reference_or_scale = c(
      "PP/VNPP is reference outcome",
      shared_verbs[1],
      "raw count",
      "raw count",
      yes_no_levels[1],
      yes_no_levels[1],
      yes_no_levels[1],
      yes_no_levels[1],
      yes_no_levels[1],
      yes_no_levels[1]
    ),
    stringsAsFactors = FALSE
  )
  rows$languageR_missing_rows <- vapply(
    rows$predictor,
    function(x) sum(is.na(languageR_h[[x]])),
    integer(1)
  )
  rows$bnc2014_missing_rows <- vapply(
    rows$predictor,
    function(x) sum(is.na(bnc_h[[x]])),
    integer(1)
  )
  rows$languageR_rows <- nrow(languageR_h)
  rows$bnc2014_rows <- nrow(bnc_h)
  rows
}

reduced_allrow_metrics <- function(languageR_h, bnc_h) {
  formulas <- list(
    source_marginal_all_rows = NULL,
    source_verb_only_all_rows = y_np ~ Verb,
    source_theme_only_all_rows = y_np ~ theme_anim + theme_def,
    source_verb_theme_all_rows = y_np ~ Verb + theme_anim + theme_def
  )
  do.call(rbind, lapply(names(formulas), function(name) {
    formula <- formulas[[name]]
    pred <- if (is.null(formula)) {
      rep(mean(languageR_h$y_np), nrow(bnc_h))
    } else {
      fit <- stats::glm(formula, data = languageR_h, family = stats::binomial())
      stats::predict(fit, newdata = bnc_h, type = "response")
    }
    data.frame(
      evaluation = name,
      formula = if (is.null(formula)) {
        "intercept-only marginal probability"
      } else {
        paste(deparse(formula), collapse = " ")
      },
      rows = nrow(bnc_h),
      np_rate = mean(bnc_h$y_np),
      mean_prediction = mean(pred),
      classification_metrics(bnc_h$y_np, pred),
      stringsAsFactors = FALSE
    )
  }))
}

predictor_distribution_comparison <- function(languageR_h, bnc_h, bnc_complete) {
  source <- languageR_h
  target_complete <- bnc_h[bnc_complete, , drop = FALSE]
  datasets <- list(
    languageR_spoken_shared = source,
    BNC2014_all_released = bnc_h,
    BNC2014_core_complete = target_complete
  )
  numeric_vars <- c("rec_len_words", "theme_len_words")
  binary_vars <- c(
    "rec_anim",
    "rec_def",
    "rec_pron",
    "theme_anim",
    "theme_def",
    "theme_pron"
  )

  numeric_rows <- do.call(rbind, lapply(names(datasets), function(set_name) {
    data <- datasets[[set_name]]
    do.call(rbind, lapply(numeric_vars, function(var) {
      x <- data[[var]]
      data.frame(
        set = set_name,
        variable = var,
        type = "numeric",
        level = NA_character_,
        rows = nrow(data),
        observed_rows = sum(!is.na(x)),
        missing_rows = sum(is.na(x)),
        mean = mean(x, na.rm = TRUE),
        sd = stats::sd(x, na.rm = TRUE),
        min = min(x, na.rm = TRUE),
        max = max(x, na.rm = TRUE),
        share = NA_real_,
        stringsAsFactors = FALSE
      )
    }))
  }))

  binary_rows <- do.call(rbind, lapply(names(datasets), function(set_name) {
    data <- datasets[[set_name]]
    do.call(rbind, lapply(binary_vars, function(var) {
      x <- as.character(data[[var]])
      data.frame(
        set = set_name,
        variable = var,
        type = "binary",
        level = "yes",
        rows = nrow(data),
        observed_rows = sum(!is.na(x)),
        missing_rows = sum(is.na(x)),
        mean = NA_real_,
        sd = NA_real_,
        min = NA_real_,
        max = NA_real_,
        share = mean(x == "yes", na.rm = TRUE),
        stringsAsFactors = FALSE
      )
    }))
  }))

  verb_rows <- do.call(rbind, lapply(names(datasets), function(set_name) {
    data <- datasets[[set_name]]
    do.call(rbind, lapply(shared_verbs, function(verb) {
      data.frame(
        set = set_name,
        variable = "Verb",
        type = "factor",
        level = verb,
        rows = nrow(data),
        observed_rows = sum(!is.na(data$Verb)),
        missing_rows = sum(is.na(data$Verb)),
        mean = NA_real_,
        sd = NA_real_,
        min = NA_real_,
        max = NA_real_,
        share = mean(as.character(data$Verb) == verb, na.rm = TRUE),
        stringsAsFactors = FALSE
      )
    }))
  }))

  rbind(numeric_rows, binary_rows, verb_rows)
}

bnc <- canonical_metadata(as.data.frame(lapply(bnc_raw, blank_to_na), stringsAsFactors = FALSE))
bnc$y_np <- as.integer(bnc$Pattern == "VNN")

bnc_core <- make_bnc_core(bnc)
bnc_h <- make_bnc_harmonized(bnc)
core_formula <- y_np ~ Verb + rec_len_words + theme_len_words +
  rec_anim + rec_pron + theme_anim + theme_def + theme_pron
core_complete <- stats::complete.cases(
  bnc_core[, all.vars(core_formula), drop = FALSE]
)

dative <- load_languageR_dative()
validate_languageR_dative(dative)
languageR_h <- make_languageR_harmonized(dative)

metadata_fields <- c(
  "AgeRange",
  "Gender",
  "Level1Dialect",
  "Level2Dialect",
  "Relation",
  "NumSpeakers",
  "SpeakerHighestQual",
  "SpeakerSocGrade"
)

counts <- do.call(rbind, lapply(metadata_fields, function(field) {
  rbind(
    metadata_counts(bnc, core_complete, field, "all_released"),
    metadata_counts(bnc, core_complete, field, "core_complete")
  )
}))
rownames(counts) <- NULL

field_summary_rows <- field_summary(counts)
completeness_metadata_rows <- do.call(rbind, lapply(metadata_fields, function(field) {
  completeness_by_metadata(bnc, core_complete, field)
}))

harmonization_rows <- harmonization_mapping(languageR_h, bnc_h)
distribution_rows <- predictor_distribution_comparison(languageR_h, bnc_h, core_complete)
core_variables <- c(
  "rec_len_words",
  "theme_len_words",
  "rec_anim",
  "rec_pron",
  "theme_anim",
  "theme_def",
  "theme_pron"
)
missing_variable_rows <- missingness_by_variable(bnc_h, core_variables)
missing_verb_pattern_rows <- missingness_by_verb_pattern(bnc_h, core_variables)
reduced_metrics <- reduced_allrow_metrics(languageR_h, bnc_h)

summary_rows <- data.frame(
  metric = c(
    "figshare_article_id",
    "dataset_file_id",
    "dataset_md5",
    "downloaded_md5",
    "released_rows",
    "core_complete_rows",
    "core_incomplete_rows",
    "released_np_rate",
    "core_complete_np_rate",
    "core_incomplete_np_rate",
    "metadata_fields_audited",
    "minimum_rows_for_np_rate"
  ),
  value = c(
    bnc_article_id,
    bnc_dataset_file_id,
    bnc_dataset_file$computed_md5,
    downloaded_md5,
    nrow(bnc),
    sum(core_complete),
    sum(!core_complete),
    mean(bnc$y_np),
    mean(bnc$y_np[core_complete]),
    mean(bnc$y_np[!core_complete]),
    length(metadata_fields),
    25L
  ),
  stringsAsFactors = FALSE
)

utils::write.csv(
  summary_rows,
  file.path(derived_dir, "bnc2014_metadata_scope_summary.csv"),
  row.names = FALSE
)
utils::write.csv(
  counts,
  file.path(derived_dir, "bnc2014_metadata_scope_counts.csv"),
  row.names = FALSE
)
utils::write.csv(
  field_summary_rows,
  file.path(derived_dir, "bnc2014_metadata_scope_field_summary.csv"),
  row.names = FALSE
)
utils::write.csv(
  completeness_metadata_rows,
  file.path(derived_dir, "bnc2014_core_completeness_by_metadata.csv"),
  row.names = FALSE
)
utils::write.csv(
  harmonization_rows,
  file.path(derived_dir, "bnc2014_harmonization_mapping.csv"),
  row.names = FALSE
)
utils::write.csv(
  distribution_rows,
  file.path(derived_dir, "bnc2014_predictor_distribution_comparison.csv"),
  row.names = FALSE
)
utils::write.csv(
  missing_variable_rows,
  file.path(derived_dir, "bnc2014_core_missingness_by_variable.csv"),
  row.names = FALSE
)
utils::write.csv(
  missing_verb_pattern_rows,
  file.path(derived_dir, "bnc2014_core_missingness_by_verb_pattern.csv"),
  row.names = FALSE
)
utils::write.csv(
  reduced_metrics,
  file.path(derived_dir, "bnc2014_reduced_allrow_transport_metrics.csv"),
  row.names = FALSE
)

print(summary_rows, row.names = FALSE)
print(field_summary_rows, row.names = FALSE)
print(distribution_rows, row.names = FALSE)
print(missing_variable_rows, row.names = FALSE)
print(reduced_metrics, row.names = FALSE)
