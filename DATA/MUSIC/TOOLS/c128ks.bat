@echo off
:# Constant 128kbps Stereo encoder
:# for (MP3, WAV, OGG)
set ERRORLEVEL=0
if exist %1 goto :out
echo Invalid filename:
echo %1
set ERRORLEVEL=222
goto :EOF

:out
:# does multithreaded actually work
SET LPARAMS=--cbr -b 128 --resample 44100 -m j
IF "%~x1" EQU ".ogg" ( "%~dp0sox" %1 -c 2 -r 44100 -S --multi-threaded -t wav - | "%~dp0lame" %LPARAMS% - %2 ) ^
ELSE ( "%~dp0lame" %LPARAMS% %1 %2 )
:# WHY IS SOX SLOW AT IT'S OWN GAME -C 128
:# i bet songlist_editor did this faster somehow
goto :EOF
