@echo off
pushd "%~dp0"
echo BROKEN RIGHT NOW!!!1!! SDFGHJKLSDFGHJKLSDFGHJKL
exit /b 1
node GenerateLD.js
set OUT=..\..\FastGH3.exe
::set RES=FastGH3.P.res.resources
::call resgen /useSourcePath /compile P\res.resx
::move P\res.resources "P\%RES%"
set DNZPATH=..\DotNetZip
call mcs -target:exe -debug- -nostdlib- -optimize+ ^
	-reference:System.dll ^
	-reference:System.Net.dll ^
	-reference:System.XML.dll ^
	-reference:System.Drawing.dll ^
	-reference:System.Windows.Forms.dll ^
	--runtime:v4 -sdk:4 -langversion:3 -platform:anycpu ^
	-out:"%OUT%" -main:Launcher -define:PC_ONLY;NO_ZLIB ^
	..\Queenbee\QueenbeeParser\*.cs ^
	..\Queenbee\QueenbeeParser\Pak\*.cs ^
	..\Queenbee\QueenbeeParser\Qb\*.cs ^
	..\Queenbee\QueenbeeParser\Qb\base\*.cs ^
	*.cs ChartEdit\*.cs P\*.cs ^
	%DNZPATH%\Zip\ComHelper.cs ^
	%DNZPATH%\Zip\EncryptionAlgorithm.cs ^
	%DNZPATH%\Zip\Events.cs ^
	%DNZPATH%\Zip\Exceptions.cs ^
	%DNZPATH%\Zip\ExtractExistingFileAction.cs ^
	%DNZPATH%\Zip\FileSelector.cs ^
	%DNZPATH%\Zip\OffsetStream.cs ^
	%DNZPATH%\Zip\Shared.cs ^
	%DNZPATH%\Zip\WinZipAes.cs ^
	%DNZPATH%\Zip\ZipConstants.cs ^
	%DNZPATH%\Zip\ZipCrypto.cs ^
	%DNZPATH%\Zip\ZipDirEntry.cs ^
	%DNZPATH%\Zip\ZipEntry.cs ^
	%DNZPATH%\Zip\ZipEntry.Extract.cs ^
	%DNZPATH%\Zip\ZipEntry.Read.cs ^
	%DNZPATH%\Zip\ZipEntry.Write.cs ^
	%DNZPATH%\Zip\ZipEntrySource.cs ^
	%DNZPATH%\Zip\ZipErrorAction.cs ^
	%DNZPATH%\Zip\ZipFile.AddUpdate.cs ^
	%DNZPATH%\Zip\ZipFile.Check.cs ^
	%DNZPATH%\Zip\ZipFile.cs ^
	%DNZPATH%\Zip\ZipFile.Events.cs ^
	%DNZPATH%\Zip\ZipFile.Extract.cs ^
	%DNZPATH%\Zip\ZipFile.Read.cs ^
	%DNZPATH%\Zip\ZipFile.Save.cs ^
	%DNZPATH%\Zip\ZipFile.SaveSelfExtractor.cs ^
	%DNZPATH%\Zip\ZipFile.Selector.cs ^
	%DNZPATH%\Zip\ZipFile.x-IEnumerable.cs ^
	%DNZPATH%\Zip\ZipInputStream.cs ^
	%DNZPATH%\Zip\ZipOutputStream.cs ^
	%DNZPATH%\Zip\ZipSegmentedStream.cs ^
	%DNZPATH%\BZip2\BitWriter.cs ^
	%DNZPATH%\BZip2\BZip2Compressor.cs ^
	%DNZPATH%\BZip2\BZip2InputStream.cs ^
	%DNZPATH%\BZip2\BZip2OutputStream.cs ^
	%DNZPATH%\BZip2\ParallelBZip2OutputStream.cs ^
	%DNZPATH%\BZip2\Rand.cs ^
	%DNZPATH%\Zlib\Deflate.cs ^
	%DNZPATH%\Zlib\DeflateStream.cs ^
	%DNZPATH%\Zlib\GZipStream.cs ^
	%DNZPATH%\Zlib\Inflate.cs ^
	%DNZPATH%\Zlib\InfTree.cs ^
	%DNZPATH%\Zlib\ParallelDeflateOutputStream.cs ^
	%DNZPATH%\Zlib\Tree.cs ^
	%DNZPATH%\Zlib\Zlib.cs ^
	%DNZPATH%\Zlib\ZlibBaseStream.cs ^
	%DNZPATH%\Zlib\ZlibCodec.cs ^
	%DNZPATH%\Zlib\ZlibConstants.cs ^
	%DNZPATH%\Zlib\ZlibStream.cs ^
	%DNZPATH%\CommonSrc\CRC32.cs
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
::NetCompressor "%OUT%" "%OUT%" -gz -a "P\AssemblyInfo.cs" -i "P\note.ico"
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
