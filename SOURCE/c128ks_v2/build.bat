@set "OUT=..\..\DATA\MUSIC\TOOLS\c128ks.exe"
@call mcs @stdopt.txt main.cs -out:"%OUT%"
@call "C:\Program Files (x86)\Resource Hacker\resourcehacker.exe" -open "%OUT%" -save "%OUT%" -action delete VERSIONINFO,,
@call stripreloc /b "%OUT%"
