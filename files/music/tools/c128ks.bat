@echo off
:# Constant 128kbps Stereo encoder
:# for (MP3, WAV (not XBADPCM), OGG, OPUS)
set ERRORLEVEL=0
if exist %1 goto :out
echo Invalid filename:
echo %1
set ERRORLEVEL=222
goto :EOF

:out

echo "%~dp0sox" %1 -c 2 -r 33075 -S --multi-threaded -t wav "%~2.pcm.wav" speed 0.985
"%~dp0sox" %1 -c 2 -r 33075 -S --multi-threaded -t wav "%~2.pcm.wav" speed 0.985
"%~dp0xbadpcm" "%~2.pcm.wav" %2
del "%~2.pcm"

goto :EOF
