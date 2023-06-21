:# REQUIRES (AND USES CYGWIN) SH, Node, and Guitar Hero SDK
@echo off
sh ./qcomp ./scripts ./!cache/scripts
node "E:\GHWTDE\guitar-hero-sdk\sdk.js" createpak -out ..\..\DATA\PAK\qb.pak.xen -pab !cache
:#del !cache /S/Q
:# save compiled to not rebuild them over and over
:# ALSO PAK BUILDING IS SLOW (sometimes)
