#include "PatchManager.h"
#include "ScopedUnprotect.h"
#include <algorithm>
#include <vector>
#include <map>

namespace GH3P
{

	static std::map< uint8_t *, std::vector<uint8_t> > sOriginalCode;
	static std::map< uint8_t *, uint32_t > sPatchOwners;
	static std::map< uint32_t, std::vector<uint8_t *> > sOwnerPatches;

	void PatchManager::FindPatch(const uint8_t *start, uint32_t size, uint8_t* &patchStart, uint32_t &patchOwner)
	{
		const uint8_t *end = start + size;

		for (auto kv : sOriginalCode)
		{
			uint32_t patchSize = kv.second.size();
			patchStart = kv.first;
			const uint8_t *patchEnd = patchStart + patchSize;
			patchOwner = sPatchOwners[patchStart];
			
			//Does the existing patch start within our patch range?
			if (patchStart >= start && patchStart < end)
				return;

			//Does the existing patch end within our patch range?
			if (patchEnd >= start && patchEnd < end)
				return;

			//Does the existing patch completely encapsulate our patch range?
			if (patchStart < start && patchEnd >= end)
				return;

		}

		patchStart = nullptr;
		patchOwner = 0x00000000;
	}

	bool PatchManager::ApplyPatch(const uint8_t *src, uint8_t *dest, uint32_t size, uint32_t ownerID)
	{
		//Assert that the code we want to patch isn't patched already
		uint8_t *patchStart;
		uint32_t patchOwner;
		FindPatch(dest, size, patchStart, patchOwner);
		if (patchOwner != 0)
			return false;

		//Back up original code and then patch
		ScopedUnprotect memUnprotect(dest, size);
		std::vector<uint8_t> oldCode(size);
		memcpy(&(oldCode[0]), dest, size);
		memcpy(dest, src, size);

		if (sOwnerPatches.find(ownerID) == sOwnerPatches.end())
			sOwnerPatches[ownerID] = std::vector<uint8_t *>();

		sOwnerPatches[ownerID].push_back(dest);
		sOriginalCode[dest] = oldCode;
		sPatchOwners[dest] = ownerID;

		return true;
	}

	bool PatchManager::RemovePatch(uint8_t *dest)
	{
		if (sOriginalCode.find(dest) == sOriginalCode.end())
			return false;

		//Restore original code
		std::vector<uint8_t> oldCode = sOriginalCode[dest];
		ScopedUnprotect memUnprotect(dest, oldCode.size());
		memcpy(dest, &(oldCode[0]), oldCode.size());

		//Remove entries
		uint32_t patchOwner = sPatchOwners[dest];
		sOriginalCode.erase(dest);
		sPatchOwners.erase(dest);
		std::vector<uint8_t *> &v = sOwnerPatches[patchOwner];
		v.erase(std::remove(v.begin(), v.end(), dest), v.end());
		if (v.empty())
			sOwnerPatches.erase(patchOwner);

		return true;
	}

	bool PatchManager::RemovePatches(uint32_t ownerID)
	{
		std::vector<uint8_t *> patchesToRemove;

		for (auto kv : sPatchOwners)
		{
			uint8_t *patchLocation = kv.first;
			uint32_t owner = kv.second;
			
			if (owner != ownerID)
				continue;
			
			patchesToRemove.push_back(patchLocation);
		}

		for (uint8_t *patch : patchesToRemove)
		{
			PatchManager::RemovePatch(patch);
		}

		return true;
	}

}