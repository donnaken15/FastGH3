transition_playing = true
current_playing_transition = Default_FastIntro_Transition
Transition_Types = {
	generic = {
		textnl = 'generic'
	}
	immediate = {
		textnl = 'immediate'
	}
	Intro = {
		textnl = 'intro'
	}
	fastintro = {
		textnl = 'fastintro'
	}
	practice = {
		textnl = 'practice'
	}
	preencore = {
		textnl = 'preencore'
	}
	ENCORE = {
		textnl = 'encore'
	}
	restartencore = {
		textnl = 'restartencore'
	}
	preboss = {
		textnl = 'preboss'
	}
	boss = {
		textnl = 'boss'
	}
	restartboss = {
		textnl = 'restartboss'
	}
	songwon = {
		textnl = 'songwon'
	}
	songlost = {
		textnl = 'songlost'
	}
	battleend = {
		textnl = 'battleend'
	}
}
nointro_ready_time = 400
Default_Immediate_Transition = {
	time = $nointro_ready_time
	ScriptTable = [
	]
}
Common_Immediate_Transition = {
	ScriptTable = [
		{
			time = 0
			Scr = nointro
		}
		{
			time = 1
			Scr = Transition_StartRendering
		}
		{
			time = 10
			Scr = muh_arby_bot_star
		}
		{
			time = 10
			Scr = key_events
		}
	]
}
Default_Generic_Transition = {
	time = 1500
	ScriptTable = [
	]
}
Common_Generic_Transition = {
	ScriptTable = [
		{
			time = 0
			Scr = play_intro
		}
		{
			time = 1
			Scr = Transition_StartRendering
		}
		{
			time = 300
			Scr = muh_arby_bot_star
		}
		{
			time = 300
			Scr = key_events
		}
	]
}
Default_FastIntro_Transition = $Default_Generic_Transition
Common_FastIntro_Transition = $Common_Generic_Transition
Default_RestartEncore_Transition = $Default_Generic_Transition
Common_RestartEncore_Transition = $Common_Generic_Transition
Default_RestartBoss_Transition = $Default_Generic_Transition
Common_RestartBoss_Transition = $Common_Generic_Transition
Default_Practice_Transition = $Default_Generic_Transition
Common_Practice_Transition = $Common_Generic_Transition
Default_Intro_Transition = $Default_Generic_Transition
Common_Intro_Transition = $Common_Generic_Transition
Default_PreEncore_Transition = {
	time = 8000
	ScriptTable = [
		{
			time = 0
			Scr = Change_Crowd_Looping_SFX
			params = {
				crowd_looping_state = good
			}
		}
	]
}
Common_PreEncore_Transition = {
	ScriptTable = [
	]
	EndWithDefaultCamera
}
Default_Encore_Transition = $Default_Generic_Transition
Common_Encore_Transition = $Common_Generic_Transition
Default_PreBoss_Transition = {
	time = 8000
	ScriptTable = [
	]
}
Common_PreBoss_Transition = {
	ScriptTable = [
	]
}
Default_Boss_Transition = {
	time = 3000
	ScriptTable = [
	]
}
Common_Boss_Transition = {
	ScriptTable = [
		{
			time = 0
			Scr = Transition_StopRendering
		}
		{
			time = 10000
			Scr = play_intro
		}
		{
			time = 10000
			Scr = Transition_StartRendering
		}
	]
}
Default_SongWon_Transition = {
	time = 0
	ScriptTable = [
	]
}
Common_SongWon_Transition = {
	ScriptTable = [
	]
}
Default_SongLost_Transition = {
	time = 3400
	ScriptTable = [
	]
}
Common_SongLost_Transition = {
	ScriptTable = [
	]
}
Default_BattleEnd_Transition = {
	time = 3400
	ScriptTable = [
	]
}
Common_BattleEnd_Transition = {
	ScriptTable = [
	]
}

script Transition_SelectTransition\{practice_intro = 0}
	if (<practice_intro> = 1)
		return
	endif
	if ($current_transition = debugintro)
		Change \{current_transition = Intro}
		return
	endif
	if ($coop_dlc_active = 1)
		Change \{current_transition = Intro}
		return
	endif
	if ($game_mode = p1_career ||
		$game_mode = p2_career)
		get_progression_globals game_mode = ($game_mode)use_current_tab = 1
		Career_Songs = <tier_global>
		Tier = ($setlist_selection_tier)
		FormatText checksumName = tier_checksum 'tier%s' s = <Tier>
		if NOT StructureContains structure = ($<Career_Songs>)<tier_checksum>
			Change \{current_transition = Intro}
			return
		endif
		if Progression_IsBossSong tier_global = <tier_global> Tier = <Tier> song = ($current_song)
			if should_play_boss_intro
				if NOT ($current_song = bossdevil)
					Change \{current_transition = boss}
				else
					Change \{current_transition = fastintro}
				endif
			else
				Change \{current_transition = fastintro}
			endif
			return
		endif
		if Progression_IsEncoreSong tier_global = <tier_global> Tier = <Tier> song = ($current_song)
			Change \{current_transition = ENCORE}
			return
		endif
	endif
	if ($game_mode = p1_quickplay)
		get_progression_globals game_mode = ($game_mode)use_current_tab = 1
		SetList_Songs = <tier_global>
		Tier = ($setlist_selection_tier)
		FormatText checksumName = tier_checksum 'tier%s' s = <Tier>
		if NOT StructureContains structure = ($<SetList_Songs>)<tier_checksum>
			Change \{current_transition = Intro}
			return
		endif
	endif
	Change \{current_transition = Intro}
