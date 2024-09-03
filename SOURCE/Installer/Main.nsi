
SetCompressor /FINAL lzma
!include VersionInfo.nsh

Name "${TITLEVER}"
!include MUI2.nsh
!include nsDialogs.nsh
!include LogicLib.nsh
!define MUI_ICON Icon.ico

Caption "${TITLEVER}"
BrandingText "github.com/donnaken15/FastGH3"

Page custom splashPage
!define MUI_PAGE_HEADER_TEXT "Select Application Folder"
!define MUI_PAGE_HEADER_SUBTEXT "Please choose the directory for the installation."
!insertmacro MUI_PAGE_DIRECTORY
; need a start menu/desktop shortcut checkbox
!define MUI_INSTFILESPAGE_FINISHHEADER_TEXT "Installed"
!define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT "Done, lol. NOW JUST START PLAYING!"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"
;!define MUI_FINISHPAGE_RUN "$INSTDIR\FastGH3.exe"
;!define MUI_FINISHPAGE_RUN_TEXT "Play a chart now"
;!define MUI_WELCOMEFINISHPAGE_BITMAP "InstSplash.bmp"
; HOW DO I DO FINISH PAGE
;!define MUI_FINISHPAGE_RUN "$INSTDIR\FastGH3.exe"
;!define MUI_FINISHPAGE_RUN_TEXT "Play a chart now"
;!insertmacro MUI_PAGE_FINISH
;"Thank you for installing FastGH3!"
;"Click Close to exit. Enjoy!"
;"Select a chart now"

OutFile "../../FINALPKG.exe"
VIProductVersion "${APPVERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${TITLEVER}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "Guitar Hero is trademark of Activision and Neversoft"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "© Activision, Aspyr, Neversoft 2007"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${TITLEVER} Installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${APPVERSION}"
InstallDir "$PROGRAMFILES\FastGH3"

Section
	!insertmacro MUI_HEADER_TEXT "Installing" "Don't blink!"
	StrCpy $0 $INSTDIR
	SetOutPath $0
	File /r "..\..\__FINAL\*"
	StrCpy $1 "FastGH3"
	StrCpy $4 "$0\$1.exe"
	StrCpy $2 "$\"$4$\" $\"%1$\""
	StrCpy $3 "\shell\open\"
	WriteRegStr HKCR ".chart" "" "$1.chart"
	WriteRegStr HKCR ".fsp" "" "$1.FSP"
	WriteRegStr HKCR "$1" "" "$1"
	WriteRegStr HKCR "$1" "URL Protocol" ""
	WriteRegStr HKCR "$1$3command" "" "$\"$4$\" dl $\"%1$\""
	WriteRegStr HKCR "$1.chart" "" "Guitar Hero Chart"
	WriteRegStr HKCR "$1.chart$3" "" "Play"
	WriteRegStr HKCR "$1.chart$3command" "" "$2"
	WriteRegStr HKCR "$1.FSP" "" "$1 Song Package"
	WriteRegStr HKCR "$1.FSP$3" "" "Play"
	WriteRegStr HKCR "$1.FSP$3command" "" "$2"
	CreateShortCut "$DESKTOP\$1.lnk" "$4" "" "$4" 0
	StrCpy $3 "$SMPROGRAMS\$1"
	CreateDirectory "$3"
	CreateShortCut "$3\$1.lnk" "$4" "" "$4" 0
	CreateShortCut "$3\$1 Settings.lnk" "$4" "-settings" "$4" 0
	CreateShortCut "$3\Shuffle.lnk" "$4" "-shuffle" "$4" 0
	CreateShortCut "$3\Updater.lnk" "$0\Updater.exe" "" "$4" 0
SectionEnd

Var DIALOG
Var HEADLINE
Var TEXT
Var IMAGECTL
Var IMAGE

Var HEADLINE_FONT

Function .onInit
	CreateFont $HEADLINE_FONT "$(^Font)" "11" "600"
	
	InitPluginsDir
	File /oname=$PLUGINSDIR\intro.wav "Intro.wav"
	StrCpy $0 "$PLUGINSDIR\intro.wav"
	System::Call 'winmm::PlaySound(t r0, i, i) b'
	File /oname=$PLUGINSDIR\splash.bmp "InstSplash.bmp"
