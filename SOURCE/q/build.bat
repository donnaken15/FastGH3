:: REQUIRES (AND USES CYGWIN) SH, Node, and Guitar Hero SDK
@echo off
sh ./qcomp ./scripts ./!cache/scripts
cmd /c sdk createpak -out ..\..\DATA\PAK\qb.pak.xen -pab !cache
:: kind of pointless to run every time but helps to reduce dbg.pak size
:: AND IT'S SLLOOOWWWWWWW (my fault probably)
where wsl 2>nul >nul && wsl -- dash ./qdbg ./scripts ./\!scripts_debug || dash ./qdbg ./scripts ./\!scripts_debug
cmd /c sdk createpak -out ..\..\DATA\PAK\dbg.pak.xen !scripts_debug
::del !cache /S/Q
:: save compiled to not rebuild them over and over
:: ALSO PAK BUILDING IS SLOW (sometimes)

:: TODO, replace GHSDK with a simple PAK creator?
:: and yeah, where's the C version of NodeQBC at, BLOOWM
