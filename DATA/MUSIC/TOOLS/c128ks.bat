@echo off
set ERRORLEVEL=0
if exist %1 goto :out
echo Invalid filename:
echo %1
set ERRORLEVEL=222
goto :EOF

:out
IF "%ab%"=="" set ab=64
IF "%bm%"=="" set bm=B
"%~dp0sox" %1 -c 2 -r 44100 -V4 --multi-threaded -t wav - | "%~dp0helix" - %2 -%bm%%ab% -M1 -u2 -q1

goto :EOF
