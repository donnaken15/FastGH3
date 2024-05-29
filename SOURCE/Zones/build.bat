:: REQUIRES (AND USES CYGWIN) SH, Node
@echo off
set "OKNOTOK=|| goto :fail"
pushd "%~dp0"
echo [97m^<^<^<^<^<^<         GLOBAL.PAK          ^>^>^>^>^>^>[0m
::echo [97m######   emptying output folder    ######[0m
del "!cache\*" /S/Q >nul 2>nul
rmdir !cache\zones\global !cache\zones !cache 2>nul
echo [92m######   compile highway sprites   ######[0m
pushd highway
..\buildtex >nul
popd
mkdir "!cache\zones\global"
copy "highway\__output.scn" "..\FastGH3\res\def.scn" /y > nul
copy "highway\__output.scn" "!cache\zones\global\global_gfx.scn.xen" /y >nul
copy "highway\__output.tex" "!cache\zones\global\global_gfx.tex.xen" /y >nul
echo [91m######      image generation       ######[0m


imggen load_disc.png
copy load_disc.img.xen ..\..\data\zones /y
del load_disc.img.xen /q


call :process_imgdir "root"
for /f "tokens=* delims=" %%D in ('dir root\*. /s /b') do call :process_imgdir "%%D"
echo [93m###### moving new generated images ######[0m
:: uhh

echo [38;2;95;95;255m######    creating/copying fonts   ######[0m
pushd fonts
..\mkfonts
popd
copy fonts\*.fnt.xen "!cache" > nul %OKNOTOK%
echo [38;2;255;127;0m###### compiling optional scripts  ######[0m
mkdir scripts 2>nul
pushd "!cache"
:: stupid
dash ../../q/qcomp ../scripts .
popd
echo [95m######        compiling PAK        ######[0m
del ..\..\DATA\ZONES\global.pak.xen 2>nul
..\q\pakdir !cache ..\..\DATA\ZONES\global -z
echo [92mDone![0m
if not exist "..\..\DATA\ZONES\global.pak.xen" ( echo [91mthe built global.pak cannot be found[0m & goto :fail )
del "!cache\*" /S/Q >nul 2>nul
rmdir !cache\zones\global !cache\zones !cache 2>nul

echo.
echo [97m^<^<^<^<^<^<        GLOBAL_SFX.PAK       ^>^>^>^>^>^>[0m
echo [31m###### RENAMING SOUND FILES SRSLY  ######[0m
pushd sounds
mkdir zones zones\global_sfx 2>nul
rename *.mp3 *.wav.xen
echo [97m######        compiling PAK        ######[0m
..\..\q\pakdir . ..\..\..\DATA\ZONES\global_sfx
:: actual cringe
rename *.wav.xen *.
rename *.wav *.mp3
popd
echo [92mDone![0m
if not exist "..\..\DATA\ZONES\global_sfx.pak.xen" ( echo [91mthe built global_sfx.pak cannot be found[0m & goto :fail )

echo.
echo [97m^<^<^<^<^<^<         DEFAULT.PAK         ^>^>^>^>^>^>[0m
::echo [96m######   emptying output folder    ######[0m
del "default\!cache\*" /S/Q > nul
::rmdir default\!cache 2>nul
mkdir "default\!cache" 2>nul
echo [96m######      image generation       ######[0m
imggen default\*.png default\*.jpg default\*.dds > nul
echo [96m######  generating default fonts   ######[0m
pushd default\fonts
..\..\mkfonts
copy *.fnt.xen "..\!cache" /y
::del *.fnt.xen /q
popd
echo [96m###### moving new generated images ######[0m
move default\*.img.xen "default\!cache" > nul
echo [96m######      generating fonts       ######[0m
pushd default
..\mkfonts
popd
echo [96m######        compiling PAK        ######[0m
..\q\pakdir "default\!cache" ..\..\DATA\ZONES\default >nul
echo [92mDone![0m
if not exist "..\..\data\zones\default.pak.xen" ( echo [91mthe built default.pak cannot be found[0m & goto :fail )

pushd ..\..\data\zones
copy "global.pak.xen" "!global.pak.xen" /y >nul
copy "global.pab.xen" "!global.pab.xen" /y >nul
copy "global_sfx.pak.xen" "!global_sfx.pak.xen" /y >nul
popd

if not "%1"=="notimeout" "%WINDIR%\system32\timeout" /t 2
popd
exit /b

:fail
echo [91mOne of the commands errored. Aborting.[0m
pause
popd
exit /b

:: absurd
:process_imgdir
	if exist "%~1" do goto imgdirerr
		imggen "%~1\*.png" "%~1\*.jpg" "%~1\*.dds" > nul %OKNOTOK%
		move "%~1\*.img.xen" "!cache" > nul %OKNOTOK%
		goto imgdirnext
	:imgdirerr
		echo [91mInvalid directory: %~1[0m
	:imgdirnext
	exit /b

