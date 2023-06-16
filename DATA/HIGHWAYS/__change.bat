@echo off
"%~dp0highwaygen" "%~1"
copy "%~dp0player.pak.xen" "%~dp0..\hway.pak.xen" /y
del "%~dp0player.pak.xen" /S /Q
:#die in real life microsoft
:#broken POS move command