:: still bloats it more than microsoft compiler
@pushd "%~dp0"
@mcs pakdir.cs @stdopt.txt -langversion:ISO-1 -out:..\q\pakdir.exe
@call stripversion.bat ..\q\pakdir.exe
@popd