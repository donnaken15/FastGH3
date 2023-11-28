:# REQUIRES (AND USES CYGWIN) SH, Node, and Guitar Hero SDK
@echo off
sh ./qcomp ./scripts ./!cache/scripts
node "%~dp0\GHSDK\sdk.js" createpak -out ..\..\DATA\PAK\qb.pak.xen -pab !cache
node "%~dp0\QBC\QBC.js" c -g gh3 engine_params.q -o ..\..\DATA\PAK\engine_params.qb.xen
:#del !cache /S/Q
:# save compiled to not rebuild them over and over
:# ALSO PAK BUILDING IS SLOW (sometimes)
