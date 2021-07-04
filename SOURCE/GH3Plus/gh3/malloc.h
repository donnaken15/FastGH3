#pragma once

namespace GH3
{
	///used for struct items?
	static void * (__cdecl *qbItemMalloc)(size_t size, int unused) = reinterpret_cast<void * (__cdecl *)(size_t size, int unused)>(0x00437410); 

	///Used for qbstructs
	static void * (__cdecl *qbMalloc)(size_t size, int unused) = reinterpret_cast<void * (__cdecl *)(size_t size, int unused)>(0x00402370);
}