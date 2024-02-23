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
	ExtendCrc \{$current_song '_song_rhythm_easy' out=song_rhythm_array_id}
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
	ExtendCrc \{$current_song '_song_rhythm_easy' out=song_rhythm_array_id}
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
practice_last_mode = p1_quickplay
script return_from_practice
	restore_start_key_binding
	change game_mode = ($practice_last_mode)
	return \{flow_state = enter_mode_fs}
endscript
script enter_mode
	printstruct <...>
	action = quickplay
	// dont know if i can have a fallback action
	switch $game_mode
		case p1_quickplay
			action = quickplay
		case p1_career
			action = career
		case p2_battle
			action = career
		case p2_faceoff
		case p2_pro_faceoff
			action = faceoff
		case p2_coop
			action = coop
		case p2_career
			action = coop
		case training
			action = practice
	endswitch
	spawnscriptnow ui_flow_manager_respond_to_action params = {
		action = <action>
		play_sound = 0
		device_num = ($primary_controller)
	}
endscript
enter_mode_fs = {
	create = enter_mode
	Destroy = EmptyScript
	actions = [
		{
			$quickplay_play_song_action
			action = quickplay
		}
		{
			action = career
			transition_screen = default_loading_screen
			func = start_song
			flow_state = career_play_song_fs
		}
		{
			action = coop
			func = start_song
			transition_screen = default_loading_screen
			flow_state = coop_career_play_song_fs
		}
		{
			action = faceoff
			func = start_song
			transition_screen = default_loading_screen
			flow_state = mp_faceoff_play_song_fs
		}
		{
			action = practice
			func = practice_start_song
			transition_screen = default_loading_screen
			flow_state = practice_play_song_fs
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
			func = return_from_practice
			flow_state = enter_mode_fs
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

practice_pressed_select_key = 0
practice_pressed_too_fast = 0

script practice_start_song\{device_num = 0}
	Change \{game_mode = training}
	Change \{current_transition = practice}
	start_song startTime = ($practice_start_time)device_num = <device_num> practice_intro = 1 endtime = ($practice_end_time)
	//Change \{practice_audio_muted = 0}
	/*if ($current_speedfactor = 1.0)
		menu_audio_settings_update_band_volume \{vol = 7}
	else
		menu_audio_settings_update_band_volume \{vol = 0}
	endif*///
	//SetSoundBussParams \{Crowd = {vol = -100.0}}
	spawnscriptnow \{practice_update}
	practice_restore_select_key_binding
endscript

script practice_manual_restart
	Change disable_intro = ($disable_intro_originalsetting)
	practice_restart_song
endscript

script practice_restart_song
	Change \{game_mode = training}
	Change \{current_transition = practice}
	restart_song practice_intro = 1 startTime = ($practice_start_time)endtime = ($practice_end_time)
	//Change \{practice_audio_muted = 0}
	/*if ($current_speedfactor = 1.0)
		menu_audio_settings_update_band_volume \{vol = 7}
	else
		menu_audio_settings_update_band_volume \{vol = 0}
	endif*///
	//SetSoundBussParams \{Crowd = {vol = -100.0}}
	spawnscriptnow \{practice_select_wait}
	spawnscriptnow \{practice_update}
endscript

script practice_select_wait
	Wait \{5 gameframes}
	change \{practice_pressed_too_fast = 0}
endscript

script practice_restore_select_key_binding
	printf \{"+++RESTORE SELECT KEY"}
	Change disable_intro_originalsetting = ($disable_intro)
	SetScreenElementProps \{id = root_window event_handlers = [{pad_select practice_instarestart}] replace_handlers}
endscript

script practice_kill_select_key_binding
	printf \{"+++KILL SELECT KEY"}
	Change disable_intro = ($disable_intro_originalsetting)
	SetScreenElementProps \{id = root_window event_handlers = [{pad_select null_script}] replace_handlers}
endscript

script practice_update
	begin
		if ($practice_pressed_too_fast = 0)
			device_num = ($player1_device)
			if WinPortSioIsKeyboard deviceNum = <device_num>
				WinPortSioGetControlBinding deviceNum = <device_num> actionNum = 5
				target_key = <controlNum>
				WinPortSioGetControlPress deviceNum = <device_num> actionNum = 0
				if (<controlNum> = <target_key>)
					if ($practice_pressed_select_key = 0)
						change \{practice_pressed_select_key = 1}
						change \{practice_pressed_too_fast = 1}
						spawnscriptnow \{practice_instarestart}
					endif
				else
					change \{practice_pressed_select_key = 0}
				endif
			endif
		endif
		practice_audio_filter
		GetSongTimeMs
		if ($practice_loop_mode = 0)
			if (<time> > ($practice_end_time + ($Song_Win_Delay * 1000 - 100)))
				spawnscriptnow \{finish_practice_song}
			endif
		else
			if (<time> > ($practice_end_time + 300))
				spawnscriptnow \{practice_instarestart}
			endif
		endif
		wait \{1 gameframes}
	repeat
endscript

script practice_instarestart
	Change disable_intro = 1
	// TODO: don't use global variable to reset disable_intro back to
	/*spawnscriptnow restart_gem_scroller params = {
		song_name = ($current_song)
		difficulty = ($current_difficulty)
		difficulty2 = ($current_difficulty2)
		startTime = ($practice_start_time)
		endtime = ($practice_end_time)
		device_num = <device_num>
		uselaststarttime
		//nointro
	}*///
	practice_restart_song
endscript

script finish_practice_song
	killspawnedscript \{name = practice_update}
	ui_flow_manager_respond_to_action \{action = end_song}
	practice_kill_select_key_binding
	gh3_start_pressed
endscript
practice_audio_muted = 0

script practice_audio_filter
	return
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
	//GetGlobalTags \{user_options}
	//menu_audio_settings_update_guitar_volume vol = <guitar_volume>
	//menu_audio_settings_update_band_volume vol = <band_volume>
	//menu_audio_settings_update_sfx_volume vol = <sfx_volume>
	//SetSoundBussParams {Crowd = {vol = ($Default_BussSet.Crowd.vol)}}
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
		practice
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
			action = select_return
			flow_state = practice_return_warning_fs
		}
		{
			action = select_loop_menu_3a
			flow_state = practice_loop_error_fs
		}
		{
			action = select_loop_menu_3b
			flow_state = practice_ab_restart_fs
		}
		{
			action = select_extras
			flow_state = extras_fs
		}
		{
			action = select_modes
			flow_state = modes_fs
			func = reset_mode_setup
		}
		{
			action = select_options
			flow_state = practice_options_fs
		}
		{
			action = select_change_speed
			flow_state = practice_change_speed_fs
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
		{
			action = select_debug_menu
			flow_state = debug_menu_fs
		}
	]
}
practice_options_fs = {
	create = create_pause_menu
	create_params = {
		submenu = options
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
practice_return_warning_fs = {
	create = create_quit_warning_menu
	create_params = {
		option2_text = "RETURN TO GAME"
		menu_pos = (470.0, 475.0)
		bg_dims = (400.0, 80.0)
		no_joiners
	}
	Destroy = destroy_quit_warning_menu
	actions = [
		{
			action = continue
			func = return_from_practice
			flow_state = enter_mode_fs
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
	setslomo \{$current_speedfactor}
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
			func = return_from_practice
			flow_state = enter_mode_fs
			transition_screen = default_loading_screen
		}
		{
			action = back_2_setlist2
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
			func = practice_manual_restart
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
			//progression_pop_current
			return \{flow_state = career_setlist_fs}
		case coop_career
			Change \{game_mode = p2_career}
			Change current_difficulty = ($came_to_practice_difficulty)
			Change current_difficulty2 = ($came_to_practice_difficulty2)
			//progression_pop_current
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
