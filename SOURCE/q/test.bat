:# REQUIRES (AND USES CYGWIN) SH
@echo off
sh ./qcomp scripts ../../DATA/scripts
echo image generation
imggen images\* > nul
echo refreshing compiled folder
del ..\..\DATA\IMAGES\* /S/Q > nul
echo moving new generated images
move images\*.img.xen ..\..\DATA\IMAGES > nul
cd ../..
start "" game!
:# doesnt focus if i use start