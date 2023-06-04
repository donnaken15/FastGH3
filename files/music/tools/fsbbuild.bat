
@echo off

rem arguments: song guitar rhythm preview filename

set argC=0
for %%x in (%*) do Set /A argC+=1

if %argC% NEQ 5 echo Invalid number of arguments && exit /b

del "%~5" /Q > nul

mkdir "%~dp0fastgh3_song" > nul
mkdir "%~dp0fastgh3_guitar" > nul
mkdir "%~dp0fastgh3_rhythm" > nul
mkdir "%~dp0fastgh3_preview" > nul

if /I NOT "%~f1"=="%~dp0fastgh3_song\fastgh3_song.mp3" (
	CALL "%~dp0c128ks.bat" %1 "%~dp0fastgh3_song\fastgh3_song.wav"
)
if /I NOT "%~f1"=="%~dp0fastgh3_guitar\fastgh3_guitar.mp3" (
	CALL "%~dp0c128ks.bat" %2 "%~dp0fastgh3_guitar\fastgh3_guitar.wav"
)
if /I NOT "%~f1"=="%~dp0fastgh3_rhythm\fastgh3_rhythm.mp3" (
	CALL "%~dp0c128ks.bat" %3 "%~dp0fastgh3_rhythm\fastgh3_rhythm.wav"
)
if /I NOT "%~f1"=="%~dp0fastgh3_preview\fastgh3_preview.mp3" (
	CALL "%~dp0c128ks.bat" %4 "%~dp0fastgh3_preview\fastgh3_preview.wav"
)
IF %ERRORLEVEL% EQU 222 echo Audio encoding failed, cannot continue. & EXIT /B

"%~dp0fsbext" -d "%~dp0fastgh3_song" -s "%~dp0fastgh3_song.dat" -r "%~dp0fastgh3_song.fsb"
"%~dp0fsbext" -d "%~dp0fastgh3_guitar" -s "%~dp0fastgh3_guitar.dat" -r "%~dp0fastgh3_guitar.fsb"
"%~dp0fsbext" -d "%~dp0fastgh3_rhythm" -s "%~dp0fastgh3_rhythm.dat" -r "%~dp0fastgh3_rhythm.fsb"
"%~dp0fsbext" -d "%~dp0fastgh3_preview" -s "%~dp0fastgh3_preview.dat" -r "%~dp0fastgh3_preview.fsb"

MakeWAD "%~dp0fastgh3_guitar.fsb" "%~dp0fastgh3_rhythm.fsb" "%~dp0fastgh3_song.fsb" "%~dp0fastgh3_preview.fsb" %5
del "%~dp0fastgh3_song.fsb"
del "%~dp0fastgh3_guitar.fsb"
del "%~dp0fastgh3_rhythm.fsb"
del "%~dp0fastgh3_preview.fsb"
del "%~dp0fastgh3_song" /S/Q
del "%~dp0fastgh3_guitar" /S/Q
del "%~dp0fastgh3_rhythm" /S/Q
del "%~dp0fastgh3_preview" /S/Q
rmdir "%~dp0fastgh3_song"
rmdir "%~dp0fastgh3_guitar"
rmdir "%~dp0fastgh3_rhythm"
rmdir "%~dp0fastgh3_preview"
