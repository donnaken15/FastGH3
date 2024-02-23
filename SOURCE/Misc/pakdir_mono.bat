:: still bloats it more than microsoft compiler
@mcs pakdir.cs -debug- -nostdlib- -langversion:ISO-1 -o+ -sdk:2 -out:..\q\pakdir.exe
@call stripversion.bat ..\q\pakdir.exe