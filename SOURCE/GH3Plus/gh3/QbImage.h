#pragma once

#include "core\GH3Plus.h"
#include "QbKey.h"
#include "TextureMetadata.h"
#include <stdint.h>


namespace GH3
{
	struct QbImage_VTABLE
	{
		//QbImage *(__thiscall *SetVtable)(char flags);
		//QbKey	 (__thiscall *GetQbKey)();
		int		 (__thiscall *GetStretchWidth)();
		int		 (__thiscall *anonymous_0)();
		bool	 (__thiscall *CreateFromImgFile)(const char *fileName);
		bool	 (__thiscall *CreateTextureFromMetadata)(TextureMetadata *textureMetadata, int a3, int a4);
		bool	 (__thiscall *CreateNewTexture)(QbKey aKey, int cullWidth, int cullHeight, int a5, int a6, int a7, TextureMetadataFormat format);
	};

	struct __declspec(align(4)) QbImage
	{
		QbImage_VTABLE *vtable;
		QbKey key;
		uint32_t flags;
		uint8_t MipLevels;
		uint8_t byteD;
		TextureMetadata *textureMetadata;
	};
}