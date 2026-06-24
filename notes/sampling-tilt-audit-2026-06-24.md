# Sampling-Tilt Audit

## Short Answer

Yes: there is a real sampling-scope tilt in the current dative reanalysis. It is not fatal, but it should be made explicit before the paper is treated as done.

The core empirical result still looks usable: the transported `languageR` profile predicts BNC2014 substantially better than a marginal baseline and collapses against a scrambled outcome. The problem is narrower: the headline transport result is tested on a favourable slice of the alternation, and the current complete-case evaluation drops rows in a direction that can make the task easier.

## What Is Tilting

### 1. Six-Verb Overlap

BNC2014 has only six verbs: `give`, `send`, `show`, `sell`, `offer`, and `lend`. Those are not a random sample of the dative alternation. They are the high-frequency, canonical core.

Quick check against `languageR::dative`:

| Comparison | Result |
|---|---:|
| Full `languageR` rows | 3,263 |
| Rows using the six BNC verbs | 2,201 / 3,263 = 67.5% |
| Spoken `languageR` rows | 2,360 |
| Spoken rows using the six BNC verbs | 1,564 / 2,360 = 66.3% |
| NP rate, spoken shared verbs | 0.811 |
| NP rate, spoken non-shared verbs | 0.741 |

Interpretation: the transport test is mostly a test on the canonical high-frequency zone where a stable conditioning profile is most likely. That is fine if the claim is scoped that way; it is too strong if the prose implies general transport across the whole alternation.

### 2. Complete-Case Filtering In BNC2014

The current core BNC transport model evaluates only complete rows for the harmonized predictors.

| BNC2014 set | Rows | NP rate |
|---|---:|---:|
| All released BNC dative rows | 1,839 | 0.802 |
| Complete rows used by core transport | 1,621 | 0.819 |
| Dropped incomplete rows | 218 | 0.670 |

The dropped rows are PP-heavier than the retained rows. That means complete-case filtering is not ignorable for the headline metrics.

A quick imputation sensitivity gives the right level of caution:

| Evaluation | Rows | Log loss | AUC | Accuracy |
|---|---:|---:|---:|---:|
| Core complete-case result | 1,621 | 0.308 | 0.906 | 0.859 |
| All rows, median/mode imputation | 1,839 | 0.362 | 0.872 | 0.846 |
| All rows, median/`no` imputation | 1,839 | 0.312 | 0.911 | 0.858 |
| All rows, median/`yes` imputation | 1,839 | 0.408 | 0.856 | 0.817 |

Interpretation: the direction of the result survives, but the exact strength of the transport claim is sensitive to how missing BNC predictors are handled. The paper should not present 0.308 / 0.906 as if it were an all-row BNC2014 result.

### 3. Bootstrap Scope

The current percentile bootstrap resamples BNC test rows. That is useful, but it only measures row-level test-set variability around the chosen split. It does not include uncertainty from:

- selecting the six shared verbs;
- excluding incomplete BNC rows;
- corpus design and annotation differences;
- speaker/conversation clustering;
- the missing broader opportunity-set denominator.

So the CIs are valid as a narrow diagnostic, not as full uncertainty on the transport claim.

## Recommended Fix

I would fix the manuscript before submitting or circulating as final.

1. Rename the headline table labels so they say `BNC2014 complete-case` where appropriate.
2. Add a short sampling-scope paragraph before the transport results:
   - BNC2014 tests only six high-frequency shared verbs.
   - The core model evaluates 1,621 complete rows out of 1,839 released BNC rows.
   - Dropped rows are PP-heavier, so complete-case metrics are favourable rather than neutral.
3. Add a compact sensitivity sentence or small table:
   - complete-case log loss/AUC: 0.308 / 0.906;
   - median/mode all-row sensitivity: 0.362 / 0.872;
   - result direction survives, but strength is scope-bound.
4. Tighten the conclusion:
   - the paper establishes transport in the high-frequency attested-token core;
   - it does not establish transport for marginal dative verbs or all transfer-event opportunities.
5. Optionally add `analysis/07_sampling_tilt_sensitivity.R` to make the sensitivity reproducible and write a small derived CSV.

## Bottom Line For The Paper

Do not abandon the result. Re-scope it.

The honest claim is:

> A production-choice profile trained on the canonical `languageR` dative core partly transports to a later British spoken corpus over the six shared high-frequency verbs. That is evidence of projectibility within the attested-token core, but not evidence that the model spans marginal verbs, non-alternating transfer-event expressions, or grammatical-but-unattested alternatives.

That version is stronger because it turns the sampling concern into the paper's methodological point: corpus models are informative only relative to their opportunity set.
