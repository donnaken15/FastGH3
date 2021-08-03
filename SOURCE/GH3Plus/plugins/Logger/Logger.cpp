#include "gh3\GH3Keys.h"
#include "core\Patcher.h"
#include "Logger.h"
#include <stdint.h>
#include <stdio.h>
#include <Windows.h>
#include "gh3\GH3Functions.h"

static char inipath[MAX_PATH],
			logfile[MAX_PATH];
BYTE l_CreateCon, l_WriteFile;
FILE * log, * CON;

static GH3P::Patcher g_patcher = GH3P::Patcher(__FILE__);

static void *ScrAsrtDetour = (void *)0x00532DFE;
__declspec(naked) void RedirectOutput()
{
	static const uint32_t returnAddress = 0x00532E03;
	static const char*logtext;
	__asm {
		mov logtext, edx;
		call PrintsubIthink;
	}
	if (l_CreateCon)
		fputs(logtext, CON);
	if (l_WriteFile)
		fputs(logtext, log);
	__asm {
		jmp returnAddress;
	}
}

void ApplyHack()
{
	GetCurrentDirectoryA(MAX_PATH, inipath);
	memcpy(logfile, inipath, MAX_PATH);
	strcat_s(inipath, MAX_PATH, "\\settings.ini");
	l_CreateCon = GetPrivateProfileIntA("Logger", "Console", 0, inipath);
	l_WriteFile = GetPrivateProfileIntA("Logger", "WriteFile", 1, inipath);
	if (l_CreateCon)
	{
		AllocConsole();
		freopen_s(&CON, "CONOUT$", "w", stdout);
	}
	if (l_WriteFile)
	{
		strcat_s(logfile, MAX_PATH, "\\output.txt");
		fopen_s(&log, logfile, "w");
	}
	if (l_CreateCon)
	{
		fputs("Guitar Hero 3 log\n--------------------\nPatching print functions\n\n", CON);
	}
	if (!g_patcher.WriteJmp(ScrAsrtDetour, RedirectOutput) ||
		!g_patcher.WriteJmp((void*)0x00530940, (void*)0x00532DD0) || // Printf jump to my function
		!g_patcher.WriteJmp((void*)0x00532E2A, RedirectOutput)) // SoftAsrt jump to my function
	{
		g_patcher.RemoveAllChanges();
		if (l_CreateCon)
		{
			fputs("----------------------", CON);
			for (int i = 0; i < 10; i++)
				fputs("Failed to redirect prints!!!!!!!!!!!!!!!!!!!!!!!!!!!", CON);
			fputs("----------------------", CON);
		}
	}
}