#include "QbMap.h"
#include <malloc.h>

namespace GH3
{

	uint32_t QbMap::operator[](QbKey key) const
	{
		if (m_nodes == nullptr)
			return 0;

		QbMapNode *node = &m_nodes[key & IndexMask()];

		while (node->key != key || !this->m_boolFlag && !node->value)
		{
			node = node->nextNode;
			if (node == nullptr)
				return 0;
		}
		return node->value;
	}

	uint32_t & QbMap::operator[](QbKey key)
	{
		
		static uint32_t &nullref = *reinterpret_cast<uint32_t *>(0);

		if (m_nodes == nullptr)
			return nullref;

		uint32_t index = key & IndexMask();

		//Attempt insertion if the node doesn't exist
		QbMapNode *node = &m_nodes[index];
		if (node->key == 0 && node->nextNode == nullptr)
		{
			node->key = key;
			return node->value;
		}

		while (node->key != key || !this->m_boolFlag && !node->value)
		{
			if (node->nextNode == nullptr)
			{
				QbMapNode *nextNode = static_cast<QbMapNode *>(malloc(sizeof(QbMapNode))); //TODO: Use GH3's malloc. THIS WILL PROBABLY CRASH
				node->nextNode = nextNode;
				nextNode->key = key;
				nextNode->nextNode = nullptr;
				return nextNode->value;
			}
		}
		return node->value;
	}

}