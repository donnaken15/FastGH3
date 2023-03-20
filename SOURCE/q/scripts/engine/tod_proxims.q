SE_Brightness = 5
currentTODSettings = Default_TOD_Manager

script TOD_Proxim_Create_LightFX
	ScreenFX_ClearFXInstances \{viewport = 0}
	if InSplitScreenGame
		ScreenFX_ClearFXInstances \{viewport = 0}
	endif
	TOD_Proxim_Update_Global_Brightness \{viewport = 0}
	TOD_Proxim_Update_LightFX \{viewport = bg_viewport time = 0}
endscript

script TOD_Proxim_Update_LightFX
	TOD_Proxim_Update_LightFX_Viewport viewport = 0 <...>
	if InSplitScreenGame
		TOD_Proxim_Update_LightFX_Viewport viewport = 0 <...>
	endif
endscript

script toggle_default_sceenfx
	printf \{"--- toggle_default_screenfx"}
	TOD_Proxim_Update_LightFX_Viewport
	toggle_screenfx_instances
endscript

script TOD_Proxim_Update_LightFX_Viewport\{fxParam = $#"0xc45de82c" viewport = 0 time = 1}
	ScreenFX_ClearFXInstances viewport = <viewport>
	if (<viewport> = 0)
		TOD_Proxim_Update_Global_Brightness <...>
	elseif (<viewport> = bg_viewport)
		if NOT screenFX_FXInstanceExists viewport = <viewport> name = venue_DOF
			ScreenFX_AddFXInstance {
				viewport = <viewport>
				name = venue_DOF
				($DOF_Off_TOD_Manager.screen_FX [0])
			}
		else
			ScreenFX_UpdateFXInstanceParams {
				viewport = <viewport>
				name = venue_DOF
				($DOF_Off_TOD_Manager.screen_FX [0])
			}
		endif
	endif
	if StructureContains \{structure = fxParam screen_FX}
		begin
			if GetNextArrayElement (<fxParam>.screen_FX)
				GetUniqueCompositeobjectID \{preferredID = screenFXID}
				ScreenFX_AddFXInstance {
					viewport = <viewport>
					name = <uniqueID>
					<element>
				}
			else
				break
			endif
		repeat
	endif
	if StructureContains \{structure = fxParam atmosphere}
		UpdateAtmosphere (<fxParam>.atmosphere)
	endif
endscript

script TOD_Proxim_Reapply_LightFX
	TOD_Proxim_Update_LightFX \{fxParam = $#"0xc777a691" time = 0.0}
endscript

script TOD_Proxim_Update_Global_Brightness\{viewport = 0}
	if NOT screenFX_FXInstanceExists viewport = <viewport> name = global_brightness
		ScreenFX_AddFXInstance {
			viewport = <viewport>
			name = global_brightness
			On = 1
			Brightness = (0.5 + ($SE_Brightness)* 0.1)
			Type = Bright_Sat
		}
	else
		ScreenFX_UpdateFXInstanceParams {
			viewport = <viewport>
			name = global_brightness
			On = 1
			Brightness = (0.5 + ($SE_Brightness)* 0.1)
			time = 0
		}
	endif
endscript
