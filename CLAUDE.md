# CLAUDE.md

This file provides project-specific guidance for Brett Reynolds's paper:

**Production probability, transport, and grammatical possibility: Reanalysing the English dative alternation with open data**

## Project Role

This is a no-new-data reanalysis/update project. The contribution is not that
dative alternation can be modelled probabilistically; Bresnan et al. already
made that classic move. The contribution must be what follows for grammatical
possibility when the result is made reproducible, updated with current modelling
practice, and tested for transport across datasets.

## Local Questions

1. What exactly is the target: production choice, acceptability preference, or
   grammatical possibility?
2. What level is being measured: token-level corpus distribution, speaker
   preference, lexical conditioning, or theoretical grammar?
3. Which dataset supports which claim?
4. Do modern models change the linguistic conclusion or only the statistical
   packaging?
5. What fails to generalize across corpus, modality, variety, or period?

## Build System

Use XeLaTeX, not pdfLaTeX or LuaLaTeX.

```bash
make
make quick
make clean
```

Manual full build:

```bash
xelatex main.tex
biber main
xelatex main.tex
xelatex main.tex
```

## File Structure

```text
bresnan-dative-alternation-reanalysis/
|-- main.tex
|-- sections/
|-- notes/
|-- data/
|-- analysis/
|-- submission/
|-- STATUS.md
|-- DECISIONS.md
|-- README.md
|-- references.bib          # symlink to ../../.house-style/references.bib
|-- references-local.bib    # verified project-specific additions only
`-- .house-style/           # symlinks to central house-style files
```

## House Style

This project uses Brett's central house style strictly by symlink. Do not copy
local house-style files into the project.

## Citation and Data Discipline

- Use the central bibliography when the key already exists.
- Add to `references-local.bib` only after source verification.
- Keep candidate sources in `notes/source-verification.md` until verified.
- Do not download, transform, or summarize datasets before reading the dataset
  documentation.
- Keep production data, acceptability judgments, and grammatical theory at
  separate explanatory levels unless the bridge is argued.

## Current State

Read `STATUS.md`, `DECISIONS.md`, `notes/project-brief.md`, and
`notes/source-verification.md` at the start of a session. Log durable decisions
to `DECISIONS.md` as they happen.
