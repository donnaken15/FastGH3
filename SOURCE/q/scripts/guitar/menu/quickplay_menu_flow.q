#"0x3e723318" = [
	{
		action = continue
		flow_state = quickplay_setlist_fs
		transition_right
	}
	{
		action = go_back
		flow_state = main_menu_fs
		transition_left
	}
	{
		action = select_new_song
		func = kill_gem_scroller
		flow_state = quickplay_setlist_fs
	}
]
'v use these to extra optimize size of flow states'
'could i probably also use qbkeystr in struct item in array to add params'
#"0x7793d59c" = {
	action = continue
	func = quickplay_start_song
	transition_screen = default_loading_screen
	flow_state = quickplay_play_song_fs
}
quickplay_select_difficulty_fs = {
	create = create_select_difficulty_menu
	Destroy = destroy_select_difficulty_menu
	actions = [
		{
			action = continue
			func = quickplay_start_song
			transition_screen = default_loading_screen
			flow_state = quickplay_play_song_fs
		}
		{
			action = go_back
			flow_state = quickplay_pause_options_fs
			transition_left
		}
	]
}
quickplay_setlist_fs = {
	create = create_setlist_menu
	Destroy = destroy_setlist_menu
	actions = [
		{
			action = continue
			func = quickplay_start_song
			transition_screen = default_loading_screen
			flow_state = quickplay_play_song_fs
		}
		{
			action = show_help
			flow_state = #"0x6ddea6c0"
			transition_right
		}
		{
			action = go_back
			func = ExitGameConfirmed
		}
	]
}
quickplay_play_song_fs = {
	create = create_play_song_menu
	Destroy = destroy_play_song_menu
	actions = [
		{
			action = pause_game
			flow_state = quickplay_pause_fs
		}
		{
			action = win_song
			func = kill_gem_scroller
			flow_state = quickplay_win_song_fs
		}
		{
			action = fail_song
			flow_state = quickplay_fail_song_fs
		}
		{
			action = controller_disconnect
			flow_state = controller_disconnect_fs
		}
	]
}
quickplay_pause_fs = {
	create = create_pause_menu
	Destroy = destroy_pause_menu
	actions = [
		{
			action = select_resume
			flow_state = quickplay_play_song_fs
		}
		{
			action = select_restart
			flow_state = quickplay_restart_warning_fs
		}
		{
			action = select_practice
			flow_state = quickplay_practice_warning_fs
		}
		{
			action = select_options
			flow_state = quickplay_pause_options_fs
		}
		{
			action = select_quit
			flow_state = quickplay_quit_warning_fs
		}
		{
			action = select_debug_menu
			flow_state = debug_menu_fs
		}
	]
}
quickplay_pause_options_fs = {
	create = create_pause_menu
	create_params = {
		for_options = 1
	}
	Destroy = destroy_pause_menu
	actions = [
		{
			action = select_audio_settings
			flow_state = quickplay_audio_settings_fs
		}
		{
			action = select_calibrate_lag
			flow_state = quickplay_calibrate_lag_warning
			winport_bind_buttons_fs
			#"0xde5731fa"
		}
		{
			action = winport_select_calibrate_lag
			flow_state = winport_quickplay_calibrate_lag_warning
		}
		{
			action = select_calibrate_whammy_bar
			flow_state = calibrate_whammy_bar_fs
		}
		{
			action = select_calibrate_star_power_trigger
			flow_state = calibrate_star_power_trigger_fs
		}
		{
			action = select_lefty_flip
			flow_state = quickplay_lefty_flip_warning
		}
		{
			action = go_back
			flow_state = quickplay_pause_fs
		}
	]
}
#"0x9de642fd" = {
	create = create_debugging_menu
	create_params = {
		for_options = 1
	}
	Destroy = destroy_debugging_menu
	actions = [
		{
			action = #"0xd14d0643"
			flow_state = #"0x5185891e"
		}
		{
			action = go_back
			flow_state = quickplay_pause_options_fs
		}
	]
}
quickplay_restart_warning_fs = {
	create = create_restart_warning_menu
	Destroy = destroy_restart_warning_menu
	actions = [
		{
			action = continue
			func = career_restart_song
			transition_screen = default_loading_screen
			flow_state = quickplay_play_song_fs
		}
		{
			action = go_back
			flow_state = quickplay_pause_fs
		}
	]
}
quickplay_controller_settings_fs = {
	create = create_controller_settings_menu
	create_params = {
		popup = 1
	}
	Destroy = destroy_controller_settings_menu
	actions = [
		{
			action = select_lefty_flip
			flow_state = quickplay_lefty_flip_warning
		}
		{
			action = select_calibrate_whammy_bar
			flow_state = options_controller_settings_fs
		}
		{
			action = select_calibrate_star_power_trigger
			flow_state = calibrate_star_power_trigger_fs
		}
		{
			action = go_back
			flow_state = quickplay_pause_fs
		}
	]
}
quickplay_practice_warning_fs = {
	create = create_practice_warning_menu
	Destroy = destroy_practice_warning_menu
	actions = [
		{
			action = continue
			func = quickplay_go_to_practice_setup
			flow_state = practice_select_song_section_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}

script quickplay_go_to_practice_setup
	Change \{came_to_practice_from = quickplay}
	Change came_to_practice_difficulty = ($current_difficulty)
	kill_gem_scroller
	Change \{game_mode = training}
endscript
quickplay_audio_settings_fs = {
	create = create_audio_settings_menu
	create_params = {
		popup = 1
	}
	Destroy = destroy_audio_settings_menu
	actions = [
		{
			action = continue
			flow_state = quickplay_pause_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
quickplay_video_settings_fs = {
	create = create_video_settings_menu
	create_params = {
		popup = 1
	}
	Destroy = destroy_video_settings_menu
	actions = [
		{
			action = select_calibrate_lag
			flow_state = quickplay_calibrate_lag_warning
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
quickplay_lefty_flip_warning = {
	create = create_lefty_flip_warning_menu
	Destroy = destroy_lefty_flip_warning_menu
	actions = [
		{
			action = continue
			func = lefty_flip_func
			flow_state = quickplay_play_song_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
quickplay_calibrate_lag_warning = {
	create = create_calibrate_lag_warning_menu
	Destroy = destroy_calibrate_lag_warning_menu
	actions = [
		{
			action = continue
			flow_state = quickplay_calibrate_lag_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
winport_quickplay_calibrate_lag_warning = {
	create = winport_create_calibrate_lag_warning_menu
	Destroy = winport_destroy_calibrate_lag_warning_menu
	actions = [
		{
			action = continue
			flow_state = winport_quickplay_calibrate_lag_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
quickplay_calibrateautosave_fs = {
	create = memcard_sequence_begin_autosave
	Destroy = memcard_sequence_cleanup_generic
	actions = [
		{
			action = memcard_sequence_save_success
			func = career_restart_song
			flow_state = quickplay_play_song_fs
		}
		{
			action = memcard_sequence_save_failed
			func = career_restart_song
			flow_state = quickplay_play_song_fs
		}
	]
}
quickplay_calibrate_lag_fs = {
	create = create_calibrate_lag_menu
	Destroy = destroy_calibrate_lag_menu
	actions = [
		{
			action = continue
			flow_state = quickplay_calibrateautosave_fs
		}
		{
			action = go_back
			func = career_restart_song
			flow_state = quickplay_play_song_fs
		}
	]
}
winport_quickplay_calibrate_lag_fs = {
	create = winport_create_calibrate_lag_menu
	Destroy = winport_destroy_calibrate_lag_menu
	actions = [
		{
			action = go_back
			func = career_restart_song
			flow_state = quickplay_play_song_fs
		}
	]
}
quickplay_fail_song_fs = {
	create = create_fail_song_menu
	Destroy = destroy_fail_song_menu
	actions = [
		{
			action = select_practice
			flow_state = quickplay_practice_warning_fs
		}
		{
			action = select_retry
			flow_state = quickplay_play_song_fs
		}
		{
			action = select_quit
			func = ExitGameConfirmed
		}
	]
}

script quickplay_song_select_quit
	GH3_SFX_fail_song_stop_sounds
	kill_gem_scroller
endscript
quickplay_song_ended_fs = {
	create = create_song_ended_menu
	Destroy = destroy_song_ended_menu
	actions = [
		{
			action = select_retry
			flow_state = quickplay_play_song_fs
		}
		{
			action = select_quit
			func = kill_gem_scroller
			flow_state = main_menu_fs
		}
	]
}
quickplay_quit_warning_fs = {
	create = create_quit_warning_menu
	Destroy = destroy_quit_warning_menu
	actions = [
		{
			action = continue
			func = ExitGameConfirmed
		}
		{
			action = go_back
			flow_state = quickplay_pause_fs
		}
	]
}
quickplay_win_song_fs = {
	create = create_newspaper_menu
	Destroy = destroy_newspaper_menu
	actions = [
		{
			action = continue
			func = ExitGameConfirmed
		}
		{
			action = try_again
			func = start_song
			transition_screen = default_loading_screen
			flow_state = quickplay_play_song_fs
		}
		{
			action = save_and_try_again
			func = start_song
			transition_screen = default_loading_screen
			flow_state = quickplay_play_song_fs
		}
		{
			action = select_detailed_stats
			flow_state = quickplay_detailed_stats_fs
		}
		{
			action = quit
			func = ExitGameConfirmed
		}
	]
}
quickplay_tryagainautosave_fs = {
	create = memcard_sequence_begin_autosave
	Destroy = memcard_sequence_cleanup_generic
	actions = [
		{
			action = memcard_sequence_save_success
			func = start_song
			transition_screen = default_loading_screen
			flow_state = quickplay_play_song_fs
		}
		{
			action = memcard_sequence_save_failed
			func = start_song
			transition_screen = default_loading_screen
			flow_state = quickplay_play_song_fs
		}
	]
}
quickplay_detailed_stats_fs = {
	create = create_detailed_stats_menu
	Destroy = destroy_detailed_stats_menu
	actions = [
		{
			action = go_back
			flow_state = quickplay_win_song_fs
		}
		{
			action = continue
			func = ExitGameConfirmed
		}
	]
}
quickplay_toprockers_fs = {
	create = create_top_rockers_menu
	Destroy = destroy_top_rockers_menu
	actions = [
		{
			action = continue
			flow_state = quickplay_autosave_fs
		}
	]
}
quickplay_autosave_fs = {
	create = memcard_sequence_begin_autosave
	Destroy = memcard_sequence_cleanup_generic
	actions = [
		{
			action = memcard_sequence_save_success
			flow_state = quickplay_setlist_fs
		}
		{
			action = memcard_sequence_save_failed
			flow_state = quickplay_setlist_fs
		}
	]
}
#"0x6ddea6c0" = {
	create = create_battle_helper_menu
	Destroy = destroy_battle_helper_menu
	actions = [
		{
			action = continue
			func = quickplay_start_song
			transition_screen = default_loading_screen
			flow_state = quickplay_play_song_fs
		}
		{
			action = go_back
			flow_state = quickplay_setlist_fs
			transition_left
		}
	]
}

script get_total_num_venues
	printf \{"get_total_num_venues"}
	array_entry = 0
	begin
		if NOT get_valid_venue_index venue_index = <array_entry>
			break
		endif
		get_LevelZoneArray_checksum index = <index>
		printf ($LevelZones.<level_checksum>.name)
		<array_entry> = (<array_entry> + 1)
	repeat
	return num_venues = <array_entry>
endscript

script get_valid_venue_index
	get_LevelZoneArray_size
	index = 0
	begin
		get_LevelZoneArray_checksum index = <index>
		valid = 1
		FormatText checksumName = venue_checksum 'venue_%s' s = ($LevelZones.<level_checksum>.name)
		GetGlobalTags <venue_checksum>
		if NOT (<unlocked> = 1)
			valid = 0
		endif
		if (<valid> = 1)
			if (<venue_index> = 0)
				return index = <index> true
			endif
			venue_index = (<venue_index> - 1)
		endif
		index = (<index> + 1)
	repeat <array_Size>
	return \{FALSE}
endscript

script quickplay_start_song\{device_num = 0}
	printf \{"quickplay_start_song"}
	get_progression_globals game_mode = ($game_mode)
	SongList = <tier_global>
	cs_get_total_guitarists
	GetRandomValue a = 0 b = (<num_guitarists> -1)name = random_guitarist_index integer
	get_valid_character_index char_index = <random_guitarist_index> Player = 1
	get_musician_profile_struct index = <index>
	FormatText checksumName = character_id '%s' s = (<profile_struct>.name)
	Change StructureName = player1_status character_id = <character_id>
	Change \{StructureName = player1_status style = 1}
	Change \{StructureName = player1_status outfit = 1}
	guitar_array = ($Bonus_Guitars)
	GetArraySize ($Secret_Guitars)
	index = 0
	begin
		guitar_id = ($Secret_Guitars [<index>].id)
		GetGlobalTags <guitar_id>
		if (<unlocked_for_purchase> = 1)
			AddArrayElement array = (<guitar_array>)element = ($Secret_Guitars [<index>])
			<guitar_array> = (<array>)
		endif
		<index> = (<index> + 1)
	repeat <array_Size>
	GetArraySize <guitar_array>
	GetRandomValue a = 0 b = (<array_Size> -1)name = random_guitar_index integer
	get_musician_instrument_struct index = <random_guitar_index>
	Change StructureName = player1_status instrument_id = (<info_struct>.desc_id)
	get_total_num_venues
	GetRandomValue a = 0 b = (<num_venues> -1)name = random_venue_index integer
	get_valid_venue_index venue_index = <random_venue_index>
	get_LevelZoneArray_checksum index = <index>
	Change current_level = <level_checksum>
	printstruct X = <...>
	printf "Random Guitarist index is %g. Random venue index is %v" g = <random_guitarist_index> v = <random_venue_index>
	start_song device_num = <device_num>
endscript
