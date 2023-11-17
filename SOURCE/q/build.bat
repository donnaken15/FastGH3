:# REQUIRES (AND USES CYGWIN) SH
@echo off
sh ./qcomp ./scripts ../../DATA/scripts
echo image generation
imggen images\* > nul
echo refreshing compiled folder
del ..\..\DATA\IMAGES\* /S/Q > nul
echo moving new generated images
move images\*.img.xen ..\..\DATA\IMAGES > nul
sh ./qcomp ./load_unpak ./!unpak_qbpak
node "E:\GHWTDE\guitar-hero-sdk\sdk.js" createpak -out ..\..\DATA\PAK\qb.pak.xen -pab !unpak_qbpak
