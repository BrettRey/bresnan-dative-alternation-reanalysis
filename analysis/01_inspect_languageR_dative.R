# Inspect the CRAN languageR::dative dataset without committing raw data.

source(file.path("analysis", "lib_languageR_dative.R"))

dative <- load_languageR_dative()
validate_languageR_dative(dative)

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
    languageR_version,
    languageR_cran_url,
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
