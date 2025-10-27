results_screen_layout = {
	layouts = {
		base = [
			{
				element = title
				pos = (145.0, 162.0)
				dims = (600.0, 114.0)
				rot = 0
				z = 999
				line_spacing = 0.85
				font = fontgrid_title_gh3
				just = [left bottom]
				iscale = 1.0
			}
			{
				element = artist
				//uppercase
				pos = (145.0, 162.0)
				dims = (600.0, 114.0)
				rot = 0
				z = 999
				line_spacing = 0.85
				font = text_a4
				just = [left top]
				iscale = 0.8
			}
		]
		quickplay_1p = [
			// TODO: CONTAINERS WITH ITEM ARRAYS!!
			{
				type = text
				text = '%'
				font = text_a4
				just = [ left bottom ]
				ijust = [ center center ]
				Pos = (240.0, 320.0)
				z = 4
				rgba = $g_ss_percent_color
				dims = (48.0, 48.0)
			}
			{
				type = textblock
				text = '\u0NOTES HIT'
				font = text_a3
				Pos = (280.0, 330.0)
				dims = (210.0, 60.0)
				just = [ left bottom ]
				ijust = [ left bottom ]
				Scale = 0.7
				z = 4
				rgba = $g_ss_offwhite
				font_spacing = 6
				space_spacing = 1 // <-- wtf????????
			}
			{
				element = notes_hit
				font = num_a7
				just = [ right bottom ]
				Pos = (230.0, 340.0)
				dims = (80.0, 50.0)
				Scale = 1.4
				z = 4
				rgba = $g_ss_offwhite
				font_spacing = 5
				space_spacing = 3
				//scale = 1 // why immediately override it
				// followed by fit text
			}
			{
				element = streak
				commas
				font = text_a3
				iscale = 0.8
				just = [ right center ]
				Pos = (620.0, 310.0)
				dims = (130.0, 50.0)
				Scale = 1.5
				z = 4
				rgba = $g_ss_offwhite
			}
			{
				type = text
				text = 'note streak'
				//element = streak
				font = text_a11
				just = [ left top ]
				Pos = (625.0, 278.0)
				Scale = (0.6, 0.7)
				z = 4
				rgba = $g_ss_offwhite
				font_spacing = 5
				space_spacing = 3
				//scale = 1 // why immediately override it
				// followed by fit text
			}
			
			
			
			
		]
		battle_2p = [
			{
				type = text
				text = 'EPIC BATTLE'
				just = [left bottom]
				font = text_a11
				Pos = (145.0, 430.0)
				Scale = 0.75
				id = battle_header_text
				//rgba = <winner_color> // :(
			}
			{
				type = text
				text = 'WHO WON?!' // WHO'S NEXT?! YOU DECIDE!!
				just = [left bottom]
				font = text_a11
				Pos = (145.0, 468.0)
				Scale = 0.75
				id = battle_who_won_text
			}
		]
		tugofwar_2p = [
			{
				type = textblock
				text = 'It\'s a TIE!'
				just = [left bottom]
				ijust = [left bottom]
				font = text_a11
				Pos = (145.0, 450.0)
				Scale = 0.8
				dims = (660.0, 90.0)
				line_spacing = 0.85
				id = ss_winner_text
			}
		]
		versus_2p = [
			{
				type = text
				just = [left top]
				ijust = [left top]
				font = text_a4
				rgba = $g_ss_2p_song_title_whiteish
				Pos = (145.0, 286.0)
				dims = (450.0, 80.0)
				Scale = 1.2
				line_spacing = 0.85
				id = ss_mode_text_block_id
			}
			{
				type = text
				font = fontgrid_title_gh3
				rgba = $g_ss_p1_orangeish
				Pos = (145.0, 490.0)
				Scale = 0.83
				line_spacing = 0.85
				id = ss_p1_difficulty
				font_spacing = 2
				space_spacing = 2
			}
			{
				type = text
				font = fontgrid_title_gh3
				rgba = $g_ss_p2_violetish
				Pos = (145.0, 540.0)
				Scale = 0.83
				line_spacing = 0.85
				id = ss_p2_difficulty
				font_spacing = 2
				space_spacing = 2
			}
			//{
			//	type = sprite
			//	texture = Song_Summary_Circle_2p
			//	rgba = $g_ss_p1_orangeish
			//	rot = 180
			//	z = 8
			//	Pos = (668.0, 260.0)
			//}
			// add subitems
		]
	}
	// make option list separate array here with indications for
	// which modes they can be accessed from, or always show on all modes
}

g_gray = [ 128 128 128 255 ]
g_ss_offwhite = [ 230 230 230 255 ]
g_ss_black = [ 0 0 0 255 ]
g_ss_gray = [100 100 100 255]
g_ss_orangeish = [ 200 135 55 255 ]
g_ss_AP_reddish = [ 200 60 55 255 ]
g_ss_AP_blueish = [ 55 80 135 255 ]
g_ss_AP_yellowish = [ 230 220 25 255 ]
g_ss_p1_orangeish = [ 210 165 110 255 ]
g_ss_p2_violetish = [ 180 155 205 255 ]
g_ss_2p_song_title_whiteish = [ 220 220 220 255 ]

g_ss_percent_color = $g_ss_offwhite
g_ss_star_good_color = $g_ss_offwhite
g_ss_star_bad_color = $g_ss_gray
g_ss_score_color = $g_ss_offwhite
g_ss_score_text_color = $g_ss_black
g_ss_score_fill_L_color = $g_ss_black
g_ss_score_fill_R_color = $g_ss_offwhite
g_ss_notestreak_fill_color = $g_ss_black
g_ss_notestreak_text_color = $g_ss_offwhite
g_ss_notestreak_color = $g_ss_offwhite

element_type_aliases = {
	text = TextElement
	textblock = TextBlockElement
	container = ContainerElement
	sprite = SpriteElement
}
element_types_allowed = [ // CreateElement
	TextElement
	TextBlockElement // has word wrapping
	SpriteElement // texture (image) or material
	MovieElement // ?????
	// only PlayMovie is known and can only do fullscreen, but video venue has bink video displaying behind the truck
	HMenu // apparently used for horizontal text stacking: menu_fail_song.q:270, i guess if events arent assigned
	VMenu // but this is (obviously) used a lot for selection menus (because strum up/down)
	HScrollingMenu
	VScrollingMenu
	ViewportElement
	WindowElement // apparently suggested for (recreating) masking filled time bar on WOR HUD when white sprite works too
	//Element3D // no 3D here lol
]
script create_results_layout
	layouts = ($results_screen_layout.layouts)
	if NOT StructureContains structure = <layouts> <layout>
		printf 'can\'t find layout %s!!!!!!!!!!!!!!' s = <layout>
		printstruct ($<layouts>)
		return false
	endif
	GetArraySize (<layouts>.<layout>)
	if NOT (<array_size> > 0)
		return
	endif
	item_count = <array_size>
	i = 0
	bbox_display = 0
	begin
		<create> = 1
		item = (<layouts>.<layout>[<i>])
		send_props = {
			//<send_props>
			
			// fallback items
			dims = (300.0, 300.0)
			pos = (640.0, 360.0)
			font = text_a1
			scale = 1.0
			rgba = [ 255 255 255 255 ]
			just = [left top]
			internal_just = [left top]
			internal_scale = 1.0 // ???????
			flip = [false false]
			text = ''
			
			// whatever you want
			id = (<item>.id) //not important for static stuff obviously
			text = (<item>.text)
			texture = (<item>.texture)
			material = (<item>.material)
			dims = (<item>.dims) // hopefully ineffective on simple text elements
			pos = (<item>.pos)
			rot_angle = (<item>.rot)
			just = (<item>.just)
			internal_just = (<item>.just)
			font = (<item>.font)
			scale = (<item>.scale)
			alpha = (<item>.alpha)
			z_priority = (<item>.z)
			rgba = (<item>.rgba)
			line_spacing = (<item>.line_spacing)
			internal_just = (<item>.ijust)
			internal_scale = (<item>.iscale)
			flip = (<item>.flip)
			parent = <parent>
		}
		if StructureContains structure=<info> (<item>.element)
			text = (<info>.(<item>.element))
			if StructureContains structure=<item> uppercase
				GetUpperCaseString <text>
				text = <uppercasestring>
			elseif StructureContains structure=<item> lowercase
				GetLowerCaseString <text>
				text = <lowercasestring>
			endif
			params = {}
			if StructureContains structure=<item> commas
				params = {usecommas}
			endif
			format = '%s'
			if StructureContains structure=<item> format
				format = (<item>.format)
			endif
			FormatText textname = fmt_text <format> s = <text> b = (<info>.artist_text) <params>
			send_props = {
				just = [left top]
				font = text_a4
				<send_props>
				type = TextBlockElement
				text = <fmt_text>
				parent = <parent>
			}
		else
			type = (<item>.type)
			if StructureContains structure=$element_type_aliases <type> // make wiki page for func
				type = ($element_type_aliases.<type>)
			endif
			if not IndexOf delegate = ChecksumEquals array = ($element_types_allowed) <type>
				printf 'invalid element type = %t' t = <type>
				<create> = 0
			else
				send_props = {
					type = <type>
					<send_props>
				}
			endif
		endif
		if (<create> = 1)
			//printstruct <send_props>
			if (<bbox_display>)
				CreateScreenElement {
					<send_props>
					type = SpriteElement
					rgba = [ 255 0 0 255 ]
					parent = <parent>
					z = (<item>.z - 1)
					alpha = 0.3
				}
				if (<item>.flip[0])
					<id>::SetProps flip_h
				endif
				if (<item>.flip[1])
					<id>::SetProps flip_v
				endif
			endif
			CreateScreenElement <send_props>
			if (<item>.flip[0])
				<id>::SetProps flip_h
			endif
			if (<item>.flip[1])
				<id>::SetProps flip_v
			endif
		endif
		//if (<prop_count> > 0)
		//	begin
		//		RemoveComponent (<send_props>[<i>])
		//	repeat <prop_count>
		//endif
		Increment \{i}
	repeat <item_count>
