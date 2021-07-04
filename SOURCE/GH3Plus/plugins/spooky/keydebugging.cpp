#include "keydebugging.h"
#include <cstdint>
#include <cstring>
#include <Windows.h>

//Debugging
bool g_enabled = true;
bool g_forceColorStrings = false;
bool g_forceNoInstances = false;
bool g_forceNoDraw = false;
bool g_forceNoDraw2D = false;
bool g_forceNoWorld = false;
bool g_forcedJitter = false;

int getKeypadNumber()
{
    static uint8_t keys[256];
    memset(keys, 0, sizeof(keys));
    GetKeyboardState(keys);

    for (int i = 0; i < 10; ++i)
    {
        if ((keys[VK_NUMPAD0 + i] & 0x80) || (keys['0' + i] & 0x80))
            return i;
    }

    return -1;
}


void debugCheckKeys()
{
    static bool keyHeld = false;

    int number = getKeypadNumber();

    if (!keyHeld && number >= 0)
    {
        keyHeld = true;

        switch (number)
        {
        case 0:
            PlaySound(TEXT("quack.wav"), NULL, SND_FILENAME | SND_ASYNC);
            g_enabled = !g_enabled;
            break;
        case 1:
            PlaySound(TEXT("quack.wav"), NULL, SND_FILENAME | SND_ASYNC);
            g_forceColorStrings = !g_forceColorStrings;
            break;
        case 2:
            PlaySound(TEXT("quack.wav"), NULL, SND_FILENAME | SND_ASYNC);
            g_forceNoInstances = !g_forceNoInstances;
            break;
        case 5:
            PlaySound(TEXT("quack.wav"), NULL, SND_FILENAME | SND_ASYNC);
            g_forceNoDraw = !g_forceNoDraw;
            break;
        case 4:
            PlaySound(TEXT("quack.wav"), NULL, SND_FILENAME | SND_ASYNC);
            g_forceNoDraw2D = !g_forceNoDraw2D;
            break;
        case 3:
            PlaySound(TEXT("quack.wav"), NULL, SND_FILENAME | SND_ASYNC);
            g_forceNoWorld = !g_forceNoWorld;
        case 6:
            PlaySound(TEXT("quack.wav"), NULL, SND_FILENAME | SND_ASYNC);
            g_forcedJitter = !g_forcedJitter;
            break;
        default:
            return;
        }
    }
    else if (keyHeld && number < 0)
    {
        keyHeld = false;
    }
}
