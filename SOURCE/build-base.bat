@echo off
pushd "%~dp0"

echo ########## FASTGH3 ##########
call FastGH3\_monotest.bat
echo ##########  ZONES  ##########
call Zones\build.bat notimeout
echo ########## QSCRIPT ##########
call q\build.bat

:: TODO: run NSIS, but it's not in PATH

popd
