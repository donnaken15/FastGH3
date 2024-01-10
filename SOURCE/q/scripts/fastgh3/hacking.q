
script key_events
	begin
		//ProfilingStart
		//if ($toggle_console = 0)
		WinPortSioGetControlPress \{deviceNum = $player1_device}
		if NOT (<controlNum> = -1)
			if (<controlNum> = 323) // Tab
				// emulator moment
				if (($console_pause = 1 & $toggle_console = 0) | $console_pause = 0)
					if ($hold_tab = 0)
						change old_speed = ($current_speedfactor)
						change current_speedfactor = ($old_speed * $fastforward)
						update_slomo
						change \{hold_tab = 1}
					endif
				endif
			endif
			if (<controlNum> = 253) // ~
				if NOT ($last_key = <controlNum>)
					toggle = toggle_console
					change globalname = <toggle> newvalue = (1 - $<toggle>)
					if ($toggle_console)
						//printf 'opened console'
						create_keyboard_input
					else
						destroy_keyboard_input
					endif
				endif
			endif
			if (<controlNum> = 267 | <controlNum> = 311) // l/rshift
				if ($might_hold_shift = 0)
					change might_hold_shift = 1
				endif
			endif
		else
			if ($might_hold_shift = 1)
				change might_hold_shift = 0
			endif
		endif
		if NOT (<controlNum> = 323)
			if ($hold_tab = 1)
				change current_speedfactor = ($old_speed)
				update_slomo
				change \{hold_tab = 0}
			endif
		endif
		change last_key = <controlNum>
		//ProfilingEnd <...> 'test' loop ____profiling_interval = 800
		Wait \{1 gameframe}
	repeat
endscript
last_key = 0
old_speed = -1.0
hold_tab = 0
fastforward = 2.0

script lefty_toggle \{player_status = player1_status}
	killspawnedscript \{id=lefty_toggle}
	if ($<player_status>.player = 1)
		toggle_global \{p1_lefty}
		left = $p1_lefty
	else
		toggle_global \{p2_lefty}
		left = $p2_lefty
	endif
	if GotParam \{save}
		if ($<player_status>.player = 1)
			text = 'Player1' // Y U NO WORK FORMATTEXT
		else
			text = 'Player2'
		endif
		FGH3Config sect=<text> 'Lefty' set=<left>
	endif
	Change StructureName = <player_status> lefthanded_gems = <left>
	begin
		if NOT GameIsPaused
			break
		endif
		wait \{1 gameframe}
	repeat
	wait ((0.28 / $current_speedfactor) * $<player_status>.scroll_time) seconds
	animate_lefty_flip other_player_status = <player_status>
	Change StructureName = <player_status> lefthanded_button_ups = <left>
endscript

script everyone_deploy // :P
	player = 1
	begin
		formattext checksumname = player_status 'player%d_status' d = <player>
		if ($<player_status>.bot_play = 1)
			if ($<player_status>.star_power_used = 0)
				if ($<player_status>.star_power_amount >= 50.0)
					spawnscriptnow star_power_activate_and_drain params = {
						player_status = <player_status>
						Player = <player>
						player_text = ($<player_status>.text)
					}
				endif
			endif
		endif
		player = (<player> + 1)
	repeat $current_num_players
endscript

