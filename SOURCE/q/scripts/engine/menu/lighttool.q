
script run_windows_light_tool_commands
	GetArraySize <commands>
	i = 0
	if (<array_Size> > 0)
		begin
			(<commands> [<i>].scriptname)(<commands> [<i>].params)
			i = (<i> + 1)
		repeat <array_Size>
	endif
endscript

script global_fx_unlock_and_set_temp_tod
	tod_manager_apply_perm_light_settings <...>
endscript
screenfx_instances_state = 1
screenfx_instances_default_state = [
	{
		name = NULL
	}
]

script toggle_screenfx_instances
	if GotParam \{On}
		Change \{screenfx_instances_state = 1}
	else
		if GotParam \{OFF}
			Change \{screenfx_instances_state = 0}
		else
			if ($screenfx_instances_state = 1)
				Change \{screenfx_instances_state = 0}
			else
				Change \{screenfx_instances_state = 1}
			endif
		endif
	endif
	ScreenFX_GetActiveScreenFXInstances \{viewport = 0}
	if NOT IsArray <curscreenfx>
		return
	endif
	GetArraySize <curscreenfx>
	i = 0
	begin
		ScreenFX_UpdateFXInstanceParams {
			viewport = 0
			name = (<curscreenfx> [<i>].name)
			time = 0
			On = ($screenfx_instances_state)
		}
		i = (<i> + 1)
	repeat <array_Size>
	save_current_screen_fx_setup
endscript

script start_viewer_screen_fx
	printf \{'--- start_viewer_screen_fx'}
	ScreenFX_ClearFXInstances \{viewport = 0}
	good_saved_screenfx_settings
	if (<is_good> = 0)
		printf \{'returned'}
		return
	endif
	printstruct ($screenfx_instances_default_state)
	temp = ($screenfx_instances_default_state)
	begin
		if GetNextArrayElement <temp>
			ScreenFX_AddFXInstance {
				viewport = 0
				<element>
			}
		else
			break
		endif
	repeat
endscript

script save_current_screen_fx_setup
	printf \{'--- save_current_screen_fx_setup'}
	if LevelIs \{viewer}
		wait \{1 Second}
		ScreenFX_GetActiveScreenFXInstances \{viewport = 0}
		printstruct <...>
		Change screenfx_instances_default_state = (<curscreenfx>)
	endif
endscript

script good_saved_screenfx_settings
	printf \{'--- good_saved_screenfx_settings'}
	if NOT IsArray ($screenfx_instances_default_state)
		printf \{'not array'}
		return \{is_good = 0}
	else
		if checksumequals a = (($screenfx_instances_default_state)[0].name)b = NULL
			printf \{'null'}
			return \{is_good = 0}
		endif
	endif
	return \{is_good = 1}
endscript

script ApplyLightColorChange
	if IsCreated <LightChecksum>
		<LightChecksum> ::Light_SetParams <...> r = <red> g = <green> b = <blue>
	endif
endscript

script ApplyLightIntensityChange
	if IsCreated <LightChecksum>
		<LightChecksum> ::Light_SetParams <...>
	endif
endscript

script ApplyLightSpecularIntensityChange
	if IsCreated <LightChecksum>
		<LightChecksum> ::Light_SetParams <...>
	endif
endscript

script ApplyLightFarAttenEndChange
endscript

script ApplyLightFarAttenStartChange
endscript

script UpdateLightTransform
	if IsCreated <LightChecksum>
		SetLightFlag name = <LightChecksum> flag = DYNAMIC
		MoveLight name = <LightChecksum> Pos = <Pos>
		ClearLightFlag name = <LightChecksum> flag = DYNAMIC
		CompactIntervals
	endif
endscript

script ApplyGroupIntensityChange
	SetLightGroupIntensity name = <GroupChecksum> i = <Intensity>
endscript

script ApplySnapshotToLight
	if GotParam \{LightChecksum}
		if IsCreated <LightChecksum>
			<LightChecksum> ::Light_SetParams <...>
		endif
	elseif GotParam \{HousingChecksum}
		if IsCreated <HousingChecksum>
			if <HousingChecksum> ::Obj_HasComponent PositionMorph
				<HousingChecksum> ::PM_SetParams <...>
			endif
			<HousingChecksum> ::LightVolume_SetParams <...>
		endif
	endif
endscript

script UpdateHousingTransform
	if IsCreated <HousingChecksum>
		if <HousingChecksum> ::Obj_HasComponent PositionMorph
			<HousingChecksum> ::PM_SetParams <...>
		endif
	endif
endscript

script ApplyHousingStartRadiusChange
	if IsCreated <HousingChecksum>
		<HousingChecksum> ::LightVolume_SetParams <...>
	endif
endscript

script ApplyHousingEndRadiusChange
	if IsCreated <HousingChecksum>
		<HousingChecksum> ::LightVolume_SetParams <...>
	endif
endscript

script ApplyHousingInnerRadiusChange
	if IsCreated <HousingChecksum>
		<HousingChecksum> ::LightVolume_SetParams <...>
	endif
endscript

script ApplyHousingRangeChange
	if IsCreated <HousingChecksum>
		<HousingChecksum> ::LightVolume_SetParams <...>
	endif
endscript

script ApplyHousingVolumeDensityChange
	if IsCreated <HousingChecksum>
		<HousingChecksum> ::LightVolume_SetParams <...>
	endif
endscript

script ApplyVolumeColorChange
	if IsCreated <HousingChecksum>
		<HousingChecksum> ::LightVolume_SetParams {
			VolumeColorRed = <red>
			VolumeColorGreen = <green>
			VolumeColorBlue = <blue>
		}
	endif
endscript

script ApplyProjectorColorChange
	if IsCreated <HousingChecksum>
		<HousingChecksum> ::LightVolume_SetParams {
			ProjectorColorRed = <red>
			ProjectorColorGreen = <green>
			ProjectorColorBlue = <blue>
		}
	endif
endscript