endscript


g_np_option_props = [
	{
		Pos = (780.0, 168.0)
		rot = 0
		offset = (-30.0, 11.0)
	}
	{
		Pos = (780.0, 201.0)
		rot = 0
		offset = (-30.0, 11.0)
	}
	{
		Pos = (780.0, 234.0)
		rot = 0
		offset = (-30.0, 11.0)
	}
	{
		Pos = (780.0, 266.0)
		rot = 0
		offset = (-30.0, 11.0)
	}
	{
		Pos = (780.0, 162.0)
		rot = 0
		offset = (-30.0, 11.0)
	}
	{
		Pos = (780.0, 195.0)
		rot = 0
		offset = (-30.0, 11.0)
	}
	{
		Pos = (780.0, 228.0)
		rot = 0
		offset = (-30.0, 11.0)
	}
	{
		Pos = (780.0, 261.0)
		rot = 0
		offset = (-30.0, 11.0)
	}
	{
		Pos = (780.0, 294.0)
		rot = 0
		offset = (-30.0, 11.0)
	}
]
g_np_menu_icon_offset = (225.0, -22.0)
g_np_options_index = 0
g_ss_mag_number = 0
use_last_player_scores = 0
old_song = None

script create_newspaper_menu\{for_practice = 0}
	menu_song_complete_sound
	create_menu_backdrop \{texture = white rgba = [32 32 32 90]}
	StopSoundsByBuss \{BinkCutScenes}
	disable_pause
	my_song = ($current_song)
	//if NOT ($old_song = None)
	//	my_song = ($old_song)
	//	Change \{old_song = None}
	//endif
	set_focus_color \{rgba = $g_ss_offwhite}
	set_unfocus_color \{rgba = $g_ss_black}
	show_replay = 1
	replay_flow_params = {action = try_again}
	if ($game_mode = training)
		if ($menu_choose_practice_destroy_previous_menu = 0)
			LaunchEvent \{Type = focus target = newspaper_vmenu}
			return
		endif
		if ViewportExists \{id = bg_viewport}
			disable_bg_viewport
		endif
		if ScreenElementExists \{id = practice_sectiontext}
			SetScreenElementProps \{id = practice_sectiontext alpha = 0}
		endif
		Change \{g_np_options_index = 4}
		Player = 1
		begin
			FormatText checksumName = player_status 'player%i_status' i = <Player> AddToStringLookup
			FormatText textname = player_text 'p%i' i = <Player> AddToStringLookup
			destroy_hud <...>
		repeat $max_num_players
	endif
	np_event_handlers = [
		{pad_up np_scroll_up params = {for_practice = <for_practice> show_replay = <show_replay>}}
		{pad_down np_scroll_down params = {for_practice = <for_practice> show_replay = <show_replay>}}
	]
	if ($player1_status.bot_play = 1)
		exclusive_device = ($primary_controller)
	else
		if ($game_mode = p2_career ||
			$game_mode = p2_faceoff ||
			$game_mode = p2_pro_faceoff ||
			$game_mode = p2_battle)
			exclusive_mp_controllers = [0 0]
			SetArrayElement ArrayName = exclusive_mp_controllers index = 0 NewValue = ($player1_device)
			SetArrayElement ArrayName = exclusive_mp_controllers index = 1 NewValue = ($player2_device)
			exclusive_device = <exclusive_mp_controllers>
		else
			exclusive_device = ($primary_controller)
		endif
	endif
	new_menu scrollid = newspaper_scroll vmenuid = newspaper_vmenu use_backdrop = 0 event_handlers = <np_event_handlers> exclusive_device = <exclusive_device>
	if ($game_mode = p2_coop)
		stars = (($player1_status.stars + $player2_status.stars)/ 2)
	else
		stars = ($player1_status.stars)
	endif
	p1_score = ($player1_status.score)
	p2_score = ($player2_status.score)
	p1_health = ($player1_status.current_health)
	p2_health = ($player2_status.current_health)
	p1_note_streak = ($player1_status.best_run)
	p2_note_streak = ($player2_status.best_run)
	p1_percent_complete = 0
	if ($player1_status.total_notes > 0)
		<p1_percent_complete> = (100 * $player1_status.notes_hit / $player1_status.total_notes)
	endif
	p2_percent_complete = 0
	if ($player2_status.total_notes > 0)
		<p2_percent_complete> = (100 * $player2_status.notes_hit / $player2_status.total_notes)
	endif
	if ($game_mode = p2_career || $game_mode = p2_coop)
		<p1_score> = (<p1_score> + <p2_score>)
		if (<p1_note_streak> < <p2_note_streak>)
			<p1_note_streak> = <p2_note_streak>
		endif
		if (<p1_percent_complete> < <p2_percent_complete>)
			<p1_percent_complete> = <p2_percent_complete>
		endif
	endif
	casttointeger \{p1_score} // floors, gracefully
	casttointeger \{p2_score}
	CreateScreenElement \{Type = ContainerElement parent = root_window id = newspaper_container Pos = (0.0, 0.0)}
	FormatText textname = p1_note_streak_text '%d' d = <p1_note_streak>
	FormatText textname = p2_note_streak_text '%d' d = <p2_note_streak>
	FormatText textname = p1_score_text '%s' s = <p1_score>
	FormatText textname = p2_score_text '%s' s = <p2_score>
	get_progression_globals game_mode = ($game_mode)use_current_tab = 1
	show_stars = 1
	if ($boss_battle = 1)
		show_stars = 0
	endif
	get_song_title song = <my_song>
	get_song_artist song = <my_song>
	get_song_struct song = <my_song>
	get_difficulty_text difficulty = ($current_difficulty)
	if (<stars> < 3)
		<stars> = 3 // ???
	endif
	offwhite = [223 223 223 255]
	reddish = [170 70 70 255]
	Change \{g_ss_mag_number = 0}
	create_results_layout parent = newspaper_container layout = base info = {
		title = <song_title>
		artist = <song_artist>
		album = (<song_struct>.album)
		year = (<song_struct>.year)
		artist_text = (<song_struct>.artist_text)
	}
	if NOT ($game_mode = p1_career || $game_mode = p2_career || $game_mode = p2_coop || $game_mode = p1_quickplay || <for_practice> = 1)
		create_results_layout \{parent = newspaper_container layout = versus_2p}
		<ss_logo> = none
		<ss_logo_sm> = none
		<ss_sidebar> = none
		<ss_percent_color> = $g_ss_black
		<ss_score_color> = $g_ss_black
		<ss_notestreak_fill_color> = $g_ss_black
		<ss_notestreak_color> = $g_ss_offwhite
		<ss_notestreak_text_color> = $g_ss_offwhite
		if ($game_mode = p2_battle)
			if (<p2_health> > <p1_health>)
				<winner> = 2
				<winner_color> = $g_ss_p2_violetish
			else
				<winner> = 1
				<winner_color> = $g_ss_p1_orangeish
			endif
		else
			if (<p2_score> > <p1_score>)
				<winner> = 2
				<winner_color> = $g_ss_p2_violetish
			elseif (<p1_score> > <p2_score>)
				<winner> = 1
				<winner_color> = $g_ss_p1_orangeish
			else
				<winner> = 0
			endif
		endif
		//if ($is_network_game) // :O
		//	do_achievement_check <...>
		//	updateatoms \{name = achievement}
		//endif
		if (<winner> = 0)
			rand_status = Random (@ 1 @ 2)
			FormatText checksumName = player_status 'player%i_status' i = <rand_status>
		else
			FormatText checksumName = player_status 'player%i_status' i = <winner>
		endif
		if ($game_mode = p2_battle)
			create_results_layout \{parent = newspaper_container layout = battle_2p}
			FormatText textname = winner_text 'Player %d' d = <winner>
			if ($is_network_game)
				if (<winner> = 2)
					winner_text = $opponent_gamertag
				else
					if NetSessionFunc Obj = match func = get_gamertag
						winner_text = <name>
					else
						winner_text = 'FAIL!!!'
					endif
				endif
			endif
			FormatText textname = who_won_text "%s%t" s = <winner_text> t = ' Rules!'
			battle_header_text::SetProps rgba = <winner_color>
			battle_who_won_text::SetProps rgba = <winner_color> text = <who_won_text>
			<final_blow_powerup> = ($<player_status>.final_blow_powerup)
			if (<final_blow_powerup> > -1)
				CreateScreenElement \{Type = TextBlockElement parent = newspaper_container just = [left top] Pos = (320.0, 415.0) rot_angle = -7.5 Scale = 0.45 text = 'FINAL BLOW:' font = fontgrid_title_gh3 rgba = [223 223 223 255] dims = (300.0, 300.0)}
				select = <final_blow_powerup>
				if (<winner> = 1)
					is_lefty_flip = $p2_lefty
				else
					is_lefty_flip = $p1_lefty
				endif
				if (<select> = 4 & <is_lefty_flip> = 1)
					GetUpperCaseString ($battlemode_powerups[<select>].alt_name_text)
				else
					GetUpperCaseString ($battlemode_powerups[<select>].name_text)
				endif
				final_blow_attack_text = <uppercasestring>
				final_blow_attack_icon = ($battlemode_powerups[<select>].card_texture)
				CreateScreenElement {
					Type = TextBlockElement
					parent = newspaper_container
					just = [left top]
					internal_just = [left top]
					Pos = (345.0, 486.0)
					rot_angle = -7.5
					Scale = 0.4
					text = <final_blow_attack_text>
					font = fontgrid_title_gh3
					rgba = [223 223 223 255]
					dims = (600.0, 200.0)
				}
				CreateScreenElement {
					Type = SpriteElement
					id = battlecard_final_blow
					parent = newspaper_container
					texture = <final_blow_attack_icon>
					rgba = [255 255 255 255]
					just = [left top]
					rot_angle = -7.5
					Pos = (286.0, 472.0)
					dims = (42.0, 42.0)
				}
			endif
		else
			create_results_layout \{parent = newspaper_container layout = tugofwar_2p}
			FormatText textname = winner_text 'Player %d' d = <winner>
			if ($is_network_game)
				if (<winner> = 2)
					winner_text = $opponent_gamertag
				else
					if NetSessionFunc \{Obj = match func = get_gamertag}
						RemoveComponent \{winner_text} // imagining both string types will conflict
						winner_text = <name>
					endif
				endif
			endif
			// FIX: headliner text/winner is determined by matching note hit count?? instead of scores including long note points
			if NOT (<winner> = 0)
				FormatText textname = who_won_text "%d %t" d = <winner_text> t = Random ( @ 'Conquers With Authority!' @ 'Wins the Crowd!' @ )
				ss_winner_text::SetProps text = <who_won_text> rgba = <winner_color>
			endif
		endif
		
		mode_text = 'UNKNOWN'
		mode_text = ($mode_text[($mode_index.($game_mode))])
		ss_mode_text_block_id::SetProps text = <mode_text>
		get_difficulty_text_upper difficulty = ($current_difficulty)
		name_text_1 = 'PLAYER 1'
		if ($is_network_game)
			if (NetSessionFunc Obj = match func = get_gamertag)
				RemoveComponent \{name_text_1}
				name_text_1 = <name>
			endif
		endif
		FormatText textname = p1_difficulty_text "%n, %d" d = <difficulty_text> n = <name_text_1>
		ss_p1_difficulty::SetProps text = <p1_difficulty_text>
		get_difficulty_text_upper difficulty = ($current_difficulty2)
		name_text_2 = 'PLAYER 2'
		if ($is_network_game)
			RemoveComponent \{name_text_2}
			name_text_2 = $opponent_gamertag
		endif
		FormatText textname = p2_difficulty_text "%n, %d" d = <difficulty_text> n = <name_text_2>
		ss_p2_difficulty::SetProps text = <p2_difficulty_text>
		<p1_stats_pos> = (668.0, 260.0)
		<p2_stats_pos> = (864.0, 260.0)
		displaySprite {
			id = np_circle_1
			parent = newspaper_container
			tex = Song_Summary_Circle_2p
			Pos = (<p1_stats_pos> + (61.0, 61.0))
			rgba = $g_ss_p1_orangeish
			rot_angle = 180
			z = 8
		}
		displaySprite {
			id = np_circle_2
			parent = newspaper_container
			tex = Song_Summary_Circle_2p
			Pos = <p2_stats_pos>
			rgba = $g_ss_p2_violetish
			z = 8
		}
		displayText {
			parent = newspaper_container
			text = '1'
			Pos = (<p1_stats_pos> + (23.0, 3.0))
			Scale = (0.9, 0.6)
			font = text_a11
			rgba = $g_ss_2p_song_title_whiteish
			z = 9
		}
		displayText {
			parent = newspaper_container
			text = '2'
			Pos = (<p2_stats_pos> + (21.0, 3.0))
			Scale = (0.9, 0.6)
			font = text_a11
			rgba = $g_ss_2p_song_title_whiteish
			z = 9
		}
		if (<winner> = 1)
			<l_wing_pos> = (<p1_stats_pos> + (-44.0, 0.0))
			<r_wing_pos> = (<p1_stats_pos> + (39.0, 0.0))
		else
			<l_wing_pos> = (<p2_stats_pos> + (-44.0, 0.0))
			<r_wing_pos> = (<p2_stats_pos> + (44.0, 0.0))
		endif
		if NOT (<winner> = 0)
			displaySprite {
				id = np_left_wing
				parent = newspaper_container
				tex = Song_Summary_Wing_2p
				Pos = <l_wing_pos>
				z = 7
			}
			displaySprite {
				id = np_right_wing
				parent = newspaper_container
				tex = Song_Summary_Wing_2p_Flipped // SHOULD BE ABLE TO USE FLIP_H INSTEAD RIGHT?? unless because of angle stuff somehow
				Pos = <r_wing_pos>
				z = 7
			}
			if (<winner> = 1)
				displaySprite {
					parent = newspaper_container
					tex = Song_Summary_Guitar_Winner_2p
					Pos = (<p1_stats_pos> + (46.0, 0.0))
					z = 6
				}
				displaySprite {
					parent = newspaper_container
					tex = Song_Summary_Guitar_Loser_2p
					Pos = (<p2_stats_pos> + (-44.0, 0.0))
					flip_v
					z = 6
				}
			else
				displaySprite {
					parent = newspaper_container
					tex = Song_Summary_Guitar_Winner_2p
					Pos = (<p2_stats_pos> + (-110.0, 0.0))
					flip_v
					z = 6
				}
				displaySprite {
					parent = newspaper_container
					tex = Song_Summary_Guitar_Loser_2p
					Pos = (<p1_stats_pos> + (44.0, 0.0))
					z = 6
				}
			endif
		endif
		displaySprite {
			id = ss_p1_note_streak_fill
			parent = newspaper_container
			tex = song_summary_notestreak_fill
			Pos = (<p1_stats_pos> + (-8.0, 44.0))
			rgba = <ss_notestreak_fill_color>
		}
		displaySprite {
			id = ss_p2_note_streak_fill
			parent = newspaper_container
			tex = song_summary_notestreak_fill
			Pos = (<p2_stats_pos> + (61.0, 174.0))
			rgba = <ss_notestreak_fill_color>
			rot_angle = 182
		}
		if (<p1_note_streak> > 999)
			<ss_p1_notestreak_pos> = (<p1_stats_pos> + (13.0, 43.0))
			<ss_notestreak_scale> = (1.12, 1.5)
		elseif (<p1_note_streak> > 99)
			<ss_p1_notestreak_pos> = (<p1_stats_pos> + (12.0, 43.0))
			<ss_notestreak_scale> = 1.5
		elseif (<p1_note_streak> < 10)
			<ss_p1_notestreak_pos> = (<p1_stats_pos> + (39.0, 43.0))
			<ss_notestreak_scale> = 1.5
		else
			<ss_p1_notestreak_pos> = (<p1_stats_pos> + (25.0, 43.0))
			<ss_notestreak_scale> = 1.5
		endif
		displayText {
			id = ss_p1_note_streak
			parent = newspaper_container
			text = <p1_note_streak_text>
			Pos = <ss_p1_notestreak_pos>
			Scale = <ss_notestreak_scale>
			font = text_a4
			z = 4
			rgba = <ss_notestreak_color>
			noshadow
		}
		displayText {
			id = ss_p1_note_streak_text
			parent = newspaper_container
			text = 'note streak'
			just = [center center]
			Pos = (<p1_stats_pos> + (52.0, 130.0))
			Scale = (0.55, 0.7)
			font = text_a11
			z = 4
			rgba = <ss_notestreak_text_color>
			noshadow
		}
		GetScreenElementDims id = <id>
		fit_text_in_rectangle id = ss_p1_note_streak_text dims = ((90.0, 0.0) + (0.0, 1.0) * <height>)Pos = (<p1_stats_pos> + (52.0, 130.0))start_x_scale = 0.55 start_y_scale = 0.7 only_if_larger_x = 1
		if (<p2_note_streak> > 999)
			<ss_p2_notestreak_pos> = (<p2_stats_pos> + (-40.0, 43.0))
			<ss_notestreak_scale> = (1.12, 1.5)
		elseif (<p2_note_streak> > 99)
			<ss_p2_notestreak_pos> = (<p2_stats_pos> + (-40.0, 43.0))
			<ss_notestreak_scale> = 1.5
		elseif (<p2_note_streak> < 10)
			<ss_p2_notestreak_pos> = (<p2_stats_pos> + (-10.0, 43.0))
			<ss_notestreak_scale> = 1.5
		else
			<ss_p2_notestreak_pos> = (<p2_stats_pos> + (-26.0, 43.0))
			<ss_notestreak_scale> = 1.5
		endif
		displayText {
			id = ss_p2_note_streak
			parent = newspaper_container
			text = <p2_note_streak_text>
			Pos = <ss_p2_notestreak_pos>
			Scale = <ss_notestreak_scale>
			font = text_a4
			z = 4
			rgba = <ss_notestreak_color>
			noshadow
		}
		displayText {
			id = ss_p2_note_streak_text
			parent = newspaper_container
			text = 'note streak'
			just = [center center]
			Pos = (<p2_stats_pos> + (-2.0, 130.0))
			Scale = (0.55, 0.7)
			font = text_a11
			z = 4
			rgba = <ss_notestreak_text_color>
			noshadow
		}
		GetScreenElementDims id = <id>
		fit_text_in_rectangle id = ss_p2_note_streak_text dims = ((90.0, 0.0) + (0.0, 1.0) * <height>)Pos = (<p2_stats_pos> + (-2.0, 130.0))start_x_scale = 0.55 start_y_scale = 0.7 only_if_larger_x = 1
		displaySprite {
			id = ss_p1_score_fill
			parent = newspaper_container
			tex = Song_Summary_Score_BG_2p
			Pos = (<p1_stats_pos> + (-12.0, 160.0))
			rgba = <ss_score_color>
		}
		displaySprite {
			id = ss_p2_score_fill
			parent = newspaper_container
			tex = Song_Summary_Score_BG_2p
			Pos = (<p2_stats_pos> + (54.0, 192.0))
			rgba = <ss_score_color>
			rot_angle = 181
		}
		displayText {
			id = ss_p1_score_text
			parent = newspaper_container
			text = 'Score'
			Pos = (<p1_stats_pos> + (10.0, 155.0))
			Scale = (0.7, 0.5)
			font = text_a11
			z = 4
			rgba = $g_ss_2p_song_title_whiteish
			noshadow
			rot = -2
		}
		displayText {
			id = ss_p2_score_text
			parent = newspaper_container
			text = 'Score'
			Pos = (<p2_stats_pos> + (-50.0, 155.0))
			Scale = (0.7, 0.5)
			font = text_a11
			z = 4
			rgba = $g_ss_2p_song_title_whiteish
			noshadow
			rot = -2
		}
		displayText {
			id = ss_p1_score
			parent = newspaper_container
			text = <p1_score_text>
			just = [center center]
			Pos = (<p1_stats_pos> + (48.0, 200.0))
			Scale = (0.8, 1.0)
			font = text_a4
			rgba = <ss_score_color>
			z = 3
			noshadow
		}
		displayText {
			id = ss_p2_score
			parent = newspaper_container
			text = <p2_score_text>
			just = [center center]
			Pos = (<p2_stats_pos> + (-12.0, 200.0))
			Scale = (0.8, 1.0)
			font = text_a4
			rgba = <ss_score_color>
			z = 3
			noshadow
		}
		FormatText textname = p1_notes_hit '%d' d = <p1_percent_complete>
		if (<p1_percent_complete> = 100)
			<ss_percent_pos> = (<p1_stats_pos> + (2.0, 204.0))
			<ss_percent_scale> = (0.7, 1.47)
		elseif (<p1_percent_complete> < 10)
			<ss_percent_pos> = (<p1_stats_pos> + (10.0, 206.0))
			<ss_percent_scale> = (1.6, 1.47)
		else
			<ss_percent_pos> = (<p1_stats_pos> + (6.0, 207.0))
			<ss_percent_scale> = (0.9, 1.47)
		endif
		displayText {
			id = ss_p1_notes_hit
			parent = newspaper_container
			text = <p1_notes_hit>
			Pos = <ss_percent_pos>
			Scale = <ss_percent_scale>
			font = text_a4
			z = 4
			rgba = <ss_percent_color>
			noshadow
		}
		FormatText textname = p2_notes_hit '%d' d = <p2_percent_complete>
		if (<p2_percent_complete> = 100)
			<ss_percent_pos> = (<p2_stats_pos> + (-70.0, 204.0))
			<ss_percent_scale> = (0.7, 1.47)
		elseif (<p2_percent_complete> < 10)
			<ss_percent_pos> = (<p2_stats_pos> + (-62.0, 206.0))
			<ss_percent_scale> = (1.6, 1.47)
		else
			<ss_percent_pos> = (<p2_stats_pos> + (-66.0, 207.0))
			<ss_percent_scale> = (0.9, 1.47)
		endif
		displayText {
			id = ss_p2_notes_hit
			parent = newspaper_container
			text = <p2_notes_hit>
			Pos = <ss_percent_pos>
			Scale = <ss_percent_scale>
			font = text_a4
			z = 4
			rgba = <ss_percent_color>
			noshadow
		}
		displayText {
			id = ss_p1_percent_sign
			parent = newspaper_container
			text = '%'
			Pos = (<p1_stats_pos> + (60.0, 226.0))
			font = text_a4
			z = 4
			rgba = <ss_percent_color>
			rot = 50
			Scale = (0.7, 0.5)
			noshadow
		}
		displayText {
			id = ss_p1_notes_text
			parent = newspaper_container
			text = '\u0NOTES' // wtf is this
			Pos = (<p1_stats_pos> + (66.0, 232.0))
			Scale = (0.4, 0.7)
			font = text_a3
			z = 4
			rgba = <ss_percent_color>
			noshadow
		}
		SetScreenElementProps id = <id> font_spacing = 4
		fit_text_in_rectangle id = ss_p1_notes_text dims = (38.0, 30.0) Pos = (<p1_stats_pos> + (66.0, 232.0))start_x_scale = 0.4 start_y_scale = 0.7 only_if_larger_x = 1
		displayText {
			id = ss_p1_hit_text
			parent = newspaper_container
			text = '\u0HIT'
			Pos = (<p1_stats_pos> + (67.0, 257.0))
			Scale = (0.4, 0.6)
			font = text_a3
			z = 4
			rgba = <ss_percent_color>
			noshadow
		}
		SetScreenElementProps id = <id> font_spacing = 6
		fit_text_in_rectangle id = ss_p1_hit_text dims = (38.0, 30.0) Pos = (<p1_stats_pos> + (67.0, 257.0))start_x_scale = 0.4 start_y_scale = 0.6 only_if_larger_x = 1
		displayText {
			id = ss_p2_percent_sign
			parent = newspaper_container
			text = '%'
			Pos = (<p2_stats_pos> + (-12.0, 226.0))
			font = text_a4
			z = 4
			rgba = <ss_percent_color>
			rot = 50
			Scale = (0.7, 0.5)
			noshadow
		}
		displayText {
			id = ss_p2_notes_text
			parent = newspaper_container
			text = '\u0NOTES'
			Pos = (<p2_stats_pos> + (-6.0, 232.0))
			Scale = (0.4, 0.7)
			font = text_a3
			z = 4
			rgba = <ss_percent_color>
			noshadow
		}
		SetScreenElementProps id = <id> font_spacing = 4
		fit_text_in_rectangle id = ss_p2_notes_text dims = (45.0, 30.0) Pos = (<p2_stats_pos> + (-6.0, 232.0))start_x_scale = 0.4 start_y_scale = 0.7 only_if_larger_x = 1
		displayText {
			id = ss_p2_hit_text
			parent = newspaper_container
			text = '\u0HIT'
			Pos = (<p2_stats_pos> + (-5.0, 257.0))
			Scale = (0.4, 0.6)
			font = text_a3
			z = 4
			rgba = <ss_percent_color>
			noshadow
		}
		SetScreenElementProps id = <id> font_spacing = 6
		fit_text_in_rectangle id = ss_p2_hit_text dims = (45.0, 30.0) Pos = (<p2_stats_pos> + (-5.0, 257.0))start_x_scale = 0.4 start_y_scale = 0.6 only_if_larger_x = 1
		if (<winner> = 1)
			displaySprite {
				id = np_icon_thumb
				parent = newspaper_container
				tex = Song_Summary_Icon_Winner_2p
				Pos = (<p1_stats_pos> + (46.0, 330.0))
				rgba = $g_ss_p1_orangeish
				just = [center center]
				dims = (64.0, 64.0)
			}
			displaySprite {
				id = np_icon_skull
				parent = newspaper_container
				tex = Song_Summary_Icon_Loser_2p
				Pos = (<p2_stats_pos> + (-55.0, 294.0))
				rgba = $g_ss_p2_violetish
				dims = (64.0, 64.0)
			}
		elseif (<winner> = 2)
			displaySprite {
				id = np_icon_thumb
				parent = newspaper_container
				tex = Song_Summary_Icon_Winner_2p
				Pos = (<p2_stats_pos> + (-16.0, 320.0))
				rgba = $g_ss_p2_violetish
				just = [center center]
				dims = (64.0, 64.0)
				flip_v
			}
			displaySprite {
				id = np_icon_skull
				parent = newspaper_container
				tex = Song_Summary_Icon_Loser_2p
				Pos = (<p1_stats_pos> + (22.0, 294.0))
				rgba = $g_ss_p1_orangeish
				dims = (64.0, 64.0)
				flip_v
			}
		endif
		if NOT (<winner> = 0)
			<i> = 1
			begin
				FormatText checksumName = hilite_id 'ss_hilite%d_p%p' d = <i> p = <winner>
				if (<i> = 3)
					<i> = 2
				endif
				if (<i> = 1)
					hilite_tex = Char_Select_Hilite1
				else
					hilite_tex = HUD_Score_flash
				endif
				<hilite_rgba> = [200 90 40 255]
				<hilite_pos> = (<p1_stats_pos> + (46.0, 330.0))
				if (<winner> = 2)
					<hilite_rgba> = [180 130 220 255]
					<hilite_pos> = (<p2_stats_pos> + (-16.0, 320.0))
				endif
				displaySprite {
					id = <hilite_id>
					parent = newspaper_container
					Pos = <hilite_pos>
					tex = <hilite_tex>
					dims = (220.0, 220.0)
					just = 0
					z = 1
				}
				if (<i> = 1)
					<id>::SetProps rgba = <hilite_rgba> alpha = 0.25 dims = (180.0, 180.0)
				endif
				<i> = (<i> + 1)
			repeat 3
		endif
		if NOT (<winner> = 0)
			spawnscriptnow \{np_2p_flap_wings}
			spawnscriptnow \{np_2p_thumb_zoom}
			spawnscriptnow np_2p_fade_to_grey params = {winner = <winner>}
		endif
		if (<winner> = 1)
			spawnscriptnow \{np_2p_hilites_p1}
		elseif (<winner> = 2)
			spawnscriptnow \{np_2p_hilites_p2}
		endif
	else
		<ss_percent_color> = $g_ss_percent_color
		<ss_star_good_color> = $g_ss_star_good_color
		<ss_star_bad_color> = $g_ss_star_bad_color
		<ss_score_fill_L_color> = $g_ss_score_fill_L_color
		<ss_score_color> = $g_ss_score_color
		<ss_score_fill_R_color> = $g_ss_score_fill_R_color
		<ss_score_text_color> = $g_ss_score_text_color
		<ss_notestreak_fill_color> = $g_ss_notestreak_fill_color
		<ss_notestreak_color> = $g_ss_notestreak_color
		<ss_notestreak_text_color> = $g_ss_notestreak_text_color
		create_results_layout {
			parent = newspaper_container layout = quickplay_1p
			info = {
				notes_hit = <p1_percent_complete>
				streak = <p1_note_streak>
			}
		}
		// add code to detect if layout wants to fit stuff within width
		// UIShortenString & StringLength
		if (<for_practice> = 0)
			if (<show_stars> = 1)
				<star_pos> = (686.0, 120.0)
				<star_add> = (23.0, 0.0)
				<i> = 0
				begin
					<star_offset> = (0.0, 0.0)
					if (<i> = 1)
						<star_rot> = 20
						<star_offset> = (4.0, -3.0)
					elseif (<i> = 3)
						<star_rot> = -20
						<star_offset> = (-2.0, 3.0)
					else
						<star_rot> = 0
					endif
					if ((<stars> - <i>)< 1)
						<star_color> = <ss_star_bad_color>
					else
						<star_color> = <ss_star_good_color>
					endif
					displaySprite {
						parent = newspaper_container
						Pos = (<star_pos> + <star_offset>)
						Scale = 0.65
						tex = song_summary_score_star
						z = 4
						rgba = <star_color>
						rot_angle = <star_rot>
					}
					<i> = (<i> + 1)
					<star_pos> = (<star_pos> + <star_add>)
				repeat 5
			endif
			displayText {
				id = np_score_text
				parent = newspaper_container
				text = <p1_score_text>
				just = [right center]
				Pos = (926.0, 116.0)
				Scale = (0.9, 0.65)
				font = text_a4
				rgba = <ss_score_color>
				z = 3
				noshadow
			}
			<curr_dif> = ($current_difficulty)
			if ($game_mode = p2_career)
				<index1> = ($difficulty_list_props.($current_difficulty).index)
				<index2> = ($difficulty_list_props.($current_difficulty2).index)
				if (<index2> < <index1>)
					<curr_dif> = ($current_difficulty2)
				endif
			endif
			get_difficulty_text_upper difficulty = <curr_dif>
			displayText {
				parent = newspaper_container
				just = [left bottom]
				text = <difficulty_text>
				Pos = (946.0, 133.0)
				Scale = (0.7, 0.6)
				font = text_a11
				z = 4
				rgba = $g_ss_offwhite
				noshadow
			}
			SetScreenElementProps id = <id> font_spacing = 3
			fit_text_in_rectangle id = <id> dims = (100.0, 100.0) only_if_larger_x = 1 keep_ar = 1 start_x_scale = 0.7 start_y_scale = 0.6 debug_me
		else
			notes_hit = ($player1_status.notes_hit)
			notes_total = ($player1_status.total_notes)
			FormatText textname = notes_hit_out_of_total '%a OUT OF %b' a = <notes_hit> b = <notes_total>
			displayText {
				id = np_score_text
				parent = newspaper_container
				text = <notes_hit_out_of_total>
				just = [right center]
				Pos = (911.0, 117.0)
				Scale = (0.9, 0.65)
				font = text_a4
				rgba = <ss_score_color>
				z = 3
				noshadow
				rot = -2
			}
			GetScreenElementDims id = <id>
			SetScreenElementProps id = <id> Scale = (0.9, 0.65)
			fit_text_in_rectangle id = <id> dims = ((200.0, 0.0) + <height> * (0.0, 0.65))
			displayText {
				parent = newspaper_container
				text = 'NOTES'
				Pos = (946.0, 98.0)
				Scale = (0.7, 0.6)
				font = text_a11
				z = 4
				rgba = <ss_score_text_color>
				noshadow
			}
			GetScreenElementDims id = <id>
			SetScreenElementProps id = <id> Scale = (0.7, 0.6)
			fit_text_in_rectangle id = <id> dims = ((70.0, 0.0) + <height> * (0.0, 0.6))
		endif
		//displaySprite {
		//	parent = newspaper_container
		//	tex = song_summary_score_fill_r
		//	Pos = (934.0, 83.0)
		//	rgba = <ss_score_fill_R_color>
		//	dims = (134.0, 67.0)
		//}
		//displaySprite {
		//	parent = newspaper_container
		//	tex = song_summary_notestreak_fill
		//	Pos = (719.0, 359.0)
		//	rgba = <ss_notestreak_fill_color>
		//}
	endif
	if ($is_network_game)
		np_net_create_options_menu Pos = (770.0, 460.0) rot = <rot> Scale = 1 for_practice = <for_practice> show_replay = <show_replay> replay_flow_params = <replay_flow_params>
	elseif ($game_mode = p1_career || $game_mode = p2_career || $game_mode = p1_quickplay)
		np_create_options_menu Pos = (770.0, 460.0) rot = <rot> Scale = 1 for_practice = <for_practice> show_replay = <show_replay> replay_flow_params = <replay_flow_params>
	else
		np_create_options_menu Pos = (770.0, 360.0) rot = <rot> Scale = 1 for_practice = <for_practice> show_replay = <show_replay> replay_flow_params = <replay_flow_params>
	endif
	if ((StructureContains structure = <song_struct> boss)|| $game_mode = p2_battle)
		set_current_battle_first_play
	endif
	Change \{user_control_pill_text_color = [0 0 0 255]}
	Change \{user_control_pill_color = [180 180 180 255]}
	if ($is_network_game = 1)
		add_user_control_helper \{text = 'EXIT' button = green z = 100}
	else
		common_control_helpers \{select}
	endif
	if ($is_network_game = 1)
		get_number_of_songs
		if NOT ((($net_song_num)!= (<num_songs> - 1))|| ($game_mode = p2_coop))
			clean_up_user_control_helpers
		endif
	endif
	if NOT ($is_network_game)
		common_control_helpers \{nav}
	endif
