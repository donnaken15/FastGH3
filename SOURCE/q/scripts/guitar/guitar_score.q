points_per_note = {
	easy = 50.0
	medium = 50.0
	hard = 50.0
	expert = 50.0
}
points_per_note_per_beat = {
	easy = 25.0
	medium = 25.0
	hard = 25.0
	expert = 25.0
}

script reset_score
	Change StructureName = <player_status> score = 0
	Change StructureName = <player_status> notes_hit = 0
	Change StructureName = <player_status> total_notes = 0
	Change StructureName = <player_status> best_run = 0
	Change StructureName = <player_status> current_run = 0
	Change StructureName = <player_status> sp_phrases_hit = 0
	Change StructureName = <player_status> multiplier_count = 0
	Change StructureName = <player_status> num_multiplier = 0
	Change StructureName = <player_status> time_in_lead = 0.0
	last_time_in_lead = 0.0
	last_time_in_lead_player = -1
	ExtendCrc \{$current_song '_markers' out = song_section_array}
	Change current_section_array = <song_section_array>
	Change \{current_section_array_entry = 0}
	FormatText checksumName = detailstats_array '%s_last_song_detailed_stats' s = (<player_status>.text)
	Change StructureName = <player_status> current_detailedstats_array_entry = 0
	Change StructureName = <player_status> current_detailedstats_array = <detailstats_array>
	FormatText checksumName = detailstats_array_max '%s_last_song_detailed_stats_max' s = (<player_status>.text)
	Change StructureName = <player_status> current_detailedstats_max_array = <detailstats_array_max>
	GetArraySize ($<detailstats_array>)
	array_count = 0
	begin
		SetArrayElement ArrayName = <detailstats_array> GlobalArray index = <array_count> NewValue = 0
		SetArrayElement ArrayName = <detailstats_array_max> GlobalArray index = <array_count> NewValue = 0
		array_count = (<array_count> + 1)
	repeat <array_Size>
	Change \{whammy_mania_achievement_invalidated = 0}
	Change \{gStar_Power_Triggered = 0}
endscript

