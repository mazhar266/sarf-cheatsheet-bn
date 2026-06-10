# Repository Guidelines

## Project Overview

This is a XeLaTeX project that builds a single A5 PDF cheatsheet for learning Arabic sarf with Bengali explanations. There is no application runtime or test suite; the source is a LaTeX document split into fragments under `chapters/`.

## Build And Verification

- Build from the repository root with `bash build.sh`.
- The build script runs `xelatex -interaction=nonstopmode -halt-on-error -output-directory=dist main.tex`.
- Use XeLaTeX only. Do not switch to `pdflatex`; the document depends on `fontspec` and `polyglossia`.
- A successful build writes `dist/main.pdf`. Treat a clean build as the verification step.
- Do not commit generated artifacts such as `dist/`, `*.pdf`, `*.aux`, `*.log`, or `*.synctex.gz`.

## Document Structure

- `main.tex` owns the preamble, fonts, colors, helper macros, document metadata, and the only `\begin{document}` / `\end{document}` pair.
- Files in `chapters/` and `chapters/bab/` are input fragments. They must not define their own document environment.
- Top-level chapters are included directly from `main.tex`.
- Bab chapters are included from `chapters/bab/index.tex`.
- To add a top-level chapter, create `chapters/name.tex` and add `\input{chapters/name}` to `main.tex`.
- To add a bab chapter, create `chapters/bab/name.tex` and add `\input{chapters/bab/name}` to `chapters/bab/index.tex`.

## LaTeX Conventions

- Keep shared commands in `main.tex` unless a command is truly local to one fragment.
- Reuse the existing color names: `headergreen`, `lightgreen`, `suffixred`, and `titlegreen`.
- Conjugation tables use `tabularx` with the custom `C` column for equal centered columns.
- Arabic table cells should use the existing Arabic helpers and font switching pattern rather than raw inline styling.
- Keep Bengali prose in chapter fragments and Arabic forms in `\textarabic{...}`.

## Root And Marker Coloring

The key teaching convention is that root letters stay black and pronoun or grammatical markers are red.

- Use `\myroot{...}` for root letters and `\sfx{...}` for red markers inside a single `\textarabic{...}` unit.
- Do not split one Arabic word across multiple `\textarabic{...}` calls; RTL ordering can put the colored marker on the wrong side.
- For bare final diacritic markers, use the existing overlay helpers such as `\redmark` and `\mudraf` instead of trying to color the diacritic directly.
- If adding repeated verb forms, prefer defining a macro beside the existing form macros in `main.tex`.

## Fonts

- Bengali font: `static/fonts/SolaimanLipi_20-04-07.ttf`.
- Arabic font: `static/fonts/Scheherazade_New/ScheherazadeNew-{Regular,Bold}.ttf`.
- Font loading is path-based, so build commands must run from the repo root.
- Many bundled font files are unused; do not assume a font is active only because it exists under `static/fonts/`.

## Git Notes

- Preserve user changes in the working tree. At initialization time `chapters/bab/intro.tex` may be an untracked draft.
- External contributions are closed per `CONTRIBUTION.md`; keep changes scoped to the document source and build metadata.