endscript

script destroy_newspaper_menu
	if ($menu_choose_practice_destroy_previous_menu = 1)
		clean_up_user_control_helpers
		killspawnedscript \{name = np_2p_flap_wings}
		killspawnedscript \{name = np_2p_thumb_zoom}
		killspawnedscript \{name = np_2p_fade_to_grey}
		killspawnedscript \{name = np_2p_hilites_p1}
		killspawnedscript \{name = np_2p_hilites_p2}
		destroy_menu \{menu_id = newspaper_scroll}
		destroy_menu \{menu_id = newspaper_container}
		destroy_menu_backdrop
		net_destroy_newspaper_menu
		Change \{g_np_options_index = 0}
	endif
endscript

script np_scroll_text_horizontal\{time = 5 band_name = "" song_name = "" band_rgba = [0 0 0 255] song_rgba = [0 0 0 255]}
	start_pos = <Pos>
	CreateScreenElement {
		Type = ContainerElement
		parent = <parent>
		id = np_scroll_text_container
		Pos = (0.0, 0.0)
	}
	num = 0
	FormatText checksumName = nID '%d' d = <num>
	displayText id = <nID> parent = np_scroll_text_container Pos = <Pos> Scale = 1 font = <font> text = <band_name> rgba = <band_rgba>
	GetScreenElementDims id = <nID>
	band_width = <width>
	<num> = (<num> + 1)
	FormatText checksumName = nID '%d' d = <num>
	<Pos> = (<Pos> + (1.0, 0.0) * <band_width>)
	displayText id = <nID> parent = np_scroll_text_container Pos = <Pos> Scale = 1 font = <font> text = <song_name> rgba = <song_rgba>
	GetScreenElementDims id = <nID>
	song_width = <width>
	end_pos = (<start_pos> - ((<band_width> + <song_width>)* (1.0, 0.0)))
	multi = (<blockWidth> / (<band_width> + <song_width>))
	if NOT (<multi>)
		<multi> = 1
	endif
	onband = 1
	if (<multi>)
		begin
			if (<onband>)
				<Pos> = (<Pos> + ((1.0, 0.0) * <song_width>))
				<num> = (<num> + 1)
				FormatText checksumName = nID '%d' d = <num>
				displayText id = <nID> parent = np_scroll_text_container Pos = <Pos> Scale = 1 font = <font> text = <band_name> rgba = <band_rgba>
				<onband> = 0
			else
				<Pos> = (<Pos> + ((1.0, 0.0) * <band_width>))
				<num> = (<num> + 1)
				FormatText checksumName = nID '%d' d = <num>
				displayText id = <nID> parent = np_scroll_text_container Pos = <Pos> Scale = 1 font = <font> text = <song_name> rgba = <song_rgba>
				<onband> = 1
			endif
		repeat (<multi> * 2)
	endif
	begin
		DoScreenElementMorph id = np_scroll_text_container Pos = <end_pos> time = <time>
		wait <time> seconds
		SetScreenElementProps id = np_scroll_text_container Pos = <start_pos>
	repeat
