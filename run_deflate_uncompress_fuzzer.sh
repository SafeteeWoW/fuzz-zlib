#!/bin/bash -eu

set -u
set -e
set -x
proj_root="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

if [[ -z "${PREFIX:-}" ]]; then
  PREFIX="$proj_root/install"
fi

mkdir -p "$proj_root/outputs/deflate_uncompress_fuzzer"
"$PREFIX/bin/deflate_uncompress_fuzzer" -max_len=205000 -seed=2 -timeout=60 "$proj_root/outputs/deflate_uncompress_fuzzer"
