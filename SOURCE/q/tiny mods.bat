:# REQUIRES (AND USES CYGWIN) SH
@sh ./qcomp !mods ..\..\DATA\MODS
copy ..\..\DATA\MODS\*.qb.xen !mods\disabled /y
copy ..\..\DATA\MODS\*.pak.xen !mods\disabled /y
copy ..\..\DATA\MODS\disabled\*.qb.xen !mods\disabled /y
copy ..\..\DATA\MODS\disabled\*.pak.xen !mods\disabled /y
:#@cd ../..
:#@start "" game!
