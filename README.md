# Sarf Cheatsheet BN

বাংলা ভাষায় আরবি সরফ শেখার জন্য একটি ছোট LaTeX cheatsheet project.

এই প্রজেক্টে আরবি فعل-এর গুরুত্বপূর্ণ রূপগুলো আলাদা chapter file-এ রাখা হয়েছে, যেন প্রতিটি অংশ আলাদাভাবে লেখা, দেখা, এবং maintain করা সহজ হয়।

## Contents

- `chapters/cover.tex` - PDF-এর cover page
- `chapters/madi.tex` - فعل الماضي / মাজি
- `chapters/mudare.tex` - فعل المضارع / মুজারে
- `chapters/amr.tex` - فعل الأمر / আমর
- `chapters/nahi.tex` - فعل النهي / নাহি
- `chapters/ism-e-mustak.tex` - اسم مشتق / ইসমে মুসতাক

## Project Structure

```text
.
├── main.tex
├── build.sh
├── chapters/
│   ├── cover.tex
│   ├── madi.tex
│   ├── mudare.tex
│   ├── amr.tex
│   ├── nahi.tex
│   └── ism-e-mustak.tex
├── static/
│   ├── fonts/
│   └── images/
└── dist/
```

`main.tex` contains the shared document setup, fonts, colors, helper commands, and chapter links. Individual content should usually go inside the relevant file in `chapters/`.

## Requirements

- XeLaTeX
- Bash-compatible shell
- Bengali font: `SolaimanLipi`
- Arabic font: `Scheherazade New`

The repository includes font files under `static/fonts/`, but the current LaTeX setup loads fonts by family name. If the build cannot find a font, install the needed font on your system or update the font path in `main.tex`.

## Build

Run:

```bash
bash build.sh
```

The script creates `dist/` and writes the PDF here:

```text
dist/main.pdf
```

Generated LaTeX files and PDFs are ignored by Git through `.gitignore`.

## GitHub Actions

The repository includes a GitHub Actions workflow at:

```text
.github/workflows/build-and-release.yml
```

The workflow runs on:

- pushes to `main`
- pull requests targeting `main`
- version tags matching `v*`
- manual runs from the GitHub Actions tab

Every successful workflow run builds the PDF and uploads it as a workflow artifact named `sarf-cheatsheet-bn`.

## Release Pipeline

To create a release, push a version tag:

```bash
git tag v1.0.0
git push origin v1.0.0
```

When GitHub Actions sees a `v*` tag, it builds the PDF and creates a GitHub Release with this asset attached:

```text
sarf-cheatsheet-bn.pdf
```

The release job uses GitHub's built-in `GITHUB_TOKEN` with `contents: write` permission only for the release job.

## Editing

To add or update content, edit the relevant chapter file:

```text
chapters/madi.tex
chapters/mudare.tex
chapters/amr.tex
chapters/nahi.tex
chapters/ism-e-mustak.tex
```

To add a new chapter, create a new `.tex` file inside `chapters/` and link it from `main.tex` with:

```tex
\input{chapters/example}
```

Do not include `\begin{document}` or `\end{document}` inside chapter files. Those belong only in `main.tex`.

## License

See `LICENSE.md`.

## Useful Links

- [Shamela.ws](https://shamela.org/)
- [Tex Studio](https://www.texstudio.org/)
- [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop)
- [MikTeX](https://miktex.org/)
- [LaTeX](https://www.latex-project.org/get/)
