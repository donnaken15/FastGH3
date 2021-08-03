#pragma once

typedef int CFunc();
typedef int CFuncI(int);
typedef int CFuncI2(int, int);
typedef int PrintsubIthinkT(char *DstBuf, size_t MaxCount, int a3);

CFuncI2 * WinPortSioGetDevicePress          = (CFuncI2 *)(0x00419A20);
CFuncI2 * WinPortSioGetControlPress         = (CFuncI2 *)(0x00419A50);
CFuncI  * WinPortSioIsDirectInputGamepad    = (CFuncI  *)(0x00419AE0);
CFuncI  * WinPortSioIsKeyboard              = (CFuncI  *)(0x00419B30);
CFuncI  * WinPortSioSetDevice0              = (CFuncI  *)(0x00419B80);

CFuncI2 * ScriptAssert                      = (CFuncI2 *)(0x00532DD0);
PrintsubIthinkT * PrintsubIthink            = (PrintsubIthinkT *)(0x00532A80);

