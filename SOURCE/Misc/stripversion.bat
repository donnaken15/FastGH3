@call "C:\Program Files (x86)\Resource Hacker\resourcehacker.exe" -open "%~1" -save "%~1" -action delete VERSIONINFO,,
@call stripreloc /b "%~1"