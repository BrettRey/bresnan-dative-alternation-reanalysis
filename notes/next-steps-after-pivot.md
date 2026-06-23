# Next Steps After The `languageR` Pivot

## Direction

Move from "can we refit Bresnan et al. more cleanly?" to "what travels, and
what does production evidence fail to see?"

The `languageR::dative` work is now a robustness section. It says the classic
conditioning profile survives modern model discipline and partial pooling. The
next work should not refine that result further unless a specific diagnostic
problem appears.

## Immediate Sequence

### 1. Inspect BNC2014

Done: `analysis/04_inspect_bnc2014_dative.R`.

Completed tasks:

- stream or fetch the Figshare CSV without committing raw data;
- verify row count and reconcile the line-count issue;
- write schema, missingness, value-level, verb-count, and pattern-count tables
  to `data/derived/`;
- confirm citation/licensing expectations from Figshare and JOHD.

This is still inspection, not modelling.

### 2. Harmonize Predictors

Done: `notes/bnc2014-harmonization.md`.

Mapped every `languageR::dative` predictor to BNC2014:

- direct match
- proxy match
- unavailable
- incompatible

Also mapped the outcome: `RealizationOfRecipient` versus BNC2014 `Pattern`
(`VNN`/`VNPP`). The harmonization note states what gets lost in transport.

### 3. State The Production/Possibility Gap

Done: `notes/production-possibility-gap.md`.

Core point:

- production data supports claims about attested conditioned choice;
- it is weak on grammatical-but-rare, grammatical-but-unattested, and
  unacceptable-but-produced regions;
- DAIS/NLMs matter only if they probe those blind spots, not if they merely add
  another predictive benchmark.

This note protects the paper from sliding from frequency to grammaticality.

### 4. Fit Transport

Done: `analysis/05_bnc2014_transport.R`.

The first transport model follows the feature restrictions in
`notes/bnc2014-harmonization.md`: shared six-verb subset, comparable outcome,
in-memory word-length proxies for BNC phrase lengths, animacy, pronominality,
theme definiteness, and a labelled recipient-definiteness sensitivity check.

Completed transport tests:

- train on `languageR`, evaluate on harmonized BNC2014 where possible;
- fit BNC2014-native model and compare the conditioning profile;
- test whether verb, length, animacy, definiteness, pronominality, and modality
  analogues behave similarly;
- report failure as informative, not as an embarrassment.

Result note: `notes/bnc2014-transport-results.md`.

### 5. Write Results Prose

Next:

- turn the `languageR` robustness result into a short first results section;
- turn the BNC2014 transport result into the second results section;
- keep the recipient-definiteness proxy as sensitivity, not the headline;
- state explicitly that transport supports production-profile projectibility,
  not direct grammatical possibility.

## Manuscript Spine

The paper should probably become:

1. Bresnan et al. made the production-probability case.
2. Open reanalysis shows the result is robust, not a modelling artifact.
3. Transport asks whether the conditioning profile is projectible beyond the
   original corpus setup.
4. Production evidence has a principled boundary: it does not by itself settle
   grammatical possibility.
5. DAIS/NLMs enter, if at all, as probes of the boundary between production
   preference and acceptability/possibility.

## Title Decision

Decision made: "neural language models" is out of the title for now.

Restore it only if a later stage includes a concrete DAIS/NLM probe. The current
title should not overpromise while the empirical spine is BNC2014 transport.
