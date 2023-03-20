main_menu_fs = {
	create = create_main_menu
	Destroy = destroy_main_menu
	actions = [
		{
			action = select_career
			flow_state_func = main_menu_career_flow_state_func
			transition_right
		}
		{
			action = select_coop_career
			flow_state = coop_career_select_controllers_fs
			transition_right
		}
		{
			action = select_quickplay
			flow_state = quickplay_select_difficulty_fs
			transition_right
		}
		{
			action = select_multiplayer
			flow_state = mp_select_controller_fs
			transition_right
		}
		{
			action = select_xbox_live
			flow_state = online_signin_fs
		}
		{
			action = select_winport_online
			flow_state = online_winport_start_connection_fs
		}
		{
			action = select_options
			flow_state = options_select_option_fs
			transition_right
		}
		{
			action = select_training
			flow_state = practice_select_mode_fs
			transition_right
		}
		{
			action = select_winport_exit
			flow_state = winport_confirm_exit_fs
			transition_left
		}
		{
			action = go_back
			flow_state = winport_confirm_exit_fs
			transition_left
		}
		{
			action = select_debug_menu
			flow_state = debug_menu_fs
		}
	]
}
winport_confirm_exit_fs = {
	create = winport_create_confirm_exit_popup
	Destroy = winport_destroy_confirm_exit_popup
	popup
	actions = [
		{
			action = continue
			func = ExitGameConfirmed
			use_last_flow_state
		}
		{
			action = go_back
			flow_state = main_menu_fs
			transition_right
		}
	]
}

script ExitGameConfirmed
	ResetEngine
	begin
		wait \{1.0 seconds}
	repeat
endscript

script main_menu_career_flow_state_func
	main_menu_get_any_band_names_exist
	if (<name_exists> = 0)
		return \{flow_state = career_enter_band_name_fs}
	else
		return \{flow_state = career_choose_band_fs}
	endif
endscript

script main_menu_get_any_band_names_exist
	band_index = 1
	begin
		get_band_game_mode_name
		FormatText checksumName = bandname_id 'band%i_info_%g' i = <band_index> g = <game_mode_name>
		GetGlobalTags <bandname_id> param = name
		if NOT (<name> = "")
			return \{name_exists = 1}
		endif
		<band_index> = (<band_index> + 1)
	repeat ($num_career_bands)
	return \{name_exists = 0}
endscript
debug_menu_fs = {
	create = create_debugging_menu
	Destroy = destroy_all_debug_menus
	actions = [
		{
			action = select_resume
			flow_state = career_play_song_fs
		}
		{
			action = go_back
			flow_state = main_menu_fs
			use_last_flow_state
		}
		{
			action = set_p1_career
			flow_state = career_play_song_fs
		}
		{
			action = set_p2_career
			flow_state = coop_career_play_song_fs
		}
		{
			action = set_p1_quickplay
			flow_state = quickplay_play_song_fs
		}
		{
			action = set_p2_general
			flow_state = mp_faceoff_play_song_fs
		}
		{
			action = set_p1_training
			flow_state = practice_play_song_fs
		}
	]
}
controller_disconnect_fs = {
	create = create_controller_disconnect_menu
	Destroy = destroy_controller_disconnect_menu
	actions = [
		{
			action = select_resume
			use_last_flow_state
		}
		{
			action = select_quit
			flow_state_func = controller_disconnect_quit_warning_decider
		}
	]
}

script controller_disconnect_quit_warning_decider
	fs = None
	switch ($game_mode)
		case p1_career
			<fs> = career_quit_warning_fs
		case p2_career
			<fs> = coop_career_quit_warning_fs
		case p1_quickplay
			<fs> = quickplay_quit_warning_fs
		case p2_faceoff
		case p2_pro_faceoff
		case p2_battle
			<fs> = mp_faceoff_quit_warning_fs
	endswitch
	if ($end_credits = 1)
		Change \{end_credits = 0}
		Progression_EndCredits_Done
		career_song_ended_select_quit
		return \{flow_state = main_menu_fs}
	endif
	return flow_state = <fs>
endscript
