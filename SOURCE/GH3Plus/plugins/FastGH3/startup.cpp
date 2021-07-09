#include "gh3\GH3Keys.h"
#include "core\Patcher.h"
#include "startup.h"
#include <stdint.h>
#include <Windows.h>
#include <d3d9.h>

static GH3P::Patcher g_patcher = GH3P::Patcher(__FILE__);

static void *D3DPPpi = (void *)0x0057BB79;

HWND*hWnd;
RECT WndR;
int sizeX, sizeY, centerX, centerY;

BYTE vsync, borderless;

static void *hWndDetour = (void *)0x0057BA6F;
static int * wndStyle = (int*)0x0057BA5D;
__declspec(naked) void hWndHack()
{
	static const uint32_t returnAddress = 0x0057BA75;
	{
		hWnd = (HWND*)0xC5B8F8;
		GetWindowRect(*hWnd, &WndR);
		sizeX = WndR.right - WndR.left;
		sizeY = WndR.bottom - WndR.top;
		centerX = (GetSystemMetrics(SM_CXSCREEN) / 2) - (sizeX / 2);
		centerY = (GetSystemMetrics(SM_CYSCREEN) / 2) - (sizeY / 2);
		if (!borderless)
		{
			sizeX += (GetSystemMetrics(SM_CXEDGE) * 2) + 2;
			sizeY += (GetSystemMetrics(SM_CYFIXEDFRAME) * 2)
				+ GetSystemMetrics(SM_CYCAPTION)
				+ GetSystemMetrics(SM_CXFIXEDFRAME) - 3; // figure this out so its just dependent on GSM
		}
		SetWindowPos(*hWnd, 0,
			centerX, centerY,
			sizeX, sizeY,
			SWP_FRAMECHANGED | SWP_NOZORDER | SWP_NOACTIVATE);
		__asm {
			jmp returnAddress;
		}
	}
}

static char inipath[MAX_PATH];
static char test[10];
static int*presint = (int*)0x00C5B934;

void ApplyHack()
{
	GetCurrentDirectoryA(MAX_PATH, inipath);
	strcat_s(inipath, MAX_PATH, "\\settings.ini");
	vsync = GetPrivateProfileIntA("Misc", "VSync", 1, inipath);
	borderless = GetPrivateProfileIntA("Misc", "Borderless", 0, inipath);

	if (!vsync)
	{
		g_patcher.WriteNOPs(D3DPPpi, 6);
		g_patcher.WriteInt32(presint, 0x80000000);
	}
	g_patcher.WriteJmp(hWndDetour, hWndHack);
	if (!borderless)
	{
		g_patcher.WriteInt32(wndStyle, WS_SYSMENU | WS_MINIMIZEBOX);
	}
}