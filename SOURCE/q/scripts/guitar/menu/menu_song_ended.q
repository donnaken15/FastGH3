
script create_song_ended_menu\{Player = 1}
	if IsMoviePlaying \{textureSlot = 1}
		PauseMovie \{textureSlot = 1}
	endif
	disable_pause
	menu_font = fontgrid_title_gh3
	menu_pos = (640.0, 415.0)
	completion = 0
	get_song_end_time song = ($current_song)
	GetSongTimeMs
	if (<time> < 0)
		time = 0
	elseif (<time> > <total_end_time>)
		time = <total_end_time>
	endif
	if (<total_end_time> > 0)
		completion = (100 * <time> / <total_end_time>)
	endif
	casttointeger \{completion}
	get_difficulty_text_upper difficulty = ($current_difficulty)
	get_song_title song = ($current_song)
	GetUpperCaseString <song_title>
	FormatText textname = completion_text "%d" d = <completion>
	song_ended_off = (640.0, 217.0)
	song_name_off = (695.0, 460.0)
	z = 10000.0
	offwhite = [223 223 223 255]
	new_menu scrollid = song_ended_scrolling_menu vmenuid = song_ended_vmenu use_backdrop = 0 spacing = -55 menu_pos = <menu_pos> exclusive_device = ($last_start_pressed_device)
	create_pause_menu_frame z = (<z> - 10)
	SetScreenElementProps \{id = song_ended_vmenu internal_just = [center center]}
	CreateScreenElement \{Type = ContainerElement parent = root_window id = song_ended_static_text_container internal_just = [center center] Pos = (0.0, 0.0) z_priority = 2}
	displaySprite parent = song_ended_static_text_container tex = #"0x7464ad56" flip_v Pos = (416.0, 100.0) Scale = (1.75, 1.75) z = <z>
	displaySprite parent = song_ended_static_text_container tex = #"0x7464ad56" Pos = (640.0, 100.0) Scale = (1.75, 1.75) z = <z>
	CreateScreenElement {
		Type = TextElement
		parent = song_ended_static_text_container
		font = <menu_font>
		text = "SONG ENDED"
		just = [center center]
		Pos = {<song_ended_off> relative}
		rgba = [223 223 223 255]
		Scale = 1.2
		z_priority = (<z> + 0.1)
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
	}
	fit_text_in_rectangle id = <id> dims = (285.0, 200.0) keep_ar = 1 only_if_larger_x = 1 start_x_scale = 1.2 start_y_scale = 1.2
	<song_title_scale> = 1.65
	<song_name_pos> = (640.0, 367.0)
	<completion_text_pos> = (640.0, 422.0)
	fill_song_title_and_completion_details <...> parent = song_ended_static_text_container
	Change \{menu_focus_color = [180 50 50 255]}
	Change \{menu_unfocus_color = [0 0 0 255]}
	text_scale = (0.8999999761581421, 1.0)
	displaySprite parent = song_ended_static_text_container tex = white Pos = (492.0, 517.0) Scale = (75.0, 6.0) z = (<z> + 0.1)rgba = <offwhite>
	displaySprite parent = song_ended_static_text_container tex = #"0xacf2f335" Pos = (480.0, 510.0) rot_angle = 5 Scale = (1.5750000476837158, 1.5) z = (<z> + 0.2)
	displaySprite parent = song_ended_static_text_container tex = #"0xacf2f335" Pos = (750.0, 514.0) flip_v rot_angle = -5 Scale = (1.5750000476837158, 1.5) z = (<z> + 0.2)
	displaySprite id = hi_right parent = song_ended_static_text_container tex = #"0x0b444b41" Pos = (770.0, 533.0) Scale = (1.0, 1.0) z = (<z> + 0.3)just = [left center]
	displaySprite id = hi_left parent = song_ended_static_text_container tex = #"0x0b444b41" flip_v Pos = (500.0, 533.0) Scale = (1.0, 1.0) z = (<z> + 0.3)just = [right center]
	displaySprite parent = song_ended_static_text_container tex = #"0xdb44b36c" Pos = (480.0, 450.0) Scale = (1.25, 1.25) z = <z>
	displaySprite parent = song_ended_static_text_container tex = #"0xdb44b36c" flip_h Pos = (480.0, 530.0) Scale = (1.25, 1.25) z = <z>
	CreateScreenElement \{Type = ContainerElement parent = song_ended_vmenu dims = (0.0, 100.0) event_handlers = [{focus menu_se_retry_highlight_focus params = {id = song_ended_retry_text}}{unfocus retail_menu_unfocus params = {id = song_ended_retry_text}}{pad_choose song_ended_menu_select_retry_song}]}
	CreateScreenElement {
		Type = TextElement
		parent = <id>
		id = song_ended_retry_text
		font = <menu_font>
		text = "RETRY SONG"
		rgba = ($menu_unfocus_color)
		Scale = <text_scale>
		just = [center top]
		z_priority = (<z> + 0.1)
	}
	GetScreenElementDims id = <id>
	fit_text_in_rectangle id = <id> only_if_larger_x = 1 dims = ((220.0, 0.0) + <height> * (0.0, 1.0))
	CreateScreenElement {
		Type = ContainerElement
		parent = song_ended_vmenu
		dims = (0.0, 100.0)
		event_handlers = [
			{focus menu_se_newsong_highlight_focus params = {id = song_ended_new_song_text}}
			{unfocus retail_menu_unfocus params = {id = song_ended_new_song_text}}
			{pad_choose song_ended_menu_select_new_song params = {Player = <Player>}}
		]
	}
	CreateScreenElement {
		Type = TextElement
		parent = <id>
		id = song_ended_new_song_text
		font = <menu_font>
		text = "NEW SONG"
		rgba = ($menu_unfocus_color)
		Scale = <text_scale>
		just = [center top]
		z_priority = (<z> + 0.1)
	}
	GetScreenElementDims id = <id>
	fit_text_in_rectangle id = <id> only_if_larger_x = 1 dims = ((220.0, 0.0) + <height> * (0.0, 1.0))
	CreateScreenElement \{Type = ContainerElement parent = song_ended_vmenu dims = (0.0, 100.0) event_handlers = [{focus menu_se_quit_highlight_focus params = {id = song_ended_main_menu_text}}{unfocus retail_menu_unfocus params = {id = song_ended_main_menu_text}}{pad_choose song_ended_menu_select_quit}]}
	CreateScreenElement {
		Type = TextElement
		parent = <id>
		id = song_ended_main_menu_text
		font = <menu_font>
		text = "MAIN MENU"
		rgba = ($menu_unfocus_color)
		Scale = <text_scale>
		just = [center top]
		z_priority = (<z> + 0.1)
	}
	GetScreenElementDims id = <id>
	fit_text_in_rectangle id = <id> only_if_larger_x = 1 dims = ((220.0, 0.0) + <height> * (0.0, 1.0))
