
script create_restart_warning_menu\{Player = 1}
	disable_pause
	player_device = ($last_start_pressed_device)
	create_popup_warning_menu {
		textblock = {
			text = "You will lose all unsaved progress if you restart. Are you sure you want to restart this song?"
			dims = (600.0, 400.0)
			Scale = 0.6
		}
		player_device = <player_device>
		no_background
		menu_pos = (640.0, 480.0)
		dialog_dims = (600.0, 80.0)
		options = [
			{
				func = menu_flow_go_back
				text = "CANCEL"
			}
			{
				func = restart_warning_select_restart
				text = "RESTART"
			}
		]
	}
endscript

script destroy_restart_warning_menu
	destroy_popup_warning_menu
endscript

script restart_warning_select_restart\{Player = 1}
	GH3_SFX_fail_song_stop_sounds
	ui_flow_manager_respond_to_action action = continue create_params = {Player = <Player>}
endscript
