np_5star_headlines = [
	"AUDIENCE KILLED BY SONIC ATTACK FROM %b"
	"%b BLOWS UP THE WORLD WITH THEIR AWESOMENESS"
	"10 OUT OF 10 ROCKERS LOVE %b"
	"LOCK  UP YOUR DAUGHTERS, %b IS IN TOWN"
]
num_5star_headlines = 4
np_4star_headlines = [
	"%b IMPRESSES AUDIENCE WITH GOOD SET"
	"SENIOR CITIZENS AGREE, %B IS TOO LOUD"
	"AUDIENCE ENJOYS GOOD SHOW FROM %b"
]
num_4star_headlines = 3
np_3star_headlines = [
	"%b DOESNT SUCK TOO HORRIBLY"
	"CROWD SLIGHTLY INTERESTED IN %b"
	"%b SOUNDS BETTER THAN FINGERNAILS ON A CHALKBOARD"
]
num_3star_headlines = 3
g_np_option_props = [
	{
		Pos = (680.0, 168.0)
		rot = 1
		offset = (-30.0, 5.0)
	}
	{
		Pos = (680.0, 201.0)
		rot = 1
		offset = (-30.0, 5.0)
	}
	{
		Pos = (680.0, 234.0)
		rot = 0.5
		offset = (-30.0, 5.0)
	}
	{
		Pos = (680.0, 266.0)
		rot = 0
		offset = (-30.0, 6.0)
	}
	{
		Pos = (680.0, 162.0)
		rot = 0
		offset = (-30.0, 6.0)
	}
	{
		Pos = (680.0, 195.0)
		rot = 0
		offset = (-30.0, 6.0)
	}
	{
		Pos = (680.0, 228.0)
		rot = 0
		offset = (-30.0, 6.0)
	}
	{
		Pos = (680.0, 261.0)
		rot = 0
		offset = (-30.0, 6.0)
	}
	{
		Pos = (680.0, 294.0)
		rot = 0
		offset = (-30.0, 6.0)
	}
]
g_np_menu_icon_offset = (225.0, -22.0)
g_np_options_index = 0
g_ss_mag_number = 0
g_grey = [
	128
	128
	128
	255
]
g_ss_offwhite = [
	230
	230
	230
	255
]
g_ss_black = [
	0
	0
	0
	255
]
g_ss_orangeish = [
	200
	135
	55
	255
]
g_ss_AP_reddish = [
	200
	60
	55
	255
]
g_ss_AP_blueish = [
	55
	80
	135
	255
]
g_ss_AP_yellowish = [
	230
	220
	25
	255
]
g_ss_p1_orangeish = [
	210
	165
	110
	255
]
g_ss_p2_violetish = [
	180
	155
	205
	255
]
g_ss_2p_song_title_whiteish = [
	220
	220
	220
	255
]
use_last_player_scores = 0
old_song = None

