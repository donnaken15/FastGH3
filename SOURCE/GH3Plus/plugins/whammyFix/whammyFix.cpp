#include "whammyFix.h"
#include "core\Patcher.h"
#include "gh3\GH3Keys.h"
#include "gh3\GH3GlobalAddresses.h"
#include <Windows.h>

static const uint32_t GH3_MAX_PLAYERS = 2;


//Static variables for hack functionality
static uint32_t g_clock[GH3_MAX_PLAYERS] = { 0 };
static uint8_t g_prevWhammy[GH3_MAX_PLAYERS] = { 0 };
static uint8_t g_prevRealWhammy[GH3_MAX_PLAYERS] = { 0 };
static uint64_t g_lastChange[GH3_MAX_PLAYERS] = { 0 };

static uint32_t controllerStructBuffer=0xDEADC0DE;

static uint32_t g_structure[GH3_MAX_PLAYERS] = { 0 };
static uint32_t g_player[GH3_MAX_PLAYERS] = { 0 };

static const uint32_t whammyThreshold = 200;
static const uint8_t minWibble = 24;

uint8_t __stdcall modifyWhammyInput(uint32_t controllerStruct, uint32_t rawInput); 

static GH3P::Patcher g_patcher = GH3P::Patcher(__FILE__);




static void * const controllerRelatedStart = (void *)0x00522CD0;
__declspec(naked) void storeControllerStructNaked()
{
    static const uint32_t returnAddress = 0x00522CD6;
    __asm
    {
        mov controllerStructBuffer, ecx;
        sub esp, 118h
        jmp returnAddress;
    }
}




static void * const controllerInputDetour = (void *)0x005249C5;
__declspec(naked) void modifyWhammyInputNaked()
{
    static const uint32_t returnAddress = 0x005249CF;
    __asm
    {
        pushad;

        push esi;
        push eax; //rawInput
        mov eax, controllerStructBuffer;
        mov eax, [eax];
        push eax; //controllerStruct
        call modifyWhammyInput
        pop esi
        mov[esi + 1Dh], al;
        popad;
        
        mov eax, ADDR_byteDebugController;
        cmp [eax], 0;

        jmp returnAddress;
    }
}

uint32_t getPlayerIndex(uint32_t controllerStructPtr)
{

    static uint32_t newestPlayer = 0;

    //use the controllerStruct

    for (uint32_t i = 0; i < GH3_MAX_PLAYERS; ++i)
    {
        if (controllerStructPtr == g_structure[i])
            return g_player[i];
    }

    //shift existing cells right and push current at 0

    for (uint32_t i = GH3_MAX_PLAYERS - 1; i > 0; --i)
    {
        g_structure[i] = g_structure[i - 1];
        g_player[i] = g_player[i - 1];
    }

    g_structure[0] = controllerStructPtr;
    g_player[0] = newestPlayer;
    newestPlayer = (newestPlayer + 1) % GH3_MAX_PLAYERS;

    return g_player[0];
}


uint8_t __stdcall modifyWhammyInput(uint32_t controllerStruct, uint32_t rawInput)
{
    rawInput &= 0xFF;
    uint32_t pIdx = getPlayerIndex(controllerStruct);

    ++g_clock[pIdx];

    uint64_t curTime = GetTickCount64();


    if (g_prevRealWhammy[pIdx] != rawInput)
        g_lastChange[pIdx] = curTime;
    g_prevRealWhammy[pIdx] = rawInput;

    uint8_t whammy = (uint8_t)rawInput;

    if ( (curTime - g_lastChange[pIdx]) < whammyThreshold)
    {
        if (g_clock[pIdx] % 2 == 0)
        {
            if (whammy > 100)
                whammy -= 100;
            else
                whammy = 0;
        }
        else
        {
            if (whammy == 0)
                whammy = minWibble;
        }
    }

    g_prevWhammy[pIdx] = whammy;

    return whammy;
}


void ApplyHack()
{
    for (int i = 0; i < GH3_MAX_PLAYERS; ++i)
    {
        g_structure[i] = 0xD15EA5ED;
        g_player[i] = 0xDEADFACE;
    }
    g_patcher.WriteJmp(controllerRelatedStart, &storeControllerStructNaked);
    g_patcher.WriteJmp(controllerInputDetour, &modifyWhammyInputNaked);
}