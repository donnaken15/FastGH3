:# REQUIRES (AND USES CYGWIN) SH
@echo off
sh ./qcomp ./scripts ../../DATA/scripts
node "%~dp0\QBC\QBC.js" c -g gh3 engine_params.q -o ..\..\DATA\PAK\engine_params.qb.xen
node "%~dp0\QBC/QBC.js" c -g gh3 _load_unpack.q
::robocopy ../../DATA/scripts test\scripts /MIR > NUL
::node "E:\GHWTDE\guitar-hero-sdk\sdk.js" createpak -out qb.pak.xen -pab test
