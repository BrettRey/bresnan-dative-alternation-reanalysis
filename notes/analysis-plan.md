# Analysis Plan

This note fixes the first modelling commitments before fitting baseline models.
The aim is to avoid post-hoc interpretation of reasonable but consequential
choices.

## 1. Target

Primary data source: `languageR::dative`, fetched from the CRAN `languageR` 1.6
source tarball by `analysis/01_inspect_languageR_dative.R`.

Primary outcome: `RealizationOfRecipient`, coded as NP versus PP.

Primary empirical question: how well do independently motivated production
predictors explain the choice between double-object and prepositional-dative
realizations?

Bridge question: what, if anything, does that production-choice profile license
us to infer about grammatical possibility?

The bridge is not automatic. A production pattern is evidence about grammatical
possibility only when the model shows stable conditioned availability rather
than mere marginal frequency, lexical accident, or corpus-specific imbalance.

## 2. Primary Predictors

The first production-choice model will use the documented predictors in
`languageR::dative`:

- Modality
- Verb
- SemanticClass
- LengthOfRecipient
- AnimacyOfRec
- DefinOfRec
- PronomOfRec
- LengthOfTheme
- AnimacyOfTheme
- DefinOfTheme
- PronomOfTheme
- AccessOfRec
- AccessOfTheme

Speaker is not a primary predictor in the full dataset because it is unavailable
for the written rows. Speaker-specific checks may be run on the spoken subset
only, and must be labelled as subset analyses.

## 3. Baseline Model Sequence

Run models in this order:

1. Marginal-rate model: predict the observed NP/PP base rate.
2. Simple logistic regression with the non-verb predictors.
3. Verb-only model.
4. Logistic regression with non-verb predictors plus fixed verb effects.
5. Hierarchical logistic model with varying intercepts for verb.
6. If justified by diagnostics, hierarchical model with selected varying slopes
   for the strongest theoretically motivated predictors.

The primary comparison is not "significant versus non-significant". It is
whether richer structure materially improves out-of-sample prediction, model
calibration, and interpretation of conditioned availability.

## 4. Null Comparisons

Use multiple nulls because each answers a different question.

### Marginal Null

Predict the overall NP/PP rate for every observation. This is the minimum floor:
because NP is the majority outcome, a 50/50 null is too weak to be informative.

### Structured Baseline Nulls

Fit verb-only, modality-only, and length-only baselines. These test whether the
full model adds information beyond obvious structure.

### Scrambled-Label Null

Shuffle `RealizationOfRecipient` and rerun the same modelling pipeline. The
default shuffle should preserve the marginal NP/PP rate. Additional shuffles may
preserve modality or verb strata when the question is whether the model is
finding signal beyond those structures.

### Noise-Predictor Null

Add one or more random predictors with no linguistic interpretation. These
should not survive regularization, improve held-out performance, or receive
substantive interpretation.

### Fake-Data Recovery Check

Simulate data from a known simple process and verify that the chosen model
recovers the intended structure. Include at least one simulation with no
predictive signal and one with a known verb-level effect.

## 5. Model Checks

For every fitted model, check:

- outcome calibration against observed NP/PP rates
- predicted versus observed rates by modality
- predicted versus observed rates for common verbs
- behavior on rare verbs
- length-effect shape
- residual or posterior predictive patterns that reveal systematic misses

For Bayesian models, run prior predictive checks before fitting and posterior
predictive checks after fitting. For frequentist models, use simulation from the
fitted model as an analogous generative check.

## 6. Robustness Grid

Predeclare the first robustness grid:

- with versus without verb effects
- fixed verb effects versus varying verb intercepts
- all rows versus spoken-only subset
- raw lengths versus transformed/scaled lengths
- complete-predictor model versus reduced theoretically motivated model
- random train/test split versus grouped or stratified cross-validation

The point of the grid is to identify which conclusions are stable across
reasonable analysis choices, not to hunt for the strongest result.

## 7. Falsification Conditions

The production reanalysis does not support the paper's intended claim if:

- the full model barely improves on the marginal null
- apparent effects disappear under scrambled-label or fake-data checks
- the conclusions depend on an arbitrary coding or subset choice
- verb effects dominate so strongly that broader grammatical conditioning is not
  interpretable
- model checks show systematic failure on the very regions used to argue for
  grammatical possibility

If these conditions hold, the paper should pivot from "modern modelling confirms
the classic claim" to a more modest claim about what production evidence can and
cannot establish.

## 8. Cross-Corpus and Acceptability Timing

BNC2014 and DAIS should not enter the first modelling stage.

BNC2014 becomes relevant after the `languageR::dative` model has a stable
conditioning profile. It should be treated as a transport/harmonization problem,
not as a direct replication.

DAIS becomes relevant only after the production-choice story is clear. It tests
whether preference/acceptability patterns align with production conditioning; it
does not measure production frequency.

## 9. Completed `languageR` Implementation

The initial `languageR::dative` implementation now exists:

1. `analysis/01_inspect_languageR_dative.R` inspects the CRAN package data.
2. `analysis/02_baseline_languageR_dative.R` fits marginal, structured,
   scrambled-label, noise-predictor, and fake-data baselines.
3. `analysis/03_hierarchical_languageR_dative.R` fits a varying-verb-intercept
   model and predictive checks.

The result is a robustness result: modern modelling and partial pooling preserve
the original production-choice conclusion. Further `languageR` refinement is not
the next contribution.

## 10. Completed BNC2014 Gate And Transport

The BNC2014 transport gate and first transport model now exist:

1. `analysis/04_inspect_bnc2014_dative.R`: fetch or stream the BNC2014 CSV,
   verify row count, schema, missingness, and variable levels, and write small
   derived metadata tables.
2. `notes/bnc2014-harmonization.md`: map BNC2014 fields to the `languageR`
   predictors and classify each as direct, proxy, unavailable, or incompatible.
3. `notes/production-possibility-gap.md`: state what production data can and
   cannot show about grammatical possibility, and what DAIS would add.
4. `analysis/05_bnc2014_transport.R`: fit the first documented cross-corpus
   transport checks from spoken six-verb `languageR` data to harmonized
   BNC2014.
5. `notes/bnc2014-transport-results.md`: summarize the positive but partial
   transport result.

The next implementation step is manuscript prose for the `languageR` robustness
and BNC2014 transport sections.
