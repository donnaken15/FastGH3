#include "core\Patcher.h"
#include "gh3\GH3Keys.h"
#include "gh3\GH3GlobalAddresses.h"
#include "gh3\malloc.h"
#include "gh3\QbStruct.h"
#include "tapHopoChord.h"

#include <cstring>


//////////////////////////////////////////
// Button model fixing (for open notes) //
//////////////////////////////////////////

void __fastcall buttonModelsInjector(GH3::QbStruct *buttonModels)
{
	/*  open
		gem_material = sys_Gem2D_Open_sys_Gem2D_Open
		gem_hammer_material = sys_Gem2D_Open_hammer_sys_Gem2D_Open_hammer
		star_material = sys_Star2D_Open_sys_Star2D_Open
		star_hammer_material = sys_Star2D_Open_Hammer_sys_Star2D_Open_Hammer
		battle_star_material = sys_BattleGEM_Yellow01_sys_BattleGEM_Yellow01
		battle_star_hammer_material = sys_BattleGEM_Hammer_Yellow01_sys_BattleGEM_Hammer_Yellow01
		whammy_material = sys_Whammy2D_Yellow_sys_Whammy2D_Yellow
		star_power_material = sys_gem2d_open_starpower_sys_gem2d_open_starpower
		star_power_hammer_material = sys_gem2d_open_starpower_hammer_sys_gem2d_open_starpower_hammer
		star_power_whammy_material = sys_Whammy2D_StarPower_sys_Whammy2D_StarPower
		dead_whammy = sys_Whammy2D_Dead_sys_Whammy2D_Dead
		name = button_z*/

	constexpr GH3::QbKey openKey = GH3::QbKey("open");

	constexpr GH3::QbKey gem_material = GH3::QbKey("gem_material");
	constexpr GH3::QbKey gem_hammer_material = GH3::QbKey("gem_hammer_material");
	constexpr GH3::QbKey star_material = GH3::QbKey("star_material");
	constexpr GH3::QbKey star_hammer_material = GH3::QbKey("star_hammer_material");
	constexpr GH3::QbKey battle_star_material = GH3::QbKey("battle_star_material");
	constexpr GH3::QbKey battle_star_hammer_material = GH3::QbKey("battle_star_hammer_material");
	constexpr GH3::QbKey whammy_material = GH3::QbKey("whammy_material");
	constexpr GH3::QbKey star_power_material = GH3::QbKey("star_power_material");
	constexpr GH3::QbKey star_power_hammer_material = GH3::QbKey("star_power_hammer_material");
	constexpr GH3::QbKey star_power_whammy_material = GH3::QbKey("star_power_whammy_material");
	constexpr GH3::QbKey dead_whammy = GH3::QbKey("dead_whammy");
	constexpr GH3::QbKey name = GH3::QbKey("name");

	constexpr GH3::QbKey gem_material_value = OpenTextureKey;
	constexpr GH3::QbKey gem_hammer_material_value = OpenHammerTextureKey;
	constexpr GH3::QbKey star_material_value = OpenStarTextureKey;
	constexpr GH3::QbKey star_hammer_material_value = OpenStarHammerTextureKey;
	constexpr GH3::QbKey battle_star_material_value = OpenStarTextureKey;
	constexpr GH3::QbKey battle_star_hammer_material_value = OpenStarHammerTextureKey;
	constexpr GH3::QbKey whammy_material_value = GH3::QbKey("sys_Whammy2D_Dead_sys_Whammy2D_Dead");
	constexpr GH3::QbKey star_power_material_value = OpenStarpowerTextureKey;
	constexpr GH3::QbKey star_power_hammer_material_value = OpenStarpowerHammerTextureKey;
	constexpr GH3::QbKey star_power_whammy_material_value = GH3::QbKey("sys_Whammy2D_StarPower_sys_Whammy2D_StarPower");
	constexpr GH3::QbKey dead_whammy_value = GH3::QbKey("sys_Whammy2D_Dead_sys_Whammy2D_Dead");
	constexpr GH3::QbKey name_value = GH3::QbKey("button_z");

	if (!buttonModels->ContainsItem(openKey))
	{
		GH3::QbStruct *openModel = (GH3::QbStruct *)GH3::qbMalloc(sizeof(GH3::QbStruct), 1);
		memset(openModel, 0, sizeof(GH3::QbStruct));

		openModel->InsertQbKeyItem(gem_material, gem_material_value);
		openModel->InsertQbKeyItem(gem_hammer_material, gem_hammer_material_value);
		openModel->InsertQbKeyItem(star_material, star_material_value);
		openModel->InsertQbKeyItem(star_hammer_material, star_hammer_material_value);
		openModel->InsertQbKeyItem(battle_star_material, battle_star_material_value);
		openModel->InsertQbKeyItem(battle_star_hammer_material, battle_star_hammer_material_value);
		openModel->InsertQbKeyItem(whammy_material, whammy_material_value);
		openModel->InsertQbKeyItem(star_power_material, star_power_material_value);
		openModel->InsertQbKeyItem(star_power_hammer_material, star_power_hammer_material_value);
		openModel->InsertQbKeyItem(star_power_whammy_material, star_power_whammy_material_value);
		openModel->InsertQbKeyItem(dead_whammy, dead_whammy_value);
		openModel->InsertQbKeyItem(name, name_value);

		buttonModels->InsertQbStructItem(openKey, openModel);
	}
}

