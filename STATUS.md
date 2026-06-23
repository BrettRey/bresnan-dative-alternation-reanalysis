# STATUS

**Last updated:** 2026-06-23  
**State:** Project scaffold created. No data downloaded and no analysis run.  
**Next action:** Verify the dataset/source situation, then decide whether the first empirical target is direct reanalysis of `languageR::dative`, cross-corpus generalization to BNC2014, or a bridge to acceptability resources.  
**Blocker:** Source and dataset verification still pending.

## Working Title

*Predicting grammatical possibility: The dative alternation after probabilistic grammar, open data, and neural language models*

## Working Thesis

Bresnan et al. made a durable methodological claim: probabilistic usage data can reveal grammatical possibilities that informal intuitions may miss. The update asks how stable that claim is under modern modelling, open-data replication, cross-corpus generalization, and the newer split between production probability and acceptability preference.

## Infrastructure

- Project path: `papers/bresnan-dative-alternation-reanalysis/`.
- `references.bib` is a symlink to the central `.house-style/references.bib`.
- `.house-style/preamble.tex` and `.house-style/style-rules.yaml` are symlinks to the central house-style files.
- There is no local house-style snapshot.
- Project-specific verified references belong in `references-local.bib`.
- Source-verification notes live in `notes/source-verification.md`.

## Session Notes

### 2026-06-23

- Created project scaffold from scratch rather than using `create-paper.sh`, because the template copies house-style files and Brett specified that this project must use the central house style strictly.
- Renamed the project folder to lower-case hyphenated form: `papers/bresnan-dative-alternation-reanalysis/`.
- Added section stubs, notes, data/analysis directories, Makefile, and project guidance.
- Seeded a pressure-test note around the load-bearing no-new-data assumptions.
