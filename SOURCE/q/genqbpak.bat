mkdir tmp
copy _load_unpack.qb.xen tmp\0xFA576113.qb
node "E:\GHWTDE\guitar-hero-sdk\sdk.js" createpak -out _load_unpack.pak.xen -pab tmp
del tmp /S/Q
rmdir tmp
