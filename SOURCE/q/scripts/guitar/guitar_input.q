button_values = [
	65536
	4096
	256
	16
	1
	0
]
hammer_on_measure_scale = 0

script check_buttons_fast
	ExtendCrc <song_name> '_guitar' out = guitar_stream
	GuitarInputLogicInit player_status = <player_status> guitar_stream = <guitar_stream> time_offset = <time_offset>
	begin
		if ($ui_flow_manager_state [(<Player> -1)] = online_pause_fs)
			SetInput controller = ($<player_status>.controller)pattern = 0 strum = 0
		endif
		if NOT GuitarInputLogicPerFrame Player = <Player>
			break
		endif
		wait \{1 gameframe}
	repeat
endscript
p1_star_ready = 0
p2_star_ready = 0

script bot_star_power\{player_status = player1_status}
	Change StructureName = <player_status> bot_star_power = 1
endscript

script check_buttons_bot
	if NOT ($input_mode = Play)
		ExtendCrc input_array <player_text> out = input_array
		song = <input_array>
		GetStrumPattern song = <song> entry = <array_entry>
		do_hammer = ($<song> [<array_entry>] [6])
		Change StructureName = <player_status> bot_pattern = <strum>
		Change StructureName = <player_status> bot_strum = 1
	endif
endscript

script strip_single_note_strum
	stripped_strum = <pattern>
	if (<required_pattern> & 4096)
		<stripped_strum> = (<pattern> & 4369)
	endif
	if (<required_pattern> & 256)
		<stripped_strum> = (<pattern> & 273)
	endif
	if (<required_pattern> & 16)
		<stripped_strum> = (<pattern> & 17)
	endif
	if (<required_pattern> & 1)
		<stripped_strum> = (<pattern> & 1)
	endif
	return stripped_strum = <stripped_strum>
endscript
button_up_pixel_arrayp1 = [
	0.0
	0.0
	0.0
	0.0
	0.0
]
button_up_pixel_arrayp2 = [
	0.0
	0.0
	0.0
	0.0
	0.0
]

script button_checker
	ButtonCheckerInit <...>
	begin
		ButtonCheckerPerFrame
		if ($display_debug_input = 1)
			input_debug <...>
		endif
		wait \{1 gameframe}
	repeat
	ButtonCheckerCleanup
endscript
currently_holding = [
	0
	0
]

script check_note_hold1
	printstruct <...>
endscript

script check_note_hold
	<index> = (<Player> - 1)
	begin
		if ($currently_holding [<index>] = 0)
			break
		endif
		wait \{1 gameframe}
	repeat
	SetArrayElement ArrayName = currently_holding GlobalArray index = <index> NewValue = 1
	CheckNoteHoldInit Player = <Player> player_status = <player_status> array_entry = <array_entry> time = <time> guitar_stream = <guitar_stream> song = <song> pattern = <pattern>
	begin
		if NOT CheckNoteHoldWait Player = <Player>
			break
		endif
		wait \{1 gameframe}
	repeat
	CheckNoteHoldStart Player = <Player>
	begin
		if NOT CheckNoteHoldPerFrame Player = <Player>
			break
		endif
		wait \{1 gameframe}
	repeat
	if ($FC_MODE = 1)
		Change StructureName = <player_status> current_health = 0.0000000000000000001
	endif
	CheckNoteHoldEnd Player = <Player>
	SetArrayElement ArrayName = currently_holding GlobalArray index = <index> NewValue = 0
endscript

script single_note
	if (<pattern> = 65536)
		return \{true}
	endif
	if (<pattern> = 4096)
		return \{true}
	endif
	if (<pattern> = 256)
		return \{true}
	endif
	if (<pattern> = 16)
		return \{true}
	endif
	if (<pattern> = 1)
		return \{true}
	endif
	return \{FALSE}
endscript

script check_for_star_power_fast
	Change \{p1_star_ready = 0}
	Change \{p2_star_ready = 0}
	Change StructureName = <player_status> star_power_usable = 1
	CheckForStarPowerInit <...>
	begin
		if NOT ($game_mode = p2_career || $game_mode = p2_coop)
			begin
				if ($<player_status>.star_power_usable = 1)
					break
				endif
				wait \{1 gameframe}
			repeat
		endif
		wait \{1 gameframe}
		if NOT ($ui_flow_manager_state [(<Player> -1)] = online_pause_fs)
			CheckForStarPowerPerFrame <...>
		endif
	repeat
endscript

script check_for_star_power
	check_for_star_power_cfunc_setup
	begin
		if check_for_star_power_cfunc
			break
		else
			if GotParam \{ScriptToRun}
				<ScriptToRun> <ScriptToRun_Params>
			else
				wait \{1 gameframe}
			endif
		endif
	repeat
	check_for_star_power_cfunc_cleanup
endscript

