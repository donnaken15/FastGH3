#include "gh3\GH3Keys.h"
#include "core\Patcher.h"
#include "mirrorMode.h"
#include <stdint.h>

static GH3P::Patcher g_patcher = GH3P::Patcher(__FILE__);

enum class FretMask : uint32_t
{
	ORANGE = 0x00001,
	BLUE =   0x00010,
	YELLOW = 0x00100,
	RED =    0x01000,
	GREEN =  0x10000,
};

struct QbArray
{
	uint32_t flags;
	uint32_t size;
	uint32_t *arr;
};

// Reverse the parameter order for the CreateNote call
static void * const createNoteDetour = (void *)0x0041D41B;

__declspec(naked) void createNoteReversedNaked()
{
	static void * const returnAddress = (void *)0x0041D449;
    __asm
    {
		mov     edx, [esp + 20h]; // [esp+48h+hopoRaw]
		mov     ecx, [esp + 18h]; // [esp+48h+redSustainLength]
		mov     esi, [esp + 30h]; // [esp+48h+currentStartTime]
		push    eax; //      nextNoteTime
		mov     eax, [esp + 28h]; // [esp+4Ch+greenSustainLength]
		push    edx; //      hopoFlag
		mov     edx, [esp + 18h]; // [esp+50h+yellowSustainLength]
		push    eax; //      greenLength
		mov     eax, [esp + 20h]; // [esp+54h+blueSustainLength]
		push    ecx; //      redLength
		mov     ecx, [esp + 2Ch]; // [esp+58h+orangeSustainLength]
		push    edx; //      yellowLength
		mov     edx, [esp + 40h]; // [esp+5Ch+noteTime2]
		push    eax; //      blueLength
		mov     eax, [esp + 4Ch]; // [esp+60h+noteArray] ; noteArray
		push    ecx; //      greenLength
		push    edx; //      noteTime
		mov     ecx, esi; // noteIndex
		jmp		returnAddress;
    }
}


static void * const GetFretmaskFromNoteQbArrayDetour = (void *)0x0041B090;

uint32_t __fastcall GetMirroredFretmaskFromNoteQbArray(QbArray *qbArr)
{
	uint32_t size = qbArr->size;
	uint32_t *frets = qbArr->arr;
	uint32_t fretMask = 0;
	uint32_t fret = reinterpret_cast<uint32_t>(frets); //Please don't ask me the reasoning behind this insanity. The neversoft devs are mad

	if (size != 1)
		fret = frets[1];
	if (fret > 0)
		fretMask |= (uint32_t)FretMask::ORANGE;

	if (size != 1)
		fret = frets[2];
	if (fret > 0)
		fretMask |= (uint32_t)FretMask::BLUE;

	if (size != 1)
		fret = frets[3];
	if (fret > 0)
		fretMask |= (uint32_t)FretMask::YELLOW;

	if (size != 1)
		fret = frets[4];
	if (fret > 0)
		fretMask |= (uint32_t)FretMask::RED;

	if (size != 1)
		fret = frets[5];
	if (fret > 0)
		fretMask |= (uint32_t)FretMask::GREEN;

	return fretMask;
}

void ApplyHack()
{
	if (!g_patcher.WriteJmp(createNoteDetour, createNoteReversedNaked) ||
		!g_patcher.WriteJmp(GetFretmaskFromNoteQbArrayDetour, GetMirroredFretmaskFromNoteQbArray))
		g_patcher.RemoveAllChanges();
}