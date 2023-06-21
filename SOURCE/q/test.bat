@echo off
sh ./qcomp ./scripts ./!cache/scripts
node "E:\GHWTDE\guitar-hero-sdk\sdk.js" createpak -out ..\..\DATA\PAK\qb.pak.xen -pab !cache
cd ..\..
start "" game!
