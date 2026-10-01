#!/bin/bash
# Publish the packages for a tag as a GitHub release.
# Run by CI when a v* tag is pushed (.github/workflows/cpp.yml).
# If the release already exists the packages are uploaded to it.
#
# Usage: scripts/create-release.sh <tag> <package-file...>
#   e.g. scripts/create-release.sh v4.06 dist/*.deb
set -euo pipefail

TAG=$1
shift
VERSION=${TAG#v}
REPO="${REPO:-PolicyReporter/xpdf-pr}"

if gh release view "${TAG}" --repo "${REPO}" >/dev/null 2>&1; then
  gh release upload "${TAG}" --repo "${REPO}" --clobber "$@"
else
  gh release create "${TAG}" \
    --repo "${REPO}" \
    --title "xpdf-pr ${VERSION}" \
    --notes "xpdf-pr ${VERSION}: xpdf ${VERSION} command-line tools with the PolicyReporter patches (see \`patches/\`).

**Packages** (Ubuntu 26.04)
- \`xpdf-pr_${VERSION}_amd64.deb\`
- \`xpdf-pr_${VERSION}_arm64.deb\`

**Installation**
\`\`\`bash
wget https://github.com/${REPO}/releases/download/${TAG}/xpdf-pr_${VERSION}_<arch>.deb
sudo apt-get install -y ./xpdf-pr_${VERSION}_<arch>.deb
\`\`\`" \
    "$@"
fi

echo "Release: https://github.com/${REPO}/releases/tag/${TAG}"
