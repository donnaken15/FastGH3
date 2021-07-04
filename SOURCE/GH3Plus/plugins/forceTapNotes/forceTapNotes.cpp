#include "core\Patcher.h"
#include "gh3\GH3Keys.h"
#include "gh3\GH3GlobalAddresses.h"
#include "forceTapNotes.h"

static void *setHopoFlagDetour =  (void *)0x0041D22A;
static void *setHopoFlagDetour2 = (void *)0x0041D41B;

static GH3P::Patcher g_patcher = GH3P::Patcher(__FILE__);

__declspec(naked) void forceTapFlagNaked()
{
    static const uint32_t returnAddress = 0x0041D233;
    __asm
    {
        mov [esp+20h],  2  //Tapping flag
        mov eax, KEY_PLAYER
        jmp returnAddress;
    }
}

__declspec(naked) void forceTapFlagNaked2()
{
    static const uint32_t returnAddress = 0x0041D423;
    __asm
    {
        mov edx, 2
        mov ecx, [esp+14h]
        jmp returnAddress
    }
}

void ApplyHack()
{
    g_patcher.WriteJmp(setHopoFlagDetour2, &forceTapFlagNaked2);
}