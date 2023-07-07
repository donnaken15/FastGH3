
script winport_wait_for_device_press
	begin
		begin
			if NOT WinPortSioGetDevicePress
				break
			endif
			wait \{1 gameframe}
		repeat
		begin
			if WinPortSioGetDevicePress
				break
			endif
			wait \{1 gameframe}
		repeat
		if (<deviceNum> = -2)
			if GotParam \{backScript}
				<backScript>
				break
			endif
		else
			if GotParam \{bindable}
				if ((WinPortSioIsDirectInputGamepad deviceNum = <deviceNum>)|| (WinPortSioIsKeyboard deviceNum = <deviceNum>))
					if GotParam \{proceedScript}
						<proceedScript> deviceNum = <deviceNum>
					endif
					break
				endif
			else
				if GotParam \{proceedScript}
					<proceedScript> deviceNum = <deviceNum>
				endif
				break
			endif
		endif
	repeat
	return deviceNum = <deviceNum>
endscript

script winport_select_p1_controller
	ui_flow_manager_respond_to_action \{action = winport_select_p1_controller}
endscript

script winport_create_p1_controller_popup
	create_popup_warning_menu \{title = "Select Controller" textblock = {text = "Press any button on the controller to be used in single player mode and in the menus." dims = (800.0, 400.0) Scale = 0.55}no_background menu_pos = (640.0, 520.0) dialog_dims = (600.0, 80.0)}
	common_control_helpers \{back}
	spawnscriptnow \{winport_wait_for_device_press params = {backScript = winport_p1_controller_back proceedScript = winport_p1_controller_proceed}}
endscript

script winport_destroy_p1_controller_popup
	destroy_popup_warning_menu
	clean_up_user_control_helpers
endscript

script winport_p1_controller_back
	ui_flow_manager_respond_to_action \{action = go_back}
endscript

script winport_p1_controller_proceed
	WinPortSioSetDevice0 deviceNum = <deviceNum>
	ui_flow_manager_respond_to_action \{action = go_back}
endscript

script winport_select_bind_buttons
	deviceNum = 0
	begin
		if WinPortSioIsKeyboard deviceNum = <deviceNum>
			Change winport_bb_device_num = <deviceNum>
			break
		endif
		deviceNum = (<deviceNum> + 1)
	repeat 4
	ui_flow_manager_respond_to_action \{action = winport_select_bind_buttons}
endscript

script winport_create_bind_buttons_popup
	create_popup_warning_menu \{title = "Select Controller" textblock = {text = "Press any button on the controller you want to configure." dims = (800.0, 400.0) Scale = 0.55}no_background menu_pos = (640.0, 520.0) dialog_dims = (600.0, 80.0)}
	common_control_helpers \{back}
	spawnscriptnow \{winport_wait_for_device_press params = {bindable backScript = winport_bind_buttons_back proceedScript = winport_bind_buttons_proceed}}
endscript

script winport_destroy_bind_buttons_popup
	destroy_popup_warning_menu
	clean_up_user_control_helpers
endscript

script winport_bind_buttons_back
	ui_flow_manager_respond_to_action \{action = go_back}
endscript

script winport_bind_buttons_proceed
	if ((WinPortSioIsDirectInputGamepad deviceNum = <deviceNum>)|| (WinPortSioIsKeyboard deviceNum = <deviceNum>))
		Change winport_bb_device_num = <deviceNum>
		ui_flow_manager_respond_to_action \{action = proceed}
	else
		spawnscriptnow \{winport_wait_for_device_press params = {backScript = winport_bind_buttons_back proceedScript = winport_bind_buttons_proceed}}
	endif
endscript
cs_highlighter_positions = [
	(620.0, 178.0)
	(621.0, 212.0)
	(622.0, 246.0)
	(623.0, 279.0)
	(624.0, 313.0)
]
cs_is_popup = 0
cs_menu_font = fontgrid_title_gh3

