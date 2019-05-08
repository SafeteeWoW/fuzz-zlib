# fuzz-zlib

Fuzz testing [Zlib](https://github.com/madler/zlib) and record test result

zlib is written by Jean-loup Gailly and Mark Adler,
unlicensed under the Zlib license

The fuzzing code is modified from the [oss-fuzz](https://github.com/google/oss-fuzz) project,
Licensed under Apache-2.0.

The fuzzing is done by libfuzz with LLVM 8.0.
