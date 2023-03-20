lefty_flip_warning_menu_font = fontgrid_title_gh3

script create_lefty_flip_warning_menu
	disable_pause
	player_device = ($last_start_pressed_device)
	create_popup_warning_menu {
		textblock = {
			text = "To change the lefty flip setting, this song must be restarted. You will lose all unsaved progress if you restart. Are you sure you want to continue?"
			dims = (800.0, 400.0)
			Scale = 0.55
		}
		player_device = <player_device>
		no_background
		menu_pos = (640.0, 520.0)
		dialog_dims = (600.0, 80.0)
		options = [
			{
				func = menu_flow_go_back
				text = "CANCEL"
			}
			{
				func = {menu_lefty_flip_warning_select_yes params = {Player = <Player>}}
				text = "RESTART"
			}
		]
	}
endscript

script destroy_lefty_flip_warning_menu
	destroy_popup_warning_menu
endscript

script menu_lefty_flip_warning_select_yes
	GetGlobalTags \{user_options}
	if (<Player> = 1)
		if (<lefty_flip_p1> = 0)
			<lefty_flip_p1> = 1
		else
			<lefty_flip_p1> = 0
		endif
		SetGlobalTags user_options params = {lefty_flip_p1 = <lefty_flip_p1>}
	else
		if (<lefty_flip_p2> = 0)
			<lefty_flip_p2> = 1
		else
			<lefty_flip_p2> = 0
		endif
		SetGlobalTags user_options params = {lefty_flip_p2 = <lefty_flip_p2>}
	endif
	GH3_SFX_fail_song_stop_sounds
	ui_flow_manager_respond_to_action \{action = continue}
endscript
