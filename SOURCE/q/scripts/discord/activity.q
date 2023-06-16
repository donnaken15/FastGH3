
// scripts\discord\activity.qb

// STATE TEXTS
richpres_modes = {
	p1_career = {
		'Career'
	}
	p1_quickplay = {
		'Quickplay'
	}
	training = {
		'Practice'
	}
	p2_faceoff = {
		'Face-Off'
		image = 'faceoff'
	}
	p2_pro_faceoff = {
		'Pro Face-Off'
		image = 'faceoff'
	}
	p2_battle = {
		'Battle'
		image = 'battle'
	}
	p2_career = {
		'Co-op Career'
		image = 'coop'
	}
	p2_coop = {
		'Co-op'
		image = 'coop'
	}
}

// SETS RICH PRESENCE SONG TEXT
// LIKE SO:
// FastGH3
// Song Name - Author
// Quickplay
// 1:00 left
// Expert - Guitar
script richpres_start_song
	Change \{rp_song_active = 1}
	// fastgh3: main_icon // gh3+: slash_hat
	AddParams \{text = 'Unknown mode' smlimage = '' lrgimage = 'main_icon' smltxt = ''}
	get_song_title \{song = $current_song}
	get_song_artist \{song = $current_song with_year = 0}
	FormatText textname = songtext '%a - %b' b = <song_title> a = <song_artist>
	if ($current_num_players = 1)
		lrgtxt = ($difficulty_list_props.$current_difficulty.text)
	else
		FormatText {
			textname = lrgtxt '%a - %b, %c - %d'
			a = ($difficulty_list_props.($current_difficulty).text)
			c = ($difficulty_list_props.($current_difficulty2).text)
			b = ($part_names.($player1_status.part))
			d = ($part_names.($player2_status.part))
		}
	endif
	if StructureContains \{structure=$richpres_modes $game_mode}
		mode_params = ($richpres_modes.$game_mode)
		text = (<mode_params>.#"0x00000000")
		if StructureContains \{structure=mode_params image}
			smlimage = (<mode_params>.image)
		endif
		if ($boss_battle = 1)
			text = 'Boss Battle'
			smlimage = 'battle'
		endif
	endif
	SetRichPresenceMode state = <text> details = <songtext> smltxt = <smltxt> smlimage = <smlimage> lrgtxt = <lrgtxt> lrgimage = <lrgimage>
	spawnscriptnow \{richpres_update_song}
endscript

// UPDATES TIMER
script richpres_update_song
	begin
		richpres_timeleft
		wait \{0.2 seconds}
	repeat
endscript

script richpres_stop_song
	killspawnedscript \{name = richpres_update_song}
	richpres_timeoff
	SetRichPresenceMode \{smlimage=''} // clear small image
	Change \{rp_song_active = 0}
endscript

script richpres_timeleft
	getsongtime
	time = (<time> + $current_starttime)
	get_song_end_time \{song = $current_song}
	casttointeger \{songtime}
	SetRichPresenceMode startTime = <songtime> endtime = (<total_end_time> / 1000)
endscript

script richpres_timeoff
	SetRichPresenceMode \{startTime = -1 endtime = -1}
endscript

script richpres_timeleft_pause
	richpres_timeoff
endscript

script richpres_timeleft_unpause
endscript

richpres_flows = {
	main_menu_fs = 'Main Menu'
	debug_menu_fs = 'Debug Menu'
	#"0x303ae628" = 'Custom Menu'
	career_enter_band_name_fs = 'Career'
	career_choose_band_fs = 'Career'
	career_setlist_fs = 'Career: Setlist'
	quickplay_select_difficulty_fs = 'Quickplay'
	quickplay_setlist_fs = 'Quickplay: Setlist'
	coop_career_select_controllers_fs = 'Co-op Career'
	coop_career_setlist_fs = 'Co-op Career: Setlist'
	mp_select_controller_fs = 'Multiplayer'
	mp_faceoff_setlist_fs = 'Multiplayer: Setlist'
	options_select_option_fs = 'Options'
	practice_select_mode_fs = 'Training'
	practice_setlist_fs = 'Training: Setlist'
}

script richpres_menu
	flow_state = ($ui_flow_manager_state[0])
	text = ''
	if StructureContains structure=$richpres_flows <flow_state>
		text = ($richpres_flows.<flow_state>)
		if (<text> != '' && $rp_song_active = 0)
			SetRichPresenceMode state = <text> details = 'Menu' lrgimage = 'main_icon'
		endif
	endif
endscript
rp_song_active = 0
