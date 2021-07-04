#include "QbStruct.h"
#include "GlobalMap.h"
#include "BinaryTree.h"
#include "gh3\malloc.h"

namespace GH3
{
	//Constructors and Destructors
	QbStruct::QbStruct() : unk0(0), unk2(1), unk3(0), first(nullptr)
	{
	}

	QbStruct::QbStruct(QbStructItem * itemChain) : unk0(0), unk2(1), unk3(0), first(itemChain)
	{
	}

	QbStruct::~QbStruct() 
	{
	}




	//Almost direct translation from IDA. Untested.
	bool QbStruct::GetTypedValue(QbKey qbKey, QbValueType valueType, void * value)
	{
		QbStructItem *node; // edi@1
		void *value2; // ebp@2
		QbValueType type; // al@3 MAPDST
		HashMapNode *item; // eax@7
		HashMapNode *item2; // esi@10
		QbValueType itemType; // cl@18
		QbStructItem *node2; // eax@43
		bool success; // [sp+Bh] [bp-1h]@1
					  // Is this the GetDWord variant for ints?
		node = this->first;
		success = false;                                  // 
													  // 
		if (!node)
			return success;

		value2 = value;
		uint32_t *iValue = static_cast<uint32_t *>(value);
		float *fValue = static_cast<float *>(value);

		uint32_t tmp;

													  
		while (1)
		{
			type = node->Type();
														// 
			if (type == TypeQbMap)
				break;                                    // 
														  // 
			if (type == TypeBinaryTree2 || type == TypeBinaryTree1)
			{
				BinaryTree *tree = reinterpret_cast<BinaryTree *>(node->value);
				if (tree->GetTypedValue(qbKey, valueType, value))
					goto CONTINUE_LOOP;
			}                                           // 
														// 
			else if (type == TypeStringPointer)
			{
				for (item = GlobalMap::GetEntry(node->value); item; item = item->nextItem)
				{
					if (item->key == static_cast<QbKey>(node->value))
						break;
				}
				item2 = item;
				if (item && ((type = item->itemType, type == TypeQbKey) || type == TypeStringPointer))
				{
					while (1)
					{
						item = GlobalMap::GetEntry(item2->value); // g_HashMap[item2->value.key & 0x7FFF];
						if (!item)
							break;
						while (item->key != static_cast<QbKey>(item2->value))
						{
							item = item->nextItem;
							if (!item)
								goto LABEL_22;
						}
						if (!item)
							break;
						itemType = item->itemType;

						if (itemType != TypeQbKey && itemType != TypeStringPointer)
							goto LABEL_21;
						item2 = item;
					}
				}
				else
				{
				LABEL_21:
					item2 = item;
				}
			LABEL_22:
				if (!item2)
					goto CONTINUE_LOOP_B;

				QbStruct *st = reinterpret_cast<QbStruct *>(item2->value);
				if (node->key == 0
					&& item2->itemType == TypeQbStruct
					&& st->GetTypedValue(qbKey, valueType, &tmp))
				{
					*iValue = tmp;
					success = true;
					if (this->unk3)
						return success;
				}
				if (node->key != qbKey)
					goto CONTINUE_LOOP_B;
				if (item2->itemType == valueType)
				{
					*iValue = item2->value;
					goto CONTINUE_LOOP;
				}
				if (item2->itemType == TypeInt && valueType == TypeFloat)
				{
					*fValue = (float)(signed int)item2->value;
					goto CONTINUE_LOOP;
				}
			}
			else if (node->key == qbKey)
			{
				if (node->Type() == valueType)
				{
					*iValue = node->value;
					goto CONTINUE_LOOP;
				}
				if (type == TypeInt && valueType == TypeFloat)
				{
					*fValue = (float)(signed int)node->value;
				CONTINUE_LOOP:
					success = true;
					if (this->unk3)
						return success;
					goto CONTINUE_LOOP_B;
				}
			}
		CONTINUE_LOOP_B:
			node = node->next;
			if (!node)
				return success;
		}                                             // 
													  // 
													  // 
													  // 
													  // 
		QbMap *map = reinterpret_cast<QbMap *>(node->value);
		node2 = reinterpret_cast<QbStructItem *>(map->Get(qbKey));
		if (node2)
		{
			if (node2->Type() == valueType)
			{
				*iValue = node2->value;
				return true;
			}
			if (valueType == QbValueType::TypeFloat && node2->Type() == QbValueType::TypeInt)// If valueType is a float but the node is an Int
			{
				*fValue = (float)(signed int)node2->value;// Converting Int to Float
				return true;
			}
		}
		return success;

	}

	bool QbStruct::GetInt(QbKey qbKey, int32_t & value)
	{
		return GetTypedValue(qbKey, QbValueType::TypeInt, &value);
	}
	bool QbStruct::GetUInt(QbKey qbKey, uint32_t & value)
	{
		return GetTypedValue(qbKey, QbValueType::TypeInt, &value);
	}

	bool QbStruct::GetFloat(QbKey qbKey, float & value)
	{
		return GetTypedValue(qbKey, QbValueType::TypeFloat, &value);
	}
	bool QbStruct::GetDouble(QbKey qbKey, double & value)
	{
		float fValue;
		bool result = GetFloat(qbKey, fValue);
		value = fValue;
		return result;
	}

