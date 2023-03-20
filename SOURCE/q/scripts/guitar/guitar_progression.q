progression_beat_game_last_song = 0
progression_unlock_tier_last_song = 0
progression_got_sponsored_last_song = 0
progression_play_completion_movie = 0
progression_completion_tier = 1
progression_unlocked_guitar = -1
progression_unlocked_guitar2 = -1
progression_unlocked_type = guitar
#"0xc48885fc" = {
	prefix = 'career'
	num_tiers = 1
	tier1 = {
		title = ""
		songs = [
			#"0x00000000"
		]
		level = load_z_viewer
		defaultunlocked = 1
		setlist_icon = #"0x3a4a769d"
	}
}
GH3_Career_NumSongToProgress = {
	easy = 1
	medium = 1
	hard = 1
	expert = 1
}

script Progression_Init
	printf \{"Progression_Init"}
	Tier = 0
	get_progression_globals game_mode = ($game_mode)
	if ($game_mode = p1_career || $game_mode = p2_career)
		FormatText checksumName = tiername 'tier%i' i = (<Tier> + 1)
		Change current_level = ($<tier_global>.<tiername>.level)
	endif
	Change \{setlist_previous_tier = 1}
	Change \{setlist_previous_song = 0}
	Change \{setlist_previous_tab = tab_setlist}
endscript

script Progression_EndOfFirstUpdate
	Change \{end_credits = 0}
	Change \{progression_beat_game_last_song = 0}
	Change \{progression_unlock_tier_last_song = 0}
	Change \{progression_got_sponsored_last_song = 0}
	Change \{progression_play_completion_movie = 0}
	Change \{progression_unlocked_guitar = -1}
	Change \{progression_unlocked_guitar2 = -1}
	Change \{progression_unlocked_type = guitar}
endscript

script Progression_TierSongsComplete
	printf \{"Progression_TierSongsComplete"}
endscript

script Progression_TierEncoreUnlock
endscript

script Progression_TierEncoreComplete
endscript

script Progression_TierBossUnlock
endscript

script Progression_TierBossComplete
endscript

script Progression_TierComplete
endscript

script Progression_UnlockVenue
endscript

script Progression_UnlockTier
endscript

script Progression_CheckSongComplete
endscript

script Progression_CheckEncoreComplete
endscript

script Progression_CheckBossComplete
endscript

script Progression_CheckSong5Star
endscript

script Progression_CheckAllSongsCompleted
endscript

script Progression_AlwaysBlock
	printf \{"Progression_AlwaysBlock"}
	return \{FALSE}
endscript

script Progression_CheckDiff
	printf \{"Progression_CheckDiff"}
	progression_getdifficulty
	if NOT (<diff> = <difficulty>)
		return \{FALSE}
	endif
	if GotParam \{mode}
		if NOT ($game_mode = <mode>)
			return \{FALSE}
		endif
	endif
	return \{true}
endscript

script Progression_UnlockGuitar
endscript

script Progression_SongFailed
endscript

