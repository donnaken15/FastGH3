:: REQUIRES (AND USES CYGWIN) SH
@dash ./qcomp !mods ..\..\DATA\MODS
copy ..\..\DATA\MODS\*.qb.xen !mods\disabled /y
copy ..\..\DATA\MODS\*.pak.xen !mods\disabled /y
copy ..\..\DATA\MODS\disabled\*.qb.xen !mods\disabled /y
copy ..\..\DATA\MODS\disabled\*.pak.xen !mods\disabled /y
::pakdir ..\..\DATA\MODS\disabled\eval ..\..\DATA\MODS\disabled\eval
::@cd ../..
::@start "" game!
