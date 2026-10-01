#!/bin/bash
# Build the xpdf-pr .deb for the current architecture.
# Meant to run inside a clean Debian/Ubuntu container.
# Reads the sources from $SRC_DIR and writes the package to $OUT_DIR.
set -euo pipefail

SRC_DIR="${SRC_DIR:-/src}"
OUT_DIR="${OUT_DIR:-/out}"
WORK_DIR=/tmp/xpdf-pr

export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq --no-install-recommends \
  ca-certificates cmake make g++ libfreetype-dev libpng-dev zlib1g-dev dpkg-dev >/dev/null

"${SRC_DIR}/scripts/build.sh" "${WORK_DIR}/build"
PKG_DIR="${WORK_DIR}/pkg"
DESTDIR="${PKG_DIR}" cmake --install "${WORK_DIR}/build"

VERSION=$(sed -n 's/^#define xpdfVersion *"\(.*\)"/\1/p' "${SRC_DIR}/xpdf/config.h")
ARCH=$(dpkg --print-architecture)

# dpkg-shlibdeps derives Depends from the binaries' NEEDED entries.
# It requires a debian/control in the working directory.
mkdir -p "${WORK_DIR}/shlibs/debian"
printf 'Source: xpdf-pr\n\nPackage: xpdf-pr\nArchitecture: any\n' >"${WORK_DIR}/shlibs/debian/control"
DEPENDS=$(cd "${WORK_DIR}/shlibs" && dpkg-shlibdeps --warnings=0 -O "${PKG_DIR}"/usr/bin/* | sed 's/^shlibs:Depends=//')

mkdir -p "${PKG_DIR}/DEBIAN"
cat >"${PKG_DIR}/DEBIAN/control" <<EOF
Package: xpdf-pr
Version: ${VERSION}
Architecture: ${ARCH}
Maintainer: Policy Reporter <developers@policyreporter.com>
Depends: ${DEPENDS}
Section: text
Priority: optional
Homepage: https://github.com/PolicyReporter/xpdf-pr
Description: PolicyReporter fork of the xpdf command-line PDF tools
 xpdf ${VERSION} command-line tools (pdftotext, pdfinfo, pdfdetach, pdffonts,
 pdfimages, pdftops, pdftoppm, pdftopng), patched to allow text extraction
 regardless of the document's copy permission. pdftotext uses the xpdf 3.04
 text extractor and pdftohtml is pdftohtml 0.39; xpdf's own are installed as
 pdftotext-xpdf and pdftohtml-xpdf.
EOF

mkdir -p "${OUT_DIR}"
DEB="${OUT_DIR}/xpdf-pr_${VERSION}_${ARCH}.deb"
dpkg-deb --root-owner-group --build "${PKG_DIR}" "${DEB}"
echo "Built ${DEB}"
