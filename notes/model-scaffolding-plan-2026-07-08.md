# Model Scaffolding Plan
## Diagnosis
The manuscript does describe the models, but too late and too densely. A reader can recover the specifications from Sections 4 and 5, yet the paper does not first say what the model sequence is _for_ or explain enough of the model vocabulary. That makes the tables look like a stack of named models rather than a set of controlled comparisons.
## Assumptions Checked
- Section 4 already names the `languageR` models: marginal null, non-verb main model, fixed-verb full model, and hierarchical verb-intercept model. The reviewed concern is that naming is insufficient: the prose needs to define fixed verb effects, varying verb intercepts, and partial pooling in reader-facing language.
  
- Section 5 already gives the BNC2014 transport formula and Table 2 model families: marginal, verb only, non-verb, and full core, for both source-trained and target-native models.
  
- The DAIS supplement already gives enough model detail for the mixed bridge. It may need one sentence linking the Gaussian mixed model to the comparative slider scale, but it is not the main gap.
  
## Proposed Fix
Add a compact pedagogical scaffold in three places.

1. Section 4, before Table 1: Add a short "model map" paragraph. The key point is that the models are not competing grammatical theories. They are nested diagnostic comparisons:
  
  - marginal null: what happens if only the base NP/PP rate is known;
    
  - non-verb model: whether the classic non-lexical predictors carry the profile;
    
  - fixed-verb model: how much lexical identity adds when each verb gets its own coefficient;
    
  - hierarchical verb-intercept model: whether the lexical effect survives partial pooling.
    
2. Section 5, before Table 2: Add a second map for transport. The key point is that source and native rows use the same four predictor families, but answer different questions:
  
  - source marginal: does the source base rate travel;
    
  - source verb only: do verb base-rate differences travel;
    
  - source non-verb: do non-lexical conditioning relations travel;
    
  - source full: does combining verb and non-verb information help;
    
  - native counterparts: how much target-specific structure is recoverable on the same rows.
    
3. DAIS supplement: Add one sentence saying the mixed model is a descriptive linear mixed model for the scaled comparative slider response, not a model of absolute acceptability or binary grammaticality.
  
## Wording Constraints
- Keep the additions short enough not to turn the methods sections into a tutorial.
  
- Avoid new model notation unless it saves words.
  
- Do not add a full appendix or another table unless the prose still feels too compressed.
  
- Preserve the current estimand discipline: production-choice models estimate conditional NP/PP realization, not grammaticality.
  
## Recommended Implementation
Use prose, not a new table, unless the rendered page count or readability forces a table. The paper is already table-heavy, and a prose map can do the scaffolding with less visual cost.
