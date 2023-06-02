
script create_gamma_brightness_menu\{popup = 0}
	header_font = text_a5
	menu_font = fontgrid_title_gh3
	menu_pos = (0.0, 340.0)
	z = 100.0
	CreateScreenElement \{Type = ContainerElement parent = root_window id = gamma_warning_container Pos = (0.0, 0.0)}
	event_handlers = [
		{pad_up gamma_brightness_menu_change params = {up}}
		{pad_down gamma_brightness_menu_change params = {down}}
		{pad_back menu_flow_go_back}
	]
	new_menu scrollid = scrolling_gamma_warning vmenuid = vmenu_gamma_warning menu_pos = <menu_pos> event_handlers = <event_handlers>
	if (<popup> = 1)
		create_pause_menu_frame z = (<z> - 10)
	else
		CreateScreenElement \{Type = SpriteElement parent = gamma_warning_container Pos = (640.0, 360.0) just = [center center] rgba = [50 50 50 255] dims = (1280.0, 720.0)}
		add_user_control_helper \{text = "BACK" button = red z = 100}
		add_user_control_helper \{text = "UP/DOWN" button = strumbar z = 100}
	endif
	SetScreenElementProps \{id = vmenu_gamma_warning dims = (1280.0, 720.0) internal_just = [center top]}
	CreateScreenElement {
		Type = TextElement
		parent = gamma_warning_container
		text = "BRIGHTNESS"
		font = <header_font>
		Scale = 1.5
		Pos = (640.0, 280.0)
		just = [center center]
		rgba = ($menu_unfocus_color)
		z_priority = <z>
	}
	FormatText textname = brightness_text "Brightness: %d" d = ($SE_Brightness)
	CreateScreenElement {
		Type = TextElement
		parent = vmenu_gamma_warning
		text = <brightness_text>
		id = gamma_brightness_text
		font = <menu_font>
		Scale = (1.25)
		z_priority = <z>
		rgba = [223 223 223 255]
		event_handlers = [
			{focus retail_menu_focus}
		]
	}
endscript

script destroy_gamma_brightness_menu
	clean_up_user_control_helpers
	destroy_menu \{menu_id = scrolling_gamma_warning}
	destroy_menu \{menu_id = gamma_warning_container}
	destroy_pause_menu_frame
endscript

script gamma_brightness_menu_change
	printf \{"gamma_brightness_menu_change"}
	if GotParam \{up}
		Change SE_Brightness = ($SE_Brightness + 1)
		if ($SE_Brightness > 10)
			Change \{SE_Brightness = 10}
		endif
	elseif GotParam \{down}
		Change SE_Brightness = ($SE_Brightness - 1)
		if ($SE_Brightness < 0)
			Change \{SE_Brightness = 0}
		endif
	endif
	SetGlobalTags \{user_options params = {gamma_brightness = $SE_Brightness}}
	if ViewportExists \{id = bg_viewport}
		TOD_Proxim_Update_Global_Brightness \{viewport = bg_viewport}
	endif
	if ScreenElementExists \{id = gamma_brightness_text}
		FormatText textname = brightness_text "Brightness: %d" d = ($SE_Brightness)
		printf <brightness_text>
		SetScreenElementProps id = gamma_brightness_text text = <brightness_text>
	endif
endscript
