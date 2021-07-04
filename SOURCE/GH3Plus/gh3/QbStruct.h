#pragma once

#include "core\GH3Plus.h"
#include "QbValueType.h"
#include "QbKey.h"
#include "QbPair.h"
#include "QbVector.h"
#include "QbArray.h"
#include <stdint.h>

namespace GH3
{

	enum GH3P_API QbNodeFlags : __int8
	{
		QFlagStructItem = 0x1,
		QTypeInt = 0x2,
		QTypeFloat = 0x4,
		QTypeCString = 0x6,
		QTypeWString = 0x8,
		QTypePair = 0xA,
		QTypeVector = 0xC,
		QTypeScript = 0xE,
		QTypeCFunc = 0x10,
		QTypeUnk9 = 0x12,
		QTypeQbStruct = 0x14,
		QTypeQbArray = 0x18,
		QTypeQbKey = 0x1A,
		QTypeUnk20 = 0x28,
		QTypeUnk21 = 0x2A,
		QTypeBinaryTree1 = 0x2C,
		QTypeBinaryTree2 = 0x2E,
		QTypeStringPointer = 0x34,
		QTypeMap = 0x36,
	};

	
	struct GH3P_API QbStructItem
	{
		uint8_t unkFlag0;
		QbNodeFlags flags;
		uint16_t word2;
		uint32_t key;
		uint32_t value;
		QbStructItem *next;

		inline QbValueType Type() { return static_cast<QbValueType>(flags >> 1); }

		QbStructItem(QbNodeFlags aFlags, QbKey aKey, uint32_t aValue);
	};

	struct GH3P_API QbStruct
	{

	private:
		uint16_t unk0;
		uint8_t unk2; //might be a debug flag to not free or something
		uint8_t unk3;
		QbStructItem *first;

	public:
		QbStruct();
		QbStruct(QbStructItem *itemChain); //Use with care
		~QbStruct();

		///Untested. Get a value from the QbStruct, traversing its children if necessary
		bool GetTypedValue(QbKey qbKey, QbValueType valueType, void *outValue);
		bool GetInt(QbKey qbKey, int32_t &value);
		bool GetUInt(QbKey qbKey, uint32_t &value);
		bool GetFloat(QbKey qbKey, float &value);
		bool GetDouble(QbKey qbKey, double &value);
		bool GetString(QbKey qbKey, char *&value);
		bool GetWString(QbKey qbKey, wchar_t *&value);
		bool GetPair(QbKey qbKey, QbPair &value);
		bool GetVector(QbKey qbKey, QbVector &value);
		bool GetStruct(QbKey qbKey, QbStruct &value);
		bool GetArray(QbKey qbKey, QbArray &value);
		bool GetQbKey(QbKey qbKey, QbKey &value);

		///Gets an item in the immediate item chain of the struct (it will not recursively traverse nested structs, maps, or binary trees)
		QbStructItem * GetItem(QbKey key);
		QbStructItem * GetItem(QbKey qbKey, QbValueType type);
		bool ContainsItem(QbKey qbKey);
		bool ContainsItem(QbKey qbKey, QbValueType type);

		void __thiscall InsertCStringItem(QbKey qbKey, char *item);
		void __thiscall InsertWStringItem(QbKey qbKey, wchar_t *item);
		void __thiscall InsertStringPointerItem(QbKey qbKey, uint32_t item);
		void __thiscall InsertIntItem(QbKey qbKey, int32_t item);
		void __thiscall InsertUIntItem(QbKey qbKey, uint32_t item);
		void __thiscall InsertFloatItem(QbKey qbKey, float item);
		void __thiscall InsertQbKeyItem(QbKey qbKey, QbKey item);
		void __thiscall InsertVectorItem(QbKey qbKey, QbVector *item);
		void __thiscall InsertPairItem(QbKey qbKey, QbPair *item);
		void __thiscall InsertQbArrayItem(QbKey qbKey, QbArray *item);
		void __thiscall InsertQbStructItem(QbKey qbKey, QbStruct *item);
		
	};

}