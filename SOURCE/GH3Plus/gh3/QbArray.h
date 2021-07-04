#pragma once

#include "core\GH3Plus.h"

#include "QbValueType.h"
#include <stdint.h>

namespace GH3
{

	struct GH3P_API QbArray final
	{

	private:
		uint8_t unk0;
		uint8_t unk1;
		QbValueType m_type;
		uint8_t unk3;
		uint32_t m_length;
		uint32_t *m_arr;

	public:
		int * __thiscall Initialize(int size, int type);

		void Clear();

		uint32_t operator [](int index) const;
		uint32_t & operator [](int index);

		inline void Set(int index, uint32_t value) { (*this)[index] = value; }
		inline uint32_t Get(int index) const { return (*this)[index]; }

		inline void SetType(QbValueType type) { m_type = type; }
		inline QbValueType Type() const { return m_type;}
		inline uint32_t Length() const { return m_length;}
	};

}