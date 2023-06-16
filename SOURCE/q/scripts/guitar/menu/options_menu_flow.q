options_select_option_fs = {
	create = create_options_menu
	Destroy = destroy_options_menu
	actions = [
		{
			action = select_audio_settings
			flow_state = options_audio_settings_fs
			transition_right
		}
		{
			action = select_gfx_settings
			flow_state = options_gfx_settings_fs
			transition_right
		}
		{
			action = select_calibrate_lag
			flow_state = options_calibrate_lag_fs
			transition_right
		}
		{
			action = winport_select_calibrate_lag
			flow_state = winport_options_calibrate_lag_fs
			transition_right
		}
		{
			action = select_controller_settings
			flow_state = options_controller_settings_fs
			transition_right
		}
		{
			action = select_data_settings
			flow_state = options_data_settings_fs
			transition_right
		}
		{
			action = select_credits
			flow_state = options_credits_fs
			transition_right
		}
		{
			action = select_top_rockers
			func = options_prepare_for_top_rockers
			flow_state = options_top_rockers_difficulty_select_fs
			transition_right
		}
		{
			action = select_cheats
			flow_state = options_cheats_fs
			transition_right
		}
		{
			action = go_back
			flow_state = main_menu_fs
			transition_left
		}
	]
}
options_audio_settings_fs = {
	create = create_audio_settings_menu
	Destroy = destroy_audio_settings_menu
	actions = [
		{
			action = go_back
			flow_state = options_select_option_fs
			transition_left
		}
	]
}
options_gfx_settings_fs = {
	create = winport_create_gfx_settings_menu
	Destroy = winport_destroy_gfx_settings_menu
	actions = [
		{
			action = go_back
			flow_state = options_select_option_fs
			transition_left
		}
		{
			action = need_restart
			flow_state = options_gfx_settings_restart_popup_fs
			transition_left
		}
	]
}
options_gfx_settings_restart_popup_fs = {
	create = winport_create_gfx_settings_restart_popup_menu
	Destroy = winport_destroy_gfx_settings_restart_popup_menu
	actions = [
		{
			action = continue
			flow_state = options_select_option_fs
			transition_left
		}
	]
}
options_controller_settings_fs = {
	create = create_controller_settings_menu
	Destroy = destroy_controller_settings_menu
	actions = [
		{
			action = select_calibrate_whammy_bar
			flow_state = calibrate_whammy_bar_fs
			transition_right
		}
		{
			action = select_calibrate_star_power_trigger
			flow_state = calibrate_star_power_trigger_fs
			transition_right
		}
		{
			action = winport_select_p1_controller
			flow_state = winport_p1_controller_fs
			transition_right
		}
		{
			action = winport_select_bind_buttons
			flow_state = winport_bind_buttons_fs
			transition_right
		}
		{
			action = show_default_keyboard_layout
			flow_state = options_default_keyboard_layout_fs
			transition_right
		}
		{
			action = go_back
			flow_state = options_select_option_fs
			transition_left
		}
	]
}
options_default_keyboard_layout_fs = {
	create = create_using_guitar_controller_menu
	create_params = {
		keyboard = 1
	}
	Destroy = destroy_using_guitar_controller_menu
	actions = [
		{
			action = continue
			flow_state = options_controller_settings_fs
			transition_left
		}
	]
}
winport_p1_controller_fs = {
	create = winport_create_p1_controller_popup
	Destroy = winport_destroy_p1_controller_popup
	actions = [
		{
			action = go_back
			use_last_flow_state
			transition_left
		}
	]
}
winport_bind_buttons_controller_fs = {
	create = winport_create_bind_buttons_popup
	Destroy = winport_destroy_bind_buttons_popup
	actions = [
		{
			action = proceed
			flow_state = winport_bind_buttons_fs
			transition_right
		}
		{
			action = go_back
			use_last_flow_state
			transition_left
		}
	]
}
winport_bind_buttons_fs = {
	create = winport_create_bind_buttons
	Destroy = winport_destroy_bind_buttons
	actions = [
		{
			action = go_back
			flow_state = options_controller_settings_fs
			transition_left
		}
	]
}
calibrate_whammy_bar_fs = {
	create = create_whammy_bar_calibration_menu
	Destroy = destroy_whammy_bar_calibration_menu
	actions = [
		{
			action = go_back
			use_last_flow_state
			transition_left
		}
	]
}
calibrate_star_power_trigger_fs = {
	create = create_star_power_trigger_calibration_menu
	Destroy = destroy_star_power_trigger_calibration_menu
	actions = [
		{
			action = go_back
			use_last_flow_state
			transition_left
		}
	]
}
options_autosave_fs = {
	create = memcard_sequence_begin_autosave
	Destroy = memcard_sequence_cleanup_generic
	actions = [
		{
			action = memcard_sequence_save_success
			flow_state = options_select_option_fs
			transition_left
		}
		{
			action = memcard_sequence_save_failed
			flow_state = options_select_option_fs
			transition_left
		}
	]
}
options_calibrate_lag_fs = {
	create = create_calibrate_lag_menu
	create_params = {
		from_in_game = 0
	}
	Destroy = destroy_calibrate_lag_menu
	actions = [
		{
			action = continue
			flow_state = options_autosave_fs
		}
		{
			action = go_back
			flow_state = options_select_option_fs
			transition_left
		}
	]
}
winport_options_calibrate_lag_fs = {
	create = winport_create_calibrate_lag_menu
	create_params = {
		from_in_game = 0
	}
	Destroy = winport_destroy_calibrate_lag_menu
	actions = [
		{
			action = go_back
			flow_state = options_select_option_fs
			transition_left
		}
	]
}
options_choose_band_fs = {
	create = create_choose_band_menu
	Destroy = destroy_choose_band_menu
	actions = [
		{
			action = select_new_band
			flow_state = options_enter_band_name_fs
			transition_right
		}
		{
			action = select_existing_band
			flow_state = options_manage_band_fs
			transition_right
		}
		{
			action = go_back
			flow_state = options_select_option_fs
			transition_left
		}
	]
}
options_manage_band_fs = {
	create = create_manage_band_menu
	Destroy = destroy_manage_band_menu
	actions = [
		{
			action = select_rename_band
			flow_state = options_enter_band_name_for_manage_band_fs
			transition_right
		}
		{
			action = select_delete_band
			flow_state = options_confirm_band_delete_fs
			transition_right
		}
		{
			action = go_back
			flow_state = options_choose_band_fs
			transition_left
		}
	]
}
options_enter_band_name_for_manage_band_fs = {
	create = create_enter_band_name_menu
	Destroy = destroy_enter_band_name_menu
	actions = [
		{
			action = enter_band_name
			flow_state = options_manage_band_fs
			transition_right
		}
		{
			action = go_back
			flow_state = options_manage_band_fs
			transition_left
		}
		{
			action = enter_band_name_for_manage_band
			flow_state = options_manage_band_fs
			transition_right
		}
	]
}
options_confirm_band_delete_fs = {
	create = create_confirm_band_delete_menu
	Destroy = destroy_confirm_band_delete_menu
	popup
	actions = [
		{
			action = continue
			flow_state = options_choose_band_fs
			transition_right
		}
		{
			action = go_back
			flow_state = options_manage_band_fs
			transition_left
		}
	]
}
options_data_settings_fs = {
	create = create_data_settings_menu
	Destroy = destroy_data_settings_menu
	actions = [
		{
			action = select_save_game
			flow_state = options_save_fs
		}
		{
			action = select_load_game
			flow_state = options_load_fs
		}
		{
			action = go_back
			flow_state = options_select_option_fs
			transition_left
		}
	]
}
options_login_settings_fs = {
	create = create_login_settings_menu
	Destroy = destroy_login_settings_menu
	actions = [
		{
			action = go_back
			flow_state = options_select_option_fs
			transition_left
		}
	]
}
options_save_fs = {
	create = memcard_sequence_begin_save
	Destroy = memcard_sequence_cleanup_generic
	actions = [
		{
			action = memcard_sequence_save_success
			flow_state = options_data_settings_fs
		}
		{
			action = memcard_sequence_save_failed
			flow_state = options_data_settings_fs
		}
	]
}
options_load_fs = {
	create = memcard_sequence_begin_load
	Destroy = memcard_sequence_cleanup_generic
	actions = [
		{
			action = memcard_sequence_load_success
			flow_state = options_data_settings_fs
		}
		{
			action = memcard_sequence_load_failed
			flow_state = options_data_settings_fs
		}
	]
}
options_bonus_videos_fs = {
	create = create_bonus_videos_menu
	Destroy = destroy_bonus_videos_menu
	actions = [
		{
			action = continue
			flow_state = options_video_play_state_fs
			transition_right
		}
		{
			action = select_credits
			flow_state = options_credits_fs
		}
		{
			action = go_back
			flow_state = options_select_option_fs
			transition_left
		}
	]
}
options_video_play_state_fs = {
	create = on_options_video_play
	Destroy = end_options_video_play
	actions = [
		{
			action = continue
			flow_state = options_bonus_videos_fs
		}
		{
			action = go_back
			flow_state = options_bonus_videos_fs
		}
	]
}
options_credits_fs = {
	create = create_credits_menu
	Destroy = destroy_credits_menu
	actions = [
		{
			action = continue
			flow_state = options_bonus_videos_fs
		}
		{
			action = go_back
			flow_state = options_bonus_videos_fs
		}
	]
}

