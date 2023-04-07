winport_song_skew = 0
winport_song_skew_default = 100
winport_calibrate_lag_menu_font = fontgrid_title_gh3
winport_calibrate_lag_menu_line_pos = (420.0, 360.0)
winport_calibrate_lag_menu_circle_dims = (96.0, 96.0)
winport_calibrate_lag_menu_circle_velocity = 300
winport_calibrate_lag_menu_circle_inital_pos = (420.0, -146.0)
winport_calibrate_lag_menu_circle_separation = 320
winport_calibrate_lag_menu_num_circles = 15
winport_calibrate_lag_hilite_pos0 = (463.0, 346.0)
winport_calibrate_lag_hilite_dims0 = (430.0, 50.0)
winport_calibrate_lag_hilite_pos1 = (463.0, 404.0)
winport_calibrate_lag_hilite_dims1 = (430.0, 50.0)
winport_calibrate_lag_hilite_pos2 = (463.0, 460.0)
winport_calibrate_lag_hilite_dims2 = (430.0, 50.0)
winport_calibrate_lag_hilite_unselected = [
	40
	100
	165
	255
]
winport_calibrate_lag_hilite_selected = [
	165
	95
	50
	255
]
winport_calibrate_lag_results = [
	0.0
	0.0
	0.0
	0.0
	0.0
	0.0
	0.0
	0.0
	0.0
	0.0
	0.0
	0.0
	0.0
	0.0
	0.0
]
winport_calibrate_lag_circle_index = 0
winport_calibrate_lag_real_time_requirement = 0
winport_calibrate_lag_dirty = 0
winport_calibrate_lag_end_checks = 0
winport_calibrate_lag_started_finish = 0
winport_calibrate_lag_cap = 200
winport_calibrate_lag_early_window = -100
winport_calibrate_lag_late_window = 400
winport_cl_ready_for_input = 0
winport_calibrate_lag_most_recent_in_game_setting = 0

