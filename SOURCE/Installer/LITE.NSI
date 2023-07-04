
Name "FastGH3 LITE"
OutFile "FastGH3_LITE.exe"
RequestExecutionLevel user
# thanks instant express
Icon "..\FastGH3\note.ico"

!include FileFunc.nsh
!include LogicLib.nsh
!include FindProcess.nsh

Function .onInit
	SetOutPath $TEMP\Z.TMP.FGH3
	File /r "..\..\__FINAL\*"
	;File /r /x settings.ini y no work
	File /oname=settings.ini liteconfig.ini
	
	${GetParameters} $R0
	;MessageBox MB_OK "$R0"
	;Quit
	IfFileExists $EXEDIR\settings.ini 0 +2
	CopyFiles $EXEDIR\settings.ini $OUTDIR
	ExecWait '"$OUTDIR\FastGH3.exe" $R0' $1
	Sleep 10000
	${Do}
		${FindProcess} "FastGH3.exe" $0
		Sleep 8000
	${LoopWhile} $0 <> 0
	Sleep 8000
	${If} $1 = 0x11111111
	${Else}
		${Do}
			Sleep 2000
			${FindProcess} "game.exe" $0
		${LoopWhile} $0 <> 0
		MessageBox MB_OK "Thanks for playing! Unlock more potential by simply installing this (from https://donnaken15.cf/FastGH3), which will make replaying songs way faster, allow you to save your settings, directly download and instantly play songs from URLs, and gain easy access to more features!"
		IfFileExists $EXEDIR\settings.ini 0 +2
		CopyFiles $OUTDIR\settings.ini $EXEDIR
	${EndIf}
	RMDir /r $OUTDIR
	Delete $OUTDIR
	Quit
FunctionEnd

Section
SectionEnd
