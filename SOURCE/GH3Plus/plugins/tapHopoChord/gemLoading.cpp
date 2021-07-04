#include "core\Patcher.h"
#include "gh3\GH3Keys.h"
#include "gh3\GH3GlobalAddresses.h"
#include "tapHopoChord.h"


///////////////////////////////
// Primary gem loading logic //
///////////////////////////////


//Fix open note scaling
//Open notes should always be scaled as large as star notes


void __stdcall setGemScale(float *gemStartScale, float *gemEndScale, uint32_t gemIndex)
{
	static float *globalGemStartScale = reinterpret_cast<float *>(0x00A130C8);
	static float *globalGemEndScale = reinterpret_cast<float *>(0x00A130CC);
	static float *globalGemStarScale = reinterpret_cast<float *>(0x00A130D0);

	float startScale = *globalGemStartScale;
	float endScale = *globalGemEndScale;

	if (gemIndex == 5)
	{
		float starScale = *globalGemStarScale;
		startScale *= starScale;
		endScale *= starScale;
	}

	*gemStartScale = startScale;
	*gemEndScale = endScale;
}

static void * const setGemScaleDetour = (void *)0x00432956;
__declspec(naked) void setGemScaleNaked()
{
	static const void * const returnAddress = (void *)0x00432972;
	__asm
	{
		mov		eax, [esp + 94h]; //gem Index
		lea		ebx, [esp + 28h]; //gem End Scale
		lea		ecx, [esp + 18h]; //gem Start Scale
		push	eax;
		push	ebx;
		push    ecx;
		call	setGemScale;
		jmp		returnAddress;
	}
}






//Star gems
static void * const setStarGemAppearanceDetour = (void *)0x004328C2;
__declspec(naked) void makeStarTapGemsNaked()
{
	const static uint32_t tappingReturn = 0x00432901;

	const static uint32_t bossReturn = 0x004328ED;
	const static uint32_t normalReturn = 0x004328D7;

	//edx = 1
	//edi = gemMaterial2
	//eax = gemIndex
	//ebp = hammerOn flag
	// This is easier to do in asm since it's so simple. The bulk of this is moving the original logic around
	__asm
	{
		cmp ebp, edx; //cmp hopo flag vs 1
		jle L_NOT_TAPPING; //if 0 or 1 then it's strummed or hopo

						   //tapping note
		mov edi, [g_gemMatHammerBattle + eax * 4];
		jmp tappingReturn;

	L_NOT_TAPPING:
		push eax
			mov eax, ADDR_gameMode
			cmp dword ptr[eax], KEY_P2_BATTLE;
		je L_BOSS_BATTLE;
		mov eax, ADDR_bossBattle
			cmp dword ptr[eax], 0;
		jnz L_BOSS_BATTLE;

		pop eax
			jmp normalReturn;

	L_BOSS_BATTLE:
		pop eax;
		jmp bossReturn;
	}
}

//Normal gems
static void * const setNormalGemAppearanceDetour = (void *)0x0043293A;
__declspec(naked) void makeTapGemsNaked()
{
	const static uint32_t returnAddress = 0x0043294E;
	__asm
	{
		cmp     ebp, edx;
		jg      L_TAPPING_GEM;
		je      L_HAMMER_GEM;

		mov edi, [g_gemMatNormal + eax * 4];
		jmp returnAddress;

	L_HAMMER_GEM:
		mov edi, [g_gemMatHammer + eax * 4];
		jmp returnAddress;

	L_TAPPING_GEM:
		mov edi, [g_gemMatBattle + eax * 4];
		jmp returnAddress;
	}
}

//Sp Gems
static void * const setSpGemAppearanceDetour = (void *)0x0043289E;
__declspec(naked) void makeSpTapGemsNaked()
{
	const static uint32_t returnAddress = 0x004328A5;

	//.data:00A17868 g_gemMatHammerSp2 dd 0  
	__asm
	{
		mov		edx, 2;
		cmp		ebp, edx;
		mov		edx, 1;
		jnz		NORMAL_NOTE;

		//Tap notes
		mov		eax, SP_TAP_NOTE_GEM_INDEX;
		mov     edi, [g_gemMatBattle + eax * 4];
		jmp		returnAddress;

	NORMAL_NOTE:
		mov     edi, [g_gemMatSp + eax * 4];
		jmp returnAddress;
	}
}

