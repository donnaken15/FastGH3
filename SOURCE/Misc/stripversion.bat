@start /b /wait "" "C:\Program Files (x86)\Resource Hacker\resourcehacker.exe" -open "%~1" -save "%~1" -action delete VERSIONINFO,, -action delete MANIFEST,,
@:: completely moronic
@call stripreloc /b "%~1"