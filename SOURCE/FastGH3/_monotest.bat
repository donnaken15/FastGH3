@echo off
pushd "%~dp0"
node GenerateLD.js
set OUT=..\..\FastGH3.exe
::set RES=FastGH3.P.res.resources
::call resgen /useSourcePath /compile P\res.resx
::move P\res.resources "P\%RES%"
call mcs -target:exe -debug- -nostdlib- -optimize+ ^
	-lib:"..\DotNetZip\Zip Reduced\bin\Release" ^
	-reference:System.dll ^
	-reference:System.Net.dll ^
	-reference:System.XML.dll ^
	-reference:System.Drawing.dll ^
	-reference:System.Windows.Forms.dll ^
	-reference:Ionic.Zip.Reduced.dll ^ 
	--runtime:v4 -sdk:4 -langversion:3 -platform:anycpu ^
	-out:"%OUT%" -main:Launcher ^
	Queenbee\*.cs Queenbee\Pak\*.cs Queenbee\Qb\*.cs ^
	Queenbee\Qb\base\*.cs *.cs ChartEdit\*.cs P\*.cs
:: -win32icon:P\note.ico

echo.
echo.
echo ###################################                                     Raw file size:
wc -c "%OUT%" 2>nul
echo.
echo.
call "..\Misc\stripversion.bat" "%OUT%"
echo ###################################                                     Removed resources and reloc:
wc -c "%OUT%" 2>nul
echo.
echo.
NetCompressor "%OUT%" "%OUT%" -gz -a "P\AssemblyInfo.cs" -i "P\note.ico"
echo ###################################                                     Compressed:
wc -c "%OUT%" 2>nul
echo.
echo.

echo Copy DotNetZip DLL
copy "..\DotNetZip\Zip Reduced\bin\Release\Ionic.Zip.Reduced.dll" ..\..\ /y

dash "../Misc/write_build_date.sh"
popd

:: (old)
:: 264kb
:: LARGER THAN CSC MAKES IT >:(
:: original: 250kb
:: thinking over it again if it could be that it doesn't optimize
:: unreachable code or compilation based on const values or something
::Queenbee\Qb\Script\*.cs
::-resource:"P\%RES%" -re "%RES%"