script winport_create_calibrate_lag_menu\{from_in_game = 1}
	WinPortGetSongSkew
	Change winport_song_skew = <value>
	Change winport_calibrate_lag_most_recent_in_game_setting = <from_in_game>
	if IsWinPort
		if ($winport_calibrate_lag_most_recent_in_game_setting = 1)
			kill_start_key_binding
		endif
	else
		kill_start_key_binding
	endif
	Menu_Music_Off
	if ViewportExists \{id = bg_viewport}
		disable_bg_viewport
	endif
	Change \{winport_calibrate_lag_end_checks = 0}
	Change \{winport_calibrate_lag_started_finish = 0}
	set_focus_color \{rgba = [230 230 230 255]}
	set_unfocus_color \{rgba = $#"0xacb5832a"}
	z = 100
	CreateScreenElement \{Type = ContainerElement parent = root_window id = winport_cl_container Pos = (0.0, 0.0)}
	create_menu_backdrop \{texture = #"0xc5a54934"}
	displaySprite {
		parent = winport_cl_container
		tex = #"0xc5a54934"
		Pos = (640.0, 360.0)
		dims = (1280.0, 720.0)
		just = [center center]
		z = (<z> - 4)
	}
	CreateScreenElement {
		Type = SpriteElement
		parent = winport_cl_container
		id = as_light_overlay
		texture = #"0xf6c8349f"
		Pos = (640.0, 360.0)
		dims = (1280.0, 720.0)
		just = [center center]
		z_priority = (<z> - 1)
	}
	<tape_offset> = (90.0, 325.0)
	displaySprite {
		parent = winport_cl_container
		tex = #"0x01c66f71"
		Pos = ((755.0, 50.0) + <tape_offset>)
		dims = (96.0, 192.0)
		z = (<z> + 2)
		flip_v
		rot_angle = -6
	}
	displaySprite {
		parent = winport_cl_container
		tex = #"0x01c66f71"
		rgba = [0 0 0 128]
		Pos = ((760.0, 48.0) + <tape_offset>)
		dims = (96.0, 192.0)
		z = (<z> + 2)
		flip_v
		rot_angle = -6
	}
	displaySprite {
		parent = winport_cl_container
		tex = #"0x28091e67"
		Pos = (440.0, 40.0)
		dims = (132.0, 64.0)
		z = (<z> + 2)
		rot_angle = 100
	}
	displaySprite {
		parent = winport_cl_container
		tex = #"0x28091e67"
		rgba = [0 0 0 128]
		Pos = (432.0, 46.0)
		dims = (132.0, 64.0)
		z = (<z> + 2)
		rot_angle = 100
	}
	upper_helper = "This value may be set between 0 ms and 200 ms.\n\nSome computer hardware may cause audio and gameplay to fall out of sync.	If you have to play notes ahead of the music, try adding 20 ms to the value.  Subtract 20 ms if you have to play behind the music.\nFine tune the number from there based on your personal preferences."
	CreateScreenElement {
		Type = TextBlockElement
		parent = winport_cl_container
		Pos = (465.0, 60.0)
		text = <upper_helper>
		font = #"0xdbce7067"
		dims = (740.0, 0.0)
		allow_expansion
		rgba = [60 40 115 255]
		Scale = 0.5
		just = [left top]
		internal_just = [left top]
		z_priority = <z>
	}
	GetScreenElementDims id = <id>
	GetScreenElementPosition id = <id>
	winport_calibrate_lag_fill_options z = <z> from_in_game = <from_in_game>
	Change \{user_control_pill_text_color = [0 0 0 255]}
	Change \{user_control_pill_color = [180 180 180 255]}
	add_user_control_helper \{text = "SELECT" button = green z = 100}
	add_user_control_helper \{text = "BACK" button = red z = 100}
	add_user_control_helper \{text = "UP/DOWN" button = strumbar z = 100}
endscript

script winport_calibrate_lag_fill_options\{z = 100}
	if (<from_in_game>)
		<controller> = ($last_start_pressed_device)
	else
		<controller> = ($primary_controller)
	endif
	displaySprite parent = winport_cl_container id = winport_calibrate_lag_hilite tex = #"0x44ca1a1c" Pos = $winport_calibrate_lag_hilite_pos0 rgba = $winport_calibrate_lag_hilite_unselected z = <z>
	calib_eh = [
		{pad_back winport_menu_calibrate_go_back}
	]
	new_menu scrollid = winport_cl_scroll vmenuid = winport_cl_vmenu menu_pos = (485.0, 380.0) event_handlers = <calib_eh> exclusive_device = <controller> text_left default_colors = 0
	text_params = {parent = winport_cl_vmenu Type = TextElement font = ($winport_calibrate_lag_menu_font)rgba = ($menu_unfocus_color)Scale = 0.9}
	CreateScreenElement {
		<text_params>
		id = calibrate_reset_option
		text = "RESET"
		event_handlers = [
			{focus winport_menu_calibrate_focus params = {index = 1}}
			{unfocus winport_menu_calibrate_unfocus params = {index = 1}}
			{pad_choose winport_menu_calibrate_lag_reset_lag params = {z = <z>}}
		]
		z_priority = (<z> + 1)
	}
	GetScreenElementDims id = <id>
	fit_text_in_rectangle id = <id> dims = ((340.0, 0.0) + <height> * (0.0, 1.0))only_if_larger_x = 1
	CreateScreenElement \{Type = ContainerElement parent = winport_cl_vmenu id = calibrate_manual_option event_handlers = [{focus winport_menu_calibrate_focus params = {index = 2}}{unfocus winport_menu_calibrate_unfocus params = {index = 2}}{pad_choose winport_menu_calibrate_lag_manual_choose}]}
	<container_id> = <id>
	CreateScreenElement {
		<text_params>
		parent = <container_id>
		id = lag_offset_text
		text = " "
		just = [left top]
		z_priority = (<z> + 1)
		Pos = (40.0, 0.0)
	}
	winport_calibrate_lag_update_text
	CreateScreenElement {
		Type = SpriteElement
		id = winport_cl_manual_adjust_up_arrow
		parent = <container_id>
		texture = #"0x1877d61c"
		just = [center bottom]
		Pos = (16.0, 16.0)
		rgba = ($winport_calibrate_lag_hilite_unselected)
		alpha = 1
		Scale = 0.65
		z_priority = (<z> + 1)
		flip_h
	}
	CreateScreenElement {
		Type = SpriteElement
		id = winport_cl_manual_adjust_down_arrow
		parent = <container_id>
		texture = #"0x1877d61c"
		just = [center top]
		Pos = (16.0, 20.0)
		rgba = ($winport_calibrate_lag_hilite_unselected)
		alpha = 1
		Scale = 0.65
		z_priority = (<z> + 1)
	}
	SetScreenElementLock \{id = winport_cl_vmenu On}
	LaunchEvent \{Type = focus target = winport_cl_vmenu}
endscript

script winport_calibrate_lag_update_text
	FormatText textname = lag_value_text "%d ms" d = ($winport_song_skew)
	lag_offset_text ::SetProps text = <lag_value_text>
endscript

script winport_destroy_calibrate_lag_menu
	WinPortSetSongSkew value = ($winport_song_skew)
	if IsWinPort
		if ($winport_calibrate_lag_most_recent_in_game_setting = 1)
			restore_start_key_binding
		endif
	else
		restore_start_key_binding
	endif
	spawnscriptnow \{Menu_Music_On}
	if ViewportExists \{id = bg_viewport}
		enable_bg_viewport
	endif
	Change \{winport_calibrate_lag_dirty = 0}
	destroy_menu_backdrop
	clean_up_user_control_helpers
	killspawnedscript \{name = winport_do_calibration_update}
	destroy_menu \{menu_id = winport_cl_scroll}
	destroy_menu \{menu_id = winport_cl_container}
	if ScreenElementExists \{idcl_manual_adjust_handler}
		DestroyScreenElement \{id = winport_cl_manual_adjust_handler}
	endif
	LaunchEvent \{Type = focus target = root_window}
endscript

script winport_menu_calibrate_focus
	generic_menu_up_or_down_sound
	wait \{1 gameframes}
	if (<index> = 0)
		retail_menu_focus
		SetScreenElementProps \{id = winport_calibrate_lag_hilite Pos = $#"0x4dedb5dd" dims = $#"0xa3118f52"}
	elseif (<index> = 1)
		retail_menu_focus
		SetScreenElementProps \{id = winport_calibrate_lag_hilite Pos = $#"0x3aea854b" dims = $#"0xd416bfc4"}
	else
		Obj_GetID
		retail_menu_focus id = {<objID> child = 0}
		SetScreenElementProps \{id = winport_calibrate_lag_hilite Pos = $#"0xa3e3d4f1" dims = $#"0x4d1fee7e"}
		DoScreenElementMorph \{id = winport_cl_manual_adjust_up_arrow rgba = $#"0x657bbe2c"}
		DoScreenElementMorph \{id = winport_cl_manual_adjust_down_arrow rgba = $#"0x657bbe2c"}
	endif
endscript

script winport_menu_calibrate_unfocus
	if (<index> = 0)
		retail_menu_unfocus
	elseif (<index> = 1)
		retail_menu_unfocus
	else
		Obj_GetID
		retail_menu_unfocus id = {<objID> child = 0}
		DoScreenElementMorph id = winport_cl_manual_adjust_up_arrow rgba = ($winport_calibrate_lag_hilite_unselected)
		DoScreenElementMorph id = winport_cl_manual_adjust_down_arrow rgba = ($winport_calibrate_lag_hilite_unselected)
	endif
endscript

script winport_menu_calibrate_lag_create_circles
	if ($transitions_locked = 1 || $menu_flow_locked = 1)
		return
	endif
	CreateScreenElement {
		parent = winport_cl_container Type = TextElement font = ($winport_calibrate_lag_menu_font)rgba = ($menu_unfocus_color)
		id = clm_dummy_event_handler
		text = ""
		z_priority = <z>
	}
	LaunchEvent \{Type = focus target = clm_dummy_event_handler}
	LaunchEvent \{Type = unfocus target = winport_cl_vmenu}
	clean_up_user_control_helpers
	Change \{user_control_pill_text_color = [0 0 0 255]}
	Change \{user_control_pill_color = [180 180 180 255]}
	add_user_control_helper \{text = "STRUM" button = strumbar z = 100}
	destroy_menu \{menu_id = winport_cl_scroll}
	destroy_menu \{menu_id = winport_calibrate_lag_hilite}
	kill_debug_elements
	init_play_log
	generic_menu_pad_choose_sound
	displaySprite {
		id = winport_cl_countdown_circle
		parent = winport_cl_container
		tex = #"0xcbbb28dc"
		Pos = ($winport_calibrate_lag_menu_line_pos + (13.0, 14.0))
		rgba = [220 220 220 208]
		dims = (72.0, 72.0)
		z = 199
	}
	CreateScreenElement {
		Type = TextElement
		id = winport_cl_countdown_text
		parent = winport_cl_container
		Pos = ($winport_calibrate_lag_menu_line_pos + (47.0, 58.0))
		Scale = (1.0, 1.0)
		text = ""
		font = ($winport_calibrate_lag_menu_font)
		rgba = [0 0 0 255]
		z_priority = 200
	}
	<sep> = ($winport_calibrate_lag_menu_circle_separation * 1.0)
	<vel> = ($winport_calibrate_lag_menu_circle_velocity * 1.0)
	<seconds_between_circles> = (<sep> / <vel>)
	<i> = 0
	begin
		spawnscriptnow \{winport_cl_do_ping params = {time = 0.6}}
		wait \{0.6 seconds}
		FormatText textname = tex "%t" t = (3 - <i>)
		SetScreenElementProps id = winport_cl_countdown_text text = <tex>
		SoundEvent \{event = GH_SFX_HitNoteSoundEvent}
		wait (<seconds_between_circles> - 0.6)seconds
		<i> = (<i> + 1)
	repeat 3
	Change \{winport_calibrate_lag_circle_index = 0}
	half_circle_width = 0
	circle_index = 0
	begin
		FormatText checksumName = circle_id 'circle%d' d = <circle_index>
		circle_pos = (($winport_calibrate_lag_menu_circle_inital_pos)- ((0.0, 1.0) * <circle_index> * ($winport_calibrate_lag_menu_circle_separation)))
		<one_frame> = ((1.0 / 60.0)* $winport_calibrate_lag_menu_circle_velocity)
		casttointeger \{one_frame}
		<y_off> = ($winport_calibrate_lag_menu_line_pos.(0.0, 1.0) - <circle_pos>.(0.0, 1.0))
		<steps> = (<y_off> / <one_frame>)
		casttointeger \{steps}
		<new_y_off> = ($winport_calibrate_lag_menu_line_pos.(0.0, 1.0) - (<steps> * <one_frame>))
		<circle_pos> = ((<circle_pos>.(1.0, 0.0) * (1.0, 0.0))+ (<new_y_off> * (0.0, 1.0)))
		CreateScreenElement {
			Type = SpriteElement
			parent = winport_cl_container
			texture = #"0xfcc0611f"
			id = <circle_id>
			Pos = <circle_pos>
			dims = ($winport_calibrate_lag_menu_circle_dims)
			just = [left top]
			rgba = [255 255 255 255]
			z_priority = (<z> + 51)
			alpha = 0.5
		}
		<circle_id> ::SetTags existence = 0 hit = 0 check = 1
		<circle_id> ::SetTags initial_position = <circle_pos>
		<circle_id> ::SetTags time_requirement = (<steps> * (1.0 / 60.0))
		<circle_index> = (<circle_index> + 1)
	repeat ($winport_calibrate_lag_menu_num_circles)
	LaunchEvent \{Type = unfocus target = root_window}
	wait \{1 gameframe}
	Change \{winport_cl_ready_for_input = 0}
	spawnscriptnow \{winport_cl_do_ping params = {time = 0.6}}
	spawnscriptnow winport_do_calibration_update params = {device_num = <device_num>}
	wait \{0.6 seconds}
	SetScreenElementProps \{id = winport_cl_countdown_text text = "GO!" Scale = 0.7}
	SoundEvent \{event = GH_SFX_HitNoteSoundEvent}
	winport_cl_ping_ID ::DoMorph \{alpha = 0}
	wait \{0.4 seconds}
	SetScreenElementProps \{id = winport_cl_countdown_circle alpha = 0}
	Change \{winport_cl_ready_for_input = 1}
	DoScreenElementMorph \{id = winport_calibrate_lag_target alpha = 1}
	wait \{1 gameframe}
	SetScreenElementProps \{id = winport_cl_countdown_text alpha = 0}
endscript

script winport_menu_calibrate_go_back
	ui_flow_manager_respond_to_action \{action = go_back}
endscript

script winport_menu_calibrate_lag_destroy_circles
	circle_index = 0
	begin
		FormatText checksumName = circle_id 'circle%d' d = <circle_index>
		destroy_menu menu_id = <circle_id>
		<circle_index> = (<circle_index> + 1)
	repeat ($winport_calibrate_lag_menu_num_circles)
	destroy_menu \{menu_id = clm_dummy_event_handler}
endscript

script winport_do_calibration_update
	<circle_index> = 0
	begin
		FormatText checksumName = circle_id 'circle%d' d = <circle_index>
		<circle_id> ::SetTags sounded = 0 pinged = 0
		<circle_index> = (<circle_index> + 1)
	repeat ($winport_calibrate_lag_menu_num_circles)
	begin
		circle_index = 0
		num_circles_gone = 0
		delta_time = (1.0 / 60.0)
		begin
			FormatText checksumName = circle_id 'circle%d' d = <circle_index>
			<circle_id> ::GetTags
			<existence> = (<existence> + <delta_time>)
			update_difference = (<delta_time>)
			position_change = (<update_difference> * ($winport_calibrate_lag_menu_circle_velocity))
			casttointeger \{position_change}
			GetScreenElementPosition id = <circle_id>
			<ScreenElementPos> = (<ScreenElementPos> + (0.0, 1.0) * <position_change>)
			<target_pos> = ($winport_calibrate_lag_menu_line_pos)
			diff = ((<ScreenElementPos>.(0.0, 1.0))- (<target_pos>.(0.0, 1.0)))
			if (<diff> < 0)
				<diff> = (0 - <diff>)
			endif
			<winport_cl_tweak> = ($winport_calibrate_lag_tick_ms_offset / 1000.0)
			if ((($winport_calibrate_lag_menu_circle_velocity)* <winport_cl_tweak>)>= <diff>)
				if (<sounded> = 0)
					SoundEvent \{event = GH_SFX_HitNoteSoundEvent}
					<circle_id> ::SetTags sounded = 1
				endif
			endif
			if (<diff> < <position_change>)
				SetScreenElementProps id = <circle_id> rgba = [135 0 180 255] alpha = 1.0
			endif
			if ((<ScreenElementPos>.(0.0, 1.0))> ($winport_calibrate_lag_menu_line_pos.(0.0, 1.0) + ($winport_calibrate_lag_menu_circle_dims.(0.0, 1.0))))
				if (<hit> = 0 & <check> = 1)
					Change winport_calibrate_lag_circle_index = (($winport_calibrate_lag_circle_index)+ 1)
					<circle_id> ::SetTags check = 0
				endif
				<num_circles_gone> = (<num_circles_gone> + 1)
				<circle_id> ::Obj_SpawnScriptNow winport_cl_fade_circle params = {id = <circle_id>}
			endif
			<circle_id> ::SetProps Pos = (<ScreenElementPos>)
			<circle_id> ::SetTags existence = <existence>
			<circle_index> = (<circle_index> + 1)
		repeat ($winport_calibrate_lag_menu_num_circles)
		if (<num_circles_gone> = $winport_calibrate_lag_menu_num_circles)
			SpawnScriptLater \{winport_kill_off_and_finish_calibration}
		endif
		if (($winport_calibrate_lag_end_checks = 0)& $winport_cl_ready_for_input)
			if ControllerMake up <device_num>
				spawnscriptnow winport_menu_calibrate_lag_do_guitar_check_up_down params = {device_num = <device_num>}
			endif
			if ControllerMake down <device_num>
				spawnscriptnow winport_menu_calibrate_lag_do_guitar_check_up_down params = {device_num = <device_num>}
			endif
			if ControllerMake X <device_num>
				spawnscriptnow winport_menu_calibrate_lag_do_guitar_check_choose params = {device_num = <device_num>}
			endif
		endif
		wait \{1 gameframe}
	repeat
endscript

script winport_cl_fade_circle
	<id> ::DoMorph rgba = [0 0 0 255] alpha = 0.5 time = 0.009
endscript

script winport_cl_do_ping\{time = 0.066}
	winport_cl_ping_ID ::DoMorph \{Scale = 10 alpha = 0}
	winport_cl_ping_ID ::DoMorph Scale = 1 alpha = 1 motion = ease_in time = <time>
	winport_cl_ping_ID ::DoMorph \{alpha = 0 motion = ease_in time = 0.1}
endscript

script winport_menu_calibrate_lag_do_guitar_check_choose
	if ($winport_calibrate_lag_end_checks = 0)
		if NOT IsGuitarController controller = <device_num>
			winport_menu_calibrate_lag_say_lines_are_even
		endif
	endif
endscript

script winport_menu_calibrate_lag_do_guitar_check_up_down
	if ($winport_calibrate_lag_end_checks = 0)
		if IsGuitarController controller = <device_num>
			winport_menu_calibrate_lag_say_lines_are_even
		endif
	endif
endscript

script winport_menu_calibrate_lag_say_lines_are_even
	if ($winport_calibrate_lag_end_checks = 1)
		return
	endif
	FormatText checksumName = circle_id 'circle%d' d = ($winport_calibrate_lag_circle_index)
	if NOT ScreenElementExists id = <circle_id>
		return
	endif
	if NOT ScreenElementExists \{id = winport_calibrate_lag_target}
		return
	endif
	<circle_id> ::GetTags
	GetScreenElementPosition id = <circle_id>
	GetScreenElementDims id = <circle_id>
	input_difference = (<time_requirement> - <existence>)
	new_input_diff = (<input_difference> * 1000)
	<new_input_diff> = (0 - <new_input_diff>)
	if (<new_input_diff> < $winport_calibrate_lag_early_window)
		return
	endif
	if (<new_input_diff> > $winport_calibrate_lag_late_window)
		return
	endif
	SetArrayElement ArrayName = winport_calibrate_lag_results GlobalArray index = ($winport_calibrate_lag_circle_index)NewValue = <new_input_diff>
	output_log_text "Calibrate: %o" o = <new_input_diff> Color = white
	winport_get_closest_circle_above_line
	<circle_id> ::SetTags hit = 1
	Change winport_calibrate_lag_circle_index = (($winport_calibrate_lag_circle_index)+ 1)
	<closest_id> ::SetProps Hide
	winport_calibrate_lag_target ::DoMorph \{Scale = 1.5 relative_scale time = 0.05}
	winport_calibrate_lag_target ::DoMorph \{Scale = 1.0 relative_scale time = 0.05}
	if (($winport_calibrate_lag_circle_index)= ($winport_calibrate_lag_menu_num_circles))
		Change \{winport_calibrate_lag_end_checks = 1}
		winport_kill_off_and_finish_calibration
	endif
endscript

script winport_kill_off_and_finish_calibration
	LaunchEvent \{Type = unfocus target = clm_dummy_event_handler}
	killspawnedscript \{name = winport_do_calibration_update}
	winport_menu_calibrate_lag_finish_up_calibration
	winport_menu_calibrate_lag_destroy_circles
endscript

script winport_get_closest_circle_above_line
	if ($winport_calibrate_lag_end_checks = 1)
		return
	endif
	i = 0
	begin
		FormatText checksumName = circle_id 'circle%d' d = <i>
		GetScreenElementPosition id = <circle_id>
		if ((<ScreenElementPos>.(0.0, 1.0))< ($winport_calibrate_lag_menu_line_pos.(0.0, 1.0) + ($winport_calibrate_lag_menu_circle_dims.(0.0, 1.25))))
			<circle_id> ::GetTags
			if NOT (<hit>)
				return closest_id = <circle_id> hit = 1
			endif
		endif
		<i> = (<i> + 1)
	repeat $winport_calibrate_lag_menu_num_circles hit = 0
	return closest_id = <circle_id>
endscript

script winport_menu_calibrate_lag_finish_up_calibration
	if ($winport_calibrate_lag_started_finish = 1)
		return
	endif
	Change \{winport_calibrate_lag_started_finish = 1}
	min = 50000.0
	Max = -50000.0
	index = 0
	num_hit = 0
	total_val = 0.0
	begin
		FormatText checksumName = circle_id 'circle%d' d = <index>
		if NOT ScreenElementExists id = <circle_id>
			return
		endif
		<circle_id> ::GetTags
		if (<hit>)
			<num_hit> = (<num_hit> + 1)
			val = ($winport_calibrate_lag_results [<index>])
			if (<val> < <min>)
				<min> = (<val>)
			endif
			if (<val> > <Max>)
				<Max> = (<val>)
			endif
			<total_val> = (<total_val> + <val>)
		endif
		<index> = (<index> + 1)
	repeat ($winport_calibrate_lag_menu_num_circles)
	if (<num_hit> > 2)
		<total_val> = (<total_val> - <min>)
		<total_val> = (<total_val> - <Max>)
		avg = (<total_val> / (<num_hit> - 2))
		if (<avg> < 0)
			<avg> = 0
		elseif (<avg> > $winport_calibrate_lag_cap)
			<avg> = $winport_calibrate_lag_cap
		endif
		GetGlobalTags \{user_options}
		old_lag = <lag_calibration>
		SetGlobalTags user_options params = {lag_calibration = <avg>}
	endif
	LaunchEvent \{Type = focus target = root_window}
	wait \{30 gameframes}
	destroy_calibrate_lag_menu
	create_calibrate_lag_menu from_in_game = ($winport_calibrate_lag_most_recent_in_game_setting)
	if GotParam \{avg}
		if GotParam \{old_lag}
			casttointeger \{avg}
			if NOT (<old_lag> = <avg>)
				Change \{winport_calibrate_lag_dirty = 1}
			endif
		endif
	endif
endscript

script winport_menu_calibrate_lag_reset_lag
	generic_menu_up_or_down_sound
	if NotIsMacPort
		Change winport_song_skew = ($winport_song_skew_default)
	else
		Change \{winport_song_skew = 40}
	endif
	winport_calibrate_lag_update_text
endscript

script winport_menu_calibrate_lag_manual_choose
	SetScreenElementProps \{id = winport_calibrate_lag_hilite rgba = $#"0xf4a4e7a9"}
	SetScreenElementProps \{id = winport_cl_vmenu block_events}
	CreateScreenElement \{Type = ContainerElement parent = winport_cl_container id = winport_cl_manual_adjust_handler event_handlers = [{pad_up winport_menu_calibrate_lag_manual_up}{pad_down winport_menu_calibrate_lag_manual_down}{pad_choose winport_menu_calibrate_lag_manual_back}{pad_back winport_menu_calibrate_lag_manual_back}]}
	LaunchEvent \{Type = focus target = winport_cl_manual_adjust_handler}
	generic_menu_pad_choose_sound
endscript

script winport_menu_calibrate_lag_manual_back
	SetScreenElementProps \{id = winport_calibrate_lag_hilite rgba = $#"0xacb5832a"}
	SetScreenElementProps \{id = winport_cl_vmenu unblock_events}
	DestroyScreenElement \{id = winport_cl_manual_adjust_handler}
	generic_menu_pad_choose_sound
endscript

script winport_menu_calibrate_lag_manual_up
	if winport_menu_calibrate_lag_adjust \{value = 1}
		DoScreenElementMorph \{id = winport_cl_manual_adjust_up_arrow Scale = 1.5 relative_scale}
		DoScreenElementMorph \{id = winport_cl_manual_adjust_up_arrow Scale = 1.0 relative_scale time = 0.15}
	endif
	generic_menu_up_or_down_sound
endscript

script winport_menu_calibrate_lag_manual_down
	if winport_menu_calibrate_lag_adjust \{value = -1}
		DoScreenElementMorph \{id = winport_cl_manual_adjust_down_arrow Scale = 1.5 relative_scale}
		DoScreenElementMorph \{id = winport_cl_manual_adjust_down_arrow Scale = 1.0 relative_scale time = 0.15}
	endif
	generic_menu_up_or_down_sound
endscript

script winport_menu_calibrate_lag_adjust\{value = 1}
	GetGlobalTags \{user_options}
	new_song_skew = (($winport_song_skew)+ <value>)
	if (<new_song_skew> > $winport_calibrate_lag_cap)
		return \{FALSE}
	elseif (<new_song_skew> < 0)
		return \{FALSE}
	endif
	Change winport_song_skew = <new_song_skew>
	winport_calibrate_lag_update_text
	return \{true}
endscript

script winport_create_audio_calibrate_reminder
	WinPortGetConfigNumber \{name = "AudioLagReminderShown" defaultValue = 0}
	if (<value> = 1)
		ui_flow_manager_respond_to_action \{action = continue}
		return
	endif
	WinPortSetConfigNumber \{name = "AudioLagReminderShown" value = 1}
	z = 100
	CreateScreenElement \{Type = ContainerElement parent = root_window id = winport_cl_container Pos = (0.0, 0.0)}
	create_menu_backdrop \{texture = #"0xc5a54934"}
	displaySprite {
		parent = winport_cl_container
		tex = #"0xc5a54934"
		Pos = (640.0, 360.0)
		dims = (1280.0, 720.0)
		just = [center center]
		z = (<z> - 4)
	}
	CreateScreenElement {
		Type = SpriteElement
		parent = winport_cl_container
		id = as_light_overlay
		texture = #"0xf6c8349f"
		Pos = (640.0, 360.0)
		dims = (1280.0, 720.0)
		just = [center center]
		z_priority = (<z> - 1)
	}
	displaySprite {
		parent = winport_cl_container
		tex = #"0x078111df"
		Pos = (540.0, 340.0)
		just = [center center]
		Scale = 1.42
		z = (<z> -2)
	}
	textProps = {
		Type = TextBlockElement
		parent = winport_cl_container
		font = #"0x35c0114b"
		rgba = [0 21 132 255]
		z_priority = <z>
		just = [center center]
		internal_just = [center center]
	}
	CreateScreenElement {
		<textProps>
		Pos = (640.0, 270.0)
		dims = (500.0, 500.0)
		text = "Check out audio calibration in the Options menu."
		Scale = 0.8
	}
	CreateScreenElement {
		<textProps>
		Pos = (640.0, 420.0)
		dims = (650.0, 500.0)
		text = "To optimize the gameplay experience on your specific computer hardware, use the Calibrate Audio Lag tool in the Options menu."
		Scale = 0.7
	}
	spawnscriptnow \{check_for_any_input params = {use_primary_controller button1 = start button2 = X}}
endscript

script winport_destroy_audio_calibrate_reminder
	DestroyScreenElement \{id = winport_cl_container}
	destroy_menu_backdrop
endscript
