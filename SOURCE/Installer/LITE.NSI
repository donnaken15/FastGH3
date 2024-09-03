
SetCompressor /FINAL lzma
!include VersionInfo.nsh

Name "${TITLEVER} LITE"
RequestExecutionLevel user
# thanks instant express
Icon "..\FastGH3\res\note.ico"

!include FileFunc.nsh
!include LogicLib.nsh
!include FindProcess.nsh

OutFile "../../FINALPKG_LITE.exe"
VIProductVersion "${APPVERSION}"
VIAddVersionKey "ProductName" "${TITLEVER}"
VIAddVersionKey "LegalTrademarks" "Activision"
VIAddVersionKey "LegalCopyright" "© Aspyr & Activision 2007-2008"
VIAddVersionKey "FileDescription" "An advanced mod of Guitar Hero 3 designed for playing charts easily. Lite version packaged into ONE EXE."
VIAddVersionKey "FileVersion" "${APPVERSION}"

; https://nsis-dev.github.io/NSIS-Forums/html/t-214310.html
Function TickCount
	System::Alloc 400 ;wtf is this
	Pop $2
	System::Call "kernel32::GetTickCount() i.r1"
	System::Free $2
FunctionEnd

Function .onInit
	${GetParameters} $R0
	StrCpy $R9 $R0
	SetOutPath $TEMP\Z.TMP.FGH3
	File /r "..\..\__FINAL\*"
	;File /r /x settings.ini y no work
	File /oname=settings.ini liteconfig.ini
	; if user has settings.ini alongside this exec, use it in the temp dir
	IfFileExists $EXEDIR\settings.ini 0 +2
	CopyFiles $EXEDIR\settings.ini $OUTDIR
	StrCmp $R9 "" 0 main ; if parameters aren't empty, skip extra song if not ignored
	ReadINIStr $R9 $EXEDIR\settings.ini Misc IgnoreExtra
	${If} $R9 == 0
	${OrIf} $R9 == ""
		MessageBox MB_YESNO \
	"There's a secret song inside! Do you want to play it? \
	Clicking ''No'' won't show this dialog again, unless a setting is undone." \
		IDNO IE
		Exec '"$OUTDIR\game.exe"'
		Goto ok
	${Else}
		Goto main
	${EndIf}
	IE:
		WriteINIStr $EXEDIR\settings.ini Misc IgnoreExtra 1
	main:
		StrCpy $R9 ""
		ExecWait '"$OUTDIR\FastGH3.exe" $R9' $R9
		Sleep 1000
			IntCmp $R9 0 ok 0 0
			Goto err
			ok:
				Sleep 5000
				Call TickCount
				StrCpy $R8 $1 ; unironic brain damage wtf, nice one nullsoft
				${Do}
					Sleep 2000
					${FindProcess} "game.exe" $0 ; find full file name if possible
				${LoopWhile} $0 <> 0
				; get playtime
				Call TickCount
				IntOp $R0 $1 - $R8
				
				IfFileExists $EXEDIR\settings.ini 0 +2
				CopyFiles $OUTDIR\settings.ini $EXEDIR
				
				; if too short, either user got some error or
				; the user just gave up on it early ( :(  ), so don't display message
				IntCmp $R0 32000 0 short 0
				MessageBox MB_OK "Thanks for playing! Unlock more potential by simply installing this (from https://donnaken15.com/FastGH3), which will make replaying songs way faster, allow you to save your settings, directly download and instantly play songs from URLs, and gain easy access to more features!"
			short:
		err:
	RMDir /r $OUTDIR
	Delete $OUTDIR
	Quit
FunctionEnd

Section
SectionEnd

