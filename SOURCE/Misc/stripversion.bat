@echo off
start /b /wait "" "resourcehacker" -open "%~1" -save "%~1" -action delete VERSIONINFO,, -action delete MANIFEST,,
:: COMPLETELY MORONIC
if /I "%STUPID%"=="true" ( exit /b )
ping localhost -n 3 >NUL
call stripreloc /b "%~1" || ( exit /b 0 ) & rem "I/O error 32 ☝️🤓" DON'T CARE STUPID!!!!!!
