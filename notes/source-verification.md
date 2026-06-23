# Source Verification

Purpose: keep candidate sources and datasets out of final prose until they have
been checked against authoritative records.

## Verified Core Targets

### Bresnan et al. 2007

- Status: verified against the Max Planck Institute publication record.
- Bibliography: `bresnan2007` is already present in central `references.bib`.
- Record: Bresnan, Cueni, Nikitina, and Baayen, "Predicting the dative
  alternation," in *Cognitive Foundations of Interpretation*, pp. 69-94,
  Amsterdam: KNAW, 2007.
- Use in paper: conceptual and empirical anchor. The MPI abstract explicitly
  frames the case as evidence that grammaticality intuitions can underestimate
  the space of grammatical possibility and that standard objections to usage
  data can be treated as empirical modelling problems.
- Source: <https://www.mpi.nl/publications/item58830/predicting-dative-alternation>

### `languageR::dative`

- Status: verified against the CRAN manual and inspected from the CRAN source
  tarball without installing the package locally.
- Package record: `languageR` 1.6, CRAN publication date 2025-06-10, GPL
  (>= 2), maintained by R. H. Baayen; package description says the datasets
  accompany *Analyzing Linguistic Data: A practical introduction to statistics
  using R*.
- Dataset documentation: data describing NP/PP realization of the dative in
  Switchboard and the Treebank Wall Street Journal collection.
- Local tarball inspection: 3,263 rows, 15 columns, 75 verb levels. Outcome
  counts: NP = 2,414, PP = 849. Modality counts: spoken = 2,360, written = 903.
- Columns: `Speaker`, `Modality`, `Verb`, `SemanticClass`,
  `LengthOfRecipient`, `AnimacyOfRec`, `DefinOfRec`, `PronomOfRec`,
  `LengthOfTheme`, `AnimacyOfTheme`, `DefinOfTheme`, `PronomOfTheme`,
  `RealizationOfRecipient`, `AccessOfRec`, `AccessOfTheme`.
- Use in paper: first empirical target. This supports a direct reproducible
  production-choice reanalysis with modern modelling and uncertainty checks.
- Limit: this verifies the packaged teaching/reanalysis dataset and its schema,
  not the full raw extraction path from Switchboard/Penn Treebank.
- Do not use `languageR::verbs` as the main dataset: CRAN documents it as a
  903-row simplified data set for expository purposes.
- Sources: <https://cran.r-project.org/web/packages/languageR/languageR.pdf>,
  <https://cran.r-project.org/src/contrib/languageR_1.6.tar.gz>

### Spoken BNC2014 Dative Dataset

- Status: verified against Figshare and the Journal of Open Humanities Data
  article record.
- Dataset record: Gard Jenset, Barbara McGillivray, and Michael Rundell's data
  for "The dative alternation revisited: fresh insights from contemporary
  British spoken data"; Figshare version 6, posted 2019-07-30.
- DOI: dataset DOI `10.6084/m9.figshare.7353164.v6`; article DOI
  `10.5334/johd.11`. Figshare asks users to cite both.
- Provenance: derived from an early sample of the Spoken BNC2014 corpus of
  Spoken British English.
- Files: `BNCspoken2014_dative_dataset_v1.csv`, plus supporting scripts/files
  (`animacy_recipient.txt`, `combine_data.py`, `r_cleaning_data_script.rmd`).
- Streaming CSV check: 1,839 lines total, so 1,838 data rows plus header. Do
  not state "1,840 observations" until that discrepancy is reconciled with the
  article or file history.
- CSV columns include verb, semantic tag, pattern, recipient/theme text and
  length, pronominality, animacy, definiteness for theme, and speaker metadata
  such as age, gender, nationality, dialect, education, occupation, and word
  counts.
- Use in paper: cross-corpus/generalization target, especially spoken British
  English and sociolinguistic metadata. It should not be treated as a direct
  replication of `languageR::dative`, because the verb set and metadata differ.
- Sources: <https://figshare.com/articles/dataset/BNCspoken2014_dative_dataset_v1_csv/7353164>,
  <https://openhumanitiesdata.metajnl.com/articles/10.5334/johd.11>

