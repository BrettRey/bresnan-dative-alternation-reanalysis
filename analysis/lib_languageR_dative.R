# Shared loader for the CRAN languageR::dative dataset.

languageR_version <- "1.6"
languageR_cran_url <- sprintf(
  "https://cran.r-project.org/src/contrib/languageR_%s.tar.gz",
  languageR_version
)
languageR_archive_url <- sprintf(
  "https://cran.r-project.org/src/contrib/Archive/languageR/languageR_%s.tar.gz",
  languageR_version
)

fetch_languageR_tarball <- function(destfile) {
  ok <- tryCatch({
    utils::download.file(languageR_cran_url, destfile, quiet = TRUE, mode = "wb")
    TRUE
  }, error = function(e) FALSE, warning = function(w) FALSE)

  if (!ok) {
    utils::download.file(
      languageR_archive_url,
      destfile,
      quiet = TRUE,
      mode = "wb"
    )
  }
}

load_languageR_dative <- function() {
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

validate_languageR_dative <- function(dative) {
  stopifnot(
    is.data.frame(dative),
    identical(dim(dative), c(3263L, 15L)),
    "RealizationOfRecipient" %in% names(dative),
    "Modality" %in% names(dative),
    "Verb" %in% names(dative)
  )
}
