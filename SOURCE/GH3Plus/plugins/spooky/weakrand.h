#pragma once

#include <cstdint>

//This is wrong if RAND_MAX is anything other than 0x7FFF
#define RAND2_MAX 0x3FFFFFFF

///Randomizes the seed since it is being manipulated frequently. Call before using a random function if a "random" number is actually desired.
void RandomizeSeed();

uint32_t rand2();

bool FlipCoin(float weight = 0.5f);