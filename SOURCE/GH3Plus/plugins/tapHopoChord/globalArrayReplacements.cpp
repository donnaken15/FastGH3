#include "core\Patcher.h"
#include "gh3\GH3Keys.h"
#include "gh3\GH3GlobalAddresses.h"
#include "tapHopoChord.h"
#include "gh3\QBKey.h"

#define ArrayLength(x) (sizeof(x)/sizeof(*(x)))

//.data:00957B90 
uint32_t g_gemColorKey[] = { KEY_GREEN, KEY_RED, KEY_YELLOW, KEY_BLUE, KEY_ORANGE, GH3::QbKey("open") };
void * g_gemColorKeyReferences[] =
{
	(void *)(0x0041B956 + 2),
	(void *)(0x0041E2F0 + 2),
	(void *)(0x00424ECB + 2),
	(void *)(0x0042B4D8 + 3),
	(void *)(0x00430AF4 + 2),
	(void *)(0x00435A5D + 3),
	(void *)(0x00435AA9 + 3),
	(void *)(0x00435C1D + 3),
	(void *)(0x00435C69 + 3),
};
//0x0041EC6A+3,

//.data:00957DF8
uint32_t g_HitNoteKey[] = { KEY_HITNOTE_GREEN, KEY_HITNOTE_RED, KEY_HITNOTE_YELLOW, KEY_HITNOTE_BLUE, KEY_HITNOTE_ORANGE, KEY_HITNOTE_YELLOW };
void * g_HitNoteKeyReference = (void *)(0x00435553 + 3);

//.data:00957BA4k
uint32_t g_brokeStringKey[] = { KEY_BROKEN_STRING_GREEN, KEY_BROKEN_STRING_RED, KEY_BROKEN_STRING_YELLOW, KEY_BROKEN_STRING_BLUE, KEY_BROKEN_STRING_ORANGE, KEY_BROKEN_STRING_YELLOW };
void * g_brokeStringKeyReference = (void *)(0x00429C64 + 3);

//"Button" arrays
//.data:00957BB8
uint32_t g_buttonLipKey[] = { KEY_BUTTON_G_LIPP1, KEY_BUTTON_R_LIPP1, KEY_BUTTON_Y_LIPP1, KEY_BUTTON_B_LIPP1, KEY_BUTTON_O_LIPP1, KEY_BUTTON_Y_LIPP1,
							  KEY_BUTTON_G_LIPP2, KEY_BUTTON_R_LIPP2, KEY_BUTTON_Y_LIPP2, KEY_BUTTON_B_LIPP2, KEY_BUTTON_O_LIPP2, KEY_BUTTON_Y_LIPP2 };
void * g_buttonLipKeyReference = (void *)(0x00429533 + 2);

//.data:00957BE0 ; QbKey g_buttonMidKey[10]
uint32_t g_buttonMidKey[] = { KEY_BUTTON_G_MIDP1, KEY_BUTTON_R_MIDP1, KEY_BUTTON_Y_MIDP1, KEY_BUTTON_B_MIDP1, KEY_BUTTON_O_MIDP1, KEY_BUTTON_Y_MIDP1,
							  KEY_BUTTON_G_MIDP2, KEY_BUTTON_R_MIDP2, KEY_BUTTON_Y_MIDP2, KEY_BUTTON_B_MIDP2, KEY_BUTTON_O_MIDP2, KEY_BUTTON_Y_MIDP2 };
void * g_buttonMidKeyReference = (void *)(0x00429539 + 2);

//.data:00957C08 ; QbKey g_buttonNeckKey[10]
uint32_t g_buttonNeckKey[] = { KEY_BUTTON_G_NECKP1, KEY_BUTTON_R_NECKP1, KEY_BUTTON_Y_NECKP1, KEY_BUTTON_B_NECKP1, KEY_BUTTON_O_NECKP1, KEY_BUTTON_Y_NECKP1,
							   KEY_BUTTON_G_NECKP2, KEY_BUTTON_R_NECKP2, KEY_BUTTON_Y_NECKP2, KEY_BUTTON_B_NECKP2, KEY_BUTTON_O_NECKP2, KEY_BUTTON_Y_NECKP2 };
void * g_buttonNeckKeyReference = (void *)(0x00429527 + 2);

