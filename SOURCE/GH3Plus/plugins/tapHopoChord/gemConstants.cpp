#include "core\Patcher.h"
#include "gh3\GH3Keys.h"
#include "gh3\GH3GlobalAddresses.h"
#include "tapHopoChord.h"

float g_gemStartPosX[6] = { 0 };
float g_gemStartPosY[6] = { 0 };
float g_gemEndPosX[6] = { 0 };
float g_gemEndPosY[6] = { 0 };

float g_gemLeftStartPosX[6] = { 0 };
float g_gemLeftStartPosY[6] = { 0 };
float g_gemLeftEndPosX[6] = { 0 };
float g_gemLeftEndPosY[6] = { 0 };

float g_gemLeftAngle[6] = { 0 };
float g_gemAngle[6] = { 0 };

uint32_t g_gemMatBattle[6] = { 0 };
uint32_t g_gemMatHammerBattle[6] = { 0 };

uint32_t g_gemMatStar[6] = { 0 };
uint32_t g_gemMatHammerStar[6] = { 0 };

uint32_t g_gemMatNormal[6] = { 0 };
uint32_t g_gemMatHammer[6] = { 0 };

uint32_t g_gemMatSp[6] = { 0 };
uint32_t g_gemMatHammerSp[6] = { 0 };

uint32_t g_gemMatWhammy[6] = { 0 };
uint32_t g_gemMatSpWhammy[6] = { 0 };



void __declspec(naked) setupOpenNote()
{
	__asm pushad;

	//Copy most of the yellow yellow note properties
	g_gemStartPosX[5] = g_gemStartPosX[2];
	g_gemStartPosY[5] = g_gemStartPosY[2];
	g_gemEndPosX[5] = g_gemEndPosX[2];
	g_gemEndPosY[5] = g_gemEndPosY[2];
	g_gemLeftStartPosX[5] = g_gemLeftStartPosX[2];
	g_gemLeftStartPosY[5] = g_gemLeftStartPosY[2];
	g_gemLeftEndPosX[5] = g_gemLeftEndPosX[2];
	g_gemLeftEndPosY[5] = g_gemLeftEndPosY[2];
	g_gemLeftAngle[5] = g_gemLeftAngle[2];
	g_gemAngle[5] = g_gemAngle[2];

	g_gemMatBattle[5] = OpenStarTextureKey;
	g_gemMatHammerBattle[5] = OpenStarHammerTextureKey;
	g_gemMatStar[5] = OpenStarTextureKey;
	g_gemMatHammerStar[5] = OpenStarHammerTextureKey;
	g_gemMatNormal[5] = OpenTextureKey;
	g_gemMatHammer[5] = OpenHammerTextureKey;
	g_gemMatSp[5] = OpenStarpowerTextureKey;
	g_gemMatHammerSp[5] = OpenStarpowerHammerTextureKey;
	g_gemMatWhammy[5] = g_gemMatWhammy[2];
	g_gemMatSpWhammy[5] = g_gemMatSpWhammy[2];

	__asm popad;
	__asm retn;
}

static void * const gemConstantFixingDetour = (void *)0x0041BB91;
void __declspec(naked) gemConstantFixingNaked()
{
	static void * const loopAddress = (void *)0x0041B954;
	static void * const returnAddress = (void *)0x0041BC62;
	__asm
	{
		fstp	[g_gemLeftStartPosX + esi];
		mov     ecx, [esp + 48h];
		fld     dword ptr[eax + 8];
		mov     eax, [esp + 18h];
		fstp	[g_gemLeftStartPosY + esi];
		movss   xmm0, dword ptr[esp + 1Ch];
		fld     dword ptr[eax + 4];
		fstp	[g_gemLeftEndPosX + esi];
		fld     dword ptr[eax + 8];
		mov     eax, [esp + 44h];
		fstp	[g_gemLeftEndPosY + esi];
		fld     dword ptr[ebp + 4];
		fstp	[g_gemStartPosX + esi];
		fld     dword ptr[ebp + 8];
		fstp	[g_gemStartPosY + esi];
		fld     dword ptr[ebx + 4];
		fstp	[g_gemEndPosX + esi];
		fld     dword ptr[ebx + 8];
		mov		[g_gemMatHammerSp + esi], edx;
		mov     edx, [esp + 4Ch];
		fstp	[g_gemEndPosY + esi];
		mov		[g_gemMatSp + esi], eax;
		mov     eax, [esp + 50h];
		mov		[g_gemMatHammerBattle + esi], ecx;
		mov     ecx, [esp + 54h];
		mov		[g_gemMatBattle + esi], edx;
		mov     edx, [esp + 58h];
		mov		[g_gemMatHammerStar + esi], eax;
		mov     eax, [esp + 5Ch];
		mov		[g_gemMatStar + esi], ecx;
		mov     ecx, [esp + 60h];
		mov		[g_gemMatHammer + esi], edx;
		mov     edx, [esp + 64h];
		movss	[g_gemLeftAngle + esi], xmm0;
		movss   xmm0, dword ptr[esp + 20h];
		mov		[g_gemMatNormal + esi], eax;
		movss	[g_gemAngle + esi], xmm0;
		mov		[g_gemMatSpWhammy + esi], ecx;
		mov		[g_gemMatWhammy + esi], edx;

		add     esi, 4;
		cmp     esi, 20;
		jl      LOOP_ADDRESS;
		call    setupOpenNote; //
		jmp     returnAddress;
	LOOP_ADDRESS:
		jmp		loopAddress;
	}
}








bool TryApplyGemConstantsPatches()
{
	return g_patcher.WriteJmp(gemConstantFixingDetour, gemConstantFixingNaked);
}