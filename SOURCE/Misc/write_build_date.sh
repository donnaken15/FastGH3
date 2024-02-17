#!/bin/dash
date +%s | xargs printf '%08X\n' | xxd -r -ps > "$(dirname "$0")/../../DATA/MUSIC/TOOLS/bt.bin"