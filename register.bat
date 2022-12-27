@echo off
echo Creating class keys...
set C=reg add
set CMD="\"%~dp0FastGH3.exe\" \"%%1\""
set OPEN=shell\open
set K=HKCR\FastGH3
set D=/f /ve /d
set OK=echo OK
set FAIL=echo FAIL
%C% "HKCR\.chart" %D% "FastGH3.chart" && %OK% || %FAIL%
%C% "HKCR\.fsp" %D% "FastGH3.FSP" && %OK% || %FAIL%
%C% "%K%" %D% "FastGH3" && %OK% || %FAIL%
%C% "%K%" /f /v "URL Protocol" && %OK% || %FAIL%
%C% "%K%\%OPEN%\command" %D% "\"%~dp0FastGH3.exe\" dl \"%%1\"" && %OK% || %FAIL%
%C% "%K%.chart" %D% "Guitar Hero Chart" && %OK% || %FAIL%
%C% "%K%.chart\%OPEN%" %D% "Play" && %OK% || %FAIL%
%C% "%K%.chart\%OPEN%\command" %D% %CMD% && %OK% || %FAIL%
%C% "%K%.FSP" %D% "FastGH3 Song Package" && %OK% || %FAIL%
%C% "%K%.FSP\%OPEN%" %D% "Play" && %OK% || %FAIL%
%C% "%K%.FSP\%OPEN%\command" %D% %CMD% && %OK% || %FAIL%
set FAIL=%ERRORLEVEL%
echo If you see any FAILs here, something went wrong.
echo This requires running as administrator.
echo Done.
set ERRORLEVEL=%FAIL%
IF ERRORLEVEL 1 (pause && exit /b)