
@echo off

rem arguments: filename

set argC=0
for %%x in (%*) do Set /A argC+=1

if %argC% NEQ 1 echo Invalid number of arguments && exit /b

del %1 /Q > nul

set b=%~dp0fsbtmp\fastgh3_
"%~dp0makefsb" "%b%guitar.mp3" "%b%rhythm.mp3" "%b%song.mp3" "%b%preview.mp3" %1

del "%~dp0fsbtmp" /S/Q
rmdir "%~dp0fsbtmp"
