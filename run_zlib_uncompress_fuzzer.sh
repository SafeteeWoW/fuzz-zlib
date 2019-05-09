#!/bin/bash -eu

set -u
set -e
set -x
proj_root="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

if [[ -z "${PREFIX:-}" ]]; then
  PREFIX="$proj_root/install"
fi

mkdir -p "$proj_root/outputs/zlib_uncompress"
"$PREFIX/bin/zlib_uncompress_fuzzer" -max_len=205000 -seed=1 -timeout=60 "$proj_root/outputs/zlib_uncompress"
