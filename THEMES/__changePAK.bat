@echo off
pushd %~dp0
copy GH3Default\global_sfx.pak.xen ..\DATA\ZONES\global_sfx.pak /y 2>nul
copy GH3Default\global_sfx.pak ..\DATA\ZONES\global_sfx.pak /y 2>nul
:: ^ fallback
copy "%~1\global.pak.xen" ..\DATA\ZONES\global.pak /y 2>nul
copy "%~1\global.pab.xen" ..\DATA\ZONES\global.pab /y 2>nul
copy "%~1\global_sfx.pak.xen" ..\DATA\ZONES\global_sfx.pak /y 2>nul
copy "%~1\global.pak" ..\DATA\ZONES\global.pak /y 2>nul
copy "%~1\global.pab" ..\DATA\ZONES\global.pab /y 2>nul
copy "%~1\global_sfx.pak" ..\DATA\ZONES\global_sfx.pak /y 2>nul
popd