endscript

script np_create_text\{Pos = (200.0, 200.0) rot = 0 text = "No text given" parent = newspaper_container Scale = 1 rgba = [0 0 0 255] just = [center top] internal_just = [left left]}
	if GotParam \{dims}
		CreateScreenElement {
			Type = TextBlockElement
			parent = <parent>
			just = <just>
			internal_just = <internal_just>
			Pos = <Pos>
			rot_angle = <rot>
			Scale = <Scale>
			text = <text>
			font = fontgrid_title_gh3
			rgba = <rgba>
			z_priority = 3
			dims = <dims>
		}
	else
		CreateScreenElement {
			Type = TextElement
			parent = <parent>
			just = <just>
			internal_just = <internal_just>
			Pos = <Pos>
			rot_angle = <rot>
			Scale = <Scale>
			text = <text>
			font = fontgrid_title_gh3
			rgba = <rgba>
			z_priority = 3
		}
	endif
endscript

script np_create_options_menu\{Pos = (600.0, 300.0) rot = 0 Scale = 0.8 menu_font = text_a11 for_practice = 0}
	SetScreenElementProps id = newspaper_scroll Pos = <Pos>
	set_focus_color \{rgba = $g_ss_black}
	set_unfocus_color \{rgba = $g_ss_offwhite}
	if (<for_practice> = 1)
		<menu_offset> = (0.0, -6.0)
	elseif NOT ($game_mode = p1_career || $game_mode = p2_career || $game_mode = p2_coop || $game_mode = p1_quickplay)
		<menu_offset> = (0.0, -65.0)
	else
		<menu_offset> = (0.0, 0.0)
	endif
	if (<for_practice> = 1)
		displayText id = np_option_0 parent = newspaper_container text = 'EXIT' Pos = (($g_np_option_props [4].Pos)+ <menu_offset>)Scale = (0.85, 0.7) rot = ($g_np_option_props [4].rot)font = <menu_font> noshadow
		displayText id = np_option_1 parent = newspaper_container text = 'RESTART' Pos = (($g_np_option_props [5].Pos)+ <menu_offset>)Scale = (0.8, 0.7) rot = ($g_np_option_props [5].rot)font = <menu_font> noshadow
		displayText id = np_option_2 parent = newspaper_container text = 'CHANGE SPEED' Pos = (($g_np_option_props [6].Pos)+ <menu_offset>)Scale = (0.8, 0.7) rot = ($g_np_option_props [6].rot)font = <menu_font> noshadow
		displayText id = np_option_3 parent = newspaper_container text = 'CHANGE SECTION' Pos = (($g_np_option_props [7].Pos)+ <menu_offset>)Scale = (0.8, 0.7) rot = ($g_np_option_props [7].rot)font = <menu_font> noshadow
		displayText id = np_option_4 parent = newspaper_container text = 'QUIT' Pos = (($g_np_option_props [8].Pos)+ <menu_offset>)Scale = (0.8, 0.7) rot = ($g_np_option_props [8].rot)font = <menu_font> noshadow
		retail_menu_unfocus \{id = np_option_4}
		<initial_hl_pos> = (($g_np_option_props [4].Pos)+ ($g_np_option_props [4].offset)+ <menu_offset>)
	else
		displayText id = np_option_0 parent = newspaper_container text = 'EXIT' Pos = (($g_np_option_props [0].Pos)+ <menu_offset>)Scale = (0.85, 0.7) rot = ($g_np_option_props [0].rot)font = <menu_font> noshadow
		SetScreenElementProps id = <id> font_spacing = 2 space_spacing = 4
		if NOT ($end_credits = 1)
			if (<show_replay> = 1)
				displayText id = np_option_1 parent = newspaper_container text = 'RETRY SONG' Pos = (($g_np_option_props [1].Pos)+ <menu_offset>)Scale = (0.8, 0.7) rot = ($g_np_option_props [1].rot)font = <menu_font> noshadow
				SetScreenElementProps id = <id> font_spacing = 2 space_spacing = 4
				displayText id = np_option_2 parent = newspaper_container text = 'MORE STATS' Pos = (($g_np_option_props [2].Pos)+ <menu_offset>)Scale = (0.8, 0.7) rot = ($g_np_option_props [2].rot)font = <menu_font> noshadow
				SetScreenElementProps id = <id> font_spacing = 2 space_spacing = 4
			else
				displayText id = np_option_1 parent = newspaper_container text = 'MORE STATS' Pos = (($g_np_option_props [1].Pos)+ <menu_offset>)Scale = (0.8, 0.7) rot = ($g_np_option_props [2].rot)font = <menu_font> noshadow
				SetScreenElementProps id = <id> font_spacing = 2 space_spacing = 4
			endif
		endif
		<initial_hl_pos> = (($g_np_option_props [0].Pos)+ ($g_np_option_props [0].offset)+ <menu_offset>)
	endif
	retail_menu_focus \{id = np_option_0}
	retail_menu_unfocus \{id = np_option_1}
	retail_menu_unfocus \{id = np_option_2}
	retail_menu_unfocus \{id = np_option_3}
	<ss_hilite_color> = $g_ss_offwhite
	<ss_menu_icon> = none
	displaySprite {
		id = ss_menu_hilite_id
		parent = newspaper_container
		tex = white
		Pos = <initial_hl_pos>
		rgba = <ss_hilite_color>
		rot_angle = ($g_np_option_props[$g_np_options_index].rot)
		dims = (320.0, 32.0)
		z = 1
	}
	displaySprite {
		id = ss_menu_icon_id
		parent = newspaper_container
		tex = <ss_menu_icon>
		Pos = (<initial_hl_pos> + ($g_np_menu_icon_offset))
		rot_angle = ($g_np_option_props[$g_np_options_index].rot)
		dims = (80.0, 80.0)
		z = 3
	}
	if (<for_practice> = 1)
		if ($came_to_practice_from = main_menu)
			continue_handlers = [
				{focus retail_menu_focus}
				{focus SetScreenElementProps params = {id = np_option_0}}
				{unfocus retail_menu_unfocus}
				{unfocus SetScreenElementProps params = {id = np_option_0}}
				{pad_choose setup_for_change_section}
				{pad_choose ui_flow_manager_respond_to_action params = {action = new_song}}
			]
		else
			continue_handlers = [
				{focus retail_menu_focus}
				{focus SetScreenElementProps params = {id = np_option_0}}
				{unfocus retail_menu_unfocus}
				{unfocus SetScreenElementProps params = {id = np_option_0}}
				{pad_choose setup_for_change_section}
				{pad_choose ui_flow_manager_respond_to_action params = {action = back_2_setlist}}
			]
		endif
		CreateScreenElement {
			Type = TextElement
			parent = newspaper_vmenu
			font = <menu_font>
			event_handlers = <continue_handlers>
		}
		CreateScreenElement {
			Type = TextElement
			parent = newspaper_vmenu
			font = <menu_font>
			event_handlers = [
				{focus retail_menu_focus}
				{focus SetScreenElementProps params = {id = np_option_1}}
				{unfocus retail_menu_unfocus}
				{unfocus SetScreenElementProps params = {id = np_option_1}}
				{pad_choose setup_for_change_section}
				{pad_choose ui_flow_manager_respond_to_action params = {action = restart}}
			]
		}
		CreateScreenElement {
			Type = TextElement
			parent = newspaper_vmenu
			font = <menu_font>
			event_handlers = [
				{focus retail_menu_focus}
				{focus SetScreenElementProps params = {id = np_option_2}}
				{unfocus retail_menu_unfocus}
				{unfocus SetScreenElementProps params = {id = np_option_2}}
				{pad_choose setup_for_change_speed}
				{pad_choose ui_flow_manager_respond_to_action params = {action = change_speed}}
			]
		}
		CreateScreenElement {
			Type = TextElement
			parent = newspaper_vmenu
			font = <menu_font>
			event_handlers = [
				{focus retail_menu_focus}
				{focus SetScreenElementProps params = {id = np_option_3}}
				{unfocus retail_menu_unfocus}
				{unfocus SetScreenElementProps params = {id = np_option_3}}
				{pad_choose setup_for_change_section}
				{pad_choose ui_flow_manager_respond_to_action params = {action = change_section}}
			]
		}
		CreateScreenElement {
			Type = TextElement
			parent = newspaper_vmenu
			font = <menu_font>
			event_handlers = [
				{focus retail_menu_focus}
				{focus SetScreenElementProps params = {id = np_option_4}}
				{unfocus retail_menu_unfocus}
				{unfocus SetScreenElementProps params = {id = np_option_4}}
				{pad_choose setup_for_change_section}
				{pad_choose ui_flow_manager_respond_to_action params = {action = exit}}
			]
		}
	else
		CreateScreenElement {
			Type = TextElement
			parent = newspaper_vmenu
			font = <menu_font>
			event_handlers = [
				{focus retail_menu_focus}
				{focus SetScreenElementProps params = {id = np_option_0}}
				{unfocus retail_menu_unfocus}
				{unfocus SetScreenElementProps params = {id = np_option_0}}
				{pad_choose setup_for_change_section}
				{pad_choose ui_flow_manager_respond_to_action params = {action = continue}}
			]
		}
		if NOT ($end_credits = 1)
			more_stats_option_id = np_option_1
			if (<show_replay> = 1)
				CreateScreenElement {
					Type = TextElement
					parent = newspaper_vmenu
					font = <menu_font>
					event_handlers = [
						{focus retail_menu_focus}
						{focus SetScreenElementProps params = {id = np_option_1}}
						{unfocus retail_menu_unfocus}
						{unfocus SetScreenElementProps params = {id = np_option_1}}
						{pad_choose ui_flow_manager_respond_to_action params = <replay_flow_params>}
					]
				}
				more_stats_option_id = np_option_2
			endif
			CreateScreenElement {
				Type = TextElement
				parent = newspaper_vmenu
				font = <menu_font>
				event_handlers = [
					{focus retail_menu_focus}
					{focus SetScreenElementProps params = {id = <more_stats_option_id>}}
					{unfocus retail_menu_unfocus}
					{unfocus SetScreenElementProps params = {id = <more_stats_option_id>}}
					{pad_choose ui_flow_manager_respond_to_action params = {action = select_detailed_stats}}
				]
			}
		endif
	endif
