#include "ScopedUnprotect.h"
#include <Windows.h>
#include "GH3Plus.h"

namespace GH3P
{
    void WriteJmp(LPVOID address, LPVOID target)
    {
        GH3P::ScopedUnprotect unprotect(address, 12);

        DWORD jmpSize = (DWORD)target - (DWORD)address - 5;
        BYTE *arr = static_cast<BYTE *>(address);

        arr[0] = 0xE9;
        memcpy(&arr[1], &jmpSize, sizeof(jmpSize));
    }

	void WriteJmp(void * address, void * target)
	{
	}
}