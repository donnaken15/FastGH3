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
set "HELIX="%~dp0helix" - "%~2" -%bm%%ab% -M1 -u2 -q1"
IF "%ff%"=="" (
	"%~dp0sox" "%~1" -c 2 -r 44100 -V4 --multi-threaded -t wav - | %HELIX%
) else (
	"%ff%" -hide_banner -i "%~1" -ac 2 -ar 44100 -f wav pipe: | %HELIX%
)

goto :EOF
