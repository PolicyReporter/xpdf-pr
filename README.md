# xpdf-pr
Our custom version of the Xpdf library incorporating a different pdftohtml utility

# Compile
## Mac
Required libraries
```
brew install freetype openmotif
```

```
autoconf && \
./configure --enable-multithreaded --enable-cmyk --with-freetype2-library=$(brew --prefix freetype) --with-freetype2-includes="$(brew --prefix freetype)/include/freetype2" && \
make -j4
```