script create_controller_settings_menu\{popup = 0}
	if IsWinPort
		if (<popup> = 1)
			kill_start_key_binding
		endif
	else
		kill_start_key_binding
	endif
	if NOT (<popup>)
		menu_pos = (638.0, 173.0)
	else
		menu_pos = (465.0, 310.0)
	endif
	CreateScreenElement \{Type = ContainerElement parent = root_window id = cs_container Pos = (0.0, 0.0) just = [left top]}
	if (<popup>)
		z = 100
		Change \{cs_is_popup = 1}
		new_menu scrollid = cs_scroll vmenuid = cs_vmenu menu_pos = <menu_pos> spacing = -10 exclusive_device = ($last_start_pressed_device)
		CreateScreenElement {
			Type = TextElement
			font = ($cs_menu_font)
			parent = cs_scroll
			Pos = (180.0, -30.0)
			Scale = 1.3
			text = "CONTROLLER SETTINGS"
			rgba = ($menu_unfocus_color)
			z_priority = <z>
		}
		create_pause_menu_frame x_scale = 1.3 z = (<z> - 10)
		text_params = {parent = cs_vmenu Type = TextElement font = ($cs_menu_font)rgba = ($menu_unfocus_color)z_priority = <z> Scale = (0.8999999761581421, 0.800000011920929)}
		<exclusive_params> = {exclusive_device = ($last_start_pressed_device)}
		CreateScreenElement {
			Type = SpriteElement
			parent = cs_container
			texture = menu_pause_frame_banner
			Pos = (640.0, 540.0)
			just = [center center]
			z_priority = (<z> + 100)
		}
		CreateScreenElement {
			Type = TextElement
			parent = <id>
			text = "PAUSED"
			font = text_a6
			Pos = (125.0, 53.0)
			rgba = [170 90 30 255]
			Scale = 0.8
		}
	else
		Change \{cs_is_popup = 0}
		new_menu scrollid = cs_scroll vmenuid = cs_vmenu menu_pos = <menu_pos> text_left
		set_focus_color \{rgba = [190 185 165 255]}
		set_unfocus_color \{rgba = [60 45 30 255]}
		create_menu_backdrop \{texture = Venue_BG}
		CreateScreenElement \{Type = SpriteElement parent = cs_container id = cs_light_overlay texture = Venue_Overlay Pos = (640.0, 360.0) dims = (1280.0, 720.0) just = [center center] z_priority = 99}
		displaySprite \{parent = cs_container tex = Options_Controller_Poster Pos = (135.0, 30.0) dims = (640.0, 620.0) rot_angle = -1.5 z = 5}
		displaySprite \{parent = cs_container tex = Options_Controller_Poster2 Pos = (525.0, 130.0) dims = (552.0, 266.0)}
		displaySprite \{parent = cs_container tex = tape_H_03 Pos = (610.0, 0.0) dims = (120.0, 60.0) z = 6 rot_angle = 60}
		displaySprite \{parent = cs_container tex = tape_H_03 rgba = [0 0 0 128] Pos = (608.0, 5.0) dims = (120.0, 60.0) z = 6 rot_angle = 60}
		displaySprite \{parent = cs_container tex = tape_H_04 Pos = (760.0, 106.0) dims = (140.0, 65.0) z = 4}
		displaySprite \{parent = cs_container tex = tape_H_04 rgba = [0 0 0 128] Pos = (763.0, 111.0) dims = (140.0, 65.0) z = 4}
		displaySprite \{parent = cs_container tex = Tape_V_01 Pos = (250.0, 360.0) dims = (80.0, 142.0) z = 6 flip_v rot_angle = -10}
		displaySprite \{parent = cs_container tex = Tape_V_01 rgba = [0 0 0 128] Pos = (255.0, 363.0) dims = (80.0, 142.0) z = 6 flip_v rot_angle = -10}
		displaySprite \{parent = cs_container tex = tape_H_02 Pos = (1090.0, 300.0) dims = (112.0, 54.0) z = 4 rot_angle = -80}
		displaySprite \{parent = cs_container tex = tape_H_02 rgba = [0 0 0 128] Pos = (1095.0, 305.0) dims = (112.0, 54.0) z = 4 rot_angle = -80}
		CreateScreenElement {
			Type = TextElement
			id = cs_controller_text
			parent = cs_container
			Pos = (465.0, 571.0)
			Scale = (0.6500000357627869, 0.800000011920929)
			text = "Controller"
			font = text_a6
			rgba = ($menu_unfocus_color)
			z_priority = 6
			rot_angle = -1.5
		}
		CreateScreenElement {
			Type = TextElement
			id = cs_options_text
			parent = cs_container
			Pos = (460.0, 293.0)
			Scale = (0.5, 0.4000000059604645)
			text = "Options"
			font = text_a6
			rgba = ($menu_unfocus_color)
			z_priority = 6
			rot_angle = -16
		}
		displaySprite \{parent = cs_container tex = options_controller_checkbg Pos = (945.0, 190.0) z = 4 flip_h rot_angle = -5 Scale = 0.7}
		displaySprite \{parent = cs_container id = cs_check_1 tex = options_controller_x Pos = (975.0, 197.0) z = 6 Scale = 0.7}
		displaySprite \{parent = cs_container tex = options_controller_checkbg Pos = (950.0, 236.0) z = 5 rot_angle = -5 Scale = 0.7}
		displaySprite \{parent = cs_container id = cs_check_2 tex = options_controller_x Pos = (970.0, 230.0) z = 6 Scale = 0.7}
		displaySprite {
			parent = cs_container
			id = cs_highlighter
			tex = options_controller_highlight
			Pos = ($cs_highlighter_positions [0])
			dims = (460.0, 58.0)
			z = 4
			rot_angle = 1
		}
		font = text_a6
		z = 5
		text_params = {parent = cs_vmenu Type = TextElement font = <font> Scale = 0.7 rgba = ($menu_unfocus_color)z_priority = <z> rot_angle = 1.5}
		<exclusive_params> = {exclusive_device = ($primary_controller)}
		Change \{user_control_pill_text_color = [0 0 0 255]}
		Change \{user_control_pill_color = [180 180 180 255]}
		common_control_helpers \{select back nav}
	endif
	if (<popup>)
		<p1_l_flip_text> = "P1 Lefty Flip: OFF"
		<p2_l_flip_text> = "P2 Lefty Flip: OFF"
	else
		<p1_l_flip_text> = "P1 Lefty Flip:"
		<p2_l_flip_text> = "P2 Lefty Flip:"
	endif
	CreateScreenElement {
		<text_params>
		text = <p1_l_flip_text>
		event_handlers = [
			{pad_choose controller_settings_menu_choose_lefty_flip_p1 params = {popup = <popup>}}
			{focus retail_menu_focus}
			{focus controller_settings_menu_highlighter params = {index = 0}}
			{unfocus retail_menu_unfocus}
		]
		id = lefty_flip_p1_se
		<exclusive_params>
	}
	if NOT (<popup>)
		GetScreenElementDims id = <id>
		if (<width> > 300)
			SetScreenElementProps id = <id> Scale = 1
			fit_text_in_rectangle id = <id> only_if_larger_x = 1 dims = ((300.0, 0.0) + <height> * (0.0, 1.0))
		endif
	endif
	CreateScreenElement {
		<text_params>
		text = <p2_l_flip_text>
		event_handlers = [
			{pad_choose controller_settings_menu_choose_lefty_flip_p2 params = {popup = <popup>}}
			{focus retail_menu_focus}
			{focus controller_settings_menu_highlighter params = {index = 1}}
			{unfocus retail_menu_unfocus}
		]
		id = lefty_flip_p2_se
		<exclusive_params>
	}
	if NOT (<popup>)
		GetScreenElementDims id = <id>
		if (<width> > 300)
			SetScreenElementProps id = <id> Scale = 1
			fit_text_in_rectangle id = <id> only_if_larger_x = 1 dims = ((300.0, 0.0) + <height> * (0.0, 1.0))
		endif
	endif
	controller_settings_menu_update_lefty_flip_p1_value lefty_flip_p1 = $p1_lefty
	controller_settings_menu_update_lefty_flip_p2_value lefty_flip_p2 = $p2_lefty
	CreateScreenElement {
		id = cs_calibrate_whammy_menu_item
		<text_params>
		text = "Calibrate Whammy"
		event_handlers = [
			{pad_choose controller_settings_menu_choose_whammy_bar params = {popup = <popup>}}
			{focus retail_menu_focus}
			{focus controller_settings_menu_highlighter params = {index = 2}}
			{unfocus retail_menu_unfocus}
		]
		<exclusive_params>
	}
	if NOT (<popup>)
		GetScreenElementDims id = <id>
		if (<width> > 300)
			SetScreenElementProps id = <id> Scale = 1
			fit_text_in_rectangle id = <id> only_if_larger_x = 1 dims = ((300.0, 0.0) + <height> * (0.0, 1.0))
		endif
	endif
	CreateScreenElement {
		id = cs_bind_buttons_menu_item
		<text_params>
		text = "Configure Keyboard"
		event_handlers = [
			{pad_choose winport_select_bind_buttons}
			{focus retail_menu_focus}
			{focus controller_settings_menu_highlighter params = {index = 3}}
			{unfocus retail_menu_unfocus}
		]
		<exclusive_params>
	}
	GetScreenElementDims id = <id>
	if (<width> > 300)
		SetScreenElementProps id = <id> Scale = 1
		fit_text_in_rectangle id = <id> only_if_larger_x = 1 dims = ((300.0, 0.0) + <height> * (0.0, 1.0))
	endif
	CreateScreenElement {
		id = cs_show_default_keyboard_layout_menu_item
		<text_params>
		text = "View Defaults"
		event_handlers = [
			{pad_choose controller_settings_show_default_keyboard_layout}
			{focus retail_menu_focus}
			{focus controller_settings_menu_highlighter params = {index = 4}}
			{unfocus retail_menu_unfocus}
		]
		<exclusive_params>
	}
	GetScreenElementDims id = <id>
	if (<width> > 300)
		SetScreenElementProps id = <id> Scale = 1
		fit_text_in_rectangle id = <id> only_if_larger_x = 1 dims = ((300.0, 0.0) + <height> * (0.0, 1.0))
	endif
	if NOT IsGuitarController controller = ($primary_controller)
		SetScreenElementProps \{id = cs_calibrate_whammy_menu_item rgba = [128 128 128 255] not_focusable}
	endif
	if WinPortSioIsKeyboard deviceNum = ($primary_controller)
		SetScreenElementProps \{id = cs_calibrate_whammy_menu_item rgba = [128 128 128 255] not_focusable}
	endif
