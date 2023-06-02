g_p1_scores = [
	0
	0
	0
	0
	0
	0
	0
]
g_p2_scores = [
	0
	0
	0
	0
	0
	0
	0
]
g_best_streaks = [
	0
	0
]
g_high_scores = [
	0
	0
]

script create_net_detailed_stats_menu
	Change \{left_column_num_elements = 0}
	Change left_column_y_end = ($initial_column_y_end)
	Change \{center_column_num_elements = 0}
	Change center_column_y_end = ($initial_column_y_end)
	Change \{right_column_num_elements = 0}
	Change right_column_y_end = ($initial_column_y_end)
	Change \{relative_screen_y_position = 0}
	Change center_column_x = (($left_column_x)+ (0.5 * ($right_column_x - $left_column_x)))
	left_margin = 400
	right_margin = 800
	basic_stats_y_offset = 100
	desc_internal_just = [center top]
	desc_x_offset = 640
	p1_stat_internal_just = [left top]
	p1_stat_x_offset = <left_margin>
	p2_stat_internal_just = [right top]
	p2_stat_x_offset = <right_margin>
	detailed_stats_create_container
	if (NetSessionFunc Obj = match func = get_gamertag)
		add_text_to_column column = 'left' text = <name> rgba = ($player1_color)dont_force_caps
	endif
	add_text_to_column \{column = 'center' text = ""}
	add_text_to_column \{column = 'right' text = ""}
	add_text_to_column \{column = 'left' text = ""}
	if ($game_mode = p2_coop)
		add_text_to_column \{column = 'center' text = "AND"}
	else
		add_text_to_column \{column = 'center' text = "VS."}
	endif
	add_text_to_column \{column = 'right' text = ""}
	add_text_to_column \{column = 'left' text = ""}
	add_text_to_column \{column = 'center' text = ""}
	if NOT ($opponent_gamertag = NULL)
		add_text_to_column column = 'right' text = ($opponent_gamertag)rgba = ($player2_color)Scale = (0.75, 1.0) dont_force_caps
	else
		add_text_to_column column = 'right' text = " " rgba = ($player2_color)Scale = (0.75, 1.0) dont_force_caps
	endif
	add_text_to_column \{column = 'left' text = ""}
	add_text_to_column \{column = 'center' text = ""}
	add_text_to_column \{column = 'right' text = ""}
	net_add_basic_stats
	add_text_to_column \{column = 'left' text = ""}
	add_text_to_column \{column = 'center' text = ""}
	add_text_to_column \{column = 'right' text = ""}
	add_text_to_column \{column = 'left' text = ""}
	add_text_to_column \{column = 'center' text = ""}
	add_text_to_column \{column = 'right' text = ""}
	add_divider_graphic
	get_number_of_songs
	set_index = 0
	highlight = 1
	begin
		net_add_stats_and_desc_row set_index = <set_index> highlight = <highlight>
		if (<highlight> = 1)
			<highlight> = 0
		else
			<highlight> = 1
		endif
		<set_index> = (<set_index> + 1)
	repeat ($net_song_num)
	menu_detailed_stats_add_paper_sprites
	circle_pos = [(400.0, 349.0) , (773.9000244140625, 449.0)]
	best_pos = [(595.0, 365.0) , (665.0, 365.0)]
	rot_vals = [-3 , 3]
	Change \{user_control_pill_text_color = [0 0 0 255]}
	Change \{user_control_pill_color = [180 180 180 255]}
	add_user_control_helper \{text = "UP/DOWN" button = strumbar z = 100}
	add_user_control_helper \{text = "CONTINUE" button = green z = 100}
endscript

script net_add_basic_stats
	net_stats_calculate_wins
	Player = 0
	begin
		wins_color = $detailed_stats_text_color
		streak_color = $detailed_stats_text_color
		score_color = $detailed_stats_text_color
		if (<Player> = 0)
			stat_column = 'left'
			FormatText textname = wins_text "%d" d = <p1_wins>
			Color = $player1_color
		else
			stat_column = 'right'
			FormatText textname = wins_text "%d" d = <p2_wins>
			Color = $player2_color
		endif
		FormatText textname = streak_text "%d" d = ($g_best_streaks [<Player>])
		FormatText textname = score_text "%d" d = ($g_high_scores [<Player>])
		if ($game_mode = p2_coop)
			add_text_to_column column = <stat_column> text = "" rgba = <Color>
		else
			add_text_to_column column = <stat_column> text = <wins_text> rgba = <Color>
		endif
		add_text_to_column column = <stat_column> text = <streak_text> rgba = <Color>
		add_text_to_column column = <stat_column> text = <score_text> rgba = <Color>
		<Player> = (<Player> + 1)
	repeat 2
	desc_column = 'center'
	if ($game_mode = p2_coop)
		add_text_to_column column = <desc_column> text = " "
	else
		add_text_to_column column = <desc_column> text = "WINS"
	endif
	add_text_to_column column = <desc_column> text = "BEST STREAK"
	add_text_to_column column = <desc_column> text = "HIGHEST SCORE"
endscript

