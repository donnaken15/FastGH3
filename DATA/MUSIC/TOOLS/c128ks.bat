@echo off
:# Constant 128kbps Stereo encoder
:# for (MP3, WAV, OGG, OPUS)
set ERRORLEVEL=0
if exist %1 goto :out
echo Invalid filename:
echo %1
set ERRORLEVEL=222
goto :EOF

:out
:# TESTING THIS OUT!! BASED FAST CHAD HELIX
"%~dp0sox" %1 -c 2 -r 44100 -S --multi-threaded -t wav - | "%~dp0helix" - %2 -B64 -M1 -u2 -q1

goto :EOF
