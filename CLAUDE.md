# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A single-PDF LaTeX cheatsheet for learning Arabic *sarf* (صرف / morphology) with explanations in Bengali. The output is `dist/main.pdf` — an A5 booklet of Arabic verb-conjugation tables. There is no application code; "the codebase" is a LaTeX document split into fragments.

## Build & verify

```bash
bash build.sh          # → dist/main.pdf
```

- **Must compile with XeLaTeX**, never pdflatex — the document relies on `fontspec` + `polyglossia` for Bengali (main language) and Arabic (other language). `build.sh` runs a single `xelatex -interaction=nonstopmode -halt-on-error -output-directory=dist main.tex` pass.
- **Run from the repo root.** Font paths in `main.tex` are relative (`Path=./static/fonts/...`); compiling from another directory breaks font loading. `build.sh` `cd`s to the project root for this reason.
- **There are no tests.** Building *is* the verification step: a clean build that produces `dist/main.pdf` with no errors in `dist/main.log` means the change is good. With `-halt-on-error`, a bad edit fails the build immediately.
- **Release:** push a `v*` tag (`git tag v1.0.0 && git push origin v1.0.0`). CI (`.github/workflows/build-and-release.yml`) builds on every push/PR to `main`, and on a `v*` tag additionally publishes a GitHub Release with `sarf-cheatsheet-bn.pdf` attached. CI installs `texlive-xetex texlive-latex-extra texlive-lang-arabic texlive-lang-other` and asserts the two required font files exist before building.

## Document assembly

`main.tex` is the only file with `\documentclass`, the preamble, and `\begin{document}`/`\end{document}`. Everything in `chapters/` is an **input fragment** — it must NOT contain a document environment. A fragment typically opens with `\newpage` then `\section{<Bengali title>}`.

Inclusion is explicit and ordered via `\input` in `main.tex`:
- Top-level chapters (`madi`, `mudare`, `amr`, `nahi`, `ism-e-mustak`) are `\input` directly from `main.tex`.
- The *abwāb* (أبواب — verb paradigm families) live in `chapters/bab/`. `main.tex` inputs `chapters/bab/index`, and `chapters/bab/index.tex` in turn inputs each bab (`nasara-yansuru`, `tafeel`, `tafaul`).

To **add a chapter**: create `chapters/foo.tex`, then add `\input{chapters/foo}` to `main.tex` at the desired position.
To **add a bab**: create `chapters/bab/foo.tex`, then add `\input{chapters/bab/foo}` to `chapters/bab/index.tex`.

Several files are intentional stubs right now (`amr`, `nahi`, `ism-e-mustak`, and all three babs contain only a `\section` and a placeholder comment). `madi.tex` and `mudare.tex` are the worked examples to copy from.

## The root/marker coloring system (most important to understand)

The pedagogical core of the document: in every conjugation the **root letters (الجذر, فعل) are black** and the **pronoun marker (العلامة/الضمير) is red**, so a learner can see what the root is and what each form adds. All the machinery for this lives in the preamble of `main.tex` (`\myroot`, `\sfx`, `\redmark`, `\mud`, `\mudraf`, and the `\fala…` word macros). Read those comments before editing any table — the approach is non-obvious because of two LaTeX/Arabic constraints:

1. **RTL reordering.** Arabic is right-to-left, so a whole word must be wrapped in a single `\textarabic{...}` so it is ONE rtl unit. If you color the root and suffix in separate `\textarabic` calls, they get reordered left-to-right and the red lands on the wrong side. Inside one `\textarabic`, use `\myroot{...}` (black) and `\sfx{...}` (red) runs.

2. **Bare-diacritic markers can't be colored directly.** When the marker is an *added letter* (e.g. ـوا, ـتم, ـانِ), simple colored runs work. But when the marker is a *bare diacritic* on the last root letter (the final fatḥa of فَعَلَ, the final ḍamma/rafʿ of يَفْعَلُ), XeLaTeX cannot color the mark separately from its base letter — changing color mid-cluster detaches the mark. The workaround is an **overlay**: draw the fully-red word first (it sets the box width), then `\llap` a black copy of the same word *with the final mark removed* on top. The black letters hide the red ones; only the red diacritic shows through.
   - `\redmark{<full red word>}{<same word without the final mark>}` — used for ماضي bare-fatḥa forms (e.g. `\fala`).
   - `\mudraf{<prefix>}` — the مضارع analogue for singular forms ending in a bare ḍamma (يَفْعَلُ). Both overlay layers split the prefix identically so they shape and measure the same.

For مضارع, markers appear at BOTH ends (the حروف المضارعة prefixes يَ تَ أَ نَ *and* the suffixes), so use `\mud{<red prefix>}{<black stem>}{<red suffix>}` for added-letter suffixes and `\mudraf{<prefix>}` for bare-ḍamma endings.

The ماضي word macros (`\fala`, `\falaa`, `\faluu`, `\falta`, `\faltu`, …) are predefined in `main.tex` and consumed by `chapters/madi.tex`. If you add forms, define the macro alongside the others rather than inlining the markup in the chapter.

## Tables & conventions

- Conjugation tables use `tabularx` with the custom `C` column (`>{\centering\arraybackslash}X`) for equal centered columns, ordered متكلم | حاضر | غائب (right-to-left reading).
- Every Arabic cell switches font with `{\arabicfont …}` and wraps text in `\textarabic{…}`. Section titles and prose are Bengali.
- Color palette is fixed in the preamble: `headergreen`/`titlegreen` (greens), `lightgreen` (zebra rows), `suffixred` (the marker red). Reuse these names rather than introducing new colors.

## Fonts

- Fonts are loaded **by file path + filename**, not by installed system family name (the README's "by family name" wording is misleading). Bengali = `static/fonts/SolaimanLipi_20-04-07.ttf`; Arabic = `static/fonts/Scheherazade_New/ScheherazadeNew-{Regular,Bold}.ttf` (scaled 1.6). These are the only two families actually used.
- The many other `.ttf` files under `static/fonts/` (Poppins, Nunito, various Quran fonts, etc.) are bundled but unused — do not assume a font is active just because the file is present.
- Because loading is path-based, the bundled files must exist for the build to work; CI verifies the three required files before compiling. If you change a font, update the `\newfontfamily` path in `main.tex`, not just the file.

## Notes

- Generated artifacts (`*.pdf`, `*.aux`, `*.log`, `dist/`, …) are git-ignored; never commit `dist/`.
- Per `CONTRIBUTION.md`, this is an author-only project and external contributions are closed.
