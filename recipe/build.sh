#!/bin/bash

autoreconf -fi

chmod +x configure
# Enable only SSE/SSE2 as these are supported on all 64bit CPUs
# https://unix.stackexchange.com/a/249384
./configure \
    --prefix="$PREFIX" \
    --libdir="$PREFIX/lib" \
    --with-default="$PREFIX" \
    --with-blas-libs="-lopenblas" \
    --enable-precompilation \
    --disable-openmp \
    --enable-sse \
    --enable-sse2 \
    --disable-sse3 \
    --disable-ssse3 \
    --disable-sse41 \
    --disable-sse42 \
    --disable-avx \
    --disable-avx2 \
    --disable-fma \
    --disable-fma4

make -j${CPU_COUNT}

if [ "$(uname)" != "Darwin" ]
then
    # appleclang crashes when following is run
    make check -j${CPU_COUNT}
fi
make install
