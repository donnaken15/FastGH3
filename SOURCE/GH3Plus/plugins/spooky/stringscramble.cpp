#include "stringscramble.h"
#include "weakrand.h"
#include "garbagetext.h"
#include <random>



wchar_t RandomCharacter()
{
    return static_cast<wchar_t>(32 + (rand() % (123 - 32)));
}

void ScrambleString(wchar_t *str)
{
    if (str == nullptr)
        return;

    for (wchar_t *c = str; *c != L'\0'; ++c)
    {
        *c = RandomCharacter();
    }
}


///Side effect: sets seed
void WeakScrambleString(wchar_t *str, float weight, float sequenceWeight, float buttonWeight)
{
    if (str == nullptr)
        return;

    static uint32_t seed = 0;
    ++seed;
    srand(seed);

    for (wchar_t *c = str; *c != L'\0'; ++c)
    {
        // Only insert random characters if we hit the random threshold
        if (!FlipCoin(weight))
            continue;

        // If we don't hit the threshold for a sequence insertion, just put in a random character
        if (!FlipCoin(sequenceWeight))
        {
            *c = RandomCharacter();
            continue;
        }

        // We hit the threshold for a sequence insertion so we will insert either a button or color sequence
        if (FlipCoin(buttonWeight))
            InsertRandomEscapeSequence<L'b', 24>(c); //button
        else
            InsertRandomEscapeSequence<L'c', 13>(c); //color
    }


}

void GarbifyString(wchar_t *str)
{
    if (str == nullptr)
        return;

    const wchar_t * garbageString = GarbageText::GetString(rand2());

    for (wchar_t *c = str; *c != L'\0'; ++c)
    {
        *c = *garbageString;
        ++garbageString;
    }
}