#!/bin/bash -eu

set -u
set -e
set -x
proj_root="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

if [[ -z "${PREFIX:-}" ]]; then
  PREFIX="$proj_root/install"
fi

if [[ -z "${CC:-}" ]]; then
  CC="clang-8"
fi

if [[ -z "${CXX:-}" ]]; then
  CXX="clang-8"
fi

if [[ -z "${CFALGS:-}" ]]; then
  CFLAGS='-O3'
fi

if [[ -z "${CXXFLAGS:-}" ]]; then
  CXXFLAGS='-O3'
fi

cd "${proj_root}/zlib"
make clean
CC="$CC" CFLAGS='-g -fsanitize=fuzzer-no-link' ./configure --prefix $PREFIX
make -j$(nproc) clean
make -j$(nproc) all
make install
cd "${proj_root}"

# Do not make check as there are tests that fail when compiled with MSAN.
# make -j$(nproc) check

mkdir -p "$PREFIX/bin"

$CXX $CXXFLAGS -g -fsanitize=fuzzer -std=c++11 -I "$PREFIX/include" \
    "${proj_root}/zlib_uncompress_fuzzer.cc" -o "$PREFIX/bin/zlib_uncompress_fuzzer" \
    "$PREFIX/lib/libz.a"


for f in $(find "${proj_root}" -name '*_fuzzer.c'); do
    b="$(basename -s .c "$f")"
    $CC $CFLAGS -g -fsanitize=fuzzer -I "$PREFIX/include" "$f" -o "$PREFIX/bin/$b" \
    "$PREFIX/lib/libz.a"
done

