#include "core\Patcher.h"
#include "gh3\GH3Keys.h"
#include "gh3\GH3GlobalAddresses.h"

#include "gemShuffle.h"
#include <random>

static void * const fruityDetour = (void *)0x00432887; //0x004327D2; // 0x00432733;

static void * const overstrumDetour1 = (void *)0x004320F0; //overstrum

static uint32_t g_randomIndex;

static GH3P::Patcher g_patcher = GH3P::Patcher(__FILE__);

void randomizeIndex()
{
	g_randomIndex = rand() % 5;
}

__declspec (naked) void fruityNaked()
{
	static const uint32_t returnAddress = 0x0043288F;

	__asm
	{
		pushad;
		call	randomizeIndex;
		popad;
		mov		eax, g_randomIndex;

		test    ecx, ecx
		movss	[esp + 34h], xmm0

		jmp     returnAddress;
	}
}



void ApplyHack()
{
	g_patcher.WriteJmp(fruityDetour, (void *)fruityNaked); 

}