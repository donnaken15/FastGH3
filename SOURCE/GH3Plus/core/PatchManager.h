#pragma once
#include "GH3Plus.h"
#include <stdint.h>

namespace GH3P
{
	/// A memberless static class for managing the patches of loaded plugins in GH3+. It should be rare to need to access this class directly.
	class GH3P_API PatchManager final
	{
	private:
		PatchManager() = delete;

	public:
		/// Given a starting address and size in bytes, finds a patch that starts in that area along with the owner of that patch.
		static void FindPatch(const uint8_t *start, uint32_t size, uint8_t* &patchStart, uint32_t &patchOwner);

		/// Writes an amount of bytes from source to destination based on the size passed in. The patch will be assigned to the specified owner ID.
		static bool ApplyPatch(const uint8_t * src, uint8_t *dest, uint32_t size, uint32_t ownerID);

		/// Removes a patch starting at the specified destination.
		static bool RemovePatch(uint8_t *dest);

		/// Removes all patches belonging to a specific owner.
		static bool RemovePatches(uint32_t ownerID);
	};

}