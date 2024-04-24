
Name "FastGH3 LITE"
OutFile "FastGH3_LITE.exe"
RequestExecutionLevel user
# thanks instant express
Icon "..\FastGH3\P\note.ico"

!include FileFunc.nsh
!include LogicLib.nsh
!include FindProcess.nsh

; https://nsis-dev.github.io/NSIS-Forums/html/t-214310.html
Function TickCount
	System::Alloc 400 ;wtf is this
	Pop $2
	System::Call "kernel32::GetTickCount() i.r1"
	System::Free $2
FunctionEnd

Function .onInit
	SetOutPath $TEMP\Z.TMP.FGH3
	File /r "..\..\__FINAL\*"
	;File /r /x settings.ini y no work
	File /oname=settings.ini liteconfig.ini
	
	${GetParameters} $R0
	; if user has settings.ini alongside this exec, use it in the temp dir
	IfFileExists $EXEDIR\settings.ini 0 +2
	CopyFiles $EXEDIR\settings.ini $OUTDIR
	ExecWait '"$OUTDIR\FastGH3.exe" $R0' $1
	${IfNot} $1 = 0x11111111
	;${Else}
		; launcher returning 1 where it should return 0 because conversion is successful
		;${If} $1 = 0
			Call TickCount
			StrCpy $R8 $1 ; unironic brain damage wtf, nice one nullsoft
			${Do}
				Sleep 2000
				${FindProcess} "game.exe" $0
			${LoopWhile} $0 <> 0
			; get playtime
			Call TickCount
			IntOp $R0 $1 - $R8
			; if too short, either user got some error or
			; the user just gave up on it early ( :(  ), so don't display message
			IntCmp $R0 32000 0 short 0
			MessageBox MB_OK "Thanks for playing! Unlock more potential by simply installing this (from https://donnaken15.com/FastGH3), which will make replaying songs way faster, allow you to save your settings, directly download and instantly play songs from URLs, and gain easy access to more features!"
		short:
			IfFileExists $EXEDIR\settings.ini 0 +2
			CopyFiles $OUTDIR\settings.ini $EXEDIR
		;${EndIf}
	${EndIf}
	RMDir /r $OUTDIR
	Delete $OUTDIR
	Quit
FunctionEnd

Section
SectionEnd

