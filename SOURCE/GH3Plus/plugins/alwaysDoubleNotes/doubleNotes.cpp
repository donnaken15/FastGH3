#include "gh3\GH3Keys.h"
#include "gh3\GH3GlobalAddresses.h"
#include "core\Patcher.h"
#include "doubleNotes.h"
#include <stdint.h>

static GH3P::Patcher g_patcher = GH3P::Patcher(__FILE__);

__declspec(naked) void tinyJump()
{
    static const uint32_t returnAddress = 0x0041D298;
    __asm
    {
        mov ecx, ebp;
        jmp returnAddress;
    }
}

static void * hopoCheckDetour = (void *)0x0041D1D2;
static void * GetFretmaskFromNoteQbArray = (void *)0x0041B090;
static void * GetFretmaskFromTrackArray = (void *)0x0041B100;
__declspec (naked) void hopoCheckNaked()
{
	static const uint32_t returnAddress = 0x0041D1E4;

	__asm
	{
		//Only use the old method if we're literally on the first note.
		sub		esi, 3
		cmp     esi, 0
		jge     NEW_METHOD

		//Old method
		add     esi, 3 //correct ESI
		mov     ecx, edi; //this
		call    GetFretmaskFromNoteQbArray;
		mov     ebp, eax;
		jmp		GET_FRETMASK;

	NEW_METHOD:
		mov		ecx, [esp + 58h];
		call    GetFretmaskFromTrackArray
		mov     ebp, eax;
		add		esi, 3 //correct ESI

	GET_FRETMASK:
		mov		ecx, [esp + 58h];
		call	GetFretmaskFromTrackArray;
		mov     ecx, eax;

		jmp		returnAddress;
	}
}

void ApplyHack()
{
    g_patcher.WriteJmp((void *)0x0041D288, &tinyJump);
	g_patcher.WriteJmp(hopoCheckDetour, hopoCheckNaked);
}