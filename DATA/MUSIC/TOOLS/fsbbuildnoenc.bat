
@echo off

rem arguments: filename

set argC=0
for %%x in (%*) do Set /A argC+=1

if %argC% NEQ 1 echo Invalid number of arguments && exit /b

del %1 /Q > nul

"%~dp0fsbext" -d "%~dp0fsbtmp" -s "%~dp0template.dat" -r "%~dp0.tmp.fsb"
"%~dp0fsbenc" "%~dp0.tmp.fsb" %1

del "%~dp0.tmp.fsb"
del "%~dp0fsbtmp" /S/Q
rmdir "%~dp0fsbtmp"
