#pragma once

#include "core\GH3Plus.h"
#include "QbValueType.h"
#include "QbKey.h"
#include "QbStruct.h"
#include <stdint.h>


namespace GH3
{

	struct GH3P_API QbMap
	{
	private:

		struct QbMapNode
		{
			QbKey key;
			uint32_t value;
			QbMapNode *nextNode;
		};

		uint32_t	m_size;
		QbMapNode	*m_nodes;
		QbNodeFlags	m_typeFlags;
		uint32_t	unkC;
		uint32_t	unk10;
		uint8_t		unk14;
		uint8_t		m_boolFlag;
		uint8_t		m_keepAliveFlag;
		uint8_t		unk17;

	public:
		uint32_t operator[] (QbKey key) const;
		uint32_t & operator[] (QbKey key);

		inline uint32_t Get(QbKey key) const { return (*this)[key]; };
		inline void Insert(QbKey key, uint32_t value) { this->operator[](key) = value; };

		inline uint32_t Size() const { return m_size; }
		inline QbValueType Type() const { return static_cast<QbValueType>(m_typeFlags >> 1); }
		inline uint32_t IndexMask() const { return ( (1 << m_size) - 1); }
	};

}