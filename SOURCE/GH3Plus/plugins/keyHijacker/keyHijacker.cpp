#include "keyHijacker.h"
#include "resource.h"
#include "core\Patcher.h"
#include "gh3\GH3Keys.h"
#include "gh3\GH3GlobalAddresses.h"
#include <Windows.h>
#include <mmsystem.h>
#include <string>
#include <cstdio>
#pragma comment(lib,"Winmm.lib")

static const LPVOID changeDetour = (LPVOID)0x00538EF0;
static const LPVOID gameFrameDetour = (LPVOID)0x005B0C50;
static uint32_t changeSpeedStruct[] = { 0x00010000, 0xCDCDCDCD,
    0x00000500, 0x16D91BC1, 0x3F800000, 0x00000000 };
#ifdef PITCHSHIFT
static uint32_t changePitchStruct[] = { 0x00010000, 0xCDCDCDCD,
    0x00001B00, 0xFD2C9E38, 0x3370A847, 0xCDCDCDCD,
    0x00000500, 0xD8604126, 0x3F800000, 0x00000000 };
#endif

static float g_hackedSpeed = 1.0f;
static float g_hackedPitch = 1.0f;
static int32_t g_currentInt = 100;
static int32_t g_multiplier = 0;
static bool g_keyHeld = false;
static int g_speedUpdated = 0;

static GH3P::Patcher g_patcher = GH3P::Patcher(__FILE__);

BOOL PlayResource(LPCWSTR lpName)
{
    BOOL bRtn;
    LPWSTR lpRes;
    HRSRC hResInfo;
    HGLOBAL hRes;

    // Find the WAVE resource. 

    hResInfo = FindResource(NULL, lpName, L"WAVE");
    if (hResInfo == NULL)
        return FALSE;

    // Load the WAVE resource. 

    hRes = LoadResource(NULL, hResInfo);
    if (hRes == NULL)
        return FALSE;

    // Lock the WAVE resource and play it. 

    lpRes = (LPWSTR)LockResource(hRes);
    if (lpRes != NULL) {
        bRtn = sndPlaySound(lpRes, SND_MEMORY | SND_SYNC | SND_NODEFAULT);
        UnlockResource(hRes);
    }
    else
        bRtn = 0;

    // Free the WAVE resource and return success or failure. 

    FreeResource(hRes);
    return bRtn;
}

__declspec(naked) void changeOverrideNaked()
{
    static const uint32_t returnAddress = 0x538EFA;
    static const uint32_t speedFactorKey = 0x16D91BC1;
    static const uint32_t structureNameKey = 0xFD2C9E38;
    static const uint32_t pitchStructKey = 0x3370A847;
    static const uint32_t pitchKey = 0xD8604126;

    __asm
    {
    CHANGE:
        // Copied start of "change"
        sub     esp, 1Ch
        push    ebp;
        mov     ebp, [esp + 36]; // aList
        push    esi;
        push    edi;

        // If the hacked values need to be changed, call change recursively to set them
        pushad;
        mov     eax, g_speedUpdated;
        test    eax, eax;
        jz      NORECURSE;
        lea     eax, g_speedUpdated;
        mov     [eax], 0;
        lea     eax, changeSpeedStruct;
        push    eax;
        call    CHANGE;
        pop     eax; // remove the stack item that change didn't clean up
#ifdef PITCHSHIFT
        lea     eax, changePitchStruct;
        push    eax;
        call    CHANGE;
        pop     eax; // remove the stack item that change didn't clean up
#endif
    NORECURSE:
        popad;
        // Check for current_speedfactor
        mov     ecx, dword ptr[ebp + 4]; // Using edi and ecx because they are overwritten by
        mov     edi, dword ptr[ecx + 4]; // existing code immediately after jumping back
        cmp     edi, speedFactorKey;     
        je      OVERWRITESPEED;
#ifdef PITCHSHIFT
        // Check for structurename
        cmp     edi, structureNameKey;
        je      CHECKPITCHSTRUCT;
        jmp     returnAddress;

    CHECKPITCHSTRUCT:
        mov     edi, dword ptr[ecx + 8];
        cmp     edi, pitchStructKey;
        je      CHECKPITCH;
        jmp     returnAddress;

    CHECKPITCH:
        mov     edi, dword ptr[ecx + 12]; // Next node of the linked list
        mov     ecx, dword ptr[edi + 4];
        cmp     ecx, pitchKey;
        je      OVERWRITEPITCH;
        jmp     returnAddress;
#else
        jmp     returnAddress
#endif
    OVERWRITESPEED:
        mov     edi, g_hackedSpeed;
        mov     dword ptr[ecx + 8], edi;
        jmp     returnAddress;
#ifdef PITCHSHIFT
    OVERWRITEPITCH:
        mov     ecx, g_hackedPitch;
        mov     dword ptr[edi + 8], ecx;
        jmp     returnAddress;
#endif
    }
}

int32_t getKeypadNumber();

void applyNewSpeed(int32_t newSpeed)
{
    if (newSpeed <= 0)
        return;
    g_hackedSpeed = (float)(newSpeed / 100.0f);
    g_hackedPitch = 1.0f / g_hackedSpeed;
    
    g_speedUpdated = 1;
}

void resetKeys()
{
    g_currentInt = 100;
    g_multiplier = 0;
}

void checkKeys()
{
    int number = getKeypadNumber();

    if (!g_keyHeld && number >= 0)
    {
        g_keyHeld = true;
        g_multiplier += (g_currentInt * number);
        g_currentInt /= 10;

        if (g_currentInt == 0)
        {
            applyNewSpeed(g_multiplier);
            resetKeys();
            
            PlaySound(TEXT("quack.wav"), NULL, SND_FILENAME | SND_ASYNC);
        }
    }

    if (g_keyHeld && number == -1)
    {
        g_keyHeld = false;
    }
}

int32_t getKeypadNumber()
{
    static uint8_t keys[256];
    memset(keys, 0, sizeof(keys));
    GetKeyboardState(keys);

    for (int i = 0; i < 10; ++i)
    {
        if ( (keys[VK_NUMPAD0 + i] & 0x80) || (keys['0' + i] & 0x80) )
            return i;
    }

    return -1;
}

_declspec(naked) void checkKeysNaked()
{
    static const uint32_t returnAddress = 0x005B0C59;

    __asm
    {
        pushad;
        call checkKeys;
        popad;

        //Displaced code
        mov     eax, [ecx + 8];
        and     eax, 0Fh;
        add     eax, 0FFFFFFFFh;

        jmp returnAddress;
    }
}

void ApplyHack()
{
    // set up pointers within the changeX structs
    changeSpeedStruct[1] = (uint32_t) &changeSpeedStruct[2];
#ifdef PITCHSHIFT
    changePitchStruct[1] = (uint32_t) &changePitchStruct[2];
    changePitchStruct[5] = (uint32_t) &changePitchStruct[6];
#endif

    g_patcher.WriteJmp(changeDetour, &changeOverrideNaked);
    g_patcher.WriteJmp(gameFrameDetour, &checkKeysNaked);
}