static void * const buttonModelsInjectorDetour = (void *)0x0042740F;
_declspec(naked) void buttonModelsInjectorNaked()
{
	//.text : 00427408 0FC call    GlobalMap__GetStruct
	//.text : 0042740D 0FC mov     ebp, eax
	//.text : 0042740F 0FC mov     eax, KEY_GEM_START_SCALE <--detour here
	//.text : 00427414 0FC push    esi; a2
	//.text : 00427415 100 push    eax
	//.text : 00427416 104 mov     [esp+104h+buttonModels2], ebp <---return address

	static const void * const returnAddress = (void *)0x00427416;
	__asm
	{
		mov		ecx, ebp;
		call	buttonModelsInjector;

		//resume execution
		mov     eax, KEY_GEM_START_SCALE;
		push    esi; //a2
		push    eax;
		jmp		returnAddress;
	}
}



///////////////////////
// Gem mutator logic //
///////////////////////




static void * const gemMutationSPActivationBranch = (void *)0x004276AC; //redirect to gemMutationSPActivationBranchNaked
static void * const gemMutationSPActivationBranch_Hammer = (void *)0x004276B2;
static void * const gemMutationSPActivationBranch_NoHammer = (void *)0x004276D9;
static void * const gemMutationSPActivationBranch_Tap = (void *)0x004276CF;

// Fixes tap note mutation upon activating star power
_declspec(naked) void gemMutationSPActivationBranchNaked()
{
	__asm
	{
		// Previous comparison was cmp		[esp + 14h], 0
		jz		NO_HAMMER;
		cmp		[esp + 14h], 1;  //[esp + 0F4h + hammerOn]
		jz		HAMMER;

		//Tap Notes
		mov		eax, SP_TAP_NOTE_GEM_INDEX;
		mov     eax, [g_gemMatBattle + eax * 4]; // g_gemMatHammerSp2[eax * 4]
		mov     ecx, [ADDR_someStruct + esi * 4];	//this
		push    eax;	//textureKey
		jmp     gemMutationSPActivationBranch_Tap;

	NO_HAMMER:
		jmp		gemMutationSPActivationBranch_NoHammer;
	HAMMER:
		mov     ecx, [esp + 10h];				// [esp + 0F4h + keyDest]; this
		jmp		gemMutationSPActivationBranch_Hammer;
	}
}




static void * const gemMutationSPDeactivationBranch = (void *)0x00427768; //redirect to gemMutationSPDeactivationBranchNaked
static void * const gemMutationSPDeactivationBranch_HammerOrTap = (void *)0x0042776F;
static void * const gemMutationSPDeactivationBranch_NoHammer = (void *)0x00427791;

// Fixes tap note mutation upon losing star power
_declspec(naked) void gemMutationSPDeactivationBranchNaked()
{
	__asm
	{
		// Previous comparison was cmp		[esp + 14h], 0
		jz		NO_HAMMER;
		cmp		[esp + 14h], 1;  //[esp + 0F4h + hammerOn]
		jz		HAMMER;

	//TAP:
		mov     eax, KEY_BATTLE_STAR_MATERIAL;
		jmp     gemMutationSPDeactivationBranch_HammerOrTap;

	NO_HAMMER:
		jmp		gemMutationSPDeactivationBranch_NoHammer;

	HAMMER:
		mov     eax, KEY_GEM_HAMMER_MATERIAL;
		jmp		gemMutationSPDeactivationBranch_HammerOrTap;
	}
}

