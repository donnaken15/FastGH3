is_boss_song = 0
is_guitar_controller = 0

script create_fail_song_menu
	menu_font = fontgrid_title_gh3
	get_song_struct song = ($current_song)
	if StructureContains structure = <song_struct> boss
		Change \{is_boss_song = 1}
	else
		Change \{is_boss_song = 0}
	endif
	<menu_pos> = (640.0, 420.0)
	<song_name_pos> = (640.0, 367.0)
	<completion_text_pos> = (640.0, 422.0)
	completion = 0
	get_song_end_time song = ($current_song)
	if (<total_end_time> > 0)
		completion = (100 * $failed_song_time / <total_end_time>)
	endif
	casttointeger \{completion}
	if (($game_mode = p1_career))
		if ($is_boss_song = 1)
			<menu_pos> = (640.0, 420.0)
		else
			<menu_pos> = (640.0, 401.0)
			<song_name_pos> = (640.0, 358.0)
			<completion_text_pos> = (640.0, 410.0)
		endif
	endif
	if ($game_mode = p2_career || $game_mode = p2_coop)
		min = ($difficulty_list_props.($current_difficulty).index)
		MathMin a = <min> b = ($difficulty_list_props.($current_difficulty2).index)
		casttointeger \{min}
		difficulty_index = <min>
		get_difficulty_text_upper difficulty = ($difficulty_list [<difficulty_index>])
	else
		get_difficulty_text_upper difficulty = ($current_difficulty)
	endif
	get_song_title song = ($current_song)
	GetUpperCaseString <song_title>
	FormatText textname = completion_text '%d' d = <completion>
	song_failed_off = (640.0, 217.0)
	z = 100.0
	offwhite = [223 223 223 255]
	CreateScreenElement \{Type = ContainerElement parent = root_window id = fail_song_static_text_container internal_just = [center center] Pos = (0.0, 0.0) z_priority = 2}
	displaySprite parent = fail_song_static_text_container tex = dialog_title_bg flip_v Pos = (416.0, 100.0) Scale = (1.75, 1.75) z = <z>
	displaySprite parent = fail_song_static_text_container tex = dialog_title_bg Pos = (640.0, 100.0) Scale = (1.75, 1.75) z = <z>
	if ($is_boss_song = 1)
		title = 'BATTLE LOST'
	else
		title = 'SONG FAILED'
	endif
	if ($boss_battle = 1)
		final_blow_powerup = -1
		<final_blow_powerup> = ($player2_status.final_blow_powerup)
		//printf channel = trchen "FINAL BLOW %s" s = <final_blow_powerup>
		if (<final_blow_powerup> > -1)
			<completion_text_pos> = (420.0, 360.0)
			<completion_text_just> = [left center]
			<completion_fit_dims> = (400.0, 400.0)
			CreateScreenElement {
				Type = HMenu
				parent = fail_song_static_text_container
				id = final_blow_stacker
				just = [right center]
				Pos = (840.0, 415.0)
				internal_just = [right center]
				Scale = <completion_text_scale>
			}
			<finalblow_scale> = 0.7
			CreateScreenElement {
				Type = TextElement
				font = <menu_font>
				parent = final_blow_stacker
				just = [center center]
				rgba = [210 130 0 255]
				Shadow
				shadow_offs = (3.0, 3.0)
				shadow_rgba = [0 0 0 255]
				z_priority = (<z> + 0.1)
				Scale = <finalblow_scale>
				text = 'FINAL BLOW:'
				rgba = [223 223 223 255]
			}
			fit_text_in_rectangle {
				id = <id>
				dims = (320.0, 400.0)
				keep_ar = 1
				only_if_larger_x = 1
				start_x_scale = <finalblow_scale>
				start_y_scale = <finalblow_scale>
			}
			CreateScreenElement \{Type = ContainerElement parent = final_blow_stacker dims = (64.0, 64.0)}
			final_blow_attack_icon = ($battlemode_powerups [<final_blow_powerup>].card_texture)
			CreateScreenElement {
				Type = SpriteElement
				parent = <id>
				texture = <final_blow_attack_icon>
				rgba = [255 255 255 255]
				just = [left top]
				Pos = (10.0, -5.0)
				dims = (64.0, 64.0)
				z_priority = (<z> + 0.1)
			}
		else
			<completion_text_pos> = (640.0, 383.0)
			<completion_text_just> = [center center]
			<completion_fit_dims> = (425.0, 400.0)
		endif
		CreateScreenElement {
			Type = HMenu
			parent = fail_song_static_text_container
			id = fail_completion_stacker
			just = <completion_text_just>
			Pos = <completion_text_pos>
			internal_just = [center center]
			Scale = <completion_text_scale>
		}
		<completion_text_params> = {
			Type = TextElement
			font = <menu_font>
			parent = fail_completion_stacker
			just = [center center]
			rgba = [210 130 0 255]
			Shadow
			shadow_offs = (3.0, 3.0)
			shadow_rgba = [0 0 0 255]
			z_priority = (<z> + 0.1)
		}
		GetUpperCaseString ($Boss_Props.character_name)
		CreateScreenElement <completion_text_params> Scale = 2 text = <uppercasestring> rgba = [223 223 223 255]
		CreateScreenElement <completion_text_params> Scale = 2 text = " WINS" rgba = [223 223 223 255]
		CreateScreenElement <completion_text_params> Scale = 1 text = " "
		CreateScreenElement <completion_text_params> Scale = 1 text = "ON"
		CreateScreenElement <completion_text_params> Scale = 1 text = " "
		CreateScreenElement <completion_text_params> Scale = 1 text = <difficulty_text>
		SetScreenElementLock \{id = fail_completion_stacker On}
		fit_text_in_rectangle {
			id = fail_completion_stacker
			dims = <completion_fit_dims>
			keep_ar = 1
			only_if_larger_x = 1
			start_x_scale = <completion_text_scale>
			start_y_scale = <completion_text_scale>
		}
	else
		<song_title_scale> = 1.65
		fill_song_title_and_completion_details <...> parent = fail_song_static_text_container
	endif
	Change \{menu_focus_color = [180 50 50 255]}
	Change \{menu_unfocus_color = [0 0 0 255]}
	if NOT GotParam \{exclusive_device}
		exclusive_device = ($primary_controller)
	endif
	disable_pause
	create_popup_warning_menu {
		title = <title>
		textblock = {text = "" Pos = (640.0, 380.0)}
		player_device = <exclusive_device>
		menu_pos = (640.0, 465.0)
		dialog_dims = (275.0, 64.0)
		menu_y = 1.33
		options = [
			{func = fail_song_menu_select_retry_song text = 'RETRY'}
			{func = fail_song_menu_select_practice text = 'PRACTICE'}
			{func = fail_song_menu_select_quit text = 'EXIT'}
		]
	}
	PauseGame
	kill_start_key_binding
