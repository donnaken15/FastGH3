curReviewLighting = 0

script CycleReviewLighting
	Change curReviewLighting = ($curReviewLighting + 1)
	if ($curReviewLighting = 7)
		Change \{curReviewLighting = 0}
	endif
	GetPakManCurrentName \{map = zones}
	FormatText checksumName = lightPrefix '%p_GFX_L' p = <pakname>
	CallScriptOnNode prefix = <lightPrefix> callBack_Script = CB_CycleReviewLighting params = {}
endscript

script CB_CycleReviewLighting
	GetLightColor name = <nodeName>
	big = <r>
	if (<big> < <g>)
		big = <g>
	endif
	if (<big> < <b>)
		big = <b>
	endif
	switch $curReviewLighting
		case 0
			SetLightColor name = <nodeName> r = <big> g = <big> b = <big>
		case 1
			SetLightColor name = <nodeName> r = <big> g = (<big> / 6.0)b = (<big> / 6.0)
		case 2
			SetLightColor name = <nodeName> r = (<big> / 6.0)g = <big> b = (<big> / 6.0)
		case 3
			SetLightColor name = <nodeName> r = (<big> / 6.0)g = (<big> / 6.0)b = <big>
		case 4
			SetLightColor name = <nodeName> r = (<big> / 6.0)g = <big> b = <big>
		case 5
			SetLightColor name = <nodeName> r = <big> g = (<big> / 6.0)b = <big>
		case 6
			SetLightColor name = <nodeName> r = <big> g = <big> b = (<big> / 6.0)
	endswitch
endscript

script SafeCreate
	if IsInNodeArray <nodeName>
		if NOT IsCreated <nodeName>
			create name = <nodeName>
		endif
	endif
endscript

script SafeKill
	if IsCreated <nodeName>
		kill name = <nodeName>
	endif
endscript

script ScreenFlash\{time = 1}
	killspawnedscript \{id = ScreenFlash}
	SpawnScriptLater ScreenFlashOn id = ScreenFlash params = {time = <time>}
endscript

script ScreenFlashOn
	if NOT screenFX_FXInstanceExists \{viewport = bg_viewport name = FlashBS}
		ScreenFX_AddFXInstance {
			viewport = bg_viewport
			name = FlashBS
			($ScreenFlash_tod_manager.screen_FX [0])
		}
	else
		ScreenFX_UpdateFXInstanceParams {
			viewport = bg_viewport
			name = FlashBS
			($ScreenFlash_tod_manager.screen_FX [0])
		}
	endif
	wait (0.1 * <time>)seconds
	if screenFX_FXInstanceExists \{viewport = bg_viewport name = FlashBS}
		ScreenFX_UpdateFXInstanceParams {
			viewport = bg_viewport
			name = FlashBS
			time = <time>
			($ScreenFlash_tod_manager.screen_FX [0])
			Contrast = 1
			Brightness = 1
		}
	endif
	wait <time> seconds
	SpawnScriptLater \{ScreenFlashOff id = ScreenFlash}
endscript

script ScreenFlashOff
	if ViewportExists \{id = bg_viewport}
		if screenFX_FXInstanceExists \{viewport = bg_viewport name = FlashBS}
			ScreenFX_RemoveFXInstance \{viewport = bg_viewport name = FlashBS}
		endif
	endif
endscript

script ScreenToBlack\{time = 0.4 viewport = UI}
	killspawnedscript \{id = ScreenToBlack}
	SpawnScriptLater Call_ScreenToBlack id = ScreenToBlack params = {<...> }
endscript

script Call_ScreenToBlack
	time = (0.5 * <time>)
	SpawnScriptLater Do_ScreenToBlack id = ScreenToBlack params = {On time = <time> <...> }
	wait <time> seconds
	SpawnScriptLater Do_ScreenToBlack id = ScreenToBlack params = {OFF time = <time> <...> }
endscript

script Do_ScreenToBlack
	if NOT (<viewport> = 0)
		if NOT ViewportExists id = <viewport>
			return
		endif
	endif
	if GotParam \{On}
		if NOT screenFX_FXInstanceExists viewport = <viewport> name = blackFX
			ScreenFX_AddFXInstance {
				viewport = <viewport>
				name = blackFX
				($ScreenToBlack_tod_manager.screen_FX [0])
			}
		endif
		ScreenFX_UpdateFXInstanceParams {
			viewport = <viewport>
			name = blackFX
			time = <time>
			($ScreenToBlack_tod_manager.screen_FX [0])
			inner_radius = 0
			Outer_Radius = 0
			alpha = 1
		}
	else
		if screenFX_FXInstanceExists viewport = <viewport> name = blackFX
			ScreenFX_UpdateFXInstanceParams {
				viewport = <viewport>
				name = blackFX
				time = <time>
				($ScreenToBlack_tod_manager.screen_FX [0])
				inner_radius = 1
				Outer_Radius = 1.5
				alpha = 0
			}
			if GotParam \{OFF}
				wait <time> seconds
				ScreenFX_RemoveFXInstance viewport = <viewport> name = blackFX
			endif
		endif
	endif
endscript
