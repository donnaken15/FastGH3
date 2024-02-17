@echo off
pushd "%~dp0"
node GenerateLD.js
set OUT=..\..\FastGH3.exe
::set RES=FastGH3.P.res.resources
::call resgen /useSourcePath /compile P\res.resx
::move P\res.resources "P\%RES%"
call mcs -target:exe -g -nostdlib- -optimize+ ^
	-lib:"..\DotNetZip\Zip Reduced\bin\Release" ^
	-reference:System.dll ^
	-reference:System.Net.dll ^
	-reference:System.XML.dll ^
	-reference:System.Drawing.dll ^
	-reference:System.Windows.Forms.dll ^
	-reference:Ionic.Zip.Reduced.dll ^
	--runtime:v4 -sdk:4 -langversion:3 -platform:anycpu ^
	-out:"%OUT%" -main:Launcher -win32icon:note.ico ^
	Queenbee\*.cs Queenbee\Pak\*.cs Queenbee\Qb\*.cs ^
	Queenbee\Qb\base\*.cs *.cs ChartEdit\*.cs P\*.cs
:: 275kb
::del "P\%RES%"

set "ILMRG=C:\Program Files\PackageManagement\NuGet\Packages\ilmerge.3.0.41\tools\net452\ILMerge.exe"
"%ILMRG%" "%OUT%" "..\DotNetZip\Zip Reduced\bin\Release\Ionic.Zip.Reduced.dll" /out:"tmp.exe" && del "%OUT%" && move "tmp.exe" "%OUT%"

::set "ILSTR=E:\WZKRice\tools\src\MiniSCT\bin\Release\BrokenEvent.ILStrip.CLI.exe"
::"%ILSTR%" -u "%OUT%" "%OUT%"
mpress -s -m "%OUT%"
du -h "%OUT%"
dash "../Misc/write_build_date.sh"
popd
:: 264kb
:: LARGER THAN CSC MAKES IT >:(
:: original: 250kb
:: thinking over it again if it could be that it doesn't optimize
:: unreachable code or compilation based on const values or something
::Queenbee\Qb\Script\*.cs
::-resource:"P\%RES%" -re "%RES%"
popd