script options_prepare_for_top_rockers
	Change \{game_mode = p1_quickplay}
endscript
options_top_rockers_difficulty_select_fs = {
	create = create_select_difficulty_menu
	Destroy = destroy_select_difficulty_menu
	actions = [
		{
			action = continue
			flow_state = options_toprockers_setlist_fs
			transition_right
		}
		{
			action = go_back
			flow_state = options_select_option_fs
			transition_left
		}
	]
}
options_toprockers_setlist_fs = {
	create = create_setlist_menu
	Destroy = destroy_setlist_menu
	actions = [
		{
			action = continue
			flow_state = options_toprockers_fs
			transition_right
		}
		{
			action = go_back
			flow_state = options_top_rockers_difficulty_select_fs
			transition_left
		}
	]
}
options_toprockers_fs = {
	create = create_top_rockers_menu
	create_params = {
		for_options = 1
	}
	Destroy = destroy_top_rockers_menu
	actions = [
		{
			action = continue
			flow_state = options_toprockers_setlist_fs
			transition_right
		}
	]
}
options_cheats_fs = {
	create = create_cheats_menu
	Destroy = destroy_cheats_menu
	actions = [
		{
			action = continue
			flow_state = options_select_option_fs
			transition_right
		}
		{
			action = enter_new_cheat
			flow_state = options_enter_new_cheat_fs
		}
		{
			action = go_back
			flow_state = options_select_option_fs
			transition_left
		}
	]
}
options_enter_new_cheat_fs = {
	create = cheats_zoomin_guitar
	Destroy = cheats_zoomout_guitar
	actions = [
		{
			action = new_cheat_finished
			flow_state = options_cheats_fs
		}
	]
}
options_choose_band_for_store_fs = {
	create = create_choose_band_menu
	Destroy = destroy_choose_band_menu
	actions = [
		{
			action = select_new_band
			flow_state = options_enter_band_name_fs
			transition_right
		}
		{
			action = select_existing_band
			func = set_store_came_from_options
			flow_state = store_fs
		}
		{
			action = go_back
			flow_state = options_select_option_fs
			transition_left
		}
	]
}
options_for_manage_band = 0

