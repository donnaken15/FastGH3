#include "BinaryTree.h"


namespace GH3
{

	bool BinaryTree::GetTypedValue(QbKey aKey, QbValueType valueType, void * pValue)
	{
		uint32_t searchValue; // ebx@2
		uint32_t *data; // ebp@2
		uint32_t left; // esi@2
		uint32_t right; // edi@2
		uint32_t middle; // eax@3
		uint32_t leftNode; // edx@3

		uint32_t * const iValue = static_cast<uint32_t *>(pValue);
		float * const fValue = static_cast<float *>(pValue);

		if (this->root)
		{
			searchValue = aKey + valueType;
			data = &this->data[this->arrayOffset];
			left = 0;
			for (right = this->root; ; left = (right + left) >> 1)
			{
				while (1)
				{
					middle = (right + left) >> 1;           
															
					leftNode = data[2 * middle];            
					if (searchValue >= leftNode)
						break;                              
															
					if (right == middle)
						goto MAYBE_FLOAT;
					right = (right + left) >> 1;
				}

				if (searchValue <= leftNode)
					break;

				if (left == middle)
					goto MAYBE_FLOAT;
			}
			*iValue = data[2 * middle + 1];        
			return true;
		}

		MAYBE_FLOAT:
		uint32_t tmp;
		if (valueType == TypeFloat && GetTypedValue(aKey, QbValueType::TypeInt, &tmp))
		{
			*fValue = (float)tmp;
			return true;
		}
			
		return false;
	}

}