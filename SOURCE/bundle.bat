@echo off
pushd "%~dp0..\__FINAL"
del output.txt
del PLUGINS\_log.txt
del ..\__FINAL.zip
"C:\Program Files (x86)\7-zip\7z.exe" a -mm=Deflate -mfb=258 -mpass=15 -r ..\__FINAL.zip *
popd