script set_for_manage_band
	Change \{options_for_manage_band = 1}
endscript

script set_store_came_from_options
	Change \{game_mode = p1_career}
	//progression_pop_current
	Change \{store_came_from = options}
endscript
store_autosave_required = 0

script store_maybe_autosave
	if ($store_autosave_required = 1)
		Change \{store_autosave_required = 0}
		return \{flow_state = store_autosave_fs}
	else
		go_back_to_where_you_came_from
		return flow_state = <flow_state>
	endif
endscript
store_autosave_fs = {
	create = memcard_sequence_begin_autosave
	Destroy = memcard_sequence_cleanup_generic
	actions = [
		{
			action = memcard_sequence_save_success
			flow_state_func = go_back_to_where_you_came_from
		}
		{
			action = memcard_sequence_save_failed
			flow_state_func = go_back_to_where_you_came_from
		}
	]
}
store_came_from = options

script go_back_to_where_you_came_from
	switch ($store_came_from)
		case options
			destroy_bg_viewport
			progression_push_current
			return \{flow_state = options_choose_band_for_store_fs}
		case p1_career
			return \{flow_state = career_character_hub_fs}
		case p2_career
			return \{flow_state = coop_career_split_off_flow_for_character_hub_fs}
		case p2_faceoff
			return \{flow_state = mp_faceoff_split_off_flow_for_character_hub_fs}
	endswitch
endscript
store_songs_fs = {
	create = create_store_songs_menu
	Destroy = destroy_store_songs_menu
	actions = [
		{
			action = go_back
			flow_state = store_fs
		}
	]
}
store_guitars_fs = {
	create = create_store_guitars_menu
	Destroy = destroy_store_guitars_menu
	actions = [
		{
			action = go_back
			flow_state = store_fs
		}
	]
}
store_finishes_fs = {
	create = create_store_guitar_finishes_menu
	Destroy = destroy_store_guitar_finishes_menu
	actions = [
		{
			action = go_back
			flow_state = store_fs
		}
	]
}
store_characters_fs = {
	create = create_store_characters_menu
	Destroy = destroy_store_characters_menu
	actions = [
		{
			action = go_back
			flow_state = store_fs
		}
	]
}
store_outfits_fs = {
	create = create_store_outfits_menu
	Destroy = destroy_store_outfits_menu
	actions = [
		{
			action = go_back
			flow_state = store_fs
		}
	]
}
store_styles_fs = {
	create = create_store_styles_menu
	Destroy = destroy_store_styles_menu
	actions = [
		{
			action = go_back
			flow_state = store_fs
		}
	]
}
store_videos_fs = {
	create = create_store_videos_menu
	Destroy = destroy_store_videos_menu
	actions = [
		{
			action = go_back
			flow_state = store_fs
		}
	]
}
store_downloads_fs = {
	create = create_download_scan_menu
	Destroy = destroy_download_scan_menu
	actions = [
		{
			action = continue
			flow_state = store_fs
		}
	]
}
