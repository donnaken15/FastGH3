gh3_button_font = buttonsxenon
default_event_handlers = [
	{
		pad_up
		generic_menu_up_or_down_sound
		params = {
			up
		}
	}
	{
		pad_down
		generic_menu_up_or_down_sound
		params = {
			down
		}
	}
	{
		pad_back
		generic_menu_pad_back
		params = {
			callback = menu_flow_go_back
		}
	}
]
extras_fs = {
	create = create_pause_menu
	create_params = {
		submenu = extras
	}
	Destroy = destroy_pause_menu
	actions = [
		{
			action = go_back
			use_last_flow_state
		}
	]
}
modes_fs = {
	create = create_pause_menu
	create_params = {
		submenu = modes
	}
	Destroy = destroy_pause_menu
	actions = [
		{
			action = go_back
			flow_state_func = pause_flow_from_mode
		}
		{
			action = select_players
			flow_state_func = controller_select_flow_state
		}
		{
			action = select_save
			func = save_mode_data
		}
		{
			action = select_start
			flow_state_func = start_custom_game
		}
	]
}
script start_custom_game
	params = ($mode_setup)
	change game_mode = ($modes[(<params>.mode)])
	change current_num_players = ((<params>.players) + 1)
	change player1_device = ((<params>.devices)[0])
	change player2_device = ((<params>.devices)[1])
	change primary_controller = $player1_device
	Change \{StructureName = player1_status controller = $player1_device}
	Change \{StructureName = player2_status controller = $player2_device}
	//printstruct ($player2_status.part)
	change structurename=player1_status part=($parts[(<params>.part)])
	change structurename=player2_status part=($parts[(<params>.part2)])
	//printstruct ($player2_status)
	change current_difficulty=($difficulty_list[(<params>.diff)])
	change current_difficulty2=($difficulty_list[(<params>.diff2)])
	change structurename=player1_status bot_play=(<params>.bot)
	change structurename=player2_status bot_play=(<params>.bot2)
	restore_start_key_binding
	return \{flow_state = enter_mode_fs}
endscript
script save_mode_data
	params = ($mode_setup)
	// OPTIMIZE!!
	FGH3Config sect='Player' 'Mode' set=(<params>.mode)
	FGH3Config sect='Player' '2Player' set=(<params>.players)
	FGH3Config sect='Player1' 'Device' set=(<params>.devices[<i>])
	FGH3Config sect='Player2' 'Device' set=(<params>.devices[<i>])
	FGH3Config sect='Player1' 'Part' set=(<params>.part)
	FGH3Config sect='Player2' 'Part' set=(<params>.part2)
	FGH3Config sect='Player1' 'Diff' set=(<params>.diff)
	FGH3Config sect='Player2' 'Diff' set=(<params>.diff2)
	FGH3Config sect='Player1' 'Bot' set=(<params>.bot)
	FGH3Config sect='Player2' 'Bot' set=(<params>.bot2)
	/*i = 0
	begin
		FormatText textname=sect 'Player%d' d=(<i> + 1)
		FGH3Config sect=<sect> 'Device' set=(<params>.players[<i>])
		Increment \{i}
	repeat 2*///
	// TODO: show warning that controller IDs can
	// change when connecting/disconnecting devices
endscript
script pause_flow_from_mode // stupid
	reset_mode_setup
	switch $game_mode
		case p1_career
			return \{flow_state = career_pause_fs}
		case training
			return \{flow_state = practice_pause_fs}
		case p2_coop
		case p2_career
			return \{flow_state = coop_career_pause_fs}
		case p2_faceoff
		case p2_pro_faceoff
			return \{flow_state = mp_faceoff_pause_fs}
		case training
			return \{flow_state = practice_pause_fs}
		case p1_quickplay
		case p2_battle
		default
			return \{flow_state = quickplay_pause_fs}
	endswitch
endscript
script detect_controller_by_button
	if GotParam \{background}
		create_menu_backdrop \{texture = black}
	endif
	ReAcquireControllers
	CreateScreenElement \{Type = ContainerElement parent = root_window id = pab_container Pos = (0.0, 0.0)}
	CreateScreenElement \{ Type = TextBlockElement parent = pab_container font = fontgrid_title_gh3 text = 'Press any button on any controller' dims = (800.0, 320.0) Pos = (640.0, 320.0) just = [center top] internal_just = [center top] rgba = [255 255 255 255] Scale = 1.4 allow_expansion }
	spawnscriptnow \{check_for_any_input}
endscript
script stop_detecting_buttons
	if GotParam \{background}
		destroy_menu_backdrop
	endif
	destroy_menu \{menu_id = pab_container}
	killspawnedscript \{name = check_for_any_input}
	SoundEvent \{event=ui_select_sfx}
endscript
script controller_texture
	texture = sprite_missing
	if IsWinPort
		if WinPortSioIsKeyboard deviceNum = <#"0x00000000">
			texture = controller_2p_keyboard
		else
			if IsGuitarController controller = <#"0x00000000">
				texture = controller_2p_lespaul
			else
				if WinPortSioIsDirectInputGamepad controller = <#"0x00000000">
					texture = controller_2p_controller_ps3
				else
					texture = controller_2p_controller_XBOX
				endif
			endif
		endif
	endif
	//printstruct <...>
	return <...>
endscript
script set_p1_device
	devices = ($mode_setup.devices)
	setarrayelement { // wtf
		arrayname=devices index=0 newvalue=<device_num>
	}
	change mode_setup = {
		($mode_setup) // why
		devices=<devices>
	}
	return \{flow_state = modes_fs}
endscript
script set_p2_device
	devices = [ 0 0 ]
	setarrayelement \{ arrayname=devices index=0 newvalue=$player1_device }
	setarrayelement \{ arrayname=devices index=1 newvalue=$player2_device }
	change mode_setup = {
		($mode_setup) // why
		devices=<devices>
	}
	return \{flow_state = modes_fs}
endscript
script reset_mode_setup
	devices = [ 0 0 ]
	setarrayelement { // why
		arrayname=devices index=0
		newvalue=($player1_device)
	}
	setarrayelement { // why
		arrayname=devices index=1
		newvalue=($player2_device)
	}
	// https://i.kym-cdn.com/entries/icons/original/000/002/085/Kornheiser_Why.JPG
	change mode_setup = {
		mode = ($mode_index.$game_mode)
		players = ($current_num_players - 1)
		devices = <devices>
		part = ($part_index.($player1_status.part))
		part2 = ($part_index.($player2_status.part))
		diff = ($diff_index.($current_difficulty))
		diff2 = ($diff_index.($current_difficulty2))
		bot = ($player1_status.bot_play)
		bot2 = ($player2_status.bot_play)
	}
