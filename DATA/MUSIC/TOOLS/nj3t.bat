@echo off
if [%1]==[] goto :nofiles

mkdir "%~dp0fsbtmp" 2>nul
IF "%ar%"=="" set ar=32000
IF "%ab%"=="" set ab=64
IF "%bm%"=="" set bm=B
IF "%ac%"=="" set ac=2
IF "%ac%"=="1" ( set m=3 ) else ( set m=1 )
set "HELIX=| "%~dp0helix" - "%~dp0fsbtmp\fastgh3_song.mp3" -%bm%%ab% -M%m% -X0 -U2 -Qquick -A1 -D -EC"
IF "%ff%"=="" (
	"%~dp0sox" -m %* -S --multi-threaded -t wav - channels %ac% rate %ar% norm -0.1 %HELIX%
) else (
	setlocal enabledelayedexpansion
	set mix=
	set count=0
	for %%x in (%*) do ( set "mix=!mix! -i %%x" && set /a count+=1 )
	"%ff%" -hide_banner !mix! -filter_complex amix=inputs=!count!:duration=longest -ac %ac% -ar %ar% -f wav pipe: %HELIX%
	endlocal
)
goto :EOF

:nofiles
echo Error: No input specified
