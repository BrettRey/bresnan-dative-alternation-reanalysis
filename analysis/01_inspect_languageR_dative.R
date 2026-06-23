# Inspect the CRAN languageR::dative dataset without committing raw data.

package_version <- "1.6"
cran_url <- sprintf(
  "https://cran.r-project.org/src/contrib/languageR_%s.tar.gz",
  package_version
)
archive_url <- sprintf(
  "https://cran.r-project.org/src/contrib/Archive/languageR/languageR_%s.tar.gz",
  package_version
)

fetch_languageR_tarball <- function(destfile) {
  ok <- tryCatch({
    utils::download.file(cran_url, destfile, quiet = TRUE, mode = "wb")
    TRUE
  }, error = function(e) FALSE, warning = function(w) FALSE)

  if (!ok) {
    utils::download.file(archive_url, destfile, quiet = TRUE, mode = "wb")
  }
}

load_dative <- function() {
  tarball <- tempfile(fileext = ".tar.gz")
  unpack_dir <- tempfile()
  dir.create(unpack_dir)

  fetch_languageR_tarball(tarball)
  utils::untar(tarball, exdir = unpack_dir)

  data_env <- new.env(parent = emptyenv())
  data_path <- file.path(unpack_dir, "languageR", "data", "dative.rda")
  load(data_path, envir = data_env)
  data_env$dative
}

dative <- load_dative()

stopifnot(
  is.data.frame(dative),
  identical(dim(dative), c(3263L, 15L)),
  "RealizationOfRecipient" %in% names(dative),
  "Modality" %in% names(dative),
  "Verb" %in% names(dative)
)

derived_dir <- file.path("data", "derived")
dir.create(derived_dir, recursive = TRUE, showWarnings = FALSE)

summary_rows <- data.frame(
  metric = c(
    "languageR_version",
    "source_url",
    "rows",
    "columns",
    "verb_levels",
    "outcome_NP",
    "outcome_PP",
    "modality_spoken",
    "modality_written"
  ),
  value = c(
    package_version,
    cran_url,
    nrow(dative),
    ncol(dative),
    length(levels(dative$Verb)),
    unname(table(dative$RealizationOfRecipient)["NP"]),
    unname(table(dative$RealizationOfRecipient)["PP"]),
    unname(table(dative$Modality)["spoken"]),
    unname(table(dative$Modality)["written"])
  )
)

column_rows <- data.frame(
  column = names(dative),
  class = vapply(dative, function(x) class(x)[1], character(1)),
  n_missing = vapply(dative, function(x) sum(is.na(x)), integer(1)),
  n_distinct = vapply(dative, function(x) length(unique(x)), integer(1)),
  stringsAsFactors = FALSE
)

utils::write.csv(
  summary_rows,
  file.path(derived_dir, "languageR_dative_summary.csv"),
  row.names = FALSE
)
utils::write.csv(
  column_rows,
  file.path(derived_dir, "languageR_dative_columns.csv"),
  row.names = FALSE
)

print(summary_rows, row.names = FALSE)
print(column_rows, row.names = FALSE)
