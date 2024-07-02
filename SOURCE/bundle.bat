@echo off
pushd "%~dp0..\__FINAL"
echo ########## CREATING RELEASE PACKAGES ##########
set "OUT=FastGH3_1.1.zip"
del output.txt
del PLUGINS\_log.txt
del "..\%OUT%"

:: PACKAGE __FINAL TO ZIP
::zip -9vrX -ds 1 -S -ic ..\__FINAL.zip * -x settings.ini -x tmp.txt
"C:\Program Files (x86)\7-zip\7z.exe" a -mm=Deflate -mfb=258 -mpass=15 -r "..\%OUT%" *
"date.exe" "+FastGH3 1.1-10999011043 | %%B %%d, %%Y" > tmp.txt
echo.------------------------^|------------------->>tmp.txt
echo.Portable version>>tmp.txt
echo.Downloaded from https://github.com/donnaken15/FastGH3>>tmp.txt
echo.More information at https://donnaken15.com/FastGH3>>tmp.txt
echo.-------------------------------------------->>tmp.txt
echo.To play the built-in song, simply launch>>tmp.txt
echo.game.exe if you haven^'t played another one yet.>>tmp.txt
echo.-------------------------------------------->>tmp.txt
echo.While it^'s possible to play this exclusively from a>>tmp.txt
echo.ZIP file, though settings would get saved to it, it>>tmp.txt
echo.is still recommended to extract this somewhere.>>tmp.txt
type tmp.txt | zip -z "..\%OUT%"
del tmp.txt

"C:\Program Files (x86)\NSIS\makensis.exe" "..\SOURCE\Installer\Main.nsi" /P4 /V3 
"C:\Program Files (x86)\NSIS\makensis.exe" "..\SOURCE\Installer\LITE.nsi" /P4 /V3 



popd