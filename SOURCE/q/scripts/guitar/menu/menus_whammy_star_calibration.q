g_spc_check_pow_bool = 1
g_spc_whammy_is_popup = 0
g_spc_sp_is_popup = 0
SHOULD_WE_PLAY_WHAMMY_SOUND = 1

script create_whammy_bar_calibration_menu\{controller = 0 popup = 0}
	if IsWinPort
		if (<popup> = 1)
			kill_start_key_binding
		endif
	else
		kill_start_key_binding
	endif
	CreateScreenElement \{Type = ContainerElement parent = root_window id = wbc_container Pos = (0.0, 0.0) just = [left top]}
	if (<popup>)
		Change \{g_spc_whammy_is_popup = 1}
		controller = ($last_start_pressed_device)
		<z> = 100
	else
		Change \{g_spc_whammy_is_popup = 0}
		<z> = 2
	endif
	if NOT (<popup>)
		create_menu_backdrop \{texture = #"0xc5a54934"}
		CreateScreenElement \{Type = SpriteElement parent = wbc_container id = wbc_light_overlay texture = #"0xf6c8349f" Pos = (640.0, 360.0) dims = (1280.0, 720.0) just = [center center] z_priority = 99}
	endif
	displaySprite {
		id = wbc_poster_1
		parent = wbc_container
		tex = #"0x413edec7"
		Pos = (286.0, 15.0)
		dims = (896.0, 896.0)
		rot_angle = -2
		z = <z>
	}
	displaySprite {
		id = wbc_poster_2
		parent = wbc_container
		tex = #"0xd8378f7d"
		Pos = (286.0, 15.0)
		dims = (896.0, 896.0)
		rot_angle = -2
		z = (<z> - 1)
	}
	if NOT (<popup>)
		displaySprite {
			parent = wbc_container
			tex = #"0xfd06d27e"
			Pos = (1010.0, 450.0)
			dims = (192.0, 92.0)
			z = (<z> + 1)
			flip_v
			rot_angle = 90
		}
		displaySprite {
			parent = wbc_container
			tex = #"0x640f83c4"
			Pos = (350.0, 200.0)
			z = (<z> + 1)
			rot_angle = 90
			dims = (192.0, 92.0)
			flip_v
			flip_h
		}
	endif
	text_block_scale = 0.65
	text_block_type_scale = 0.8
	text_block_1_pos = (630.0, 70.0)
	text_block_1_dims = (910.0, 200.0)
	text_block_2_pos = (650.0, 140.0)
	text_block_2_dims = (840.0, 100.0)
	text_block_3_pos = (750.0, 195.0)
	text_block_3_dims = (525.0, 300.0)
	<text_1> = "Press  the	whammy	bar	 completely	 down, and	gently	allow  it  to  return  to  its	resting	 position."
	button_color = "Green"
	GetEnterButtonAssignment
	if (<assignment> = Circle)
		button_color = "Red"
	endif
	FormatText textname = text_2 "Press	 the  %a  Button  to  calibrate	 using	this  position." a = <button_color>
	<text_3> = "Repeat	the	 process  until	 you  see  the	\c1''Resting  position	calibrated'' \c0message	 every	time  you  return  the	whammy	bar	 to	 its  resting  position."
	CreateScreenElement {
		Type = TextBlockElement
		font = #"0xaba484e8"
		Pos = <text_block_1_pos>
		parent = wbc_container
		text = <text_1>
		rgba = [0 0 0 255]
		z_priority = (<z> + 1)
		dims = <text_block_1_dims>
		just = [center top]
		internal_just = [left top]
		Scale = <text_block_scale>
		internal_scale = <text_block_type_scale>
		rot_angle = -2
		line_spacing = 0.8
	}
	CreateScreenElement {
		Type = TextBlockElement
		font = #"0xaba484e8"
		Pos = <text_block_2_pos>
		parent = wbc_container
		text = <text_2>
		rgba = [220 220 220 255]
		z_priority = (<z> + 1)
		dims = <text_block_2_dims>
		just = [center top]
		internal_just = [left top]
		Scale = <text_block_scale>
		internal_scale = <text_block_type_scale>
		rot_angle = -3
		line_spacing = 0.8
	}
	CreateScreenElement {
		Type = TextBlockElement
		font = #"0xaba484e8"
		Pos = <text_block_3_pos>
		parent = wbc_container
		text = <text_3>
		rgba = [0 0 0 255]
		z_priority = (<z> + 1)
		dims = <text_block_3_dims>
		just = [center top]
		internal_just = [left top]
		Scale = <text_block_scale>
		internal_scale = <text_block_type_scale>
		rot_angle = -2
		line_spacing = 0.8
	}
	CreateScreenElement {
		Type = TextElement
		font = #"0x42c721dd"
		Pos = (760.0, 315.0)
		parent = wbc_container
		text = "Calibrate"
		rgba = [220 220 220 255]
		z_priority = (<z> + 1)
		just = [center top]
		Scale = 1.6
		rot_angle = -4
	}
	CreateScreenElement {
		Type = TextElement
		font = #"0x42c721dd"
		Pos = (800.0, 365.0)
		parent = wbc_container
		text = "Whammy"
		rgba = [220 220 220 255]
		z_priority = (<z> + 1)
		just = [center top]
		Scale = 1.6
		rot_angle = -4
	}
	CreateScreenElement {
		Type = TextBlockElement
		font = #"0xaba484e8"
		rgba = [140 235 170 255]
		Pos = (810.0, 408.0)
		text = "RESTING POSITION CALIBRATED"
		just = [center top]
		internal_just = [center center]
		dims = (400.0, 200.0)
		Scale = 0.6
		line_spacing = 0.8
		parent = wbc_container
		z_priority = (<z> + 2)
		rot_angle = -4
		id = resting_message
		font_spacing = 50
		space_spacing = 20
		Shadow
		shadow_offs = (2.0, 2.0)
		shadow_rgba = [0 0 0 255]
		event_handlers = [
			{pad_choose menu_whammy_bar_calibration_enter_sample}
			{pad_back ui_flow_manager_respond_to_action params = {action = go_back}}
		]
		exclusive_device = <controller>
	}
	LaunchEvent \{Type = focus target = resting_message}
	spawnscriptnow menu_whammy_bar_update_resting_message params = {controller = <controller>}
	Change \{user_control_pill_text_color = [0 0 0 255]}
	Change \{user_control_pill_color = [180 180 180 255]}
	add_user_control_helper text = "SELECT" button = green z = (<z> + 100)
	add_user_control_helper text = "BACK" button = red z = (<z> + 100)
endscript

script destroy_whammy_bar_calibration_menu
	if IsWinPort
		if ($g_spc_whammy_is_popup = 1)
			restore_start_key_binding
		endif
	else
		restore_start_key_binding
	endif
	killspawnedscript \{name = menu_whammy_bar_update_resting_message}
	destroy_menu \{menu_id = wbc_container}
	clean_up_user_control_helpers
	if NOT ($g_spc_whammy_is_popup)
		destroy_menu_backdrop
	endif
endscript

script menu_whammy_bar_calibration_enter_sample
	if GuitarGetAnalogueInfo controller = <device_num>
		if (<rightx> = 0)
			<rightx> = 0.0001
		elseif (<rightx> = 1)
			<rightx> = 0.9998999
		endif
		switch (<device_num>)
			case 0
				SetGlobalTags user_options params = {resting_whammy_position_device_0 = <rightx>}
			case 1
				SetGlobalTags user_options params = {resting_whammy_position_device_1 = <rightx>}
			case 2
				SetGlobalTags user_options params = {resting_whammy_position_device_2 = <rightx>}
			case 3
				SetGlobalTags user_options params = {resting_whammy_position_device_3 = <rightx>}
			case 4
				SetGlobalTags user_options params = {resting_whammy_position_device_4 = <rightx>}
			case 5
				SetGlobalTags user_options params = {resting_whammy_position_device_5 = <rightx>}
			case 6
				SetGlobalTags user_options params = {resting_whammy_position_device_6 = <rightx>}
		endswitch
		if (<device_num> = $player1_status.controller)
			get_resting_whammy_position controller = <device_num>
			Change StructureName = player1_status resting_whammy_position = <resting_whammy_position>
		else
			if (<device_num> = $player2_status.controller)
				get_resting_whammy_position controller = <device_num>
				Change StructureName = player2_status resting_whammy_position = <resting_whammy_position>
			endif
		endif
	endif
endscript

script menu_whammy_bar_update_resting_message
	begin
		if is_whammy_resting controller = <controller>
			if ($SHOULD_WE_PLAY_WHAMMY_SOUND = 0)
				SoundEvent \{event = #"0x8b4a14dc"}
				Change \{SHOULD_WE_PLAY_WHAMMY_SOUND = 1}
			endif
			SetScreenElementProps \{id = resting_message unhide}
			SetScreenElementProps \{id = wbc_poster_1 alpha = 1}
		else
			Change \{SHOULD_WE_PLAY_WHAMMY_SOUND = 0}
			SetScreenElementProps \{id = resting_message Hide}
			menu_whammy_bar_do_poster_morph controller = <controller>
		endif
		wait \{1 gameframe}
	repeat
endscript

script menu_whammy_bar_do_poster_morph
	if GuitarGetAnalogueInfo controller = <controller>
		if (<rightx> >= 0)
			SetScreenElementProps id = wbc_poster_1 alpha = ((1 - <rightx>)* 0.5)
		else
			SetScreenElementProps id = wbc_poster_1 alpha = ((0.5 * (<rightx> * -1))+ 0.5)
		endif
	endif
endscript

script create_star_power_trigger_calibration_menu\{controller = 0 popup = 0}
	kill_start_key_binding
	CreateScreenElement \{id = spc_container Type = ContainerElement parent = root_window Pos = (0.0, 0.0) just = [left top]}
	if (<popup>)
		<z> = 100
		controller = ($last_start_pressed_device)
	else
		<z> = -4
	endif
	if NOT (<popup>)
		create_menu_backdrop \{texture = #"0x13362d9f"}
	else
		displaySprite \{parent = spc_container tex = #"0x13362d9f" Pos = (0.0, 0.0) dims = (1280.0, 720.0) z = 107}
	endif
	displaySprite {
		parent = spc_container
		tex = #"0xb6a0992b"
		Pos = (326.0, 0.0)
		dims = (512.0, 512.0)
		rot_angle = -2
		z = <z>
	}
	displaySprite {
		id = spc_rotating_bg_lines
		parent = spc_container
		tex = #"0x64dd0859"
		Pos = (578.0, 156.0)
		dims = (640.0, 640.0)
		just = [center center]
		rot_angle = 25
		z = (<z> + 1)
	}
	displaySprite {
		id = spc_rotating_bg_planes
		parent = spc_container
		tex = #"0x13da38cf"
		Pos = (568.0, 114.0)
		dims = (512.0, 384.0)
		just = [center center]
		rot_angle = 20
		z = (<z> + 2)
	}
	starpower_pow_tex = #"0xb5104050"
	displaySprite {
		id = spc_pow
		parent = spc_container
		tex = <starpower_pow_tex>
		Pos = (0.0, 0.0)
		Scale = 1.0
		relative_scale
		z = (<z> + 3)
	}
	SetScreenElementProps id = <id> Hide
	button_color = "Green"
	GetEnterButtonAssignment
	if (<assignment> = Circle)
		button_color = "Red"
	endif
	FormatText textname = element_text "Raise the Guitar up to the point at which you would like Star Power to be triggered and press the %a Button to set this value." a = <button_color>
	CreateScreenElement {
		Type = TextBlockElement
		id = star_calibration_text
		parent = spc_container
		font = #"0xdbce7067"
		Pos = (608.0, 520.0)
		just = [center top]
		internal_just = [left top]
		line_spacing = 0.85
		dims = (940.0, 300.0)
		Scale = (0.5, 0.6500000357627869)
		rgba = [225 200 120 255]
		text = <element_text>
		event_handlers = [
			{pad_choose menu_star_power_trigger_enter_position params = {controller = <controller>}}
			{pad_back ui_flow_manager_respond_to_action params = {action = go_back}}
		]
		z_priority = (<z> + 6.0999999)
		rot_angle = -2
	}
	LaunchEvent \{Type = focus target = star_calibration_text}
	spawnscriptnow menu_star_power_trigger_pow_check params = {controller = <controller>}
	add_user_control_helper \{text = "SELECT" button = green z = 110}
	add_user_control_helper \{text = "BACK" button = red z = 110}
endscript

script destroy_star_power_trigger_calibration_menu
	restore_start_key_binding
	destroy_menu \{menu_id = spc_container}
	clean_up_user_control_helpers
	killspawnedscript \{name = menu_star_power_trigger_pow_check}
	destroy_menu_backdrop
endscript

script menu_star_power_trigger_pow_check
	begin
		if GuitarGetAnalogueInfo controller = <controller>
			<spc_v_dist> = <righty>
			if (<spc_v_dist> > 0)
				<spc_v_dist> = 0
			endif
			GetGlobalTags \{user_options}
			if (<controller> = $player1_status.controller)
				if (<lefty_flip_p1> = 1)
					<line_rot> = (25.0 -30.0 * ((<spc_v_dist>)* -1))
				else
					<line_rot> = (25.0 -30.0 * <spc_v_dist>)
				endif
			else
				if (<lefty_flip_p2> = 1)
					<line_rot> = (25.0 -30.0 * ((<spc_v_dist>)* -1))
				else
					<line_rot> = (25.0 -30.0 * <spc_v_dist>)
				endif
			endif
			SetScreenElementProps id = spc_rotating_bg_lines rot_angle = <line_rot>
			SetScreenElementProps id = spc_rotating_bg_planes rot_angle = (<line_rot> - 5.0)
			get_star_power_position controller = <controller>
			<spc_pos_dev> = <star_power_position>
			wait \{0.05 seconds}
			if (<spc_v_dist> <= <spc_pos_dev>)
				if ($g_spc_check_pow_bool = 1)
					SoundEvent \{event = POW_SFX}
					<spc_pow_rand_x> = 0
					<spc_pow_rand_y> = 0
					<spc_pow_rand_scale> = 0
					<spc_pow_rand_rot> = 0
					GetRandomValue \{name = spc_pow_rand_x integer a = 380 b = 470}
					GetRandomValue \{name = spc_pow_rand_y integer a = 50 b = 80}
					GetRandomValue \{name = spc_pow_rand_scale a = 0.6 b = 1.0}
					GetRandomValue \{name = spc_pow_rand_rot a = -3.0 b = 3.0}
					SetScreenElementProps {
						id = spc_pow
						unhide
						Pos = (((1.0, 0.0) * <spc_pow_rand_x>)+ ((0.0, 1.0) * <spc_pow_rand_y>))
						rot_angle = <spc_pow_rand_rot>
						Scale = <spc_pow_rand_scale>
						relative_scale
					}
					Change \{g_spc_check_pow_bool = 0}
				endif
			else
				SetScreenElementProps \{id = spc_pow Hide}
				Change \{g_spc_check_pow_bool = 1}
			endif
		else
			wait \{0.05 seconds}
		endif
	repeat
endscript

script menu_star_power_trigger_enter_position
	if GuitarGetAnalogueInfo controller = <device_num>
		if (<righty> > 0)
			<righty> = 0
		endif
		switch (<device_num>)
			case 0
				SetGlobalTags user_options params = {star_power_position_device_0 = <righty>}
				SoundEvent \{event = POW_SFX}
			case 1
				SetGlobalTags user_options params = {star_power_position_device_1 = <righty>}
				SoundEvent \{event = POW_SFX}
			case 2
				SetGlobalTags user_options params = {star_power_position_device_2 = <righty>}
				SoundEvent \{event = POW_SFX}
			case 3
				SetGlobalTags user_options params = {star_power_position_device_3 = <righty>}
				SoundEvent \{event = POW_SFX}
		endswitch
		if (<device_num> = $player1_status.controller)
			get_star_power_position controller = <device_num>
			Change StructureName = player1_status star_tilt_threshold = <star_power_position>
		else
			if (<device_num> = $player2_status.controller)
				get_star_power_position controller = <device_num>
				Change StructureName = player2_status star_tilt_threshold = <star_power_position>
			endif
		endif
	endif
endscript

script create_guitar_diagnostic_menu
	CreateScreenElement \{Type = ContainerElement parent = root_window id = gd_container Pos = (0.0, 0.0) just = [left top]}
	CreateScreenElement \{Type = SpriteElement parent = gd_container Pos = (0.0, 0.0) just = [left top] dims = (1280.0, 1024.0) rgba = [80 80 80 255] z_priority = -1}
	font = #"0x35c0114b"
	text_params = {Type = TextElement parent = gd_container font = <font> just = [left top]}
	CreateScreenElement {
		<text_params>
		id = title_text
		text = "Guitar info"
		Pos = (540.0, 100.0)
	}
	CreateScreenElement {
		<text_params>
		id = leftx
		text = "Left X "
		Pos = (580.0, 200.0)
	}
	CreateScreenElement {
		<text_params>
		id = rightx
		text = "Right X "
		Pos = (580.0, 240.0)
	}
	CreateScreenElement {
		<text_params>
		id = lefty
		text = "Left Y "
		Pos = (580.0, 280.0)
	}
	CreateScreenElement {
		<text_params>
		id = righty
		text = "Right Y "
		Pos = (580.0, 320.0)
	}
	CreateScreenElement {
		<text_params>
		id = leftlength
		text = "Left Length "
		Pos = (580.0, 360.0)
	}
	CreateScreenElement {
		<text_params>
		id = rightlength
		text = "Right Length "
		Pos = (580.0, 400.0)
	}
	CreateScreenElement {
		<text_params>
		id = LeftTrigger
		text = "Left Trigger "
		Pos = (580.0, 440.0)
	}
	CreateScreenElement {
		<text_params>
		id = RightTrigger
		text = "Right Trigger "
		Pos = (580.0, 480.0)
	}
	CreateScreenElement {
		<text_params>
		id = VerticalDist
		text = "Vertical Dist "
		Pos = (580.0, 520.0)
	}
	spawnscriptnow \{update_guitar_diagnostic_menu}
endscript

script destroy_guitar_diagnostic_menu
	killspawnedscript \{name = update_guitar_diagnostic_menu}
	destroy_menu \{menu_id = gd_container}
endscript

script update_guitar_diagnostic_menu
	begin
		if GuitarGetAnalogueInfo \{controller = 0}
			FormatText textname = leftxtext "Left X - %v" v = <leftx>
			FormatText textname = rightxtext "Whammy position - %v" v = <rightx>
			FormatText textname = leftytext "Left Y - %v" v = <lefty>
			FormatText textname = rightytext "Right Y - %v" v = <righty>
			FormatText textname = leftlengthtext "Left Length - %v" v = <leftlength>
			FormatText textname = rightlengthtext "Right Length - %v" v = <rightlength>
			FormatText textname = lefttriggertext "Left Trigger - %v" v = <LeftTrigger>
			FormatText textname = righttriggertext "Right Trigger - %v" v = <RightTrigger>
			FormatText textname = verticaldisttext "Vertical orientation - %v" v = <VerticalDist>
			SetScreenElementProps id = leftx text = <leftxtext>
			SetScreenElementProps id = rightx text = <rightxtext>
			SetScreenElementProps id = lefty text = <leftytext>
			SetScreenElementProps id = righty text = <rightytext>
			SetScreenElementProps id = leftlength text = <leftlengthtext>
			SetScreenElementProps id = rightlength text = <rightlengthtext>
			SetScreenElementProps id = LeftTrigger text = <lefttriggertext>
			SetScreenElementProps id = RightTrigger text = <righttriggertext>
			SetScreenElementProps id = VerticalDist text = <verticaldisttext>
		endif
		wait \{1 gameframe}
	repeat
endscript