endscript

script controller_settings_menu_highlighter\{index = 0}
	if NOT ($cs_is_popup)
		SetScreenElementProps id = cs_highlighter Pos = ($cs_highlighter_positions [<index>])
	endif
endscript

script destroy_controller_settings_menu
	if IsWinPort
		if ($cs_is_popup = 1)
			restore_start_key_binding
		endif
	else
		restore_start_key_binding
	endif
	destroy_pause_menu_frame
	destroy_menu \{menu_id = cs_container}
	destroy_menu \{menu_id = cs_scroll}
	clean_up_user_control_helpers
endscript

script controller_settings_menu_update_lefty_flip_p1_value\{lefty_flip_p1 = 0}
	if (<lefty_flip_p1>)
		if NOT ($cs_is_popup)
			SetScreenElementProps \{id = cs_check_1 texture = options_controller_check}
			Change \{pad_event_up_inversion = true}
		else
			SetScreenElementProps \{id = lefty_flip_p1_se text = "P1 Lefty Flip: ON"}
		endif
	else
		if NOT ($cs_is_popup)
			SetScreenElementProps \{id = cs_check_1 texture = options_controller_x}
			Change \{pad_event_up_inversion = FALSE}
		else
			SetScreenElementProps \{id = lefty_flip_p1_se text = "P1 Lefty Flip: OFF"}
		endif
	endif