//.data:00957C30
uint32_t g_buttonHeadKey[] = { KEY_BUTTON_G_HEADP1, KEY_BUTTON_R_HEADP1, KEY_BUTTON_Y_HEADP1, KEY_BUTTON_B_HEADP1, KEY_BUTTON_O_HEADP1, KEY_BUTTON_Y_HEADP1,
							   KEY_BUTTON_G_HEADP2, KEY_BUTTON_R_HEADP2, KEY_BUTTON_Y_HEADP2, KEY_BUTTON_B_HEADP2, KEY_BUTTON_O_HEADP2, KEY_BUTTON_Y_HEADP2, };
void * g_buttonHeadKeyReference = (void *)(0x0042952D + 2);

//.data:00957C58 ; QbKey g_fxWhammyKey[10]
uint32_t g_fxWhammyKey[] = { KEY_FX_WHAMMY_GP1, KEY_FX_WHAMMY_RP1, KEY_FX_WHAMMY_YP1, KEY_FX_WHAMMY_BP1, KEY_FX_WHAMMY_OP1, KEY_FX_WHAMMY_YP1,
							 KEY_FX_WHAMMY_GP2, KEY_FX_WHAMMY_RP2, KEY_FX_WHAMMY_YP2, KEY_FX_WHAMMY_BP2, KEY_FX_WHAMMY_OP2, KEY_FX_WHAMMY_YP2 };
void * g_fxWhammyKeyReferences[] =
{

	(void *)(0x0042B144 + 3),
	(void *)(0x00D7F06D + 3)
};


//.data:00957C80 ; QbKey g_fxWhammyParticleKey[10]
uint32_t g_fxWhammyParticleKey[] = { KEY_FX_WHAMMY_GP1_PARTICLE, KEY_FX_WHAMMY_RP1_PARTICLE, KEY_FX_WHAMMY_YP1_PARTICLE, KEY_FX_WHAMMY_BP1_PARTICLE, KEY_FX_WHAMMY_OP1_PARTICLE, KEY_FX_WHAMMY_YP1_PARTICLE,
									 KEY_FX_WHAMMY_GP2_PARTICLE, KEY_FX_WHAMMY_RP2_PARTICLE, KEY_FX_WHAMMY_YP2_PARTICLE, KEY_FX_WHAMMY_BP2_PARTICLE, KEY_FX_WHAMMY_OP2_PARTICLE, KEY_FX_WHAMMY_YP2_PARTICLE };
void * g_fxWhammyParticleKeyReferences[] =
{

	(void *)(0x0042B14B + 3),
	(void *)(0x00D7F074 + 3)
};

//main fxWhammyKey ussage
static uint32_t tempFxWhammyKey;
static uint32_t tempFxWhammyParticleKey;
void __fastcall whammyFxKeyFixing(uint32_t playerIndex, uint32_t gemIndex)
{
	//uint32_t *g_fxWhammyKey = reinterpret_cast<uint32_t *>(0x00957C58);
	//uint32_t *g_fxWhammyParticleKey = reinterpret_cast<uint32_t *>(0x00957C80);

	tempFxWhammyKey = g_fxWhammyKey[gemIndex + 6 * playerIndex];
	tempFxWhammyParticleKey = g_fxWhammyParticleKey[gemIndex + 6 * playerIndex];
}


static void *whammyFxKeyFixingDetour = (void *)0x0042B134;
void __declspec(naked) whammyFxKeyFixingNaked()
{
	static const void *returnAddress = (void *)0x0042B154;
	__asm
	{
		//mov ecx, gemIndex;
		push ebp;
		push esi;
		push edi;
		mov edx, eax;
		call whammyFxKeyFixing;
		mov ebp, tempFxWhammyKey;
		mov edx, tempFxWhammyParticleKey;
		mov edi, DWORD PTR ds:ADDR_noteFxRelated1;
		jmp returnAddress;
	}
}

//securom fxWhammyKey usage
//.securom:0173AD88 mov     eax, [esp + 1Ch]
//.securom : 0173AD8C lea     eax, [eax + ecx * 4]
//.securom : 0173AD8F add     eax, ecx

static void * whammyFxKeyFixingSecuromDetour = (void *)0x00D7F05A;
void __declspec(naked) whammyFxKeyFixingSecuromNaked()
{
	static const void * returnAddress = (void *)0x00D7F063;
	__asm
	{
		mov     eax, [esp + 1Ch];
		lea     eax, [eax + ecx * 4];
		lea     eax, [eax + ecx * 2];
		jmp		returnAddress;
	}
}




//.data:00957E0C 
uint32_t g_fxKey[] = {	KEY_FX_GP1, KEY_FX_GP2,
						KEY_FX_RP1, KEY_FX_RP2,
						KEY_FX_YP1, KEY_FX_YP2,
						KEY_FX_BP1, KEY_FX_BP2,
						KEY_FX_OP1, KEY_FX_OP2,
						KEY_FX_YP1, KEY_FX_YP2 };
