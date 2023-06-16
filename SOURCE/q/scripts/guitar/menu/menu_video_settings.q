video_settings_menu_font = fontgrid_title_gh3

script create_video_settings_menu\{popup = 0}
	kill_start_key_binding
	CreateScreenElement \{Type = ContainerElement parent = root_window id = vom_container Pos = (0.0, 0.0)}
	if (<popup> = 0)
		new_menu \{scrollid = vs_scroll vmenuid = vs_vmenu font = $video_settings_menu_font menu_pos = (300.0, 400.0) spacing = 8 text_left}
		Change \{menu_focus_color = [240 235 240 255]}
		Change \{menu_unfocus_color = [235 120 135 255]}
		displayText \{parent = vom_container Pos = (800.0, 550.0) just = [center center] text = "video options" Scale = 1.5 rgba = [240 235 240 255] font = $video_settings_menu_font noshadow}
		create_menu_backdrop \{texture = venue_bg}
		displaySprite \{parent = vom_container tex = options_video_poster Pos = (640.0, 360.0) dims = (1024.0, 512.0) just = [center center] z = 1 font = $video_settings_menu_font}
		GetGlobalTags \{user_options}
		displaySprite \{parent = vom_container id = vom_hilite tex = white Pos = (285.0, 415.0) rgba = [40 60 110 255] dims = (275.0, 35.0) z = 2}
		common_control_helpers \{select back nav}
		text_params = {
			parent = vs_vmenu
			Type = TextElement
			font = $video_settings_menu_font
			rgba = ($menu_unfocus_color)
			Scale = 0.75
			z_priority = 3
		}
		<exclusive_params> = {exclusive_device = ($primary_controller)}
	else
		z = 100
		new_menu scrollid = vs_scroll vmenuid = vs_vmenu menu_pos = (0.0, 340.0) exclusive_device = ($last_start_pressed_device)
		SetScreenElementProps \{id = vs_vmenu dims = (1280.0, 720.0) internal_just = [center top]}
		CreateScreenElement {
			Type = TextElement
			font = ($video_settings_menu_font)
			parent = vs_scroll
			Pos = (640.0, -90.0)
			Scale = 1.4
			text = "VIDEO SETTINGS"
			rgba = ($menu_unfocus_color)
			just = [center top]
			z_priority = <z>
		}
		create_pause_menu_frame z = (<z> - 10)
		calibrate_text = "CALIBRATE LAG"
		text_params = {parent = vs_vmenu Type = TextElement font = ($audio_settings_menu_font)rgba = ($menu_unfocus_color)Scale = 1 z_priority = <z>}
		<exclusive_params> = {exclusive_device = ($last_start_pressed_device)}
		CreateScreenElement {
			Type = SpriteElement
			parent = vom_container
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
	endif
	CreateScreenElement {
		<text_params>
		text = "Calibrate Lag"
		event_handlers = [
			{focus vom_focus params = {item = calibrate popup = <popup>}}
			{unfocus vom_unfocus params = {item = calibrate popup = <popup>}}
			{pad_choose menu_video_settings_select_calibrate_lag}
		]
		<exclusive_params>
	}
	<id> ::SetTags hilite_pos = (285.0, 420.0)
endscript

script destroy_video_settings_menu
	restore_start_key_binding
	clean_up_user_control_helpers
	destroy_menu_backdrop
	destroy_menu \{menu_id = vom_container}
	destroy_menu \{menu_id = vs_scroll}
	destroy_pause_menu_frame
endscript

script vom_focus
	retail_menu_focus
	if (<popup> = 0)
		GetTags
		<id> ::GetTags
		if ScreenElementExists \{id = vom_hilite}
			vom_hilite ::SetProps Pos = <hilite_pos>
		endif
	endif
endscript

script vom_unfocus
	retail_menu_unfocus
	if (<popup>)
		return
	endif
endscript

script menu_video_settings_select_calibrate_lag
	ui_flow_manager_respond_to_action \{action = select_calibrate_lag}
endscript