endscript

script Transition_KillAll
	killspawnedscript \{id = transitions}
	Change \{transition_playing = FALSE}
	Change \{current_playing_transition = None}
endscript

script Transition_GetTime\{Type = Intro}
	if StructureContains structure = $Transition_Types <Type>
		//printstruct <...>
		type_textnl = ($Transition_Types.<Type>.textnl)
	else
		printstruct <...>
		ScriptAssert \{"Unknown transition type"}
	endif
	GetPakManCurrentName \{map = zones}
	FastFormatCrc a = <pakname> b = '_' c = <type_textnl> d = '_Transition' out = Transition_Props
	if NOT GlobalExists name = <Transition_Props>
		FastFormatCrc #"0x1ca1ff20" a = '_' b = <type_textnl> c = '_Transition' out = Transition_Props
		//type_textnl = 'default'
	endif
	printstruct <...>
	//FormatText checksumName = Transition_Props '%s_%p_Transition' p = <type_textnl> s = <pakname>
	//	FormatText checksumName = Transition_Props 'default_%p_Transition' p = <type_textnl> s = <pakname>
	return transition_time = ($<Transition_Props>.time)
endscript

script Transition_Play\{Type = Intro}
	Transition_KillAll
	Change current_playing_transition = <Type>
	if StructureContains structure = $Transition_Types <Type>
		type_textnl = ($Transition_Types.<Type>.textnl)
	else
		printstruct <...>
		ScriptAssert \{"Unknown transition type"}
	endif
	GetPakManCurrentName \{map = zones}
	FormatText checksumName = event 'Common_%p_TransitionSetup' p = <type_textnl> s = <pakname>
	if ScriptExists <event>
		<event>
	endif
	FormatText checksumName = event '%s_%p_TransitionSetup' p = <type_textnl> s = <pakname>
	if ScriptExists <event>
		<event>
	endif
	spawnscriptnow Transition_Play_Spawned id = transitions params = {<...> }
	FormatText checksumName = event 'GuitarEvent_Transition%s' s = <type_textnl>
	if ScriptExists <event>
		spawnscriptnow <event>
	endif
endscript

script Transition_Play_Spawned
	Change \{transition_playing = true}
	GetPakManCurrentName \{map = zones}
	FormatText checksumName = Transition_Props '%s_%p_Transition' p = <type_textnl> s = <pakname>
	if NOT GlobalExists name = <Transition_Props>
		FormatText checksumName = Transition_Props 'default_%p_Transition' p = <type_textnl>
		if NOT GlobalExists name = <Transition_Props>
			printstruct <...>
			ScriptAssert \{"Default Transition Struct not found"}
		endif
	endif
	transition_time = ($<Transition_Props>.time)
	spawnscriptnow Transition_Play_Iterator id = transitions params = {<...> }
	FormatText checksumName = Transition_Props 'Common_%p_Transition' p = <type_textnl>
	spawnscriptnow Transition_Play_Iterator id = transitions params = {<...> }
	GetSongTimeMs
	time_offset = (0 - <time>)
	begin
		GetSongTimeMs time_offset = <time_offset>
		if (<transition_time> <= <time>)
			Change \{transition_playing = FALSE}
			break
		endif
		wait \{1 gameframe}
	repeat
	if StructureContains structure = ($<Transition_Props>)EndWithDefaultCamera
		if StructureContains structure = ($<Transition_Props>)SyncWithNoteCameras
			CameraCuts_GetNextNoteCameraTime
			GetSongTimeMs
			if (<camera_time> >= 0 &
				<camera_time> - <time> < 2000)
				CameraCuts_EnableChangeCam \{enable = FALSE}
			else
				if NOT ($game_mode = training)
					CameraCuts_SetArrayPrefix \{prefix = 'cameras' changenow}
				else
					CameraCuts_EnableChangeCam \{enable = FALSE}
				endif
			endif
		else
			if NOT ($game_mode = training)
				CameraCuts_SetArrayPrefix \{prefix = 'cameras' changenow}
			else
				CameraCuts_EnableChangeCam \{enable = FALSE}
			endif
		endif
	endif
	FormatText checksumName = event 'Common_%p_TransitionEnd' p = <type_textnl> s = <pakname>
	if ScriptExists <event>
		spawnscriptnow <event>
	endif
	FormatText checksumName = event '%s_%p_TransitionEnd' p = <type_textnl> s = <pakname>
	if ScriptExists <event>
		spawnscriptnow <event>
	endif
	Change \{current_playing_transition = None}
