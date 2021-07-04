#include "gh3\GH3Keys.h"
#include "core\Patcher.h"
#include "startup.h"
#include <stdint.h>
#include <Windows.h>

//static GH3P::Patcher g_patcher = GH3P::Patcher(__FILE__);

/*static void *testDetour = (void *)0x00000000;
__declspec(naked) void nakedFunction()
{
    __asm
    {
		int 3;
    }
}*/

HWND*hWnd;
RECT WndR;
int sizeX, sizeY, centerX, centerY;

void ApplyHack()
{
	hWnd = (HWND*)0xC5B8F8;
	GetWindowRect(*hWnd, &WndR);
	sizeX = WndR.right - WndR.left;
	sizeY = WndR.bottom - WndR.top;
	centerX = (GetSystemMetrics(SM_CXSCREEN) / 2) - (sizeX / 2);
	centerY = (GetSystemMetrics(SM_CYSCREEN) / 2) - (sizeY / 2);
	SetWindowPos(*hWnd, 0, centerX, centerY,
		sizeX + (GetSystemMetrics(SM_CXEDGE) * 2) + 2,
		sizeY + (GetSystemMetrics(SM_CYFIXEDFRAME) * 2)
				+ GetSystemMetrics(SM_CYCAPTION)
				+ GetSystemMetrics(SM_CXFIXEDFRAME) - 3, // figure this out so its just dependent on GSM
		SWP_FRAMECHANGED | SWP_NOZORDER | SWP_NOACTIVATE);
}