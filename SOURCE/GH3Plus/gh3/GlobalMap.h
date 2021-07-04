#pragma once

#include "QbMap.h"

namespace GH3
{
	struct __declspec(align(4)) HashMapNode
	{
		uint8_t byte0;
		uint8_t byte1;
		QbValueType itemType;
		uint8_t byte3;
		QbKey key;
		uint32_t dword8;
		uint32_t value;
		HashMapNode *nextItem;
	};


	class GH3P_API GlobalMap final
	{
	private:
		GlobalMap() = delete;
		~GlobalMap() = delete;
	public:
		inline static constexpr uint32_t Size() { return 15; }
		inline static constexpr uint32_t Length() { return 1 << Size(); }
		inline static constexpr uint32_t IndexMask() { return Length() - 1; }

		inline static HashMapNode ** Nodes() { return reinterpret_cast<HashMapNode **>(0x00C03AA8); };

		inline static HashMapNode * GetEntry(QbKey key) { return Nodes()[key & IndexMask()]; };
		static bool GetTypedValue(QbKey key, QbValueType type, void *pValue);
		static bool GetValue(QbKey key, void *pValue, QbValueType *pType);

		static uint32_t Insert(uint32_t key, QbValueType type, uint32_t value); //TODO

	};

}