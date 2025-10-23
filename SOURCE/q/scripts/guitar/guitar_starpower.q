WhammyWibble0 = []
WhammyWibble1 = []

overlapping_starpower = 1

script star_power_reset
	Change StructureName = <player_status> star_power_amount = 0.0
	Change StructureName = <player_status> star_power_sequence = 0
	Change StructureName = <player_status> star_power_note_count = 0
	Change StructureName = <player_status> star_power_used = 0
	Change StructureName = <player_status> current_star_array_entry = 0
endscript

script increase_star_power\{amount = 10.0 player_status = player1_status}
	if ($game_mode = p2_career || $game_mode = p2_coop)
		//printf \{"giving star power to both players"} // annoying
		increase_star_power_guts amount = <amount> player_status = player1_status
		increase_star_power_guts amount = <amount> player_status = player2_status
	else
		increase_star_power_guts amount = <amount> player_status = <player_status>
	endif
endscript

script increase_star_power_guts
	if ($game_mode = p2_battle || $boss_battle = 1)
		return
	endif
	if ($<player_status>.star_power_used = 1 && $overlapping_starpower = 0)
		return
	endif
	old_amount = ($<player_status>.star_power_amount)
	Change StructureName = <player_status> star_power_amount = ($<player_status>.star_power_amount + <amount>)
	if ($<player_status>.star_power_amount > 100)
		Change StructureName = <player_status> star_power_amount = 100
	endif
	if ($<player_status>.star_power_used = 0 && <old_amount> < 50.0)
		if ($<player_status>.star_power_amount >= 50.0)
			spawnscriptnow show_star_power_ready params = {player_status = <player_status>}
		endif
	endif
endscript
star_power_ready_on_p1 = 0
star_power_ready_on_p2 = 0

script show_star_power_ready
	if ($Cheat_PerformanceMode = 1)
		return
	endif
	if ($game_mode = p2_career || $game_mode = p2_coop)
		<player_status> = player1_status
	endif
	SoundEvent \{event = Star_Power_Ready_SFX}
	spawnscriptnow rock_meter_star_power_on params = {player_status = <player_status>}
	FormatText checksumName = player_container 'HUD_Note_Streak_Combo%d' d = ($<player_status>.Player)
	begin
		if NOT ScreenElementExists id = <player_container>
			break
		endif
		wait \{1 gameframe}
	repeat
	if ($<player_status>.Player = 1)
		if ($star_power_ready_on_p1 = 1)
			return
		else
			Change \{star_power_ready_on_p1 = 1}
		endif
	else
		if ($star_power_ready_on_p2 = 1)
			return
		else
			Change \{star_power_ready_on_p2 = 1}
		endif
	endif
	if ($<player_status>.star_power_used = 1)
		return
	endif
	ExtendCrc star_power_ready_text ($<player_status>.text) out = id
	if (($game_mode = p2_faceoff)|| ($game_mode = p2_pro_faceoff))
		offset = ((1.0, 0.0) * $x_offset_p2)
		if ($<player_status>.Player = 1)
			original_pos = (($hud_screen_elements [0].Pos) - (0.0, 50.00) - <offset>)
		else
			original_pos = (($hud_screen_elements [0].Pos) + (0.0, -50.0) + <offset>)
		endif
		base_scale = 0.8
		scale_big_mult = 1.2
	else
		if ($game_mode = p2_career || $game_mode = p2_coop)
			original_pos = (($hud_screen_elements [0].Pos) - (0.0, 60.0))
		else
			original_pos = (($hud_screen_elements [0].Pos) - (0.0, 20.0))
		endif
		base_scale = 1.2
		scale_big_mult = 1.5
	endif
	if ScreenElementExists id = <id>
		<id> ::DoMorph Pos = <original_pos> Scale = 4 rgba = $hud_notif_starpower1 alpha = 0 rot_angle = 3
	endif
	ExtendCrc hud_destroygroup_window ($<player_status>.text)out = hud_destroygroup
	spawnscriptnow hud_lightning_alert params = {Player = ($<player_status>.Player) alert_id = <id> player_container = <hud_destroygroup>}
	if ScreenElementExists id = <id>
		<id> ::DoMorph Pos = <original_pos> Scale = <base_scale> alpha = 1 time = 0.3 rot_angle = -3 motion = ease_in
	endif
	if ScreenElementExists id = <id>
		<id> ::DoMorph Pos = <original_pos> Scale = (<base_scale> * <scale_big_mult>)time = 0.3 rot_angle = 4 motion = ease_out
	endif
	if ScreenElementExists id = <id>
		<id> ::DoMorph Pos = <original_pos> Scale = <base_scale> time = 0.3 rot_angle = -5 rgba = $hud_notif_starpower2 motion = ease_in
	endif
	rotation = 10
	begin
		<rotation> = (<rotation> * -0.7)
		if ScreenElementExists id = <id>
			<id> ::DoMorph Pos = <original_pos> rot_angle = <rotation> alpha = 1 time = 0.08 motion = ease_out
		endif
	repeat 12
	if ScreenElementExists id = <id>
		<id> ::DoMorph Pos = <original_pos> rot_angle = 0 motion = ease_out
	endif
	if ScreenElementExists id = <id>
		<id> ::DoMorph Pos = (<original_pos> - (0.0, 230.0))Scale = (<base_scale> * 0.5)alpha = 0 time = 0.3 motion = ease_in
	endif
	if ($<player_status>.Player = 1)
		Change \{star_power_ready_on_p1 = 0}
	else
		Change \{star_power_ready_on_p2 = 0}
	endif
