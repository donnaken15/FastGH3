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
menu_text_color = [ 255 255 255 255 ]
menu_text_sel = 'Select'
menu_text_conf = 'Confirm'
menu_text_back = 'Back'
menu_text_nav = 'Up/Down'
script common_control_helpers
	if GotParam \{select}
		add_user_control_helper \{text = $menu_text_sel button = green z = 100}
	endif
	if GotParam \{confirm}
		add_user_control_helper \{text = $menu_text_conf button = green z = 100}
	endif
	if GotParam \{continue}
		add_user_control_helper \{text = 'Continue' button = green z = 100}
	endif
	if GotParam \{back}
		add_user_control_helper \{text = $menu_text_back button = red z = 100}
	endif
	if GotParam \{nav}
		add_user_control_helper \{text = $menu_text_nav button = strumbar z = 100}
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
		printf "script new_menu - %s Already exists." s = <scrollid>
		return
	endif
	if ScreenElementExists id = <vmenuid>
		printf "script new_menu - %s Already exists." s = <vmenuid>
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
	/*if GotParam \{tierlist}
		Tier = 0
		begin
			<Tier> = (<Tier> + 1)
			setlist_prefix = ($<tierlist>.prefix)
			FormatText checksumName = tiername '%ptier%i' p = <setlist_prefix> i = (<Tier>)
			FormatText checksumName = tier_checksum 'tier%s' s = (<Tier>)
			<unlocked> = 1
			GetGlobalTags <tiername> param = unlocked
			if ((<unlocked> = 1)|| ($is_network_game))
				GetArraySize ($<tierlist>.<tier_checksum>.songs)
				song_count = 0
				if (<array_Size> > 0)
					begin
						FormatText checksumName = song_checksum '%p_song%i_tier%s' p = <setlist_prefix> i = (<song_count> + 1)s = (<Tier>)AddToStringLookup = true
						for_bonus = 0
						if ($current_tab = tab_bonus)
							<for_bonus> = 1
						endif
						if IsSongAvailable song_checksum = <song_checksum> song = ($g_gh3_setlist.<tier_checksum>.songs [<song_count>])for_bonus = <for_bonus>
							get_song_title song = ($<tierlist>.<tier_checksum>.songs [<song_count>])
							CreateScreenElement {
								Type = TextElement
								parent = <vmenuid>
								font = <font>
								Scale = <font_size>
								rgba = [210 210 210 250]
								text = <song_title>
								just = [left top]
								event_handlers = [
									{focus menu_focus}
									{unfocus menu_unfocus}
									{pad_choose <on_choose> params = {Tier = <Tier> song_count = <song_count>}}
									{pad_left <on_left> params = {Tier = <Tier> song_count = <song_count>}}
									{pad_right <on_right> params = {Tier = <Tier> song_count = <song_count>}}
									{pad_L3 <on_l3> params = {Tier = <Tier> song_count = <song_count>}}
								]
							}
						endif
						song_count = (<song_count> + 1)
					repeat <array_Size>
				endif
			endif
		repeat ($<tierlist>.num_tiers)
	endif*//
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
menu_focus_color = [ 255 127 0 224 ]
default_menu_unfocus_color = [ 255 255 255 191 ]
default_menu_focus_color = [ 255 127 0 224 ]

script new_pause_menu_button \{cont_params = {} event_handlers = []}
	id2 = <id>
	CreateScreenElement {
		<cont_params>
		event_handlers = <event_handlers>
	}
	CreateScreenElement {
		Type = TextElement
		parent = <id>
		font = <font>
		Scale = <scale>
		rgba = $menu_unfocus_color
		text = <text>
		id = <id2>
		just = [left top]
		z_priority = <z>
		exclusive_device = <player_device>
	}
	GetScreenElementDims id = <id>
	fit_text_in_rectangle {
		id = <id>
		dims = ((250.0, 0.0) + <height> * (0.0, 1.0))
		only_if_larger_x = 1
		start_x_scale = (<scale>.(1.0, 0.0))
		start_y_scale = (<scale>.(0.0, 1.0))
	}
endscript

