:# REQUIRES (AND USES CYGWIN) SH
@echo off
sh ./qcomp ./scripts ../../DATA/scripts
robocopy ../../DATA/scripts test\scripts /MIR > NUL
node "E:\GHWTDE\guitar-hero-sdk\sdk.js" createpak -out qb.pak.xen -pab test
node "QBC/QBC.js" c -g gh3 _load_unpack.q
:#mkdir tmp
:#copy _load_unpack.qb.xen tmp\0xFA576113.qb
:#node "E:\GHWTDE\guitar-hero-sdk\sdk.js" createpak -out _load_unpack.pak.xen -pab tmp
:#del tmp /S/Q
:#rmdir tmp