endscript

script Transition_Play_Iterator
	GetSongTimeMs
	time_offset = (0 - <time>)
	GetArraySize ($<Transition_Props>.ScriptTable)
	if (<array_Size> = 0)
		return
	endif
	GetSongTimeMs time_offset = <time_offset>
	array_count = 0
	begin
		begin
			GetSongTimeMs time_offset = <time_offset>
			if ($<Transition_Props>.ScriptTable [<array_count>].time <= <time>)
				break
			endif
			wait \{1 gameframe}
		repeat
		if ScriptExists ($<Transition_Props>.ScriptTable [<array_count>].Scr)
			spawnscriptnow ($<Transition_Props>.ScriptTable [<array_count>].Scr)id = transitions params = {transition_time = <transition_time> ($<Transition_Props>.ScriptTable [<array_count>].params)}
		endif
		array_count = (<array_count> + 1)
	repeat <array_Size>
endscript

script Transition_Wait
	begin
		if ($transition_playing = FALSE)
			return
		endif
		wait \{1 gameframe}
	repeat
endscript

script Transition_PlayAnim\{cycle = 0}
	<Obj> ::Obj_SwitchScript Transition_PlayAnim_Spawned params = {anim = <anim> cycle = <cycle> BlendDuration = <BlendDuration>}
endscript

script Transition_PlayAnim_Spawned
	begin
		GameObj_PlayAnim anim = <anim> BlendDuration = <BlendDuration>
		GameObj_WaitAnimFinished
		if (<cycle> = 0)
			break
		endif
	repeat
endscript

script Transition_CameraCut
	CameraCuts_SetArrayPrefix <...> length = <transition_time>
endscript

script Transition_StopRendering
	printf \{"Transition_StopRendering"}
	StopRendering
endscript

script Transition_StartRendering
	printf \{"Transition_StartRendering"}
	StartRendering
	enable_pause
	Change \{is_changing_levels = 0}
	if ($blade_active = 1)
		gh3_start_pressed
	endif
endscript

script Transition_Printf
	printf <...>
endscript

script Transitions_ResetZone
	printf \{"Transitions_ResetZone"}
	GetPakManCurrentName \{map = zones}
	FormatText checksumName = reset_func '%s_ResetTransition' s = <pakname>
	if ScriptExists <reset_func>
		<reset_func>
	endif
	FormatText checksumName = nodearray_checksum '%s_NodeArray' s = <pakname>
	if NOT GlobalExists name = <nodearray_checksum> Type = array
		return
	endif
	GetArraySize $<nodearray_checksum>
	array_count = 0
	begin
		resetvalid = true
		if StructureContains structure = ($<nodearray_checksum> [<array_count>])CreatedFromVariable
			resetvalid = FALSE
		endif
		if StructureContains structure = ($<nodearray_checksum> [<array_count>])CreatedOnProgress
			resetvalid = FALSE
		endif
		if StructureContains structure = ($<nodearray_checksum> [<array_count>])Class
			if NOT ($<nodearray_checksum> [<array_count>].Class = GameObject ||
				$<nodearray_checksum> [<array_count>].Class = LevelGeometry)
				resetvalid = FALSE
			endif
		else
			resetvalid = FALSE
		endif
		if (<resetvalid> = true)
			printf "Resetting %s" s = ($<nodearray_checksum> [<array_count>].name)
			kill name = ($<nodearray_checksum> [<array_count>].name)
			if StructureContains structure = ($<nodearray_checksum> [<array_count>])CreatedAtStart
				create name = ($<nodearray_checksum> [<array_count>].name)
			endif
		endif
		array_count = (<array_count> + 1)
	repeat <array_Size>
endscript

script Common_PreEncore_TransitionSetup
	PreEncore_Crowd_Build_SFX
	Change_Crowd_Looping_SFX \{crowd_looping_state = good}
endscript

script Common_PreEncore_TransitionEnd
endscript

script Common_Encore_TransitionSetup
	GH_SFX_Play_Encore_Audio_From_Zone_Memory
endscript

script Common_Boss_TransitionSetup
	GH_SFX_Play_Boss_Audio_From_Zone_Memory
endscript

script Common_Encore_TransitionEnd
endscript

script Preload_Encore_Bink_Audio\{movie_name = 'z_artdeco_encore_audio'}
endscript
