# BNC2014 Transport Results

**Superseded 2026-06-26 for manuscript comparison purposes.** The first-pass
transport metrics below are still reproducible from `analysis/05`, but the
native-vs-transport comparison used different evaluation samples. Current
manuscript claims should use `analysis/10_bnc2014_paired_transport_cv.R`, which
scores source-trained and BNC2014-native out-of-fold predictions on the same
1,621 complete-case rows.

Purpose: record the first cross-corpus transport result before manuscript prose
turns it into an argument.

## Model Scope

`analysis/05_bnc2014_transport.R` follows the harmonization gate in
`notes/bnc2014-harmonization.md`.

Primary training data:

- `languageR::dative`
- spoken rows only
- restricted to the six BNC2014 verbs: `give`, `send`, `show`, `sell`,
  `offer`, `lend`
- 1,564 complete training rows

Primary BNC2014 evaluation data:

- 1,621 complete rows out of 1,839 parsed rows
- missingness comes mainly from recipient/theme phrase fields and
  pronominality fields
- no raw BNC CSV or raw phrase table is committed

The core transport formula uses verb, recipient/theme word-length proxies,
recipient/theme animacy, recipient/theme pronominality, and theme definiteness.
A second formula adds recipient definiteness as a labelled BNC regex proxy.

## Headline Metrics

| Model | Train | Test | Log loss | AUC |
|---|---|---|---:|---:|
| languageR marginal | languageR spoken shared | BNC2014 | 0.473 | 0.500 |
| languageR core transport | languageR spoken shared | BNC2014 | 0.308 | 0.906 |
| languageR core transport, scrambled BNC outcome | languageR spoken shared | scrambled BNC2014 | 0.885 | 0.515 |
| BNC2014 marginal holdout | BNC2014 | BNC2014 | 0.481 | 0.500 |
| BNC2014 native core holdout | BNC2014 | BNC2014 | 0.202 | 0.960 |
| BNC2014 native core, scrambled training labels | scrambled BNC2014 | BNC2014 | 0.495 | 0.440 |

The result is a real transport result, not just another `languageR` refit. The
core production profile trained on spoken `languageR` data predicts BNC2014 much
better than the marginal baseline, and it collapses against a scrambled BNC
outcome.

## What Travels

The core direction of several effects is stable across the languageR-trained
and BNC-native fits:

- recipient length is negative for NP realization;
- theme length is positive for NP realization;
- recipient pronominality is strongly positive;
- theme pronominality is strongly negative;
- `sell` is strongly less NP-like than `give`;
- `send` is less NP-like than `give`;
- theme animacy is negative, though sparse in BNC2014.

This is the first evidence that Bresnan et al.'s production-conditioning profile
is not merely an artefact of one packaged dataset.

## What Does Not Simply Travel

The BNC-native model still beats the transported languageR model. The gap is
large enough to matter: 0.202 versus 0.308 log loss on the core comparison.

Verb-level calibration also shows local differences:

- `give` and `show` are well calibrated by the transported model;
- `send`, `offer`, and `lend` are underpredicted for NP realization;
- `sell` is overpredicted for NP realization.

Theme definiteness is the clearest coefficient mismatch. In the languageR-trained
core model, definite themes have a negative coefficient. In the BNC-native core
model, the coefficient is positive and weak. This may reflect corpus difference,
annotation difference, interaction with omitted accessibility, or the
harmonized feature set.

The recipient-definiteness proxy should not be primary. Adding it worsens
transport log loss from 0.308 to 0.347 while leaving AUC about the same. It is a
useful sensitivity check, not a headline feature.

## Interpretation

The answer to the transport question is now "partly yes." The classic profile
travels strongly enough to support cross-corpus projectibility, but not so
perfectly that the BNC2014 data become redundant. The novel contribution should
therefore be phrased as:

1. open reanalysis confirms robustness on `languageR::dative`;
2. BNC2014 transport confirms that much of the production-conditioning profile
   survives a corpus, variety, and annotation shift;
3. mismatches identify where production probability is corpus-local or
   annotation-sensitive;
4. none of this erases the production/possibility boundary.

This is stronger than the earlier pivot expected: the paper now has a genuine
transport result, not only a plan for one.