endscript

script setup_for_change_section
	Change \{menu_choose_practice_destroy_previous_menu = 1}
endscript

script setup_for_change_speed
	Change \{menu_choose_practice_destroy_previous_menu = 0}
endscript

script np_scroll_down\{for_practice = 0}
	if ($end_credits = 1)
		return
	endif
	if ($is_network_game)
		return
	endif
	generic_menu_up_or_down_sound
	if (<for_practice> = 1)
		<menu_offset> = (0.0, -6.0)
	elseif NOT ($game_mode = p1_career || $game_mode = p2_career || $game_mode = p2_coop || $game_mode = p1_quickplay)
		<menu_offset> = (0.0, -65.0)
	else
		<menu_offset> = (0.0, 0.0)
	endif
	if (<for_practice> = 1)
		FormatText checksumName = option_id 'np_option_%d' d = ($g_np_options_index - 4)
	else
		FormatText \{checksumName = option_id 'np_option_%d' d = $g_np_options_index}
	endif
	retail_menu_unfocus id = <option_id>
	Change g_np_options_index = ($g_np_options_index + 1)
	printf "new g_np_options_index = %d" d = ($g_np_options_index)
	if (<for_practice> = 1)
		if ($g_np_options_index > 8)
			Change \{g_np_options_index = 4}
		endif
		FormatText checksumName = option_id 'np_option_%d' d = ($g_np_options_index - 4)
	else
		if (<show_replay> = 1)
			if ($g_np_options_index > 2)
				Change \{g_np_options_index = 0}
			endif
		else
			if ($g_np_options_index > 1)
				Change \{g_np_options_index = 0}
			endif
		endif
		FormatText \{checksumName = option_id 'np_option_%d' d = $g_np_options_index}
	endif
	retail_menu_focus id = <option_id>
	DoScreenElementMorph {
		id = ss_menu_hilite_id
		Pos = (($g_np_option_props [$g_np_options_index].Pos)+ ($g_np_option_props [$g_np_options_index].offset)+ <menu_offset>)
		rot_angle = (($g_np_option_props [$g_np_options_index].rot)+ 0.5)
		time = 0.05
	}
	DoScreenElementMorph {
		id = ss_menu_icon_id
		Pos = (($g_np_option_props [$g_np_options_index].Pos)+ ($g_np_option_props [$g_np_options_index].offset)+ ($g_np_menu_icon_offset)+ <menu_offset>)
		rot_angle = ($g_np_option_props [$g_np_options_index].rot)
		time = 0.05
	}