endscript
showing_raise_axe = 0

script show_coop_raise_axe_for_starpower
	if ($<player_status>.bot_play = 1 && $<player_status>.star_power_used = 0)
		player = 1
		begin
			formattext checksumname = p 'player%d_status' d = <player>
			if ($<p>.star_power_used = 0)
				printstruct <...>
				spawnscriptnow star_power_activate_and_drain params = {
					player_status = <p>
					Player = <player>
					player_text = ($<p>.text)
				}
				player = (<player> + 1)
			endif
		repeat $current_num_players
		return
	endif
	if ($<player_status>.star_power_used = 1 || $<player_status>.bot_play = 1 ||
		$is_attract_mode = 1 || $showing_raise_axe = 1 || $Cheat_PerformanceMode = 1 || $playing_song = 0)
		return
	endif
	Change \{showing_raise_axe = 1}
	ExtendCrc coop_raise_axe ($<player_status>.text)out = id
	ExtendCrc coop_raise_axe_cont ($<player_status>.text)out = id_cont
	offset = ((1.0, 0.0) * $x_offset_p2)
	if ($<player_status>.Player = 1)
		original_pos = (($hud_screen_elements [3].Pos) - (0.0, 60.0) - <offset>)
		original_pos_cont = (($hud_screen_elements [3].Pos) - (0.0, 30.0) - <offset>)
	else
		original_pos = (($hud_screen_elements [3].Pos) + (0.0, -60.0) + <offset>)
		original_pos_cont = (($hud_screen_elements [3].Pos) + (0.0, -30.0) + <offset>)
	endif
	base_scale = 0.7
	base_scale_cont = 1
	if ScreenElementExists id = <id>
		DoScreenElementMorph {
			id = <id>
			Pos = <original_pos>
			Scale = 0
			alpha = 1
		}
	endif
	if ScreenElementExists id = <id_cont>
		DoScreenElementMorph {
			id = <id_cont>
			Pos = <original_pos_cont>
			Scale = 0
			alpha = 1
		}
	endif
	if ScreenElementExists id = <id>
		DoScreenElementMorph id = <id> Scale = <base_scale> time = 0.2
	endif
	if ScreenElementExists id = <id_cont>
		DoScreenElementMorph id = <id_cont> Scale = <base_scale_cont> time = 0.2
	endif
	wait \{0.2 seconds}
	if NOT ScreenElementExists id = <id>
		Change \{showing_raise_axe = 0}
		return
	endif
	rotation = 4
	begin
		<rotation> = (<rotation> * -1)
		if ScreenElementExists id = <id>
			DoScreenElementMorph {
				id = <id>
				rot_angle = <rotation>
				time = 0.1
			}
		endif
		if ScreenElementExists id = <id_cont>
			DoScreenElementMorph {
				id = <id_cont>
				rot_angle = <rotation>
				time = 0.1
			}
		endif
		wait \{0.13 seconds}
		if NOT ScreenElementExists id = <id>
			Change \{showing_raise_axe = 0}
			return
		endif
	repeat 8
	if ScreenElementExists id = <id>
		DoScreenElementMorph id = <id> rot_angle = 0
	endif
	if ScreenElementExists id = <id_cont>
		DoScreenElementMorph id = <id_cont> rot_angle = 0
	endif
	if ScreenElementExists id = <id>
		DoScreenElementMorph {
			id = <id>
			Pos = (<original_pos> - (0.0, 400.0))
			Scale = (<base_scale> * 0.5)
			time = 0.35
		}
	endif
	if ScreenElementExists id = <id_cont>
		DoScreenElementMorph {
			id = <id_cont>
			Pos = (<original_pos_cont> - (0.0, 400.0))
			Scale = (<base_scale_cont> * 0.5)
			time = 0.35
		}
	endif
	Change \{showing_raise_axe = 0}
