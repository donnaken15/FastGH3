:: REQUIRES (AND USES CYGWIN/MSYS2) (Z)SH, Node
@echo off
pushd "%~dp0"
:: /!\ ZSH OPERATES ON SCRIPTS FASTER, EVEN FASTER THAN DASH, DASH L /!\
where zsh /Q && zsh ./qcomp ./scripts ./!cache/scripts || dash ./qcomp ./scripts ./!cache/scripts
mkdir ..\..\DATA\PAK 2>nul
pakdir !cache ..\..\DATA\PAK\qb -s

:: kind of pointless to run every time but helps to reduce dbg.pak size
:: AND IT'S SLLOOOWWWWWWW (my fault probably)
::dash ./qdbg ./scripts ./\!scripts_debug
::pakdir !scripts_debug ..\..\DATA\PAK\dbg
dash "../Misc/write_build_date.sh"

::del !cache /S/Q
popd