script calc_songscoreinfo\{player_status = player1_status}
	get_song_prefix song = ($current_song)
	CalcSongScoreInfo <...>
	/*fast_base_score = ($<player_status>.base_score)
	fast_max_notes = ($<player_status>.max_notes)
	fast_sp_phrases_total = ($<player_status>.sp_phrases_total)
	if ($devil_finish = 1)
		return
	endif
	base_score = 0
	max_notes = 0
	sim_bot_score = 0
	sim_bot_multiplier = 1
	sim_bot_note_count = 0
	fretbar_array = ($<player_status>.current_song_fretbar_array)
	if (<fretbar_array> = None)
		return
	endif
	fretbar_count = 0
	GetArraySize $<fretbar_array>
	fretbar_size = <array_Size>
	get_song_prefix song = ($current_song)
	ExtendCrc \{$current_song '_markers' out = song_section_array}
	GetArraySize ($<song_section_array>)
	song_section_array_size = <array_Size>
	FormatText checksumName = detailstats_array_max '%s_last_song_detailed_stats_max' s = (<player_status>.text)
	GetArraySize ($<detailstats_array_max>)
	array_count = 0
	begin
		SetArrayElement ArrayName = <detailstats_array_max> GlobalArray index = <array_count> NewValue = 0
		array_count = (<array_count> + 1)
	repeat <array_Size>
	starpower_array = ($<player_status>.current_song_star_array)
	starpower_array_entry = 0
	starpower_on = 0
	GetArraySize ($<starpower_array>)
	starpower_array_size = <array_Size>
	sp_phrases_total = 0
	if ($game_mode = p2_faceoff)
		faceoff_array_entry = 0
		gemfiller_on = 0
		get_song_prefix song = ($current_song)
		FormatText checksumName = faceoff_array '%s_faceoff%p' s = <song_prefix> p = ($<player_status>.text)AddToStringLookup
		GetArraySize $<faceoff_array>
		faceoff_array_size = <array_Size>
	else
		gemfiller_on = 1
	endif
	song = ($<player_status>.current_song_gem_array)
	difficulty = $current_difficulty
	GetArraySize $<song>
	song_size = (<array_Size> / $num_song_columns)
	array_count = 0
	if (<song_size> = 0)
		Change StructureName = <player_status> max_notes = 0
		Change StructureName = <player_status> base_score = 0
		return
	endif
	section_index = 0
	last_array_count = -1
	begin
		time = ($<song> [<array_count>])
		begin
			if ((<fretbar_count> + 1)= (<fretbar_size> - 1))
				break
			endif
			beat_time = ($<fretbar_array> [(<fretbar_count> + 1)] - $<fretbar_array> [<fretbar_count>])
			if ($<fretbar_array> [(<fretbar_count> + 1)] > <time>)
				break
			endif
			fretbar_count = (<fretbar_count> + 1)
		repeat
		if ($game_mode = p2_faceoff)
			begin
				if (<faceoff_array_entry> >= <faceoff_array_size>)
					break
				endif
				faceoff_starttime = ($<faceoff_array> [<faceoff_array_entry>] [0])
				faceoff_endtime = (<faceoff_starttime> + $<faceoff_array> [<faceoff_array_entry>] [1])
				if (<gemfiller_on> = 1)
					if (<faceoff_endtime> <= <time>)
						gemfiller_on = 0
						printf "gemfiller_on %a %i" a = <gemfiller_on> i = <time>
						faceoff_array_entry = (<faceoff_array_entry> + 1)
					else
						break
					endif
				elseif (<gemfiller_on> = 0)
					if (<faceoff_starttime> <= <time>)
						gemfiller_on = 1
						printf "gemfiller_on %a %i" a = <gemfiller_on> i = <time>
					else
						break
					endif
				endif
			repeat
		endif
		begin
			if (<starpower_array_entry> >= <starpower_array_size>)
				break
			endif
			star_starttime = ($<starpower_array> [<starpower_array_entry>] [0])
			star_endtime = (<star_starttime> + $<starpower_array> [<starpower_array_entry>] [1])
			if (<starpower_on> = 1)
				if (<star_endtime> <= <time>)
					starpower_on = 0
					printf "starpower_on %a %i" a = <starpower_on> i = <time>
					starpower_array_entry = (<starpower_array_entry> + 1)
				else
					break
				endif
			elseif (<starpower_on> = 0)
				if (<star_starttime> <= <time>)
					starpower_on = 1
					printf "starpower_on %a %i" a = <starpower_on> i = <time>
					if (<gemfiller_on> = 1)
						sp_phrases_total = (<sp_phrases_total> + 1)
					endif
				else
					break
				endif
			endif
		repeat
		begin
			if (<song_section_array_size> > (<section_index> + 1))
				if ($<song_section_array> [(<section_index> + 1)].time > <time>)
					break
				else
					section_index = (<section_index> + 1)
				endif
			else
				break
			endif
		repeat
		if (<gemfiller_on> = 1)
			sim_bot_note_count = (<sim_bot_note_count> + 1)
			max_notes = (<max_notes> + 1)
			SetArrayElement ArrayName = <detailstats_array_max> GlobalArray index = <section_index> NewValue = (($<detailstats_array_max> [<section_index>])+ 1)
		endif
		GetArraySize \{$#"0xd4b50263"}
		Color = 0
		whammy_value = -1
		length = ($<song> [(<array_count> + 1)])
		value_bitfield = ($<song> [(<array_count> + 2)])
		begin
			value = 0
			if NOT ((<value_bitfield> / 2)* 2 = <value_bitfield>)
				value = <length>
			endif
			value_bitfield = (<value_bitfield> / 2)
			if (<gemfiller_on> = 1 &
				<value> > 0)
				if (<whammy_value> = -1)
					whammy_value = <value>
				endif
				base_score = (<base_score> + $points_per_note.<difficulty>)
				if (<sim_bot_note_count> < 10)
					sim_bot_score = (<sim_bot_score> + $points_per_note.<difficulty>)
				elseif (<sim_bot_note_count> < 20)
					sim_bot_score = (<sim_bot_score> + $points_per_note.<difficulty> * 2)
				elseif (<sim_bot_note_count> < 30)
					sim_bot_score = (<sim_bot_score> + $points_per_note.<difficulty> * 3)
				else
					sim_bot_score = (<sim_bot_score> + $points_per_note.<difficulty> * 4)
				endif
			endif
			Color = (<Color> + 1)
		repeat <array_Size>
		if (<gemfiller_on> &
			<whammy_value> > (<beat_time> / 2.0)&
			<last_array_count> != <array_count>)
			last_array_count = <array_count>
			whammy_score = 0
			whammy_value = (<whammy_value> - $whammy_shorten * <beat_time>)
			whammy_value_beat = <whammy_value>
			finished = 0
			whammy_fretbar_count = <fretbar_count>
			begin
				whammy_beat_time = ($<fretbar_array> [(<whammy_fretbar_count> + 1)] - $<fretbar_array> [<whammy_fretbar_count>])
				if (<whammy_value> > <whammy_beat_time>)
					whammy_value_beat = <whammy_beat_time>
					whammy_value = (<whammy_value> - <whammy_beat_time>)
				else
					whammy_value_beat = <whammy_value>
					finished = 1
				endif
				additional_score = ($points_per_note_per_beat.<difficulty> * 1.0)
				additional_score = (<additional_score> * <whammy_value_beat>)
				additional_score = (<additional_score> / <whammy_beat_time>)
				whammy_score = (<whammy_score> + <additional_score>)
				if (<sim_bot_note_count> < 10)
					sim_bot_score = (<sim_bot_score> + <additional_score>)
				elseif (<sim_bot_note_count> < 20)
					sim_bot_score = (<sim_bot_score> + <additional_score> * 2)
				elseif (<sim_bot_note_count> < 30)
					sim_bot_score = (<sim_bot_score> + <additional_score> * 3)
				else
					sim_bot_score = (<sim_bot_score> + <additional_score> * 4)
				endif
				printf "Simbot %i Entry %a Whammy %d" i = <sim_bot_score> a = <array_count> d = <additional_score>
				if (<finished> = 1)
					break
				endif
			repeat
			printf "Score %i Entry %a Color %t + whammy %v" i = <base_score> a = <array_count> t = <Color> v = <whammy_score>
			base_score = (<base_score> + <whammy_score>)
		endif
		array_count = (<array_count> + $num_song_columns)
	repeat <song_size>
	printstruct <...>
	Change StructureName = <player_status> max_notes = <max_notes>
	Change StructureName = <player_status> base_score = <base_score>
	Change StructureName = <player_status> sp_phrases_total = <sp_phrases_total>
	casttointeger \{fast_base_score}
	casttointeger \{base_score}
	if (<fast_base_score> != <base_score> ||
		<fast_max_notes> != <max_notes> ||
		<fast_sp_phrases_total> != <sp_phrases_total>)
		ScriptAssert \{"Mismatch in CalcSongScoreInfo"}
	endif*/
