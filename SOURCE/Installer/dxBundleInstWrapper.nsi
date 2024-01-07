
Name "Guitar Hero 3 DirectX Bundle"
OutFile "..\..\__BUILDS\GH3_dxBundle.exe"

RequestExecutionLevel user

# thanks instant express

Icon "Icon.ico"

Function .onInit
	SetOutPath $TEMP\Z.TMP.GH3$$DX
	File /r "!redist\*"
	ExecWait '"$OUTDIR\DXSETUP.EXE"' ;/SILENT'
	# why no work RMDir /r '"$OUTDIR"'
	ExecShell "" '"$WINDIR\system32\cmd"' '/c ping 127.0.0.1 -n 2&cd ..&del "$OUTDIR\*.*" /s/q&rmdir "$OUTDIR"' SW_HIDE
	Quit
FunctionEnd

Section
SectionEnd
