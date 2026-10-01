#!/bin/bash
# Configure and build the xpdf-pr command-line tools with CMake.
# The single place the build options live; used by package-deb.sh.
# Install afterwards with: DESTDIR=... cmake --install <build-dir>
#
# Usage: scripts/build.sh [build-dir]   (default: ./build)
#   PREFIX            install prefix (default /usr)
#   CMAKE_EXTRA_ARGS  extra arguments passed to cmake
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${1:-${SRC_DIR}/build}"

# CLI tools only: the Qt viewer is skipped.
# Fontconfig is disabled to keep font lookup the same as the 3.04 build, which had no fontconfig support.
# shellcheck disable=SC2086
cmake -S "${SRC_DIR}" -B "${BUILD_DIR}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="${PREFIX:-/usr}" \
  -DMULTITHREADED=ON \
  -DSPLASH_CMYK=ON \
  -DOPI_SUPPORT=ON \
  -DNO_FONTCONFIG=ON \
  -DCMAKE_DISABLE_FIND_PACKAGE_Qt6Widgets=ON \
  -DCMAKE_DISABLE_FIND_PACKAGE_Qt5Widgets=ON \
  ${CMAKE_EXTRA_ARGS:-}

cmake --build "${BUILD_DIR}" -j "$(nproc 2>/dev/null || sysctl -n hw.ncpu)"
