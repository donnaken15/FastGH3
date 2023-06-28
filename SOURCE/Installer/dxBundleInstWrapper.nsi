
Name "Guitar Hero 3 DirectX Bundle"
OutFile "..\..\__BUILDS\GH3_dxBundle.exe"

RequestExecutionLevel user

# thanks instant express

Icon "Icon.ico"

Function .onInit
	SetOutPath $TEMP\Z.TMP.GH3$$DX
	File /r "..\..\JUNK3\__REDIST\min\*"
	ExecWait '"$OUTDIR\DXSETUP.EXE"' ;/SILENT'
	# why no work RMDir /r '"$OUTDIR"'
	Quit
FunctionEnd

Section
SectionEnd
