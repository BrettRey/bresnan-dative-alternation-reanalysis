# Hierarchical varying-verb model for languageR::dative.

source(file.path("analysis", "lib_languageR_dative.R"))

if (!requireNamespace("lme4", quietly = TRUE)) {
  stop("The lme4 package is required for this script.")
}

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

hier_formula <- y_np ~ Modality + SemanticClass + LengthOfRecipient +
  AnimacyOfRec + DefinOfRec + PronomOfRec + LengthOfTheme +
  AnimacyOfTheme + DefinOfTheme + PronomOfTheme + AccessOfRec +
  AccessOfTheme + (1 | Verb)

fit_glmer <- function(model_name, formula, data) {
  warnings <- character()
  messages <- character()
  model <- withCallingHandlers(
    lme4::glmer(
      formula,
      data = data,
      family = stats::binomial(),
      control = lme4::glmerControl(
        optimizer = "bobyqa",
        optCtrl = list(maxfun = 200000)
      )
    ),
    warning = function(w) {
      warnings <<- c(warnings, conditionMessage(w))
      invokeRestart("muffleWarning")
    },
    message = function(m) {
      messages <<- c(messages, conditionMessage(m))
      invokeRestart("muffleMessage")
    }
  )
  all_warnings <- unique(c(warnings, messages))
  list(model = model, warnings = warning_rows(model_name, all_warnings))
}

predict_glmer <- function(fit, newdata) {
  stats::predict(
    fit$model,
    newdata = newdata,
    type = "response",
    allow.new.levels = FALSE
  )
}

evaluate_glmer <- function(model_name, formula, train_data, test_data) {
  fit <- fit_glmer(model_name, formula, train_data)
  p_train <- predict_glmer(fit, train_data)
  p_test <- predict_glmer(fit, test_data)
  train_metrics <- classification_metrics(train_data$y_np, p_train)
  test_metrics <- classification_metrics(test_data$y_np, p_test)

  list(
    model = fit$model,
    p_train = p_train,
    p_test = p_test,
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
      df = attr(stats::logLik(fit$model), "df"),
      aic = stats::AIC(fit$model)
    ),
    warnings = fit$warnings
  )
}

set.seed(20260624)
scrambled_train <- train
scrambled_train$y_np <- sample(scrambled_train$y_np)

set.seed(20260625)
simulate_null <- train
simulate_null$y_np <- stats::rbinom(nrow(train), 1L, mean(train$y_np))
simulate_null_test <- test
simulate_null_test$y_np <- stats::rbinom(nrow(test), 1L, mean(train$y_np))

set.seed(20260626)
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

fits <- list(
  hierarchical_verb_intercept = evaluate_glmer(
    "hierarchical_verb_intercept",
    hier_formula,
    train,
    test
  ),
  scrambled_hierarchical_verb_intercept = evaluate_glmer(
    "scrambled_hierarchical_verb_intercept",
    hier_formula,
    scrambled_train,
    test
  ),
  fake_null_hierarchical = evaluate_glmer(
    "fake_null_hierarchical",
    hier_formula,
    simulate_null,
    simulate_null_test
  ),
  fake_verb_hierarchical = evaluate_glmer(
    "fake_verb_hierarchical",
    hier_formula,
    simulate_verb,
    simulate_verb_test
  )
)

metrics <- do.call(rbind, lapply(fits, `[[`, "metrics"))
warnings <- do.call(rbind, lapply(fits, `[[`, "warnings"))

utils::write.csv(
  metrics,
  file.path(derived_dir, "languageR_dative_hierarchical_metrics.csv"),
  row.names = FALSE
)
utils::write.csv(
  warnings,
  file.path(derived_dir, "languageR_dative_hierarchical_warnings.csv"),
  row.names = FALSE
)

