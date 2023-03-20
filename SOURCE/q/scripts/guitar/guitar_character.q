guitarist_info = {
	anim_set = None
	stance = None
	finger_anims = None
	fret_anims = None
	strum = None
	guitar_model = None
	playing_missed_note = FALSE
	last_strum_length = None
	current_anim = None
	anim_repeat_count = 0
	arms_disabled = 1
	disable_arms = 1
	cycle_anim = FALSE
	next_stance = None
	next_anim = None
	next_anim_repeat_count = 0
	next_anim_disable_arms = 1
	cycle_next_anim = FALSE
	last_anim_name = None
	waiting_for_cameracut = FALSE
	allow_movement = FALSE
	target_node = None
	facial_anim = None
	Scale = 0.0
}
bassist_info = {
	anim_set = None
	stance = None
	finger_anims = None
	fret_anims = None
	strum = None
	bass_model = None
	playing_missed_note = FALSE
	last_strum_length = None
	current_anim = None
	anim_repeat_count = 0
	arms_disabled = 1
	disable_arms = 1
	cycle_anim = FALSE
	next_stance = None
	next_anim = None
	next_anim_repeat_count = 0
	next_anim_disable_arms = 1
	cycle_next_anim = FALSE
	last_anim_name = None
	waiting_for_cameracut = FALSE
	allow_movement = FALSE
	target_node = None
	facial_anim = None
	Scale = 0.0
}
vocalist_info = {
	anim_set = None
	stance = None
	current_anim = None
	anim_repeat_count = 0
	disable_arms = 1
	arms_disabled = 1
	cycle_anim = FALSE
	next_stance = None
	next_anim = None
	next_anim_repeat_count = 0
	next_anim_disable_arms = 1
	cycle_next_anim = FALSE
	last_anim_name = None
	allow_movement = FALSE
	target_node = None
	facial_anim = None
	Scale = 0.0
}
drummer_info = {
	TWIST = 0.0
	desired_twist = 0.0
	anim_set = None
	stance = None
	current_anim = None
	anim_repeat_count = 0
	disable_arms = 1
	arms_disabled = 1
	cycle_anim = FALSE
	next_stance = None
	next_anim = None
	next_anim_repeat_count = 0
	next_anim_disable_arms = 1
	cycle_next_anim = FALSE
	last_anim_name = None
	allow_movement = FALSE
	target_node = None
	facial_anim = None
	last_left_arm_note = 0
	last_right_arm_note = 0
	Scale = 0.0
}
current_bass_model = None

script create_band
endscript

script create_guitarist_profile
	player2_is_lead = FALSE
	if ($current_num_players = 2)
		if (($game_mode = p2_career)|| ($game_mode = p2_coop))
			if NOT ($player1_status.part = guitar)
				player2_is_lead = true
			endif
		endif
	endif
	if ((<name> = GUITARIST & <player2_is_lead> = FALSE)|| (<name> = BASSIST & <player2_is_lead> = true))
		player_status = player1_status
	else
		player_status = player2_status
	endif
	found = 0
	find_profile_by_id id = ($<player_status>.character_id)
	<found> = 1
	if (<found> = 1)
		if GotParam \{no_guitar}
			<instrument_id> = None
		else
			if ($boss_battle = 1 & <name> = BASSIST)
				get_musician_profile_struct index = <index>
				<instrument_id> = (<profile_struct>.musician_instrument.desc_id)
			else
				<instrument_id> = ($<player_status>.instrument_id)
			endif
		endif
		if ($Cheat_AirGuitar = 1)
			if NOT ($is_network_game)
				<instrument_id> = None
			endif
		endif
		outfit = ($<player_status>.outfit)
		style = ($<player_status>.style)
		get_musician_profile_struct index = <index>
		character_name = (<profile_struct>.name)
		FormatText checksumName = body_id 'Guitarist_%n_Outfit%o_Style%s' n = <character_name> o = <outfit> s = <style>
		Profile = {<profile_struct>
			musician_instrument = {desc_id = <instrument_id>}
			musician_body = {desc_id = <body_id>}
			download_musician_instrument = {desc_id = <instrument_id>}
			download_musician_body = {desc_id = <body_id>}
			outfit = <outfit>}
	endif
	return <...>
endscript

