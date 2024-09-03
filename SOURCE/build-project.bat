@echo off
pushd "%~dp0"
set MSB="C:\Program Files (x86)\MSBuild\14.0\bin\MSBuild.exe"
set CONF=Release
echo ########## FASTGH3 ##########
%MSB% "%~dp0FastGH3.sln" /p:Configuration=%CONF%
::echo ########## FASTGH3 ##########
::%MSB% "%~dp0FastGH3\FastGH3.csproj" "/p:SolutionDir=%~dp0" /p:Configuration=Release
::echo ########## C128KS  ##########
::%MSB% "%~dp0Misc\c128ks.csproj" /p:Configuration=Release
::echo ########## PAKDIR  ##########
::%MSB% "%~dp0Misc\pakdir.csproj" /p:Configuration=Release
::call build-base.bat
::echo ########## PACKAGE ##########
::cmd /c call copy-all.bat
::cmd /c call bundle.bat
echo FINALLY!!!!!!
popd "%~dp0"

