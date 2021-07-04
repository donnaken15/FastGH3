#include "core\Patcher.h"
#include "gh3\GH3Keys.h"
#include "gh3\GH3GlobalAddresses.h"

#include "textureHelper.h"
#include <random>
#include <iostream>

//static void * guitarInputDetour = (void *)0x00431D65;  ////0x00431CCE; //0x0043190D;
//static void * guitarInputDetour2 = (void *)0x0043226B; // 0x004320EC; //overstrum

static void * const textureKeyDetour = (void *)0x004FAC60; //0x004327D2; // 0x00432733;

static GH3P::Patcher g_patcher = GH3P::Patcher(__FILE__);

static uint32_t g_newTexture = 0;

static uint32_t ignoredKeys[]
{
	0x0, //error

	0x02EC4A8A, //nowbar
	0x0B7DDD3A,
	0x1FB8EE56,
	0x3BEEDF17,
	0x488A30D9,
	0x53A29CF3,
	0x541C5B42,
	0x55173AC7,
	0x5E62E0F2,
	0x62442C5A,
	0x76FFFD01,
	0x89657E48,
	0x8A5CBE09,
	0x901A7B90,
	0x9C1D32A6,
	0xA3ABE406,
	0xA57BFEF9,
	0xA6461323,
	0xAAE08B99,
	0xAE3F6FBD,
	0xCADD3843,
	0xD4C574A7,
	0xE4A7C8B6,
	0xE92CFF13,
	0xEF5FAC20,
	0xF0B602EB,

	0xE0D86413, //fretbar
	0x3F7CAAE1,
	0x82ADD9D0,

	0xC5C51FEE, //sparks
	0x3A9A5D3E,

	0x3E4F70B3,	//sys_string01_sys_string01


};

int __stdcall textureManipulator(uint32_t key);

__declspec (naked) void textureHelperNaked()
{
	static const uint32_t returnAddress = 0x004FAC68;

	__asm
	{
		mov     eax, [esp+4]

		pushad
		push	eax
		call	textureManipulator
		mov		g_newTexture, eax
		popad

		mov		eax, g_newTexture

		push    esi
		push    edi
		xor     edi, edi

		jmp     returnAddress;
	}
}

int __stdcall textureManipulator(uint32_t key)
{
	for (int i = 0; i < (sizeof(ignoredKeys) / 4); ++i)
	{
		if (key == ignoredKeys[i])
			return key;
	}

	std::cout << key << "\n";

	return		0x58C6A27F;// 0x1FB75CA1; //lightning
}


void ApplyHack()
{

	g_patcher.WriteJmp(textureKeyDetour, (void *)textureHelperNaked);

}