script print_guitar_analogue_info
	GuitarGetAnalogueInfo controller = ($primary_controller)
	printstruct <...>
endscript

script wait_for_inactive
	Change StructureName = <player_status> star_power_usable = 0
	<frames_under> = 0
	controller = ($<player_status>.controller)
	if IsGuitarController controller = <controller>
		if (<guitar_used_select> = 0)
			begin
				wait \{1 gameframe}
				if GuitarGetAnalogueInfo controller = <controller>
					if (<righty> > $<player_status>.star_tilt_threshold)
						Increment \{frames_under}
						if (<frames_under> >= 30)
							break
						endif
					endif
				endif
			repeat
		else
			<guitar_used_select> = 0
		endif
	endif
	Change StructureName = <player_status> star_power_usable = 1
endscript

script star_power_activate_and_drain
	Change StructureName = <player_status> star_power_used = 1
	spawnscriptnow hud_activated_star_power params = {Player = <Player>}
	wait \{1 gameframe}
	LaunchGemEvent event = star_power_on Player = <Player>
	ExtendCrc star_power_on <player_text> out = Type
	broadcastevent Type = <Type> data = {player_text = <player_text> Player = <Player> player_status = <player_status>}
	spawnscriptnow \{Crowd_AllPlayAnim params = {anim = starpower}}
	begin
		wait \{1 gameframe}
		if ($game_mode = p2_career || $game_mode = p2_coop)
			drain = ($star_power_drain_rate_coop * 1000.0 * ($current_deltatime / $<player_status>.playline_song_measure_time))
		elseif ($game_mode = tutorial)
			drain = 0
		else
			drain = ($star_power_drain_rate * 1000.0 * ($current_deltatime / $<player_status>.playline_song_measure_time))
		endif
		Change StructureName = <player_status> star_power_amount = ($<player_status>.star_power_amount - <drain>)
		if ($<player_status>.star_power_amount <= 0)
			Change StructureName = <player_status> star_power_amount = 0
			break
		endif
	repeat
	spawnscriptnow \{Crowd_AllPlayAnim params = {anim = Idle}}
	if ($<player_status>.controller = $primary_controller)
		Change gStar_Power_Triggered = ($gStar_Power_Triggered + 1)
	endif
	Change StructureName = <player_status> star_power_used = 0
	UpdateNixie Player = <Player>
	wait \{1 gameframe}
	LaunchGemEvent event = star_power_off Player = <Player>
	ExtendCrc star_power_off <player_text> out = Type
	broadcastevent Type = <Type> data = {player_text = <player_text> player_status = <player_status>}
	<do_star> = 0
	return <...>
endscript
//whammy_wibble_speed = 2 // set to 1
wibble_delta = 0.01666666666 // and 0.008333333333 for 120 FPS
wibble_lagp1 = 0.0 // last time whammy wibbles were updated
wibble_lagp2 = 0.0 //

script control_whammy_pitchshift
	if ($boss_battle = 1)
		if (($<player_status>.Player)= 2)
			return
		endif
	endif
	<set_pitch> = 0
	if GotParam \{net_whammy_length}
		<len> = <net_whammy_length>
		<set_pitch> = 1
	else
		if GuitarGetAnalogueInfo controller = ($<player_status>.controller)
			<set_pitch> = 1
			if ($<player_status>.bot_play = 1)
				<len> = 0.0
			elseif IsGuitarController controller = ($<player_status>.controller)
				<len> = ((<rightx> - $<player_status>.resting_whammy_position)/ (1.0 - $<player_status>.resting_whammy_position))
				if (<len> < 0.0)
					<len> = 0.0
				endif
			else
				if (<leftlength> > 0)
					<len> = <leftlength>
				else
					if (<rightlength> > 0)
						<len> = <rightlength>
					else
						<len> = 0
					endif
				endif
			endif
			if (($is_network_game)& ($<player_status>.Player = 1))
				Change StructureName = <player_status> net_whammy = <len>
			endif
		endif
	endif
	if (<set_pitch> = 1)
		set_whammy_pitchshift control = <len> player_status = <player_status>
		<whammy_scale> = (((<len> * 0.5) + 0.5) * 2.0)
		// thought of doing a dirty hack here
		// where its executed 60 times per second
		// instead of for every single frame
		GetSongTime
		ExtendCrc wibble_lag ($<player_status>.text) out = wibble_lag
		w = ($<wibble_lag>)
		if (<songtime> > <w>)
			SetNewWhammyValue value = <whammy_scale> time_remaining = <time> player_status = <player_status> Player = (<player_status>.Player)
			change globalname = <wibble_lag> newvalue = (<songtime> + $wibble_delta)
		endif
	endif
endscript

script reset_whammy_pitchshift
	set_whammy_pitchshift control = 0.0 player_status = <player_status>
	SetAllWhammyValues value = 1.0 Player = <Player>
	change \{wibble_lagp1 = 0.0}
	change \{wibble_lagp2 = 0.0}
