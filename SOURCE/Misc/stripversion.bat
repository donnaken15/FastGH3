@call "C:\Program Files (x86)\Resource Hacker\resourcehacker.exe" -open "%~1" -save "%~1" -action delete VERSIONINFO,, -action delete MANIFEST,,
@ping -n 1 -w 600 127.0.0.1 >nul :: completely moronic
@call stripreloc /b "%~1"