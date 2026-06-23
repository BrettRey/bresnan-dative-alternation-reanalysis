# Source Verification Queue

Purpose: keep candidate sources and datasets out of final prose until they have
been checked against authoritative records.

## Already Present in Central Bibliography

- `bresnan2007` — Bresnan, Cueni, Nikitina, and Baayen, "Predicting the Dative Alternation." Present in central `references.bib`. Still verify against the MPI / publisher record before source-grounded drafting.

## Candidate Data / Source Targets To Verify

- `languageR::dative` dataset
  - Claim to verify: 3,263 observations from Switchboard and the Wall Street Journal portion of the Penn Treebank, with predictor fields for modality, verb, semantic class, lengths, animacy, definiteness, pronominality, discourse accessibility, and NP/PP realization.
  - Candidate page from seed note: <https://rdrr.io/cran/languageR/man/dative.html>
  - Verification needed: package manual, CRAN version, licensing, field names, whether it is the original-style Bresnan dataset or a derived teaching dataset.

- Spoken BNC2014 dative dataset
  - Claim to verify: 1,840 observations of informal spoken British English dative alternations, with syntactic pattern, verb, recipient/theme properties, animacy, definiteness, and metadata.
  - Candidate page from seed note: <https://openhumanitiesdata.metajnl.com/articles/10.5334/johd.11>
  - Verification needed: article metadata, repository link, licensing, schema, relation to Bresnan et al.

- DAIS dative-alternation benchmark
  - Claim to verify: 50K human judgments for 5K sentence pairs involving 200 verbs and manipulated argument properties.
  - Candidate page from seed note: <https://aclanthology.org/2020.emnlp-main.376/>
  - Verification needed: paper title, dataset availability, licensing, and whether its judgment format supports the production/acceptability bridge.

- Bard, Robertson, and Sorace 1996
  - Use: conceptual comparator for magnitude estimation and acceptability-methods framing.
  - Candidate page from seed note: <https://www.research.ed.ac.uk/en/publications/magnitude-estimation-of-linguistic-acceptability/>
  - Verification needed: full bibliographic record and whether any raw participant-level data exists.

- Later acceptability datasets and methods papers
  - Candidate resources from seed note: Sprouse, Schütze, and Almeida; Langsford et al.; CoLA; BLiMP; MegaAcceptability; Syntactic Acceptability Dataset preview.
  - Verification needed: decide which are relevant enough to include. Avoid turning the dative paper into a Bard/magnitude-estimation paper.

## Data Handling Rule

Do not commit large raw datasets unless needed and licensing permits it. Prefer
scripts that fetch or document canonical public sources, plus small derived
tables needed for reproducibility.
