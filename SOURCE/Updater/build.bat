@pushd "%~dp0"
@mcs Program.cs SimpleJSON.cs -debug- /reference:"C:\Program Files (x86)\FastGH3\Ionic.Zip.dll" -sdk:2 -optimize+ -codepage:437 -nostdlib- --runtime:v1 -out:..\..\__FINAL\Updater.exe && copy ..\..\__FINAL\Updater.exe ..\..\Updater.exe /y && ..\..\__FINAL\Updater
@popd