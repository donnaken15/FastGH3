@echo off
start /b /wait "" "resourcehacker" -open "%~1" -save "%~1" -action delete VERSIONINFO,, -action delete MANIFEST,,
:: COMPLETELY MORONIC
if "%STUPID%"=="true" ( exit /b )
call stripreloc /b "%~1"