endscript

script controller_settings_menu_update_lefty_flip_p2_value\{lefty_flip_p2 = 0}
	if (<lefty_flip_p2>)
		if NOT ($cs_is_popup)
			SetScreenElementProps \{id = cs_check_2 texture = options_controller_check}
		else
			SetScreenElementProps \{id = lefty_flip_p2_se text = "P2 Lefty Flip: ON"}
		endif
	else
		if NOT ($cs_is_popup)
			SetScreenElementProps \{id = cs_check_2 texture = options_controller_x}
		else
			SetScreenElementProps \{id = lefty_flip_p2_se text = "P2 Lefty Flip: OFF"}
		endif
	endif
endscript

script controller_settings_menu_choose_lefty_flip_p1
	if (<popup>)
		ui_flow_manager_respond_to_action \{action = select_lefty_flip create_params = {Player = 1}}
	else
		if ($p1_lefty = 1)
			change \{p1_lefty = 0}
			SoundEvent \{event = checkbox_sfx}
		else
			change \{p1_lefty = 1}
			SoundEvent \{event = checkbox_check_sfx}
		endif
		controller_settings_menu_update_lefty_flip_p1_value lefty_flip_p1 = <lefty_flip_p1>
	endif
endscript

script controller_settings_menu_choose_lefty_flip_p2
	if (<popup>)
		ui_flow_manager_respond_to_action \{action = select_lefty_flip create_params = {Player = 2}}
	else
		GetGlobalTags \{user_options}
		if ($p2_lefty = 1)
			change \{p2_lefty = 0}
			SoundEvent \{event = checkbox_sfx}
		else
			change \{p2_lefty = 1}
			SoundEvent \{event = checkbox_check_sfx}
		endif
		controller_settings_menu_update_lefty_flip_p2_value lefty_flip_p2 = <lefty_flip_p2>
	endif
endscript

script controller_settings_menu_choose_star_power
	ui_flow_manager_respond_to_action action = select_calibrate_star_power_trigger create_params = {controller = <device_num> popup = <popup>}
endscript

script controller_settings_menu_choose_whammy_bar
	ui_flow_manager_respond_to_action action = select_calibrate_whammy_bar create_params = {controller = <device_num> popup = <popup>}
endscript

script controller_settings_show_default_keyboard_layout
	ui_flow_manager_respond_to_action \{action = show_default_keyboard_layout create_params = {keyboard = 1}}
endscript
