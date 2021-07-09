#pragma once

typedef int CFunc();
typedef int CFuncI(int);
typedef int CFuncI2(int, int);

CFuncI2 * WinPortSioGetDevicePress          = (CFuncI2 *)(0x00419A20);
CFuncI2 * WinPortSioGetControlPress         = (CFuncI2 *)(0x00419A50);
CFuncI  * WinPortSioIsDirectInputGamepad    = (CFuncI  *)(0x00419AE0);
CFuncI  * WinPortSioIsKeyboard              = (CFuncI  *)(0x00419B30);
CFuncI  * WinPortSioSetDevice0              = (CFuncI  *)(0x00419B80);

