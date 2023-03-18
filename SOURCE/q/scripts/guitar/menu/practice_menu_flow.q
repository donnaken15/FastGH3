came_to_practice_from = main_menu
came_to_practice_difficulty = easy
came_to_practice_difficulty2 = easy
practice_select_mode_fs = {
	create = create_select_practice_mode_menu
	Destroy = destroy_select_practice_mode_menu
	actions = [
		{
			action = select_practice
			flow_state = practice_setlist_fs
			transition_right
		}
		{
			action = select_tutorial
			flow_state = practice_tutorial_select_fs
			transition_right
		}
		{
			action = go_back
			flow_state = main_menu_fs
			transition_left
		}
	]
}
practice_setlist_fs = {
	create = create_setlist_menu
	Destroy = destroy_setlist_menu
	actions = [
		{
			action = continue
			flow_state_func = practice_check_song_for_parts
			transition_right
		}
		{
			action = go_back
			func = ResetEngine
		}
	]
}

script practice_check_song_for_parts
	load_songqpak song_name = ($current_song)async = 0
	get_song_struct song = ($current_song)
	if StructureContains structure = <song_struct> no_rhythm_track
		Change \{StructureName = player1_status part = guitar}
		return \{flow_state = practice_select_difficulty_fs}
	endif
	get_song_prefix song = ($current_song)
	FormatText checksumName = song_rhythm_array_id '%s_song_rhythm_easy' s = <song_prefix>
	if GlobalExists name = <song_rhythm_array_id> Type = array
		GetArraySize $<song_rhythm_array_id>
		if (<array_Size> > 0)
			return \{flow_state = practice_select_part_fs}
		endif
	endif
	if StructureContains structure = <song_struct> use_coop_notetracks
		return \{flow_state = practice_select_part_fs}
	endif
	Change \{StructureName = player1_status part = guitar}
	return \{flow_state = practice_select_difficulty_fs}
endscript

script practice_check_song_for_parts_back
	load_songqpak song_name = ($current_song)async = 0
	get_song_struct song = ($current_song)
	if StructureContains structure = <song_struct> no_rhythm_track
		return \{flow_state = practice_setlist_fs}
	endif
	get_song_prefix song = ($current_song)
	FormatText checksumName = song_rhythm_array_id '%s_song_rhythm_easy' s = <song_prefix>
	if GlobalExists name = <song_rhythm_array_id> Type = array
		GetArraySize $<song_rhythm_array_id>
		if (<array_Size> > 0)
			return \{flow_state = practice_select_part_fs}
		endif
	endif
	if StructureContains structure = <song_struct> use_coop_notetracks
		return \{flow_state = practice_select_part_fs}
	endif
	return \{flow_state = practice_setlist_fs}