endscript

script hit_note
	Change StructureName = <player_status> notes_hit = ($<player_status>.notes_hit + 1)
	Change StructureName = <player_status> current_run = ($<player_status>.current_run + 1)
	Change StructureName = <player_status> total_notes = ($<player_status>.total_notes + 1)
	if ($<player_status>.current_run > $<player_status>.best_run)
		Change StructureName = <player_status> best_run = ($<player_status>.current_run)
	endif
	get_current_multiplier player_status = <player_status>
	difficulty = $current_difficulty
	Change StructureName = <player_status> score = ($<player_status>.score + (<multiplier> * $points_per_note.<difficulty>))
endscript

script miss_note
	Change StructureName = <player_status> total_notes = ($<player_status>.total_notes + 1)
	Change StructureName = <player_status> current_run = 0
endscript

script unnecessary_note
	Change StructureName = <player_status> current_run = 0
endscript

script update_score_fast
	if ($Cheat_PerformanceMode = 1 || hudless = 1)
		if ($game_mode = training)
			begin
				GetSongTimeMs
				if (<time> > $current_section_array[($current_section_array_entry + 1)].time)
					change current_section_array_entry = ($current_section_array_entry + 1)
				endif
				wait \{1 gameframe}
			repeat
		endif
		return
	endif
	UpdateScoreFastInit player_status = <player_status>
	begin
		GetSongTimeMs
		UpdateScoreFastPerFrame player_status = <player_status> time = <time>
		wait \{1 gameframe}
	repeat
endscript
