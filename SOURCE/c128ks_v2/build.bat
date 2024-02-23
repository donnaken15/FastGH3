@pushd "%~dp0"
@set "OUT=..\..\DATA\MUSIC\TOOLS\c128ks.exe"
@call mcs @stdopt.txt main.cs -out:"%OUT%"
@"C:\Program Files\PackageManagement\NuGet\Packages\ilmerge.3.0.41\tools\net452\ILMerge.exe" "%OUT%" /out:"tmp.exe" && del "%OUT%" && move "tmp.exe" "%OUT%"
@call ..\Misc\stripversion.bat "%OUT%"
@popd