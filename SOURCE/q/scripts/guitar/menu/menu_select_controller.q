menu_select_controller_icon_positions = [
	{
		c = (370.0, 350.0)
		g = (370.0, 350.0)
		n = (616.0, 475.0)
	}
	{
		c = (900.0, 420.0)
		g = (900.0, 420.0)
		n = (926.0, 475.0)
	}
	{
		c = (565.0, 415.0)
		g = (565.0, 405.0)
	}
	{
		c = (670.0, 440.0)
		g = (670.0, 430.0)
	}
	{
		c = (655.0, 335.0)
		g = (655.0, 325.0)
	}
	{
		c = (630.0, 395.0)
		g = (630.0, 385.0)
	}
	{
		c = (610.0, 450.0)
		g = (610.0, 440.0)
	}
	{
		c = (700.0, 370.0)
		g = (700.0, 360.0)
	}
	{
		c = (595.0, 345.0)
		g = (595.0, 335.0)
	}
]
menu_select_controller_icon_rotations = [
	0.0
	0.0
	0.0
	0.0
	0.0
	0.0
	0.0
]
menu_select_num_controllers = 0
menu_select_controller_p1_controller_id = -1
menu_select_controller_p2_controller_id = -1
menu_select_controller_light = [
	180
	180
	180
	255
]
menu_select_controller_dark = [
	100
	100
	100
	255
]
menu_select_controller_sticks_big = (192.0, 192.0)
menu_select_controller_sticks_small = (160.0, 160.0)
menu_select_controller_guitar_big = (384.0, 192.0)
menu_select_controller_guitar_small = (320.0, 160.0)
in_controller_select_menu = 0

old_2p_background = 0

script create_select_controller_menu
	if ($playing_song)
		disable_bg_viewport
	endif
	Change \{in_controller_select_menu = 1}
	Change \{p1_ready = 0}
	Change \{p2_ready = 0}
	Change \{menu_select_controller_p1_controller_id = -1}
	Change \{menu_select_controller_p2_controller_id = -1}
	Change \{player_controls_valid = 0}
	menu_font = text_a5
	CreateScreenElement \{Type = ContainerElement parent = root_window id = msc_container Pos = (0.0, 0.0)}
	create_menu_backdrop \{texture = controller_2p_bg}
	displayText \{parent = msc_container text = "CONTROLLER SELECT" Pos = (640.0, 160.0) Scale = 1.7 just = [center center] rgba = [255 255 255 255] font = text_a3 z = 100 shadow shadow_rgba = [127 0 0 255] shadow_offs = (4.0, 4.0)}
	CreateScreenElement \{Type = TextElement parent = msc_container text = "Move the desired controller" Pos = (680.0, 240.0) Scale = 0.9 just = [center center] rgba = [185 180 135 255] font = text_a4 z = 100 Shadow shadow_rgba = [90 25 20 255] shadow_offs = (2.0, 2.0)}
	CreateScreenElement \{Type = TextElement parent = msc_container text = "to your side of the screen." Pos = (680.0, 290.0) Scale = 0.9 just = [center center] rgba = [185 180 135 255] font = text_a4 z = 100 Shadow shadow_rgba = [90 25 20 255] shadow_offs = (2.0, 2.0)}
	if ($old_2p_background) // support original background if available
		CreateScreenElement \{Type = SpriteElement parent = msc_container id = arrow1 texture = controller_2p_arrow rgba = [240 140 80 255] dims = (64.0, 128.0) Pos = (450.0, 270.0) just = [left top] rot_angle = -20}
		<id> ::SetTags old_pos = (450.0, 270.0)
		CreateScreenElement \{Type = SpriteElement parent = msc_container id = arrow2 texture = controller_2p_arrow rgba = [130 90 205 255] dims = (64.0, 128.0) Pos = (705.0, 445.0) just = [left top] flip_v flip_h rot_angle = -20}
		<id> ::SetTags old_pos = (680.0, 420.0)
		spawnscriptnow \{cs_bounce_arrows}
	else
		if (randomrange(0.0, 1.0) > 0.5)
			tex1 = Controller_2p_ring
			tex2 = Controller_2p_ring_b
		else
			tex1 = Controller_2p_ring_b
			tex2 = Controller_2p_ring
		endif
		rgba = [ 112 112 112 255 ]
		CreateScreenElement {
			Type = SpriteElement parent = msc_container id = ring1
			texture = <tex1> rgba = <rgba> Pos = (350.0, 440.0) scale = 1.9
			just = [center center]
		}
		CreateScreenElement {
			Type = SpriteElement parent = msc_container id = ring2
			texture = <tex2> rgba = <rgba> Pos = (888.0, 525.0) scale = 1.9
			just = [center center]
		}
		if (randomrange(0.0, 1.0) > 0.5)
			ring1::SetProps flip_h
		endif
		if (randomrange(0.0, 1.0) > 0.5)
			ring2::SetProps flip_h
		endif
		spawnscriptnow \{cs_rotate_rings}
		spawnscriptnow \{cs_rotate_rings params = { id = ring2 }}
	endif
	//spawnscriptnow \{jump_up_and_down_peasants}
	common_control_helpers \{select back nav}
	create_ready_icons \{pos1 = (300.0, 450.0) pos2 = (835.0, 510.0)}
	i = 0
	begin
		GetRandomValue \{a = -10 b = 10 name = rand_rot}
		SetArrayElement ArrayName = menu_select_controller_icon_rotations GlobalArray index = <i> NewValue = <rand_rot>
		<i> = (<i> + 1)
	repeat 7
	spawnscriptnow \{menu_select_controller_poll_for_controllers params = {wait_to_drop_controller = 1}}
