#!/bin/dash
dir="$(dirname "$0")/../../DATA/MUSIC/TOOLS"
mkdir "$dir" -p 2>/dev/null
date +%s | xargs printf '%08X\n' | xxd -r -ps > "$dir/bt.bin"