endscript

script np_scroll_up\{for_practice = 0}
	if ($end_credits = 1)
		return
	endif
	if ($is_network_game)
		return
	endif
	generic_menu_up_or_down_sound
	if (<for_practice> = 1)
		<menu_offset> = (0.0, -6.0)
	elseif NOT ($game_mode = p1_career || $game_mode = p2_career || $game_mode = p2_coop || $game_mode = p1_quickplay)
		<menu_offset> = (0.0, -65.0)
	else
		<menu_offset> = (0.0, 0.0)
	endif
	if (<for_practice> = 1)
		FormatText checksumName = option_id 'np_option_%d' d = ($g_np_options_index - 4)
	else
		FormatText \{checksumName = option_id 'np_option_%d' d = $g_np_options_index}
	endif
	retail_menu_unfocus id = <option_id>
	Change g_np_options_index = ($g_np_options_index -1)
	if (<for_practice> = 1)
		if ($g_np_options_index < 4)
			Change \{g_np_options_index = 8}
		endif
		FormatText checksumName = option_id 'np_option_%d' d = ($g_np_options_index - 4)
	else
		if (<show_replay> = 1)
			if ($g_np_options_index < 0)
				Change \{g_np_options_index = 2}
			endif
		else
			if ($g_np_options_index < 0)
				Change \{g_np_options_index = 1}
			endif
		endif
		FormatText \{checksumName = option_id 'np_option_%d' d = $g_np_options_index}
	endif
	retail_menu_focus id = <option_id>
	DoScreenElementMorph {
		id = ss_menu_hilite_id
		Pos = (($g_np_option_props [$g_np_options_index].Pos)+ ($g_np_option_props [$g_np_options_index].offset)+ <menu_offset>)
		rot_angle = (($g_np_option_props [$g_np_options_index].rot)+ 0.5)
		time = 0.05
	}
	DoScreenElementMorph {
		id = ss_menu_icon_id
		Pos = (($g_np_option_props [$g_np_options_index].Pos)+ ($g_np_option_props [$g_np_options_index].offset)+ ($g_np_menu_icon_offset)+ <menu_offset>)
		rot_angle = ($g_np_option_props [$g_np_options_index].rot)
		time = 0.05
	}
