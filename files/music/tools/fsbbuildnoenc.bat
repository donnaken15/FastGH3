
@echo off

rem arguments: filename

set argC=0
for %%x in (%*) do Set /A argC+=1

if %argC% NEQ 1 echo Invalid number of arguments && exit /b

del %1 /Q > nul

"%~dp0fsbext" -d "%~dp0fastgh3_song" -s "%~dp0fastgh3_song.dat" -r "%~dp0fastgh3_song.fsb"
"%~dp0fsbext" -d "%~dp0fastgh3_guitar" -s "%~dp0fastgh3_guitar.dat" -r "%~dp0fastgh3_guitar.fsb"
"%~dp0fsbext" -d "%~dp0fastgh3_rhythm" -s "%~dp0fastgh3_rhythm.dat" -r "%~dp0fastgh3_rhythm.fsb"
"%~dp0fsbext" -d "%~dp0fastgh3_preview" -s "%~dp0fastgh3_preview.dat" -r "%~dp0fastgh3_preview.fsb"

MakeWAD "%~dp0fastgh3_guitar.fsb" "%~dp0fastgh3_rhythm.fsb" "%~dp0fastgh3_song.fsb" "%~dp0fastgh3_preview.fsb" %1
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
