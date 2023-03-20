beat_game_title = "\c6YOU BEAT GUITAR HERO III ON \c0%d\c6!\c0"
beat_game_message = "Think you've got what it takes to really\n blow their minds? Try this bad boy out on \c1%n\c0. There may be a reward waiting for you if you succeed. Pain, fame and glory await, lil' rocker."
beat_game_message_expert = "Wow. You've mastered expert -- Go start a band already! Take it to the next level with the \c1%n\c0! Cheats can be unlocked in the options menu."

script create_beat_game_menu
	create_menu_backdrop \{texture = #"0x7db2638a"}
	menu_font = fontgrid_title_gh3
	get_current_band_info
	GetGlobalTags <band_info> param = name
	band_name = <name>
	FormatText textname = band_name_text "%s" s = <band_name>
	difficulty_text = "EXPERT"
	next_difficulty_text = "PRECISION MODE CHEAT"
	<difficulty> = ($current_difficulty)
	if ($game_mode = p2_career)
		<index1> = ($difficulty_list_props.($current_difficulty).index)
		<index2> = ($difficulty_list_props.($current_difficulty2).index)
		if (<index2> < <index1>)
			<difficulty> = ($current_difficulty2)
		endif
	endif
	switch (<difficulty>)
		case easy
			<difficulty_text> = "EASY"
			next_difficulty = medium
			<next_difficulty_text> = "MEDIUM"
		case medium
			<difficulty_text> = "MEDIUM"
			next_difficulty = hard
			<next_difficulty_text> = "HARD"
		case hard
			<difficulty_text> = "HARD"
			next_difficulty = expert
			<next_difficulty_text> = "EXPERT"
	endswitch
	CreateScreenElement \{Type = ContainerElement parent = root_window id = beat_game_container Pos = (0.0, 0.0) just = [left top]}
	CreateScreenElement {
		Type = TextElement
		parent = beat_game_container
		id = bgs_band_name
		just = [center top]
		font = <menu_font>
		text = <band_name_text>
		Scale = 1.38
		rgba = [140 70 70 255]
		Pos = (640.0, 366.0)
	}
	GetScreenElementDims \{id = bgs_band_name}
	if (<width> > 300)
		fit_text_in_rectangle \{id = bgs_band_name dims = (1060.0, 130.0) Pos = (640.0, 366.0)}
	endif
	FormatText textname = title_text $beat_game_title d = <difficulty_text>
	CreateScreenElement {
		Type = TextElement
		parent = beat_game_container
		id = bgs_under_title
		just = [left top]
		font = <menu_font>
		text = <title_text>
		Scale = 1.0
		rgba = [250 245 145 255]
	}
	fit_text_in_rectangle \{id = bgs_under_title dims = (700.0, 65.0) Pos = (300.0, 428.0)}
	if (<difficulty> = expert)
		FormatText textname = motivation_text ($beat_game_message_expert)n = <next_difficulty_text>
	else
		FormatText textname = motivation_text ($beat_game_message)n = <next_difficulty_text>
	endif
	CreateScreenElement {
		Type = TextBlockElement
		parent = beat_game_container
		font = #"0x35c0114b"
		text = <motivation_text>
		dims = (1100.0, 700.0)
		Pos = (640.0, 468.0)
		rgba = [250 245 145 255]
		just = [center top]
		internal_just = [center top]
		Scale = 0.7
		z_priority = 3
	}
	<cheat> = "ROCK YOU LIKE A HURRICANE RIFF x 2"
	FormatText textname = cheat_text "CHEAT HINT: %c" c = <cheat>
	if (<difficulty> = expert)
		CreateScreenElement {
			Type = TextElement
			parent = beat_game_container
			id = bgs_cheat_text
			just = [center top]
			font = <menu_font>
			text = <cheat_text>
			Scale = 0.5
			Pos = (640.0, 622.0)
			rgba = [250 245 145 255]
		}
	endif
	button_font = #"0x0d53096f"
	displaySprite \{id = bgs_black_banner parent = beat_game_container tex = white Pos = (0.0, -2.0) dims = (1240.0, 100.0) rgba = [0 0 0 255] z = -2}
	CreateScreenElement {
		Type = TextElement
		parent = beat_game_container
		id = continue_text
		Scale = 1.0
		Pos = (40.0, 20.0)
		font = ($cash_reward_font)
		rgba = [0 0 0 255]
		just = [left center]
		event_handlers = [
			{pad_choose ui_flow_manager_respond_to_action params = {action = continue}}
		]
	}
	spawnscriptnow scroll_band_name params = {band_text = <band_name_text>}
	LaunchEvent \{Type = focus target = continue_text}
	Change \{user_control_pill_text_color = [0 0 0 255]}
	Change \{user_control_pill_color = [180 180 180 255]}
	add_user_control_helper \{text = "CONTINUE" button = green z = 100}
endscript

script destroy_beat_game_menu
	clean_up_user_control_helpers
	destroy_menu \{menu_id = beat_game_container}
	destroy_menu_backdrop
	killspawnedscript \{name = scroll_band_name}
endscript

script scroll_band_name
	displayText id = scrolling_bandname1 parent = beat_game_container Pos = (0.0, 34.0) Scale = 1 font = <menu_font> text = <band_text> rgba = [124 77 65 255] z = -1
	GetScreenElementDims \{id = scrolling_bandname1}
	multi = (1280 / <width>)
	band_text_with_space = (<band_text> + " ")
	long_band_text = <band_text_with_space>
	StringLength string = <band_text_with_space>
	<band_text_with_space_length> = <str_len>
	begin
		StringLength string = <long_band_text>
		<long_band_text_length> = <str_len>
		if NOT (<long_band_text_length> < (127 - <band_text_with_space_length>))
			break
		endif
		<long_band_text> = (<long_band_text> + <band_text_with_space>)
		SetScreenElementProps id = scrolling_bandname1 text = <long_band_text>
		GetScreenElementDims \{id = scrolling_bandname1}
		if (<width> > 1280)
			break
		endif
	repeat <multi>
	SetScreenElementProps id = scrolling_bandname1 text = <long_band_text>
	fit_text_in_rectangle id = scrolling_bandname1 dims = ((1280.0, 0.0) + (<height> * (0.0, 1.0)))Pos = (0.0, 34.0)
	displayText id = scrolling_bandname2 parent = beat_game_container Scale = 1 font = <menu_font> text = <long_band_text> rgba = [124 77 65 255] z = -1
	GetScreenElementDims \{id = scrolling_bandname1}
	fit_text_in_rectangle id = scrolling_bandname2 dims = ((1280.0, 0.0) + (<height> * (0.0, 1.0)))Pos = (((1.0, 0.0) * <width>)+ (0.0, 34.0))
	first = 1
	begin
		if (<first>)
			DoScreenElementMorph id = scrolling_bandname1 Pos = (((-1.0, 0.0) * <width>)+ (0.0, 34.0))time = 5
			DoScreenElementMorph \{id = scrolling_bandname2 Pos = (0.0, 34.0) time = 5}
		else
			DoScreenElementMorph id = scrolling_bandname2 Pos = (((-1.0, 0.0) * <width>)+ (0.0, 34.0))time = 5
			DoScreenElementMorph \{id = scrolling_bandname1 Pos = (0.0, 34.0) time = 5}
		endif
		wait \{5 seconds}
		if (<first>)
			SetScreenElementProps id = scrolling_bandname1 Pos = (((1.0, 0.0) * <width>)+ (0.0, 34.0))
			SetScreenElementProps \{id = scrolling_bandname2 Pos = (0.0, 34.0)}
			<first> = 0
		else
			SetScreenElementProps id = scrolling_bandname2 Pos = (((1.0, 0.0) * <width>)+ (0.0, 34.0))
			SetScreenElementProps \{id = scrolling_bandname1 Pos = (0.0, 34.0)}
			<first> = 1
		endif
	repeat
endscript
