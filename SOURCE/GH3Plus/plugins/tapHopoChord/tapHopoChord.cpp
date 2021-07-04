#include "core\Patcher.h"
#include "gh3\GH3Keys.h"
#include "gh3\GH3GlobalAddresses.h"
#include "tapHopoChord.h"

GH3P::Patcher g_patcher = GH3P::Patcher(__FILE__);


void ApplyHack()
{
	if (!TryApplyGlobalArrayPatches() ||
		!TryApplyGemLoadingPatches() ||
		!TryApplyGemMutationPatches() ||
		!TryApplyNoteLoadingPatches() ||
		!TryApplyNoteLogicPatches() ||
		!TryApplyGemConstantsPatches() ||
		!TryApplyTextureTakeoverPatches())
	{
		g_patcher.RemoveAllChanges();
	}
}
