@echo off
if [%1]==[] goto :nofiles

mkdir "%~dp0fsbtmp" 2>nul
IF "%ab%"=="" set ab=64
set "HELIX="%~dp0helix" - "%~dp0fsbtmp\fastgh3_song.mp3" -B%ab% -M1 -u2 -q1"
IF "%ff%"=="" (
	"%~dp0sox" -m %* -S --multi-threaded -t wav - channels 2 rate 44100 norm -0.1 | %HELIX%
) else (
	setlocal enabledelayedexpansion
	set mix=
	set count=0
	for %%x in (%*) do ( set "mix=!mix! -i %%x" && set /a count+=1 )
	"%ff%" -hide_banner !mix! -filter_complex amix=inputs=!count!:duration=longest -ac 2 -ar 44100 -f wav pipe: | %HELIX%
	endlocal
)
goto :EOF

:nofiles
echo Error: No input specified