
script create_quit_warning_menu\{Player = 1 option1_text = "CANCEL" option2_text = "QUIT"}
	disable_pause
	player_device = ($last_start_pressed_device)
	create_popup_warning_menu {
		textblock = {
			text = "You will lose all unsaved progress if you quit. Are you sure you want to quit this song?"
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
				text = <option1_text>
			}
			{
				func = quit_warning_select_quit
				text = <option2_text>
			}
		]
	}
endscript

script destroy_quit_warning_menu
	destroy_popup_warning_menu
endscript

script quit_warning_select_quit\{Player = 1}
	GH3_SFX_fail_song_stop_sounds
	ui_flow_manager_respond_to_action action = continue create_params = {Player = <Player>}
endscript