script Progression_SongWon
	printf \{"Progression_SongWon"}
	additional_cash = 0
	Change \{progression_beat_game_last_song = 0}
	Change \{progression_unlock_tier_last_song = 0}
	Change \{progression_got_sponsored_last_song = 0}
	Change \{progression_play_completion_movie = 0}
	Player = 1
	begin
		FormatText checksumName = player_status 'player%i_status' i = <Player>
		new_stars = 3
		if ($<player_status>.score >= $<player_status>.base_score * 2.8)
			new_stars = 5
		elseif ($<player_status>.score >= $<player_status>.base_score * 2)
			new_stars = 4
		endif
		Change StructureName = <player_status> stars = <new_stars>
		Player = (<Player> + 1)
	repeat $current_num_players
	if ($coop_dlc_active = 1)
		if ($player1_status.total_notes = $player1_status.notes_hit)
			if NOT ($player1_status.total_notes = 0)
				WriteAchievements \{achievement = LEADERS_OF_THE_PACK}
			endif
		endif
		return
	endif
	get_difficulty_text_nl difficulty = ($current_difficulty)
	get_song_prefix song = ($current_song)
	FormatText checksumName = songname '%s_%d' s = <song_prefix> d = <difficulty_text_nl>
	if ($player1_status.total_notes > 0)
		p1_percent_complete = (100 * $player1_status.notes_hit / $player1_status.total_notes)
		if (<p1_percent_complete> = 100)
			if ($game_mode = p1_quickplay)
				SetGlobalTags <songname> params = {percent100 = 1}
			endif
			if ($game_mode = p1_quickplay ||
				$game_mode = p1_career)
				SetGlobalTags <songname> params = {achievement_gold_star = 1}
			endif
		endif
	endif
	if ($game_mode = p1_career ||
		$game_mode = p2_career)
		get_progression_globals game_mode = ($game_mode)use_current_tab = 1
		SongList = <tier_global>
		get_band_game_mode_name
		FormatText checksumName = bandname_id 'band%i_info_%g' i = ($current_band)g = <game_mode_name>
		SetGlobalTags <bandname_id> params = {first_play = 0}
		GetGlobalTags \{Progression params = current_tier}
		GetGlobalTags \{Progression params = current_song_count}
		song_count = <current_song_count>
		if GotParam \{current_tier}
			setlist_prefix = ($<SongList>.prefix)
			FormatText checksumName = song_checksum '%p_song%i_tier%s' p = <setlist_prefix> i = (<song_count> + 1)s = <current_tier> AddToStringLookup = true
			FormatText checksumName = tier_checksum 'tier%s' s = <current_tier>
			if Progression_IsBossSong tier_global = <tier_global> Tier = <current_tier> song = (<tier_global>.<tier_checksum>.songs [<song_count>])
				Change \{StructureName = player1_status stars = 5}
			endif
			GetGlobalTags <song_checksum> param = stars
			GetGlobalTags <song_checksum> param = score
			if ($game_mode = p1_career)
				new_score = ($player1_status.score)
				new_stars = ($player1_status.stars)
			else
				new_score = ($player1_status.score + $player2_status.score)
				new_stars = (($player1_status.stars + $player1_status.stars)/ 2)
			endif
			if ($player1_status.total_notes > 0)
				p1_percent_complete = (100 * $player1_status.notes_hit / $player1_status.total_notes)
				if (<p1_percent_complete> = 100)
					SetGlobalTags <song_checksum> params = {percent100 = 1}
				endif
			endif
			if (<new_stars> > <stars>)
				SetGlobalTags <song_checksum> params = {stars = <new_stars>}
				if ($current_tab = tab_setlist)
					if NOT StructureContains structure = (<tier_global>.<tier_checksum>)nocash
						Progression_AwardCash old_stars = <stars> new_stars = <new_stars>
					endif
				endif
			endif
			if (<new_score> > <score>)
				casttointeger \{new_score}
				SetGlobalTags <song_checksum> params = {score = <new_score>}
			endif
			Progression_CalcSetlistNextSong tier_global = <tier_global>
		endif
	endif
	Achievements_SongWon additional_cash = <additional_cash>
	if ($game_mode = p1_career || $game_mode = p2_career)
		updateatoms \{name = Progression}
	endif
	Change \{Achievements_SongWonFlag = 1}
	updateatoms \{name = achievement}
endscript
end_credits = 0
boss_devil_score = 0

script Progression_EndCredits
	printf \{"CREDITS BEGIN"}
	Change boss_devil_score = ($player1_status.score)
	Change \{current_level = load_z_credits}
	ui_flow_manager_respond_to_action \{action = select_retry}
	Change \{current_song = thrufireandflames}
	create_loading_screen
	Load_Venue
	restart_gem_scroller song_name = ($current_song)difficulty = ($current_difficulty)difficulty2 = ($current_difficulty2)startTime = 0 end_credits_restart = 1
	destroy_loading_screen
	start_flow_manager \{flow_state = career_play_song_fs}
	spawnscriptnow \{scrolling_list_begin}