endscript
sp_ctrlsel_fs = {
	create = detect_controller_by_button
	Destroy = stop_detecting_buttons
	actions = [
		{
			action = continue
			flow_state_func = set_p1_device
		}
	]
}
mp_ctrlsel_fs = {
	create = create_select_controller_menu
	Destroy = destroy_select_controller_menu
	actions = [
		{
			action = continue
			flow_state_func = set_p2_device
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
script controller_select_flow_state
	// ternary CFunc/script when
	if ($mode_setup.players = 0)
		return \{flow_state = sp_ctrlsel_fs}
	else
		return \{flow_state = mp_ctrlsel_fs}
	endif
endscript
script mode_menu
	if GotParam \{button}
		if GotParam \{select}
			ui_flow_manager_respond_to_action action = <id>
		endif
		return
	endif
	value = ($mode_setup.<param>)
	if GotParam \{left}
		value = (<value> - 1)
	else
		Increment \{value}
	endif
	if (<value> < 0)
		value = <range>
	endif
	if (<value> > <range>)
		value = 0
	endif
	switch (<param>) // so cringe!!!!!!111!!!111111!1!1!!!!!1111111!!!
		case mode
			out = { mode=<value> }
		case diff
			out = { diff=<value> }
		case diff2
			out = { diff2=<value> }
		case part
			out = { part=<value> }
		case part2
			out = { part2=<value> }
		case bot
			out = { bot=<value> }
		case bot2
			out = { bot2=<value> }
		case players
			out = { players=<value> }
			if ScreenElementExists id=p2_icon
				SetScreenElementProps id=p2_icon alpha=<value>
			endif
	endswitch
	generic_menu_up_or_down_sound
	change mode_setup = {
		($mode_setup) <out>
	}
	if ScreenElementExists id=<id>
		SetScreenElementProps id=<id> text=($<texts>[<value>])
	endif
endscript
mode_buttons = []
mode_setup = {
	mode	= 0
	players	= 0
	devices	= [ 0 1 ] // controllers
	part	= 0
	part2	= 0
	diff	= 3
	diff2	= 3
	bot		= 0
	bot2	= 0
}
mode_text = [
	'Quickplay'
	'Training'
	'Co-op'
	'Face-off'
	'Pro Face-off'
	'Battle'
]
part_text = [ 'Guitar' 'Rhythm' ]
diff_text = [ 'Easy' 'Medium' 'Hard' 'Expert' ]
toggle_text = [ 'OFF' 'ON' ]
playercount_text = [ '1' '2' ] // uhhhhhhh
// wonder if i can get device name somehow
menu_text_color = [ 255 255 255 255 ]
menu_text_sel = 'Select'
menu_text_conf = 'Confirm'
menu_text_back = 'Back'
menu_text_nav = 'Up/Down'
script common_control_helpers
	if GotParam \{select}
		add_user_control_helper \{z = 100 button = green text = $menu_text_sel}
	endif
	if GotParam \{confirm}
		add_user_control_helper \{z = 100 button = green text = $menu_text_conf}
	endif
	if GotParam \{continue}
		add_user_control_helper \{z = 100 button = green text = 'Continue'}
	endif
	if GotParam \{back}
		add_user_control_helper \{z = 100 button = red text = $menu_text_back}
	endif
	if GotParam \{nav}
		add_user_control_helper \{z = 100 button = strumbar text = $menu_text_nav}
	endif
endscript

script create_version_text
	CreateScreenElement {
		Type = TextElement
		parent = pause_menu_frame_container
		text = $fastgh3_build
		font = text_a4
		just = [right bottom]
		Pos = (1200,710)
		alpha = 0.8
		Scale = 0.7
		z = <z>
	}
	branch_text = ''
	switch ($fastgh3_branch)
		case main
			branch_text = 'main'
		case unpak
			branch_text = 'unpak'
		case wii
			branch_text = 'wii'
		case online
			branch_text = 'online'
	endswitch
	CreateScreenElement {
		Type = TextElement
		parent = pause_menu_frame_container
		text = <branch_text>
		font = text_a4
		just = [right bottom]
		Pos = (600,710)
		rgba = [ 127 255 255 191 ]
		Scale = 0.7
		z = <z>
	}
	pad ($build_timestamp[0])
	d = <pad>
	pad ($build_timestamp[1])
	e = <pad>
	if IsTrue \{$bleeding_edge}
		formattext textname=vertext2 'BLEEDING EDGE %f.%d.%e' d=<d> e=<e> f=($build_timestamp[2])
		CreateScreenElement {
			Type = TextElement
			parent = pause_menu_frame_container
			text = <vertext2>
			font = text_a4
			just = [right bottom]
			Pos = (1000,710)
			rgba = [ 255 0 0 191 ]
			Scale = 0.7
			z = <z>
		}
	endif
endscript

script menu_flow_go_back\{Player = 1 create_params = {}destroy_params = {}}
	ui_flow_manager_respond_to_action action = go_back Player = <Player> create_params = <create_params> destroy_params = <destroy_params>
endscript

// @script | new_menu | Creates a new menu with id current_menu_anchor
// @parm name | menu_id | id of this menu
// @parm name | vmenu_id | id of the vmenu
// @parm struct | event_handlers | group of actions to respond to when a button is pressed
// @parmopt vector | dims | (400,480) | dimensions of the menu
// @parmopt array | internal_just | [left top] | justification of elements within the
// menu
script new_menu\{menu_pos = $menu_pos event_handlers = $default_event_handlers use_backdrop = 0 z = 1 dims = (400.0, 480.0) font = text_a1 font_size = 0.75 default_colors = 1 just = [left top] no_focus = 0 internal_just = [center top]}
	if ScreenElementExists id = <scrollid>
		printf 'script new_menu - %s Already exists.' s = <scrollid>
		return
	endif
	if ScreenElementExists id = <vmenuid>
		printf 'script new_menu - %s Already exists.' s = <vmenuid>
		return
	endif
	CreateScreenElement {
		Type = VScrollingMenu
		parent = root_window
		id = <scrollid>
		just = <just>
		dims = <dims>
		Pos = <menu_pos>
		z_priority = <z>
	}
	if (<use_backdrop>)
		create_generic_backdrop
	endif
	if GotParam \{name}
		CreateScreenElement {
			Type = TextElement
			parent = <scrollid>
			font = <font>
			Pos = (0.0, -45.0)
			Scale = <font_size>
			rgba = [127 127 127 127]
			text = <name>
			just = <just>
			Shadow
			shadow_offs = (3.0, 3.0)
			shadow_rgba [0 0 0 255]
		}
	endif
	CreateScreenElement {
		Type = VMenu
		parent = <scrollid>
		id = <vmenuid>
		Pos = (0.0, 0.0)
		just = <just>
		internal_just = <internal_just>
		event_handlers = <event_handlers>
	}
	if GotParam \{rot_angle}
		SetScreenElementProps id = <vmenuid> rot_angle = <rot_angle>
	endif
	if GotParam \{no_wrap}
		SetScreenElementProps id = <vmenuid> dont_allow_wrap
	endif
	if GotParam \{spacing}
		SetScreenElementProps id = <vmenuid> spacing_between = <spacing>
	endif
	if GotParam \{text_left}
		SetScreenElementProps id = <vmenuid> internal_just = [left top]
	endif
	if GotParam \{text_right}
		SetScreenElementProps id = <vmenuid> internal_just = [right top]
	endif
	if NOT GotParam \{exclusive_device}
		exclusive_device = ($primary_controller)
	endif
	if NOT (<exclusive_device> = None)
		SetScreenElementProps {
			id = <scrollid>
			exclusive_device = <exclusive_device>
		}
		SetScreenElementProps {
			id = <vmenuid>
			exclusive_device = <exclusive_device>
		}
	endif
	if (<default_colors>)
		set_focus_color rgba = ($default_menu_focus_color)
		set_unfocus_color rgba = ($default_menu_unfocus_color)
	endif
	if (<no_focus> = 0)
		LaunchEvent Type = focus target = <vmenuid>
	endif
endscript

script destroy_menu
	if GotParam \{menu_id}
		if ScreenElementExists id = <menu_id>
			DestroyScreenElement id = <menu_id>
		endif
		destroy_generic_backdrop
	endif
endscript

script create_main_menu_backdrop
	Change \{coop_dlc_active = 0}
	create_menu_backdrop \{texture = menu_main_bg}
	base_menu_pos = (730.0, 90.0)
	CreateScreenElement {
		Type = ContainerElement
		id = main_menu_text_container
		parent = root_window
		Pos = (<base_menu_pos>)
		just = [left top]
		z_priority = 3
		Scale = 0.8
	}
	CreateScreenElement \{Type = ContainerElement id = main_menu_bg_container parent = root_window Pos = (0.0, 0.0) z_priority = 3}
	WinPortGetAppFullVersion
	FormatText textname = version_string_display "VERSION %s" s = <version_string>
	main_menu_font = fontgrid_title_gh3
	CreateScreenElement {
		Type = TextElement
		id = version_text
		parent = main_menu_bg_container
		text = <version_string_display>
		font = <main_menu_font>
		Pos = (130.0, 600.0)
		Scale = (0.5, 0.5)
		rgba = ($menu_text_color)
		just = [left top]
		font_spacing = 0
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
		z_priority = 60
	}
endscript

script WinPortCreateLaptopUi
	FGH3Config \{sect='GFX' 'LaptopUI' #"0x1ca1ff20"=1}
	if (<value> = 0)
		return
	endif
	z = 1000000
	CreateScreenElement {
		Type = SpriteElement
		id = batteryElem
		parent = root_window
		texture = battery_charging
		Pos = (65.0, 721.0)
		Scale = (0.6600000262260437, 0.6600000262260437)
		just = [left bottom]
		z_priority = <z>
		Hide
	}
	CreateScreenElement {
		Type = SpriteElement
		id = batteryLevelElem
		parent = root_window
		texture = battery_level0
		Pos = (65.0, 721.0)
		Scale = (0.6600000262260437, 0.6600000262260437)
		just = [left bottom]
		z_priority = (<z> - 1)
		Hide
	}
	CreateScreenElement {
		Type = SpriteElement
		id = wirelessElem
		parent = root_window
		texture = wifi_bar0
		Pos = (1201.0, 716.0)
		Scale = (0.6600000262260437, 0.6600000262260437)
		just = [right bottom]
		z_priority = <z>
		Hide
	}
	spawnscriptnow \{WinPortUpdateLaptopUi}
endscript
script WinPortUpdateLaptopUi
	begin
		WinPortGetLaptopInfo
		if (<batteryPercent> > -1)
			if (<batteryCharging> = 1)
				SetScreenElementProps \{id = batteryElem unhide texture = battery_charging}
			else
				SetScreenElementProps \{id = batteryElem unhide texture = battery}
			endif
			MathFloor ((<batteryPercent> + 1)/ 12.5)
			FormatText checksumName = batteryLevelImage 'battery_level%a' a = <floor>
			SetScreenElementProps id = batteryLevelElem unhide texture = <batteryLevelImage>
		else
			SetScreenElementProps \{id = batteryElem Hide}
			SetScreenElementProps \{id = batteryLevelElem Hide}
		endif
		if (<wirelessPercent> > -1)
			MathFloor ((<wirelessPercent> + 1)/ 20)
			FormatText checksumName = wirelessImage 'wifi_bar%a' a = <floor>
			SetScreenElementProps id = wirelessElem unhide texture = <wirelessImage>
		else
			SetScreenElementProps \{id = wirelessElem Hide}
		endif
		wait \{5 seconds}
	repeat
endscript
main_menu_movie_first_time = 1
main_menu_created = 0

script create_main_menu
endscript

winport_is_in_online_menu_system = 0

script main_menu_select_winport_online
	Change \{winport_is_in_online_menu_system = 1}
	ui_flow_manager_respond_to_action \{action = select_winport_online}
endscript

script main_menu_select_exit
	ui_flow_manager_respond_to_action \{action = select_winport_exit}
endscript

script main_menu_select_options
	ui_flow_manager_respond_to_action \{action = select_options}
endscript

script create_play_song_menu
endscript

script destroy_play_song_menu
endscript

script isSinglePlayerGame
	if ($game_mode = p1_career || $game_mode = p1_quickplay || $game_mode = training)
		return \{true}
	else
		return \{FALSE}
	endif
endscript
winport_in_top_pause_menu = 0

menu_unfocus_color = [ 255 255 255 191 ]
menu_focus_color = [ 255 105 0 224 ]
default_menu_unfocus_color = [ 255 255 255 191 ]
default_menu_focus_color = [ 255 105 0 224 ]

script new_pause_menu_button \{cont_params = {} event_handlers = [] just = [left top] fit = (250.0, 0.0) pos_off = (0, 0)}
	id2 = <id>
	CreateScreenElement { <cont_params> event_handlers = <event_handlers> }
	//printstruct <...>
	CreateScreenElement {
		Type = TextElement
		parent = <id>
		font = <font>
		Scale = <scale>
		rgba = $menu_unfocus_color
		text = <text>
		id = <id2>
		just = <just>
		z_priority = <z>
		pos = <pos_off>
		exclusive_device = <player_device>
	}
	GetScreenElementDims id = <id>
	fit_text_in_rectangle {
		id = <id>
		dims = (<fit> + <height> * (0.0, 1.0))
		only_if_larger_x = 1
		start_x_scale = (<scale>.(1.0, 0.0))
		start_y_scale = (<scale>.(0.0, 1.0))
	}
	return container_id = <id>
endscript

script checkbox_sound
	s = Checkbox_
	if (<#"0x00000000">)
		ExtendCRC <s> 'Check_' out=s
	endif
	ExtendCRC <s> 'SFX' out=s
	SoundEvent event = <s>
endscript

script pause_lefty_toggle \{player = 1}
	if ($game_mode = p2_battle | $boss_battle = 1)
		ui_flow_manager_respond_to_action \{action=select_lefty_flip}
		return
	endif
	FormatText checksumName = player_status 'player%d_status' d = <Player>
	sound_event = Checkbox_
	if ($<player_status>.lefthanded_gems = 1)
		SetScreenElementProps \{id = pause_lefty_check texture = options_controller_x}
		Change \{pad_event_up_inversion = true}
	else
		extendcrc <sound_event> 'Check_' out = sound_event
		SetScreenElementProps \{id = pause_lefty_check texture = options_controller_check}
		Change \{pad_event_up_inversion = false}
	endif
	extendcrc <sound_event> 'SFX' out = sound_event
	if NOT isSinglePlayerGame
		FormatText checksumName = append '_P%d' s = <s> d = <Player>
		extendcrc <sound_event> <append> out = <sound_event>
	endif
	SoundEvent event = <sound_event>
	killspawnedscript \{name = lefty_toggle}
	spawnscriptnow lefty_toggle params = {player_status = <player_status> save}
endscript

script set_focus_color\{rgba = $menu_focus_color}
	Change menu_focus_color = <rgba>
endscript

script set_unfocus_color\{rgba = $menu_unfocus_color}
	Change menu_unfocus_color = <rgba>
endscript

particle_modes=['All' 'Minimal' 'Disabled']
extras_menu = []
script extra_format
	FormatText textname=strval '%s' s=<#"0x00000000">
	switch <type>
		case bool
			if (<#"0x00000000"> = 1)
				strval = 'On'
			elseif (<#"0x00000000"> = 0)
				strval = 'Off'
			elseif (<#"0x00000000"> = true)
				strval = 'On'
			elseif (<#"0x00000000"> = false)
				strval = 'Off'
			endif
	endswitch
	return strval = <strval>
endscript
script extra_toggle \{name='Unknown' type=bool sect='Misc' key='' step=1 restart=0}
	if (<key> = '')
		key = <name>
	endif
	value = ($<#"0x00000000">)
	switch <type>
		case bool
			switch <b>
				case choose
					//SoundEvent \{event = ui_sfx_select}
					if (<value> = 1)
						value=0
						check=0
					elseif (<value> = 0)
						value=1
						check=1
					elseif (<value> = true)
						value=false
						check=0
					elseif (<value> = false)
						value=true
						check=1
					endif
					change globalname=<#"0x00000000"> newvalue=<value>
					checkbox_sound <check>
				default
					return
			endswitch
		case int
			switch <b>
				// can cases fall into others? x to doubt
				case choose
					if (<value> >= <max>)
						value = <min>
					else
						value = (<value> + <step>)
					endif
				case left
					if (<value> <= <min>)
						return
					else
						value = (<value> - <step>)
					endif
				case right
					if (<value> >= <max>)
						return
					else
						value = (<value> + <step>)
					endif
			endswitch
			change globalname=<#"0x00000000"> newvalue=<value>
			generic_menu_up_or_down_sound
	endswitch
	if (<restart> = 1)
		DoScreenElementMorph \{id=extras_warning_container alpha=1 time=0.14}
	endif
	//printstruct <...>
	FGH3Config sect=<sect> <key> set=($<#"0x00000000">)
	extra_format ($<#"0x00000000">) type = <type>
	FormatText textname=text '%s: %v' s=<name> v=<strval>
	switch <#"0x00000000">
		case fps_max // custom format ok_bud
			if ($<#"0x00000000"> = 0)
				FormatText textname=text '%s: Unlimited' s=<name>
			endif
		case gem_scalar
			change gem_start_scale1 = ($<#"0x00000000"> * $gem_scale_orig1)
			change gem_start_scale2 = ($<#"0x00000000"> * $gem_scale_orig2)
			//if ($current_num_players = 1)
			//	change \{gem_start_scale = $gem_start_scale1}
			//else
			//	change \{gem_start_scale = $gem_start_scale2}
			//endif
			//SetGemConstants
			//TODO?: script to update gem constants
	endswitch
	if (<#"0x00000000"> = Cheat_NoFail)
		// Y U NO WORK IN SWITCH (executes half of the time, makes no sense)
		ExtendCrc hud2d_rock_bg_nofail ($player1_status.text) out=id2
		if ScreenElementExists id=<id2>
			SetScreenElementProps id=<id2> alpha=<check>
		endif
		ExtendCrc HUD2D_rock_lights_nofail ($player1_status.text) out=id2
		if ScreenElementExists id=<id2>
			SetScreenElementProps id=<id2> alpha=<check>
		endif
	endif
	if (<key> = 'NoParticles')
		FormatText textname=text '%s: %v' s=<name> v=($particle_modes[($<#"0x00000000">)])
		// WHY WAS THIS EXECUTING ON OTHER OPTIONS!!!!!!!!!!!!!!!!?!??!?!?!?!??!!
	else
		extra_format ($<#"0x00000000">) type = <type>
	endif
	if (<#"0x00000000"> = current_speedfactor)
		update_slomo
	endif
	if ScreenElementExists id=<id>
		SetScreenElementProps id=<id> text=<text>
	endif
endscript
pause_font = fontgrid_title_gh3
script create_pause_menu\{Player = 1 submenu = none}
	// I hate big scripts like this
	player_device = ($last_start_pressed_device)
	if ($player1_device = <player_device>)
		<Player> = 1
	else
		<Player> = 2
	endif
	Change \{user_control_pill_text_color = [0 0 0 255]}
	Change \{user_control_pill_color = [180 180 180 255]}
	if (<submenu> = none)
		if ($view_mode)
			return
		endif
		enable_pause
		safe_create_gh3_pause_menu
	else
		kill_start_key_binding
	endif
	if IsWinPort
		Change \{winport_in_top_pause_menu = 1}
	endif
	pause_z = 11000000
	menu_pos = (130.0, 140.0)
	menu_offset = (0.0, 0.0)
	spacing = -59
	text_scale = (0.85, 0.85)
	switch <submenu>
		case modes
			spacing = -50
			menu_offset = (250.0, 15.0)
		case extras
			spacing = -72
			text_scale = (0.63, 0.63)
	endswitch
	new_menu {
		scrollid = scrolling_pause
		vmenuid = vmenu_pause
		menu_pos = (<menu_pos> + <menu_offset>)
		rot_angle = 0
		event_handlers = [
			{pad_back ui_flow_manager_respond_to_action params = {action = go_back}}
		]
		dims = (350,740)
		spacing = <spacing>
		use_backdrop = 0
		exclusive_device = <player_device>
	}
	create_pause_menu_frame z = (<pause_z> - 10)
	if ($is_network_game = 0)
		if GotParam \{banner_text}
			pause_player_text = <banner_text>
		else
			if (<submenu> = none)
				if GotParam \{practice}
					<pause_player_text> = "Paused"
				else
					if NOT isSinglePlayerGame
						FormatText textname = pause_player_text "Player %d paused" d = <Player>
					else
						<pause_player_text> = "Paused"
					endif
				endif
			elseif (<submenu> = options)
				pause_player_text = "Options"
			elseif (<submenu> = extras)
				pause_player_text = "Extras"
			elseif ChecksumEquals a = <submenu> b = modes // why do you exist
				pause_player_text = "Change Mode"
			else
				pause_player_text = "Unknown menu"
			endif
		endif
	endif
	/*CreateScreenElement {
		Type = SpriteElement
		parent = pause_menu_frame_container
		texture = black
		alpha = 0.2
		pos = (640,360)
		dims = (1280,720)
		z = (<pause_z> - 10)
	}*///
	font = ($pause_font)
	CreateScreenElement {
		Type = TextElement
		parent = pause_menu_frame_container
		text = <pause_player_text>
		font = <font>
		just = [left top]
		Pos = (<menu_pos> + (270,-17))
		Scale = 1.2
		rgba = [255 255 255 255]
		z = (<pause_z> + 10)
	}
	CreateScreenElement {
		Type = SpriteElement
		parent = pause_menu_frame_container
		texture = FastGH3_logo
		just = [left top]
		Pos = (<menu_pos> - (10,30))
		Scale = 0.5
	}
	create_version_text z=(<pause_z> + 10)
	params_params = {
		cont_params = {Type = ContainerElement parent = vmenu_pause dims = (0.0, 100.0)}
		font = <font>
		scale = <text_scale>
		z = <pause_z>
		exclusive_device = <player_device>
		fit = (300,0)
	}
	
	// PAUSE MENU & SUBMENUS
	
	if (<submenu> = none)
		new_pause_menu_button {
			<params_params>
			id = pause_resume
			event_handlers = [
				{focus retail_menu_focus params = {id = pause_resume}}
				{focus generic_menu_up_or_down_sound}
				{unfocus retail_menu_unfocus params = {id = pause_resume}}
				{pad_choose gh3_start_pressed}
			]
			text = 'Resume'
		}
		if ($is_network_game = 0)
			new_pause_menu_button {
				<params_params>
				id = pause_restart
				event_handlers = [
					{focus retail_menu_focus params = {id = pause_restart}}
					{focus generic_menu_up_or_down_sound}
					{unfocus retail_menu_unfocus params = {id = pause_restart}}
					{pad_choose ui_flow_manager_respond_to_action params = {action = select_restart}}
				]
				text = 'Restart'
			}
			new_pause_menu_button {
				<params_params>
				id = pause_extras
				event_handlers = [
					{focus retail_menu_focus params = {id = pause_extras}}
					{focus generic_menu_up_or_down_sound}
					{unfocus retail_menu_unfocus params = {id = pause_extras}}
					{pad_choose ui_flow_manager_respond_to_action params = {action = select_extras create_params = {player_device = <player_device>}}}
				]
				text = 'Extras'
			}
		endif
		if NOT GotParam \{practice}
			if ($is_network_game = 0)
				if (($game_mode = p1_career & $boss_battle = 0)|| ($game_mode = p1_quickplay))
					new_pause_menu_button {
						<params_params>
						id = pause_practice
						event_handlers = [
							{focus retail_menu_focus params = {id = pause_practice}}
							{focus generic_menu_up_or_down_sound}
							{unfocus retail_menu_unfocus params = {id = pause_practice}}
							{pad_choose ui_flow_manager_respond_to_action params = {action = select_practice}}
						]
						text = 'Practice'
					}
				endif
				new_pause_menu_button {
					<params_params>
					id = pause_mode
					event_handlers = [
						{focus retail_menu_focus params = {id = pause_mode}}
						{focus generic_menu_up_or_down_sound}
						{unfocus retail_menu_unfocus params = {id = pause_mode}}
						{pad_choose ui_flow_manager_respond_to_action params = {action = select_modes create_params = {player_device = <player_device>}}}
					]
					text = 'Change Mode'
				}
				new_pause_menu_button {
					<params_params>
					id = pause_options
					event_handlers = [
						{focus retail_menu_focus params = {id = pause_options}}
						{focus generic_menu_up_or_down_sound}
						{unfocus retail_menu_unfocus params = {id = pause_options}}
						{pad_choose ui_flow_manager_respond_to_action params = {action = select_options create_params = {player_device = <player_device>}}}
					]
					text = 'Options'
				}
			endif
			quit_script = ui_flow_manager_respond_to_action
			quit_script_params = {action = select_quit create_params = {Player = <Player>}}
			/*if ($is_network_game)
				quit_script = create_leaving_lobby_dialog
				quit_script_params = {
					create_pause_menu
					pad_back_script = return_to_pause_menu_from_net_warning
					pad_choose_script = pause_menu_really_quit_net_game
					z = 300
				}
			endif*///
			new_pause_menu_button {
				<params_params>
				id = pause_quit
				event_handlers = [
					{focus retail_menu_focus params = {id = pause_quit}}
					{focus generic_menu_up_or_down_sound}
					{unfocus retail_menu_unfocus params = {id = pause_quit}}
					{pad_choose <quit_script> params = <quit_script_params>}
				]
				text = 'Exit'
			}
		else
			new_pause_menu_button {
				<params_params>
				id = practice_loop_button
				event_handlers = [
					{focus retail_menu_focus params = {id = practice_loop_button}}
					{focus generic_menu_up_or_down_sound}
					{unfocus retail_menu_unfocus params = {id = practice_loop_button}}
					{pad_choose practice_loop_toggle}
				]
			}
			practice_loop_setprop
			FormatText textname = text 'Return to %s' s = ($richpres_modes.$practice_last_mode.#"0x00000000") // ez
			new_pause_menu_button {
				<params_params>
				id = pause_return
				event_handlers = [
					{focus retail_menu_focus params = {id = pause_return}}
					{focus generic_menu_up_or_down_sound}
					{unfocus retail_menu_unfocus params = {id = pause_return}}
					{pad_choose ui_flow_manager_respond_to_action params = {action = select_return}}
				]
				text = <text>
			}
			new_pause_menu_button {
				<params_params>
				id = pause_options
				event_handlers = [
					{focus retail_menu_focus params = {id = pause_options}}
					{focus generic_menu_up_or_down_sound}
					{unfocus retail_menu_unfocus params = {id = pause_options}}
					{pad_choose ui_flow_manager_respond_to_action params = {action = select_options create_params = {player_device = <player_device>}}}
				]
				text = 'Options'
			}
			new_pause_menu_button {
				<params_params>
				id = pause_change_speed
				event_handlers = [
					{focus retail_menu_focus params = {id = pause_change_speed}}
					{focus generic_menu_up_or_down_sound}
					{unfocus retail_menu_unfocus params = {id = pause_change_speed}}
					{pad_choose ui_flow_manager_respond_to_action params = {action = select_change_speed}}
				]
				text = 'Change Speed'
			}
			new_pause_menu_button {
				<params_params>
				id = pause_change_section
				event_handlers = [
					{focus retail_menu_focus params = {id = pause_change_section}}
					{focus generic_menu_up_or_down_sound}
					{unfocus retail_menu_unfocus params = {id = pause_change_section}}
					{pad_choose ui_flow_manager_respond_to_action params = {action = select_change_section}}
				]
				text = 'Change Section'
			}
			new_pause_menu_button {
				<params_params>
				id = pause_quit
				event_handlers = [
					{focus retail_menu_focus params = {id = pause_quit}}
					{focus generic_menu_up_or_down_sound}
					{unfocus retail_menu_unfocus params = {id = pause_quit}}
					{pad_choose ui_flow_manager_respond_to_action params = {action = select_quit}}
				]
				text = 'Quit'
			}
		endif
		if ($enable_button_cheats = 1)
			new_pause_menu_button {
				<params_params>
				id = pause_debug_menu
				event_handlers = [
					{focus retail_menu_focus params = {id = pause_debug_menu}}
					{focus generic_menu_up_or_down_sound}
					{unfocus retail_menu_unfocus params = {id = pause_debug_menu}}
					{pad_choose ui_flow_manager_respond_to_action params = {action = select_debug_menu}}
				]
				text = '__debug'
			}
		endif
		add_user_control_helper \{text = $menu_text_sel button = green z = 100000}
		add_user_control_helper \{text = 'Unpause' button = start z = 100000}
		add_user_control_helper \{text = $menu_text_nav button = strumbar z = 100000}
	else
		add_user_control_helper \{text = $menu_text_sel button = green z = 100000}
		add_user_control_helper \{text = $menu_text_back button = red z = 100000}
		switch <submenu>
			case options
				<fit_dims> = (400.0, 0.0)
				new_pause_menu_button {
					<params_params>
					id = options_audio
					event_handlers = [
						{focus retail_menu_focus params = {id = options_audio}}
						{focus generic_menu_up_or_down_sound}
						{unfocus retail_menu_unfocus params = {id = options_audio}}
						{pad_choose ui_flow_manager_respond_to_action params = {action = select_audio_settings create_params = {Player = <Player>}}}
					]
					text = 'Volume'
				}
				new_pause_menu_button {
					<params_params>
					id = options_calibrate_lag
					event_handlers = [
						{focus retail_menu_focus params = {id = options_calibrate_lag}}
						{focus generic_menu_up_or_down_sound}
						{unfocus retail_menu_unfocus params = {id = options_calibrate_lag}}
						{pad_choose ui_flow_manager_respond_to_action params = {action = select_calibrate_lag create_params = {Player = <Player>}}}
					]
					text = 'Calibrate video lag'
				}
				new_pause_menu_button {
					<params_params>
					id = winport_options_calibrate_lag
					event_handlers = [
						{focus retail_menu_focus params = {id = winport_options_calibrate_lag}}
						{focus generic_menu_up_or_down_sound}
						{unfocus retail_menu_unfocus params = {id = winport_options_calibrate_lag}}
						{pad_choose ui_flow_manager_respond_to_action params = {action = winport_select_calibrate_lag create_params = {Player = <Player>}}}
					]
					text = 'Calibrate audio lag'
				}
				if IsGuitarController controller = <player_device>
					if NOT WinPortSioIsKeyboard deviceNum = <player_device>
						new_pause_menu_button {
							<params_params>
							id = options_calibrate_whammy
							event_handlers = [
								{focus retail_menu_focus params = {id = options_calibrate_whammy}}
								{focus generic_menu_up_or_down_sound}
								{unfocus retail_menu_unfocus params = {id = options_calibrate_whammy}}
								{pad_choose ui_flow_manager_respond_to_action params = {action = select_calibrate_whammy_bar create_params = {Player = <Player> popup = 1}}}
							]
							text = 'Calibrate whammy'
						}
						/*new_pause_menu_button {
							<params_params>
							id = winport_options_calibrate_tilt
							event_handlers = [
								{focus retail_menu_focus params = {id = winport_options_calibrate_tilt}}
								{focus generic_menu_up_or_down_sound}
								{unfocus retail_menu_unfocus params = {id = winport_options_calibrate_tilt}}
								{pad_choose ui_flow_manager_respond_to_action params = {action = select_calibrate_star_power_trigger create_params = {Player = <Player>}}}
							]
							text = 'Calibrate guitar tilt'
						}*///
					endif
				endif
				if isSinglePlayerGame
					lefty_flip_text = "Lefty flip:"
				else
					if (<Player> = 1)
						lefty_flip_text = "P1 Lefty:"
					else
						lefty_flip_text = "P2 Lefty:"
					endif
				endif
				CreateScreenElement {
					Type = ContainerElement
					parent = vmenu_pause
					dims = (0.0, 100.0)
					event_handlers = [
						{focus retail_menu_focus params = {id = pause_options_lefty}}
						{focus generic_menu_up_or_down_sound}
						{unfocus retail_menu_unfocus params = {id = pause_options_lefty}}
						{pad_choose pause_lefty_toggle params = {player = <player>}}
					]
				}
				<lefty_container> = <id>
				CreateScreenElement {
					Type = TextElement
					parent = <lefty_container>
					id = pause_options_lefty
					font = <font>
					Scale = <text_scale>
					rgba = $menu_unfocus_color
					text = <lefty_flip_text>
					just = [left top]
					z_priority = <pause_z>
					exclusive_device = <player_device>
				}
				GetScreenElementDims id = <id>
				fit_text_in_rectangle id = <id> dims = (<fit_dims> + <height> * (0.0, 1.0))only_if_larger_x = 1 start_x_scale = (<text_scale>.(1.0, 0.0))start_y_scale = (<text_scale>.(0.0, 1.0))
				if (<Player> = 1)
					if ($p1_lefty = 1)
						lefty_tex = options_controller_check
					else
						lefty_tex = options_controller_x
					endif
				else
					if ($p2_lefty = 1)
						lefty_tex = options_controller_check
					else
						lefty_tex = options_controller_x
					endif
				endif
				displaySprite {
					parent = <lefty_container>
					tex = <lefty_tex>
					id = pause_lefty_check
					just = [center center]
					z = (<pause_z> + 10)
				}
				GetScreenElementDims \{id = pause_options_lefty}
				<id> ::SetProps Pos = (<width> * (1.0, 0.0) + (22.0, 24.0))
				/*if NOT ($end_credits = 1)
					new_pause_menu_button {
						<params_params>
						id = pause_credits
						event_handlers = [
							{focus retail_menu_focus params = {id = pause_credits}}
							{focus generic_menu_up_or_down_sound}
							{unfocus retail_menu_unfocus params = {id = pause_credits}}
							{pad_choose ui_flow_manager_respond_to_action params = {action = select_credits create_params = {player_device = <player_device>}}}
						]
						text = 'Credits'
					}
				endif*///
				new_pause_menu_button {
					<params_params>
					id = options_exit
					event_handlers = [
						{focus retail_menu_focus params = {id = options_exit}}
						{focus generic_menu_up_or_down_sound}
						{unfocus retail_menu_unfocus params = {id = options_exit}}
						{pad_choose ui_flow_manager_respond_to_action params = {action = go_back}}
					]
					text = 'Back'
				}
			case modes
				params_params = {
					<params_params> scale=0.8
				}
				titles = [
					'Game Mode: '
					'Players: '
					'Controllers: '
					'Difficulty:'
					'Instrument(s): '
					'Autoplay: '
				]
				getarraysize \{titles}
				i = 0
				begin
					CreateScreenElement {
						Type = TextElement
						parent = pause_menu_frame_container
						text = (<titles>[<i>])
						font = <font>
						just = [right top]
						Pos = (<menu_pos> + ((230,64) + ((0, 50) * <i>)))
						Scale = 0.8
						rgba = [255 255 255 255]
						z = (<pause_z> + 10)
					}
					Increment \{i}
				repeat <array_size>
				buttons = ($mode_buttons)
				GetArraySize \{buttons}
				i = 0
				begin
					params = (<buttons>[<i>])
					id = (<params>.id)
					if StructureContains \{structure=params cont}
						cont = (<params>.cont)
					else
						cont = {}
					endif
					if StructureContains \{structure=params texts}
						texts = (<params>.texts) // unironically die
						text = ($<texts>[($mode_setup.(<params>.param))])
					else
						text = (<params>.text)
					endif
					new_pause_menu_button {
						<params_params>
						id = <id>
						event_handlers = [
							{focus		retail_menu_focus params = {id = <id>}}
							{focus		generic_menu_up_or_down_sound}
							{unfocus	retail_menu_unfocus params = {id = <id> unfocus}}
							{pad_choose	mode_menu params = { <params> select } }
							{pad_left	mode_menu params = { <params> left } }
							{pad_right	mode_menu params = { <params> right } }
						]
						<cont>
						text = <text>
					}
					if (<id> = select_players)
						ctrls_container = <container_id>
					endif
					Increment \{i}
				repeat <array_size>
				controller_texture ($mode_setup.devices[0])
				p1_tex = <texture>
				controller_texture ($mode_setup.devices[1])
				p2_tex = <texture>
				CreateScreenElement {
					Type = SpriteElement
					parent = <ctrls_container>
					id = p1_icon
					texture = <p1_tex>
					just = [left bottom]
					Pos = (130.0, 60.0)
					Scale = 0.6
				}
				CreateScreenElement {
					Type = SpriteElement
					parent = <ctrls_container>
					id = p2_icon
					texture = <p2_tex>
					just = [left bottom]
					Pos = (220.0, 60.0)
					Scale = 0.6
				}
				if ScreenElementExists id=p2_icon // :/
					SetScreenElementProps id=p2_icon alpha=($mode_setup.players)
				endif
				add_user_control_helper \{text = ' Cycle Option' button = leftright z = 100000}
			case extras
				//params_params = {<params_params> scale=0.7}
				
				// toggleables
				menu = ($extras_menu)
				GetArraySize \{menu}
				i = 0
				begin
					item = (<menu>[<i>])
					value = (<item>.#"0x00000000")
					value = ($<value>) // wtf
					extra_format <value> type = (<item>.type)
					FormatText textname=text '%s: %v' s=(<item>.name) v=<strval>
					FormatText checksumname=exid 'extras_%i' i=<i>
					new_pause_menu_button {
						<params_params>
						id = <exid>
						event_handlers = [
							{focus retail_menu_focus params = {id = <exid>}}
							{focus generic_menu_up_or_down_sound}
							{unfocus retail_menu_unfocus params = {id = <exid>}}
							{pad_choose extra_toggle params = {id = <exid> <item> b=choose}} // bool toggles
							{pad_left extra_toggle params = {id = <exid> <item> b=left}} // for integers
							{pad_right extra_toggle params = {id = <exid> <item> b=right}} //
						]
						text = <text>
					}
					Increment \{i}
				repeat <array_size>
				
				FormatText textname=text 'Particles: %v' v=($particle_modes[$disable_particles])
				FormatText \{checksumname=id 'extras_%i' i=2}
				SetScreenElementProps id=extras_2 text=<text>
				
				add_user_control_helper \{text = ' Cycle Option' button = leftright z = 100000}
				
				CreateScreenElement \{Type = ContainerElement id = extras_warning_container parent = pause_menu_frame_container alpha = 0 Scale = 0.35 Pos = (640.0, 540.0)}
				displaySprite \{parent = extras_warning_container id = extras_warning tex = control_pill_body Pos = (0.0, 0.0) just = [center center] rgba = [96 0 0 255] z = 100}
				CreateScreenElement {
					Type = TextBlockElement
					id = first_warning
					parent = extras_warning_container
					font = text_a4
					Scale = 1.5
					text = 'Warning: Some changed extras require restarting the song!'
					rgba = [255 101 0 255]
					just = [center center]
					z_priority = 101
					Pos = (0.0, -20.0)
					dims = (600.0, 100.0)
					allow_expansion
				}
				GetScreenElementDims \{id = first_warning}
				bg_dims = (<width> * (1.0, 0.0) + (<height> * (0.0, 1.0) + (0.0, 40.0)))
				extras_warning ::SetProps dims = <bg_dims>
				displaySprite {
					parent = extras_warning_container
					tex = control_pill_end
					Pos = (-1 * <width> * (0.5, 0.0))
					rgba = [96 0 0 255]
					dims = ((96.0, 0.0) + (<height> * (0.0, 1.0) + (0.0, 40.0)))
					just = [right center]
					flip_v
					z = 100
				}
				displaySprite {
					parent = extras_warning_container
					tex = control_pill_end
					Pos = (<width> * (0.5, 0.0))
					rgba = [96 0 0 255]
					dims = ((96.0, 0.0) + (<height> * (0.0, 1.0) + (0.0, 40.0)))
					just = [left center]
					z = 100
				}
		endswitch
		add_user_control_helper \{text = $menu_text_nav button = strumbar z = 100000}
	endif
	
	
	
	if ($is_network_game = 0)
		if NOT isSinglePlayerGame
			if NOT GotParam \{practice}
				FormatText textname = player_paused_text 'PLAYER %d PAUSED. ONLY PLAYER %d OPTIONS ARE AVAILABLE.' d = <Player>
				displaySprite {
					parent = pause_menu_frame_container
					id = pause_helper_text_bg
					tex = control_pill_body
					Pos = (640.0, 600.0)
					just = [center center]
					rgba = [96 0 0 255]
					z = (<pause_z> + 10)
				}
				displayText {
					parent = pause_menu_frame_container
					Pos = (640.0, 604.0)
					just = [center center]
					text = <player_paused_text>
					rgba = [186 105 0 255]
					Scale = (0.45000001788139343, 0.6000000238418579)
					z = (<pause_z> + 11)
					font = <font>
				}
				GetScreenElementDims id = <id>
				bg_dims = (<width> * (1.0, 0.0) + (0.0, 32.0))
				pause_helper_text_bg ::SetProps dims = <bg_dims>
				displaySprite {
					parent = pause_menu_frame_container
					tex = control_pill_end
					Pos = ((640.0, 600.0) - <width> * (0.5, 0.0))
					rgba = [96 0 0 255]
					just = [right center]
					flip_v
					z = (<pause_z> + 10)
				}
				displaySprite {
					parent = pause_menu_frame_container
					tex = control_pill_end
					Pos = ((640.0, 601.0) + <width> * (0.5, 0.0))
					rgba = [96 0 0 255]
					just = [left center]
					z = (<pause_z> + 10)
				}
			endif
		endif
	endif
	Change \{menu_choose_practice_destroy_previous_menu = 1}
endscript

script destroy_pause_menu
	restore_start_key_binding
	clean_up_user_control_helpers
	destroy_pause_menu_frame
	destroy_menu \{menu_id = scrolling_pause}
	//destroy_menu \{menu_id = pause_menu_frame_container}
	if ScreenElementExists \{id = warning_message_container}
		DestroyScreenElement \{id = warning_message_container}
	endif
	if ScreenElementExists \{id = leaving_lobby_dialog_menu}
		DestroyScreenElement \{id = leaving_lobby_dialog_menu}
	endif
	destroy_pause_menu_frame \{container_id = net_quit_warning}
	if IsWinPort
		Change \{winport_in_top_pause_menu = 0}
	endif
endscript

script create_menu_backdrop\{texture = venue_bg rgba = [255 255 255 255] z = 0}
	if ScreenElementExists \{id = menu_backdrop_container}
		DestroyScreenElement \{id = menu_backdrop_container}
	endif
	CreateScreenElement \{Type = ContainerElement parent = root_window id = menu_backdrop_container Pos = (0.0, 0.0) just = [left top]}
	CreateScreenElement {
		Type = SpriteElement
		parent = menu_backdrop_container
		id = menu_backdrop
		texture = <texture>
		rgba = <rgba>
		Pos = (640.0, 360.0)
		dims = (1280.0, 720.0)
		just = [center center]
		z_priority = <z>
	}
endscript

script destroy_menu_backdrop
	if ScreenElementExists \{id = menu_backdrop_container}
		DestroyScreenElement \{id = menu_backdrop_container}
	endif
endscript

script create_pause_menu_frame\{x_scale = 1 y_scale = 1 tile_sprite = 1 container_id = pause_menu_frame_container z = 0 gradient = 1 parent = root_window}
	CreateScreenElement {
		Type = ContainerElement
		parent = <parent>
		id = <container_id>
		Pos = (0.0, 0.0)
		just = [left top]
		z_priority = <z>
	}
endscript

script destroy_pause_menu_frame\{container_id = pause_menu_frame_container}
	destroy_menu menu_id = <container_id>
endscript

script retail_menu_focus
	if GotParam \{id}
		if ScreenElementExists id = <id>
			SetScreenElementProps id = <id> rgba = ($menu_focus_color)
		endif
	else
		GetTags
		printstruct <...>
		SetScreenElementProps id = <id> rgba = ($menu_focus_color)
	endif
endscript

script retail_menu_unfocus
	if GotParam \{id}
		if ScreenElementExists id = <id>
			SetScreenElementProps id = <id> rgba = ($menu_unfocus_color)
		endif
	else
		GetTags
		SetScreenElementProps id = <id> rgba = ($menu_unfocus_color)
	endif
endscript

script fit_text_in_rectangle\{dims = (100.0, 100.0) just = center keep_ar = 0 only_if_larger_x = 0 only_if_larger_y = 0 start_x_scale = 1.0 start_y_scale = 1.0}
	if NOT GotParam \{id}
		ScriptAssert \{'No id passed to fit_text_in_rectangle!'}
	endif
	GetScreenElementDims id = <id>
	x_dim = (<dims>.(1.0, 0.0))
	y_dim = (<dims>.(0.0, 1.0))
	x_scale = (<x_dim> / <width>)
	if (<keep_ar> = 1)
		y_scale = <x_scale>
	else
		y_scale = (<y_dim> / <height>)
	endif
	if GotParam \{debug_me}
		printstruct <...>
	endif
	if (<only_if_larger_x> = 1)
		if (<x_scale> > 1)
			return
		endif
	elseif (<only_if_larger_y> = 1)
		if (<y_scale> > 1)
			return
		endif
	endif
	if (<just> = center)
		if GotParam \{Pos}
		endif
	endif
	scale_pair = ((1.0, 0.0) * <x_scale> * <start_x_scale> + (0.0, 1.0) * <y_scale> * <start_y_scale>)
	SetScreenElementProps {
		id = <id>
		Scale = <scale_pair>
	}
	if GotParam \{Pos}
		SetScreenElementProps id = <id> Pos = <Pos>
	endif
endscript
num_user_control_helpers = 0
user_control_text_font = fontgrid_title_gh3
user_control_pill_color = [
	20
	20
	20
	155
]
user_control_pill_text_color = [
	180
	180
	180
	255
]
user_control_auto_center = 1
user_control_super_pill = 0
user_control_pill_y_position = 630
user_control_pill_scale = 0.4
user_control_pill_end_width = 50
user_control_pill_gap = 150
user_control_super_pill_gap = 0.4
pill_helper_max_width = 100

script clean_up_user_control_helpers
	if ScreenElementExists \{id = user_control_container}
		DestroyScreenElement \{id = user_control_container}
	endif
	Change \{user_control_pill_gap = 150}
	Change \{pill_helper_max_width = 100}
	Change \{num_user_control_helpers = 0}
	Change \{user_control_pill_color = [20 20 20 155]}
	Change \{user_control_pill_text_color = [180 180 180 255]}
	Change \{user_control_auto_center = 1}
	Change \{user_control_super_pill = 0}
	Change \{user_control_pill_y_position = 630}
	Change \{user_control_pill_scale = 0.4}
endscript

script add_user_control_helper\{z = 10 pill = 1 fit_to_rectangle = 1}
	Scale = ($user_control_pill_scale)
	Pos = ((0.0, 1.0) * ($user_control_pill_y_position))
	buttonoff = (0.0, 0.0)
	if NOT ScreenElementExists \{id = user_control_container}
		CreateScreenElement \{id = user_control_container Type = ContainerElement parent = root_window Pos = (0.0, 0.0)}
	endif
	if GotParam \{button}
		switch (<button>)
			case green
				buttonchar = '\m0'
			case red
				buttonchar = '\m1'
			case yellow
				buttonchar = '\b6'
			case blue
				buttonchar = '\b7'
			case orange
				buttonchar = '\b8'
			case strumbar
				buttonchar = '\bb'
				offset_for_strumbar = 1
			case start
				buttonchar = '\ba'
				offset_for_strumbar = 1
			case leftright
				buttonchar = '\bh'
		endswitch
	else
		buttonchar = ''
	endif
	if (<pill> = 0)
		CreateScreenElement {
			Type = TextElement
			parent = user_control_container
			text = <buttonchar>
			Pos = (<Pos> + (-10.0, 8.0) * <Scale> + <buttonoff>)
			Scale = (1 * <Scale>)
			rgba = [255 255 255 255]
			font = ($gh3_button_font)
			just = [left top]
			z_priority = (<z> + 0.1)
		}
		CreateScreenElement {
			Type = TextElement
			parent = user_control_container
			text = <text>
			rgba = $user_control_pill_text_color
			Scale = (1.1 * <Scale>)
			Pos = (<Pos> + (50.0, 0.0) * <Scale> + (0.0, 20.0) * <Scale>)
			font = ($user_control_text_font)
			z_priority = (<z> + 0.1)
			just = [left top]
		}
		if (<fit_to_rectangle> = 1)
			SetScreenElementProps id = <id> Scale = (1.1 * <Scale>)
			GetScreenElementDims id = <id>
			if (<width> > $pill_helper_max_width)
				fit_text_in_rectangle id = <id> dims = ($pill_helper_max_width * (0.5, 0.0) + <height> * (0.0, 1.0) * $user_control_pill_scale)
			endif
		endif
	else
		if (($user_control_super_pill = 0)& ($user_control_auto_center = 0))
			CreateScreenElement {
				Type = TextElement
				parent = user_control_container
				text = <text>
				id = <textid>
				rgba = $user_control_pill_text_color
				Scale = (1.1 * <Scale>)
				Pos = (<Pos> + (50.0, 0.0) * <Scale> + (0.0, 20.0) * <Scale>)
				font = ($user_control_text_font)
				z_priority = (<z> + 0.1)
				just = [left top]
			}
			textid = <id>
			if (<fit_to_rectangle> = 1)
				SetScreenElementProps id = <id> Scale = (1.1 * <Scale>)
				GetScreenElementDims id = <id>
				if (<width> > $pill_helper_max_width)
					fit_text_in_rectangle id = <id> dims = ($pill_helper_max_width * (0.5, 0.0) + <height> * (0.0, 1.0) * $user_control_pill_scale)
				endif
			endif
			CreateScreenElement {
				Type = TextElement
				parent = user_control_container
				id = <buttonid>
				text = <buttonchar>
				Pos = (<Pos> + (-10.0, 8.0) * <Scale> + <buttonoff>)
				Scale = (1 * <Scale>)
				rgba = [255 255 255 255]
				font = ($gh3_button_font)
				just = [left top]
				z_priority = (<z> + 0.1)
			}
			buttonid = <id>
			if GotParam \{offset_for_strumbar}
				<textid> ::SetTags is_strumbar = 1
				fastscreenelementpos id = <textid> absolute
				SetScreenElementProps id = <textid> Pos = (<ScreenElementPos> + (50.0, 0.0) * <Scale>)
			else
			endif
			fastscreenelementpos id = <buttonid> absolute
			top_left = <ScreenElementPos>
			fastscreenelementpos id = <textid> absolute
			bottom_right = <ScreenElementPos>
			GetScreenElementDims id = <textid>
			bottom_right = (<bottom_right> + (1.0, 0.0) * <width> + (0.0, 1.0) * <height>)
			pill_width = ((1.0, 0.0).<bottom_right> - (1.0, 0.0).<top_left>)
			pill_height = ((0.0, 1.0).<bottom_right> - (0.0, 1.0).<top_left>)
			pill_y_offset = (<pill_height> * 0.2)
			pill_height = (<pill_height> + <pill_y_offset>)
			<Pos> = (<Pos> + (0.0, 1.0) * (<Scale> * 3))
			CreateScreenElement {
				Type = SpriteElement
				parent = user_control_container
				texture = control_pill_body
				dims = ((1.0, 0.0) * <pill_width> + (0.0, 1.0) * <pill_height>)
				Pos = (<Pos> + (0.0, -0.5) * <pill_y_offset>)
				rgba = ($user_control_pill_color)
				just = [left top]
				z_priority = <z>
			}
			CreateScreenElement {
				Type = SpriteElement
				parent = user_control_container
				texture = control_pill_end
				dims = ((1.0, 0.0) * (<Scale> * $user_control_pill_end_width)+ (0.0, 1.0) * <pill_height>)
				Pos = (<Pos> + (0.0, -0.5) * <pill_y_offset>)
				rgba = ($user_control_pill_color)
				just = [right top]
				z_priority = <z>
				flip_v
			}
			CreateScreenElement {
				Type = SpriteElement
				parent = user_control_container
				texture = control_pill_end
				dims = ((1.0, 0.0) * (<Scale> * $user_control_pill_end_width)+ (0.0, 1.0) * <pill_height>)
				Pos = (<Pos> + (0.0, -0.5) * <pill_y_offset> + (1.0, 0.0) * <pill_width>)
				rgba = ($user_control_pill_color)
				just = [left top]
				z_priority = <z>
			}
		else
			FormatText checksumName = textid 'uc_text_%d' d = ($num_user_control_helpers)
			CreateScreenElement {
				Type = TextElement
				parent = user_control_container
				text = <text>
				id = <textid>
				rgba = $user_control_pill_text_color
				Scale = (1.1 * <Scale>)
				Pos = (<Pos> + (50.0, 0.0) * <Scale> + (0.0, 20.0) * <Scale>)
				font = ($user_control_text_font)
				z_priority = (<z> + 0.1)
				just = [left top]
			}
			if (<fit_to_rectangle> = 1)
				SetScreenElementProps id = <id> Scale = (1.1 * <Scale>)
				GetScreenElementDims id = <id>
				if (<width> > $pill_helper_max_width)
					fit_text_in_rectangle id = <id> dims = ($pill_helper_max_width * (0.5, 0.0) + <height> * (0.0, 1.0) * $user_control_pill_scale)
				endif
			endif
			FormatText checksumName = buttonid 'uc_button_%d' d = ($num_user_control_helpers)
			CreateScreenElement {
				Type = TextElement
				parent = user_control_container
				id = <buttonid>
				text = <buttonchar>
				Pos = (<Pos> + (-10.0, 8.0) * <Scale> + <buttonoff>)
				Scale = (1.2 * <Scale>)
				rgba = [255 255 255 255]
				font = ($gh3_button_font)
				just = [left top]
				z_priority = (<z> + 0.1)
			}
			if GotParam \{offset_for_strumbar}
				<textid> ::SetTags is_strumbar = 1
				fastscreenelementpos id = <textid> absolute
				SetScreenElementProps id = <textid> Pos = (<ScreenElementPos> + (50.0, 0.0) * <Scale>)
			endif
			Change num_user_control_helpers = ($num_user_control_helpers + 1)
		endif
	endif
	if ($user_control_super_pill = 1)
		user_control_build_super_pill z = <z>
	elseif ($user_control_auto_center = 1)
		user_control_build_pills z = <z>
	endif
endscript

script user_control_cleanup_pills
	destroy_menu \{menu_id = user_control_super_pill_object_main}
	destroy_menu \{menu_id = user_control_super_pill_object_l}
	destroy_menu \{menu_id = user_control_super_pill_object_r}
	index = 0
	if NOT ($num_user_control_helpers = 0)
		begin
			FormatText checksumName = pill_id 'uc_pill_%d' d = <index>
			if ScreenElementExists id = <pill_id>
				DestroyScreenElement id = <pill_id>
			endif
			FormatText checksumName = pill_l_id 'uc_pill_l_%d' d = <index>
			if ScreenElementExists id = <pill_l_id>
				DestroyScreenElement id = <pill_l_id>
			endif
			FormatText checksumName = pill_r_id 'uc_pill_r_%d' d = <index>
			if ScreenElementExists id = <pill_r_id>
				DestroyScreenElement id = <pill_r_id>
			endif
			<index> = (<index> + 1)
		repeat ($num_user_control_helpers)
	endif
endscript
action_safe_width_for_helpers = 925

script user_control_build_pills
	user_control_cleanup_pills
	Scale = ($user_control_pill_scale)
	index = 0
	max_pill_width = 0
	if NOT ($num_user_control_helpers = 0)
		begin
			FormatText checksumName = textid 'uc_text_%d' d = <index>
			FormatText checksumName = buttonid 'uc_button_%d' d = <index>
			fastscreenelementpos id = <buttonid> absolute
			top_left = <ScreenElementPos>
			fastscreenelementpos id = <textid> absolute
			bottom_right = <ScreenElementPos>
			GetScreenElementDims id = <textid>
			bottom_right = (<bottom_right> + (1.0, 0.0) * <width> + (0.0, 1.0) * <height>)
			pill_width = ((1.0, 0.0).<bottom_right> - (1.0, 0.0).<top_left>)
			if (<pill_width> > <max_pill_width>)
				<max_pill_width> = (<pill_width>)
			endif
			<index> = (<index> + 1)
		repeat ($num_user_control_helpers)
	endif
	<total_width> = (((<max_pill_width> + (<Scale> * $user_control_pill_end_width * 2))* ($num_user_control_helpers))+ (($user_control_pill_gap * <Scale>)* ($num_user_control_helpers - 1)))
	if (<total_width> > $action_safe_width_for_helpers)
		<max_pill_width> = ((($action_safe_width_for_helpers - (($user_control_pill_gap * <Scale>)* ($num_user_control_helpers - 1)))/ ($num_user_control_helpers))- (<Scale> * $user_control_pill_end_width * 2))
	endif
	index = 0
	initial_pill_x = (640 + -1 * (($num_user_control_helpers / 2.0)* <max_pill_width>)- ((0.5 * $user_control_pill_gap * <Scale>)* ($num_user_control_helpers -1)))
	Pos = ((1.0, 0.0) * <initial_pill_x> + (0.0, 1.0) * ($user_control_pill_y_position)+ (0.0, 0.800000011920929) * (<Scale>))
	if NOT ($num_user_control_helpers = 0)
		begin
			FormatText checksumName = pill_id 'uc_pill_%d' d = <index>
			FormatText checksumName = pill_l_id 'uc_pill_l_%d' d = <index>
			FormatText checksumName = pill_r_id 'uc_pill_r_%d' d = <index>
			FormatText checksumName = textid 'uc_text_%d' d = <index>
			FormatText checksumName = buttonid 'uc_button_%d' d = <index>
			fastscreenelementpos id = <buttonid> absolute
			top_left = <ScreenElementPos>
			fastscreenelementpos id = <textid> absolute
			bottom_right = <ScreenElementPos>
			GetScreenElementDims id = <textid>
			bottom_right = (<bottom_right> + (1.0, 0.0) * <width> + (0.0, 1.0) * <height>)
			pill_width = (<max_pill_width>)
			pill_height = ((0.0, 1.0).<bottom_right> - (0.0, 1.0).<top_left>)
			pill_y_offset = (<pill_height> * 0.2)
			pill_height = (<pill_height> + <pill_y_offset>)
			CreateScreenElement {
				Type = SpriteElement
				parent = user_control_container
				id = <pill_id>
				texture = control_pill_body
				dims = ((1.0, 0.0) * <pill_width> + (0.0, 1.0) * <pill_height>)
				Pos = (<Pos> + (0.0, -0.5) * <pill_y_offset>)
				rgba = ($user_control_pill_color)
				just = [left top]
				z_priority = <z>
			}
			CreateScreenElement {
				Type = SpriteElement
				parent = user_control_container
				id = <pill_l_id>
				texture = control_pill_end
				dims = ((1.0, 0.0) * (<Scale> * $user_control_pill_end_width)+ (0.0, 1.0) * <pill_height>)
				Pos = (<Pos> + (0.0, -0.5) * <pill_y_offset>)
				rgba = ($user_control_pill_color)
				just = [right top]
				z_priority = <z>
				flip_v
			}
			CreateScreenElement {
				Type = SpriteElement
				parent = user_control_container
				id = <pill_r_id>
				texture = control_pill_end
				dims = ((1.0, 0.0) * (<Scale> * $user_control_pill_end_width)+ (0.0, 1.0) * <pill_height>)
				Pos = (<Pos> + (0.0, -0.5) * <pill_y_offset> + (1.0, 0.0) * <max_pill_width>)
				rgba = ($user_control_pill_color)
				just = [left top]
				z_priority = <z>
			}
			<index> = (<index> + 1)
			Pos = (<Pos> + (1.0, 0.0) * ($user_control_pill_gap * <Scale> + <max_pill_width>))
		repeat ($num_user_control_helpers)
	endif
	index = 0
	if NOT ($num_user_control_helpers = 0)
		begin
			align_user_control_with_pill pill_index = <index>
			<index> = (<index> + 1)
		repeat ($num_user_control_helpers)
	endif
endscript

script align_user_control_with_pill
	FormatText checksumName = pill_id 'uc_pill_%d' d = <pill_index>
	fastscreenelementpos id = <pill_id> absolute
	GetScreenElementDims id = <pill_id>
	pill_midpoint_x = (<ScreenElementPos>.(1.0, 0.0) + 0.5 * <width>)
	align_user_control_with_x X = <pill_midpoint_x> pill_index = <pill_index>
endscript

script align_user_control_with_x
	FormatText checksumName = textid 'uc_text_%d' d = <pill_index>
	FormatText checksumName = buttonid 'uc_button_%d' d = <pill_index>
	fastscreenelementpos id = <buttonid> absolute
	top_left = <ScreenElementPos>
	button_pos = <ScreenElementPos>
	fastscreenelementpos id = <textid> absolute
	bottom_right = <ScreenElementPos>
	text_pos = <ScreenElementPos>
	GetScreenElementDims id = <textid>
	bottom_right = (<bottom_right> + (1.0, 0.0) * <width> + (0.0, 1.0) * <height>)
	pill_width = ((1.0, 0.0).<bottom_right> - (1.0, 0.0).<top_left>)
	text_button_midpoint = (<top_left>.(1.0, 0.0) + 0.5 * <pill_width>)
	midpoint_diff = (<text_button_midpoint> - <X>)
	new_button_pos = (<button_pos> - (1.0, 0.0) * <midpoint_diff>)
	new_text_pos = (<text_pos> - (1.0, 0.0) * <midpoint_diff>)
	SetScreenElementProps id = <textid> Pos = <new_text_pos>
	SetScreenElementProps id = <buttonid> Pos = <new_button_pos>
endscript

script user_control_build_super_pill
	user_control_cleanup_pills
	Scale = ($user_control_pill_scale)
	index = 0
	Pos = ((0.0, 1.0) * $user_control_pill_y_position)
	leftmost = 9999.0
	rightmost = -9999.0
	if NOT ($num_user_control_helpers = 0)
		begin
			FormatText checksumName = textid 'uc_text_%d' d = <index>
			FormatText checksumName = buttonid 'uc_button_%d' d = <index>
			fastscreenelementpos id = <buttonid> absolute
			top_left = <ScreenElementPos>
			fastscreenelementpos id = <textid> absolute
			bottom_right = <ScreenElementPos>
			GetScreenElementDims id = <textid>
			bottom_right = (<bottom_right> + (1.0, 0.0) * <width> + (0.0, 1.0) * <height>)
			button_text_width = ((1.0, 0.0).<bottom_right> - (1.0, 0.0).<top_left>)
			left_x = ((1.0, 0.0).<Pos>)
			right_x = ((1.0, 0.0).<Pos> + <button_text_width>)
			if (<left_x> < <leftmost>)
				<leftmost> = (<left_x>)
			endif
			if (<right_x> > <rightmost>)
				<rightmost> = (<right_x>)
			endif
			pill_width = ((1.0, 0.0).<bottom_right> - (1.0, 0.0).<top_left>)
			<buttonid> ::SetTags calc_width = <pill_width>
			<buttonid> ::SetTags calc_pos = <Pos>
			Pos = (<Pos> + (1.0, 0.0) * ($user_control_pill_gap * <Scale> * $user_control_super_pill_gap + <pill_width>))
			<index> = (<index> + 1)
		repeat ($num_user_control_helpers)
	endif
	whole_pill_width = (<rightmost> - <leftmost>)
	holy_midpoint_batman = (<leftmost> + 0.5 * <whole_pill_width>)
	midpoint_diff = (<holy_midpoint_batman> - 640)
	index = 0
	if NOT ($num_user_control_helpers = 0)
		begin
			FormatText checksumName = textid 'uc_text_%d' d = <index>
			FormatText checksumName = buttonid 'uc_button_%d' d = <index>
			<buttonid> ::GetTags
			<calc_pos> = (<calc_pos> - (1.0, 0.0) * <midpoint_diff>)
			SetScreenElementProps id = <buttonid> Pos = (<calc_pos>)
			istextstrumbar id = <textid>
			if (<is_strumbar> = 0)
				SetScreenElementProps id = <textid> Pos = (<calc_pos> + (50.0, 7.0) * <Scale>)
			else
				SetScreenElementProps id = <textid> Pos = (<calc_pos> + (100.0, 7.0) * <Scale>)
			endif
			<index> = (<index> + 1)
		repeat ($num_user_control_helpers)
	endif
	pill_height = ((0.0, 1.0).<bottom_right> - (0.0, 1.0).<top_left>)
	pill_y_offset = (<pill_height> * 0.2)
	pill_height = (<pill_height> + <pill_y_offset>)
	Pos = ((1.0, 0.0) * (<leftmost> - <midpoint_diff>)+ (0.0, 1.0) * $user_control_pill_y_position)
	CreateScreenElement {
		Type = SpriteElement
		parent = user_control_container
		id = user_control_super_pill_object_main
		texture = control_pill_body
		dims = ((1.0, 0.0) * <whole_pill_width> + (0.0, 1.0) * <pill_height>)
		Pos = (<Pos> + (0.0, -0.5) * <pill_y_offset>)
		rgba = ($user_control_pill_color)
		just = [left top]
		z_priority = <z>
	}
	CreateScreenElement {
		Type = SpriteElement
		parent = user_control_container
		id = user_control_super_pill_object_l
		texture = control_pill_end
		dims = ((1.0, 0.0) * (<Scale> * $user_control_pill_end_width)+ (0.0, 1.0) * <pill_height>)
		Pos = (<Pos> + (0.0, -0.5) * <pill_y_offset>)
		rgba = ($user_control_pill_color)
		just = [right top]
		z_priority = <z>
		flip_v
	}
	CreateScreenElement {
		Type = SpriteElement
		parent = user_control_container
		id = user_control_super_pill_object_r
		texture = control_pill_end
		dims = ((1.0, 0.0) * (<Scale> * $user_control_pill_end_width)+ (0.0, 1.0) * <pill_height>)
		Pos = (<Pos> + (0.0, -0.5) * <pill_y_offset> + (1.0, 0.0) * <whole_pill_width>)
		rgba = ($user_control_pill_color)
		just = [left top]
		z_priority = <z>
	}
endscript

script fastscreenelementpos
	GetScreenElementProps id = <id>
	return ScreenElementPos = <Pos>
endscript

script istextstrumbar
	<id> ::GetTags
	if GotParam \{is_strumbar}
		return \{is_strumbar = 1}
	else
		return \{is_strumbar = 0}
	endif
endscript

script get_diff_completion_text\{for_p2_career = 0}
endscript

script get_diff_completion_percentage\{for_p2_career = 0}
endscript
winport_confirm_exit_msg = 'Are you sure you want to exit?'

script winport_create_confirm_exit_popup
	create_popup_warning_menu \{textblock = {text = $winport_confirm_exit_msg}menu_pos = (640.0, 490.0) dialog_dims = (288.0, 64.0) options = [{func = {ui_flow_manager_respond_to_action params = {action = continue}}text = "Yes" Scale = (1.0, 1.0)}{func = {ui_flow_manager_respond_to_action params = {action = go_back}}text = "No" Scale = (1.0, 1.0)}]}
endscript

script winport_destroy_confirm_exit_popup
	destroy_popup_warning_menu
endscript

script displaySprite\{just = [left top] rgba = [255 255 255 255] dims = {}BlendMode = {}internal_just = {}Scale = {}alpha = 1}
	if GotParam \{rot_angle}
		rot_struct = {rot_angle = <rot_angle>}
	else
		rot_struct = {}
	endif
	CreateScreenElement {
		Type = SpriteElement
		id = <id>
		parent = <parent>
		texture = <tex>
		dims = <dims>
		rgba = <rgba>
		Pos = <Pos>
		just = <just>
		internal_just = <internal_just>
		z_priority = <z>
		Scale = <Scale>
		<rot_struct>
		blend = <BlendMode>
		alpha = <alpha>
	}
	if GotParam \{flip_v}
		<id> ::SetProps flip_v
	endif
	if GotParam \{flip_h}
		<id> ::SetProps flip_h
	endif
	return id = <id>
endscript

script displayText\{id = {}just = [left top] rgba = [210 130 0 250] font = fontgrid_title_gh3 rot = 0}
	CreateScreenElement {
		Type = TextElement
		parent = <parent>
		font = <font>
		Scale = <Scale>
		rgba = <rgba>
		text = <text>
		id = <id>
		Pos = <Pos>
		just = <just>
		rot_angle = <rot>
		z_priority = <z>
		font_spacing = <font_spacing>
	}
	if GotParam \{noshadow}
		<id> ::SetProps noshadow
	else
		<id> ::SetProps Shadow shadow_offs = (3.0, 3.0) shadow_rgba [0 0 0 255]
	endif
	return id = <id>
endscript
