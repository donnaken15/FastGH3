@echo off
cmd /c build.bat
cd ..\..
start "" game
:: doesnt focus if i use start