endscript

script star_power_hit_note
	increase_star_power amount = $star_power_hit_note_score player_status = <player_status>
	Change StructureName = <player_status> star_power_note_count = ($<player_status>.star_power_note_count + 1)
	Change StructureName = <player_status> star_power_sequence = ($<player_status>.star_power_sequence + 1)
	broadcastevent Type = star_hit_note data = {song = <song> array_entry = <array_entry> player_status = <player_status>}
	printf "star note hit: %s required %r" s = ($<player_status>.star_power_sequence)r = <sequence_count>
	if (<sequence_count> = $<player_status>.star_power_sequence)
		if ($<player_status>.star_power_sequence > $star_power_sequence_min)
			if ($<player_status>.star_power_used = 0)
				printf \{channel = training "broadcasting star power bonus!!!!!!!!!!!"}
				broadcastevent Type = star_sequence_bonus data = {song = <song> array_entry = <array_entry>}
				increase_star_power amount = $star_power_sequence_bonus player_status = <player_status>
			endif
		endif
	endif
endscript

script reset_star_sequence
	Change StructureName = <player_status> star_power_sequence = 0
	Change StructureName = <player_status> star_power_note_count = 0
endscript

script star_power_miss_note
	// WHY ISN'T THIS GETTING CALLED!!!!!!!
	// THERE'S A GLITCH WHERE YOU CAN STRUM
	// MISS AND THE SEQUENCE WON'T GO AWAY!!!!!
	Change StructureName = <player_status> star_power_sequence = 0
	LaunchGemEvent event = star_miss_note Player = <Player>
	ExtendCrc star_miss_note <player_text> out = id
	broadcastevent Type = <id> data = {song = <song> array_entry = <array_entry>}
endscript

