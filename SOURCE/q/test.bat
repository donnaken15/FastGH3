:# REQUIRES (AND USES CYGWIN) SH
@echo off
sh ./qcomp scripts ../../DATA/scripts
imggen images\*
del ..\..\DATA\IMAGES\* /S/Q > nul
move images\*.img.xen ..\..\DATA\IMAGES > nul
cd ../..
start "" game!
:# doesnt focus if i use start