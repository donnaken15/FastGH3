#include "GlobalMap.h"

namespace GH3
{

	bool GlobalMap::GetTypedValue(QbKey key, QbValueType type, void * pValue)
	{
		HashMapNode *node = GetEntry(key);
		uint32_t *pValue2 = reinterpret_cast<uint32_t *>(pValue); //We don't know what type of data is being stored besides that it's 32 bits but that's all we need.

		while (node != nullptr)
		{
			if (node->key == key && node->itemType == type)
			{
				if (pValue2 != nullptr)
					*pValue2 = node->value;
				return true;
			}
			node = node->nextItem;
		}

		if (pValue2 != nullptr)
			*pValue2 = 0;
		return false;
	}

	bool GlobalMap::GetValue(QbKey key, void * pValue, QbValueType * pType)
	{
		HashMapNode *node = GetEntry(key);
		uint32_t *pValue2 = reinterpret_cast<uint32_t *>(pValue); //We don't know what type of data is being stored besides that it's 32 bits but that's all we need.

		while (node != nullptr)
		{
			if (node->key == key)
			{
				if (pValue2 != nullptr)
					*pValue2 = node->value;
				if (pType != nullptr)
					*pType = node->itemType;
				return true;
			}
			node = node->nextItem;
		}

		if (pValue2 != nullptr)
			*pValue2 = 0;
		if (pType != nullptr)
			*pType = QbValueType::TypeUndefined;
		return false;
	}

}