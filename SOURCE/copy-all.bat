@echo off
pushd "%~dp0.."
upx -9 --ultra-brute game!.exe -ogame.exe
echo Creating output directory...
del /S/Q __FINAL
mkdir __FINAL
for %%I in (
	ASPYRCONFIG.bat
	AWL.dll
	binkw32.dll
	FastGH3.exe
	fmodex.dll
	game.exe
	Ionic.Zip.Reduced.dll
	IntelLaptopGaming.dll
	mid2chart.exe
	register.bat
	settings.bat
	shuffle.bat
	Updater.exe
) do copy %%I __FINAL /y
mkdir __FINAL\DATA __FINAL\PLUGINS
pushd __FINAL\DATA
mkdir CACHE FXFILES HIGHWAYS MUSIC MUSIC\TOOLS MOVIES MOVIES\BIK PAK ZONES ..\THEMES
popd
::copy settings_Def.ini __FINAL\settings.ini /y
echo Copying files...
for %%I in (
	FXFILES
	MUSIC\TOOLS
) do copy DATA\%%I\*.* __FINAL\DATA\%%I\ /y
for %%I in (
	HIGHWAYS\__change.bat
	HIGHWAYS\_black.dds
	HIGHWAYS\highwaygen.exe
	MUSIC\fastgh3.dat.xen
	PAK\engine_params.qb.xen
	PAK\qb.pak.xen
	PAK\qb.pab.xen
	MOVIES\BIK\__change.bat
	MOVIES\BIK\__reset.bat
	MOVIES\BIK\usage.txt
	..\THEMES\__changePAK.bat
	..\THEMES\__changeTEX.bat
	"..\THEMES\FastGH3 Themes.url"
	..\THEMES\readme.txt
	ZONES\default.pak.xen
	ZONES\default.scn.xen
	ZONES\load_disc.img.xen
	ZONES\load_scr.img.xen
	ZONES\global.pak.xen
	ZONES\global.pab.xen
	ZONES\global_sfx.pak.xen
) do copy DATA\%%I __FINAL\DATA\%%I /y
for %%I in (
	core
	FastGH3
	modifiers
	NoteLimitFix
	RichPresence
	SongLimitFix
	TapHopoChord
) do copy PLUGINS\%%I.dll __FINAL\PLUGINS\%%I.dll /y
copy SOURCE\Misc\user.pak.xen __FINAL\DATA\user.pak.xen /y

:: not needed now, no crashes with that :D
::copy SOURCE\Misc\null.fsb __FINAL\DATA\MUSIC\fastgh3.fsb.xen /y
::copy SOURCE\Misc\null.pak __FINAL\DATA\PAK\song.pak.xen /y









