@echo off
cls

title FastGH3 - Configure/install repo
setlocal
call :checkdeps
set R_GIT=
set R_NODE=
set R_MPR=
set R_SRL=
set R_NSI=
set R_VS=
set R_MONO=
set R_CHLK=
set "R_GOTTEXT=(Already installed)"
if  %GIT% EQU 1 ( set "R_GIT=%R_GOTTEXT%"	)
if %NODE% EQU 1 ( set "R_NODE=%R_GOTTEXT%"	)
if %CHLK% EQU 1 ( set "R_CHLK=%R_GOTTEXT%"	)
if  %BUN% EQU 1 ( set "R_BUN=%R_GOTTEXT%"	)
if  %MPR% EQU 1 ( set "R_MPR=%R_GOTTEXT%"	)
if  %SRL% EQU 1 ( set "R_SRL=%R_GOTTEXT%"	)
if  %NSI% EQU 1 ( set "R_NSI=%R_GOTTEXT%"	)
if   %VS% EQU 1 ( set "R_VS=%R_GOTTEXT%"	)
if %MONO% EQU 1 ( set "R_MONO=%R_GOTTEXT%"	)
if  %UPX% EQU 1 ( set "R_UPX=%R_GOTTEXT%"	)

echo --- FASTGH3 ---
echo.
echo This batch script will install the dependencies
echo required for building this mod manually.
echo If you have any of the following already installed,
echo installation of said programs will be skipped.
echo.
echo Required programs:
echo - Git  (Git, Shell)      %R_GIT%
echo - Node (^>=12.2.0)        %R_NODE%
echo   or
echo   Bun  (^>=1.1.0)         %R_BUN%
echo - Visual Studio (^>=2015) %R_VS%
::echo   or
::echo   Mono                   %R_MONO%
echo Optional:
echo - UPX                    %R_UPX%
echo - NSIS                   %R_NSI%
echo - DotNetCompressor       %R_MPR%
echo - stripreloc             %R_SRL%
echo - Chocolatey             %R_CHLK%
echo - Cygwin/ZSH
echo.
echo Projects to build:
echo - FastGH3 Launcher               - Converts charts, settings
echo - FastGH3 qb.pak / global.pak    - Game code and assets
echo - GH3+                           - Plugin library
echo - c128ks                         - Audio encoder
::echo - makefsb
echo - Installer

choice /m "Do you want to continue?"
if errorlevel 2 goto :eof

choice /c ync /m "Install optional tools?"
if errorlevel 3 goto :eof
set opt=%errorlevel%

if %CHLK% EQU 1 ( goto NO_CHOCO )
choice /c ync /m "Install using chocolatey?"
if errorlevel 3 goto :eof
set opt=%errorlevel%
:NO_CHOCO

:: check if git folder exists
::https://nodejs.org/download/release/v10.4.0/

::git fetch --recurse-submodules
::git submodule update --remote --merge
::git pull --recurse-submodules (said already up to date)

endlocal
pause

exit /b

:checkdeps

:: git -v exits batch, nice one free software
call git	-v	>nul && set  GIT=1	||	set  GIT=0
call bun	-v	>nul && set  BUN=1	||	set  BUN=0
call node	-v	>nul && set NODE=1	||	set NODE=0
call choco	-v	>nul && set CHLK=1	||	set CHLK=0
:: blessed node

where /q mpress && set MPR=1 || set MPR=0
where /q stripreloc && set SRL=1 || set SRL=0
where /q upx && set UPX=1 || set UPX=0
reg query HKLM\SOFTWARE\NSIS /reg:32 /ve 2>nul >nul && set NSI=1 || set NSI=0
set VS=0
set VSKEY=HKLM\SOFTWARE\Microsoft\VisualStudio\
reg query %VSKEY%14.0\Setup\vs /reg:32 2>nul >nul && set VS=1
reg query %VSKEY%15.0\Setup\vs /reg:32 2>nul >nul && set VS=1
reg query %VSKEY%16.0\Setup\vs /reg:32 2>nul >nul && set VS=1
reg query %VSKEY%17.0\Setup\vs /reg:32 2>nul >nul && set VS=1
where /q mono && set MONO=1 || set MONO=0

goto :eof