endscript

script boss_play_on
	Change \{boss_play = 1}
	vol = 0
	Player = 1
	begin
		FormatText checksumName = player_status 'player%i_status' i = <Player> AddToStringLookup
		Change StructureName = <player_status> guitar_volume = 100
		Player = (<Player> + 1)
	repeat $current_num_players
	UpdateGuitarVolume
endscript

script boss_play_off
	Change \{boss_play = 0}
endscript

playback_next_frame = 0.0
playback_do_frame = 0
playback_pattern_p1 = 0
playback_pattern_p2 = 0
playback_ctrl1 = 0
playback_ctrl2 = 0
script playback_timer
	if ($replay_suspend = 1)
		//return
		SetInput controller = ($player1_status.controller) pattern = ($playback_pattern_p1) strum = 0
		SetInput controller = ($player2_status.controller) pattern = ($playback_pattern_p2) strum = 0
	endif
	if GameIsPaused
		return
	endif
	GetSongTime
	if (<songtime> > $playback_next_frame)
		if DataBufferGetFloat \{name = replay}
			//SetDeltaTime delta_time = <float>
			change playback_next_frame = <float>
			change playback_do_frame = 1
			// set time to wait to play next frame
			//printf \{'frame %d' d = $playback_next_frame}
		endif
	endif
endscript

script save_replay
	destroy_debugging_menu
	//CreateScreenElement \{Type = TextElement parent = root_window id = info_text font = text_a1 Pos = (640.0, 32.0) just = [center top] Scale = 1.0 rgba = [210 210 210 250] text = "Saving replay" z_priority = 1.0}
	//wait \{2 gameframes}
	//get_difficulty_text_nl difficulty = ($current_difficulty)
	//get_song_prefix song = ($current_song)
	get_song_title \{song = $current_song}
	timestamp
	FormatText textname = FileName "fgh3_%t_%s_" t = <song_title> s = <timestamp>
	WriteDataBuffer name = replay FileName = <FileName>
	printf 'fgh3_%t_%s.rep saved' t = <song_title> s = <timestamp>
	//DestroyScreenElement \{id = info_text}
	create_debugging_menu
endscript

script autodetectleftys
	if IsGuitarController controller = ($<player_status>.controller)
		if GuitarGetAnalogueInfo controller = ($<player_status>.controller)
			if (<RightTrigger> < 0)
				Change StructureName = <player_status> lefthanded = 0
			else
				Change StructureName = <player_status> lefthanded = 1
			endif
		endif
	else
		Change StructureName = <player_status> lefthanded = 0
	endif
	Change StructureName = <player_status> lefthanded_gems = ($<player_status>.lefthanded)
	Change StructureName = <player_status> lefthanded_button_ups = ($<player_status>.lefthanded)
endscript
resting_whammy_tolerance = 0.1

script is_whammy_resting
	if GotParam \{controller}
		get_resting_whammy_position <...>
	else
		controller = ($<player_status>.controller)
		resting_whammy_position = ($<player_status>.resting_whammy_position)
	endif
	if GuitarGetAnalogueInfo controller = <controller>
		if (<rightx> < <resting_whammy_position>)
			return \{true}
		elseif ((<rightx> - <resting_whammy_position>)< ($resting_whammy_tolerance))
			return \{true}
		endif
	endif
	return \{FALSE}
endscript

script get_resting_whammy_position
	GetGlobalTags \{user_options}
	switch (<controller>)
		case 0
			return resting_whammy_position = <resting_whammy_position_device_0>
		case 1
			return resting_whammy_position = <resting_whammy_position_device_1>
		case 2
			return resting_whammy_position = <resting_whammy_position_device_2>
		case 3
			return resting_whammy_position = <resting_whammy_position_device_3>
		case 4
			return resting_whammy_position = <resting_whammy_position_device_4>
		case 5
			return resting_whammy_position = <resting_whammy_position_device_5>
		case 6
			return resting_whammy_position = <resting_whammy_position_device_6>
	endswitch
endscript

script get_star_power_position
	GetGlobalTags \{user_options}
	switch (<controller>)
		case 0
			return star_power_position = <star_power_position_device_0>
		case 1
			return star_power_position = <star_power_position_device_1>
		case 2
			return star_power_position = <star_power_position_device_2>
		case 3
			return star_power_position = <star_power_position_device_3>
		case 4
			return star_power_position = <star_power_position_device_4>
		case 5
			return star_power_position = <star_power_position_device_5>
		case 6
			return star_power_position = <star_power_position_device_6>
	endswitch
endscript

script dragonforce_hack_on
	Change \{dragonforce_hack = 1}
endscript

script dragonforce_hack_off
	Change \{dragonforce_hack = 0}
endscript
