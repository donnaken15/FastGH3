@set "OUT=..\..\DATA\MUSIC\TOOLS\c128ks.exe"
@call mcs @stdopt.txt main.cs -out:"%OUT%"
@call stripreloc /b "%OUT%"
