@echo off
if [%1]==[] goto :nofiles

echo Merging extra tracks
mkdir fsbtmp > nul
:# nj3t [audio track] [audio track] [audio track]
"%~dp0sox" -m %* -S --multi-threaded -t wav - channels 2 rate 44100 norm -0.1 | "%~dp0lame" %LPARAMS% - "%~dp0fsbtmp\fastgh3_song.mp3"
goto :EOF

:nofiles
echo Error: No input specified