script create_guitarist\{name = GUITARIST profile_name = 'axel' instrument_id = Instrument_Les_Paul_Black async = 0 animpak = 1}
	ExtendCrc <name> '_Info' out = info_struct
	printf channel = AnimInfo "creating guitarist - %a ........." a = <name>
	create_guitarist_profile <...>
	character_id = ($<player_status>.character_id)
	if (<found> = 1)
		if GotParam \{node_name}
			waypoint_id = <node_name>
		else
			get_start_node_id member = <name>
		endif
		if DoesWaypointExist name = <waypoint_id>
			Change StructureName = <info_struct> target_node = <waypoint_id>
		else
			printf "unable to find starting position for %a ........" a = <name>
		endif
		ClearEventHandlerGroup \{hand_events}
		if NOT create_band_member name = <name> Profile = <Profile> start_node = <waypoint_id> <...>
			return \{FALSE}
		endif
		find_profile_by_id id = <character_id>
		FormatText textname = highway_name 'Guitarist_%n_Outfit%o_Style%s' n = (<profile_struct>.name)o = <outfit> s = <style>
		AddToMaterialLibrary scene = <highway_name>
		FormatText checksumName = highway_material 'sys_%a_1_highway_sys_%a_1_highway' a = (<profile_struct>.name)
		Change StructureName = <player_status> highway_material = <highway_material>
		Change StructureName = <player_status> band_member = <name>
		get_musician_profile_struct index = <index>
		Change StructureName = <info_struct> anim_set = (<profile_struct>.anim_set)
		Change StructureName = <info_struct> finger_anims = (<profile_struct>.finger_anims)
		Change StructureName = <info_struct> fret_anims = (<profile_struct>.fret_anims)
		Change StructureName = <info_struct> strum = (<profile_struct>.strum_anims)
		Change StructureName = <info_struct> allow_movement = FALSE
		Change StructureName = <info_struct> arms_disabled = 1
		Change StructureName = <info_struct> disable_arms = 1
		Change StructureName = <info_struct> next_stance = ($<info_struct>.stance)
		Change StructureName = <info_struct> Scale = 0.0
		stance = ($<info_struct>.stance)
		printf channel = AnimInfo "creating guitarist in stance %a ........" a = <stance>
		if (<stance> = fail || <stance> = Stance_FrontEnd_Guitar)
			Change StructureName = <info_struct> arms_disabled = 2
			Change StructureName = <info_struct> disable_arms = 2
			<name> ::hero_toggle_arms num_arms = 0 prev_num_arms = 2 blend_time = 0.0
		else
			EmptyScript
			EmptyScript
			EmptyScript <...>
			EmptyScript <...>
			EmptyScript <...>
			EmptyScript <...>
			EmptyScript
		endif
		finger_anims = ($<info_struct>.finger_anims)
		fret_anims = ($<info_struct>.fret_anims)
		strum_type = ($<info_struct>.strum)
		ExtendCrc <strum_type> '_Strums' out = strum_anims
		if IsWinPort
			if NOT (<character_id> = ripper)
				<name> ::Ragdoll_SetAccessoryBones accessory_bones = $guitarist_accessory_bones
			endif
		else
			EmptyScript
			EmptyScript
			EmptyScript
			EmptyScript <...>
		endif
		EmptyScript
		EmptyScript
		EmptyScript
		EmptyScript
		EmptyScript
		EmptyScript
		if GotParam \{no_anim}
			spawnscriptnow temp_hero_pause_script params = {name = <name>}
		endif
		EmptyScript
		EmptyScript <...>
	else
		printf \{"profile not found in create_guitarist! ........."}
	endif
	return \{true}
endscript

script temp_hero_pause_script
endscript

script unload_character
	destroy_band_member name = <name>
endscript

script unload_band
	destroy_band_member \{name = GUITARIST}
	destroy_band_member \{name = BASSIST}
	destroy_band_member \{name = drummer}
	destroy_band_member \{name = vocalist}
	force_unload_all_character_paks
endscript

script hero_play_random_anim
endscript

script should_display_debug_info
	Obj_GetID
	display_info = FALSE
	switch (<objID>)
		case GUITARIST
			if ($display_guitarist_anim_info = true)
				display_info = true
			endif
		case BASSIST
			if ($display_bassist_anim_info = true)
				display_info = true
			endif
		case vocalist
			if ($display_vocalist_anim_info = true)
				display_info = true
			endif
		case drummer
			if ($display_drummer_anim_info = true)
				display_info = true
			endif
	endswitch
	return <display_info>
endscript

