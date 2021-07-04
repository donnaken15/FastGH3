// GH3Hack.cpp : Defines the exported functions for the DLL application.
//

#include "songLimitFix.h"
#include "core\Patcher.h"
#include <stdint.h>

const uint32_t MAX_TIME = 2140283648; //Roughly 24 days. Trying to get close to INT_MAX without running the risk of overflowing
									
void * const TIME_LOC_1 =  (void *)0x0041AAE8;
void * const TIME_LOC_2 =  (void *)0x0041D417;
void * const TIME_LOC_3 =  (void *)0x0043043E;
void * const TIME_LOC_4 =  (void *)0x00431463;

static GH3P::Patcher g_patcher = GH3P::Patcher(__FILE__);

void FixSongLimit()
{
	g_patcher.WriteInt32(TIME_LOC_1, MAX_TIME);
	g_patcher.WriteInt32(TIME_LOC_2, MAX_TIME);
	g_patcher.WriteInt32(TIME_LOC_3, MAX_TIME);
	g_patcher.WriteInt32(TIME_LOC_4, MAX_TIME);
}

