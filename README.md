# Bresnan Dative Alternation Reanalysis

Working title:

*Predicting grammatical possibility: The dative alternation after probabilistic grammar, open data, and neural language models*

## Aim

Set up a no-new-data paper around Bresnan, Cueni, Nikitina, and Baayen's
"Predicting the dative alternation." The project should test what survives when
the classic probabilistic-grammar result is rerun with open data, modern
modelling, cross-corpus generalization, and acceptability resources.

## Build

```bash
make
```

Manual build:

```bash
xelatex main.tex
biber main
xelatex main.tex
xelatex main.tex
```

## Structure

- `main.tex` orchestrates the paper.
- `sections/` holds section-level source files.
- `notes/source-verification.md` tracks sources and datasets to verify before citation.
- `notes/assumptions-and-pressure-test.md` records early falsification conditions.
- `data/` is for scripts or pointers to reusable public datasets, not raw downloads by default.
- `analysis/` is for reproducible analysis notebooks/scripts.
- `references.bib` is a symlink to the central bibliography.
- `references-local.bib` is for verified project-specific additions only.

## House Style

This project uses the central house style strictly by symlink:

- `.house-style/preamble.tex -> ../../../.house-style/preamble.tex`
- `.house-style/style-rules.yaml -> ../../../.house-style/style-rules.yaml`
- `references.bib -> ../../.house-style/references.bib`

Do not copy house-style files into this project.
