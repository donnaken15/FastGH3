@echo off
if [%1]==[] goto :nofiles

echo Merging extra tracks
mkdir fsbtmp > nul
:# nj3t [audio track] [audio track] [audio track]
"%~dp0sox" -m %* -S --multi-threaded -t wav - channels 2 rate 44100 norm -0.1 | "%~dp0helix" - "%~dp0fsbtmp\fastgh3_song.mp3" -B64 -M1 -u2 -q1
goto :EOF

:nofiles
echo Error: No input specified