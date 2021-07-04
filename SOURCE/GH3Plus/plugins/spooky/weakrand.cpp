#include "weakrand.h"
#include <random>
#include <time.h>

void RandomizeSeed()
{
    static uint32_t seed = 236147403;
    seed += (clock() & 0x7FFF);
    seed ^= (seed << 13);
    seed ^= (seed >> 17);
    seed ^= (seed << 5);
    seed += 541;
    srand(seed);
};

uint32_t rand2()
{
    return (rand() << 15) | (rand());
}

bool FlipCoin(float weight)
{
    return (rand2() / static_cast<float>(RAND2_MAX)) < weight;
}