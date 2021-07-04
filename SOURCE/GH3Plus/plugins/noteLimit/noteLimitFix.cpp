// GH3Hack.cpp : Defines the exported functions for the DLL application.
//

#include "noteLimitFix.h"
#include "core\Patcher.h"
#include <stdint.h>
#include <Windows.h>

uint32_t MAX_NOTES = 0x100000; // = 1048576
uint32_t GH3_MAX_PLAYERS = 2;

void * const SIZEOP_NOTE_ALLOCATION = (void *)0x0041AA78;
									
void * const ADDROP_SUSTAINARRAY_1 =  (void *)0x0041EE33;
void * const ADDROP_SUSTAINARRAY_2 =  (void *)0x00423CD4;
void * const ADDROP_SUSTAINARRAY_3 =  (void *)0x00423D02;
void * const ADDROP_FCARRAY =		  (void *)0x00423D14;
void * const ADDROP_NOTEOFFSETARRAY = (void *)0x00423D22;

static float *fixedSustainArray = nullptr;
static float *fixedFcArray = nullptr;
static uint32_t *fixedOffsetArray = nullptr;

static GH3P::Patcher g_patcher = GH3P::Patcher(__FILE__);

static char inipath[MAX_PATH];

// Writes to the code segment of GH3, overwriting the operands responsible for creating or pointing
// towards the fixed 4000 size note arrays with its own allocated arrays
void FixNoteLimit()
{
	GetCurrentDirectoryA(MAX_PATH, inipath);
	strcat_s(inipath, MAX_PATH, "\\settings.ini");
	//MessageBoxA(0, inipath, "", 0);
	MAX_NOTES = GetPrivateProfileIntA("Player", "MaxNotes", 0x100000, inipath);

	if (fixedSustainArray == nullptr)
		fixedSustainArray = new float[MAX_NOTES * GH3_MAX_PLAYERS];

	if (fixedFcArray == nullptr)
		fixedFcArray = new float[MAX_NOTES * GH3_MAX_PLAYERS];

	if (fixedOffsetArray == nullptr)
		fixedOffsetArray =  new uint32_t[MAX_NOTES * GH3_MAX_PLAYERS];

	// Fix dynamic allocations
	g_patcher.WriteInt32(SIZEOP_NOTE_ALLOCATION, MAX_NOTES);

	// Fix static references
	g_patcher.WriteInt32(ADDROP_SUSTAINARRAY_1, reinterpret_cast<uint32_t>(fixedSustainArray));
	g_patcher.WriteInt32(ADDROP_SUSTAINARRAY_2, reinterpret_cast<uint32_t>(fixedSustainArray));
	g_patcher.WriteInt32(ADDROP_SUSTAINARRAY_3, reinterpret_cast<uint32_t>(fixedSustainArray));
	g_patcher.WriteInt32(ADDROP_FCARRAY,		reinterpret_cast<uint32_t>(fixedFcArray));
	g_patcher.WriteInt32(ADDROP_NOTEOFFSETARRAY, reinterpret_cast<uint32_t>(fixedOffsetArray));
}

