:# REQUIRES (AND USES CYGWIN) SH, Node, and Guitar Hero SDK
@echo off
cd /d "%~dp0"
echo GLOBAL.PAK
echo ######   emptying output folder    ######
del "!cache\*" /S/Q > nul
rmdir !cache\zones\global !cache\zones !cache 2>nul
echo ######   compile highway sprites   ######
pushd highway
..\buildtex >nul
popd
mkdir "!cache\zones\global"
copy "highway\__output.scn" "!cache\zones\global\global_gfx.scn.xen" /y
copy "highway\__output.tex" "!cache\zones\global\global_gfx.tex.xen" /y
copy "highway\__output.scn" "..\..\DATA\ZONES\__themes\default.scn.xen" /y
echo ######      image generation       ######
imggen root\*.png root\*.dds > nul
echo ###### moving new generated images ######
move root\*.img.xen "!cache" > nul
echo ######     copying fonts (raw)     ######
copy fonts\*.fnt.xen "!cache" > nul
echo ###### compiling optional scripts  ######
sh ../q/qcomp ./zones/scripts ./!cache/scripts
echo ######        compiling PAK        ######
node "..\q\GHSDK\sdk.js" createpak -zone global -out ..\..\data\zones\global.pak.xen -pab "!cache"

echo GLOBAL_SFX.PAK
echo ###### RENAMING SOUND FILES SRSLY  ######
pushd sounds
rename *.mp3 *.wav.xen
node "..\..\q\GHSDK\sdk.js" createpak -zone global_sfx -out ..\..\..\DATA\ZONES\global_sfx.pak.xen .
rename *.wav.xen *.
rename *.wav *.mp3
popd

echo DEFAULT.PAK
echo ######   emptying output folder    ######
del "default\!cache\*" /S/Q > nul
::rmdir default\!cache 2>nul
mkdir default\!cache 2>nul
echo ######      image generation       ######
imggen default\*.png default\*.dds > nul
echo ###### moving new generated images ######
move default\*.img.xen "default\!cache" > nul
echo ######     copying fonts (raw)     ######
copy default\*.fnt.xen "default\!cache" > nul
node "..\q\GHSDK\sdk.js" createpak -out ..\..\DATA\ZONES\default.pak.xen "default\!cache"

pushd ..\..\data\zones
copy "global.pak.xen" "!global.pak.xen" /y
copy "global.pab.xen" "!global.pab.xen" /y
copy "global_sfx.pak.xen" "!global_sfx.pak.xen" /y
popd

exit /b
