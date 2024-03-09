@pushd "%~dp0"
@set "OUT=..\..\DATA\MUSIC\TOOLS\c128ks.exe"
@call mcs @"%~dp0stdopt.txt" "%~dp0c128ks.cs" -out:"%OUT%"
@call ..\Misc\stripversion.bat "%OUT%"
@popd