fastgh3_path_triggers = []
// soulless 5
;fastgh3_path_triggers = [33230 120000 148610 187610 246610 307460 350760 431200 507690 585000 658960 716300 794530 831380 876460 900920 983070]
// soulless 1 path from CHOpt
;fastgh3_path_triggers = [9446 18638 37851 57127 85851 151148 191936 265276 298148 334978]
script muh_arby_bot_star
	if ($is_network_game)
		return
	endif
	if ($player1_status.bot_play = 0 & $player2_status.bot_play = 0)
		printf \{'bot not turned on!!!!!!!!!!!!!'}
		return
	endif
	if ($game_mode = p2_battle)
		printf \{'fake battle bot (with self awareness!!!!!!)'}
		begin
			wait \{0.1 seconds}
			i = 1
			j = 3
			begin
				formattext checksumname = player_status 'player%i_status' i = <i>
				if ($<player_status>.bot_play = 1)
					count = ($<player_status>.current_num_powerups)
					if (<count> > 0)
						ExtendCrc current_powerups_ ($<player_status>.text) out=pows
						current_powerup = ($<pows>[(<count> - 1)])
						if (randomrange (0.0, 100.0) > 90.0 || <current_powerup> = 3 || <current_powerup> = 8)
							formattext checksumname = other_player_status 'player%i_status' i = (<j> - <i>)
							if NOT ((<current_powerup> = 3 & $<other_player_status>.current_num_powerups = 0) || (<current_powerup> = 8 & ($<player_status>.current_health > $health_medium_good | $<player_status>.star_power_used = 1)))
								// can't use multiple NOTs within conditions, stupid
								if (<current_powerup> = 8 & $<player_status>.star_power_used = 1)
									wait \{2 gameframe} // causes display glitch if i don't wait when the bot has 2 star powers
								endif
								battle_trigger_on player_status = <player_status>
							endif
						endif
					endif
				endif
				Increment \{i}
			repeat ($current_num_players)
		repeat
		return
	endif
	if (($game_mode = p2_career || $game_mode = p2_coop) & ($player1_status.bot_play = 0 || $player2_status.bot_play = 0))
		printf \{'co-op with bot, manual triggering by player enabled'}
		return
	endif
	getarraysize \{$fastgh3_path_triggers}
	if (<array_size> = 0)
		printf \{'star power bot: triggering every 16 beats'}
		begin
			wait_beats \{16}
			everyone_deploy
		repeat
	else
		printf \{'star power bot: using provided path'}
		i = 0
		begin
			begin
				GetSongTimeMs
				if ($fastgh3_path_triggers[<i>] < (<time> + ($check_time_early * 1000.0) + 10))
					break
				endif
				Wait \{1 gameframe}
			repeat
			Increment \{i}
			everyone_deploy
		repeat <array_size>
	endif
endscript

// TODO: only print necessary info
script PrintPlayer\{player_status = player1_status}
	/**player_status = $<player_status>
	printstruct {
		player = {
			controller = (<player_status>.controller)
			Player = (<player_status>.Player)
			star_power_usable = (<player_status>.star_power_usable)
			star_power_amount = (<player_status>.star_power_amount)
			star_tilt_threshold = (<player_status>.star_tilt_threshold)
			playline_song_measure_time = (<player_status>.playline_song_measure_time)
			star_power_used = (<player_status>.star_power_used)
			current_run = (<player_status>.current_run)
			//resting_whammy_position = (<player_status>.resting_whammy_position)
			bot_play = (<player_status>.bot_play)
			//bot_pattern = (<player_status>.bot_pattern)
			//bot_strum = (<player_status>.bot_strum)
			part = (<player_status>.part)
			lefthanded_gems = (<player_status>.lefthanded_gems)
			current_song_gem_array = (<player_status>.current_song_gem_array)
			current_song_fretbar_array = (<player_status>.current_song_fretbar_array)
			current_song_star_array = (<player_status>.current_song_star_array)
			//current_star_array_entry = (<player_status>.current_star_array_entry)
			current_song_beat_time = (<player_status>.current_song_beat_time)
			playline_song_beat_time = (<player_status>.playline_song_beat_time)
			current_song_measure_time = (<player_status>.current_song_measure_time)
			//time_in_lead = (<player_status>.time_in_lead)
			hammer_on_tolerance = (<player_status>.hammer_on_tolerance)
			check_time_early = (<player_status>.check_time_early)
			check_time_late = (<player_status>.check_time_late)
			whammy_on = (<player_status>.whammy_on)
			star_power_sequence = (<player_status>.star_power_sequence)
			star_power_note_count = (<player_status>.star_power_note_count)
			score = (<player_status>.score)
			notes_hit = (<player_status>.notes_hit)
			total_notes = (<player_status>.total_notes)
			best_run = (<player_status>.best_run)
			max_notes = (<player_status>.max_notes)
			base_score = (<player_status>.base_score)
			stars = (<player_status>.stars)
			sp_phrases_hit = (<player_status>.sp_phrases_hit)
			sp_phrases_total = (<player_status>.sp_phrases_total)
			multiplier_count = (<player_status>.multiplier_count)
			num_multiplier = (<player_status>.num_multiplier)
			sim_bot_score = (<player_status>.sim_bot_score)
			scroll_time = (<player_status>.scroll_time)
			game_speed = (<player_status>.game_speed)
			highway_speed = (<player_status>.highway_speed)
			//highway_material = (<player_status>.highway_material)
			guitar_volume = (<player_status>.guitar_volume)
			last_guitar_volume = (<player_status>.last_guitar_volume)
			last_faceoff_note = (<player_status>.last_faceoff_note)
			is_local_client = (<player_status>.is_local_client)
			//current_num_powerups = (<player_status>.current_num_powerups)
			death_lick_attack = (<player_status>.death_lick_attack)
			//broken_string_mask = (<player_status>.broken_string_mask)
			//broken_string_green = (<player_status>.broken_string_green)
			//broken_string_red = (<player_status>.broken_string_red)
			//broken_string_yellow = (<player_status>.broken_string_yellow)
			//broken_string_blue = (<player_status>.broken_string_blue)
			//broken_string_orange = (<player_status>.broken_string_orange)
			//gem_filler_enabled_time_on = (<player_status>.gem_filler_enabled_time_on)
			//gem_filler_enabled_time_off = (<player_status>.gem_filler_enabled_time_off)
			current_health = (<player_status>.current_health)
			button_checker_up_time = (<player_status>.button_checker_up_time)
			last_playline_song_beat_time = (<player_status>.last_playline_song_beat_time)
			last_playline_song_beat_change_time = (<player_status>.last_playline_song_beat_change_time)
		}
	}/**///
	//printstruct $<player_status>