coef_table <- function(model_name, fit) {
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

fixed_effects <- do.call(rbind, Map(coef_table, names(fits), fits))
utils::write.csv(
  fixed_effects,
  file.path(derived_dir, "languageR_dative_hierarchical_fixed_effects.csv"),
  row.names = FALSE
)

diagnostic_rows <- lapply(names(fits), function(name) {
  model <- fits[[name]]$model
  random_sd <- as.numeric(attr(lme4::VarCorr(model)$Verb, "stddev"))
  conv_messages <- model@optinfo$conv$lme4$messages
  if (is.null(conv_messages)) {
    conv_messages <- ""
  } else {
    conv_messages <- paste(conv_messages, collapse = " | ")
  }
  data.frame(
    model = name,
    random_intercept_sd = random_sd,
    singular = lme4::isSingular(model),
    optimizer_message = conv_messages,
    log_lik = as.numeric(stats::logLik(model)),
    aic = stats::AIC(model)
  )
})

diagnostics <- do.call(rbind, diagnostic_rows)
utils::write.csv(
  diagnostics,
  file.path(derived_dir, "languageR_dative_hierarchical_diagnostics.csv"),
  row.names = FALSE
)

random_effects <- lme4::ranef(fits$hierarchical_verb_intercept$model)$Verb
random_effects <- data.frame(
  Verb = rownames(random_effects),
  verb_intercept = random_effects[, "(Intercept)"],
  row.names = NULL
)
random_effects <- random_effects[order(random_effects$verb_intercept), ]
utils::write.csv(
  random_effects,
  file.path(derived_dir, "languageR_dative_hierarchical_verb_effects.csv"),
  row.names = FALSE
)

predictive_interval <- function(group, observed, predicted, model_name, nsim = 500) {
  group <- factor(as.character(group))
  groups <- levels(group)
  sim_mat <- replicate(nsim, {
    sim_y <- stats::rbinom(length(predicted), 1L, clip_prob(predicted))
    tapply(sim_y, group, mean)
  })
  sim_mat <- t(sim_mat)
  observed_rate <- tapply(observed, group, mean)
  predicted_rate <- tapply(predicted, group, mean)
  counts <- tapply(observed, group, length)

  data.frame(
    model = model_name,
    group = groups,
    n = as.integer(counts[groups]),
    observed = as.numeric(observed_rate[groups]),
    predicted = as.numeric(predicted_rate[groups]),
    sim_q05 = apply(sim_mat[, groups, drop = FALSE], 2, stats::quantile, 0.05),
    sim_q50 = apply(sim_mat[, groups, drop = FALSE], 2, stats::quantile, 0.50),
    sim_q95 = apply(sim_mat[, groups, drop = FALSE], 2, stats::quantile, 0.95),
    row.names = NULL
  )
}

hier_fit <- fits$hierarchical_verb_intercept
modality_ppc <- predictive_interval(
  test$Modality,
  test$y_np,
  hier_fit$p_test,
  "hierarchical_verb_intercept"
)

common_verbs <- names(sort(table(test$Verb), decreasing = TRUE))[1:15]
verb_subset <- test$Verb %in% common_verbs
verb_ppc <- predictive_interval(
  test$Verb[verb_subset],
  test$y_np[verb_subset],
  hier_fit$p_test[verb_subset],
  "hierarchical_verb_intercept"
)

utils::write.csv(
  modality_ppc,
  file.path(derived_dir, "languageR_dative_hierarchical_ppc_by_modality.csv"),
  row.names = FALSE
)
utils::write.csv(
  verb_ppc,
  file.path(derived_dir, "languageR_dative_hierarchical_ppc_common_verbs.csv"),
  row.names = FALSE
)

png(
  file.path(figure_dir, "languageR_dative_hierarchical_ppc_by_modality.png"),
  width = 850,
  height = 600
)
plot(
  seq_len(nrow(modality_ppc)),
  modality_ppc$observed,
  ylim = c(0, 1),
  xaxt = "n",
  xlab = "Modality",
  ylab = "NP rate",
  pch = 19
)
axis(1, at = seq_len(nrow(modality_ppc)), labels = modality_ppc$group)
segments(
  seq_len(nrow(modality_ppc)),
  modality_ppc$sim_q05,
  seq_len(nrow(modality_ppc)),
  modality_ppc$sim_q95,
  lwd = 4,
  col = "grey70"
)
points(seq_len(nrow(modality_ppc)), modality_ppc$predicted, pch = 17)
points(seq_len(nrow(modality_ppc)), modality_ppc$observed, pch = 19)
legend(
  "topright",
  legend = c("Observed", "Predicted", "Simulated 90% interval"),
  pch = c(19, 17, NA),
  lwd = c(NA, NA, 4),
  col = c("black", "black", "grey70")
)
invisible(dev.off())

png(
  file.path(figure_dir, "languageR_dative_hierarchical_ppc_common_verbs.png"),
  width = 1100,
  height = 650
)
old_par <- par(mar = c(7, 5, 2, 1))
plot(
  seq_len(nrow(verb_ppc)),
  verb_ppc$observed,
  ylim = c(0, 1),
  xaxt = "n",
  xlab = "",
  ylab = "NP rate",
  pch = 19
)
axis(1, at = seq_len(nrow(verb_ppc)), labels = verb_ppc$group, las = 2)
segments(
  seq_len(nrow(verb_ppc)),
  verb_ppc$sim_q05,
  seq_len(nrow(verb_ppc)),
  verb_ppc$sim_q95,
  lwd = 4,
  col = "grey70"
)
points(seq_len(nrow(verb_ppc)), verb_ppc$predicted, pch = 17)
points(seq_len(nrow(verb_ppc)), verb_ppc$observed, pch = 19)
legend(
  "bottomleft",
  legend = c("Observed", "Predicted", "Simulated 90% interval"),
  pch = c(19, 17, NA),
  lwd = c(NA, NA, 4),
  col = c("black", "black", "grey70")
)
par(old_par)
invisible(dev.off())

print(metrics, row.names = FALSE)
print(diagnostics, row.names = FALSE)
if (nrow(warnings) > 0L) {
  print(warnings, row.names = FALSE)
}
