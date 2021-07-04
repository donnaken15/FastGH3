#pragma once

namespace GH3
{

	enum GH3P_API QbValueType : __int8
	{
		TypeUndefined = 0x0,
		TypeInt = 0x1,
		TypeFloat = 0x2,
		TypeCString = 0x3,
		TypeWString = 0x4,
		TypePair = 0x5,
		TypeVector = 0x6,
		TypeScript = 0x7,
		TypeCFunc = 0x8,
		TypeUnk9 = 0x9,
		TypeQbStruct = 0xA,
		TypeQbArray = 0xC,
		TypeQbKey = 0xD,
		TypeUnk20 = 0x14,
		TypeUnk21 = 0x15,
		TypeBinaryTree1 = 0x16,
		TypeBinaryTree2 = 0x17,
		TypeStringPointer = 0x1A,
		TypeQbMap = 0x1B,
		TypeQbKeyStringQs = 0x1C,
	};

}