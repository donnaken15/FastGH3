@echo off
pushd %~dp0
copy GH3Default\global_sfx.pak.xen .. /y
:# ^ fallback
copy "%~1\global.pak.xen" .. /y
copy "%~1\global.pab.xen" .. /y
copy "%~1\global_sfx.pak.xen" .. /y
popd