script find_profile
	get_musician_profile_size
	if GotParam \{name}
		GetLowerCaseString <name>
		search_name = <lowercasestring>
		found = 0
		index = 0
		begin
			get_musician_profile_struct index = <index>
			GetLowerCaseString (<profile_struct>.name)
			profile_name = <lowercasestring>
			if (<profile_name> = <search_name>)
				found = 1
				break
			endif
			index = (<index> + 1)
		repeat <array_Size>
		return found = <found> index = <index>
	elseif GotParam \{body_id}
		found = 0
		index = 0
		begin
			get_musician_profile_struct index = <index>
			Body = (<profile_struct>.musician_body)
			body_descid = (<Body>.desc_id)
			if (<body_id> = <body_descid>)
				found = 1
				break
			endif
			index = (<index> + 1)
		repeat <array_Size>
		return found = <found> index = <index>
	endif
endscript

script find_profile_by_id
	get_musician_profile_size
	found = 0
	index = 0
	begin
		get_musician_profile_struct index = <index>
		next_name = (<profile_struct>.name)
		FormatText checksumName = profile_id '%n' n = <next_name> AddToStringLookup = true
		if (<profile_id> = <id>)
			return true index = <index>
			break
		endif
		index = (<index> + 1)
	repeat <array_Size>
	find_profile_by_id \{id = axel}
	return FALSE index = <index>
endscript

script get_waypoint_id
endscript

script get_start_node_id
endscript

script get_skill_level
	health = ($player1_status.current_health)
	skill = Normal
	if (<health> < 0.66)
		skill = bad
	elseif (<health> > 1.3299999)
		skill = good
	endif
	return skill = <skill>
endscript

script get_target_node
	Obj_GetID
	ExtendCrc <objID> '_Info' out = info_struct
	return target_node = ($<info_struct>.target_node)
endscript

script bandmember_idle
	ResetEventHandlersFromTable \{BandMember_Idle_EventTable group = hand_events}
	Obj_KillSpawnedScript \{name = hero_play_adjusting_random_anims}
	Block
endscript

script play_special_facial_anim
	if NOT GotParam \{anim}
		return
	endif
	Obj_KillSpawnedScript \{name = facial_anim_loop}
endscript

script facial_anim_loop
endscript
Guitarist_Idle_EventTable = [
	{
		response = call_script
		event = play_battle_anim
		Scr = EmptyScript
	}
]

script guitarist_idle
	ResetEventHandlersFromTable \{Guitarist_Idle_EventTable group = hand_events}
	Obj_GetID
	if (($player1_status.band_member)= <objID>)
		SetEventHandler \{response = call_script event = star_power_onp1 Scr = handle_star_power group = hand_events}
	else (($player2_status.band_member)= <objID>)
		SetEventHandler \{response = call_script event = star_power_onp2 Scr = handle_star_power group = hand_events}
	endif
	Obj_KillSpawnedScript \{name = hero_play_adjusting_random_anims}
	Block
endscript

script guitarist_idle_animpreview
	ClearEventHandlerGroup \{hand_events}
endscript

script handle_star_power
endscript

script handle_song_won
endscript

script handle_song_failed
endscript

script play_intro_anims
endscript

script UseSmallVenueAnims
endscript

script play_win_anims
	if ($disable_band = 1)
		return
	endif
	if ($game_mode = tutorial)
		return
	endif
	restore_idle_faces
endscript

script play_lose_anims
	printf \{channel = newdebug "play_lose_anims............"}
	if ($disable_band = 0)
		return
	endif
	restore_idle_faces
endscript

script restore_idle_faces
endscript

script Hide_Band
	if CompositeObjectExists \{GUITARIST}
		GUITARIST ::Hide
	endif
	if CompositeObjectExists \{BASSIST}
		BASSIST ::Hide
	endif
	if CompositeObjectExists \{vocalist}
		vocalist ::Hide
	endif
	if CompositeObjectExists \{drummer}
		drummer ::Hide
	endif
endscript

script Unhide_Band
	if CompositeObjectExists \{GUITARIST}
		GUITARIST ::unhide
	endif
	if CompositeObjectExists \{BASSIST}
		BASSIST ::unhide
	endif
	if CompositeObjectExists \{vocalist}
		vocalist ::unhide
	endif
	if CompositeObjectExists \{drummer}
		drummer ::unhide
	endif
endscript
using_walk_camera = FALSE

script start_walk_camera
endscript

script Kill_Walk_Camera
endscript
