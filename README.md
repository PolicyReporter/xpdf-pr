# xpdf-pr
PolicyReporter's build of the [Xpdf](https://www.xpdfreader.com/) command-line tools, packaged as `.deb` for amd64 and arm64.

## Fork delta
The tree is pristine xpdf 4.06 sources plus the patches in [`patches/`](patches/), already applied.

| Patch | Why |
|---|---|
| `0001-okToCopy-always-true.patch` | Always allow text extraction, ignoring the PDF's copy permission.<br/>Documents that need a *user* password still can't be opened without it. |

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
`scripts/build.sh` holds the build options (CLI tools only, no Qt viewer, no fontconfig).

## Packaging
Each package is built in a Docker container of the target distro and architecture, so binaries link against the glibc/ABI that will run them.
```sh
scripts/build-deb.sh               # dist/xpdf-pr_4.06_{amd64,arm64}.deb
ARCHS=arm64 scripts/build-deb.sh   # a single architecture
```
