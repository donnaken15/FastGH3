#pragma once

#include "core\GH3Plus.h"
#include "QbKey.h"
#include <stdint.h>

namespace GH3
{

	struct GH3P_API QbPair
	{
		uint8_t gap0[1];
		uint8_t byte1;
		float X;
		float Y;
	};
}