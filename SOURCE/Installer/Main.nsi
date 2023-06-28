!include MUI.nsh
!include nsDialogs.nsh
!include LogicLib.nsh
!define MUI_ICON Icon.ico
!insertmacro MUI_LANGUAGE "English"

Name "FastGH3 1.0"
!define APPVER_MAJOR 0
!define APPVER_MINOR 889
!define APPVERSION 1.${APPVER_MAJOR}.${APPVER_MINOR}.0
OutFile "FastGH3_1.0.exe"
VIProductVersion "${APPVERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "FastGH3 1.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "Guitar Hero is trademark of Activision and Neversoft"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "Copyright Activision, Aspyr, Neversoft 2007"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "FastGH3 1.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${APPVERSION}"
InstallDir $PROGRAMFILES\FastGH3

Page custom splashPage
!insertmacro MUI_PAGE_DIRECTORY
; need a start menu/desktop shortcut checkbox
!insertmacro MUI_PAGE_INSTFILES

Section
	StrCpy $3 $INSTDIR
	SetOutPath $3
	File /r "..\..\__FINAL\*"
	StrCpy $0 "FastGH3"
	StrCpy $1 "$\"$3\$0.exe$\" $\"%1$\""
	StrCpy $2 "\shell\open\"
	WriteRegStr HKCR ".chart" "" "$0.chart"
	WriteRegStr HKCR ".fsp" "" "$0.FSP"
	WriteRegStr HKCR "$0" "" "$0"
	WriteRegStr HKCR "$0" "URL Protocol" ""
	WriteRegStr HKCR "$0.chart" "" "Guitar Hero Chart"
	WriteRegStr HKCR "$0.chart$2" "" "Play"
	WriteRegStr HKCR "$0.chart$2command" "" "$1"
	WriteRegStr HKCR "$0.FSP" "" "FastGH3 Song Package"
	WriteRegStr HKCR "$0.FSP$2" "" "Play"
	WriteRegStr HKCR "$0.FSP$2command" "" "$1"
	StrCpy $4 "$3\$0.exe"
	CreateShortCut "$DESKTOP\$0.lnk" "$4" "" "$4" 0
	CreateShortCut "$SMPROGRAMS\$0\$0.lnk" "$4" "" "$4" 0
	CreateShortCut "$SMPROGRAMS\$0\$0 Settings.lnk" "$4" "-settings" "$4" 0
	CreateShortCut "$SMPROGRAMS\$0\Shuffle.lnk" "$4" "-shuffle" "$4" 0
	CreateShortCut "$SMPROGRAMS\$0\Updater.lnk" "$3\Updater.exe" "" "$4" 0
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
	File /oname=$PLUGINSDIR\splash.bmp "InstSplash.bmp"
	File /oname=$PLUGINSDIR\intro.wav "Intro.wav"
	StrCpy $0 "$PLUGINSDIR\intro.wav"
	System::Call 'winmm::PlaySound(t r0, i, i) b'
FunctionEnd

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

	nsDialogs::CreateControl STATIC ${WS_VISIBLE}|${WS_CHILD}|${WS_CLIPSIBLINGS} 0 120u 24u -130u -32u "This will install FastGH3 1.0 on your computer, a mod built to reduce the hassle of playing customs for Guitar Hero (3), add QOL enhancements and gameplay additions, including ones the later games had, add endless customization and personalization, heavily optimized performance, tons of tweaks to change up the game, a plethra of fixes, portability, instant playability, from the double click in your file browser to rocking out in seconds, all in 13 megabytes!$\r$\n$\r$\nNote: this runs separate of normal GH3.$\r$\n$\r$\nVersion: 1.${APPVER_MAJOR}-99901${APPVER_MAJOR}${APPVER_MINOR}, build date: ${__DATE__} ${__TIME__}$\r$\n"
	Pop $TEXT

	SetCtlColors $DIALOG 0 0xffffff
	SetCtlColors $HEADLINE 0 0xffffff
	SetCtlColors $TEXT 0 0xffffff

	Call HideControls

	nsDialogs::Show

	Call ShowControls

	System::Call gdi32::DeleteObject(p$IMAGE)
FunctionEnd