//Point to the new gem constants
bool PatchGemConstants()
{
	g_patcher.WritePointer((void *)(0x00432895 + 3), &g_gemMatHammerSp);
	//g_patcher.WritePointer((void *)(0x0043289E + 3), &g_gemMatSp); <-- We are detouring here so don't patch this one out. Uncomment if detour is removed
	g_patcher.WritePointer((void *)(0x004328F1 + 3), &g_gemMatHammerBattle);
	g_patcher.WritePointer((void *)(0x004328FA + 3), &g_gemMatBattle);
	g_patcher.WritePointer((void *)(0x004328DB + 3), &g_gemMatHammerStar);
	g_patcher.WritePointer((void *)(0x004328E4 + 3), &g_gemMatStar);
	g_patcher.WritePointer((void *)(0x0043293E + 3), &g_gemMatHammer);
	g_patcher.WritePointer((void *)(0x00432947 + 3), &g_gemMatNormal);
	g_patcher.WritePointer((void *)(0x00432D4F + 3), &g_gemMatSpWhammy);
	g_patcher.WritePointer((void *)(0x00432D58 + 3), &g_gemMatWhammy);

	g_patcher.WritePointer((void *)(0x00432813 + 5), &g_gemLeftStartPosX);
	g_patcher.WritePointer((void *)(0x00432825 + 5), &g_gemLeftStartPosY);
	g_patcher.WritePointer((void *)(0x00432834 + 5), &g_gemLeftEndPosX);
	g_patcher.WritePointer((void *)(0x00432843 + 5), &g_gemLeftEndPosY);
	g_patcher.WritePointer((void *)(0x0043284E + 5), &g_gemStartPosX);
	g_patcher.WritePointer((void *)(0x00432860 + 5), &g_gemStartPosY);
	g_patcher.WritePointer((void *)(0x0043286F + 5), &g_gemEndPosX);
	g_patcher.WritePointer((void *)(0x0043287E + 5), &g_gemEndPosY);
	g_patcher.WritePointer((void *)(0x00432D2B + 5), &g_gemLeftAngle);
	g_patcher.WritePointer((void *)(0x00432D36 + 5), &g_gemAngle);

	return true;
	
}








int __fastcall gemStepLoopFixA(GH3::QbArray *note, uint32_t gemIndex)
{
	if (gemIndex != 5)
	{
		if (note->Get(8)) //Is Open
			return false; //Don't allow open note chords
		return note->Get(gemIndex + 1);
	}
	else
		return note->Get(8); //Open note is at index 8
}

static void * const gemStepLoopDetourA = (void *)(0x00435A20);
void __declspec(naked) gemStepLoopFixANaked()
{
	static const void * const returnAddress = (void *)0x00435A2D;
	__asm
	{
		push ecx;
		push edx;

		mov ecx, esi;
		mov edx, ebp;
		call gemStepLoopFixA;

		pop edx;
		pop ecx;
		jmp returnAddress;
	}
}



int __fastcall gemStepLoopFixB(uint32_t gemIndex, QbFretMask fretMask)
{
	QbFretMask gemMask;
	if (gemIndex < 5)
		gemMask = static_cast<QbFretMask>((1 << gemIndex));
	else
		gemMask = QbFretMask::QbOpen;

	if (fretMask & QbOpen && gemIndex != 5) //Don't let people make chords with open notes
		return false;

	return (gemMask & fretMask);
}

static void * const gemStepLoopDetourB = (void *)0x00435BE0;
void __declspec(naked) gemStepLoopFixBNaked()
{
	static const void * const returnAddress = (void *)0x00435BEF;
	__asm
	{
		mov		edx, [esp + 28h]; //note qbfretmask
		mov		ecx, ebp;
		call	gemStepLoopFixB;

		test	eax, eax;
		jmp		returnAddress;
	}
}









bool TryApplyGemLoadingPatches()
{
	if (!g_patcher.WriteJmp(setGemScaleDetour, &setGemScaleNaked))
		return false;

	if (!g_patcher.WriteJmp(setStarGemAppearanceDetour, &makeStarTapGemsNaked) ||
		!g_patcher.WriteJmp(setNormalGemAppearanceDetour, &makeTapGemsNaked) ||
		!g_patcher.WriteJmp(setSpGemAppearanceDetour, &makeSpTapGemsNaked) ||
		!PatchGemConstants())
		return false;

	if (!g_patcher.WriteJmp(gemStepLoopDetourA, gemStepLoopFixANaked) ||
		!g_patcher.WriteInt8((void*)(0x00435B92+2), 6))
		return false;

	if (!g_patcher.WriteJmp(gemStepLoopDetourB, gemStepLoopFixBNaked) ||
		!g_patcher.WriteInt8((void*)(0x00435D84+2), 6))
		return false;

	return true;
}