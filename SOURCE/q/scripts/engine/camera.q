camera_default_far_clip = 0.0
camera_fov = 0.0
widescreen_camera_fov = 0.0
compact_camera_fov = 0.0
current_screen_mode = standard_screen_mode
last_screen_mode = standard_screen_mode
camera_1p_farplane_baseline = 0
camera_1p_farplane_adjustment = 0
camera_2p_farplane_baseline = 0
camera_2p_farplane_adjustment = 0
focus_mode_cam_height_multiplier = 0.4
focus_mode_cam_vert_air_override = 0.6
camera_lock_button_pressed_time = 300

script screen_setup_standard
	SetScreen \{Aspect = 1.3333334 angle = camera_fov letterbox = 0}
	Change \{current_screen_mode = standard_screen_mode}
	printf \{"change to standard"}
endscript

script screen_setup_widescreen
	SetScreen \{Aspect = 1.7777778 angle = $#"0x946139a7" letterbox = 0}
	Change \{current_screen_mode = widescreen_screen_mode}
	printf \{"change to widescreen"}
endscript

script screen_setup_letterbox
	SetScreen \{Aspect = 1.7777778 angle = $#"0x946139a7" letterbox = 1}
	Change \{current_screen_mode = letterbox_screen_mode}
	printf \{"change to letterbox"}
endscript

script fake_letterboxing
	if NOT GotParam \{remove}
		switch ($current_screen_mode)
			case standard_screen_mode
				fake_letterboxing_elements
				Change \{last_screen_mode = standard_screen_mode}
			case widescreen_screen_mode
				Change \{last_screen_mode = widescreen_screen_mode}
			case letterbox_screen_mode
				Change \{last_screen_mode = letterbox_screen_mode}
			default
				printf \{"current screen mode = %d" d = $#"0xd65fe602"}
				script_assert \{"Unrecognized screen mode"}
		endswitch
	else
		switch ($last_screen_mode)
			case standard_screen_mode
				fake_letterboxing_elements \{remove}
			case widescreen_screen_mode
				printf \{"last screen mode = %d" d = $#"0x28bd32d7"}
				nullscript
			case letterbox_screen_mode
				printf \{"last screen mode = %d" d = $#"0x28bd32d7"}
				nullscript
			default
				printf \{"last screen mode = %d" d = $#"0x28bd32d7"}
				script_assert \{"Unrecognized screen mode"}
		endswitch
	endif
endscript

script fake_letterboxing_elements
	if ScreenElementExists \{id = letterbox_anchor}
		DestroyScreenElement \{id = letterbox_anchor}
	endif
	if GotParam \{remove}
		SetScreen \{angle = 72.0 Aspect = 1.3333334}
		return
	else
		SetScreen \{angle = 72.0 Aspect = 1.3333334}
	endif
	SetScreenElementLock \{id = root_window OFF}
	CreateScreenElement \{Type = ContainerElement id = letterbox_anchor parent = root_window z_priority = 999 just = [center center] internal_just = [left top]}
	CreateScreenElement \{Type = SpriteElement parent = letterbox_anchor texture = #"0x34d3e9ce" Scale = (100.0, 9.5) Pos = (0.0, -20.0) rgba = [0 0 0 128] just = [left top] z_priority = 15}
	CreateScreenElement \{Type = SpriteElement parent = letterbox_anchor texture = #"0x34d3e9ce" Scale = (100.0, 12.0) Pos = (0.0, 392.0) rgba = [0 0 0 128] just = [left top] z_priority = 15}
endscript
