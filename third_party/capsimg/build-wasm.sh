#!/bin/sh
# Radio Équinoxe (23/11/2026): build the SPS Decoder Library (CAPSImage) for
# Emscripten, as used by the browser build of Hatari in this repository.
# Source: unmodified FrodeSolheim/capsimg, commit ed4cb0912fb1a2a0d5203111c6f6abd50d411b56,
# plus CAPSImg/config.h (two lines, needed to compile with Emscripten).
# Usage (Emscripten 7.0.1 in PATH):  sh build-wasm.sh /path/to/output
set -e
OUT=${1:-capsimg-wasm}
mkdir -p "$OUT/obj" "$OUT/lib" "$OUT/include/caps"
OUT=$(cd "$OUT" && pwd)
cd "$(dirname "$0")/CAPSImg"
SRCS="../Core/BaseFile.cpp ../Core/BitBuffer.cpp ../Core/CRC.cpp ../Core/DiskFile.cpp ../Core/MemoryFile.cpp
../Codec/CTRawCodec.cpp ../Codec/CTRawCodecDecompressor.cpp ../Codec/DiskEncoding.cpp
CapsAPI.cpp CapsFDCEmulator.cpp CapsFile.cpp CapsFormatMFM.cpp CapsImage.cpp CapsImageStd.cpp
CapsLoader.cpp DiskImage.cpp DiskImageFactory.cpp StreamCueImage.cpp StreamImage.cpp stdafx.cpp"
for f in $SRCS; do
  em++ -O2 -w -fno-rtti -fno-exceptions -I../LibIPF -I../Codec -I../Core -I../Device -I. -c "$f" -o "$OUT/obj/$(basename "$f" .cpp).o"
done
emar rcs "$OUT/lib/libcapsimage.a" "$OUT"/obj/*.o
cp ../LibIPF/*.h "$OUT/include/caps/"
cp ../Core/CommonTypes.h "$OUT/include/caps/"
echo "OK: $OUT/lib/libcapsimage.a"