endscript

script Progression_EndCredits_Done
	if ($end_credits = 1)
		Change StructureName = player1_status score = ($boss_devil_score)
		Change \{boss_devil_score = 0}
	endif
	destroy_credits_menu
endscript

script PlayMovie_EndCredits
	KillMovie \{textureSlot = 1}
	PreLoadMovie \{movie = 'Fret_Flames' textureSlot = 1 TexturePri = -2 no_loop no_hold}
	begin
		if (isMoviePreLoaded textureSlot = 1)
			StartPreLoadedMovie \{textureSlot = 1}
			return
		endif
		wait \{1 gameframe}
	repeat
endscript

script Progression_CalcSetlistNextSong
	if ($current_tab = tab_setlist)
		setlist_prefix = ($<tier_global>.prefix)
		num_tiers = ($<tier_global>.num_tiers)
		Tier = 1
		begin
			FormatText checksumName = tiername '%ptier%i' p = <setlist_prefix> i = <Tier>
			GetGlobalTags <tiername> param = unlocked
			if (<unlocked> = 0)
				Tier = (<Tier> - 1)
				break
			endif
			Tier = (<Tier> + 1)
		repeat <num_tiers>
		if (<Tier> > <num_tiers>)
			Tier = <num_tiers>
		endif
		found = 0
		Progression_GetBossSong tier_global = <tier_global> Tier = <Tier>
		if (<song_count> = -1 & found = 0)
			FormatText checksumName = song_checksum '%p_song%i_tier%s' p = <setlist_prefix> i = (<song_count> + 1)s = <Tier> AddToStringLookup = true
			GetGlobalTags <song_checksum> param = unlocked
			if (<unlocked> = 1)
				found = 1
			endif
		endif
		Progression_GetEncoreSong tier_global = <tier_global> Tier = <Tier>
		if (<song_count> = -1 & found = 0)
			FormatText checksumName = song_checksum '%p_song%i_tier%s' p = <setlist_prefix> i = (<song_count> + 1)s = <Tier> AddToStringLookup = true
			GetGlobalTags <song_checksum> param = unlocked
			if (<unlocked> = 1)
				found = 1
			endif
		endif
		if (<found> = 0)
			FormatText checksumName = tier_checksum 'tier%s' s = <Tier>
			GetArraySize (<tier_global>.<tier_checksum>.songs)
			song_count = 0
			begin
				FormatText checksumName = song_checksum '%p_song%i_tier%s' p = <setlist_prefix> i = (<song_count> + 1)s = <Tier> AddToStringLookup = true
				GetGlobalTags <song_checksum> param = stars
				GetGlobalTags <song_checksum> param = unlocked
				if (<stars> < 3 & <unlocked> = 1)
					found = 1
					break
				endif
				song_count = (<song_count> + 1)
			repeat <array_Size>
		endif
		if (<found> = 1)
			Change setlist_previous_tier = <Tier>
			Change setlist_previous_song = <song_count>
		endif
	endif
endscript

script Progression_AwardCash
endscript

script Progression_CountCompletedSongsInCurrentTier
endscript

script Progression_GetNumTierSong
endscript

script Progression_GetTierSong
endscript

script Progression_GetBossSong
endscript

script Progression_GetEncoreSong
endscript

script Progression_IsBossSong
endscript

script Progression_IsEncoreSong
endscript

script Progression_UnlockSong
endscript

script progression_getdifficulty
	difficulty = ($current_difficulty)
	if ($game_mode = p2_career)
		get_minimum_difficulty difficulty1 = ($current_difficulty)difficulty2 = ($current_difficulty2)
		difficulty = <minimum_difficulty>
	endif
	return difficulty = <difficulty>
endscript

