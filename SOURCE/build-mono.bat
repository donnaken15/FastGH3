::
:: build projects with mono
:: -------------------------
:: for GH3+, it's recommended you use Visual Studio
:: directly to build the library and its plugins
::
:: DO NOT USE RIGHT NOW
@echo off
echo ########## FASTGH3 ##########
"%~dp0FastGH3\_monotest.bat"
pushd "%~dp0"
echo ########## C128KS  ##########
call Misc\c128ks_mono.bat

:: stupid mono
::echo ########## .NETZIP ##########
:: try to have this build only once since nothing else is being updated for it
:: no longer necessary because the launcher project uses it directly
::set "OUT=bin\Release\Ionic.Zip.Reduced.dll"
::pushd "DotNetZip\Zip Reduced"
::if not exist "%OUT%" (
::	call mcs -target:library -sdk:2 -out:"%OUT%" -debug -delaysign- -optimize+ ..\Zip\ComHelper.cs ..\Zip\EncryptionAlgorithm.cs ..\Zip\Events.cs ..\Zip\Exceptions.cs ..\Zip\ExtractExistingFileAction.cs ..\Zip\FileSelector.cs ..\Zip\OffsetStream.cs ..\Zip\Shared.cs ..\Zip\WinZipAes.cs ..\Zip\ZipConstants.cs ..\Zip\ZipCrypto.cs ..\Zip\ZipDirEntry.cs ..\Zip\ZipEntry.cs ..\Zip\ZipEntry.Extract.cs ..\Zip\ZipEntry.Read.cs ..\Zip\ZipEntry.Write.cs ..\Zip\ZipEntrySource.cs ..\Zip\ZipErrorAction.cs ..\Zip\ZipFile.AddUpdate.cs ..\Zip\ZipFile.Check.cs ..\Zip\ZipFile.cs ..\Zip\ZipFile.Events.cs ..\Zip\ZipFile.Extract.cs ..\Zip\ZipFile.Read.cs ..\Zip\ZipFile.Save.cs ..\Zip\ZipFile.SaveSelfExtractor.cs ..\Zip\ZipFile.Selector.cs ..\Zip\ZipFile.x-IEnumerable.cs ..\Zip\ZipInputStream.cs ..\Zip\ZipOutputStream.cs ..\Zip\ZipSegmentedStream.cs ..\BZip2\BitWriter.cs ..\BZip2\BZip2Compressor.cs ..\BZip2\BZip2InputStream.cs ..\BZip2\BZip2OutputStream.cs ..\BZip2\ParallelBZip2OutputStream.cs ..\BZip2\Rand.cs ..\Zlib\Deflate.cs ..\Zlib\DeflateStream.cs ..\Zlib\GZipStream.cs ..\Zlib\Inflate.cs ..\Zlib\InfTree.cs ..\Zlib\ParallelDeflateOutputStream.cs ..\Zlib\Tree.cs ..\Zlib\Zlib.cs ..\Zlib\ZlibBaseStream.cs ..\Zlib\ZlibCodec.cs ..\Zlib\ZlibConstants.cs ..\Zlib\ZlibStream.cs ..\CommonSrc\CRC32.cs ..\SolutionInfo.cs
::) else (
::	echo DotNetZip is already built.
::)
::popd

popd
