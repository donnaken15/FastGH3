@pushd "%~dp0"
@set DNZPATH=..\DotNetZip
@set OUT=..\..\__FINAL\Updater.exe
@call mcs Program.cs SimpleJSON.cs -debug- ^
	-sdk:2 -optimize+ -codepage:437 -nostdlib- ^
	/reference:System.Windows.Forms.dll ^
	--runtime:v1 -out:"%OUT%" ^
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
	%DNZPATH%\CommonSrc\CRC32.cs ^
	%DNZPATH%\SolutionInfo.cs
@call "%~dp0..\Misc\stripversion.bat" "%OUT%"
@call NetCompressor "%OUT%" "%OUT%" -gz
@call "%~dp0..\Misc\stripversion.bat" "%OUT%"
@copy "%OUT%" ..\..\Updater.exe /y
@"%OUT%"
@popd