@echo off
set ERRORLEVEL=0
if exist %1 goto :out
echo Invalid filename:
echo %1
set ERRORLEVEL=222
goto :EOF

:out
IF "%ab%"=="" set ab=64
"%~dp0sox" %1 -c 2 -r 44100 -S --multi-threaded -t wav - | "%~dp0helix" - %2 -B%ab% -M1 -u2 -q1

goto :EOF
