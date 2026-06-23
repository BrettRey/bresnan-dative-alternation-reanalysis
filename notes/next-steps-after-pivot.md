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

Create `analysis/04_inspect_bnc2014_dative.R`.

Tasks:

- stream or fetch the Figshare CSV without committing raw data;
- verify row count and reconcile the 1,838/1,840 issue;
- write schema, missingness, value-level, verb-count, and pattern-count tables
  to `data/derived/`;
- confirm citation/licensing expectations from Figshare and JOHD.

This is still inspection, not modelling.

### 2. Harmonize Predictors

Create `notes/bnc2014-harmonization.md`.

Map every `languageR::dative` predictor to BNC2014:

- direct match
- proxy match
- unavailable
- incompatible

Also map the outcome: `RealizationOfRecipient` versus BNC2014 `Pattern`
(`VNN`/`VNPP`). The harmonization note should say what gets lost before any
transport model is fit.

### 3. State The Production/Possibility Gap

Create `notes/production-possibility-gap.md`.

Core point:

- production data supports claims about attested conditioned choice;
- it is weak on grammatical-but-rare, grammatical-but-unattested, and
  unacceptable-but-produced regions;
- DAIS/NLMs matter only if they probe those blind spots, not if they merely add
  another predictive benchmark.

This note protects the paper from sliding from frequency to grammaticality.

### 4. Then Fit Transport

Only after steps 1-3:

Create `analysis/05_bnc2014_transport.R`.

Minimal transport tests:

- train on `languageR`, evaluate on harmonized BNC2014 where possible;
- fit BNC2014-native model and compare the conditioning profile;
- test whether verb, length, animacy, definiteness, pronominality, and modality
  analogues behave similarly;
- report failure as informative, not as an embarrassment.

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

## Decision Needed Soon

Decide whether "neural language models" stays in the title.

Keep it only if the next stage includes a concrete DAIS/NLM probe. Otherwise,
soften the title now so the analysis does not overpromise.
