@pushd "%~dp0"
@set "OUT=..\..\DATA\MUSIC\TOOLS\c128ks.exe"
@call mcs @stdopt.txt main.cs -out:"%OUT%"
@"C:\Program Files\PackageManagement\NuGet\Packages\ilmerge.3.0.41\tools\net452\ILMerge.exe" "%OUT%" /out:"tmp.exe" && del "%OUT%" && move "tmp.exe" "%OUT%"
@call "C:\Program Files (x86)\Resource Hacker\resourcehacker.exe" -open "%OUT%" -save "%OUT%" -action delete VERSIONINFO,,
@call stripreloc /b "%OUT%"
@popd