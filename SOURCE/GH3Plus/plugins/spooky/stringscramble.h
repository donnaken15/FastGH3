#pragma once

#include <random>

void GarbifyString(wchar_t *str);
wchar_t RandomCharacter();
void ScrambleString(wchar_t *str);
void WeakScrambleString(wchar_t *str, float weight = 0.05f, float sequenceWeight = 0.1f, float buttonWeight = 0.8);

template <wchar_t C, uint32_t Limit>
bool InsertRandomEscapeSequence(wchar_t *str)
{
    if (str == nullptr)
        return false;

    if (str[0] == L'\0' || str[1] == L'\0' || str[2] == L'\0')
        return false;

    uint32_t index = rand() % Limit;
    wchar_t randomChar;
    if (index < 10)
        randomChar = L'0' + index;
    else
        randomChar = L'a' + index - 10;

    str[0] = L'\\';
    str[1] = C;
    str[2] = randomChar;
    return true;
}