endscript
practice_select_part_fs = {
	create = create_choose_practice_part_menu
	Destroy = destroy_choose_practice_part_menu
	actions = [
		{
			action = continue
			flow_state = practice_select_difficulty_fs
			transition_right
		}
		{
			action = go_back
			flow_state = practice_setlist_fs
			transition_left
		}
	]
}
practice_select_difficulty_fs = {
	create = create_select_difficulty_menu
	Destroy = destroy_select_difficulty_menu
	actions = [
		{
			action = continue
			flow_state = practice_select_song_section_fs
			transition_right
		}
		{
			action = go_back
			flow_state_func = practice_check_song_for_parts_back
			transition_left
		}
	]
}
practice_select_song_section_fs = {
	create = create_choose_practice_section_menu
	Destroy = destroy_choose_practice_section_menu
	actions = [
		{
			action = continue
			flow_state = practice_select_speed_fs
		}
		{
			action = go_back
			flow_state = #"0x2616eb19"
		}
	]
}
practice_select_speed_fs = {
	create = create_choose_practice_speed_menu
	Destroy = destroy_choose_practice_speed_menu
	actions = [
		{
			action = continue
			func = practice_start_song
			transition_screen = default_loading_screen
			flow_state = practice_play_song_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}

script practice_start_song\{device_num = 0}
	Change \{game_mode = training}
	Change \{current_transition = practice}
	start_song startTime = ($practice_start_time)device_num = <device_num> practice_intro = 1 endtime = ($practice_end_time)
	Change \{practice_audio_muted = 0}
	if ($current_speedfactor = 1.0)
		menu_audio_settings_update_band_volume \{vol = 7}
	else
		menu_audio_settings_update_band_volume \{vol = 0}
	endif
	SetSoundBussParams \{Crowd = {vol = -100.0}}
	spawnscriptnow \{practice_update}
	#"0x29a63aa1"
endscript

script practice_restart_song
	Change \{game_mode = training}
	Change \{current_transition = practice}
	restart_song practice_intro = 1 startTime = ($practice_start_time)endtime = ($practice_end_time)
	Change \{practice_audio_muted = 0}
	if ($current_speedfactor = 1.0)
		menu_audio_settings_update_band_volume \{vol = 7}
	else
		menu_audio_settings_update_band_volume \{vol = 0}
	endif
	SetSoundBussParams \{Crowd = {vol = -100.0}}
	spawnscriptnow \{practice_update}
endscript

script #"0x29a63aa1"
	printf \{"+++RESTORE SELECT KEY"}
	Change #"0x736a45df" = ($#"0xdf7ff31b")
	SetScreenElementProps \{id = root_window event_handlers = [{pad_select #"0xc5e43e95"}] replace_handlers}
endscript

script #"0xd0d74dce"
	printf \{"+++KILL SELECT KEY   "}
	Change #"0xdf7ff31b" = ($#"0x736a45df")
	SetScreenElementProps \{id = root_window event_handlers = [{pad_select null_script}] replace_handlers}
endscript

script practice_update
	begin
		practice_audio_filter
		GetSongTimeMs
		if (<time> > (($practice_end_time)+ ($Song_Win_Delay * 1000 - 100)))
			spawnscriptnow \{finish_practice_song}
		endif
		wait \{1 gameframes}
	repeat
endscript

script #"0xc5e43e95"
	Change #"0xdf7ff31b" = 1
	spawnscriptnow restart_gem_scroller params = {
		song_name = ($current_song)
		difficulty = ($current_difficulty)
		difficulty2 = ($current_difficulty2)
		startTime = ($current_starttime)
		device_num = <device_num>
		uselaststarttime
	}
endscript

script finish_practice_song
	killspawnedscript \{name = practice_update}
	ui_flow_manager_respond_to_action \{action = end_song}
	#"0xd0d74dce"
	gh3_start_pressed
endscript
practice_audio_muted = 0

script practice_audio_filter
	GetSongTimeMs
	if ((<time> > ($practice_start_time))& (<time> < ($practice_end_time)))
		if ($practice_audio_muted = 1)
			GetGlobalTags \{user_options}
			menu_audio_settings_update_guitar_volume vol = <guitar_volume>
			Change \{practice_audio_muted = 0}
		endif
	else
		if ($practice_audio_muted = 0)
			printf \{"Setting audio supposedly"}
			menu_audio_settings_update_guitar_volume \{vol = 0}
			Change \{practice_audio_muted = 1}
		endif
	endif
endscript

script shut_down_practice_mode
	killspawnedscript \{name = practice_update}
	GetGlobalTags \{user_options}
	menu_audio_settings_update_guitar_volume vol = <guitar_volume>
	menu_audio_settings_update_band_volume vol = <band_volume>
	menu_audio_settings_update_sfx_volume vol = <sfx_volume>
	SetSoundBussParams {Crowd = {vol = ($Default_BussSet.Crowd.vol)}}
endscript
practice_play_song_fs = {
	actions = [
		{
			action = pause_game
			flow_state = practice_pause_fs
		}
		{
			action = end_song
			flow_state = practice_newspaper_fs
		}
	]
}
practice_pause_fs = {
	create = create_pause_menu
	create_params = {
		for_practice = 1
	}
	Destroy = destroy_pause_menu
	actions = [
		{
			action = select_resume
			flow_state = practice_play_song_fs
		}
		{
			action = select_restart
			flow_state = practice_restart_warning_fs
		}
		{
			action = select_change_speed
			flow_state = practice_change_speed_fs
		}
		{
			action = select_options
			flow_state = practice_options_fs
		}
		{
			action = select_change_section
			flow_state = practice_change_section_quit_warning_fs
		}
		{
			action = select_new_song
			flow_state = practice_quit_warning_fs
		}
		{
			action = select_quit
			flow_state = practice_quit_warning_fs
		}
	]
}
practice_options_fs = {
	create = create_pause_menu
	create_params = {
		for_options = 1
	}
	Destroy = destroy_pause_menu
	actions = [
		{
			action = select_audio_settings
			flow_state = practice_audio_settings_fs
		}
		{
			action = select_calibrate_lag
			flow_state = practice_calibrate_lag_warning
		}
		{
			action = winport_select_calibrate_lag
			flow_state = winport_practice_calibrate_lag_warning
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
			flow_state = practice_lefty_flip_warning
		}
		{
			action = go_back
			flow_state = practice_pause_fs
		}
	]
}
practice_audio_settings_fs = {
	create = create_audio_settings_menu
	create_params = {
		popup = 1
	}
	Destroy = destroy_audio_settings_menu
	actions = [
		{
			action = continue
			flow_state = practice_pause_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
practice_lefty_flip_warning = {
	create = create_lefty_flip_warning_menu
	Destroy = destroy_lefty_flip_warning_menu
	actions = [
		{
			action = continue
			func = lefty_flip_func
			flow_state = practice_play_song_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
practice_calibrate_lag_warning = {
	create = create_calibrate_lag_warning_menu
	Destroy = destroy_calibrate_lag_warning_menu
	actions = [
		{
			action = continue
			flow_state = practice_calibrate_lag_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
winport_practice_calibrate_lag_warning = {
	create = winport_create_calibrate_lag_warning_menu
	Destroy = winport_destroy_calibrate_lag_warning_menu
	actions = [
		{
			action = continue
			flow_state = winport_practice_calibrate_lag_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
practice_calibrate_lag_fs = {
	create = create_calibrate_lag_menu
	Destroy = destroy_calibrate_lag_menu
	actions = [
		{
			action = continue
			flow_state = practice_calibrate_autosave_fs
		}
		{
			action = go_back
			func = practice_restart_song
			transition_screen = default_loading_screen
			flow_state = practice_play_song_fs
		}
	]
}
winport_practice_calibrate_lag_fs = {
	create = winport_create_calibrate_lag_menu
	Destroy = winport_destroy_calibrate_lag_menu
	actions = [
		{
			action = go_back
			func = practice_restart_song
			transition_screen = default_loading_screen
			flow_state = practice_play_song_fs
		}
	]
}
practice_calibrate_autosave_fs = {
	create = memcard_sequence_begin_autosave
	Destroy = memcard_sequence_cleanup_generic
	actions = [
		{
			action = memcard_sequence_save_success
			func = practice_restart_song
			transition_screen = default_loading_screen
			flow_state = practice_play_song_fs
		}
		{
			action = memcard_sequence_save_failed
			func = practice_restart_song
			transition_screen = default_loading_screen
			flow_state = practice_play_song_fs
		}
	]
}
practice_restart_warning_fs = {
	create = create_restart_warning_menu
	Destroy = destroy_restart_warning_menu
	actions = [
		{
			action = continue
			func = practice_restart_song
			transition_screen = default_loading_screen
			flow_state = practice_play_song_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
practice_quit_warning_fs = {
	create = create_quit_warning_menu
	Destroy = destroy_quit_warning_menu
	actions = [
		{
			action = continue
			func = ResetEngine
		}
		{
			action = go_back
			flow_state = practice_pause_fs
		}
	]
}
practice_change_speed_quit_warning_fs = {
	create = create_quit_warning_menu
	create_params = {
		option2_text = "CHANGE SPEED"
		menu_pos = (470.0, 475.0)
		bg_dims = (400.0, 80.0)
		no_joiners
	}
	Destroy = destroy_quit_warning_menu
	actions = [
		{
			action = continue
			flow_state = practice_change_speed_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
practice_change_section_quit_warning_fs = {
	create = create_quit_warning_menu
	create_params = {
		option2_text = "CHANGE SECTION"
		menu_pos = (445.0, 475.0)
		bg_dims = (500.0, 80.0)
		no_joiners
	}
	Destroy = destroy_quit_warning_menu
	actions = [
		{
			action = continue
			func = end_practice_song
			flow_state = practice_select_song_section_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
practice_new_song_quit_warning_fs = {
	create = create_quit_warning_menu
	create_params = {
		option2_text = "NEW SONG"
		menu_pos = (520.0, 475.0)
		bg_dims = (350.0, 80.0)
		no_joiners
	}
	Destroy = destroy_quit_warning_menu
	actions = [
		{
			action = continue
			func = ResetEngine
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}

script end_practice_song_slomo
	Change \{current_speedfactor = 1.0}
	setslomo \{$#"0x16d91bc1"}
	Change \{StructureName = PitchShiftSlow1 pitch = 1.0}
endscript

script end_practice_song
	printf \{"end_practice_song"}
	end_practice_song_slomo
	spawnscriptnow \{xenon_singleplayer_session_complete_uninit}
	kill_gem_scroller
endscript
practice_change_speed_fs = {
	create = create_choose_practice_speed_menu
	Destroy = destroy_choose_practice_speed_menu
	actions = [
		{
			action = continue
			func = practice_restart_song
			flow_state = practice_play_song_fs
		}
		{
			action = go_back
			flow_state = practice_pause_fs
		}
	]
}
practice_newspaper_fs = {
	create = create_newspaper_menu
	create_params = {
		for_practice = 1
	}
	Destroy = destroy_newspaper_menu
	actions = [
		{
			action = restart
			func = practice_restart_song
			transition_screen = default_loading_screen
			flow_state = practice_play_song_fs
		}
		{
			action = change_speed
			func = kill_gem_scroller
			flow_state = practice_select_speed_fs
		}
		{
			action = change_section
			func = end_practice_song
			flow_state = practice_select_song_section_fs
		}
		{
			action = new_song
			func = ResetEngine
		}
		{
			action = back_2_setlist
			func = quickplay_start_song
			transition_screen = default_loading_screen
			flow_state = quickplay_play_song_fs
		}
		{
			action = #"0xb7294ebb"
			func = ResetEngine
		}
		{
			action = exit
			func = ResetEngine
		}
	]
}
practice_end_fs = {
	create = create_practice_end_menu
	Destroy = destroy_practice_end_menu
	actions = [
		{
			action = restart
			func = practice_restart_song
			transition_screen = default_loading_screen
			flow_state = practice_play_song_fs
		}
		{
			action = change_speed
			func = kill_gem_scroller
			flow_state = practice_select_speed_fs
		}
		{
			action = change_section
			func = end_practice_song
			flow_state = practice_select_song_section_fs
		}
		{
			action = new_song
			func = ResetEngine
		}
		{
			action = exit
			func = ResetEngine
		}
	]
}

script where_do_we_go_from_practice
	switch ($came_to_practice_from)
		case main_menu
			if GotParam \{from_choose_practice_section}
				return \{flow_state = practice_select_difficulty_fs}
			elseif GotParam \{from_practice_tutorial_select}
				return \{flow_state = practice_select_mode_fs}
			else
				return \{flow_state = main_menu_fs}
			endif
		case career
			Change \{game_mode = p1_career}
			Change current_difficulty = ($came_to_practice_difficulty)
			progression_pop_current
			return \{flow_state = career_setlist_fs}
		case coop_career
			Change \{game_mode = p2_career}
			Change current_difficulty = ($came_to_practice_difficulty)
			Change current_difficulty2 = ($came_to_practice_difficulty2)
			progression_pop_current
			return \{flow_state = coop_career_setlist_fs}
		case quickplay
			Change \{game_mode = p1_quickplay}
			Change current_difficulty = ($came_to_practice_difficulty)
			return \{flow_state = quickplay_setlist_fs}
	endswitch
endscript
practice_tutorial_select_fs = {
	create = create_tutorial_select_menu
	Destroy = destroy_tutorial_select_menu
	actions = [
		{
			action = continue
			func = run_training_script
			flow_state = practice_play_tutorial_fs
			transition_right
		}
		{
			action = go_back
			flow_state_func = where_do_we_go_from_practice
			flow_state_func_params = {
				from_practice_tutorial_select
			}
			transition_left
		}
	]
}
practice_play_tutorial_fs = {
	actions = [
		{
			action = complete_tutorial
			flow_state = practice_tutorial_autosave_fs
		}
		{
			action = quit_tutorial
			flow_state = practice_tutorial_select_fs
			transition_left
		}
	]
}
practice_tutorial_autosave_fs = {
	create = memcard_sequence_begin_autosave
	Destroy = memcard_sequence_cleanup_generic
	actions = [
		{
			action = memcard_sequence_save_success
			flow_state = practice_tutorial_select_fs
		}
		{
			action = memcard_sequence_save_failed
			flow_state = practice_tutorial_select_fs
		}
	]
}