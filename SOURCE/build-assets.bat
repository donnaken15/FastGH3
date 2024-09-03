@echo off
pushd "%~dp0"

echo ##########  ZONES  ##########
cmd /c call Zones\build.bat notimeout
:: THIS IS SO STUPID!!!!!
echo ########## QSCRIPT ##########
cmd /c call q\build.bat

popd