void * g_fxKeyReferences[] =
{

	(void *)(0x00430A6C + 3),
	(void *)(0x00430A8A + 3)
};
void * g_fxKeyPlayer2Reference = (void *)(0x00424E76 + 4);
//00424E76 


template < uint32_t returnAddressRaw >
void __declspec(naked) mul_esi_ebx_24()
{
	static void *returnAddress = (void *)returnAddressRaw;
	__asm
	{
		lea esi, [ebx+2*ebx];
		shl esi, 3;
		jmp returnAddress;
	}
}





//00430A6C

//.data:00957B2C ; char **g_fretNames
char * g_fretNames[] = { "green", "red", "yellow", "blue", "orange", "yellow"};
void * g_fretNamesReferences[] =
{

	(void *)(0x0041EC6A + 3),
	(void *)(0x0041EC8B + 3),
	(void *)(0x00424E9D + 2),
	(void *)(0x00430ABD + 2),
	(void *)(0x004310F2 + 4),
	(void *)(0x004311A0 + 1),
	(void *)(0x0043273A + 3),
	(void *)(0x00432741 + 3),
	(void *)(0x00435ABE + 3),
	(void *)(0x00435C7E + 3),
};
void * g_fretNamesEndReferences[] =
{
	(void *)(0x00431175 + 1),
	(void *)(0x00431244 + 2),
};


//.data:00957B40 ; int g_fretMask[]
uint32_t g_fretMask[] = { FretMask::GREEN, FretMask::RED, FretMask::YELLOW, FretMask::BLUE, FretMask::ORANGE, FretMask::OPEN };
void * g_fretMaskReferences[] =
{

	(void *)(0x00424E84 + 2),
	(void *)(0x00430AA4 + 2),
};




bool TryApplyGlobalArrayPatches()
{
	if (!g_patcher.WritePointerMulti(g_gemColorKeyReferences, ArrayLength(g_gemColorKeyReferences), g_gemColorKey) ||
		!g_patcher.WritePointer(g_HitNoteKeyReference, g_HitNoteKey) ||
		!g_patcher.WritePointer(g_brokeStringKeyReference, g_brokeStringKey))
		return false;

	//if (!g_patcher.WritePointer(g_buttonLipKeyReference, g_buttonLipKey) ||
	//	!g_patcher.WritePointer(g_buttonMidKeyReference, g_buttonMidKey) ||
	//	!g_patcher.WritePointer(g_buttonNeckKeyReference, g_buttonNeckKey) ||
	//	!g_patcher.WritePointer(g_buttonHeadKeyReference, g_buttonHeadKey) ||
	//	!g_patcher.WriteJmp((void*)0x004294F3, &mul_esi_ebx_24<0x004294FA>)) //GH3 uses a clever optimization to multiply by 5 (lea reg [reg + 4*reg]) that we can't mimic in the same amount of bytes for multiplying by 6
	//	return false;
	
	if (!g_patcher.WriteJmp(whammyFxKeyFixingDetour, whammyFxKeyFixingNaked) ||
		!g_patcher.WriteJmp(whammyFxKeyFixingSecuromDetour, whammyFxKeyFixingSecuromNaked) ||
		!g_patcher.WritePointerMulti(g_fxWhammyKeyReferences, ArrayLength(g_fxWhammyKeyReferences), g_fxWhammyKey) ||
		!g_patcher.WritePointerMulti(g_fxWhammyParticleKeyReferences, ArrayLength(g_fxWhammyParticleKeyReferences), g_fxWhammyParticleKey))
		return false;
	
	
	if (!g_patcher.WritePointerMulti(g_fretNamesReferences, ArrayLength(g_fretNamesReferences), g_fretNames) ||
		!g_patcher.WritePointerMulti(g_fretNamesEndReferences, ArrayLength(g_fretNamesEndReferences), &g_fretNames[ArrayLength(g_fretNames)]))
		return false;
	
	if (!g_patcher.WritePointerMulti(g_fretMaskReferences, ArrayLength(g_fretMaskReferences), g_fretMask))
		return false;
	
	if (!g_patcher.WritePointerMulti(g_fxKeyReferences, ArrayLength(g_fxKeyReferences), g_fxKeyReferences) ||
		!g_patcher.WritePointer(g_fxKeyPlayer2Reference, &g_fxKeyReferences[1]))
		return false;

	return true;
}