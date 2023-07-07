:# REQUIRES (AND USES CYGWIN) SH
@echo off
sh ./qcomp ./scripts ../../DATA/scripts
imggen images\*
del ..\..\DATA\IMAGES\* /S/Q > nul
move images\*.img.xen ..\..\DATA\IMAGES > nul
node "QBC/QBC.js" c -g gh3 _load_unpack.q