script create_newspaper_menu\{for_practice = 0}
	menu_song_complete_sound
	StopSoundsByBuss \{BinkCutScenes}
	disable_pause
	my_song = ($current_song)
	if NOT ($old_song = None)
		my_song = ($old_song)
		Change \{old_song = None}
	endif
	set_focus_color \{rgba = $g_ss_offwhite}
	set_unfocus_color \{rgba = $g_ss_black}
	show_replay = 1
	replay_flow_params = {action = try_again}
	if ($game_mode = p1_quickplay)
		menu_top_rockers_check_for_new_top_score \{nowrite = 1}
		if NOT (<new_score> = -1)
			show_replay = 0
		endif
		if (<newbestscore> = 1)
			replay_flow_params = {action = save_and_try_again}
		endif
	endif
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
			exclusive_mp_controllers = [0 , 0]
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
	casttointeger \{p1_score}
	casttointeger \{p2_score}
	CreateScreenElement \{Type = ContainerElement parent = root_window id = newspaper_container Pos = (0.0, 0.0)}
	FormatText textname = p1_note_streak_text "%d" d = <p1_note_streak>
	FormatText textname = p2_note_streak_text "%d" d = <p2_note_streak>
	FormatText textname = p1_score_text "%s" s = <p1_score>
	FormatText textname = p2_score_text "%s" s = <p2_score>
	get_progression_globals game_mode = ($game_mode)use_current_tab = 1
	GetGlobalTags \{Progression params = current_tier}
	show_stars = 1
	if GotParam \{current_tier}
		if Progression_IsBossSong tier_global = <tier_global> Tier = <current_tier> song = <my_song>
			show_stars = 0
		endif
	endif
	get_song_title song = <my_song>
	get_difficulty_text difficulty = ($current_difficulty)
	if (<stars> < 3)
		<stars> = 3
	endif
	offwhite = [223 223 223 255]
	reddish = [170 70 70 255]
	switch <current_tier>
		case 1
			Change \{g_ss_mag_number = 0}
		case 2
			Change \{g_ss_mag_number = 1}
		case 3
			Change \{g_ss_mag_number = 2}
		case 4
			Change \{g_ss_mag_number = 3}
		case 5
			Change \{g_ss_mag_number = 4}
		case 6
			Change \{g_ss_mag_number = 5}
		case 7
			Change \{g_ss_mag_number = 6}
		case 8
			Change \{g_ss_mag_number = 7}
		default
			Change \{g_ss_mag_number = 0}
	endswitch
	if NOT ($game_mode = p1_career || $game_mode = p2_career || $game_mode = p2_coop || $game_mode = p1_quickplay || <for_practice> = 1)
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
				<winner> = "2"
				<win_sqs> = '2'
				<winner_color> = $g_ss_p2_violetish
			else
				<winner> = "1"
				<win_sqs> = '1'
				<winner_color> = $g_ss_p1_orangeish
			endif
		else
			if (<p2_score> > <p1_score>)
				<winner> = "2"
				<win_sqs> = '2'
				<winner_color> = $g_ss_p2_violetish
			elseif (<p1_score> > <p2_score>)
				<winner> = "1"
				<win_sqs> = '1'
				<winner_color> = $g_ss_p1_orangeish
			else
				<winner> = "0"
				<win_sqs> = '0'
			endif
		endif
		if ($is_network_game)
			do_achievement_check <...>
			updateatoms \{name = achievement}
		endif
		if (<win_sqs> = '0')
			rand_status = Random (@ 1 @ 2)
			FormatText checksumName = player_status 'player%i_status' i = <rand_status>
		else
			FormatText checksumName = player_status 'player%i_status' i = <win_sqs>
		endif
		if ($game_mode = p2_battle)
			displayText {
				parent = newspaper_container
				text = "EPIC BATTLE"
				just = [left top]
				Pos = (256.0, 264.0)
				Scale = 0.75
				font = text_a11
				rgba = <winner_color>
				rot = -7.5
				noshadow
			}
			FormatText textname = winner_text "Player %d" d = <winner>
			if ($is_network_game)
				if (<winner> = "2")
					winner_text = $opponent_gamertag
				else
					if (NetSessionFunc Obj = match func = get_gamertag)
						winner_text = <name>
					endif
				endif
			endif
			FormatText textname = who_won_text "%s	Rules!" s = <winner_text>
			displayText {
				parent = newspaper_container
				text = <who_won_text>
				just = [left top]
				Pos = (262.0, 302.0)
				Scale = 0.75
				font = text_a11
				rgba = <winner_color>
				rot = -7.5
				noshadow
			}
			<final_blow_powerup> = ($<player_status>.final_blow_powerup)
			if (<final_blow_powerup> > -1)
				CreateScreenElement \{Type = TextBlockElement parent = newspaper_container just = [left top] Pos = (320.0, 415.0) rot_angle = -7.5 Scale = 0.45 text = "FINAL BLOW:" font = fontgrid_title_gh3 rgba = [223 223 223 255] dims = (300.0, 300.0)}
				select = <final_blow_powerup>
				if (<winner> = "1")
					is_lefty_flip = $p2_lefty
				else
					is_lefty_flip = $p1_lefty
				endif
				if (<select> = 4 & <is_lefty_flip> = 1)
					GetUpperCaseString ($battlemode_powerups [<select>].alt_name_text)
				else
					GetUpperCaseString ($battlemode_powerups [<select>].name_text)
				endif
				final_blow_attack_text = <uppercasestring>
				final_blow_attack_icon = ($battlemode_powerups [<select>].card_texture)
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
				FormatText \{checksumName = card_checksum 'battlecard_final_blow'}
				CreateScreenElement {
					Type = SpriteElement
					id = <card_checksum>
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
			winner_text = <winner>
			FormatText textname = winner_text "Player %d" d = <winner>
			if ($is_network_game)
				if (<winner> = "2")
					winner_text = $opponent_gamertag
				else
					if (NetSessionFunc Obj = match func = get_gamertag)
						winner_text = <name>
					endif
				endif
			endif
			if (<winner> = "0")
				who_won_text = "It's a TIE!"
			else
				FormatText textname = who_won_text "%d Conquers With Authority!" d = <winner_text>
			endif
			CreateScreenElement {
				Type = TextBlockElement
				parent = newspaper_container
				just = [left bottom]
				internal_just = [left bottom]
				Pos = (270.0, 345.0)
				Scale = 0.7
				text = <who_won_text>
				font = text_a11
				rgba = <winner_color>
				dims = (350.0, 200.0)
				line_spacing = 0.85
				rot_angle = -7.5
			}
		endif
		displaySprite {
			parent = newspaper_container
			tex = <ss_logo>
			Pos = (158.0, 25.0)
		}
		displaySprite {
			parent = newspaper_container
			tex = <ss_sidebar>
			Pos = (858.0, 130.0)
		}
		GetUpperCaseString <song_title>
		CreateScreenElement {
			id = ss_song_title_text_block_id
			Type = TextBlockElement
			parent = newspaper_container
			just = [left top]
			internal_just = [left top]
			Pos = (270.0, 352.0)
			Scale = (0.550000011920929, 0.550000011920929)
			text = <uppercasestring>
			font = text_a11
			rgba = $g_ss_2p_song_title_whiteish
			dims = (400.0, 134.0)
			line_spacing = 0.85
			rot_angle = -7.5
			noshadow
		}
		get_song_artist song = <my_song>
		GetUpperCaseString <song_artist>
		<band_name> = <uppercasestring>
		GetScreenElementChildren \{id = ss_song_title_text_block_id}
		GetArraySize (<children>)
		if (<array_Size> = 1)
			<artist_pos> = (276.0, 386.0)
		else
			<artist_pos> = (280.0, 416.0)
		endif
		if ($g_ss_mag_number = 0 || $g_ss_mag_number = 1)
			<band_name_color> = $g_ss_offwhite
		else
			<band_name_color> = $g_ss_p1_orangeish
		endif
		CreateScreenElement {
			id = ss_artist_text_block_id
			Type = TextBlockElement
			parent = newspaper_container
			just = [left top]
			internal_just = [left top]
			Pos = <artist_pos>
			Scale = (0.45000001788139343, 0.45000001788139343)
			text = <band_name>
			font = text_a4
			rgba = <band_name_color>
			dims = (400.0, 134.0)
			line_spacing = 0.85
			rot_angle = -7.5
		}
		get_difficulty_text_upper difficulty = ($current_difficulty)
		name_text_1 = "PLAYER 1"
		if ($is_network_game)
			if (NetSessionFunc Obj = match func = get_gamertag)
				name_text_1 = <name>
			endif
		endif
		FormatText textname = p1_difficulty_text "%n, %d" d = <difficulty_text> n = <name_text_1>
		displayText {
			parent = newspaper_container
			text = <p1_difficulty_text>
			Pos = (298.0, 522.0)
			Scale = (0.5, 0.550000011920929)
			font = text_a11
			rgba = $g_ss_p1_orangeish
			rot = -7.5
			noshadow
		}
		SetScreenElementProps id = <id> font_spacing = 2 space_spacing = 2
		get_difficulty_text_upper difficulty = ($current_difficulty2)
		name_text_2 = "PLAYER 2"
		if ($is_network_game)
			name_text_2 = $opponent_gamertag
		endif
		FormatText textname = p2_difficulty_text "%n, %d" d = <difficulty_text> n = <name_text_2>
		displayText {
			parent = newspaper_container
			text = <p2_difficulty_text>
			Pos = (302.0, 552.0)
			Scale = (0.5, 0.550000011920929)
			font = text_a11
			rgba = $g_ss_p2_violetish
			rot = -7.5
			noshadow
		}
		SetScreenElementProps id = <id> font_spacing = 2 space_spacing = 2
		displaySprite {
			parent = newspaper_container
			tex = <ss_logo_sm>
			Pos = (946.0, 86.0)
		}
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
			text = "1"
			Pos = (<p1_stats_pos> + (23.0, 3.0))
			Scale = (0.8999999761581421, 0.6000000238418579)
			font = text_a11
			rgba = $g_ss_2p_song_title_whiteish
			z = 9
		}
		displayText {
			parent = newspaper_container
			text = "2"
			Pos = (<p2_stats_pos> + (21.0, 3.0))
			Scale = (0.8999999761581421, 0.6000000238418579)
			font = text_a11
			rgba = $g_ss_2p_song_title_whiteish
			z = 9
		}
		if (<winner> = "1")
			<l_wing_pos> = (<p1_stats_pos> + (-44.0, 0.0))
			<r_wing_pos> = (<p1_stats_pos> + (39.0, 0.0))
		else
			<l_wing_pos> = (<p2_stats_pos> + (-44.0, 0.0))
			<r_wing_pos> = (<p2_stats_pos> + (44.0, 0.0))
		endif
		if NOT (<winner> = "0")
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
				tex = Song_Summary_Wing_2p_Flipped
				Pos = <r_wing_pos>
				z = 7
			}
			if (<winner> = "1")
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
			<ss_notestreak_scale> = (1.1200000047683716, 1.5)
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
			text = "note streak"
			just = [center center]
			Pos = (<p1_stats_pos> + (52.0, 130.0))
			Scale = (0.550000011920929, 0.699999988079071)
			font = text_a11
			z = 4
			rgba = <ss_notestreak_text_color>
			noshadow
		}
		GetScreenElementDims id = <id>
		fit_text_in_rectangle id = ss_p1_note_streak_text dims = ((90.0, 0.0) + (0.0, 1.0) * <height>)Pos = (<p1_stats_pos> + (52.0, 130.0))start_x_scale = 0.55 start_y_scale = 0.7 only_if_larger_x = 1
		if (<p2_note_streak> > 999)
			<ss_p2_notestreak_pos> = (<p2_stats_pos> + (-40.0, 43.0))
			<ss_notestreak_scale> = (1.1200000047683716, 1.5)
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
			text = "note streak"
			just = [center center]
			Pos = (<p2_stats_pos> + (-2.0, 130.0))
			Scale = (0.550000011920929, 0.699999988079071)
			font = text_a11
			z = 4
			rgba = <ss_notestreak_text_color>
			noshadow
		}
		GetScreenElementDims id = <id>
		fit_text_in_rectangle id = ss_p2_note_streak_text dims = ((90.0, 0.0) + (0.0, 1.0) * <height>)Pos = (<p2_stats_pos> + (-2.0, 130.0))start_x_scale = 0.55 start_y_scale = 0.7 only_if_larger_x = 1
		if NOT ($g_ss_mag_number = 7)
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
		else
			displaySprite {
				id = ss_p1_score_fill
				parent = newspaper_container
				tex = Song_Summary_Score_BG_2p
				Pos = (<p1_stats_pos> + (-12.0, 160.0))
				rgba = $g_ss_HELL_darker_reddish
			}
			displaySprite {
				id = ss_p2_score_fill
				parent = newspaper_container
				tex = Song_Summary_Score_BG_2p
				Pos = (<p2_stats_pos> + (54.0, 192.0))
				rgba = $g_ss_HELL_darker_reddish
				rot_angle = 181
			}
		endif
		displayText {
			id = ss_p1_score_text
			parent = newspaper_container
			text = "Score"
			Pos = (<p1_stats_pos> + (10.0, 155.0))
			Scale = (0.699999988079071, 0.5)
			font = text_a11
			z = 4
			rgba = $g_ss_2p_song_title_whiteish
			noshadow
			rot = -2
		}
		displayText {
			id = ss_p2_score_text
			parent = newspaper_container
			text = "Score"
			Pos = (<p2_stats_pos> + (-50.0, 155.0))
			Scale = (0.699999988079071, 0.5)
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
			Scale = (0.800000011920929, 1.0)
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
			Scale = (0.800000011920929, 1.0)
			font = text_a4
			rgba = <ss_score_color>
			z = 3
			noshadow
		}
		FormatText textname = p1_notes_hit "%d" d = <p1_percent_complete>
		if (<p1_percent_complete> = 100)
			<ss_percent_pos> = (<p1_stats_pos> + (2.0, 204.0))
			<ss_percent_scale> = (0.699999988079071, 1.4700000286102295)
		elseif (<p1_percent_complete> < 10)
			<ss_percent_pos> = (<p1_stats_pos> + (10.0, 206.0))
			<ss_percent_scale> = (1.600000023841858, 1.4700000286102295)
		else
			<ss_percent_pos> = (<p1_stats_pos> + (6.0, 207.0))
			<ss_percent_scale> = (0.8999999761581421, 1.4700000286102295)
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
		FormatText textname = p2_notes_hit "%d" d = <p2_percent_complete>
		if (<p2_percent_complete> = 100)
			<ss_percent_pos> = (<p2_stats_pos> + (-70.0, 204.0))
			<ss_percent_scale> = (0.699999988079071, 1.4700000286102295)
		elseif (<p2_percent_complete> < 10)
			<ss_percent_pos> = (<p2_stats_pos> + (-62.0, 206.0))
			<ss_percent_scale> = (1.600000023841858, 1.4700000286102295)
		else
			<ss_percent_pos> = (<p2_stats_pos> + (-66.0, 207.0))
			<ss_percent_scale> = (0.8999999761581421, 1.4700000286102295)
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
			text = "%"
			Pos = (<p1_stats_pos> + (60.0, 226.0))
			font = text_a4
			z = 4
			rgba = <ss_percent_color>
			rot = 50
			Scale = (0.699999988079071, 0.5)
			noshadow
		}
		displayText {
			id = ss_p1_notes_text
			parent = newspaper_container
			text = "\u0NOTES"
			Pos = (<p1_stats_pos> + (66.0, 232.0))
			Scale = (0.4000000059604645, 0.699999988079071)
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
			text = "\u0HIT"
			Pos = (<p1_stats_pos> + (67.0, 257.0))
			Scale = (0.4000000059604645, 0.6000000238418579)
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
			text = "%"
			Pos = (<p2_stats_pos> + (-12.0, 226.0))
			font = text_a4
			z = 4
			rgba = <ss_percent_color>
			rot = 50
			Scale = (0.699999988079071, 0.5)
			noshadow
		}
		displayText {
			id = ss_p2_notes_text
			parent = newspaper_container
			text = "\u0NOTES"
			Pos = (<p2_stats_pos> + (-6.0, 232.0))
			Scale = (0.4000000059604645, 0.699999988079071)
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
			text = "\u0HIT"
			Pos = (<p2_stats_pos> + (-5.0, 257.0))
			Scale = (0.4000000059604645, 0.6000000238418579)
			font = text_a3
			z = 4
			rgba = <ss_percent_color>
			noshadow
		}
		SetScreenElementProps id = <id> font_spacing = 6
		fit_text_in_rectangle id = ss_p2_hit_text dims = (45.0, 30.0) Pos = (<p2_stats_pos> + (-5.0, 257.0))start_x_scale = 0.4 start_y_scale = 0.6 only_if_larger_x = 1
		if (<winner> = "1")
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
		elseif (<winner> = "2")
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
		if NOT (<winner> = "0")
			<i> = 1
			begin
				FormatText checksumName = hilite_id 'ss_hilite%d_p%p' d = <i> p = <win_sqs>
				if (<i> = 3)
					<i> = 2
				endif
				FormatText checksumName = hilite_tex 'Char_Select_Hilite%d' d = <i>
				<hilite_rgba> = [200 90 40 255]
				<hilite_pos> = (<p1_stats_pos> + (46.0, 330.0))
				if (<win_sqs> = '2')
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
					<id> ::SetProps rgba = <hilite_rgba> alpha = 0.25 dims = (180.0, 180.0)
				endif
				<i> = (<i> + 1)
			repeat 3
		endif
		outfit = ($<player_status>.outfit)
		style = ($<player_status>.style)
		if find_profile_by_id id = ($<player_status>.character_id)
			get_musician_profile_struct index = <index>
			character_name = (<profile_struct>.name)
			FormatText checksumName = the_body_id_i_need 'Guitarist_%n_Outfit%o_Style%s' n = <character_name> o = <outfit> s = <style>
			get_pak_filename desc_id = <the_body_id_i_need> Type = Body
			if (<found> = 1)
				get_musician_body_struct index = <pak_index>
				<asset_context> = (<info_struct>.asset_context)
				PushAssetContext context = <asset_context>
			endif
		endif
		displaySprite \{parent = newspaper_container tex = #"0xc9c796cb" dims = (640.0, 640.0) Pos = (125.0, 34.0) z = -1}
		if (<found> = 1)
			PopAssetContext
		endif
		if NOT (<winner> = "0")
			spawnscriptnow \{np_2p_flap_wings}
			spawnscriptnow \{np_2p_thumb_zoom}
			spawnscriptnow np_2p_fade_to_grey params = {winner = <winner>}
		endif
		if (<winner> = "1")
			spawnscriptnow \{np_2p_hilites_p1}
		elseif (<winner> = "2")
			spawnscriptnow \{np_2p_hilites_p2}
		endif
	else
		<ss_logo> = none
		<ss_sidebar> = none
		<ss_percent_fill> = none
		<ss_percent_color> = $g_ss_offwhite
		<ss_star_good_color> = $g_ss_offwhite
		<ss_star_bad_color> = [100 100 100 255]
		<ss_score_fill_L_color> = $g_ss_black
		<ss_score_color> = $g_ss_offwhite
		<ss_score_fill_R_color> = $g_ss_offwhite
		<ss_score_text_color> = $g_ss_black
		<ss_notestreak_fill_color> = $g_ss_black
		<ss_notestreak_color> = $g_ss_offwhite
		<ss_notestreak_text_color> = $g_ss_offwhite
		displaySprite {
			parent = newspaper_container
			tex = <ss_logo>
			Pos = (158.0, 25.0)
		}
		displaySprite {
			parent = newspaper_container
			tex = <ss_sidebar>
			Pos = (858.0, 130.0)
		}
		get_song_artist song = <my_song>
		GetUpperCaseString <song_artist>
		<band_name> = <uppercasestring>
		song_internal_scale = 1.0
		StringLength string = <song_title>
		if (<str_len> >= 19)
			<song_internal_scale> = 0.75
		endif
		mypos = (262.0, 345.0)
		CreateScreenElement {
			id = ss_song_title_text_block_id
			Type = TextBlockElement
			parent = newspaper_container
			just = [left bottom]
			internal_just = [left bottom]
			Pos = <mypos>
			Scale = 0.75
			text = <song_title>
			font = text_a11
			rgba = $g_ss_offwhite
			dims = (300.0, 200.0)
			line_spacing = 0.85
			rot_angle = -7.5
			internal_scale = <song_internal_scale>
		}
		<artist_pos> = (<mypos> + (0.0, 5.0))
		if ($g_ss_mag_number = 0 || $g_ss_mag_number = 1)
			<band_name_color> = $g_ss_offwhite
		else
			<band_name_color> = $g_ss_orangeish
		endif
		CreateScreenElement {
			id = ss_artist_text_block_id
			Type = TextBlockElement
			parent = newspaper_container
			just = [left top]
			internal_just = [left top]
			Pos = <artist_pos>
			Scale = (0.5, 0.550000011920929)
			text = <band_name>
			font = text_a4
			rgba = <band_name_color>
			dims = (400.0, 134.0)
			line_spacing = 0.85
			rot_angle = -7.5
		}
		displaySprite {
			parent = newspaper_container
			tex = <ss_percent_fill>
			Pos = (267.0, 460.0)
			dims = (336.0, 168.0)
		}
		FormatText textname = p1_notes_hit "%d" d = <p1_percent_complete>
		if (<p1_percent_complete> = 100)
			<ss_percent_pos> = (290.0, 503.0)
			<ss_percent_scale> = (1.2999999523162842, 1.600000023841858)
		elseif (<p1_percent_complete> < 10)
			<ss_percent_pos> = (332.0, 496.0)
			<ss_percent_scale> = 1.6
		else
			<ss_percent_pos> = (302.0, 501.0)
			<ss_percent_scale> = 1.6
		endif
		displayText {
			parent = newspaper_container
			text = <p1_notes_hit>
			Pos = <ss_percent_pos>
			Scale = <ss_percent_scale>
			font = text_a4
			z = 4
			rgba = <ss_percent_color>
			rot = -10
			noshadow
		}
		displayText {
			parent = newspaper_container
			text = "%"
			Pos = (364.0, 500.0)
			font = text_a4
			z = 4
			rgba = <ss_percent_color>
			rot = -10
			noshadow
		}
		if NOT ($g_ss_mag_number = 7)
			<np_notes_hit_color> = $g_ss_black
		else
			<np_notes_hit_color> = $g_ss_HELL_lighter_reddish
		endif
		displayText {
			parent = newspaper_container
			text = "\u0NOTES HIT"
			Pos = (403.0, 522.0)
			Scale = (0.4399999976158142, 0.699999988079071)
			font = text_a3
			z = 4
			rgba = <np_notes_hit_color>
			rot = -10
			noshadow
		}
		SetScreenElementProps id = <id> font_spacing = 6 space_spacing = 1
		GetScreenElementDims id = <id>
		if (<width> > 79)
			SetScreenElementProps id = <id> Scale = 1
			fit_text_in_rectangle id = <id> dims = (66.0, 35.0) Pos = (403.0, 522.0)
		endif
		displaySprite {
			parent = newspaper_container
			tex = song_summary_score_fill_l
			Pos = (674.0, 90.0)
			rgba = <ss_score_fill_L_color>
			dims = (268.0, 67.0)
		}
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
				Scale = (0.8999999761581421, 0.6500000357627869)
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
				Scale = (0.699999988079071, 0.6000000238418579)
				font = text_a11
				z = 4
				rgba = <ss_score_text_color>
				noshadow
			}
			SetScreenElementProps id = <id> font_spacing = 3
			fit_text_in_rectangle id = <id> dims = (100.0, 100.0) only_if_larger_x = 1 keep_ar = 1 start_x_scale = 0.7 start_y_scale = 0.6 debug_me
		else
			notes_hit = ($player1_status.notes_hit)
			notes_total = ($player1_status.total_notes)
			FormatText textname = notes_hit_out_of_total "%a OUT OF %b" a = <notes_hit> b = <notes_total>
			displayText {
				id = np_score_text
				parent = newspaper_container
				text = <notes_hit_out_of_total>
				just = [right center]
				Pos = (911.0, 117.0)
				Scale = (0.8999999761581421, 0.6500000357627869)
				font = text_a4
				rgba = <ss_score_color>
				z = 3
				noshadow
				rot = -2
			}
			GetScreenElementDims id = <id>
			SetScreenElementProps id = <id> Scale = (0.8999999761581421, 0.6500000357627869)
			fit_text_in_rectangle id = <id> dims = ((200.0, 0.0) + <height> * (0.0, 0.6500000357627869))
			displayText {
				parent = newspaper_container
				text = "NOTES"
				Pos = (946.0, 98.0)
				Scale = (0.699999988079071, 0.6000000238418579)
				font = text_a11
				z = 4
				rgba = <ss_score_text_color>
				noshadow
			}
			GetScreenElementDims id = <id>
			SetScreenElementProps id = <id> Scale = (0.699999988079071, 0.6000000238418579)
			fit_text_in_rectangle id = <id> dims = ((70.0, 0.0) + <height> * (0.0, 0.6000000238418579))
		endif
		displaySprite {
			parent = newspaper_container
			tex = song_summary_score_fill_r
			Pos = (934.0, 83.0)
			rgba = <ss_score_fill_R_color>
			dims = (134.0, 67.0)
		}
		displaySprite {
			parent = newspaper_container
			tex = song_summary_notestreak_fill
			Pos = (719.0, 359.0)
			rgba = <ss_notestreak_fill_color>
		}
		if (<p1_note_streak> > 999)
			<ss_notestreak_pos> = (740.0, 358.0)
			<ss_notestreak_scale> = (1.1200000047683716, 1.5)
		elseif (<p1_note_streak> > 99)
			<ss_notestreak_pos> = (739.0, 358.0)
			<ss_notestreak_scale> = 1.5
		elseif (<p1_note_streak> < 10)
			<ss_notestreak_pos> = (766.0, 358.0)
			<ss_notestreak_scale> = 1.5
		else
			<ss_notestreak_pos> = (752.0, 358.0)
			<ss_notestreak_scale> = 1.5
		endif
		displayText {
			parent = newspaper_container
			text = <p1_note_streak_text>
			Pos = <ss_notestreak_pos>
			Scale = <ss_notestreak_scale>
			font = text_a4
			z = 4
			rgba = <ss_notestreak_color>
			noshadow
		}
		displayText {
			parent = newspaper_container
			text = "note streak"
			Pos = (732.0, 425.0)
			Scale = (0.4399999976158142, 0.550000011920929)
			font = text_a11
			z = 4
			rgba = <ss_notestreak_text_color>
			noshadow
		}
		SetScreenElementProps id = <id> font_spacing = 5 space_spacing = 3 Scale = 1
		fit_text_in_rectangle id = <id> dims = (80.0, 35.0) Pos = (732.0, 425.0)
		outfit = ($player1_status.outfit)
		style = ($player1_status.style)
		if find_profile_by_id id = ($player1_status.character_id)
			get_musician_profile_struct index = <index>
			character_name = (<profile_struct>.name)
			FormatText checksumName = the_body_id_i_need 'Guitarist_%n_Outfit%o_Style%s' n = <character_name> o = <outfit> s = <style>
			get_pak_filename desc_id = <the_body_id_i_need> Type = Body
			if (<found> = 1)
				get_musician_body_struct index = <pak_index>
				<asset_context> = (<info_struct>.asset_context)
				PushAssetContext context = <asset_context>
			endif
		endif
		displaySprite \{parent = newspaper_container tex = #"0xc9c796cb" dims = (640.0, 640.0) Pos = (125.0, 34.0) z = -1}
		if (<found> = 1)
			PopAssetContext
		endif
	endif
	if ($is_network_game)
		np_net_create_options_menu Pos = (770.0, 460.0) rot = <rot> Scale = 1 for_practice = <for_practice> show_replay = <show_replay> replay_flow_params = <replay_flow_params>
	elseif ($game_mode = p1_career || $game_mode = p2_career || $game_mode = p1_quickplay)
		np_create_options_menu Pos = (770.0, 460.0) rot = <rot> Scale = 1 for_practice = <for_practice> show_replay = <show_replay> replay_flow_params = <replay_flow_params>
	else
		np_create_options_menu Pos = (770.0, 360.0) rot = <rot> Scale = 1 for_practice = <for_practice> show_replay = <show_replay> replay_flow_params = <replay_flow_params>
	endif
	get_song_struct song = <my_song>
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
		//destroy_menu_backdrop
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
	set_focus_color \{rgba = $g_ss_offwhite}
	set_unfocus_color \{rgba = $g_ss_black}
	if (<for_practice> = 1)
		<menu_offset> = (0.0, -6.0)
	elseif NOT ($game_mode = p1_career || $game_mode = p2_career || $game_mode = p2_coop || $game_mode = p1_quickplay)
		<menu_offset> = (0.0, -65.0)
	else
		<menu_offset> = (0.0, 0.0)
	endif
	if (<for_practice> = 1)
		displayText id = np_option_0 parent = newspaper_container text = "CONTINUE" Pos = (($g_np_option_props [4].Pos)+ <menu_offset>)Scale = (0.8500000238418579, 0.699999988079071) rot = ($g_np_option_props [4].rot)font = <menu_font> noshadow
		displayText id = np_option_1 parent = newspaper_container text = "RESTART" Pos = (($g_np_option_props [5].Pos)+ <menu_offset>)Scale = (0.800000011920929, 0.699999988079071) rot = ($g_np_option_props [5].rot)font = <menu_font> noshadow
		displayText id = np_option_2 parent = newspaper_container text = "CHANGE SPEED" Pos = (($g_np_option_props [6].Pos)+ <menu_offset>)Scale = (0.800000011920929, 0.699999988079071) rot = ($g_np_option_props [6].rot)font = <menu_font> noshadow
		displayText id = np_option_3 parent = newspaper_container text = "CHANGE SECTION" Pos = (($g_np_option_props [7].Pos)+ <menu_offset>)Scale = (0.800000011920929, 0.699999988079071) rot = ($g_np_option_props [7].rot)font = <menu_font> noshadow
		displayText id = np_option_4 parent = newspaper_container text = "QUIT" Pos = (($g_np_option_props [8].Pos)+ <menu_offset>)Scale = (0.800000011920929, 0.699999988079071) rot = ($g_np_option_props [8].rot)font = <menu_font> noshadow
		retail_menu_unfocus \{id = np_option_4}
		<initial_hl_pos> = (($g_np_option_props [4].Pos)+ ($g_np_option_props [4].offset)+ <menu_offset>)
	else
		displayText id = np_option_0 parent = newspaper_container text = "CONTINUE" Pos = (($g_np_option_props [0].Pos)+ <menu_offset>)Scale = (0.8500000238418579, 0.699999988079071) rot = ($g_np_option_props [0].rot)font = <menu_font> noshadow
		SetScreenElementProps id = <id> font_spacing = 2 space_spacing = 4
		if NOT ($end_credits = 1)
			if (<show_replay> = 1)
				displayText id = np_option_1 parent = newspaper_container text = "RETRY SONG" Pos = (($g_np_option_props [1].Pos)+ <menu_offset>)Scale = (0.800000011920929, 0.699999988079071) rot = ($g_np_option_props [1].rot)font = <menu_font> noshadow
				SetScreenElementProps id = <id> font_spacing = 2 space_spacing = 4
				displayText id = np_option_2 parent = newspaper_container text = "MORE STATS" Pos = (($g_np_option_props [2].Pos)+ <menu_offset>)Scale = (0.800000011920929, 0.699999988079071) rot = ($g_np_option_props [2].rot)font = <menu_font> noshadow
				SetScreenElementProps id = <id> font_spacing = 2 space_spacing = 4
			else
				displayText id = np_option_1 parent = newspaper_container text = "MORE STATS" Pos = (($g_np_option_props [1].Pos)+ <menu_offset>)Scale = (0.800000011920929, 0.699999988079071) rot = ($g_np_option_props [2].rot)font = <menu_font> noshadow
				SetScreenElementProps id = <id> font_spacing = 2 space_spacing = 4
			endif
		endif
		<initial_hl_pos> = (($g_np_option_props [0].Pos)+ ($g_np_option_props [0].offset)+ <menu_offset>)
	endif
	retail_menu_focus \{id = np_option_0}
	retail_menu_unfocus \{id = np_option_1}
	retail_menu_unfocus \{id = np_option_2}
	retail_menu_unfocus \{id = np_option_3}
	<ss_hilite_color> = $g_ss_black
	<ss_menu_icon> = none
	displaySprite {
		id = ss_menu_hilite_id
		parent = newspaper_container
		tex = song_summary_menu_hilite
		Pos = <initial_hl_pos>
		rgba = <ss_hilite_color>
		rot_angle = (($g_np_option_props [$g_np_options_index].rot)+ 0.5)
		dims = (320.0, 40.0)
		z = 1
	}
	displaySprite {
		id = ss_menu_icon_id
		parent = newspaper_container
		tex = <ss_menu_icon>
		Pos = (<initial_hl_pos> + ($g_np_menu_icon_offset))
		rot_angle = ($g_np_option_props [$g_np_options_index].rot)
		dims = (80.0, 80.0)
		z = 3
	}
	if (<for_practice> = 1)
		if ($came_to_practice_from = main_menu)
			continue_handlers = [
				{focus retail_menu_focus}
				{focus SetScreenElementProps params = {id = np_option_0 Shadow shadow_rgba = [0 0 0 255] shadow_offs = (2.0, 2.0)}}
				{unfocus retail_menu_unfocus}
				{unfocus SetScreenElementProps params = {id = np_option_0 no_shadow}}
				{pad_choose setup_for_change_section}
				{pad_choose ui_flow_manager_respond_to_action params = {action = new_song}}
			]
		else
			continue_handlers = [
				{focus retail_menu_focus}
				{focus SetScreenElementProps params = {id = np_option_0 Shadow shadow_rgba = [0 0 0 255] shadow_offs = (2.0, 2.0)}}
				{unfocus retail_menu_unfocus}
				{unfocus SetScreenElementProps params = {id = np_option_0 no_shadow}}
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
				{focus SetScreenElementProps params = {id = np_option_1 Shadow shadow_rgba = [0 0 0 255] shadow_offs = (2.0, 2.0)}}
				{unfocus retail_menu_unfocus}
				{unfocus SetScreenElementProps params = {id = np_option_1 no_shadow}}
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
				{focus SetScreenElementProps params = {id = np_option_2 Shadow shadow_rgba = [0 0 0 255] shadow_offs = (2.0, 2.0)}}
				{unfocus retail_menu_unfocus}
				{unfocus SetScreenElementProps params = {id = np_option_2 no_shadow}}
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
				{focus SetScreenElementProps params = {id = np_option_3 Shadow shadow_rgba = [0 0 0 255] shadow_offs = (2.0, 2.0)}}
				{unfocus retail_menu_unfocus}
				{unfocus SetScreenElementProps params = {id = np_option_3 no_shadow}}
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
				{focus SetScreenElementProps params = {id = np_option_4 Shadow shadow_rgba = [0 0 0 255] shadow_offs = (2.0, 2.0)}}
				{unfocus retail_menu_unfocus}
				{unfocus SetScreenElementProps params = {id = np_option_4 no_shadow}}
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
				{focus SetScreenElementProps params = {id = np_option_0 Shadow shadow_rgba = [0 0 0 255] shadow_offs = (2.0, 2.0)}}
				{unfocus retail_menu_unfocus}
				{unfocus SetScreenElementProps params = {id = np_option_0 no_shadow}}
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
						{focus SetScreenElementProps params = {id = np_option_1 Shadow shadow_rgba = [0 0 0 255] shadow_offs = (2.0, 2.0)}}
						{unfocus retail_menu_unfocus}
						{unfocus SetScreenElementProps params = {id = np_option_1 no_shadow}}
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
					{focus SetScreenElementProps params = {id = <more_stats_option_id> Shadow shadow_rgba = [0 0 0 255] shadow_offs = (2.0, 2.0)}}
					{unfocus retail_menu_unfocus}
					{unfocus SetScreenElementProps params = {id = <more_stats_option_id> no_shadow}}
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
			np_set_section_color p = 1 i = <i> j = <j> Color = $g_grey
			np_set_section_color p = 2 i = <i> j = <j> Color = $g_grey
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
	displaySprite {
		id = ss_stroke_1
		parent = newspaper_container
		tex = Song_Summary_Brushstroke_2p
		Pos = <stroke_pos>
		rgba = $g_ss_AP_reddish
		z = 80
		rot_angle = 25
		Scale = 0.125
		relative_scale
	}
	DoScreenElementMorph id = ss_stroke_1 Scale = 10.0 relative_scale Pos = (<stroke_pos> + (-8.0, -10.0))time = 0.15 motion = ease_in
	wait \{0.2 seconds}
	displaySprite {
		id = ss_stroke_2
		parent = newspaper_container
		tex = Song_Summary_Brushstroke_2p
		Pos = (<stroke_pos> + (-110.0, -30.0))
		rgba = [255 0 0 255]
		z = 80
		rot_angle = -10
		flip_v
		flip_h
		Scale = 0.125
		relative_scale
	}
	DoScreenElementMorph id = ss_stroke_2 Scale = 12.0 relative_scale Pos = (<stroke_pos> + (-120.0, -30.0))time = 0.125 motion = ease_out
	wait \{0.125 seconds}
	<drain_time> = 2
	if (<winner> = "2")
		if NOT ($g_ss_mag_number = 7)
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
			DoScreenElementMorph id = ss_p1_note_streak_fill rgba = [128 118 118 255] time = <drain_time>
			DoScreenElementMorph id = ss_p1_note_streak rgba = [210 200 200 255] time = <drain_time>
			DoScreenElementMorph id = ss_p1_note_streak_text rgba = [220 210 210 255] time = <drain_time>
			DoScreenElementMorph id = ss_p1_score_fill rgba = [128 118 118 255] time = <drain_time>
			DoScreenElementMorph id = ss_p1_score_text rgba = [220 210 210 255] time = <drain_time>
			DoScreenElementMorph id = ss_p1_score rgba = [128 118 118 255] time = <drain_time>
			DoScreenElementMorph id = ss_p1_notes_hit rgba = [128 118 118 255] time = <drain_time>
			DoScreenElementMorph id = ss_p1_percent_sign rgba = [64 54 54 255] time = <drain_time>
			DoScreenElementMorph id = ss_p1_notes_text rgba = [64 54 54 255] time = <drain_time>
			DoScreenElementMorph id = ss_p1_hit_text rgba = [64 54 54 255] time = <drain_time>
			DoScreenElementMorph id = np_circle_1 rgba = [192 182 182 255] time = <drain_time>
		endif
	else
		if NOT ($g_ss_mag_number = 7)
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
		else
			DoScreenElementMorph id = ss_p2_note_streak_fill rgba = [128 118 118 255] time = <drain_time>
			DoScreenElementMorph id = ss_p2_note_streak rgba = [210 200 200 255] time = <drain_time>
			DoScreenElementMorph id = ss_p2_note_streak_text rgba = [220 210 210 255] time = <drain_time>
			DoScreenElementMorph id = ss_p2_score_fill rgba = [128 118 118 255] time = <drain_time>
			DoScreenElementMorph id = ss_p2_score_text rgba = [220 210 210 255] time = <drain_time>
			DoScreenElementMorph id = ss_p2_score rgba = [128 118 118 255] time = <drain_time>
			DoScreenElementMorph id = ss_p2_notes_hit rgba = [128 118 118 255] time = <drain_time>
			DoScreenElementMorph id = ss_p2_percent_sign rgba = [64 54 54 255] time = <drain_time>
			DoScreenElementMorph id = ss_p2_notes_text rgba = [64 54 54 255] time = <drain_time>
			DoScreenElementMorph id = ss_p2_hit_text rgba = [64 54 54 255] time = <drain_time>
			DoScreenElementMorph id = np_circle_2 rgba = [192 182 182 255] time = <drain_time>
		endif
	endif
	DoScreenElementMorph id = np_icon_skull rgba = [192 192 192 255] time = <drain_time>
	wait (<drain_time> + 0.5)seconds
	DoScreenElementMorph \{id = ss_stroke_1 alpha = 0 time = 0.25}
	DoScreenElementMorph \{id = ss_stroke_2 alpha = 0 z = 1 time = 0.25}
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
