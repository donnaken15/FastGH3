:: REQUIRES (AND USES CYGWIN) SH, Node, and Guitar Hero SDK
@echo off
zsh ./qcomp ./load_unpak ./!tmp
zsh ./qcomp ./scripts ../../DATA/scripts
node "%~dp0\QBC\QBC.js" c -g gh3 engine_params.q -o ..\..\DATA\PAK\engine_params.qb.xen
cmd /c sdk createpak -out ..\..\DATA\PAK\qb.pak.xen -pab !tmp
:: kind of pointless to run every time but helps to reduce dbg.pak size
:: AND IT'S SLLOOOWWWWWWW (my fault probably)
::where wsl 2>nul >nul && wsl -- dash ./qdbg ./scripts ./\!scripts_debug || dash ./qdbg ./scripts ./\!scripts_debug
::cmd /c sdk createpak -out ..\..\DATA\PAK\dbg.pak.xen !scripts_debug

:: TODO, replace GHSDK with a simple PAK creator?
:: and yeah, where's the C version of NodeQBC at, BLOOWM
