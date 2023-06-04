@echo off
if [%1]==[] goto :nofiles

echo Merging extra tracks
mkdir fastgh3_song > nul
:# nj3t [audio track] [audio track] [audio track]
"%~dp0sox" -m %* -S --multi-threaded -t wav "%~dp0fastgh3_song\tmp.wav" channels 2 rate 33075 norm -0.1 speed 0.985
"%~dp0XBADPCM" "%~dp0fastgh3_song\tmp.wav" "%~dp0fastgh3_song\fastgh3_song.wav"
del "%~dp0fastgh3_song\tmp.wav"
goto :EOF

:nofiles
echo Error: No input specified