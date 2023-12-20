:: REQUIRES (AND USES CYGWIN) SH, Node, and Guitar Hero SDK
@echo off
set "OKNOTOK=|| goto :fail"
cd /d "%~dp0"
echo [97m^<^<^<^<^<^<         GLOBAL.PAK          ^>^>^>^>^>^>[0m
::echo [97m######   emptying output folder    ######[0m
del "!cache\*" /S/Q > nul
rmdir !cache\zones\global !cache\zones !cache 2>nul
echo [92m######   compile highway sprites   ######[0m
pushd highway
..\buildtex >nul
popd
mkdir "!cache\zones\global"
copy "highway\__output.scn" "!cache\zones\global\global_gfx.scn.xen" /y >nul
copy "highway\__output.tex" "!cache\zones\global\global_gfx.tex.xen" /y >nul
copy "highway\__output.scn" "..\..\DATA\ZONES\__themes\default.scn.xen" /y > nul
echo [91m######      image generation       ######[0m

imggen root\*.png root\*.jpg root\*.dds > nul %OKNOTOK%
echo [93m###### moving new generated images ######[0m
del ..\..\DATA\IMAGES /S/Q > nul
rmdir ..\..\DATA\IMAGES
mkdir ..\..\DATA\IMAGES 2>nul
move root\*.img.xen ..\..\DATA\IMAGES > nul %OKNOTOK%
echo [38;2;95;95;255m######     copying fonts (raw)     ######[0m
copy fonts\*.fnt.xen "!cache" > nul %OKNOTOK%
echo [38;2;255;127;0m###### compiling optional scripts  ######[0m
mkdir scripts 2>nul
zsh ../q/qcomp ./scripts ./!cache/scripts
echo [95m######        compiling PAK        ######[0m
del ..\..\data\zones\global.pak.xen 2>nul
cmd /c ..\q\sdk createpak -zone global -out ..\..\data\zones\global.pak.xen -pab "!cache" >nul
echo [92mDone![0m
if not exist "..\..\data\zones\global.pak.xen" ( echo [91mthe built global.pak cannot be found[0m & goto :fail )

echo.
echo [97m^<^<^<^<^<^<        GLOBAL_SFX.PAK       ^>^>^>^>^>^>[0m
echo [31m###### RENAMING SOUND FILES SRSLY  ######[0m
pushd sounds
:: because i just remembered git won't push the empty folders
:: and zones to build in SDK with zone parameter require it
mkdir zones zones\global_sfx 2>nul
rename *.mp3 *.wav.xen
echo [97m######        compiling PAK        ######[0m
cmd /c ..\..\q\sdk createpak -zone global_sfx -out ..\..\..\DATA\ZONES\global_sfx.pak.xen . >nul
:: actual cringe
rename *.wav.xen *.
rename *.wav *.mp3
popd
echo [92mDone![0m
if not exist "..\..\data\zones\global_sfx.pak.xen" ( echo [91mthe built global_sfx.pak cannot be found[0m & goto :fail )

echo.
echo [97m^<^<^<^<^<^<         DEFAULT.PAK         ^>^>^>^>^>^>[0m
::echo [96m######   emptying output folder    ######[0m
del "default\!cache\*" /S/Q > nul
mkdir default\!cache 2>nul
echo [96m######      image generation       ######[0m
imggen default\*.png default\*.jpg default\*.dds > nul

pushd default_scene
..\buildtex >nul
popd
copy "default_scene\__output.scn" "default\!cache\default.scn.xen" /y >nul
copy "default_scene\__output.tex" "default\!cache\default.tex.xen" /y >nul

echo [96m###### moving new generated images ######[0m
move default\*.img.xen "default\!cache" > nul
echo [96m######     copying fonts (raw)     ######[0m
copy default\*.fnt.xen "default\!cache" > nul
echo [96m######        compiling PAK        ######[0m
cmd /c ..\q\sdk createpak -out ..\..\DATA\ZONES\default.pak.xen "default\!cache" >nul
echo [92mDone![0m
if not exist "..\..\data\zones\default.pak.xen" ( echo [91mthe built default.pak cannot be found[0m & goto :fail )

pushd ..\..\data\zones
copy "global.pak.xen" "!global.pak.xen" /y >nul
copy "global.pab.xen" "!global.pab.xen" /y >nul
copy "global_sfx.pak.xen" "!global_sfx.pak.xen" /y >nul
popd

if not "%1"=="notimeout" "%WINDIR%\system32\timeout" /t 2
exit /b

:fail
echo [91mOne of the commands errored. Aborting.[0m
pause
exit /b
