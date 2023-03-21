
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
	GetArraySize \{$#"0x6c609315"}
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
			FormatText checksumName = songname '%s_%d' s = (<song_prefix>)d = <difficulty_text_nl> AddToStringLookup = true
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

script setup_setlisttags\{globaltag_checksum = None Force = 0}
	setup_tiertags SetList_Songs = <SetList_Songs>
	array_count = 0
	begin
		FormatText checksumName = Tier 'tier%s' s = (<array_count> + 1)
		GetArraySize ($<SetList_Songs>.<Tier>.songs)
		if (<array_Size> > 0)
			song_count = 0
			begin
				song = ($<SetList_Songs>.<Tier>.songs [<song_count>])
				setlist_prefix = ($<SetList_Songs>.prefix)
				SetGlobalTags <song> params = {unlocked = 0}
				FormatText textname = song_checksum_suffix '%p_song%i_tier%s' p = <setlist_prefix> i = (<song_count> + 1)s = (<array_count> + 1)
				ExtendCrc out = song_checksum <song> <song_checksum_suffix>
				globaltag_checksum = (<globaltag_checksum> + <song_checksum>)
				FormatText checksumName = song_checksum '%p_song%i_tier%s' p = <setlist_prefix> i = (<song_count> + 1)s = (<array_count> + 1)AddToStringLookup = true
				if NOT GetGlobalTags <song_checksum> noassert = 1
					SetGlobalTags <song_checksum> params = {($default_songsetlisttags)}
				elseif (<Force> = 1)
					SetGlobalTags <song_checksum> params = {($default_songsetlisttags)}
				endif
				if StructureContains structure = ($<SetList_Songs>.<Tier>)defaultunlocked
					if (<song_count> < $<SetList_Songs>.<Tier>.defaultunlocked)
						SetGlobalTags <song_checksum> params = {unlocked = 1}
					endif
				elseif StructureContains structure = ($<SetList_Songs>.<Tier>)unlockall
					song = ($<SetList_Songs>.<Tier>.songs [<song_count>])
					if is_song_downloaded song_checksum = <song>
						SetGlobalTags <song_checksum> params = {unlocked = 1}
					else
						SetGlobalTags <song_checksum> params = {unlocked = 0}
					endif
				endif
				song_count = (<song_count> + 1)
			repeat <array_Size>
		endif
		array_count = (<array_count> + 1)
	repeat ($<SetList_Songs>.num_tiers)
	return globaltag_checksum = <globaltag_checksum>
endscript
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
	band_count = 0
	begin
		GetArraySize \{$#"0x6c609315"}
		array_count = 0
		begin
			get_difficulty_text_nl difficulty = ($difficulty_list [<array_count>])
			FormatText checksumName = bandname 'p1_career_band%i_%d' i = (<band_count> + 1)d = <difficulty_text_nl> AddToStringLookup = true
			push_bandtags bandname = <bandname> mode = p1_career
			FormatText checksumName = bandname 'p2_career_band%i_%d' i = (<band_count> + 1)d = <difficulty_text_nl> AddToStringLookup = true
			push_bandtags bandname = <bandname> mode = p2_career
			FormatText checksumName = default_bandname 'band%i_info_p1_career' i = (<band_count> + 1)AddToStringLookup = true
			SetGlobalTags <default_bandname> params = {($default_bandtags)}
			FormatText checksumName = default_bandname 'band%i_info_p2_career' i = (<band_count> + 1)AddToStringLookup = true
			SetGlobalTags <default_bandname> params = {($default_bandtags)}
			array_count = (<array_count> + 1)
		repeat <array_Size>
		<band_count> = (<band_count> + 1)
	repeat ($num_career_bands + 1)
	GetArraySize \{$#"0x6c609315"}
	array_count = 0
	begin
		get_difficulty_text_nl difficulty = ($difficulty_list [<array_count>])
		get_progression_globals \{game_mode = p1_career}
		setlist_prefix = ($<tier_global>.prefix)
		FormatText checksumName = gametype_checksum '%p_%s' p = <setlist_prefix> s = <difficulty_text_nl> AddToStringLookup = true
		SetGlobalTags <gametype_checksum> params = {complete = 0}
		get_progression_globals \{game_mode = p2_career}
		setlist_prefix = ($<tier_global>.prefix)
		FormatText checksumName = gametype_checksum '%p_%s' p = <setlist_prefix> s = <difficulty_text_nl> AddToStringLookup = true
		SetGlobalTags <gametype_checksum> params = {complete = 0}
		array_count = (<array_count> + 1)
	repeat <array_Size>
	SetGlobalTags \{Progression params = {current_band = 1 current_difficulty = easy current_gamemode = p1_career}}
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
	get_progression_globals game_mode = <mode>
	if (<mode> = p1_career)
		Career_Songs = <tier_global>
		num_players = 1
	elseif (<mode> = p2_career)
		Career_Songs = <tier_global>
		num_players = 2
	else
		printstruct <...>
		ScriptAssert \{"Invalid mode"}
	endif
	i = 0
	begin
		num_tiers = ($<Career_Songs>.num_tiers)
		array_count = 0
		begin
			FormatText checksumName = Tier 'tier%d' d = (<array_count> + 1)
			GetArraySize ($<Career_Songs>.<Tier>.songs)
			if NOT (<array_Size> = 0)
				setlist_prefix = ($<Career_Songs>.prefix)
				FormatText checksumName = tiername '%ptier%i' p = <setlist_prefix> i = (<array_count> + 1)
				FormatText checksumName = tier_checksum 'tier%s' s = (<array_count> + 1)
				PushGlobalTags <tiername> section = <bandname>
				GetArraySize ($<Career_Songs>.<tier_checksum>.songs)
				song_count = 0
				begin
					setlist_prefix = ($<Career_Songs>.prefix)
					FormatText checksumName = song_checksum '%p_song%i_tier%s' p = <setlist_prefix> i = (<song_count> + 1)s = (<array_count> + 1)AddToStringLookup = true
					PushGlobalTags <song_checksum> section = <bandname>
					song_count = (<song_count> + 1)
				repeat <array_Size>
			endif
			array_count = (<array_count> + 1)
		repeat <num_tiers>
		<i> = (<i> + 1)
		if (<i> = 1)
			get_progression_globals game_mode = <mode> Bonus
		elseif (<i> = 2)
			get_progression_globals game_mode = <mode> download
		endif
		Career_Songs = <tier_global>
	repeat 3
	Player = 1
	begin
		FormatText checksumName = player_status 'player%i_status' i = <Player>
		FormatText checksumName = player_character_params 'player%i_character_params' i = <Player> AddToStringLookup = true
		SetGlobalTags <player_character_params> params = {character_id = ($<player_status>.character_id)
			instrument_id = ($<player_status>.instrument_id)
			style = ($<player_status>.style)
			outfit = ($<player_status>.outfit)}
		PushGlobalTags <player_character_params> section = <bandname>
		Player = (<Player> + 1)
	repeat <num_players>
	PushGlobalTags <player_character_params> section = <bandname>
endscript

script pop_bandtags
	setup_setlisttags \{SetList_Songs = GH3_Download_Songs Force = 1}
	PopGlobalTags section = <bandname>
	<num_players> = 1
	if ($game_mode = p2_career)
		<num_players> = 2
	endif
	Player = 1
	begin
		FormatText checksumName = player_status 'player%i_status' i = <Player>
		FormatText checksumName = player_character_params 'player%i_character_params' i = <Player>
		GetGlobalTags <player_character_params>
		Change StructureName = <player_status> character_id = <character_id>
		Change StructureName = <player_status> instrument_id = <instrument_id>
		Change StructureName = <player_status> style = <style>
		Change StructureName = <player_status> outfit = <outfit>
		valid = 0
		if find_profile_by_id id = ($<player_status>.character_id)
			if is_musician_profile_downloaded index = <index>
				valid = 1
			endif
		endif
		if (<valid> = 0)
			printf \{"Invalid Character found - changing to axel"}
			Change StructureName = <player_status> character_id = axel
			Change StructureName = <player_status> style = 1
			Change StructureName = <player_status> outfit = 1
		endif
		valid = 0
		if find_instrument_index desc_id = ($<player_status>.instrument_id)
			if is_musician_instrument_downloaded index = <index>
				valid = 1
			endif
		endif
		if (<valid> = 0)
			printf \{"Invalid Instrument found - changing to les paul black"}
			Change StructureName = <player_status> instrument_id = Instrument_Les_Paul_Black
		endif
		Player = (<Player> + 1)
	repeat <num_players>
endscript

script GlobalTags_UnlockAll\{songs_only = 0}
	if NOT (<songs_only> = 1)
		array_count = 0
		GetArraySize \{$#"0x6b999e82"}
		begin
			SetGlobalTags ($Bonus_Guitars [<array_count>].id)params = {unlocked = 1 unlocked_for_purchase = 1}
			array_count = (<array_count> + 1)
		repeat <array_Size>
		array_count = 0
		GetArraySize \{$#"0x5e190e34"}
		begin
			SetGlobalTags ($Bonus_Guitar_Finishes [<array_count>].id)params = {unlocked = 1 unlocked_for_purchase = 1}
			array_count = (<array_count> + 1)
		repeat <array_Size>
		array_count = 0
		GetArraySize \{$#"0xbc02c6ad"}
		begin
			SetGlobalTags ($Secret_Guitars [<array_count>].id)params = {unlocked = 1 unlocked_for_purchase = 1}
			array_count = (<array_count> + 1)
		repeat <array_Size>
		array_count = 0
		GetArraySize \{$#"0x1ee2823e"}
		begin
			SetGlobalTags ($Bonus_Basses [<array_count>].id)params = {unlocked = 1 unlocked_for_purchase = 1}
			array_count = (<array_count> + 1)
		repeat <array_Size>
		array_count = 0
		GetArraySize \{$#"0x9088f262"}
		begin
			SetGlobalTags ($Bonus_Bass_Finishes [<array_count>].id)params = {unlocked = 1 unlocked_for_purchase = 1}
			array_count = (<array_count> + 1)
		repeat <array_Size>
		array_count = 0
		GetArraySize \{$#"0x886843df"}
		begin
			SetGlobalTags ($Secret_Basses [<array_count>].id)params = {unlocked = 1 unlocked_for_purchase = 1}
			array_count = (<array_count> + 1)
		repeat <array_Size>
		array_count = 0
		GetArraySize \{$#"0x1c11400a"}
		begin
			SetGlobalTags ($Secret_Characters [<array_count>].id)params = {unlocked = 1}
			array_count = (<array_count> + 1)
		repeat <array_Size>
		array_count = 0
		GetArraySize \{$#"0x625feafc"}
		begin
			SetGlobalTags ($Bonus_Outfits [<array_count>].id)params = {unlocked = 1}
			array_count = (<array_count> + 1)
		repeat <array_Size>
		array_count = 0
		GetArraySize \{$#"0x06af4fdb"}
		begin
			SetGlobalTags ($Bonus_Styles [<array_count>].id)params = {unlocked = 1}
			array_count = (<array_count> + 1)
		repeat <array_Size>
		array_count = 0
		GetArraySize \{$#"0x995fd11c"}
		begin
			SetGlobalTags ($Bonus_videos [<array_count>].id)params = {unlocked = 1}
			array_count = (<array_count> + 1)
		repeat <array_Size>
	endif
	array_count = 0
	begin
		setlist_prefix = ($<SongList>.prefix)
		FormatText checksumName = tiername '%ptier%i' p = <setlist_prefix> i = (<array_count> + 1)
		FormatText checksumName = tier_checksum 'tier%s' s = (<array_count> + 1)
		GetArraySize ($<SongList>.<tier_checksum>.songs)
		SetGlobalTags <tiername> params = {unlocked = 1
			complete = 1
			encore_unlocked = 1
			boss_unlocked = 1
			num_songs_to_progress = 0}
		song_count = 0
		begin
			setlist_prefix = ($<SongList>.prefix)
			FormatText checksumName = song_checksum '%p_song%i_tier%s' p = <setlist_prefix> i = (<song_count> + 1)s = (<array_count> + 1)AddToStringLookup = true
			if (<songs_only> = 1)
				SetGlobalTags <song_checksum> params = {unlocked = 1}
			else
				SetGlobalTags <song_checksum> params = {stars = 5
					score = 1000000
					unlocked = 1}
				get_difficulty_text_nl difficulty = ($current_difficulty)
				get_song_prefix song = ($<SongList>.<tier_checksum>.songs [<song_count>])
				FormatText checksumName = songname '%s_%d' s = <song_prefix> d = <difficulty_text_nl>
				SetGlobalTags <songname> params = {achievement_gold_star = 1}
			endif
			song_count = (<song_count> + 1)
		repeat <array_Size>
		array_count = (<array_count> + 1)
	repeat ($<SongList>.num_tiers)
	setup_venuetags \{cheat}
endscript
progression_pop_count = 0

script progression_push_current\{Force = 0}
	printscriptinfo \{"progression_push_current_callstack"}
	if NOT ($progression_pop_count = 1)
		if (<Force> = 0)
			ScriptAssert \{"progression_push_current with nothing popped"}
		endif
		return
	endif
	GetGlobalTags \{Progression params = current_band}
	GetGlobalTags \{Progression params = current_difficulty}
	GetGlobalTags \{Progression params = current_gamemode}
	get_difficulty_text_nl difficulty = (<current_difficulty>)
	if GotParam \{force_gamemode}
		<current_gamemode> = <force_gamemode>
	endif
	if (<current_gamemode> = p1_career)
		bandname_part1 = 'p1_career'
	elseif (<current_gamemode> = p2_career)
		bandname_part1 = 'p2_career'
	endif
	FormatText checksumName = bandname '%s_band%i_%d' s = <bandname_part1> i = <current_band> d = <difficulty_text_nl>
	push_bandtags bandname = <bandname> mode = <current_gamemode>
	Change progression_pop_count = ($progression_pop_count - 1)
endscript

script progression_pop_current\{Force = 0 updateatoms = 1}
	printscriptinfo \{"progression_pop_current_callstack"}
	if NOT ($progression_pop_count = 0)
		if (<Force> = 0)
			ScriptAssert \{"progression_pop_current with something already popped"}
		endif
		return
	endif
	current_gamemode = ($game_mode)
	if GotParam \{force_gamemode}
		<current_gamemode> = <force_gamemode>
	endif
	if (<current_gamemode> = p1_career)
		bandname_part1 = 'p1_career'
	elseif (<current_gamemode> = p2_career)
		bandname_part1 = 'p2_career'
	else
		ScriptAssert \{"progression_pop_current not in career mode"}
	endif
	progression_getdifficulty
	get_difficulty_text_nl difficulty = <difficulty>
	FormatText checksumName = bandname '%s_band%i_%d' s = <bandname_part1> i = ($current_band)d = <difficulty_text_nl>
	pop_bandtags bandname = <bandname>
	SetGlobalTags Progression params = {current_band = ($current_band)
		current_difficulty = <difficulty>
		current_gamemode = <current_gamemode>}
	Change progression_pop_count = ($progression_pop_count + 1)
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
	GetGlobalTags \{achievement_info}
	printf \{"set_online_match_info"}
	if (<Ranked> = 0)
		<player_matches> = (<player_matches_played> + 1)
		SetGlobalTags achievement_info params = {player_matches_played = <player_matches>}
		if (<won> = 1)
			<matches_won> = (<player_matches_won> + 1)
			SetGlobalTags achievement_info params = {player_matches_won = <matches_won>}
			if (<HOST> = 1)
				<host_won> = (<player_matches_won_as_host> + 1)
				SetGlobalTags achievement_info params = {player_matches_won_as_host = <host_won>}
			else
				<client_won> = (<player_matches_won_as_client> + 1)
				SetGlobalTags achievement_info params = {player_matches_won_as_client = <client_won>}
			endif
		endif
	else
		<player_matches> = (<ranked_matches_played> + 1)
		SetGlobalTags achievement_info params = {ranked_matches_played = <player_matches>}
		if (<won> = 1)
			<matches_won> = (<ranked_matches_won> + 1)
			SetGlobalTags achievement_info params = {ranked_matches_won = <matches_won>}
			if (<HOST> = 1)
				<host_won> = (<ranked_matches_won_as_host> + 1)
				SetGlobalTags achievement_info params = {ranked_matches_won_as_host = <host_won>}
				<consec_won> = (<ranked_consecutive_won_as_host> + 1)
				SetGlobalTags achievement_info params = {ranked_consecutive_won_as_host = <consec_won>}
			else
				<client_won> = (<ranked_matches_won_as_client> + 1)
				SetGlobalTags achievement_info params = {ranked_matches_won_as_client = <client_won>}
				<consec_won> = (<ranked_consecutive_won_as_client> + 1)
				SetGlobalTags achievement_info params = {ranked_consecutive_won_as_client = <consec_won>}
			endif
			if (<standard_controller> = 1)
				<controller_won> = (<ranked_matches_won_with_standard_controller> + 1)
				SetGlobalTags achievement_info params = {ranked_matches_won_with_standard_controller = <controller_won>}
			endif
		else
			if (<HOST> = 1)
				SetGlobalTags \{achievement_info params = {ranked_consecutive_won_as_host = 0}}
			else
				SetGlobalTags \{achievement_info params = {ranked_consecutive_won_as_client = 0}}
			endif
		endif
	endif
	GetGlobalTags \{achievement_info}
	printstruct <...>
endscript
