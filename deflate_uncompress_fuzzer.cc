// Author: SafeteeWow
// Fuzzing test decompressing raw deflate format

#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>

#define ZLIB_CONST 1   // To enable "const" keyword support in zlib.
#include "zlib.h"

static Bytef buffer[1024 * 1024] = { 0 };

// Entry point for LibFuzzer.
extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
	uLongf buffer_length = static_cast<uLongf>(sizeof(buffer));
	z_stream strm;
	strm.zalloc = Z_NULL;
	strm.zfree = Z_NULL;
	strm.opaque = Z_NULL;
	strm.avail_in = size;
	strm.next_in = data;
	strm.avail_out = buffer_length;
	strm.next_out = buffer;
  	if (inflateInit2(&strm, -15) != Z_OK) {
		return 1;
  	}
	int inflate_ret;
    inflate_ret = inflate(&strm, Z_FINISH);
    if (inflateEnd(&strm) != Z_OK) {
		return 1;
	}
	if (inflate_ret != Z_OK) {
		return 0;
	}
	return 0;
}
