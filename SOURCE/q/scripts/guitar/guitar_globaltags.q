
script setup_globaltags
	globaltag_checksum = initial_v43
	setup_songtags globaltag_checksum = <globaltag_checksum>
	//setup_venuetags globaltag_checksum = <globaltag_checksum>
	//setup_unlocks globaltag_checksum = <globaltag_checksum>
	//get_progression_globals \{game_mode = p1_career}
	//setup_setlisttags SetList_Songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	//get_progression_globals \{game_mode = p2_career}
	//setup_setlisttags SetList_Songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	//get_progression_globals \{game_mode = p1_quickplay}
	//setup_setlisttags SetList_Songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	//get_progression_globals \{game_mode = p2_faceoff}
	//setup_setlisttags SetList_Songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	//get_progression_globals \{game_mode = p1_quickplay Bonus}
	//setup_setlisttags SetList_Songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	//get_progression_globals \{game_mode = p1_quickplay download}
	//setup_setlisttags SetList_Songs = <tier_global> globaltag_checksum = <globaltag_checksum>
	//setup_bandtags globaltag_checksum = <globaltag_checksum>
	setup_user_option_tags globaltag_checksum = <globaltag_checksum>
	//setup_training_tags globaltag_checksum = <globaltag_checksum>
	//setup_store_tags globaltag_checksum = <globaltag_checksum>
	//setup_characterguitar_tags globaltag_checksum = <globaltag_checksum>
	//setup_online_tags globaltag_checksum = <globaltag_checksum>
	//setup_character_tags globaltag_checksum = <globaltag_checksum>
	//setup_achievement_tags globaltag_checksum = <globaltag_checksum>
	SetGlobalTags globaltag_checksum params = {globaltag_checksum = <globaltag_checksum>}
endscript
default_topscores_easy = {
	score1 = 19737
	score2 = 18164
	score3 = 17809
	score4 = 15500
	score5 = 15434
}
default_topscores_medium = {
	score1 = 46322
	score2 = 41217
	score3 = 39989
	score4 = 32984
	score5 = 20107
}
default_topscores_hard = {
	score1 = 54046
	score2 = 49787
	score3 = 41256
	score4 = 38002
	score5 = 27015
}
default_topscores_expert = {
	score1 = 64289
	score2 = 61986
	score3 = 55423
	score4 = 51425
	score5 = 29001
}
default_songtagswithdifficulty = {
	name1 = "D. Stowater"
	name2 = "Ginkel"
	name3 = "Bunny"
	name4 = "BMarvs"
	name5 = "CVance"
	stars1 = 0
	stars2 = 0
	stars3 = 0
	stars4 = 0
	stars5 = 0
	bestscore = 0
	beststars = 0
	achievement_gold_star = 0
	failedtimes = 0
	percent100 = 0
}

script setup_character_tags
endscript
default_songtags = {
	available_on_other_client = 0
	beaten_coop_as_lead = 0
	beaten_coop_as_rhythm = 0
}

