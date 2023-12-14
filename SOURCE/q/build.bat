:: REQUIRES (AND USES CYGWIN) SH, Node, and Guitar Hero SDK
@echo off
sh ./qcomp ./load_unpak ./!tmp
sh ./qcomp ./scripts ../../DATA/scripts
node "%~dp0\QBC\QBC.js" c -g gh3 engine_params.q -o ..\..\DATA\PAK\engine_params.qb.xen
sdk createpak -out ..\..\DATA\PAK\qb.pak.xen -pab !tmp
::del !tmp /S/Q
::rmdir !tmp

::robocopy ../../DATA/scripts test\scripts /MIR > NUL
::node "%~dp0\GHSDK\sdk.js" createpak -out qb.pak.xen -pab test
