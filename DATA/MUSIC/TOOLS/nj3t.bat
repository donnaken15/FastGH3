@echo off
if [%1]==[] goto :nofiles

mkdir "%~dp0fsbtmp" > nul
IF "%ab%"=="" set ab=64
"%~dp0sox" -m %* -S --multi-threaded -t wav - channels 2 rate 44100 norm -0.1 | "%~dp0helix" - "%~dp0fsbtmp\fastgh3_song.mp3" -B%ab% -M1 -u2 -q1
goto :EOF

:nofiles
echo Error: No input specified