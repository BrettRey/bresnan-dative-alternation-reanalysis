# Reader-Oriented Revision Pass
This pass treats the target reader as a linguist who is interested in probabilistic grammar, evidence, and generalization, but who does not want the statistics to become the plot.
## Revision Contract
1. Lead with the linguistic or evidential question, then name the diagnostic.
  
  - Replace method-first sentences such as "The native BNC2014 benchmark uses repeated verb-stratified row-level cross-validation..." with reader-first versions that say what the limitation means: the public release permits a same-row target-native comparison but not a new-conversation test.
    
2. Keep technical terms only where they pay rent immediately.
  
  - Calibration, log loss, AUC, partial pooling, OOF, and cross-validation should remain, but each should be attached to a plain-language function the first time it matters in a paragraph.
    
3. Reduce defensive correction.
  
  - Preserve essential boundaries: production probability is not grammaticality probability; DAIS preference is not absolute acceptability; row-level folds are not conversation-level folds.
    
  - Recast non-essential "not X but Y" prose into direct statements of what the result licenses.
    
4. Clean editing scar tissue.
  
  - Remove compressed stitching from recent passes: duplicated caveats, unexplained abbreviations, abrupt contrast markers, and sentences that read as replies to a reviewer rather than as exposition for the article.
    
5. Keep the paper short.
  
  - This is not a pedagogical expansion pass. Where a sentence is opaque, revise the sentence before adding a new one.
    
## Likely Touch Points
- Section 3: denominator and BNC2014 setup.
  
- Section 4: model-family descriptions and partial pooling payoff.
  
- Section 5: harmonization, cross-validation, ablation sequence, transport result, and recalibration.
  
- Section 6: grammaticality boundary and evidence ladder.
  
- Section 7: conclusion.
  
- DAIS supplement: measurement-scale cautions and mixed-model description.
  
## Acceptance Criteria
- A linguist can state the paper's evidential claim before encountering the full statistical machinery.
  
- Every technical limitation says what it does and does not license.
  
- The prose no longer sounds like accumulated patches from earlier review passes.
  
- House style passes.
  
- `make` and `make blind` pass, with the blinded PDF checked for identity leakage.
