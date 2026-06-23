# Pivot After `languageR::dative`

## Honest Read

The `languageR::dative` reanalysis has done its job. It verifies that the
classic Bresnan et al. production-choice result is robust to cleaner analysis
discipline, null checks, and partial pooling. It does not yet supply the paper's
main contribution.

The current result answers local question 4 from `CLAUDE.md`: modern modelling
does not appear to change the linguistic conclusion. It changes the statistical
packaging. The verb-conditioning result survives:

| Model | Test log loss | Test AUC | Effective df |
|---|---:|---:|---:|
| Marginal null | 0.554 | 0.500 | 1 |
| Non-verb main model | 0.271 | 0.932 | 18 |
| Fixed-verb full model | 0.234 | 0.951 | 92 |
| Hierarchical verb-intercept model | 0.233 | 0.952 | 19 |

The hierarchical model's verb random-intercept SD is 2.106. Scrambled-label and
fake-null hierarchical checks collapse toward zero verb variance. That is a
clean robustness result, but it is not the paper.

## Consequence

Stop adding further `languageR` refinements for now.

The next contribution cannot be another same-data model unless a specific
diagnostic failure demands it. More modelling on `languageR::dative` would
improve polish, not the argument.

## What The Paper Can Now Say

The first results section should be modest:

1. The classic conditioning profile is reproducible from open package data.
2. The result beats marginal, structured, scrambled-label, and fake-data nulls.
3. Partial pooling preserves the substantive story while avoiding a large
   fixed-verb parameterization.
4. Therefore, modern modelling supports the durability of the original
   production-choice result; it does not by itself establish a new grammatical
   conclusion.

This section should be written as a floor, not as the paper's ceiling.

## Where The Contribution Lives

### 1. Transport

BNC2014 is the first genuinely new empirical test. It asks whether the
conditioning profile travels across corpus design, variety, register, time, and
metadata structure.

The next analysis stage was:

1. Reconcile the BNC2014 row-count issue.
2. Inspect BNC2014 schema and licensing without committing raw data.
3. Build a harmonization table between `languageR::dative` and BNC2014 fields.
4. Define what can be transported directly, what must be proxied, and what must
   be dropped.

Those gates now exist in `analysis/04_inspect_bnc2014_dative.R` and
`notes/bnc2014-harmonization.md`. The first transport test now exists in
`analysis/05_bnc2014_transport.R`, with results summarized in
`notes/bnc2014-transport-results.md`.

The transport question is not "can we get a good AUC on another dataset?" It is:
which parts of the conditioning profile remain projectible when the corpus and
annotation regime change?

### 2. Production Versus Possibility

The title promises grammatical possibility, but production-token data only sees
attested choices. It is structurally weak on never-attested-but-grammatical and
low-probability-but-grammatical regions.

That gap must become explicit:

- `languageR::dative` supports claims about production choice under observed
  corpus conditions.
- BNC2014 tests whether a production-choice profile transports.
- DAIS and neural language model probes are relevant only if they test regions
  production data cannot see: preference, acceptability, verb bias under
  controlled alternatives, and low-attestation contrasts.

The paper should not let "grammatical possibility" ride for free on production
probability.

## NLM Scope Decision

Decision made: remove the neural-language-model promise from the title unless
and until a concrete DAIS/NLM probe becomes part of the analysis.

Possible later routes:

1. Minimal probe: use DAIS/Hawkins et al. as the acceptability/preference bridge
   and report a narrow comparison to published NLM behavior or a small
   reproducible local probe.
2. Deferred promise: keep DAIS/NLMs as future work.

Do not restore the NLM phrase unless the project will cash it with a concrete
analysis.

## Revised Next Step

Replace "add Bayesian priors or more languageR models" with:

1. Done: `analysis/04_inspect_bnc2014_dative.R`: fetch or stream the BNC2014 CSV,
   verify row count, schema, missingness, and variable levels, and write small
   derived metadata tables.
2. Done: `notes/bnc2014-harmonization.md`: map BNC2014 fields to the `languageR`
   predictors and classify each as direct, proxy, unavailable, or incompatible.
3. Done: `notes/production-possibility-gap.md`: state exactly what production data
   can and cannot show about grammatical possibility, and what DAIS would add.
4. Done: `analysis/05_bnc2014_transport.R`, fit the documented minimal
   transport model.

The project is now cleared to write the robustness and transport results as
manuscript prose.
