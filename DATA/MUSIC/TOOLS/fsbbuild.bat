
@echo off

rem arguments: song guitar rhythm preview filename

set argC=0
for %%x in (%*) do Set /A argC+=1

if %argC% NEQ 5 echo Invalid number of arguments && exit /b

del %5 /Q > nul

mkdir "%~dp0fsbtmp"

if /I NOT "%~f1"=="%~dp0fsbtmp\fastgh3_song.mp3" (
	CALL "%~dp0c128ks.exe" %1 "%~dp0fsbtmp\fastgh3_song.mp3"
)
if /I NOT "%~f1"=="%~dp0fsbtmp\fastgh3_guitar.mp3" (
	CALL "%~dp0c128ks.exe" %2 "%~dp0fsbtmp\fastgh3_guitar.mp3"
)
if /I NOT "%~f1"=="%~dp0fsbtmp\fastgh3_rhythm.mp3" (
	CALL "%~dp0c128ks.exe" %3 "%~dp0fsbtmp\fastgh3_rhythm.mp3"
)
if /I NOT "%~f1"=="%~dp0fsbtmp\fastgh3_preview.mp3" (
	CALL "%~dp0c128ks.exe" %4 "%~dp0fsbtmp\fastgh3_preview.mp3"
)
IF %ERRORLEVEL% EQU 222 echo Audio encoding failed, cannot continue. & EXIT /B

set b=%~dp0fsbtmp\fastgh3_
"%~dp0makefsb" "%b%guitar.mp3" "%b%rhythm.mp3" "%b%song.mp3" "%b%preview.mp3" %5

del "%~dp0fsbtmp" /S/Q
rmdir "%~dp0fsbtmp"