endscript

script destroy_select_controller_menu
	if ($playing_song)
		enable_bg_viewport
	endif
	destroy_ready_icons
	Change \{menu_select_num_controllers = 0}
	clean_up_user_control_helpers
	killspawnedscript \{name = cs_rotate_rings}
	killspawnedscript \{name = cs_bounce_arrows}
	//killspawnedscript \{name = jump_up_and_down_peasants}
	killspawnedscript \{name = menu_select_controller_poll_for_controllers}
	destroy_menu \{menu_id = msc_container}
	destroy_menu_backdrop
	Change \{in_controller_select_menu = 0}
endscript

script cs_rotate_rings \{id = ring1}
	#"360_degree_interval" = randomrange(2.7, 8.9)
	rotations = 1000
	time = (<#"360_degree_interval"> * <rotations>)
	start_angle = randomrange(-360.0, 360.0)
	end_angle = (360.0 * <rotations> + <start_angle>)
	begin
		if ScreenElementExists id = <id>
			DoScreenElementMorph id = <id> rot_angle = <start_angle>
			DoScreenElementMorph id = <id> rot_angle = <end_angle> time = <time>
		endif
		wait <time> seconds
		printf \{'you\'re still here? i get it, it\'s a cool design, right? guess the reference and @ ptr__WESLEY on twitter if you know'}
	repeat
endscript

script cs_bounce_arrows
	begin
		if ScreenElementExists \{id = arrow1}
			arrow1 ::GetTags
			DoScreenElementMorph id = arrow1 Pos = (<old_pos> + (15.0, 25.0))time = 0.5 motion = ease_out
		endif
		if ScreenElementExists \{id = arrow2}
			arrow2 ::GetTags
			DoScreenElementMorph id = arrow2 Pos = (<old_pos>)time = 0.5 motion = ease_out
		endif
		wait \{0.5 seconds}
		if ScreenElementExists \{id = arrow1}
			arrow1 ::GetTags
			DoScreenElementMorph id = arrow1 Pos = (<old_pos>)time = 0.5 motion = ease_in
		endif
		if ScreenElementExists \{id = arrow2}
			arrow2 ::GetTags
			DoScreenElementMorph id = arrow2 Pos = (<old_pos> + (15.0, 25.0))time = 0.5 motion = ease_in
		endif
		wait \{0.5 seconds}
	repeat
endscript

script jump_up_and_down_peasants
endscript

script menu_select_controller_poll_for_controllers\{wait_to_drop_controller = 0}
	begin
		active_controllers = [0 0 0 0 0 0 0]
		GetActiveControllers
		GetInputHandlerBotIndex \{Player = 1}
		total_change = 0
		controller_index = 0
		begin
			if (<active_controllers> [<controller_index>] = 1)
				menu_select_controller_add_controllable_icon controller_index = <controller_index> wait_to_drop_controller = <wait_to_drop_controller>
				<total_change> = (<total_change> + <changed>)
			endif
			if (<active_controllers> [<controller_index>] = 0)
				menu_select_controller_remove_controller_icon controller_index = <controller_index> wait_to_drop_controller = <wait_to_drop_controller>
				<total_change> = (<total_change> + <changed>)
			endif
			<controller_index> = (<controller_index> + 1)
		repeat <controller>
		<wait_to_drop_controller> = 0
		wait \{1 gameframe}
	repeat
endscript

script menu_select_controller_add_controllable_icon\{controller_index = 0 wait_to_drop_controller = 0}
	FormatText checksumName = controller_icon_id 'controller%d_icon' d = <controller_index>
	if NOT ScreenElementExists id = <controller_icon_id>
		c_texture = missing_sprite
		c_pos = ($menu_select_controller_icon_positions [(<controller_index> + 2)].c)
		if IsWinPort
			if WinPortSioIsKeyboard deviceNum = <controller_index>
				c_texture = controller_2p_keyboard
				c_pos = ($menu_select_controller_icon_positions [(<controller_index> + 2)].c)
			else
				if IsGuitarController controller = <controller_index>
					c_texture = controller_2p_lespaul
					c_pos = ($menu_select_controller_icon_positions [(<controller_index> + 2)].g)
				else
					if WinPortSioIsDirectInputGamepad deviceNum = <controller_index>
						c_texture = controller_2p_controller_ps3
						// my NES controller isn't picking up,
						// so need to see if this works
					else
						c_texture = controller_2p_controller_XBOX
					endif
					c_pos = ($menu_select_controller_icon_positions [(<controller_index> + 2)].c)
				endif
			endif
		endif
		CreateScreenElement {
			Type = SpriteElement
			parent = msc_container
			id = <controller_icon_id>
			texture = <c_texture>
			rgba = [220 220 220 250]
			Pos = <c_pos>
			dims = (128.0, 256.0)
			just = [center center]
			rot_angle = ($menu_select_controller_icon_rotations [<controller_index>])
			z_priority = 10
			rgba = <grey>
			event_handlers = [
				{pad_up menu_select_controller_move_up params = {controller_index = <controller_index>}}
				{pad_down menu_select_controller_move_down params = {controller_index = <controller_index>}}
				{pad_choose menu_select_controller_try_to_continue params = {controller_index = <controller_index>}}
				{pad_back menu_select_controller_go_back params = {controller_index = <controller_index>}}
			]
			exclusive_device = <controller_index>
		}
		<id> ::SetProps Scale = 0.5 relative_scale
		grey_out_controller controller_index = <controller_index>
		<controller_icon_id> ::SetTags ready = no location = p0 port = <controller_index>
		Change menu_select_num_controllers = ($menu_select_num_controllers + 1)
		SetScreenElementProps id = <id> alpha = 0
		spawnscriptnow fall_controller params = {controller_index = <controller_index> id = <id> wait = <wait_to_drop_controller>}
		return \{changed = 1}
	endif
	return \{changed = 0}
endscript

script fall_controller\{wait = 0}
	if (<wait> = 1)
		wait \{0.25 seconds}
	endif
	if ScreenElementExists id = <id>
		GetScreenElementProps id = <id>
		hipos = (<Pos> - (0.0, 720.0))
		SetScreenElementProps id = <id> Pos = <hipos> alpha = 1
		<id> ::DoMorph Pos = (<Pos> + (0.0, 50.0))motion = ease_in time = 0.5
		if ScreenElementExists id = <id>
			<id> ::DoMorph Pos = (<Pos> - (0.0, 25.0))motion = ease_out time = 0.1 rot_angle = randomrange (-10.0, 10.0)
		endif
		if ScreenElementExists id = <id>
			<id> ::DoMorph Pos = <Pos> motion = ease_in time = 0.1 rot_angle = randomrange (-5.0, 5.0)
		endif
		if (<controller_index> = $primary_controller)
			menu_select_controller_move_up controller_index = <controller_index> Force = 1
		endif
		if ScreenElementExists id = <id>
			LaunchEvent Type = focus target = <id>
		endif
	endif
endscript

script menu_select_controller_leave_spot\{controller_index = 0}
	FormatText checksumName = controller_icon_id 'controller%d_icon' d = <controller_index>
	i = 1
	begin
		FormatText checksumName = controller_id 'menu_select_controller_p%d_controller_id' d = <i>
		FormatText checksumName = player_ready 'p%d_ready' d = <i>
		if ($<controller_id> = <controller_index>)
			Change GlobalName = <controller_id> NewValue = -1
			<controller_icon_id> ::SetTags ready = no location = p0
			grey_out_controller controller_index = <controller_index>
			generic_menu_up_or_down_sound \{down}
			if ($<player_ready>)
				drop_out_ready_sign Player = <i>
				Change GlobalName = <player_ready> NewValue = 0
			endif
			return
		endif
		<i> = (<i> + 1)
	repeat 2
endscript

script menu_select_controller_get_spot\{controller_index = 0 Spot = p1 Force = 0}
	FormatText checksumName = controller_icon_id 'controller%d_icon' d = <controller_index>
	<controller_icon_id> ::GetTags
	if (<Spot> = p1)
		if ($menu_select_controller_p1_controller_id = -1 || <Force> = 1)
			if (<Force> = 1)
				if NOT ($menu_select_controller_p1_controller_id = -1)
					menu_select_controller_leave_spot controller_index = ($menu_select_controller_p1_controller_id)
				endif
			endif
			Change menu_select_controller_p1_controller_id = <controller_index>
			<controller_icon_id> ::SetTags ready = yes location = p1
			light_up_controller controller_index = <controller_index>
			generic_menu_up_or_down_sound \{up}
		endif
	elseif (<Spot> = p2)
		if ($menu_select_controller_p2_controller_id = -1)
			Change menu_select_controller_p2_controller_id = <controller_index>
			<controller_icon_id> ::SetTags ready = yes location = p2
			light_up_controller controller_index = <controller_index>
			generic_menu_up_or_down_sound \{down}
		endif
	endif
endscript

script menu_select_controller_move_up\{controller_index = 0 Force = 0}
	unfocus_all_controllers
	FormatText checksumName = controller_icon_id 'controller%d_icon' d = <controller_index>
	if ScreenElementExists id = <controller_icon_id>
		<controller_icon_id> ::GetTags
		if (<location> = p2)
			if ($p2_ready)
				focus_all_controllers
				return
			endif
			if (<controller_index> = $primary_controller)
				if ($menu_select_controller_p1_controller_id = -1)
					menu_select_controller_leave_spot controller_index = <controller_index>
					menu_select_controller_get_spot controller_index = <controller_index> Spot = p1
				endif
			else
				menu_select_controller_leave_spot controller_index = <controller_index>
			endif
		elseif (<location> = p0)
			menu_select_controller_get_spot controller_index = <controller_index> Spot = p1 Force = <Force>
		endif
	endif
	focus_all_controllers
endscript

script menu_select_controller_move_down\{controller_index = 0}
	unfocus_all_controllers
	FormatText checksumName = controller_icon_id 'controller%d_icon' d = <controller_index>
	if ScreenElementExists id = <controller_icon_id>
		<controller_icon_id> ::GetTags
		if (<location> = p1)
			if ($p1_ready)
				focus_all_controllers
				return
			endif
			if (<controller_index> = $primary_controller)
				if ($menu_select_controller_p2_controller_id = -1)
					menu_select_controller_leave_spot controller_index = <controller_index>
					menu_select_controller_get_spot controller_index = <controller_index> Spot = p2
				endif
			else
				menu_select_controller_leave_spot controller_index = <controller_index>
			endif
		elseif (<location> = p0)
			menu_select_controller_get_spot controller_index = <controller_index> Spot = p2
		endif
	endif
	focus_all_controllers
endscript

script menu_select_controller_remove_controller_icon
	FormatText checksumName = controller_icon_id 'controller%d_icon' d = <controller_index>
	if ScreenElementExists id = <controller_icon_id>
		if ($menu_select_controller_p1_controller_id = <controller_index>)
			Change \{menu_select_controller_p1_controller_id = -1}
		elseif ($menu_select_controller_p2_controller_id = <controller_index>)
			Change \{menu_select_controller_p2_controller_id = -1}
		endif
		<controller_icon_id> ::GetTags
		if (<location> = p1 & $p1_ready = 2)
			drop_out_ready_sign \{Player = 1}
			Change \{p1_ready = 0}
		endif
		if (<location> = p2 & $p2_ready = 2)
			drop_out_ready_sign \{Player = 2}
			Change \{p2_ready = 0}
		endif
		DestroyScreenElement id = <controller_icon_id>
		Change menu_select_num_controllers = ($menu_select_num_controllers - 1)
		return \{changed = 1}
	endif
	return \{changed = 0}
endscript

script unfocus_all_controllers
	i = 0
	begin
		FormatText checksumName = controller_icon_id 'controller%d_icon' d = <i>
		if ScreenElementExists id = <controller_icon_id>
			LaunchEvent Type = unfocus target = <controller_icon_id>
		endif
		<i> = (<i> + 1)
	repeat 7
endscript

script focus_all_controllers
	i = 0
	begin
		FormatText checksumName = controller_icon_id 'controller%d_icon' d = <i>
		if ScreenElementExists id = <controller_icon_id>
			LaunchEvent Type = focus target = <controller_icon_id>
		endif
		<i> = (<i> + 1)
	repeat 7
endscript

script menu_select_controller_try_to_continue
	FormatText checksumName = controller_icon_id 'controller%d_icon' d = <controller_index>
	unfocus_all_controllers
	<controller_icon_id> ::GetTags
	if (<location> = p1)
		if (<ready> = yes)
			Change player1_device = <controller_index>
			if ($p1_ready = 0)
				if ($p2_ready = 0 || $primary_controller = $player1_device || $primary_controller = $player2_device)
					Change \{p1_ready = 1}
					drop_in_ready_sign \{Player = 1}
					Change \{p1_ready = 2}
				endif
			endif
		endif
	elseif (<location> = p2)
		if (<ready> = yes)
			Change player2_device = <controller_index>
			if ($p2_ready = 0)
				if ($p1_ready = 0 || $primary_controller = $player1_device || $primary_controller = $player2_device)
					Change \{p2_ready = 1}
					drop_in_ready_sign \{Player = 2}
					Change \{p2_ready = 2}
				endif
			endif
		endif
	endif
	if (($p1_ready = 2)& ($p2_ready = 2))
		Change \{p1_ready = 0}
		Change \{p2_ready = 0}
		Change StructureName = player1_status controller = ($player1_device)
		Change StructureName = player2_status controller = ($player2_device)
		Change \{player_controls_valid = 1}
		ui_flow_manager_respond_to_action \{action = continue}
	else
		focus_all_controllers
	endif
endscript

script menu_select_controller_go_back
	FormatText checksumName = controller_icon_id 'controller%d_icon' d = <controller_index>
	<controller_icon_id> ::GetTags
	if (<location> = p1)
		if ($p1_ready = 2)
			Change \{p1_ready = 0}
			drop_out_ready_sign \{Player = 1}
		else
			ui_flow_manager_respond_to_action \{action = go_back}
		endif
	elseif (<location> = p2)
		if ($p2_ready = 2)
			Change \{p2_ready = 0}
			drop_out_ready_sign \{Player = 2}
		else
			ui_flow_manager_respond_to_action \{action = go_back}
		endif
	else
		ui_flow_manager_respond_to_action \{action = go_back}
	endif
endscript

script grey_out_controller
	FormatText checksumName = controller_icon_id 'controller%d_icon' d = <controller_index>
	grey = [150 150 150 255]
	if ScreenElementExists id = <controller_icon_id>
		<controller_icon_id> ::GetTags
		if IsGuitarController controller = <port>
			c_pos = ($menu_select_controller_icon_positions [(<controller_index> + 2)].g)
		else
			c_pos = ($menu_select_controller_icon_positions [(<controller_index> + 2)].c)
		endif
		DoScreenElementMorph id = <controller_icon_id> Pos = <c_pos> Scale = 0.5 alpha = 0.75 time = 0.25 relative_scale motion = ease_in
		RunScriptOnScreenElement id = <controller_icon_id> controller_jiggle params = {<...> }
		SetScreenElementProps id = <controller_icon_id> rgba = <grey>
	endif
endscript

script light_up_controller
	FormatText checksumName = controller_icon_id 'controller%d_icon' d = <controller_index>
	printf \{"Light up controller"}
	white = [255 255 255 255]
	if ScreenElementExists id = <controller_icon_id>
		<controller_icon_id> ::GetTags
		<controller_icon_id> ::SetTags old_pos = <Pos>
		<controller_icon_id> ::GetTags
		index = 0
		if (<location> = p2)
			index = 1
		endif
		if IsGuitarController controller = <port>
			new_pos = ($menu_select_controller_icon_positions [<index>].g)
		else
			new_pos = ($menu_select_controller_icon_positions [<index>].c)
		endif
		DoScreenElementMorph id = <controller_icon_id> Pos = <new_pos> Scale = 1.5 alpha = 1 time = 0.25 relative_scale motion = ease_in
		RunScriptOnScreenElement id = <controller_icon_id> controller_jiggle params = {<...> }
		SetScreenElementProps id = <controller_icon_id> rgba = <white>
	endif
endscript

script controller_jiggle
	if NOT ScreenElementExists id = <controller_icon_id>
		return
	endif
	<controller_icon_id> ::DoMorph Pos = {(5.0, 0.0) relative}time = 0.1 motion = ease_in
	<controller_icon_id> ::DoMorph Pos = {(-10.0, 0.0) relative}time = 0.05
	<controller_icon_id> ::DoMorph Pos = {(5.0, 0.0) relative}time = 0.1 motion = ease_out
endscript

















script select_instrument_go_back
	if (<Player> = 1)
		if ($p1_ready = 1)
			Change \{p1_ready = 0}
			Change \{g_si_player2_locked = 0}
			drop_out_ready_sign Player = <Player>
			SoundEvent \{event = Generic_menu_back_SFX}
		else
			menu_flow_go_back
		endif
	else
		if ($p2_ready = 1)
			Change \{p2_ready = 0}
			Change \{g_si_player1_locked = 0}
			drop_out_ready_sign Player = <Player>
			SoundEvent \{event = Generic_menu_back_SFX}
		else
			menu_flow_go_back
		endif
	endif
endscript

script create_ready_icons\{pos1 = (440.0, 120.0) pos2 = (720.0, 580.0)}
	if NOT ((GotParam parent1)|| (GotParam parent2))
		parent1 = root_window
		parent2 = root_window
	endif
	if GotParam \{parent1}
		destroy_menu \{menu_id = ready_container_p1}
		CreateScreenElement {
			Type = ContainerElement
			parent = <parent1>
			id = ready_container_p1
			just = [left top]
			Pos = <pos1>
			rot_angle = -10
			z_priority = 70
			Scale = 1
			alpha = 0
		}
		displaySprite \{parent = ready_container_p1 tex = dialog_title_bg flip_v dims = (128.0, 128.0)}
		displaySprite parent = <id> tex = dialog_title_bg Pos = (128.0, 0.0) dims = (128.0, 128.0)
		displayText \{parent = ready_container_p1 text = "READY!" Pos = (-15.0, -35.0) Scale = (1.25, 0.8999999761581421) font = text_a4 z = 100 rgba = [223 223 223 255]}
		SetScreenElementProps id = <id> Scale = 1
		fit_text_in_rectangle id = <id> dims = (160.0, 42.0)
	endif
	if GotParam \{parent2}
		destroy_menu \{menu_id = ready_container_p2}
		CreateScreenElement {
			Type = ContainerElement
			parent = <parent2>
			id = ready_container_p2
			just = [left top]
			Pos = <pos2>
			rot_angle = 10
			z_priority = 70
			Scale = 1
			alpha = 0
		}
		displaySprite \{parent = ready_container_p2 tex = dialog_title_bg flip_v dims = (128.0, 128.0)}
		displaySprite parent = <id> tex = dialog_title_bg Pos = (128.0, 0.0) dims = (128.0, 128.0)
		displayText \{parent = ready_container_p2 text = "READY!" Pos = (-15.0, -35.0) Scale = (1.25, 0.8999999761581421) font = text_a4 z = 100 rgba = [223 223 223 255]}
		SetScreenElementProps id = <id> Scale = 1
		fit_text_in_rectangle id = <id> dims = (160.0, 42.0)
	endif
endscript

script destroy_ready_icons
	destroy_menu \{menu_id = ready_container_p1}
	destroy_menu \{menu_id = ready_container_p2}
endscript

script drop_in_ready_sign\{Player = 1}
	FormatText checksumName = ready_container 'ready_container_p%d' d = <Player>
	if NOT ScreenElementExists id = <ready_container>
		create_ready_icons
	endif
	DoScreenElementMorph id = <ready_container> alpha = 1
	DoScreenElementMorph id = <ready_container> Scale = 0.5 time = 0.1
	wait \{0.1 seconds}
	FormatText checksumName = sound_event 'CheckBox_Check_SFX_P%d' d = <Player>
	SoundEvent event = <sound_event>
	DoScreenElementMorph id = <ready_container> Scale = 1 time = 0.1
	wait \{0.1 seconds}
endscript

script drop_out_ready_sign\{Player = 1}
	FormatText checksumName = ready_container 'ready_container_p%d' d = <Player>
	DoScreenElementMorph id = <ready_container> Scale = 0.5 time = 0.1
	wait \{0.1 seconds}
	FormatText checksumName = sound_event 'Checkbox_SFX_P%d' d = <Player>
	SoundEvent event = <sound_event>
	DoScreenElementMorph id = <ready_container> Scale = 1 time = 0.1
	wait \{0.1 seconds}
	DoScreenElementMorph id = <ready_container> alpha = 0
endscript

script change_pos_ready_sign\{Player = 1 Pos = (0.0, 0.0)}
	if (<Player> = 1)
		if ScreenElementExists \{id = ready_container_p1}
			SetScreenElementProps id = ready_container_p1 Pos = <Pos>
		endif
	else
		if ScreenElementExists \{id = ready_container_p2}
			SetScreenElementProps id = ready_container_p2 Pos = <Pos>
		endif
	endif
endscript



