@echo off
::pushd "%~dp0"
::popd
echo BROKEN RIGHT NOW!!!1!! SDFGHJKLSDFGHJKLSDFGHJKL
exit /b 1
node GenerateLD.js
set OUT=..\..\FastGH3.exe
::set RES=FastGH3.P.res.resources
::call resgen /useSourcePath /compile P\res.resx
::move P\res.resources "P\%RES%"
set DNZPATH=..\dependencies\DotNetZip
call mcs -target:exe -debug- -nostdlib- -optimize+ ^
	-reference:System.dll ^
	-reference:System.Net.dll ^
	-reference:System.XML.dll ^
	-reference:System.Drawing.dll ^
	-reference:System.Windows.Forms.dll ^
	--runtime:v4 -sdk:4 -langversion:3 -platform:anycpu ^
	-out:"%OUT%" -main:Launcher -define:PC_ONLY;NO_ZLIB;SHARPDEV ^
	..\dependencies\Queenbee\QueenbeeParser\*.cs ^
	..\dependencies\Queenbee\QueenbeeParser\Pak\*.cs ^
	..\dependencies\Queenbee\QueenbeeParser\Qb\*.cs ^
	..\dependencies\Queenbee\QueenbeeParser\Qb\base\*.cs ^
	..\dependencies\mid2chart\*.cs ^
	..\dependencies\mid2chart\NAudio\*.cs ^
	..\dependencies\mid2chart\NAudio\Midi\*.cs ^
	..\dependencies\mid2chart\NAudio\Utils\*.cs ^
	Launcher.cs LD.cs Sng.cs WZK64.cs ^
	diags\*.cs diags\conf\*.cs diags\mods\*.cs ^
	deps\ChartEdit\*.cs deps\SubstrExt.cs ^
	%DNZPATH%\Zip\*.cs ^
	%DNZPATH%\BZip2\*.cs ^
	%DNZPATH%\Zlib\*.cs ^
	%DNZPATH%\CommonSrc\CRC32.cs
	:: TODO: support SZL
:: -win32icon:P\note.ico

::echo.
::echo.
::echo ###################################                                     Raw file size:
::wc -c "%OUT%" 2>nul
::echo.
::echo.
::call "..\Misc\stripversion.bat" "%OUT%"
::echo ###################################                                     Removed resources and reloc:
::wc -c "%OUT%" 2>nul
::echo.
::echo.
::::NetCompressor "%OUT%" "%OUT%" -gz -a "P\AssemblyInfo.cs" -i "P\note.ico"
::echo ###################################                                     Compressed:
::wc -c "%OUT%" 2>nul
::echo.
::echo.

::echo Copy DotNetZip DLL
::copy "..\DotNetZip\Zip Reduced\bin\Release\Ionic.Zip.Reduced.dll" ..\..\ /y

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
