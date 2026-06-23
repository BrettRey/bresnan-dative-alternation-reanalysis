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

prepare_languageR_dative_model_data <- function(dative, seed = 20260623) {
  validate_languageR_dative(dative)

  set.seed(seed)
  dative$y_np <- as.integer(dative$RealizationOfRecipient == "NP")
  dative$noise_z <- stats::rnorm(nrow(dative))

  train_indices_by_verb <- tapply(seq_len(nrow(dative)), dative$Verb, function(idx) {
    if (length(idx) == 1L) {
      idx
    } else {
      sample(idx, ceiling(0.8 * length(idx)))
    }
  })

  train_idx <- sort(unlist(train_indices_by_verb, use.names = FALSE))
  test_idx <- setdiff(seq_len(nrow(dative)), train_idx)

  list(
    data = dative,
    train_idx = train_idx,
    test_idx = test_idx,
    train = droplevels(dative[train_idx, ]),
    test = droplevels(dative[test_idx, ])
  )
}

clip_prob <- function(p) {
  pmin(pmax(p, 1e-6), 1 - 1e-6)
}

auc_score <- function(y, p) {
  if (length(unique(y)) < 2L) {
    return(NA_real_)
  }
  ranks <- rank(p, ties.method = "average")
  n_pos <- sum(y == 1L)
  n_neg <- sum(y == 0L)
  (sum(ranks[y == 1L]) - n_pos * (n_pos + 1) / 2) / (n_pos * n_neg)
}

classification_metrics <- function(y, p) {
  p <- clip_prob(p)
  data.frame(
    log_loss = -mean(y * log(p) + (1 - y) * log(1 - p)),
    brier = mean((p - y)^2),
    accuracy = mean(as.integer(p >= 0.5) == y),
    auc = auc_score(y, p)
  )
}

warning_rows <- function(model_name, warnings) {
  if (length(warnings) == 0L) {
    return(data.frame(model = character(), warning = character()))
  }
  data.frame(model = model_name, warning = warnings, stringsAsFactors = FALSE)
}

calibration_by_group <- function(group, observed, model_name, pred) {
  rows <- data.frame(
    group = as.character(group),
    observed = observed,
    predicted = pred
  )
  rates <- stats::aggregate(cbind(observed, predicted) ~ group, rows, mean)
  counts <- stats::aggregate(observed ~ group, rows, length)
  names(counts)[2] <- "n"
  merged <- merge(counts, rates, by = "group")
  merged$model <- model_name
  merged[, c("model", "group", "n", "observed", "predicted")]
}