endscript

script keytest
	CreateScreenElement {
		Type = TextElement
		parent = root_window
		id = keytest_text
		font = text_a1
		Pos = (128.0, 64.0)
		just = [left top]
		Scale = (1.0, 1.0)
		rgba = [255 255 255 255]
		text = 'test'
		z_priority = 1000
		alpha = 1
	}
	begin
		WinPortSioGetControlPress \{deviceNum = $player1_device actionNum = 0}
		if NOT (<controlNum> = -1)
			FormatText textname=text 'test: %d: %e' d=$player1_device e=<controlNum>
			SetScreenElementProps id=keytest_text text=<text>
		endif
		wait \{1 gameframe}
	repeat 10000
	if ScreenElementExists \{id = keytest_text}
		DestroyScreenElement \{id = keytest_text}
	endif
endscript

// ../guitar/guitar_gems.q:664
mbt_b = 1
script mbt_test
	if NOT ScreenElementExists \{id = mbt_test}
		CreateScreenElement {
			type = TextElement
			font = num_a9
			pos = (1100.0, 80.0)
			just = [right top]
			text = 'test'
			scale = 1.0
			parent = root_window
			id = mbt_test
			font_spacing = 5
		}
	endif
	if (<fretbar_scale> = thick)
		change \{mbt_b = 0}
	endif
	change mbt_b = ($mbt_b + 1)
	Increment \{measure}
	pad <measure> count = 4
	m = <pad>
	pad ($mbt_b) count = 2
	FormatText textname = text 'M.B.T: %m:%b' m = <m> b = <pad>
	SetScreenElementProps id = mbt_test text = <text>
endscript

