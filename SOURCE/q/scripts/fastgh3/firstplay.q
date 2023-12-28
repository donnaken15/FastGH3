
first_launch_fs = {
	create = create_first_launch_menu
	Destroy = destroy_first_launch_menu
	actions = [
		{
			action = select_auto
			flow_state = first_launch_auto_fs
		}
		{
			action = select_manual
			flow_state = bootup_sequence_fs
		}
	]
}
first_launch_auto_fs = {
	create = detect_controller_by_button
	create_params = { background }
	Destroy = stop_detecting_buttons
	create_params = { background }
	actions = [
		{
			action = continue
			flow_state_func = set_startup_controller
		}
	]
}

script create_first_launch_menu
	ReAcquireControllers
	Change \{primary_controller_assigned = 0}
	create_menu_backdrop \{texture = black}
	CreateScreenElement \{ Type = ContainerElement parent = root_window id = pab_container Pos = (0.0, 0.0) }
	CreateScreenElement \{ Type = SpriteElement parent = pab_container texture = FastGH3_logo just = [center center] Pos = (640.0, 330.0) Scale = 2 alpha = 0.2 }
	CreateScreenElement \{ Type = TextElement parent = pab_container font = fontgrid_title_gh3 just = [center center] Pos = (640.0, 140.0) Scale = 2 text = 'WELCOME!' rgba = [ 255 0 0 255 ] }
	CreateScreenElement \{ text = 'To ensure the perfect gameplay experience for you, we\'ll want to make sure you\'re able to get to playing right away without any issues. Due to the way this game handles currently connected controllers, it may interfere with how you prefer to launch this mod. To work around this, would you like to be prompted to press a button on any controller you want to play with upon starting a song or do you wish to assign a default controller to skip the inital prompt? You can return to this menu by setting AutoStart to -1 in the Player section of the settings.ini.' Type = TextBlockElement parent = pab_container font = text_a4 dims = (1330.0, 640.0) Pos = (640.0, 190.0) just = [center top] internal_just = [center top] shadow shadow_offs = (2.0, 2.0) shadow_rgba = [ 0 0 0 127 ] Scale = 0.64 allow_expansion }
	create_popup_warning_menu \{player_device = NULL no_background no_title options = [{func = firstplay_select_auto text = "AUTO START"}{func = firstplay_select_manual text = "MANUAL START"}]}
endscript
script destroy_first_launch_menu
	destroy_menu \{menu_id = pab_container}
	destroy_menu_backdrop
	destroy_popup_warning_menu
	killspawnedscript \{name = check_for_any_input}
endscript

script set_startup_controller
	FGH3Config \{sect='Player' 'AutoStart' set='1'}
	FormatText textname = value '%d' d = <device_num>
	FGH3Config sect='Player1' 'Device' set=<value>
	bootup_check_autologin <...>
	return flow_state = <flow_state>
endscript
script firstplay_select_auto
	ui_flow_manager_respond_to_action \{action = select_auto}
endscript
script firstplay_select_manual
	FGH3Config \{sect='Player' 'AutoStart' set='0'}
	ui_flow_manager_respond_to_action \{action = select_manual}
endscript

