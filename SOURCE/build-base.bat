@echo off
:: DO NOT RUN DIRECTLY

pushd "%~dp0"

echo ##########  ZONES  ##########
cmd /c call Zones\build.bat notimeout
:: THIS IS SO STUPID!!!!!
echo ########## QSCRIPT ##########
cmd /c call q\build.bat

:: TODO: run NSIS, but it's not in PATH

popd