script Ternary \{out = ternary}
	//ProfilingStart
	if (<#"0x00000000"> = 0)
		ternary = <b>
	else
		ternary = <a>
	endif
	if (<out> = ternary)
		//ProfilingEnd <...> 'ternary'
		return ternary = <ternary>
	endif
	AddParams \{output = {}} // should i even do it like this
	AddParam structure_name = output name = <out> value = <ternary>
	if StructureContains structure=<output> <out>
		return <output>
	else
		return ternary = <ternary>
	endif
endscript

// for concatenating simple strings into QbKey
// because i can't just shove a local var into array declaration
script FastFormatCrc \{#"0xFFFFFFFF"}
	// key a = '_' b = 'p1' out = testkey
	//
	// perfect real world example:
	// FormatText checksumName = gem_array '%s_%t_%p%d' s = <song_prefix> t = 'song' p = <part> d = <difficulty_text_nl> AddToStringLookup
	// replaced with
	// FastFormatCrc $current_song a = '_song_' b = <part> c = <difficulty_text_nl> out = gem_array
	// also why does the game have a conniption fit when i create a variable named "test"
	if NOT GotParam \{#"0x00000000"}
		return
	endif
	if NOT GotParam \{out}
		return
	endif
	if NOT GotParam \{a}
		return
	endif
	//x = <#"0x00000000">
	//ProfilingStart
	AddParams \{params = [a b c d e]}
	// allow as many strings as i'll necessarily need
	GetArraySize \{params}
	i = 0
	z = ''
	begin
		param = (<params>[<i>])
		if NOT GotParam <param>
			break
		endif
		ExtendCrc <#"0x00000000"> (<...>.<param>) out = #"0x00000000"
		z = (<z> + (<...>.<param>))
		Increment \{i}
	repeat <array_size>
	AddParam structure_name = output name = <out> value = <#"0x00000000">
	//ProfilingEnd <...> 'FastFormatCrc'
	//printf '%x%z' x = <x> z = <z>
	//printstruct <...>
	return <output>
endscript
script SysTex
	name = ('sys_' + <#"0x00000000">)
	ExtendCrc #"0xFFFFFFFF" (<name> + '_' + <name>) out = sys_tex
	return sys_tex = <sys_tex>
endscript

script create_debug_gem
	//return
	Create2DGem {
		color = <color>
		marker = <marker>
		time = <time>
		song = <song>
		entry = <entry>
		gem_count = <gem_count>
		player = <player>
		player_text = <player_text>
		player_status = <player_status>
	}
	if (<color> = open) // oh no
		gem_count = 2
	endif
	if ($gem_debug_text = 0)
		return
	endif
	input = ($<song>[<entry>])
	// useful maybe (probably input_arrayp1):
	// 0: time
	// 1-5: G/R/Y/B/O lengths
	// 6: hammer/tap flags
	// 7: (input) time end??
	FormatText textname = gem_text '%g_%e_gem_p%p' e = <entry> g = ($gem_colors_text[<gem_count>]) p = <player>
	ExtendCrc #"0xFFFFFFFF" <gem_text> out = gem
	if (<color> = open)
		gem_count = 5
	endif
	pad (<input>[(<gem_count>+1)]) count = 5 pad = ' '
	//FormatText textname = gem_text '%l' l = (<input>[(<gem_count>+1)])
	flag = ''
	switch (<input>[6])
		case 1
			flag = ' H'
		case 2
			flag = ' T'
	endswitch
	FormatText textname = gem_text '%l%f' l = <pad> f = <flag>
	//ExtendCrc <gem> '_text' out = gem_debug_id
	if ScreenElementExists id = <gem>
		CreateScreenElement {
			id = <gem_debug_id> parent = <gem>
			type = textblockelement text = <gem_text>
			just = [left bottom] pos = (-32.0, 0.0)
			internal_just = [left bottom]
			dims = (160.0, 64.0)
			font = text_a1 scale = 1.2 }
		//SetScreenElementProps id = <gem> material = sys_Gem2D_Red_sys_Gem2D_Red
	endif
endscript

fakearray = [
	[ 100 100 100 0 0 0 1 0 ]
]

script debugNoteCRC \{name = 'gem' color = 'green' array_entry = 0 player = 1}
	formattext checksumName = debug_id '%c_%e_%t_p%p' c = <color> e = <array_entry> t = <name> p = <player>
	//printf '%c_%e_%t_p%p' c = <color> e = <array_entry> t = <name> p = <player>
	return debug_id = <debug_id>
endscript

script fakenote \{#"0x00000000" = 0 player = 1}
	Ternary (<player> = 2) a = player2_status b = player1_status out = player_status
	player = ($<player_status>.player)
	player_text = ($<player_status>.text)
	ExtendCrc input_array <player_text> out = input_array
	GetSongTimeMs
	MathFloor <time>
	//debugNoteCRC name = ($gem_colors_text[<#"0x00000000">]) array_entry = 0 color = 'gem' player = <player>
	//gem = <debug_id>
	FormatText textname = gem_text '%g_%e_%t_p%p' g = ($gem_colors_text[<#"0x00000000">]) e = 0 t = 'gem' p = <player>
	FormatText checksumname = gem '%g' g = <gem_text>
	Create2DGem {
		color = mine
		marker = 0
		time = 0
		song = fakearray
		entry = 0
		gem_count = <#"0x00000000">
		player = <player>
		player_text = <player_text>
		player_status = <player_status>
	}
	if ScreenElementExists id = <gem>
		CreateScreenElement {
			id = testgem parent = <gem>
			type = textelement text = 'test'
			just = [left bottom] pos = (0.0, 0.0)
			font = text_a4 scale = 1.0 }
		SetScreenElementProps id = <gem> material = sys_Gem2D_Red_sys_Gem2D_Red
		killtime = ($<player_status>.scroll_time) // is this correct?
		Wait <killtime> seconds
		printf '%d' d = <killtime>
		DestroyGem name = <gem>
	endif
endscript

// notes disappear when speed is backwards
/**script rewind \{3000.0}
	GetSongTimeMs
	current_time = <time>
	return_to = (<time> - <#"0x00000000">)
	if (<return_to> < 0.0)
		return_to = 0.0
	endif
	//WinPortSongHighwaySync \{sync = 0}
	PauseGh3Sounds
	setslomo \{-1.0}
	begin
		GetSongTimeMs
		i = 1
		begin
			formattext checksumname = button_ups 'button_up_pixel_arrayp%i' i = <i>
			j = 0
			begin
				setarrayelement arrayname = <button_ups> globalarray index = <j> newvalue = 0.0
				Increment \{j}
			repeat 5
			Increment \{i}
		repeat $current_num_players
		if (<time> < <return_to>)
			break
		endif
		wait \{1 gameframe}
	repeat
	setslomo \{1.0}
	UnpauseGh3Sounds
	printstruct <...>
	CastToInteger \{return_to}
	SetSeekPosition_Song position = <return_to>
	//WinPortSongHighwaySync \{sync = 1}
endscript/**///

script ProfilingStart \{ time = 0.0 }
	ProfileTime
	return ____profiling_checkpoint_1 = <time>
endscript
script ProfilingEnd \{ time = 0.0 #"0x00000000" = 'unnamed script' ____profiling_i = 0 ____profiling_interval = 60 }
	ProfileTime
	____profiling_time = ((<time> - <____profiling_checkpoint_1>) * 0.0001)
	if NOT GotParam \{ loop }
		printf 'profiled script %s, %t ms' s = <#"0x00000000"> t = <____profiling_time>
		return profile_time = <____profiling_time>
	endif
	if (<____profiling_i> = 0)
		____profiling_samples = []
	endif
	element=(<____profiling_time> * 10000)
	CastToInteger \{element}
	AddArrayElement array=<____profiling_samples> element=<element>
	Increment \{____profiling_i}
	if (<____profiling_i> > <____profiling_interval>)
		____profiling_i = 0
		RemoveComponent \{____profiling_samples}
		Avg <array>
		GetArraySize \{array}
		//printstruct <...>
		printf 'profiled script %s, %t ms, %n samples' n = (<array_size> - 1) s = <#"0x00000000"> t = (<avg> * 0.0001) // C++ broken >:(
	endif
	return {
		profile_time = <____profiling_time>
		____profiling_i = <____profiling_i>
		____profiling_samples = <array>
	}
endscript

