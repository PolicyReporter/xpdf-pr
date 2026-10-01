#!/bin/bash
# Build xpdf-pr .deb packages.
# One Docker container per target architecture so each binary links against the same glibc/ABI.
#
# Usage: scripts/build-deb.sh
#   ARCHS       space-separated Debian architectures (default "amd64 arm64")
#   BASE_IMAGE  build image (default ubuntu:26.04, bumblebee's base image)
# Output: dist/xpdf-pr_<version>_<arch>.deb
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${SRC_DIR}/dist"
BASE_IMAGE="${BASE_IMAGE:-ubuntu:26.04}"
read -r -a ARCHS <<<"${ARCHS:-amd64 arm64}"

mkdir -p "${OUT_DIR}"

for ARCH in "${ARCHS[@]}"; do
  echo "=== Building .deb for ${ARCH} in ${BASE_IMAGE} ==="
  docker run --rm \
    --platform "linux/${ARCH}" \
    -v "${SRC_DIR}:/src:ro" \
    -v "${OUT_DIR}:/out" \
    "${BASE_IMAGE}" /src/scripts/package-deb.sh
done

ls -lh "${OUT_DIR}"/*.deb
