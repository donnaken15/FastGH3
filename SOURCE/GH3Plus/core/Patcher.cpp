#include "Patcher.h"
#include "PatchManager.h"

#include <vector>

namespace GH3P
{

	//Constructors and destructors

	Patcher::Patcher(GH3::QbKey owner) : _owner(owner)
	{
	}

	Patcher::~Patcher()
    {
		RemoveAllChanges();
    }

	bool Patcher::RemoveAllChanges()
	{
		return PatchManager::RemovePatches(_owner);
	}








	//Jumps

	bool Patcher::WriteJmp(void * addr, void * jumpDestination)
	{
		uint8_t jumpBuffer[5];
		uint32_t jmpSize = reinterpret_cast<uint8_t *>(jumpDestination) - reinterpret_cast<uint8_t *>(addr) - 5;

		jumpBuffer[0] = 0xE9; //unconditional x86 jump instruction
		memcpy(&jumpBuffer[1], &jmpSize, sizeof(jmpSize));

		return PatchManager::ApplyPatch(jumpBuffer, reinterpret_cast<uint8_t *>(addr), 5, _owner);
	}

	bool Patcher::WriteJmpMulti(void ** addresses, uint32_t addressCount, void * jumpDestination)
	{
		for (uint32_t i=0; i < addressCount; ++i)
		{
			if (!WriteJmp(addresses[i], jumpDestination))
				return false;
		}

		return true;
	}





	//Calls

	bool Patcher::WriteCall(void * addr, void * calleeAddress)
	{
		uint8_t callBuffer[5];
		uint32_t jmpSize = reinterpret_cast<uint8_t *>(calleeAddress) - reinterpret_cast<uint8_t *>(addr) - 5;

		callBuffer[0] = 0xE8; //x86 call instruction
		memcpy(&callBuffer[1], &jmpSize, sizeof(jmpSize));

		return PatchManager::ApplyPatch(callBuffer, reinterpret_cast<uint8_t *>(addr), 5, _owner);
	}

	bool Patcher::WriteCallMulti(void ** addresses, uint32_t addressCount, void * calleeAddress)
	{
		for (uint32_t i = 0; i < addressCount; ++i)
		{
			if (!WriteCall(addresses[i], calleeAddress))
				return false;
		}

		return true;
	}



	//Other writes

	bool Patcher::WriteInt8(void * addr, uint8_t value)
	{
		return PatchManager::ApplyPatch(&value, reinterpret_cast<uint8_t *>(addr), 1, _owner);
	}

	bool Patcher::WriteInt8Multi(void ** addresses, uint32_t addressCount, uint32_t value)
	{
		for (uint32_t i = 0; i < addressCount; ++i)
		{
			if (!WriteInt8(addresses[i], value))
				return false;
		}

		return true;
	}

	bool Patcher::WriteInt16(void * addr, uint16_t value)
	{
		return PatchManager::ApplyPatch(reinterpret_cast<uint8_t *>(&value), reinterpret_cast<uint8_t *>(addr), 2, _owner);
	}

	bool Patcher::WriteInt16Multi(void ** addresses, uint32_t addressCount, uint16_t value)
	{
		for (uint32_t i = 0; i < addressCount; ++i)
		{
			if (!WriteInt16(addresses[i], value))
				return false;
		}

		return true;
	}

	bool Patcher::WriteInt32(void * addr, uint32_t value)
	{
		return PatchManager::ApplyPatch(reinterpret_cast<uint8_t *>(&value), reinterpret_cast<uint8_t *>(addr), 4, _owner);
	}

	bool Patcher::WriteInt32Multi(void ** addresses, uint32_t addressCount, uint32_t value)
	{
		for (uint32_t i = 0; i < addressCount; ++i)
		{
			if (!WriteInt32(addresses[i], value))
				return false;
		}

		return true;
	}

	bool Patcher::WriteInt64(void * addr, uint64_t value)
	{
		return PatchManager::ApplyPatch(reinterpret_cast<uint8_t *>(&value), reinterpret_cast<uint8_t *>(addr), 8, _owner);
	}

	bool Patcher::WriteInt64Multi(void ** addresses, uint32_t addressCount, uint64_t value)
	{
		for (uint32_t i = 0; i < addressCount; ++i)
		{
			if (!WriteInt64(addresses[i], value))
				return false;
		}

		return true;
	}

	bool Patcher::WritePointer(void * addr, void * value)
	{
		return WriteInt32(addr, reinterpret_cast<uint32_t>(value));
	}

	bool Patcher::WritePointerMulti(void ** addresses, uint32_t addressCount, void * value)
	{
		return WriteInt32Multi(addresses, addressCount, reinterpret_cast<uint32_t>(value));
	}

	bool Patcher::WriteArray(void * addr, uint8_t *value, uint32_t length)
	{
		return PatchManager::ApplyPatch(value, reinterpret_cast<uint8_t *>(addr), length, _owner);
	}

	bool Patcher::WriteArrayMulti(void ** addresses, uint32_t addressCount, uint8_t * value, uint32_t length)
	{
		for (uint32_t i = 0; i < addressCount; ++i)
		{
			if (!WriteArray(addresses[i], value, length))
				return false;
		}

		return true;
	}

	bool Patcher::WriteNOPs(void * addr, uint32_t length)
	{
		std::vector<uint8_t> nopArray(length);
		memset(&(nopArray[0]), 0x90, length);
		return PatchManager::ApplyPatch(&nopArray[0], reinterpret_cast<uint8_t *>(addr), nopArray.size(), _owner);
	}

	bool Patcher::WriteNOPsMulti(void ** addresses, uint32_t addressCount, uint32_t length)
	{
		for (uint32_t i = 0; i < addressCount; ++i)
		{
			if (!WriteNOPs(addresses[i], length))
				return false;
		}

		return true;
	}
}