endscript

script scale_textblock\{reset_scale = 0}
	GetScreenElementDims id = <id>
	block_width = (<width> * 1.0)
	block_height = (<height> * 1.0)
	GetScreenElementChildren id = <id>
	if GotParam \{children}
		i = 0
		GetArraySize <children>
		begin
			GetScreenElementDims id = (<children> [<i>])
			width_scale = (<block_width> / <width>)
			height_scale = ((<block_height> / <array_Size>)/ <height>)
			if (<reset_scale> = 1)
				text_scale = (((1.0 / <width_scale>)* (1.0, 0.0))+ ((0.0, 1.0) * 1.0))
			else
				text_scale = (((1.0, 0.0) * <width_scale>)+ ((0.0, 1.0) * 1.0))
			endif
			SetScreenElementProps id = (<children> [<i>])Scale = <text_scale>
			<i> = (<i> + 1)
		repeat <array_Size>
	endif
	return num_children = <array_Size>
endscript

script np_2p_hilite_sections
	black = [0 0 0 255]
	time = 1
	begin
		i = 0
		j = 2
		begin
			if (<i> = 2)
				<j> = 3
			else
				<j> = 2
			endif
			np_set_section_color p = 1 i = <i> j = <j> Color = <black>
			np_set_section_color p = 2 i = <i> j = <j> Color = <black>
			wait <time> seconds
			np_set_section_color p = 1 i = <i> j = <j> Color = $g_gray
			np_set_section_color p = 2 i = <i> j = <j> Color = $g_gray
			<i> = <new_i>
		repeat 3
	repeat
