@echo off
set ERRORLEVEL=0
if exist %1 goto :out
echo Invalid filename:
echo %1
set ERRORLEVEL=222
goto :EOF

:out
IF [%2]==[] ( set "out=%~dpn1.c128ks.mp3" ) else ( set "out=%~2" )
IF "%ar%"=="" set ar=32000
IF "%ab%"=="" set ab=64
IF "%bm%"=="" set bm=B
IF "%ac%"=="" set ac=1
IF "%ac%"=="1" ( set m=3 ) else ( set m=1 )
set "HELIX=wav - | "%~dp0helix" - "%out%" -%bm%%ab% -M%m% -U2 -q1 -A1 -D -EC"
IF "%ff%"=="" (
	"%~dp0sox" -V3 --multi-threaded "%~1" -c %ac% -r %ar% -t %HELIX%
) else (
	"%ff%" -hide_banner -i "%~1" -ac %ac% -ar %ar% -f %HELIX%
)