### DAIS / Hawkins et al. 2020

- Status: paper and repository verified; licensing still needs a closer check
  before copying or redistributing data.
- Paper record: Robert Hawkins, Takateru Yamakoshi, Thomas Griffiths, and Adele
  Goldberg, "Investigating representations of verb bias in neural language
  models," EMNLP 2020, pp. 4653-4663, DOI `10.18653/v1/2020.emnlp-main.376`.
- Dataset claim verified from ACL abstract: DAIS contains 50K human judgments
  for 5K distinct sentence pairs in the English dative alternation, with 200
  verbs and systematic variation in definiteness and argument length.
- Repository: `taka-yamakoshi/neural_constructions`; README says `DAIS`
  contains the 50K human judgments and code for human data collection and
  analyses, and `SWBD` contains materials for reanalysis of naturally occurring
  datives annotated by Bresnan and Nikitina.
- Use in paper: acceptability/preference bridge and neural-LM comparison. It is
  not production-token evidence and should not be merged with `languageR` or
  BNC2014 as if it measured the same outcome.
- Sources: <https://aclanthology.org/2020.emnlp-main.376/>,
  <https://github.com/taka-yamakoshi/neural_constructions>

### Bard, Robertson, and Sorace 1996

- Status: bibliographic record and conceptual role verified against Edinburgh
  Research Explorer.
- Record: Ellen Bard, David Robertson, and Antonella Sorace, "Magnitude
  estimation of linguistic acceptability," *Language*, 1996, pp. 32-68.
- Use in paper: methods comparator for acceptability measurement and scale
  construction. It should frame the production/acceptability distinction, not
  become a second empirical target unless raw data availability is established.
- Source: <https://www.research.ed.ac.uk/en/publications/magnitude-estimation-of-linguistic-acceptability/>

## Later Acceptability Resources

- CoLA: verified as a 10,657-sentence grammatical/ungrammatical corpus from
  published linguistics literature. Useful only as broad LM acceptability
  context, not as a dative-specific bridge.
  Source: <https://aclanthology.org/Q19-1040/>
- BLiMP: verified as 67 datasets of 1,000 minimal pairs each, generated from
  linguist-crafted templates, with high aggregate human agreement. Useful for
  LM-evaluation framing; not dative-specific.
  Source: <https://aclanthology.org/2020.tacl-1.25/>
- MegaAcceptability: verified as ordinal acceptability judgments for 1,007
  English clause-embedding verbs across 50 surface-syntactic frames and three
  tenses. Useful as a large-scale acceptability comparator; not dative-specific.
  Source: <https://megaattitude.io/projects/mega-acceptability/mega-acceptability-v2/>
- Syntactic Acceptability Dataset preview: verified as 1,000 English sequences
  with both grammaticality labels from literature and crowdsourced acceptability
  labels. Useful for the grammaticality/acceptability distinction; not
  dative-specific.
  Source: <https://aclanthology.org/2024.lrec-main.1401/>

## Working Classification

| Source | Evidential level | Best use | Do not use for |
|---|---|---|---|
| Bresnan et al. 2007 | Conceptual + production modelling | Anchor claim about usage data and grammatical possibility | Treating intuition, production, and acceptability as equivalent |
| `languageR::dative` | Production-token choice | First reproducible reanalysis | Raw-corpus provenance claims beyond package documentation |
| Spoken BNC2014 dative data | Production-token choice in a later spoken British corpus | Cross-corpus transport/generalization | Direct replication without harmonization |
| DAIS | Human preference/acceptability over sentence pairs | Production/acceptability bridge and LM comparison | Production-token frequency |
| Bard et al. 1996 | Acceptability-methods theory | Measurement framing | Dative-specific empirical evidence |
| CoLA/BLiMP/MegaAcceptability/SAD | General acceptability/LM benchmarks | Background only | Main empirical target |

## Data Handling Rule

Do not commit large raw datasets unless needed and licensing permits it. Prefer
scripts that fetch or document canonical public sources, plus small derived
tables needed for reproducibility.
