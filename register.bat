@echo off
echo Creating class key...
reg add "HKCR\.chart" /f /ve /d "FastGH3.chart" && echo OK || echo FAIL
reg add "HKCR\FastGH3" /f /ve /d "FastGH3" && echo OK || echo FAIL
reg add "HKCR\FastGH3" /f /v "URL Protocol" && echo OK || echo FAIL
reg add "HKCR\FastGH3\shell\open\command" /f /ve /d "\"%~dp0FastGH3.exe\" dl \"%%1\"" && echo OK || echo FAIL
reg add "HKCR\FastGH3.chart" /f /ve /d "Guitar Hero Chart" && echo OK || echo FAIL
reg add "HKCR\FastGH3.chart\shell\open\command" /f /ve /d "\"%~dp0FastGH3.exe\" \"%%1\"" && echo OK || echo FAIL
echo Creating Aspyr key...
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set TUNNEL=\ || set TUNNEL=\WOW6432Node\
reg add "HKLM\SOFTWARE%TUNNEL%Aspyr\FastGH3" /f /ve && echo Done. || echo Please run as administrator.
if %ERRORLEVEL% GEQ 0 pause
