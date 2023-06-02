
script create_select_private_match_menu\{menu_title = "CREATE MATCH" menu_subtitle = "PRIVATE MATCH" menu_id = create_private_match_menu vmenu_id = create_private_match_vmenu}
	CreateScreenElement \{Type = ContainerElement parent = root_window id = online_menu_ui_container Pos = (0.0, 0.0)}
	CreateScreenElement {
		Type = VScrollingMenu
		parent = online_menu_ui_container
		id = <menu_id>
		just = [center top]
		dims = (256.0, 350.0)
		Pos = (($online_general_menu_pos)+ (0.0, 182.0))
		z_priority = 1
	}
	CreateScreenElement {
		Type = VMenu
		parent = <menu_id>
		id = <vmenu_id>
		Pos = ((128.0, 0.0) + (-8.0, 0.0))
		just = [center top]
		internal_just = [center center]
		dims = (256.0, 350.0)
		padding_scale = 1.5
		event_handlers = [
			{pad_back ui_flow_manager_respond_to_action params = {action = go_back}}
			{pad_back generic_menu_pad_back_sound}
			{pad_up generic_menu_up_or_down_sound params = {up}}
			{pad_down generic_menu_up_or_down_sound params = {down}}
		]
		exclusive_device = ($primary_controller)
	}
	create_menu_backdrop \{texture = #"0x4fb4b5e9"}
	displaySprite id = #"0xf3ed3382" parent = online_menu_ui_container tex = #"0xf3ed3382" Pos = (($online_general_menu_pos)+ (0.0, -48.0))dims = (192.0, 96.0) just = [center top] z = 3
	displaySprite id = online_menu_box_top parent = online_menu_ui_container tex = #"0xb532229b" rgba = ($online_medium_blue)Pos = ($online_general_menu_pos)dims = (288.0, 64.0) just = [center top] z = 2
	displaySprite id = online_menu_box_top_fill parent = online_menu_ui_container tex = #"0xecab1ed6" rgba = [0 0 0 200] Pos = ($online_general_menu_pos)dims = (288.0, 64.0) just = [center top] z = 2
	displaySprite id = online_menu_box_body parent = online_menu_ui_container tex = #"0x721db38e" rgba = ($online_medium_blue)Pos = (($online_general_menu_pos)+ (0.0, 64.0))dims = (288.0, 432.0) just = [center top] z = 2 flip_h
	displaySprite id = online_menu_box_body_fill parent = online_menu_ui_container tex = #"0xae017b97" rgba = [0 0 0 200] Pos = (($online_general_menu_pos)+ (0.0, 64.0))dims = (288.0, 432.0) just = [center top] z = 2 flip_h
	displaySprite id = online_menu_box_bottom parent = online_menu_ui_container tex = #"0xb532229b" rgba = ($online_medium_blue)Pos = (($online_general_menu_pos)+ (0.0, 496.0))dims = (288.0, 64.0) just = [center top] z = 2 flip_h
	displaySprite id = online_menu_box_bottom_fill parent = online_menu_ui_container tex = #"0xecab1ed6" rgba = [0 0 0 200] Pos = (($online_general_menu_pos)+ (0.0, 496.0))dims = (288.0, 64.0) just = [center top] z = 2 flip_h
	displaySprite id = online_title_bar parent = online_menu_ui_container tex = #"0xec880166" rgba = ($online_light_blue)Pos = (($online_general_menu_pos)+ (0.0, 128.0))dims = (288.0, 128.0) just = [center center] z = 3
	displaySprite id = online_highlight parent = online_menu_ui_container tex = white rgba = ($online_light_blue)Pos = ((($online_general_menu_hi_lite_ypos [0])* (0.0, 1.0))+ (632.0, 0.0))dims = (288.0, 40.0) just = [center top] z = 3
	displaySprite id = online_bookend1 parent = online_menu_ui_container tex = character_hub_hilite_bookend rgba = ($online_light_blue)Pos = ((($online_general_menu_hi_lite_ypos [0])* (0.0, 1.0))+ (502.0, 20.0))dims = (40.0, 35.0) just = [center center] z = 3
	displaySprite id = online_bookend2 parent = online_menu_ui_container tex = character_hub_hilite_bookend rgba = ($online_light_blue)Pos = ((($online_general_menu_hi_lite_ypos [0])* (0.0, 1.0))+ (774.0, 20.0))dims = (40.0, 35.0) just = [center center] z = 3
	CreateScreenElement {
		Type = TextElement
		parent = online_menu_ui_container
		font = text_a4
		Scale = (0.6500000357627869, 0.75)
		rgba = ($online_medium_blue)
		text = <menu_title>
		just = [center top]
		Pos = (($online_general_menu_pos)+ (-5.0, 32.0))
		z_priority = 3.0
	}
	fit_text_into_menu_item id = <id> max_width = 223
	CreateScreenElement {
		Type = TextElement
		parent = online_menu_ui_container
		font = fontgrid_title_gh3
		Scale = (0.699999988079071, 0.75)
		rgba = ($online_dark_purple)
		text = <menu_subtitle>
		just = [center top]
		Pos = (($online_general_menu_pos)+ (0.0, 115.0))
		z_priority = 4.0
	}
	fit_text_into_menu_item id = <id> max_width = 223
	selectable_menu_items = 0
	CreateScreenElement {
		Type = TextElement
		parent = <vmenu_id>
		font = fontgrid_title_gh3
		Scale = (0.6500000357627869, 0.75)
		rgba = ($online_light_blue)
		text = "NO"
		just = [left top]
		z_priority = 4.0
	}
	fit_text_into_menu_item id = <id> max_width = 223
	<id> ::SetTags menu_item = <selectable_menu_items>
	<id> ::SetProps event_handlers = [
		{focus online_general_menu_focus params = {id = <id>}}
		{unfocus retail_menu_unfocus}
		{pad_choose select_private_match params = {Type = open}}
	]
	<selectable_menu_items> = (<selectable_menu_items> + 1)
	CreateScreenElement {
		Type = TextElement
		parent = <vmenu_id>
		font = fontgrid_title_gh3
		Scale = (0.6500000357627869, 0.75)
		rgba = ($online_light_blue)
		text = "YES"
		just = [left top]
		z_priority = 4.0
	}
	fit_text_into_menu_item id = <id> max_width = 223
	<id> ::SetTags menu_item = <selectable_menu_items>
	<id> ::SetProps event_handlers = [
		{focus online_general_menu_focus params = {id = <id>}}
		{unfocus retail_menu_unfocus}
		{pad_choose select_private_match params = {Type = private}}
	]
	<selectable_menu_items> = (<selectable_menu_items> + 1)
	set_online_menu_highlight_pos menu_items = <selectable_menu_items>
	set_focus_color rgba = ($online_dark_purple)
	set_unfocus_color rgba = ($online_light_blue)
	Change \{user_control_pill_text_color = [0 0 0 255]}
	Change \{user_control_pill_color = [180 180 180 255]}
	add_user_control_helper \{text = "SELECT" button = green z = 100}
	add_user_control_helper \{text = "BACK" button = red z = 100}
	add_user_control_helper \{text = "UP/DOWN" button = strumbar z = 100}
	LaunchEvent Type = focus target = <vmenu_id>
endscript

script destroy_select_private_match_menu
	if ScreenElementExists \{id = online_menu_ui_container}
		DestroyScreenElement \{id = online_menu_ui_container}
	endif
	clean_up_user_control_helpers
	destroy_menu_backdrop
endscript

script select_private_match
	if (<Type> = private)
		SetNetworkPreference {Field = 'private_slots' string = ($num_private_slots [1].name)checksum = ($num_private_slots [1].checksum)num = 1}
	else
		SetNetworkPreference {Field = 'private_slots' string = ($num_private_slots [0].name)checksum = ($num_private_slots [0].checksum)num = 0}
	endif
	ui_flow_manager_respond_to_action \{action = continue}
endscript
