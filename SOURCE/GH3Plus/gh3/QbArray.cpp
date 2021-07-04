#include "QbArray.h"

namespace GH3
{

	int * QbArray::Initialize(int size, int type)
	{
		static const void *function = (void *)0x0055DF00;
		__asm jmp function;
	}

	void QbArray::Clear()
	{
		SetType(QbValueType::TypeUndefined);
		m_arr = nullptr;
		m_length = 0;
		unk1 = 0;
	}

	uint32_t QbArray::operator[](int index) const
	{
		if (m_length != 1)
			return m_arr[index];
		else
			return reinterpret_cast<uint32_t>(m_arr);
	}

	uint32_t & QbArray::operator[](int index)
	{
		if (Length() == 1)
			return reinterpret_cast<uint32_t &>(m_arr);
		else
			return m_arr[index];
	}

}