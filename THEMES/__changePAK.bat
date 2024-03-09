@echo off
pushd %~dp0
copy GH3Default\global_sfx.pak.xen ..\DATA\ZONES /y
:# ^ fallback
copy "%~1\global.pak.xen" ..\DATA\ZONES /y
copy "%~1\global.pab.xen" ..\DATA\ZONES /y
copy "%~1\global_sfx.pak.xen" ..\DATA\ZONES /y
popd