script setup_songtags
	GetArraySize \{$difficulty_list}
	num_difficulty = <array_Size>
	array_count = 0
	begin
		get_difficulty_text_nl difficulty = ($difficulty_list [<array_count>])
		FormatText checksumName = default_topscores 'default_topscores_%d' d = <difficulty_text_nl>
		get_songlist_size
		song_array_size = <array_Size>
		song_count = 0
		begin
			get_songlist_checksum index = <song_count>
			get_song_prefix song = <song_checksum>
			FormatText checksumName = songname '%s_%d' s = <song_prefix> d = <difficulty_text_nl> AddToStringLookup = true
			if GotParam \{globaltag_checksum}
				globaltag_checksum = (<globaltag_checksum> + <songname>)
			endif
			get_song_struct song = <song_checksum>
			if (<song_struct>.version = gh3)
				if NOT GetGlobalTags <songname> noassert = 1
					get_song_title song = <song_checksum>
					SetGlobalTags <songname> params = {($default_songtagswithdifficulty)(<default_topscores>)}
				endif
				if NOT GetGlobalTags <song_checksum> noassert = 1
					SetGlobalTags <song_checksum> params = {($default_songtags)}
				endif
			endif
			song_count = (<song_count> + 1)
		repeat <song_array_size>
		<array_count> = (<array_count> + 1)
	repeat <num_difficulty>
	song_count = 0
	GetArraySize ($GH3_Bonus_Songs.#"0x408c9ef8")
	begin
		unlocked = -1
		GetGlobalTags ($GH3_Bonus_Songs.#"0x408c9ef8" [<song_count>])
		if (<unlocked> = -1)
			SetGlobalTags ($GH3_Bonus_Songs.#"0x408c9ef8" [<song_count>])params = {unlocked = 0}
		endif
		song_count = (<song_count> + 1)
	repeat <array_Size>
	if GotParam \{globaltag_checksum}
		return globaltag_checksum = <globaltag_checksum>
	endif
endscript
default_venuetags = {
	unlocked = 0
}
cheat_venuetags = {
	unlocked = 1
}

script setup_venuetags
endscript

script setup_generalvenuetags
endscript
default_guitartags = {
	unlocked = 0
	unlocked_on_other_client = 0
	available_on_other_client = 0
}
default_charactertags = {
	unlocked = 0
	unlocked_on_other_client = 0
	available_on_other_client = 0
}

script setup_unlocks
endscript
default_songsetlisttags = {
	stars = 0
	score = 0
	percent100 = 0
	unlocked = 0
}

default_tiertags = {
	unlocked = 0
	complete = 0
	encore_unlocked = 0
	boss_unlocked = 0
	num_songs_to_progress = 4
}

script setup_tiertags
	num_tiers = ($<SetList_Songs>.num_tiers)
	array_count = 0
	begin
		//printf \{'why'}
		setlist_prefix = ($<SetList_Songs>.prefix)
		FormatText checksumName = Tier 'tier%s' s = (<array_count> + 1)
		FormatText checksumName = tiername '%ptier%i' p = <setlist_prefix> i = (<array_count> + 1)AddToStringLookup = true
		if NOT GetGlobalTags <tiername> noassert = 1
			SetGlobalTags <tiername> params = {($default_tiertags)}
		endif
		if StructureContains structure = ($<SetList_Songs>.<Tier>)defaultunlocked
			SetGlobalTags <tiername> params = {unlocked = 1}
		endif
		if StructureContains structure = ($<SetList_Songs>.<Tier>)unlockall
			SetGlobalTags <tiername> params = {unlocked = 1}
		endif
		array_count = (<array_count> + 1)
	repeat <num_tiers>
endscript
default_bandtags = {
	cash = 0
	name = ""
	first_play = 1
	first_battle_play = 1
	first_venue_movie_played = 0
	band_unique_id = non_existent_checksum
	hendrix_achievement_easy = -1
	hendrix_achievement_medium = -1
	hendrix_achievement_hard = -1
	hendrix_achievement_expert = -1
}

script setup_bandtags
endscript

script setup_user_option_tags
	SetGlobalTags \{user_options params = {guitar_volume = 11 band_volume = 11 sfx_volume = 11 lefty_flip_p1 = 0 lefty_flip_p2 = 0 lag_calibration = 0.0 autosave = 0 resting_whammy_position_device_0 = -0.76 resting_whammy_position_device_1 = -0.76 resting_whammy_position_device_2 = -0.76 resting_whammy_position_device_3 = -0.76 resting_whammy_position_device_4 = -0.76 resting_whammy_position_device_5 = -0.76 resting_whammy_position_device_6 = -0.76 star_power_position_device_0 = -1.0 star_power_position_device_1 = -1.0 star_power_position_device_2 = -1.0 star_power_position_device_3 = -1.0 star_power_position_device_4 = -1.0 star_power_position_device_5 = -1.0 star_power_position_device_6 = -1.0 gamma_brightness = 5 online_game_mode = 0 online_difficulty = 0 online_num_songs = 0 online_tie_breaker = 0 online_highway = 0 unlock_Cheat_AirGuitar = 0 unlock_Cheat_PerformanceMode = 0 unlock_Cheat_Hyperspeed = 0 unlock_Cheat_NoFail = 0 unlock_Cheat_EasyExpert = 0 unlock_Cheat_PrecisionMode = 0 unlock_Cheat_BretMichaels = 0}}
endscript

script setup_online_tags
	SetGlobalTags \{net params = {face_off_streak = 0 pro_face_off_streak = 0 battle_streak = 0 faceoff_wins = 0 faceoff_loses = 0 pro_faceoff_wins = 0 pro_faceoff_loses = 0 battle_wins = 0 battle_loses = 0}}
endscript

script restore_options_from_global_tags
	GetGlobalTags \{user_options}
	if (<lefty_flip_p1>)
		Change \{pad_event_up_inversion = true}
	else
		Change \{pad_event_up_inversion = FALSE}
	endif
endscript

script setup_training_tags
	SetGlobalTags \{training params = {basic_lesson = not_complete star_power_lesson = not_complete guitar_battle_lesson = not_complete advanced_techniques_lesson = not_complete}}
endscript

script setup_store_tags
endscript
default_characterguitartags = {
	current_selected_guitar = Instrument_Les_Paul_Black
	current_selected_bass = Instrument_LP_VBRST
	current_instrument = guitar
	current_outfit = 1
	current_style = 1
}

script setup_characterguitar_tags
endscript

script push_bandtags\{mode = p1_career}
endscript

script pop_bandtags
endscript

script GlobalTags_UnlockAll\{songs_only = 0}
endscript
progression_pop_count = 0

script progression_push_current\{Force = 0}
endscript

script progression_pop_current\{Force = 0 updateatoms = 1}
endscript

script get_minimum_difficulty\{difficulty1 = easy difficulty2 = easy}
	if (<difficulty1> = <difficulty2>)
		return minimum_difficulty = <difficulty1>
	else
		switch <difficulty1>
			case easy
				return \{minimum_difficulty = easy}
			case medium
				if (<difficulty2> = easy)
					return \{minimum_difficulty = easy}
				else
					return \{minimum_difficulty = medium}
				endif
			case hard
				switch <difficulty2>
					case easy
						return \{minimum_difficulty = easy}
					case medium
						return \{minimum_difficulty = medium}
					case expert
						return \{minimum_difficulty = hard}
				endswitch
			case expert
				switch <difficulty2>
					case easy
						return \{minimum_difficulty = easy}
					case medium
						return \{minimum_difficulty = medium}
					case hard
						return \{minimum_difficulty = hard}
				endswitch
		endswitch
	endif
endscript

script get_game_mode_ui_string
	if NOT GotParam \{game_mode}
		SoftAssert \{"Did not get game_mode!"}
		return
	endif
	return ui_string = ($game_mode_ui_strings.<game_mode>)
endscript
game_mode_ui_strings = {
	p1_career = "Career"
	p2_career = "Career"
	p1_quickplay = "Quick Play"
	p2_faceoff = "Face Off"
	p2_pro_faceoff = "Pro Faceoff"
	p2_battle = "Battle"
	p2_coop = "Co-op"
}

script get_difficulty_ui_string
	if NOT GotParam \{difficulty}
		SoftAssert \{"Did not get difficulty!"}
		return
	endif
	return ui_string = ($game_difficulty_ui_strings.<difficulty>)
endscript
game_difficulty_ui_strings = {
	easy = "Easy"
	medium = "Medium"
	hard = "Hard"
	expert = "Expert"
}
game_mode_names = {
	p1_career = 'p1_career'
	p2_career = 'p2_career'
	p1_quickplay = 'p1_quickplay'
	p2_faceoff = 'p2_faceoff'
	p2_pro_faceoff = 'p2_pro_faceoff'
	p2_battle = 'p2_battle'
	p2_coop = 'p2_coop'
}

script get_band_game_mode_name
	game_mode_name = ($game_mode_names.p1_career)
	return game_mode_name = <game_mode_name>
endscript

script get_game_mode_name
	return game_mode_name = ($game_mode_names.$game_mode)
endscript

script get_current_band_info
	FormatText checksumName = bandname 'band%i_info_p1_career' i = ($current_band)
	return band_info = <bandname>
endscript

script get_current_band_checksum
	get_difficulty_text_nl difficulty = ($current_difficulty)
	if ($game_mode = p2_career)
		FormatText checksumName = bandname 'p2_career_band%i_%d' i = ($current_band)d = <difficulty_text_nl>
	else
		FormatText checksumName = bandname 'p1_career_band%i_%d' i = ($current_band)d = <difficulty_text_nl>
	endif
	return band_checksum = <bandname>
endscript

script setup_achievement_tags
	SetGlobalTags \{achievement_info params = {ranked_matches_played = 0 ranked_matches_won = 0 ranked_consecutive_won_as_host = 0 ranked_consecutive_won_as_client = 0 ranked_matches_won_as_host = 0 ranked_matches_won_as_client = 0 ranked_matches_won_with_standard_controller = 0 player_matches_played = 0 player_matches_won = 0 player_matches_won_as_host = 0 player_matches_won_as_client = 0 total_notes_in_career_mode = 0 total_cash_in_career_mode = 0 total_points_in_career_mode = 0 total_points_in_career_mode_easy = 0 total_points_in_career_mode_medium = 0 total_points_in_career_mode_hard = 0 total_points_in_career_mode_expert = 0 hendrix_achievement_lefty_on = 0 hendrix_achievement_lefty_off = 0}}
endscript

script set_online_match_info\{Ranked = 0 won = 0 HOST = 0 standard_controller = 0}
endscript