script net_add_stats_and_desc_row\{set_index = 0 highlight = 0}
	desc_column = 'center'
	get_song_title song = ($net_setlist_songs [<set_index>])
	add_text_to_column column = <desc_column> text = <song_title> Scale = (0.800000011920929, 1.0) dims = (320.0, 0.0)
	Player = 0
	begin
		Color = $detailed_stats_text_color
		if (<Player> = 0)
			stat_column = 'left'
			if ($game_mode = p2_battle)
				if (($g_p1_scores [<set_index>])= -1)
					score = " "
				else
					score = "X"
				endif
			else
				score = ($g_p1_scores [<set_index>])
			endif
			Color = ($player1_color)
		else
			stat_column = 'right'
			if ($game_mode = p2_battle)
				if (($g_p2_scores [<set_index>])= -1)
					score = " "
				else
					score = "X"
				endif
			else
				score = ($g_p2_scores [<set_index>])
			endif
			Color = ($player2_color)
		endif
		FormatText textname = score_text "%d" d = <score>
		add_text_to_column column = <stat_column> text = <score_text> rgba = <Color> highlight = <highlight>
		<Player> = (<Player> + 1)
	repeat 2
endscript

script net_stats_calculate_wins
	p1_wins = 0
	p2_wins = 0
	if ($net_song_num <= 0)
		return <...>
	endif
	get_number_of_songs
	array_count = 0
	begin
		if ($g_p1_scores [<array_count>] > $g_p2_scores [<array_count>])
			<p1_wins> = (<p1_wins> + 1)
		elseif ($g_p2_scores [<array_count>] > $g_p1_scores [<array_count>])
			<p2_wins> = (<p2_wins> + 1)
		endif
		<array_count> = (<array_count> + 1)
	repeat ($net_song_num)
	return <...>
endscript

script print_scores
	GetArraySize \{$g_p1_scores}
	printf \{"===1=== ===2==="}
	index = 0
	begin
		printf "   %a		%b" a = ($g_p1_scores [<index>])b = ($g_p2_scores [<index>])
		<index> = (<index> + 1)
	repeat <array_Size>
endscript

script net_stats_calculate_total_scores
	p1_score = 0
	p2_score = 0
	get_number_of_songs
	array_count = 0
	begin
		<p1_score> = (<p1_score> + ($g_p1_scores [<array_count>]))
		<p2_score> = (<p2_score> + ($g_p2_scores [<array_count>]))
		<array_count> = (<array_count> + 1)
	repeat <num_songs>
	return p1_score = <p1_score> p2_score = <p2_score>
endscript

script reset_net_stats_menu
	Player = 0
	get_number_of_songs
	begin
		array_count = 0
		begin
			FormatText checksumName = scores_array 'g_p%p_scores' p = (<Player> + 1)
			SetArrayElement ArrayName = <scores_array> GlobalArray index = <array_count> NewValue = 0
			<array_count> = (<array_count> + 1)
		repeat <num_songs>
		SetArrayElement ArrayName = g_best_streaks GlobalArray index = <Player> NewValue = 0
		SetArrayElement ArrayName = g_high_scores GlobalArray index = <Player> NewValue = 0
		<Player> = (<Player> + 1)
	repeat 2
endscript

script record_net_statistics
	Player = 0
	if ($game_mode = p2_battle)
		if (($player1_status.current_health)> ($player2_status.current_health))
			if NOT ($player1_status.final_blow_powerup = -1)
				SetArrayElement ArrayName = g_p1_scores GlobalArray index = ($net_song_num)NewValue = ($player1_status.final_blow_powerup)
			else
				SetArrayElement ArrayName = g_p1_scores GlobalArray index = ($net_song_num)NewValue = 8
			endif
			SetArrayElement ArrayName = g_p2_scores GlobalArray index = ($net_song_num)NewValue = -1
		else
			if NOT ($player2_status.final_blow_powerup = -1)
				SetArrayElement ArrayName = g_p2_scores GlobalArray index = ($net_song_num)NewValue = ($player2_status.final_blow_powerup)
			else
				SetArrayElement ArrayName = g_p2_scores GlobalArray index = ($net_song_num)NewValue = 8
			endif
			SetArrayElement ArrayName = g_p1_scores GlobalArray index = ($net_song_num)NewValue = -1
		endif
	endif
	begin
		FormatText checksumName = player_status 'player%p_status' p = (<Player> + 1)
		player_score = ($<player_status>.score)
		casttointeger \{player_score}
		if NOT ($game_mode = p2_battle)
			FormatText checksumName = scores_array 'g_p%p_scores' p = (<Player> + 1)
			SetArrayElement ArrayName = <scores_array> GlobalArray index = ($net_song_num)NewValue = <player_score>
		endif
		if ($<player_status>.best_run > $g_best_streaks [<Player>])
			SetArrayElement ArrayName = g_best_streaks GlobalArray index = <Player> NewValue = ($<player_status>.best_run)
		endif
		if ($<player_status>.score > $g_high_scores [<Player>])
			SetArrayElement ArrayName = g_high_scores GlobalArray index = <Player> NewValue = <player_score>
		endif
		<Player> = (<Player> + 1)
	repeat 2
endscript