script star_power_whammy
	if ($<player_status>.star_power_used = 1 & $overlapping_starpower = 0)
		return
	endif
	last_x = 0
	last_y = 0
	dir_x = 1
	dir_y = 1
	first = 1
	xtolerance = 0.03
	whammy_on_time = 0.0
	whammy_off_time = 0.0
	whammy_time = 83.3333333
	whammy_on = 0.0
	whammy_star_on = 0
	whammy_star_off = 0
	ExtendCrc star_whammy_on <player_text> out = id
	broadcastevent Type = <id> data = {pattern = <pattern> time = <time> guitar_stream = <guitar_stream> song = <song> array_entry = <array_entry> Player = <Player> player_status = <player_status> player_text = <player_text>}
	<boss> = 0
	if ($boss_battle = 1)
		if (($<player_status>.Player)= 2)
			<boss> = 1
		endif
	endif
	<do_blue_whammys> = 1
	if ($game_mode = p2_battle || $boss_battle = 1)
		<do_blue_whammys> = 0
	endif
	begin
		if (($<player_status>.whammy_on)= 0)
			ExtendCrc star_whammy_off <player_text> out = id
			broadcastevent Type = <id> data = {pattern = <pattern> time = <time> guitar_stream = <guitar_stream> song = <song> array_entry = <array_entry> Player = <Player> player_status = <player_status> player_text = <player_text> finished = 0}
			break
		endif
		if (<boss> = 0)
			if GuitarGetAnalogueInfo controller = ($<player_status>.controller)
				if IsGuitarController controller = ($<player_status>.controller)
					<px> = ((<rightx> - $<player_status>.resting_whammy_position)/ (1.0 - $<player_status>.resting_whammy_position))
					if (<px> < 0)
						<px> = 0
					endif
					if (<first> = 1)
						<last_x> = <px>
						<first> = 0
					endif
					<xdiff> = (<px> - <last_x>)
					if (<xdiff> < 0)
						<xdiff> = (0.0 - <xdiff>)
					endif
					if (<xdiff> > <xtolerance>)
						<whammy_on> = <whammy_time>
						time2 = <time>
						getsongtime
						whammy_on_time = <time>
						time = <time2>
					endif
				else
					<px> = 0
					<py> = 0
					if (<leftlength> > 0)
						<px> = <leftx>
						<py> = <lefty>
					else
						if (<rightlength> > 0)
							<px> = <rightx>
							<py> = <righty>
						endif
					endif
					if (<first> = 1)
						<last_x> = <px>
						<last_y> = <py>
						<first> = 0
					endif
					<xdiff> = (<px> - <last_x>)
					if (<xdiff> < 0)
						<xdiff> = (0.0 - <xdiff>)
					endif
					<ydiff> = (<py> - <last_y>)
					if (<ydiff> < 0)
						<ydiff> = (0.0 - <ydiff>)
					endif
					if (<xdiff> > <xtolerance>)
						<whammy_on> = <whammy_time>
						time2 = <time>
						getsongtime
						whammy_on_time = <time>
						time = <time2>
					endif
					if (<ydiff> > <xtolerance>)
						<whammy_on> = <whammy_time>
						time2 = <time>
						getsongtime
						whammy_on_time = <time>
						time = <time2>
					endif
				endif
				if (($<player_status>.bot_play) = 1)
					whammy_on = <whammy_time>
				endif
				if (<whammy_on> > 0.0)
					<whammy_star_off> = 0
					<whammy_star_on> = (<whammy_star_on> + 1)
					beat_time = ($<player_status>.playline_song_beat_time / 1000.0)
					beat_ratio = ($current_deltatime / <beat_time>)
					if ($game_mode = p2_career || $game_mode = p2_coop)
						increase_star_power amount = ($star_power_whammy_add_coop * <beat_ratio>)player_status = <player_status>
					else
						increase_star_power amount = ($star_power_whammy_add * <beat_ratio>)player_status = <player_status>
					endif
					time2 = <time>
					getsongtime
					whammy_off_time = <time>
					time = <time2>
					whammy_on = (<whammy_time> - (<whammy_on_time> - <whammy_off_time>))
					if (<do_blue_whammys> = 1)
						if (<whammy_star_on> = 5)
							GetArraySize $gem_colors
							gem_count = 0
							begin
								if ((<pattern> & $button_values [<gem_count>])= $button_values [<gem_count>])
									FormatText checksumName = whammy_id '%c_%i_whammybar_p%p' c = ($gem_colors_text [<gem_count>])i = <array_entry> p = ($<player_status>.Player)AddToStringLookup = true
									if ScreenElementExists id = <whammy_id>
										bar_name = (<whammy_id> + 1)
										MakeStarWhammy name = <bar_name> Player = ($<player_status>.Player)
									endif
								endif
								gem_count = (<gem_count> + 1)
							repeat <array_Size>
						endif
					endif
				else
					<whammy_star_on> = 0
					<whammy_star_off> = (<whammy_star_off> + 1)
					if (<do_blue_whammys> = 1)
						if (<whammy_star_off> = 5)
							GetArraySize $gem_colors
							gem_count = 0
							begin
								if ((<pattern> & $button_values [<gem_count>])= $button_values [<gem_count>])
									FormatText checksumName = whammy_id '%c_%i_whammybar_p%p' c = ($gem_colors_text [<gem_count>])i = <array_entry> p = ($<player_status>.Player)AddToStringLookup = true
									if ScreenElementExists id = <whammy_id>
										bar_name = (<whammy_id> + 1)
										MakeNormalWhammy name = <bar_name> Player = ($<player_status>.Player)
									endif
								endif
								gem_count = (<gem_count> + 1)
							repeat <array_Size>
						endif
					endif
				endif
				<last_x> = <px>
				<last_y> = <py>
			endif
		endif
		<time> = (<time> - ($current_deltatime * 1000))
		if (<time> <= 0)
			ExtendCrc star_whammy_off <player_text> out = id
			broadcastevent Type = <id> data = {pattern = <pattern> time = <time> guitar_stream = <guitar_stream> song = <song> array_entry = <array_entry> Player = <Player> player_status = <player_status> player_text = <player_text> finished = 1}
			break
		endif
		wait 1 gameframe
	repeat