script Progression_SetProgressionNodeFlags
	if ($coop_dlc_active = 1)
		Change \{game_mode = p2_career}
	endif
	ChangeNodeFlag \{LS_ALWAYS 1}
	ls_encore = 0
	ls_3_5 = 0
	get_progression_globals game_mode = ($game_mode)
	Tier = ($setlist_selection_tier)
	if ($coop_dlc_active = 0)
		if ($game_mode = p1_career ||
			$game_mode = p2_career)
			if Progression_IsEncoreSong tier_global = <tier_global> Tier = <Tier> song = ($current_song)
				ls_encore = 1
			endif
			progression_getdifficulty
			Progression_CountCompletedSongsInCurrentTier
			if (<difficulty> = easy || <difficulty> = medium)
				if (<completed_songs> >= 2)
					ls_3_5 = 1
				endif
			else
				if (<completed_songs> >= 3)
					ls_3_5 = 1
				endif
			endif
		endif
	endif
	printf "Progression_SetProgressionNodeFlags encore = %d 3_5 = %i" d = <ls_encore> i = <ls_3_5>
	if (<ls_encore> = 1)
		ChangeNodeFlag \{LS_3_5_PRE 0}
		ChangeNodeFlag \{LS_3_5_POST 1}
		ChangeNodeFlag \{LS_ENCORE_PRE 0}
		ChangeNodeFlag \{LS_ENCORE_POST 1}
	elseif (<ls_3_5> = 1)
		ChangeNodeFlag \{LS_3_5_PRE 0}
		ChangeNodeFlag \{LS_3_5_POST 1}
		ChangeNodeFlag \{LS_ENCORE_PRE 1}
		ChangeNodeFlag \{LS_ENCORE_POST 0}
	else
		ChangeNodeFlag \{LS_3_5_PRE 1}
		ChangeNodeFlag \{LS_3_5_POST 0}
		ChangeNodeFlag \{LS_ENCORE_PRE 1}
		ChangeNodeFlag \{LS_ENCORE_POST 0}
	endif
endscript
#"0xfde7f2e2" = {
	tier_global = #"0xc48885fc"
	progression_global = None
}
P1_career_progression = $#"0xfde7f2e2"
P2_career_progression = $#"0xfde7f2e2"
Bonus_progression = $#"0xfde7f2e2"
Download_progression = $#"0xfde7f2e2"
General_progression = $#"0xfde7f2e2"
GeneralP2_progression = $#"0xfde7f2e2"
P2_coop_progression = $#"0xfde7f2e2"
Demo_progression_Career = $#"0xfde7f2e2"
Demo_progression_Coop = $#"0xfde7f2e2"
Demo_progression_Multiplayer = $#"0xfde7f2e2"
Demo_progression_Quickplay = $#"0xfde7f2e2"

script get_progression_globals {game_mode = <game_mode> use_current_tab = 0}
	if (<use_current_tab> = 1)
		if ($current_tab = tab_bonus)
			Bonus = 1
		elseif ($current_tab = tab_downloads)
			download = 1
		endif
	endif
	if ($is_demo_mode = 1)
		if GotParam \{Bonus}
			AddParams ($Bonus_progression)
		elseif GotParam \{download}
			AddParams ($Download_progression)
		elseif (<game_mode> = p1_career)
			AddParams ($Demo_progression_Career)
		elseif (<game_mode> = p2_career)
			AddParams ($Demo_progression_Coop)
		elseif (<game_mode> = p1_quickplay)
			AddParams ($Demo_progression_Quickplay)
		else
			AddParams ($Demo_progression_Multiplayer)
		endif
		return tier_global = <tier_global> progression_global = <progression_global>
	endif
	if GotParam \{Bonus}
		AddParams ($Bonus_progression)
	elseif GotParam \{download}
		AddParams ($Download_progression)
	elseif (<game_mode> = p1_career)
		AddParams ($P1_career_progression)
	elseif (<game_mode> = p2_career)
		AddParams ($P2_career_progression)
	elseif (<game_mode> = p1_quickplay)
		AddParams ($General_progression)
	elseif (<game_mode> = p2_coop)
		AddParams ($P2_coop_progression)
	else
		AddParams ($GeneralP2_progression)
	endif
	return tier_global = <tier_global> progression_global = <progression_global>
endscript