endscript

script fail_song_menu_select_tutorial
	player_device = ($primary_controller)
	if IsGuitarController controller = <player_device>
		ui_flow_manager_respond_to_action \{action = select_tutorial}
	endif
endscript

script destroy_fail_song_menu
	restore_start_key_binding
	destroy_pause_menu_frame
	destroy_menu \{menu_id = fail_song_static_text_container}
	destroy_popup_warning_menu
endscript

script fail_song_menu_select_practice
	GH3_SFX_fail_song_stop_sounds
	ui_flow_manager_respond_to_action \{action = select_practice}
endscript

script fail_song_menu_select_retry_song
	GH3_SFX_fail_song_stop_sounds
	UnPauseGame
	ui_flow_manager_respond_to_action \{action = select_retry}
	restart_song
endscript

script fail_song_menu_select_new_song
	GH3_SFX_fail_song_stop_sounds
	if ($coop_dlc_active = 1)
		Change \{game_mode = p2_faceoff}
	endif
	ui_flow_manager_respond_to_action \{action = select_new_song}
endscript

script fail_song_menu_select_quit
	ui_flow_manager_respond_to_action \{action = select_quit}
endscript

// 555-475
// MAKE THIS A UNIFIED FUNCTION!!!!!!!!
script retry_highlight_focus
	retail_menu_focus id = <id>
	if ScreenElementExists \{id = hi_left}
		if ScreenElementExists \{id = hi_right}
			GetScreenElementDims id = <id>
			SetScreenElementProps id = hi_left Pos = ((635.0, 475.0) - <width> * (0.5, 0.0))flip_v
			SetScreenElementProps id = hi_right Pos = ((645.0, 475.0) + <width> * (0.5, 0.0))
		endif
	endif
endscript
script practice_highlight_focus
	retail_menu_focus id = <id>
	if ScreenElementExists \{id = hi_left}
		if ScreenElementExists \{id = hi_right}
			GetScreenElementDims id = <id>
			SetScreenElementProps id = hi_left Pos = ((635.0, 515.0) - <width> * (0.5, 0.0))flip_v
			SetScreenElementProps id = hi_right Pos = ((645.0, 515.0) + <width> * (0.5, 0.0))
		endif
	endif
endscript
script quit_highlight_focus
	retail_menu_focus id = <id>
	if ScreenElementExists \{id = hi_left}
		if ScreenElementExists \{id = hi_right}
			GetScreenElementDims id = <id>
			SetScreenElementProps id = hi_left Pos = ((635.0, 555.0) - <width> * (0.5, 0.0))flip_v
			SetScreenElementProps id = hi_right Pos = ((645.0, 555.0) + <width> * (0.5, 0.0))
		endif
	endif
endscript

script fill_song_title_and_completion_details
	RequireParams \{[parent uppercasestring] all}
	CreateScreenElement {
		Type = TextElement
		parent = <parent>
		id = fail_song_song_name
		font = <menu_font>
		just = [center center]
		text = <uppercasestring>
		Pos = <song_name_pos>
		rgba = [223 223 223 255]
		Scale = <song_title_scale>
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
		z_priority = (<z> + 0.1)
	}
	fit_text_in_rectangle {
		id = fail_song_song_name
		dims = (430.0, 65.0)
		keep_ar = 1
		only_if_larger_x = 1
		start_x_scale = <song_title_scale>
		start_y_scale = <song_title_scale>
	}
	<completion_text_scale> = 0.5
	CreateScreenElement {
		Type = HMenu
		parent = <parent>
		id = fail_completion_stacker
		just = [center center]
		Pos = <completion_text_pos>
		internal_just = [center center]
		Scale = <completion_text_scale>
	}
	<completion_text_params> = {
		Type = TextElement
		font = <menu_font>
		parent = fail_completion_stacker
		just = [center center]
		rgba = [210 130 0 255]
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
		z_priority = (<z> + 0.1)
	}
	CreateScreenElement <completion_text_params> Scale = 1 text = 'COMPLETED '
	CreateScreenElement <completion_text_params> Scale = 2 text = <completion_text>
	CreateScreenElement <completion_text_params> Scale = 1 text = '% ON '
	CreateScreenElement <completion_text_params> Scale = 2 text = <difficulty_text>
	SetScreenElementLock \{id = fail_completion_stacker On}
	fit_text_in_rectangle {
		id = fail_completion_stacker
		dims = (405.0, 400.0)
		keep_ar = 1
		only_if_larger_x = 1
		start_x_scale = <completion_text_scale>
		start_y_scale = <completion_text_scale>
	}
endscript
