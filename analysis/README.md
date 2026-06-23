# Analysis

This directory is for reproducible analysis scripts or notebooks after source
verification.

Likely analysis sequence:

1. Load and audit `languageR::dative`.
2. Reproduce the original-style model.
3. Fit modern comparison models.
4. Run cross-validation / posterior predictive checks as appropriate.
5. Test generalization to later datasets only after schema comparability is
   documented.
