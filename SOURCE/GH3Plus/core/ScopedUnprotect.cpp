#include "ScopedUnprotect.h"
#include <Windows.h>

namespace GH3P
{
	static const LPVOID GH3_CODE_START = (LPVOID)0x00401010;
	static const SIZE_T GH3_CODE_SIZE = 0x00490000;

    ScopedUnprotect::ScopedUnprotect() : ScopedUnprotect(GH3_CODE_START, GH3_CODE_SIZE)
    {
    }

    ScopedUnprotect::ScopedUnprotect(LPVOID addr, SIZE_T length) : addr_(addr), length_(length)
    {
        VirtualProtect(addr_, length_, PAGE_EXECUTE_READWRITE, &oldProtect_);
    }

    ScopedUnprotect::~ScopedUnprotect()
    {
        VirtualProtect(addr_, length_, oldProtect_, &oldProtect_);
    }
}