endscript

script reset_star_array
	get_song_struct song = <song_name>
	if (($<player_status>.part)= rhythm)
		<part> = 'rhythm_'
	else
		<part> = ''
	endif
	if ($game_mode = p2_career || $game_mode = p2_coop ||
		($game_mode = training & ($<player_status>.part = rhythm)))
		if StructureContains structure = <song_struct> use_coop_notetracks
			if (($<player_status>.part)= rhythm)
				<part> = 'rhythmcoop_'
			else
				<part> = 'guitarcoop_'
			endif
		endif
	endif
	get_difficulty_text_nl difficulty = <difficulty>
	key_parts = [ '_' '' '' '_star' ]
	SetArrayElement arrayname=key_parts index=1 newvalue=<part> // wtf
	SetArrayElement arrayname=key_parts index=2 newvalue=<difficulty_text_nl>
	GetArraySize \{key_parts}
	song = ($current_song)
	i = 0
	begin
		ExtendCrc <song> (<key_parts>[<i>]) out=song
		Increment i
	repeat <array_size>
	if ($game_mode = p2_battle ||
		$boss_battle = 1)
		ExtendCrc <song> 'battlemode' out=song
		Change StructureName = <player_status> sp_phrases_total = 0
	endif
	Change StructureName = <player_status> current_song_star_array = <song>
	Change StructureName = <player_status> current_star_array_entry = 0
endscript

script is_star_note\{time = 0}
	star_array = ($<player_status>.current_song_star_array)
	GetArraySize $<star_array>
	if (<array_Size> = 0)
		return \{FALSE star_count = 0}
	endif
	star_start =  ($<star_array>[($<player_status>.current_star_array_entry)][0])
	star_end   = (($<star_array>[($<player_status>.current_star_array_entry)][1]) + <star_start>)
	star_count =  ($<star_array>[($<player_status>.current_star_array_entry)][2])
	if (<time> >= <star_start>)
		if (<time> <= <star_end>)
			return true star_count = <star_count>
		endif
	endif
	if (<time> > <star_end>)
		if ($<player_status>.current_star_array_entry < (<array_Size> - 1))
			Change StructureName = <player_status> current_star_array_entry = ($<player_status>.current_star_array_entry + 1)
		endif
	endif
	return FALSE star_count = <star_count>
endscript

script Do_StarPower_Camera
	// called internally
endscript
using_starpower_camera = FALSE
