# xpdf-pr
PolicyReporter's build of the [Xpdf](https://www.xpdfreader.com/) command-line tools, packaged as `.deb` for amd64 and arm64.

## Fork delta
The tree is pristine upstream xpdf plus the patches in [`patches/`](patches/) and the [`pdftotext/`](pdftotext/) and [`pdftohtml/`](pdftohtml/) directories:

| Patch | Why |
|---|---|
| `0001-okToCopy-always-true.patch` | Always allow text extraction, ignoring the PDF's copy permission.<br/>Documents that need a *user* password still can't be opened without it. |
| `0002-build-pdftohtml-0.39.patch` | Build `pdftohtml/` (see below). |
| `0003-ascii7-drop-nbsp.patch` | `-enc ASCII7` drops non-breaking spaces (U+00A0) as 3.04 did. 4.x outputs them as a space. |
| `0004-build-pdftotext-3.04.patch` | Build `pdftotext/` (see below). |

Unlike 3.04, xpdf 4.x stops parsing options at the first non-option argument, so options must come before the file name:
`pdfdetach -saveall -o <dir> <file>`, not `pdfdetach -saveall <file> -o <dir>`.

### pdftotext
`pdftotext` uses the xpdf 3.04 text extractor (`TextOutputDev`), built against the xpdf 4.06 sources.\
xpdf 4 rewrote the text layout analysis, which reorders and re-wraps the text of many documents.
bumblebee and policyr compare and store this text, so the 3.04 output is kept.\
xpdf's own `pdftotext` is installed as `pdftotext-xpdf`.

Changes from 3.04:
- Ported to the xpdf 4 API (`drawChar` signature, declared font ascent, `displayPages`).
- Hardening fixes, most of them from 4.x, commented `xpdf-pr:` in the code:
  huge or NaN coordinates, empty Type 3 glyph names, font changes without a font, and out of memory (exit code 98).

### pdftohtml
`pdftohtml` is not xpdf's: it is [pdftohtml 0.39](http://pdftohtml.sourceforge.net/), built against the xpdf sources.\
policyr parses its HTML output (`<DIV class="text" ...>` rows), which xpdf's own `pdftohtml` does not produce.\
xpdf's own `pdftohtml` is installed as `pdftohtml-xpdf`.

Changes from pdftohtml 0.39:
- HTML output: `page` and `text` div classes, page width/height, `px` units, closed tags, escaped entities and metadata.
- Options: `-d` (discard duplicate text), `-space`, `-nooutline`, and `-raw` re-enabled.
- Ported to the xpdf 4 API. The helpers it used to add to xpdf core are in `pdftohtml/HtmlCompat.h`.

With patch 0003, the 4.06 build gives the same output as the 3.04 build.

## Build
Requires CMake, a C++ compiler, FreeType, libpng and zlib.
```sh
# Ubuntu
sudo apt install cmake g++ libfreetype-dev libpng-dev zlib1g-dev
# Mac
brew install cmake freetype libpng

scripts/build.sh
sudo cmake --install build
```
`scripts/build.sh` holds the build options (CLI tools only, no Qt viewer, no fontconfig).\
The packaging scripts and CI all use it.

## Packaging
Each package is built in a Docker container of the target distro and architecture, so binaries link against the glibc/ABI that will run them.\
Nothing is cross-compiled.
```sh
scripts/build-deb.sh               # dist/xpdf-pr_4.06_{amd64,arm64}.deb (ubuntu:26.04)
ARCHS=arm64 scripts/build-deb.sh   # a single architecture
```

CI (`.github/workflows/cpp.yml`) builds the package on native amd64 and arm64 runners.\
Pushing a `v*` tag, or creating the release in the GitHub UI, attaches both `.deb` files to the release.
