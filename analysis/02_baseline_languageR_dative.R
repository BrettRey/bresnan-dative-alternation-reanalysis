# Baseline and null models for languageR::dative.

source(file.path("analysis", "lib_languageR_dative.R"))

set.seed(20260623)

derived_dir <- file.path("data", "derived")
figure_dir <- file.path(derived_dir, "figures")
dir.create(derived_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(figure_dir, recursive = TRUE, showWarnings = FALSE)

dative <- load_languageR_dative()
model_data <- prepare_languageR_dative_model_data(dative)
dative <- model_data$data
train <- model_data$train
test <- model_data$test

split_rows <- data.frame(
  row_id = seq_len(nrow(dative)),
  split = ifelse(seq_len(nrow(dative)) %in% model_data$train_idx, "train", "test")
)
utils::write.csv(
  split_rows,
  file.path(derived_dir, "languageR_dative_split.csv"),
  row.names = FALSE
)

fit_glm <- function(formula, data) {
  warnings <- character()
  model <- withCallingHandlers(
    stats::glm(formula, data = data, family = stats::binomial()),
    warning = function(w) {
      warnings <<- c(warnings, conditionMessage(w))
      invokeRestart("muffleWarning")
    }
  )
  list(model = model, warnings = unique(warnings))
}

predict_glm <- function(fit, newdata) {
  stats::predict(fit$model, newdata = newdata, type = "response")
}

model_formulas <- list(
  marginal = NULL,
  modality_only = y_np ~ Modality,
  length_only = y_np ~ LengthOfRecipient + LengthOfTheme,
  verb_only = y_np ~ Verb,
  nonverb_main = y_np ~ Modality + SemanticClass + LengthOfRecipient +
    AnimacyOfRec + DefinOfRec + PronomOfRec + LengthOfTheme +
    AnimacyOfTheme + DefinOfTheme + PronomOfTheme + AccessOfRec +
    AccessOfTheme,
  fixed_verb_full = y_np ~ Verb + Modality + SemanticClass +
    LengthOfRecipient + AnimacyOfRec + DefinOfRec + PronomOfRec +
    LengthOfTheme + AnimacyOfTheme + DefinOfTheme + PronomOfTheme +
    AccessOfRec + AccessOfTheme,
  nonverb_plus_noise = y_np ~ Modality + SemanticClass + LengthOfRecipient +
    AnimacyOfRec + DefinOfRec + PronomOfRec + LengthOfTheme +
    AnimacyOfTheme + DefinOfTheme + PronomOfTheme + AccessOfRec +
    AccessOfTheme + noise_z
)

evaluate_model <- function(model_name, formula, train_data, test_data) {
  if (is.null(formula)) {
    p_train <- rep(mean(train_data$y_np), nrow(train_data))
    p_test <- rep(mean(train_data$y_np), nrow(test_data))
    train_metrics <- classification_metrics(train_data$y_np, p_train)
    test_metrics <- classification_metrics(test_data$y_np, p_test)
    return(list(
      model = NULL,
      metrics = data.frame(
        model = model_name,
        train_rows = nrow(train_data),
        test_rows = nrow(test_data),
        train_log_loss = train_metrics$log_loss,
        train_brier = train_metrics$brier,
        train_accuracy = train_metrics$accuracy,
        train_auc = train_metrics$auc,
        test_log_loss = test_metrics$log_loss,
        test_brier = test_metrics$brier,
        test_accuracy = test_metrics$accuracy,
        test_auc = test_metrics$auc,
        df = 1L,
        aic = NA_real_
      ),
      warnings = warning_rows(model_name, character())
    ))
  }

  fit <- fit_glm(formula, train_data)
  p_train <- predict_glm(fit, train_data)
  p_test <- predict_glm(fit, test_data)
  train_metrics <- classification_metrics(train_data$y_np, p_train)
  test_metrics <- classification_metrics(test_data$y_np, p_test)

  list(
    model = fit$model,
    metrics = data.frame(
      model = model_name,
      train_rows = nrow(train_data),
      test_rows = nrow(test_data),
      train_log_loss = train_metrics$log_loss,
      train_brier = train_metrics$brier,
      train_accuracy = train_metrics$accuracy,
      train_auc = train_metrics$auc,
      test_log_loss = test_metrics$log_loss,
      test_brier = test_metrics$brier,
      test_accuracy = test_metrics$accuracy,
      test_auc = test_metrics$auc,
      df = length(stats::coef(fit$model)),
      aic = stats::AIC(fit$model)
    ),
    warnings = warning_rows(model_name, fit$warnings)
  )
}

fits <- lapply(names(model_formulas), function(name) {
  evaluate_model(name, model_formulas[[name]], train, test)
})
names(fits) <- names(model_formulas)

scrambled_train <- train
scrambled_train$y_np <- sample(scrambled_train$y_np)
scrambled_fits <- lapply(c("nonverb_main", "fixed_verb_full"), function(name) {
  result <- evaluate_model(
    paste0("scrambled_", name),
    model_formulas[[name]],
    scrambled_train,
    test
  )
  result
})
names(scrambled_fits) <- paste0("scrambled_", c("nonverb_main", "fixed_verb_full"))

simulate_null <- train
simulate_null$y_np <- stats::rbinom(nrow(train), 1L, mean(train$y_np))
simulate_null_test <- test
simulate_null_test$y_np <- stats::rbinom(nrow(test), 1L, mean(train$y_np))

verb_effects <- stats::rnorm(nlevels(dative$Verb), sd = 1.0)
names(verb_effects) <- levels(dative$Verb)
base_logit <- stats::qlogis(mean(train$y_np))
simulate_verb <- train
simulate_verb$p <- stats::plogis(base_logit + verb_effects[as.character(train$Verb)])
simulate_verb$y_np <- stats::rbinom(nrow(train), 1L, simulate_verb$p)
simulate_verb_test <- test
simulate_verb_test$p <- stats::plogis(
  base_logit + verb_effects[as.character(test$Verb)]
)
simulate_verb_test$y_np <- stats::rbinom(nrow(test), 1L, simulate_verb_test$p)

fake_fits <- list(
  fake_null_marginal = evaluate_model(
    "fake_null_marginal",
    NULL,
    simulate_null,
    simulate_null_test
  ),
  fake_null_nonverb = evaluate_model(
    "fake_null_nonverb",
    model_formulas$nonverb_main,
    simulate_null,
    simulate_null_test
  ),
  fake_verb_marginal = evaluate_model(
    "fake_verb_marginal",
    NULL,
    simulate_verb,
    simulate_verb_test
  ),
  fake_verb_verb_only = evaluate_model(
    "fake_verb_verb_only",
    model_formulas$verb_only,
    simulate_verb,
    simulate_verb_test
  )
)

all_fits <- c(fits, scrambled_fits, fake_fits)

metrics <- do.call(rbind, lapply(all_fits, `[[`, "metrics"))
warnings <- do.call(rbind, lapply(all_fits, `[[`, "warnings"))

utils::write.csv(
  metrics,
  file.path(derived_dir, "languageR_dative_baseline_metrics.csv"),
  row.names = FALSE
)
utils::write.csv(
  warnings,
  file.path(derived_dir, "languageR_dative_model_warnings.csv"),
  row.names = FALSE
)

coef_table <- function(model_name, fit) {
  if (is.null(fit$model)) {
    return(data.frame())
  }
  coef_summary <- summary(fit$model)$coefficients
  data.frame(
    model = model_name,
    term = rownames(coef_summary),
    estimate = coef_summary[, "Estimate"],
    std_error = coef_summary[, "Std. Error"],
    z_value = coef_summary[, "z value"],
    p_value = coef_summary[, "Pr(>|z|)"],
    row.names = NULL
  )
}

coefficients <- do.call(
  rbind,
  Map(coef_table, names(fits), fits)
)
utils::write.csv(
  coefficients,
  file.path(derived_dir, "languageR_dative_model_coefficients.csv"),
  row.names = FALSE
)

nonverb_pred <- predict_glm(fits$nonverb_main, test)
fixed_verb_pred <- predict_glm(fits$fixed_verb_full, test)

modality_calibration <- rbind(
  calibration_by_group(test$Modality, test$y_np, "nonverb_main", nonverb_pred),
  calibration_by_group(test$Modality, test$y_np, "fixed_verb_full", fixed_verb_pred)
)

common_verbs <- names(sort(table(test$Verb), decreasing = TRUE))[1:15]
verb_subset <- test$Verb %in% common_verbs
verb_calibration <- rbind(
  calibration_by_group(
    test$Verb[verb_subset],
    test$y_np[verb_subset],
    "nonverb_main",
    nonverb_pred[verb_subset]
  ),
  calibration_by_group(
    test$Verb[verb_subset],
    test$y_np[verb_subset],
    "fixed_verb_full",
    fixed_verb_pred[verb_subset]
  )
)

utils::write.csv(
  modality_calibration,
  file.path(derived_dir, "languageR_dative_calibration_by_modality.csv"),
  row.names = FALSE
)
utils::write.csv(
  verb_calibration,
  file.path(derived_dir, "languageR_dative_calibration_common_verbs.csv"),
  row.names = FALSE
)

png(
  file.path(figure_dir, "languageR_dative_calibration_by_modality.png"),
  width = 900,
  height = 600
)
barplot(
  t(as.matrix(modality_calibration[, c("observed", "predicted")])),
  beside = TRUE,
  names.arg = paste(modality_calibration$model, modality_calibration$group, sep = "\n"),
  ylim = c(0, 1),
  ylab = "NP rate",
  col = c("grey30", "grey75"),
  las = 2
)
legend("topright", fill = c("grey30", "grey75"), legend = c("Observed", "Predicted"))
invisible(dev.off())

png(
  file.path(figure_dir, "languageR_dative_common_verb_calibration.png"),
  width = 1200,
  height = 650
)
old_par <- par(mfrow = c(1, 2), mar = c(5, 5, 3, 1))
for (model_name in c("nonverb_main", "fixed_verb_full")) {
  model_rows <- verb_calibration[verb_calibration$model == model_name, ]
  plot(
    model_rows$observed,
    model_rows$predicted,
    pch = 19,
    xlim = c(0, 1),
    ylim = c(0, 1),
    xlab = "Observed NP rate",
    ylab = "Predicted NP rate",
    main = model_name
  )
  abline(0, 1, col = "grey60", lty = 2)
  text(
    model_rows$observed,
    model_rows$predicted,
    labels = model_rows$group,
    pos = 3,
    cex = 0.7,
    xpd = NA
  )
}
par(old_par)
invisible(dev.off())

print(metrics, row.names = FALSE)
if (nrow(warnings) > 0L) {
  print(warnings, row.names = FALSE)
}
