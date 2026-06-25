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
- Variety/period: the source data is American English. Switchboard is
  telephone conversation among speakers from across the United States,
  developed in 1990-1991. The Treebank Wall Street Journal component contains
  one million words of 1989 Wall Street Journal material; the larger Wall
  Street Journal source collection spans 1987-1989.
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
  <https://cran.r-project.org/src/contrib/languageR_1.6.tar.gz>,
  <https://catalog.ldc.upenn.edu/LDC97S62>,
  <https://catalog.ldc.upenn.edu/LDC99T42>,
  <https://catalog.ldc.upenn.edu/LDC2000T43>

### Spoken BNC2014 Dative Dataset

- Status: verified against Figshare and the Journal of Open Humanities Data
  article record.
- Dataset record: Gard Jenset, Barbara McGillivray, and Michael Rundell's data
  for "The dative alternation revisited: fresh insights from contemporary
  British spoken data"; Figshare version 6, posted 2019-07-30.
- DOI: dataset DOI `10.6084/m9.figshare.7353164.v6`; article DOI
  `10.5334/johd.11`. Figshare asks users to cite both.
- Licence: Figshare API reports CC BY 4.0
  (<https://creativecommons.org/licenses/by/4.0/>).
- Provenance: derived from the Early-Access Subset of the Spoken BNC2014
  corpus of Spoken British English. The subset contains spontaneous
  conversations recorded in 2012-2014 and over 4 million tokens.
- Files: `BNCspoken2014_dative_dataset_v1.csv`, plus supporting scripts/files
  (`animacy_recipient.txt`, `combine_data.py`, `r_cleaning_data_script.rmd`).
- CSV file metadata: Figshare file ID `16713434`, size 859,613 bytes, MD5
  `1c041dbcb635855f3d8f4be9f3e1fced`.
- Inspection by `analysis/04_inspect_bnc2014_dative.R`: parsed CSV has 1,839
  data rows and 44 columns. The raw file has 1,839 newline characters but no
  terminal newline, yielding 1,840 logical text lines including the header. So
  the earlier `wc -l` result is not a data-row count.
- Outcome counts: `Pattern == VNN` = 1,474; `Pattern == VNPP` = 365. Verb
  counts: `give` = 829, `send` = 545, `show` = 265, `sell` = 96,
  `offer` = 68, `lend` = 36.
- CSV columns include verb, semantic tag, pattern, recipient/theme text and
  length, pronominality, animacy, definiteness for theme, and speaker metadata
  such as age, gender, nationality, dialect, education, occupation, and word
  counts.
- Metadata-scope audit by `analysis/09_bnc2014_metadata_scope.R`: the released
  rows are heavily structured, with Level 1 dialect `uk` for 1,720/1,839 rows,
  Level 2 dialect `english` for 1,689/1,839, female-coded gender for 1,138 rows
  and male-coded gender for 699, age band 19-29 for 736 rows, and close-family,
  partner, or very-close-friend conversations for 1,171 rows. The transport
  complete-case subset has the same broad shape. Treat BNC2014 transport as a
  corpus-domain diagnostic, not a clean estimate for all British spoken
  English.
- Use in paper: cross-corpus/generalization target, especially spoken British
  English and sociolinguistic metadata. It should not be treated as a direct
  replication of `languageR::dative`, because the verb set and metadata differ.
- Sources: <https://figshare.com/articles/dataset/BNCspoken2014_dative_dataset_v1_csv/7353164>,
  <https://openhumanitiesdata.metajnl.com/articles/10.5334/johd.11>

### DAIS / Hawkins et al. 2020

- Status: paper, repository, licence, and reuse permission verified. A
  repository-level CC BY 4.0 licence was added upstream on 2026-06-24 in commit
  `16ef145b71d1f6e6d755ad0f5ff822327639af0a` (merge PR
  `add-cc-by-license`). Robert Hawkins's 2026-06-25 email also gives explicit
  permission to reuse and redistribute the DAIS judgements while the licence
  update is being settled.
- Paper record: Robert Hawkins, Takateru Yamakoshi, Thomas Griffiths, and Adele
  Goldberg, "Investigating representations of verb bias in neural language
  models," EMNLP 2020, pp. 4653-4663, DOI `10.18653/v1/2020.emnlp-main.376`.
- Dataset claim verified from ACL abstract: DAIS contains 50K human judgments
  for 5K distinct sentence pairs in the English dative alternation, with 200
  verbs and systematic variation in definiteness and argument length.
- Repository: `taka-yamakoshi/neural_constructions`; README says the dative
  judgement dataset contains 50K human judgments and code for human data
  collection and analyses, and `SWBD` contains materials for reanalysis of
  naturally occurring datives annotated by Bresnan and Nikitina. The top-level
  README calls the directory `DATIVE`, while the live repository directory is
  `DAIS`.
- Licence check: a fresh sparse clone on 2026-06-25 finds top-level `LICENSE`
  and README licence language saying that the DAIS dataset and repository code
  are released under Creative Commons Attribution 4.0 International (CC BY 4.0)
  and asking users to cite both the EMNLP 2020 paper and the dataset.
- Data-file check: `DAIS/data/generated_pairs_with_results.csv` at commit
  `16ef145b71d1f6e6d755ad0f5ff822327639af0a` has MD5
  `46af310f1633b8784f897e4482faed84`, 5,000 item rows, and columns including
  the double-object sentence, prepositional-dative sentence, verb
  classification, condition labels, `BehavDOpreference`, and model
  log-likelihood ratios. The cleaned individual-judgement ZIP has MD5
  `e7b3ac6f2dd8e85bc93e6e20fc0f6ec1` and contains 50,136 retained judgement
  rows from 1,011 participants after the authors' exclusions.
- Use in paper: one compact acceptability/preference bridge. The project script
  fetches the item-level DAIS CSV and cleaned individual-judgement ZIP to
  temporary files, validates the MD5 hashes, and writes derived summaries for
  the 150 DAIS items whose verbs overlap the six-verb `languageR`/BNC2014 core.
  When `lme4` is available, it also fits a compact participant-level mixed
  bridge model. DAIS is not production-token evidence and should not be merged
  with `languageR` or BNC2014 as if it measured the same outcome.
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
