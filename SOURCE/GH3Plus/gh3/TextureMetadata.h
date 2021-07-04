#pragma once

#include "core\GH3Plus.h"
#include "QbKey.h"
#include <stdint.h>
#include <d3d9.h>


namespace GH3
{
	enum GH3P_API TextureMetadataFormat : __int8
	{
		TM_DXT1 = 0x1,
		TM_DXT2 = 0x2,
		TM_DXT3 = 0x3,
		TM_DXT4 = 0x4,
		TM_DXT5_1 = 0x5,
		TM_DXT5_2 = 0x6,
		TM_A8R8G8B8 = 0x0,
	};

	enum GH3P_API TextureMetadataType : __int8
	{
		TM_CubeTexture = 0x4,
		TM_VolumeTexture = 0x5,
	};

	struct GH3P_API __declspec(align(4)) TextureMetadata
	{
		uint8_t byte0;
		uint8_t byte1;
		uint8_t unkFlags;
		TextureMetadataType type;
		QbKey key;
		uint16_t stretchWidth;
		uint16_t stretchHeight;
		uint16_t unk1;
		uint16_t cullWidth;
		uint16_t cullHeight;
		uint16_t unk2;
		uint8_t MipLevels;
		__declspec(align(2)) TextureMetadataFormat textureFormat;
		uint8_t *texFile1;
		IDirect3DTexture9 *texture;
		uint32_t Length;
		uint8_t *texFile2;
	};
}
