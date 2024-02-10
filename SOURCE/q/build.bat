:: REQUIRES (AND USES CYGWIN/MSYS2) (Z)SH, Node, and Guitar Hero SDK
@echo off
:: /!\ ZSH OPERATES ON SCRIPTS FASTER, EVEN FASTER THAN DASH, DASH L /!\
where zsh /Q && zsh ./qcomp ./scripts ./!cache/scripts || dash ./qcomp ./scripts ./!cache/scripts
cmd /c sdk createpak -out ..\..\DATA\PAK\qb.pak.xen -pab !cache
:: kind of pointless to run every time but helps to reduce dbg.pak size
:: AND IT'S SLLOOOWWWWWWW (my fault probably)
where wsl /q && wsl -- dash ./qdbg ./scripts ./\!scripts_debug || dash ./qdbg ./scripts ./\!scripts_debug
cmd /c sdk createpak -out ..\..\DATA\PAK\dbg.pak.xen !scripts_debug
pushd ..\..
sh "!.__write_build_date.sh"
popd
::del !cache /S/Q
:: save compiled to not rebuild them over and over
:: ALSO PAK BUILDING IS SLOW (sometimes)

:: TODO, replace GHSDK with a simple PAK creator?
:: also for zone building to make that separable for custom themes
:: and yeah, where's the C version of NodeQBC at, BLOOWM