static void * const gemMutationPhraseMissBranch = (void *)0x00427B86; //redirect to gemMutationPhraseMissBranchNaked
// Fixes tap note mutation upon missing SP phrase
_declspec(naked) void gemMutationPhraseMissBranchNaked()
{
	static const void * const gemMutationPhraseMissBranch_NoHammer = (void *)0x00427BA0;
	static const void * const gemMutationPhraseMissBranch_HammerAndTap = (void *)0x00427B8D;
	__asm
	{
		// Previous comparison was cmp		[esp + 14h], 0
		jz		NO_HAMMER;
		cmp		[esp + 14h], 1;  //[esp + 0F4h + hammerOn]
		jz		HAMMER;

		//Tap Notes
		mov     eax, KEY_BATTLE_STAR_MATERIAL;
		jmp     gemMutationPhraseMissBranch_HammerAndTap;

	NO_HAMMER:
		jmp		gemMutationPhraseMissBranch_NoHammer;
	HAMMER:
		mov     eax, KEY_GEM_HAMMER_MATERIAL;
		jmp		gemMutationPhraseMissBranch_HammerAndTap;
	}
}




static void * const gemMutationSPtoStarBranch = (void *)0x00427D0E; //redirect to gemMutationSPtoStarBranchNaked
static void * const gemMutationSPtoStarBranch_Hammer = (void *)0x00427D14;
static void * const gemMutationSPtoStarBranch_NoHammer = (void *)0x00427D2F;
static void * const gemMutationSPtoStarBranch_Tap = (void *)0x00427D19;

// Fixes tap note mutation upon star power running out with an SP phrase back into gems
_declspec(naked) void gemMutationSPtoStarBranchNaked()
{
	__asm
	{
		// Previous comparison was cmp		[esp + 14h], 0
		jz		NO_HAMMER;
		cmp[esp + 14h], 1;  //[esp + 0F4h + hammerOn]
		jz		HAMMER;

		//Tap Notes
		mov     ecx, [esp + 10h]; //this //[esp + 0F4h + keyDest]
		mov     eax, KEY_BATTLE_STAR_HAMMER_MATERIAL;
		jmp     gemMutationSPtoStarBranch_Tap;

	NO_HAMMER:
		jmp		gemMutationSPtoStarBranch_NoHammer;

	HAMMER:
		mov     ecx, [esp + 10h]; //this //[esp + 0F4h + keyDest]
		jmp		gemMutationSPtoStarBranch_Hammer;
	}
}


// 00427AAB
static void * const gemMutationStarOverlapBranch = (void *)0x00427AAB; //redirect to gemMutationStarOverlapBranchNaked
static void * const gemMutationStarOverlapBranch_Exit = (void *)0x00427646;

// Fixes tap note mutation upon star power overlapping (previously) star gems
_declspec(naked) void gemMutationStarOverlapBranchNaked()
{
	__asm
	{
		// Previous comparison was cmp		[esp + 14h], 0
		cmp		[esp + 14h], 1;  //[esp + 0F4h + hammerOn]
		jz		HAMMER;

		//Tap Notes
		mov		eax, SP_TAP_NOTE_GEM_INDEX;
		mov     eax, [g_gemMatBattle + eax * 4]; // g_gemMatHammerSp2[eax * 4]

	HAMMER:
		jmp		gemMutationStarOverlapBranch_Exit;
	}
}

bool TryApplyGemMutationPatches()
{
	return  (g_patcher.WriteJmp(gemMutationSPActivationBranch, &gemMutationSPActivationBranchNaked) &&
			g_patcher.WriteJmp(gemMutationSPDeactivationBranch, &gemMutationSPDeactivationBranchNaked) &&
			g_patcher.WriteJmp(gemMutationPhraseMissBranch, &gemMutationPhraseMissBranchNaked) &&
			g_patcher.WriteJmp(gemMutationStarOverlapBranch, &gemMutationStarOverlapBranchNaked) &&
			g_patcher.WriteJmp(gemMutationSPtoStarBranch, &gemMutationSPtoStarBranchNaked) &&
			g_patcher.WriteJmp(buttonModelsInjectorDetour, &buttonModelsInjectorNaked));
}