FunctionEnd

; need an array for this or something
Function HideControls

	LockWindow on
	GetDlgItem $0 $HWNDPARENT 1028
	ShowWindow $0 ${SW_HIDE}

	GetDlgItem $0 $HWNDPARENT 1256
	ShowWindow $0 ${SW_HIDE}

	GetDlgItem $0 $HWNDPARENT 1035
	ShowWindow $0 ${SW_HIDE}

	GetDlgItem $0 $HWNDPARENT 1037
	ShowWindow $0 ${SW_HIDE}

	GetDlgItem $0 $HWNDPARENT 1038
	ShowWindow $0 ${SW_HIDE}

	GetDlgItem $0 $HWNDPARENT 1039
	ShowWindow $0 ${SW_HIDE}

	GetDlgItem $0 $HWNDPARENT 1045
	ShowWindow $0 ${SW_NORMAL}
	LockWindow off

FunctionEnd

Function ShowControls

	LockWindow on
	GetDlgItem $0 $HWNDPARENT 1028
	ShowWindow $0 ${SW_NORMAL}

	GetDlgItem $0 $HWNDPARENT 1256
	ShowWindow $0 ${SW_NORMAL}

	GetDlgItem $0 $HWNDPARENT 1035
	ShowWindow $0 ${SW_NORMAL}

	GetDlgItem $0 $HWNDPARENT 1037
	ShowWindow $0 ${SW_NORMAL}

	GetDlgItem $0 $HWNDPARENT 1038
	ShowWindow $0 ${SW_NORMAL}

	GetDlgItem $0 $HWNDPARENT 1039
	ShowWindow $0 ${SW_NORMAL}

	GetDlgItem $0 $HWNDPARENT 1045
	ShowWindow $0 ${SW_HIDE}
	LockWindow off

FunctionEnd

Function splashPage
	nsDialogs::Create 1044
	Pop $DIALOG

	nsDialogs::CreateControl STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS}|${SS_BITMAP} 0 0 0 109u 193u ""
	Pop $IMAGECTL

	StrCpy $0 $PLUGINSDIR\splash.bmp
	System::Call 'user32::LoadImage(p 0, t r0, i ${IMAGE_BITMAP}, i 0, i 0, i ${LR_LOADFROMFILE})p.s'
	Pop $IMAGE
	
	SendMessage $IMAGECTL ${STM_SETIMAGE} ${IMAGE_BITMAP} $IMAGE

	nsDialogs::CreateControl STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS} 0 120u 10u -130u 13u "Welcome to the FastGH3 install wizard"
	Pop $HEADLINE

	SendMessage $HEADLINE ${WM_SETFONT} $HEADLINE_FONT 0

	nsDialogs::CreateControl STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS} 0 120u 24u -130u -32u "This will install FastGH3 1.0 on your computer, a mod built to reduce the hassle of playing customs for Guitar Hero (3), add QOL enhancements and gameplay additions, including ones the later games had, add endless customization and personalization, heavily optimized performance, tons of tweaks to change up the game, a plethra of fixes, portability, instant playability, from the double click in your file browser to rocking out in seconds, all in 12 megabytes!$\r$\n$\r$\nNote: this runs separate of normal GH3.$\r$\n$\r$\nVersion: 1.${APPVER_MAJOR}-99901${APPVER_MAJOR}${APPVER_MINOR}, build date: ${__DATE__} ${__TIME__}$\r$\n"
	Pop $TEXT

	SetCtlColors $DIALOG 0 0xffffff
	SetCtlColors $HEADLINE 0 0xffffff
	SetCtlColors $TEXT 0 0xffffff
	;SetCtlColors $RUNNOW_TEXT 0 0xffffff

	Call HideControls

	nsDialogs::Show

	Call ShowControls

	System::Call gdi32::DeleteObject(p$IMAGE)
FunctionEnd
