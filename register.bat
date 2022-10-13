@echo off
echo Creating class keys...
reg add "HKCR\.chart" /f /ve /d "FastGH3.chart" && echo OK || echo FAIL
reg add "HKCR\.fsp" /f /ve /d "FastGH3.FSP" && echo OK || echo FAIL
reg add "HKCR\FastGH3" /f /ve /d "FastGH3" && echo OK || echo FAIL
reg add "HKCR\FastGH3" /f /v "URL Protocol" && echo OK || echo FAIL
reg add "HKCR\FastGH3\shell\open\command" /f /ve /d "\"%~dp0FastGH3.exe\" dl \"%%1\"" && echo OK || echo FAIL
reg add "HKCR\FastGH3.chart" /f /ve /d "Guitar Hero Chart" && echo OK || echo FAIL
reg add "HKCR\FastGH3.chart\shell\open" /f /ve /d "Play" && echo OK || echo FAIL
reg add "HKCR\FastGH3.chart\shell\open\command" /f /ve /d "\"%~dp0FastGH3.exe\" \"%%1\"" && echo OK || echo FAIL
reg add "HKCR\FastGH3.FSP" /f /ve /d "FastGH3 Song Package" && echo OK || echo FAIL
reg add "HKCR\FastGH3.FSP\shell\open" /f /ve /d "Play" && echo OK || echo FAIL
reg add "HKCR\FastGH3.FSP\shell\open\command" /f /ve /d "\"%~dp0FastGH3.exe\" \"%%1\"" && echo OK || echo FAIL
echo If you see any FAILs here, something went wrong.
echo Done.
if %ERRORLEVEL% NEQ 0 do (pause && exit /b)
