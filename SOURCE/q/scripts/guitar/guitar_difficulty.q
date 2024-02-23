difficulty_list = [
	easy
	medium
	hard
	expert
]
difficulty_list_props = {
	easy = {
		index = 0
		text_nl = 'easy'
		text = "Easy"
		text_upper = "EASY"
		scroll_time = 3.5
		game_speed = 1.5
	}
	medium = {
		index = 1
		text_nl = 'medium'
		text = "Medium"
		text_upper = "MEDIUM"
		scroll_time = 3.0
		game_speed = 2.0
	}
	hard = {
		index = 2
		text_nl = 'hard'
		text = "Hard"
		text_upper = "HARD"
		scroll_time = 2.75
		game_speed = 2.125
	}
	expert = {
		index = 3
		text_nl = 'expert'
		text = "Expert"
		text_upper = "EXPERT"
		scroll_time = 2.5
		game_speed = 2.25
	}
}
p2_scroll_time_factor = 1.0
p2_game_speed_factor = 1.0
//p2_scroll_time_factor = 0.8
//p2_game_speed_factor = 0.8
global_hyperspeed_factor = 1.0

script get_difficulty_text\{difficulty = easy}
	return difficulty_text = ($difficulty_list_props.<difficulty>.text)
endscript

script get_difficulty_text_nl\{difficulty = easy}
	return difficulty_text_nl = ($difficulty_list_props.<difficulty>.text_nl)
endscript

script get_difficulty_text_upper\{difficulty = easy}
	return difficulty_text = ($difficulty_list_props.<difficulty>.text_upper)
endscript

script difficulty_setup
	scroll_time_factor = $global_hyperspeed_factor
	game_speed_factor = $global_hyperspeed_factor
	if ($current_num_players = 2 || $end_credits = 1)
		scroll_time_factor = ($p2_scroll_time_factor)
		game_speed_factor = ($p2_game_speed_factor)
	endif
	if ($Cheat_Hyperspeed > -11)
		if NOT ($is_network_game)
			hyperspeed_scale = -1
			/*switch ($Cheat_Hyperspeed - 1)
				case 1
					<hyperspeed_scale> = 0.88
				case 2
					<hyperspeed_scale> = 0.83
				case 3
					<hyperspeed_scale> = 0.78
				case 4
					<hyperspeed_scale> = 0.73
				case 5
					<hyperspeed_scale> = 0.68
			endswitch*///
			<hyperspeed_scale> = ($hyperspeed_scales[($Cheat_Hyperspeed + 12)])
			//printf 'current hyperspeed index: %h, real value: %g' h = $Cheat_Hyperspeed g = <hyperspeed_scale>
			if (<hyperspeed_scale> > 0)
				scroll_time_factor = (<scroll_time_factor> * <hyperspeed_scale>)
				game_speed_factor = (<game_speed_factor> * <hyperspeed_scale>)
			endif
		endif
	endif
	AddParams ($difficulty_list_props.<difficulty>)
	Change StructureName = <player_status> scroll_time = (<scroll_time> * <scroll_time_factor>)
	Change StructureName = <player_status> game_speed = (<game_speed> * <game_speed_factor>)
endscript
hyperspeed_scales = [
	// < 0
	3.0
	2.72
	2.52
	2.32
	2.12
	1.92
	1.72
	1.52
	1.42
	1.32
	1.22
	1.13
	1.0
	// >= 1
	0.88
	0.83
	0.78
	0.72
	0.68
	0.66
	0.64
	0.62
	0.59
	0.56
]
