# Inspect the Figshare BNC2014 dative dataset without committing raw data.

if (!requireNamespace("jsonlite", quietly = TRUE)) {
  stop("Package 'jsonlite' is required to read Figshare API metadata.")
}

article_id <- "7353164"
dataset_file_id <- 16713434L
article_api <- sprintf("https://api.figshare.com/v2/articles/%s", article_id)
files_api <- sprintf("https://api.figshare.com/v2/articles/%s/files", article_id)
article_url <- sprintf(
  "https://figshare.com/articles/dataset/BNCspoken2014_dative_dataset_v1_csv/%s",
  article_id
)
article_doi <- "10.5334/johd.11"

article <- jsonlite::fromJSON(article_api)
files <- jsonlite::fromJSON(files_api)

dataset_file <- files[files$id == dataset_file_id, , drop = FALSE]
if (nrow(dataset_file) != 1L) {
  stop("Could not uniquely identify the BNC2014 CSV in Figshare file metadata.")
}

dataset_url <- dataset_file$download_url
dataset_md5 <- dataset_file$computed_md5

csv_path <- tempfile(fileext = ".csv")
on.exit(unlink(csv_path), add = TRUE)
utils::download.file(dataset_url, csv_path, quiet = TRUE, mode = "wb")

downloaded_md5 <- unname(tools::md5sum(csv_path))
if (!identical(downloaded_md5, dataset_md5)) {
  stop(sprintf(
    "Downloaded CSV MD5 mismatch: expected %s, got %s",
    dataset_md5,
    downloaded_md5
  ))
}

csv_bytes <- readBin(csv_path, what = "raw", n = file.info(csv_path)$size)
newline_count <- sum(csv_bytes == as.raw(0x0a))
terminal_newline <- length(csv_bytes) > 0L &&
  identical(tail(csv_bytes, 1L), as.raw(0x0a))
logical_text_lines <- newline_count + if (terminal_newline) 0L else 1L

bnc <- utils::read.csv(
  csv_path,
  stringsAsFactors = FALSE,
  check.names = FALSE,
  fileEncoding = "UTF-8-BOM"
)

if (nrow(bnc) != 1839L || ncol(bnc) != 44L) {
  stop(sprintf(
    "Unexpected BNC2014 dimensions: got %d rows and %d columns.",
    nrow(bnc),
    ncol(bnc)
  ))
}

if (!identical(sort(unique(bnc$Pattern)), c("VNN", "VNPP"))) {
  stop("Unexpected BNC2014 Pattern levels.")
}

derived_dir <- file.path("data", "derived")
dir.create(derived_dir, recursive = TRUE, showWarnings = FALSE)

blank_to_na <- function(x) {
  if (!is.character(x)) {
    return(x)
  }

  y <- trimws(x)
  y[y == ""] <- NA_character_
  y
}

bnc_clean <- as.data.frame(lapply(bnc, blank_to_na), stringsAsFactors = FALSE)

count_value <- function(x, level) {
  tab <- table(x, useNA = "no")
  if (level %in% names(tab)) {
    unname(tab[[level]])
  } else {
    0L
  }
}

summary_rows <- data.frame(
  metric = c(
    "figshare_article_id",
    "figshare_url",
    "dataset_title",
    "dataset_doi",
    "article_doi",
    "figshare_version",
    "figshare_published_date",
    "license",
    "license_url",
    "dataset_file_id",
    "dataset_file_name",
    "dataset_download_url",
    "dataset_file_size_bytes",
    "dataset_md5",
    "downloaded_md5",
    "raw_newline_count",
    "raw_terminal_newline",
    "logical_text_lines",
    "parsed_data_rows",
    "columns",
    "verb_levels",
    "pattern_VNN",
    "pattern_VNPP"
  ),
  value = c(
    article_id,
    article_url,
    article$title,
    article$doi,
    article_doi,
    article$version,
    article$published_date,
    article$license$name,
    article$license$url,
    dataset_file$id,
    dataset_file$name,
    dataset_url,
    dataset_file$size,
    dataset_md5,
    downloaded_md5,
    newline_count,
    terminal_newline,
    logical_text_lines,
    nrow(bnc),
    ncol(bnc),
    length(unique(bnc_clean$Verb)),
    count_value(bnc_clean$Pattern, "VNN"),
    count_value(bnc_clean$Pattern, "VNPP")
  ),
  stringsAsFactors = FALSE
)

column_rows <- data.frame(
  column = names(bnc_clean),
  class = vapply(bnc_clean, function(x) class(x)[1], character(1)),
  n_missing = vapply(bnc_clean, function(x) sum(is.na(x)), integer(1)),
  n_distinct = vapply(
    bnc_clean,
    function(x) length(unique(x[!is.na(x)])),
    integer(1)
  ),
  stringsAsFactors = FALSE
)

key_columns <- c(
  "Verb",
  "VerbSemTag",
  "Pattern",
  "RecPrn",
  "AnimateRec",
  "ThemePrn",
  "DefTheme",
  "AnimateTheme",
  "NumSpeakers",
  "Relation",
  "AgeRange",
  "Gender",
  "Nationality",
  "L1",
  "LingOrigin",
  "Level1Dialect",
  "Level2Dialect",
  "SpeakerHighestQual",
  "SpeakerSocGrade"
)

count_levels <- function(data, column) {
  counts <- sort(table(data[[column]], useNA = "ifany"), decreasing = TRUE)
  data.frame(
    column = column,
    value = names(counts),
    n = as.integer(counts),
    stringsAsFactors = FALSE
  )
}

key_count_rows <- do.call(
  rbind,
  lapply(key_columns, function(column) count_levels(bnc_clean, column))
)
rownames(key_count_rows) <- NULL

verb_pattern_counts <- as.data.frame.matrix(table(bnc_clean$Verb, bnc_clean$Pattern))
verb_pattern_counts <- data.frame(
  Verb = rownames(verb_pattern_counts),
  verb_pattern_counts,
  row.names = NULL,
  check.names = FALSE
)
verb_pattern_counts$total <- rowSums(verb_pattern_counts[c("VNN", "VNPP")])
verb_pattern_counts <- verb_pattern_counts[
  order(verb_pattern_counts$total, decreasing = TRUE),
]

source_files <- files[, c(
  "id",
  "name",
  "size",
  "mimetype",
  "download_url",
  "supplied_md5",
  "computed_md5"
)]

utils::write.csv(
  summary_rows,
  file.path(derived_dir, "bnc2014_dative_summary.csv"),
  row.names = FALSE
)
utils::write.csv(
  source_files,
  file.path(derived_dir, "bnc2014_dative_source_files.csv"),
  row.names = FALSE
)
utils::write.csv(
  column_rows,
  file.path(derived_dir, "bnc2014_dative_columns.csv"),
  row.names = FALSE
)
utils::write.csv(
  key_count_rows,
  file.path(derived_dir, "bnc2014_dative_key_counts.csv"),
  row.names = FALSE
)
utils::write.csv(
  verb_pattern_counts,
  file.path(derived_dir, "bnc2014_dative_verb_pattern_counts.csv"),
  row.names = FALSE
)

print(summary_rows, row.names = FALSE)
print(column_rows, row.names = FALSE)
print(verb_pattern_counts, row.names = FALSE)
