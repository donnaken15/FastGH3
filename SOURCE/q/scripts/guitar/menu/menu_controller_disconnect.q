
script create_controller_disconnect_menu
	kill_start_key_binding
	destroy_menu \{menu_id = cd_static_text_container}
	CreateScreenElement \{Type = ContainerElement parent = root_window id = cd_static_text_container Pos = (0.0, 0.0)}
	if ($playing_song = 1)
		menu_pos = (550.0, 500.0)
		menu_z = 1000
		rocking_out_text = "YOU ARE ROCKING OUT A BIT TOO HARD"
		rocking_out_off = (640.0, 160.0)
		rocking_out_dims = (500.0, 200.0)
		z = 3.0
		please_reconnect_off = (640.0, 270.0)
		please_reconnect_dims = (550.0, 300.0)
		offwhite = [223 223 223 255]
		FormatText \{textname = please_reconnect_text "Please ensure a controller is connected properly"}
		menu_font = fontgrid_title_gh3
		new_menu {
			scrollid = cd_scrolling_menu
			vmenuid = cd_vmenu
			use_backdrop = 0
			menu_pos = <menu_pos>
			exclusive_device = ($unplugged_controller)
			spacing = -20
		}
		create_pause_menu_frame x_scale = 1.2 y_scale = 1.2 z = (<menu_z> - 10)
		CreateScreenElement {
			Type = TextBlockElement
			parent = cd_static_text_container
			font = <menu_font>
			text = <rocking_out_text>
			Pos = <rocking_out_off>
			dims = <rocking_out_dims>
			just = [center top]
			Scale = 1.0
			rgba = [150 0 0 250]
			z_priority = <menu_z>
		}
		CreateScreenElement {
			Type = TextBlockElement
			parent = cd_static_text_container
			font = <menu_font>
			text = <please_reconnect_text>
			Pos = <please_reconnect_off>
			dims = <please_reconnect_dims>
			just = [center top]
			Scale = 0.85
			rgba = [210 210 210 250]
			z_priority = <menu_z>
		}
		displaySprite parent = cd_static_text_container tex = #"0xdb44b36c" Pos = (448.0, 470.0) Scale = (1.5, 1.5) z = <menu_z>
		displaySprite parent = cd_static_text_container tex = #"0xdb44b36c" flip_h Pos = (448.0, 550.0) Scale = (1.5, 1.5) z = <menu_z>
		displaySprite parent = cd_static_text_container tex = white Pos = (462.0, 550.0) Scale = (89.0, 7.5) z = (<menu_z> + 0.1)rgba = <offwhite>
		displaySprite parent = cd_static_text_container tex = #"0xacf2f335" Pos = (448.0, 540.0) rot_angle = 5 Scale = (1.8899999856948853, 1.875) z = (<menu_z> + 0.2)
		displaySprite parent = cd_static_text_container tex = #"0xacf2f335" Pos = (770.0, 547.0) flip_v rot_angle = -5 Scale = (1.8899999856948853, 1.875) z = (<menu_z> + 0.2)
		displaySprite id = hi_right parent = cd_static_text_container tex = #"0x0b444b41" Pos = (770.0, 553.0) Scale = (1.25, 1.25) z = (<menu_z> + 0.3)
		displaySprite id = hi_left parent = cd_static_text_container tex = #"0x0b444b41" flip_v Pos = (500.0, 553.0) Scale = (1.25, 1.25) z = (<menu_z> + 0.3)
		set_focus_color \{rgba = [180 50 50 255]}
		set_unfocus_color \{rgba = [0 0 0 255]}
		text_scale = (1.2000000476837158, 1.25)
		CreateScreenElement {
			Type = TextElement
			parent = cd_vmenu
			font = <menu_font>
			Scale = <text_scale>
			rgba = [180 50 50 255]
			text = "RESUME"
			just = [left top]
			z_priority = (<menu_z> + 0.2)
			event_handlers = [
				{focus controller_disconnect_resume_focus}
				{unfocus retail_menu_unfocus}
				{pad_choose controller_disconnect_menu_select_resume}
			]
		}
		CreateScreenElement {
			Type = TextElement
			parent = cd_vmenu
			font = <menu_font>
			Scale = <text_scale>
			rgba = [0 0 0 255]
			text = "QUIT"
			just = [left top]
			z_priority = (<menu_z> + 0.2)
			event_handlers = [
				{focus controller_disconnect_quit_focus}
				{unfocus retail_menu_unfocus}
				{pad_choose controller_disconnect_menu_select_quit}
			]
		}
	else
		blinker_pos = (750.0, 80.0)
		displaySprite {
			parent = cd_static_text_container
			id = controller_disconnect_pill
			tex = #"0x0d96f276"
			dims = (384.0, 80.0)
			just = [center center]
			Pos = <blinker_pos>
			rgba = [50 50 50 212]
			z = 100
		}
		displayText {
			parent = cd_static_text_container
			id = controller_disconnect_text
			text = "PLEASE RECONNECT CONTROLLER"
			Pos = (<blinker_pos> + (0.0, -5.0))
			just = [center center]
			z = 101
			font = #"0xba959ce0"
			Scale = 0.7
			rgba = [223 223 223 255]
		}
		spawnscriptnow \{menu_controller_disconnect_wait_for_reconnect}
	endif
endscript

script menu_controller_disconnect_wait_for_reconnect
	begin
		if GuitarGetAnalogueInfo \{controller = $#"0x2da0d0c3"}
			break
		endif
		wait \{1 gameframe}
	repeat
	if ScreenElementExists \{id = controller_disconnect_pill}
		DoScreenElementMorph \{id = controller_disconnect_pill Scale = 0 time = 0.25 relative_scale}
	endif
	if ScreenElementExists \{id = controller_disconnect_text}
		DoScreenElementMorph \{id = controller_disconnect_text Scale = 0 time = 0.25}
	endif
	wait \{0.25 seconds}
	controller_disconnect_menu_select_resume
endscript

script controller_disconnect_resume_focus
	retail_menu_focus
	if ScreenElementExists \{id = hi_left}
		if ScreenElementExists \{id = hi_right}
			SetScreenElementProps \{id = hi_left Pos = (470.0, 505.0) flip_v}
			SetScreenElementProps \{id = hi_right Pos = (735.0, 505.0)}
		endif
	endif
endscript

script controller_disconnect_quit_focus
	retail_menu_focus
	if ScreenElementExists \{id = hi_left}
		if ScreenElementExists \{id = hi_right}
			SetScreenElementProps \{id = hi_left Pos = (510.0, 565.0) flip_v}
			SetScreenElementProps \{id = hi_right Pos = (690.0, 565.0)}
		endif
	endif
endscript

script destroy_controller_disconnect_menu
	destroy_menu \{menu_id = cd_scrolling_menu}
	destroy_pause_menu_frame
	destroy_menu \{menu_id = cd_static_text_container}
endscript

script controller_disconnect_menu_select_resume
	restore_start_key_binding
	Change \{check_for_unplugged_controllers = 1}
	if ($playing_song = 1)
		gh3_start_pressed
		ui_flow_manager_respond_to_action \{action = select_resume}
	else
		destroy_controller_disconnect_menu
	endif
endscript

script controller_disconnect_menu_select_quit
	restore_start_key_binding
	Change \{check_for_unplugged_controllers = 1}
	ui_flow_manager_respond_to_action \{action = select_quit}
endscript