endscript

script np_set_section_color
	begin
		FormatText checksumName = section_id 'p%p_np_%d' p = <p> d = <i>
		SetScreenElementProps id = <section_id> rgba = <Color>
		<i> = (<i> + 1)
	repeat <j>
	return new_i = <i>
endscript

script np_2p_flap_wings
	<flap_time> = 0.6
	GetScreenElementProps \{id = np_left_wing}
	SetScreenElementProps \{id = np_left_wing just = [0.9688 0.6875001]}
	SetScreenElementProps \{id = np_right_wing just = [-0.9688 0.6875001]}
	begin
		DoScreenElementMorph id = np_left_wing rot_angle = 20 time = <flap_time> motion = ease_out
		DoScreenElementMorph id = np_right_wing rot_angle = -20 time = <flap_time> motion = ease_out
		wait <flap_time> seconds
		DoScreenElementMorph id = np_left_wing rot_angle = -20 time = <flap_time> motion = ease_in
		DoScreenElementMorph id = np_right_wing rot_angle = 20 time = <flap_time> motion = ease_in
		wait (<flap_time> * 2)seconds
	repeat
endscript

script np_2p_thumb_zoom
	<zoom_time> = 0.4
	<bounce_time> = 0.5
	<thumb_orig_pos> = (240.0, -30.0)
	<thumb_orig_alpha> = 0.25
	<thumb_orig_scale> = 12
	GetScreenElementProps \{id = np_icon_thumb}
	<thumb_final_pos> = <Pos>
	<thumb_final_alpha> = 1.0
	<thumb_bounce_scale> = 1.5
	SetScreenElementProps {
		id = np_icon_thumb
		Pos = <thumb_orig_pos>
		alpha = <thumb_orig_alpha>
		Scale = <thumb_orig_scale>
		relative_scale
		preserve_flip
	}
	DoScreenElementMorph {
		id = np_icon_thumb
		Pos = <thumb_final_pos>
		alpha = <thumb_final_alpha>
		Scale = 1
		relative_scale
		time = <zoom_time>
	}
	wait (<zoom_time> * 1.5)seconds
	begin
		DoScreenElementMorph {
			id = np_icon_thumb
			Scale = <thumb_bounce_scale>
			relative_scale
			time = <bounce_time>
			motion = ease_in
		}
		wait <bounce_time> seconds
		DoScreenElementMorph {
			id = np_icon_thumb
			Scale = 1
			relative_scale
			time = <bounce_time>
			motion = ease_out
		}
		wait <bounce_time> seconds
	repeat
endscript

script np_2p_fade_to_grey
	wait \{1 Second}
	if (<winner> = "2")
		<stroke_pos> = (798.0, 260.0)
	else
		<stroke_pos> = (934.0, 280.0)
	endif
	<drain_time> = 2
	if (<winner> = "2")
		DoScreenElementMorph id = ss_p1_note_streak_fill rgba = [128 128 128 255] time = <drain_time>
		DoScreenElementMorph id = ss_p1_note_streak rgba = [210 210 210 255] time = <drain_time>
		DoScreenElementMorph id = ss_p1_note_streak_text rgba = [220 220 220 255] time = <drain_time>
		DoScreenElementMorph id = ss_p1_score_fill rgba = [128 128 128 255] time = <drain_time>
		DoScreenElementMorph id = ss_p1_score_text rgba = [220 220 220 255] time = <drain_time>
		DoScreenElementMorph id = ss_p1_score rgba = [128 128 128 255] time = <drain_time>
		DoScreenElementMorph id = ss_p1_notes_hit rgba = [128 128 128 255] time = <drain_time>
		DoScreenElementMorph id = ss_p1_percent_sign rgba = [64 64 64 255] time = <drain_time>
		DoScreenElementMorph id = ss_p1_notes_text rgba = [64 64 64 255] time = <drain_time>
		DoScreenElementMorph id = ss_p1_hit_text rgba = [64 64 64 255] time = <drain_time>
		DoScreenElementMorph id = np_circle_1 rgba = [192 192 192 255] time = <drain_time>
	else
		DoScreenElementMorph id = ss_p2_note_streak_fill rgba = [128 128 128 255] time = <drain_time>
		DoScreenElementMorph id = ss_p2_note_streak rgba = [210 210 210 255] time = <drain_time>
		DoScreenElementMorph id = ss_p2_note_streak_text rgba = [220 220 220 255] time = <drain_time>
		DoScreenElementMorph id = ss_p2_score_fill rgba = [128 128 128 255] time = <drain_time>
		DoScreenElementMorph id = ss_p2_score_text rgba = [220 220 220 255] time = <drain_time>
		DoScreenElementMorph id = ss_p2_score rgba = [128 128 128 255] time = <drain_time>
		DoScreenElementMorph id = ss_p2_notes_hit rgba = [128 128 128 255] time = <drain_time>
		DoScreenElementMorph id = ss_p2_percent_sign rgba = [64 64 64 255] time = <drain_time>
		DoScreenElementMorph id = ss_p2_notes_text rgba = [64 64 64 255] time = <drain_time>
		DoScreenElementMorph id = ss_p2_hit_text rgba = [64 64 64 255] time = <drain_time>
		DoScreenElementMorph id = np_circle_2 rgba = [192 192 192 255] time = <drain_time>
	endif
	DoScreenElementMorph id = np_icon_skull rgba = [192 192 192 255] time = <drain_time>
	wait (<drain_time> + 0.5)seconds
endscript

script np_2p_hilites_p1\{time = 3.0}
	rot1 = 360
	rot2 = 180
	alpha1 = 1
	alpha2 = 1
	SetScreenElementProps \{id = ss_hilite2_p1 rot_angle = 0 alpha = 0}
	SetScreenElementProps \{id = ss_hilite3_p1 rot_angle = 0 alpha = 0}
	begin
		i = 1
		begin
			if ScreenElementExists \{id = ss_hilite2_p1}
				DoScreenElementMorph id = ss_hilite2_p1 rot_angle = <rot1> alpha = <alpha1> time = <time>
			endif
			if ScreenElementExists \{id = ss_hilite3_p1}
				DoScreenElementMorph id = ss_hilite3_p1 rot_angle = <rot2> alpha = <alpha2> time = <time>
			endif
			<i> = (<i> + 1)
		repeat 2
		<rot1> = (<rot1> + 360)
		<rot2> = (<rot2> + 180)
		if (<alpha1> = 1)
			<alpha1> = 0
		else
			<alpha1> = 1
		endif
		if (<alpha2> = 1)
			<alpha2> = 0
		else
			<alpha2> = 1
		endif
		wait <time> seconds
	repeat
endscript

script np_2p_hilites_p2\{time = 3.0}
	rot1 = 360
	rot2 = 180
	alpha1 = 1
	alpha2 = 1
	SetScreenElementProps \{id = ss_hilite2_p2 rot_angle = 0 alpha = 0}
	SetScreenElementProps \{id = ss_hilite3_p2 rot_angle = 0 alpha = 0}
	begin
		i = 1
		begin
			if ScreenElementExists \{id = ss_hilite2_p2}
				DoScreenElementMorph id = ss_hilite2_p2 rot_angle = <rot1> alpha = <alpha1> time = <time>
			endif
			if ScreenElementExists \{id = ss_hilite3_p2}
				DoScreenElementMorph id = ss_hilite3_p2 rot_angle = <rot2> alpha = <alpha2> time = <time>
			endif
			<i> = (<i> + 1)
		repeat 2
		<rot1> = (<rot1> + 360)
		<rot2> = (<rot2> + 180)
		if (<alpha1> = 1)
			<alpha1> = 0
		else
			<alpha1> = 1
		endif
		if (<alpha2> = 1)
			<alpha2> = 0
		else
			<alpha2> = 1
		endif
		wait <time> seconds
	repeat
endscript

script do_achievement_check
	if (<winner> = "1")
		<won> = 1
	else
		<won> = 0
	endif
	if IsHost
		<HOST> = 1
	else
		<HOST> = 0
	endif
	if ($match_type = Ranked)
		<Ranked> = 1
	else
		<Ranked> = 0
	endif
	if IsGuitarController controller = ($player1_status.controller)
		standard_controller = 0
	else
		standard_controller = 1
	endif
	set_online_match_info Ranked = <Ranked> won = <won> HOST = <HOST> standard_controller = <standard_controller>
endscript
