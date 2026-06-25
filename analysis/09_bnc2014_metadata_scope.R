# Descriptive metadata-scope audit for the BNC2014 dative transport target.

if (!requireNamespace("jsonlite", quietly = TRUE)) {
  stop("Package 'jsonlite' is required to read Figshare API metadata.")
}

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
    levels = c("no", "yes")
  )
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
    Verb = factor(bnc$Verb, levels = c("give", "send", "show", "sell", "offer", "lend")),
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

bnc <- canonical_metadata(as.data.frame(lapply(bnc_raw, blank_to_na), stringsAsFactors = FALSE))
bnc$y_np <- as.integer(bnc$Pattern == "VNN")

bnc_core <- make_bnc_core(bnc)
core_formula <- y_np ~ Verb + rec_len_words + theme_len_words +
  rec_anim + rec_pron + theme_anim + theme_def + theme_pron
core_complete <- stats::complete.cases(
  bnc_core[, all.vars(core_formula), drop = FALSE]
)

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

print(summary_rows, row.names = FALSE)
print(field_summary_rows, row.names = FALSE)
