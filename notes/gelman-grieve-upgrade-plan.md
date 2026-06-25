# Gelman + Grieve Upgrade Plan
Goal: revise the paper so the DAIS bridge and BNC2014 transport result satisfy two kinds of scrutiny at once:

- a Gelman-style statistical reading: clear estimands, multilevel uncertainty, measurement-channel discipline, and graph-first diagnostics;
  
- a Grieve-style corpus-sociolinguistic reading: careful domain labels, explicit corpus/speaker heterogeneity, and no overclaiming from six canonical verbs.
  
## Main Diagnosis
The current paper is already disciplined about production probability, acceptability preference, and grammatical possibility. The vulnerable point is that the new DAIS bridge is still mostly descriptive, and the transport section still risks sounding like a stronger sociolinguistic generalization than the design warrants.

The upgrade should keep the paper compact. It should not turn this into a full new Bayesian modelling paper or a BNC2014 sociolinguistic variation paper. The target is a stronger bridge and clearer diagnostic framing.
## Proposed Changes
1. **State the estimands explicitly.**
  
  Add a short paragraph before the results tables:
  
  - `languageR` models estimate conditional production choice inside attested dative tokens.
    
  - BNC2014 transport estimates out-of-domain predictive projectibility over complete-case rows in the six shared high-frequency verbs.
    
  - DAIS estimates controlled double-object preference for constructed alternatives.
    
  
  This is the Gelman move: name what each number estimates before interpreting the number.
  
2. **Add one DAIS calibration figure.**
  
  Create a scatterplot of production NP probability against DAIS DO preference for the 150 shared-verb items. Use colour or facets for verb, and mark the `offer` cases. This should replace some prose burden and make the divergence visible.
  
  Keep it descriptive for now. If time permits, add a simple uncertainty band from item-level bootstrap or participant-level bootstrap, but the figure itself matters most.
  
3. **Upgrade the DAIS model without overbuilding it.**
  
  Preferred version: use the cleaned participant-level DAIS file and fit a mixed model:
  
  ```text
  DOpreference ~ production_np_prob + recipient_id + theme_type + (1 | participant) + (1 | verb)
  ```
  
  If that is too slow or fragile, use item means plus bootstrap over DAIS items as a fallback. The manuscript should not make the correlation do all the inferential work.
  
4. **Make the BNC2014 domain claim impossible to overread.**
  
  Replace any broad “cross-variety” phrasing near the headline result with “out-of-domain corpus transport over the shared high-frequency verb core.” Keep the prior literature paragraph, but make clear that this design bundles variety, period, register, annotation, and verb selection.
  
5. **Add a small BNC2014 heterogeneity audit.**
  
  Use available BNC2014 metadata only descriptively:
  
  - counts by broad dialect/region field if usable;
    
  - counts by age/gender if usable;
    
  - NP rate by available metadata category only where cells are large enough.
    
  
  This is not a social-effects model. It is a scope check showing whether the “BNC2014” target is internally heterogeneous enough that a single corpus-level score should be read cautiously.
  
6. **Revise the conclusion around measurement channels.**
  
  The final claim should be:
  
  > The same conditioning profile is visible in production transport and in controlled preference, but the channels separate in diagnostic cases. That is why corpus probability is evidence about grammatical possibility, not a substitute for judgement evidence.
  
## Files To Touch
- `analysis/08_dais_acceptability_bridge.R`: add DAIS figure outputs; possibly add participant-level mixed model.
  
- `analysis/05_bnc2014_transport.R` or a new `analysis/09_bnc2014_metadata_scope.R`: add metadata-scope summaries.
  
- `sections/05-generalization-and-acceptability.tex`: add estimands, figure, stronger domain wording, and DAIS model/diagnostic results.
  
- `sections/06-grammatical-possibility.tex`: tighten the measurement-channel interpretation.
  
- `sections/07-conclusion.tex`: recast final claim around transport + preference as distinct evidence channels.
  
- `notes/source-verification.md`, `STATUS.md`, and `DECISIONS.md`: record new scope/model decisions.
  
## Guardrails
- Do not promise clean American-vs-British identification.
  
- Do not call DAIS validation of the production model.
  
- Do not let a correlation be the main DAIS result if a model/figure can show calibration and divergence.
  
- Do not build a large Bayesian workflow unless it clearly fits within this paper’s scope.
  
## Recommended Immediate Sequence
1. Add BNC2014 metadata summaries to see what social/domain heterogeneity is available.
  
2. Extend the DAIS script with the calibration figure and, if feasible, the participant-level mixed model.
  
3. Revise Section 05 around estimands, plots, and domain scoping.
  
4. Rebuild, style-check, and inspect whether the paper is still compact.