script checkbox_sound
	s = 'Check_'
	if (<#"0x00000000">)
		s = ''
	endif
	FormatText checksumName = sound_event 'Checkbox_%sSFX' s = <s>
	SoundEvent event = <sound_event>
endscript

script pause_lefty_toggle \{player = 1}
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
script create_pause_menu\{Player = 1 for_options = 0 for_practice = 0}
	player_device = ($last_start_pressed_device)
	if ($player1_device = <player_device>)
		<Player> = 1
	else
		<Player> = 2
	endif
	Change \{user_control_pill_text_color = [0 0 0 255]}
	Change \{user_control_pill_color = [180 180 180 255]}
	if (<for_options> = 0)
		if ($view_mode)
			return
		endif
		enable_pause
		safe_create_gh3_pause_menu
	else
		kill_start_key_binding
		flame_handlers = [
			{pad_back ui_flow_manager_respond_to_action params = {action = go_back}}
		]
	endif
	if IsWinPort
		Change \{winport_in_top_pause_menu = 1}
	endif
	pause_z = 11000000
	spacing = -59
	menu_pos = (150.0, 170.0)
	//if (<for_options> = 0)
		//menu_pos = (230.0, 240.0)
		//if (<for_practice> = 1)
			//<menu_pos> = (230.0, 240.0)
			//<spacing> = -30
		//endif
	//else
		//<spacing> = -30
		//if IsGuitarController controller = <player_device>
			//if WinPortSioIsKeyboard deviceNum = <player_device>
			//	menu_pos = (230.0, 240.0)
			//else
			//	menu_pos = (230.0, 240.0)
			//endif
		//else
			//menu_pos = (230.0, 240.0)
		//endif
	//endif
	new_menu {
		scrollid = scrolling_pause
		vmenuid = vmenu_pause
		menu_pos = <menu_pos>
		rot_angle = 0
		event_handlers = <flame_handlers>
		spacing = <spacing>
		use_backdrop = (0)
		exclusive_device = <player_device>
	}
	create_pause_menu_frame z = (<pause_z> - 10)
	if ($is_network_game = 0)
		if GotParam \{banner_text}
			pause_player_text = <banner_text>
		else
			if (<for_options> = 0)
				if (<for_practice> = 1)
					<pause_player_text> = "Paused"
				else
					if NOT isSinglePlayerGame
						FormatText textname = pause_player_text "Player %d paused" d = <Player>
					else
						<pause_player_text> = "Paused"
					endif
				endif
			else
				pause_player_text = "Options"
			endif
		endif
	endif
	text_scale = (0.9, 0.9)
	font = fontgrid_title_gh3
	CreateScreenElement {
		Type = TextElement
		parent = pause_menu_frame_container
		text = <pause_player_text>
		font = <font>
		just = [left top]
		Pos = (<menu_pos> + (270,-17))
		Scale = 1.2
		rgba = [255 255 255 255]
	}
	CreateScreenElement {
		Type = SpriteElement
		parent = pause_menu_frame_container
		texture = FastGH3_logo
		just = [left top]
		Pos = (<menu_pos> - (10,30))
		Scale = 0.5
	}
	container_params = {Type = ContainerElement parent = vmenu_pause dims = (0.0, 100.0)}
	params_params = { // Sonic's Sonic
		cont_params = <container_params>
		font = <font>
		scale = <text_scale>
		z = <pause_z>
		exclusive_device = <player_device>
	}
	if (<for_options> = 0)
		new_pause_menu_button {
			<params_params>
			id = pause_resume
			event_handlers = [
				{focus retail_menu_focus params = {id = pause_resume}}
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
					{unfocus retail_menu_unfocus params = {id = pause_restart}}
					{pad_choose ui_flow_manager_respond_to_action params = {action = select_restart}}
				]
				text = 'Restart'
			}
		endif
		if (<for_practice> = 0)
			if ($is_network_game = 0)
				if (($game_mode = p1_career & $boss_battle = 0)|| ($game_mode = p1_quickplay))
					new_pause_menu_button {
						<params_params>
						id = pause_practice
						event_handlers = [
							{focus retail_menu_focus params = {id = pause_practice}}
							{unfocus retail_menu_unfocus params = {id = pause_practice}}
							{pad_choose ui_flow_manager_respond_to_action params = {action = select_practice}}
						]
						text = 'Practice'
					}
				endif
				new_pause_menu_button {
					<params_params>
					id = pause_extras
					event_handlers = [
						{focus retail_menu_focus params = {id = pause_extras}}
						{unfocus retail_menu_unfocus params = {id = pause_extras}}
						{pad_choose ui_flow_manager_respond_to_action params = {action = select_extras create_params = {player_device = <player_device>}}}
					]
					text = 'Extras'
				}
				new_pause_menu_button {
					<params_params>
					id = pause_options
					event_handlers = [
						{focus retail_menu_focus params = {id = pause_options}}
						{unfocus retail_menu_unfocus params = {id = pause_options}}
						{pad_choose ui_flow_manager_respond_to_action params = {action = select_options create_params = {player_device = <player_device>}}}
					]
					text = 'Options'
				}
			endif
			quit_script = ui_flow_manager_respond_to_action
			quit_script_params = {action = select_quit create_params = {Player = <Player>}}
			if ($is_network_game)
				quit_script = create_leaving_lobby_dialog
				quit_script_params = {
					create_pause_menu
					pad_back_script = return_to_pause_menu_from_net_warning
					pad_choose_script = pause_menu_really_quit_net_game
					z = 300
				}
			endif
			new_pause_menu_button {
				<params_params>
				id = pause_quit
				event_handlers = [
					{focus retail_menu_focus params = {id = pause_quit}}
					{unfocus retail_menu_unfocus params = {id = pause_quit}}
					{pad_choose <quit_script> params = <quit_script_params>}
				]
				text = 'Exit'
			}
			if ($enable_button_cheats = 1)
				new_pause_menu_button {
					<params_params>
					id = pause_debug_menu
					event_handlers = [
						{focus retail_menu_focus params = {id = pause_debug_menu}}
						{unfocus retail_menu_unfocus params = {id = pause_debug_menu}}
						{pad_choose ui_flow_manager_respond_to_action params = {action = select_debug_menu}}
					]
					text = '__debug'
				}
			endif
		else
			FormatText textname = text 'Return to %s' s = ($richpres_modes.$practice_last_mode.#"0x00000000") // ez
			new_pause_menu_button {
				<params_params>
				id = pause_return
				event_handlers = [
					{focus retail_menu_focus params = {id = pause_return}}
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
					{unfocus retail_menu_unfocus params = {id = pause_quit}}
					{pad_choose ui_flow_manager_respond_to_action params = {action = select_quit}}
				]
				text = 'Quit'
			}
		endif
		add_user_control_helper \{text = $menu_text_sel button = green z = 100000}
		add_user_control_helper \{text = 'Unpause' button = start z = 100000}
		add_user_control_helper \{text = $menu_text_nav button = strumbar z = 100000}
	else
		<fit_dims> = (400.0, 0.0)
		params_params = {
			cont_params = {
				Type = ContainerElement
				parent = vmenu_pause
				dims = (0.0, 100.0)
			}
			font = <font>
			scale = <text_scale>
			z = <pause_z>
			exclusive_device = <player_device>
		}
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
		add_user_control_helper \{text = $menu_text_sel button = green z = 100000}
		add_user_control_helper \{text = $menu_text_back button = red z = 100000}
		add_user_control_helper \{text = $menu_text_nav button = strumbar z = 100000}
	endif
	if ($is_network_game = 0)
		if NOT isSinglePlayerGame
			if (<for_practice> = 0)
				FormatText textname = player_paused_text "PLAYER %d PAUSED. ONLY PLAYER %d OPTIONS ARE AVAILABLE." d = <Player>
				displaySprite {
					parent = pause_menu_frame_container
					id = pause_helper_text_bg
					tex = helper_pill_body
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
					tex = helper_pill_end
					Pos = ((640.0, 600.0) - <width> * (0.5, 0.0))
					rgba = [96 0 0 255]
					just = [right center]
					flip_v
					z = (<pause_z> + 10)
				}
				displaySprite {
					parent = pause_menu_frame_container
					tex = helper_pill_end
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

script create_menu_backdrop\{texture = venue_bg rgba = [255 255 255 255]}
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
		z_priority = 0
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
		ScriptAssert \{"No id passed to fit_text_in_rectangle!"}
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
user_control_pill_y_position = 650
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
	Change \{user_control_pill_y_position = 650}
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
				buttonchar = "\m0"
			case red
				buttonchar = "\m1"
			case yellow
				buttonchar = "\b6"
			case blue
				buttonchar = "\b7"
			case orange
				buttonchar = "\b8"
			case strumbar
				buttonchar = "\bb"
				offset_for_strumbar = 1
			case start
				buttonchar = "\ba"
				offset_for_strumbar = 1
		endswitch
	else
		buttonchar = ""
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
				texture = #"0x237d7770"
				dims = ((1.0, 0.0) * <pill_width> + (0.0, 1.0) * <pill_height>)
				Pos = (<Pos> + (0.0, -0.5) * <pill_y_offset>)
				rgba = ($user_control_pill_color)
				just = [left top]
				z_priority = <z>
			}
			CreateScreenElement {
				Type = SpriteElement
				parent = user_control_container
				texture = #"0xb844e84a"
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
				texture = #"0xb844e84a"
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
				texture = #"0x237d7770"
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
				texture = #"0xb844e84a"
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
				texture = #"0xb844e84a"
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
		texture = #"0x237d7770"
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
		texture = #"0xb844e84a"
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
		texture = #"0xb844e84a"
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
winport_confirm_exit_msg = "Are you sure you want to exit?"

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