	bool QbStruct::GetString(QbKey qbKey, char *& value)
	{
		return GetTypedValue(qbKey, QbValueType::TypeCString, &value);
	}
	bool QbStruct::GetWString(QbKey qbKey, wchar_t *& value)
	{
		return GetTypedValue(qbKey, QbValueType::TypeWString, &value);
	}

	bool QbStruct::GetPair(QbKey qbKey, QbPair & value)
	{
		return GetTypedValue(qbKey, QbValueType::TypePair, &value);
	}
	bool QbStruct::GetVector(QbKey qbKey, QbVector & value)
	{
		return GetTypedValue(qbKey, QbValueType::TypeVector, &value);
	}
	bool QbStruct::GetStruct(QbKey qbKey, QbStruct & value)
	{
		return GetTypedValue(qbKey, QbValueType::TypeQbStruct, &value);
	}
	bool QbStruct::GetArray(QbKey qbKey, QbArray & value)
	{
		return GetTypedValue(qbKey, QbValueType::TypeQbArray, &value);
	}
	bool QbStruct::GetQbKey(QbKey qbKey, QbKey & value)
	{
		return GetTypedValue(qbKey, QbValueType::TypeQbKey, &value);
	}

	QbStructItem * QbStruct::GetItem(QbKey qbKey)
	{
		QbStructItem *item = this->first;
		while (item != nullptr)
		{
			if (item->key == qbKey)
				return item;
			item = item->next;
		}
		return nullptr;
	}

	QbStructItem * QbStruct::GetItem(QbKey qbKey, QbValueType type)
	{
		QbStructItem *item = this->first;
		while (item != nullptr)
		{
			if (item->key == qbKey && item->Type() == type)
				return item;
			item = item->next;
		}
		return nullptr;
	}

	bool QbStruct::ContainsItem(QbKey qbKey)
	{
		return (GetItem(qbKey) != nullptr);
	}

	bool QbStruct::ContainsItem(QbKey qbKey, QbValueType type)
	{
		return (GetItem(qbKey) != nullptr);
	}







	////////////////////////////////
	// Native Insertion Functions //
	////////////////////////////////

	template<uint32_t address, typename T>
	inline void __declspec(naked) __stdcall NativeInsertCall(QbStruct *qbStruct, QbKey qbKey, T item)
	{
		static const void * const nativeFunction = (void *)address;
		__asm
		{
			//Have to use [esp] because Visual Studio expects there to be a base pointer if you use variable names and we're not using 
			mov ecx, [esp+4];
			push [esp+0Ch];
			push [esp+0Ch];
			call nativeFunction;
			retn 0Ch;
		}
	}
	void __thiscall QbStruct::InsertCStringItem(QbKey qbKey, char *item) {
		NativeInsertCall<0x00479AC0, char *>(this, qbKey, item);
	}
	void __thiscall QbStruct::InsertWStringItem(QbKey qbKey, wchar_t *item) {
		NativeInsertCall<0x00479B20, wchar_t *>(this, qbKey, item);
	}
	void __thiscall QbStruct::InsertStringPointerItem(QbKey qbKey, uint32_t item) {
		NativeInsertCall<0x00479B80, uint32_t>(this, qbKey, item);
	}
	void __thiscall QbStruct::InsertIntItem(QbKey qbKey, int32_t item) {
		NativeInsertCall<0x00479BD0, int32_t>(this, qbKey, item);
	}
	void __thiscall QbStruct::InsertUIntItem(QbKey qbKey, uint32_t item) {
		NativeInsertCall<0x00479BD0, uint32_t>(this, qbKey, item);
	}
	void __thiscall QbStruct::InsertFloatItem(QbKey qbKey, float item) {
		NativeInsertCall<0x00479C20, float>(this, qbKey, item);
	}
	void __thiscall QbStruct::InsertQbKeyItem(QbKey qbKey, QbKey item) {
		NativeInsertCall<0x00479C80, QbKey>(this, qbKey, item);
	}
	void __thiscall QbStruct::InsertVectorItem(QbKey qbKey, QbVector *item) {
		NativeInsertCall<0x00479CD0, QbVector *>(this, qbKey, item);
	}
	void __thiscall QbStruct::InsertPairItem(QbKey qbKey, QbPair *item) {
		NativeInsertCall<0x00479D60, QbPair *>(this, qbKey, item);
	}
	void __thiscall QbStruct::InsertQbArrayItem(QbKey qbKey, QbArray *item) {
		NativeInsertCall<0x00479DF0, QbArray *>(this, qbKey, item);
	}
	void __thiscall QbStruct::InsertQbStructItem(QbKey qbKey, QbStruct *item) {
		NativeInsertCall<0x00479E40, QbStruct *>(this, qbKey, item);
	}

	//void __thiscall QbStruct::InsertQbStructItem(QbKey qbKey, QbStruct * item)
	//{
	//	static const void * const nativeFunction = (void *)0x00479E40;
	//	__asm
	//	{
	//		push item;
	//		push qbKey;
	//		call nativeFunction;
	//	}
	//}
	//
	//void __thiscall QbStruct::InsertQbKeyItem(QbKey qbKey, QbKey item)
	//{
	//	static const void * const nativeFunction = (void *)0x00479C80;
	//	__asm
	//	{
	//		push item;
	//		push qbKey;
	//		call nativeFunction;
	//	}
	//}









	QbStructItem::QbStructItem(QbNodeFlags aFlags, QbKey aKey, uint32_t aValue) : unkFlag0(0), flags(aFlags), word2(0), key(aKey), value(aValue), next(nullptr)
	{
	}

}