endscript

script destroy_song_ended_menu
	GH3_SFX_fail_song_stop_sounds
	if IsMoviePlaying \{textureSlot = 1}
		ResumeMovie \{textureSlot = 1}
	endif
	enable_pause
	destroy_menu \{menu_id = song_ended_scrolling_menu}
	destroy_pause_menu_frame
	destroy_menu \{menu_id = song_ended_static_text_container}
endscript

script song_ended_menu_select_retry_song
	ui_flow_manager_respond_to_action \{action = select_retry}
	restart_song
endscript

script song_ended_menu_select_new_song
	if ($coop_dlc_active = 1)
		Change \{game_mode = p2_faceoff}
	endif
	if GotParam \{Player}
		ui_flow_manager_respond_to_action action = select_new_song create_params = {Player = <Player>}
	else
		ui_flow_manager_respond_to_action \{action = select_new_song}
	endif
endscript

script song_ended_menu_select_quit
	ui_flow_manager_respond_to_action \{action = select_quit}
endscript

script menu_se_retry_highlight_focus
	retail_menu_focus id = <id>
	GetScreenElementDims id = <id>
	SetScreenElementProps id = hi_left Pos = ((635.0, 480.0) - <width> * (0.5, 0.0))flip_v
	SetScreenElementProps id = hi_right Pos = ((645.0, 480.0) + <width> * (0.5, 0.0))
endscript

script menu_se_newsong_highlight_focus
	retail_menu_focus id = <id>
	GetScreenElementDims id = <id>
	SetScreenElementProps id = hi_left Pos = ((635.0, 530.0) - <width> * (0.5, 0.0))flip_v
	SetScreenElementProps id = hi_right Pos = ((645.0, 530.0) + <width> * (0.5, 0.0))
endscript

script menu_se_quit_highlight_focus
	retail_menu_focus id = <id>
	GetScreenElementDims id = <id>
	SetScreenElementProps id = hi_left Pos = ((635.0, 575.0) - <width> * (0.5, 0.0))flip_v
	SetScreenElementProps id = hi_right Pos = ((645.0, 575.0) + <width> * (0.5, 0.0))
endscript
