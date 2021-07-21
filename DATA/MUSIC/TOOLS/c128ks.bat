@echo off
set ERRORLEVEL=0
if exist %1 goto :out
echo Invalid filename:
echo %1
set ERRORLEVEL=222
goto :EOF

:out
"%~dp0sox" %1 -c 2 -r 44100 -S --multi-threaded -t wav - | "%~dp0lame" --cbr -b 128 --resample 44100 -m j - %2
:# WHY IS SOX SLOW AT IT'S OWN GAME -C 128
goto :EOF
