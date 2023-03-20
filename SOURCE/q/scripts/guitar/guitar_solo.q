
script solo\{part = guitar diff = expert}
	if ($game_mode = p2_battle || $#"0x6e482dae" = 0)
		return
	endif
	get_song_prefix song = ($current_song)
	FormatText checksumName = scripts_name '%d_scripts' d = <song_prefix>
	scripts = $<scripts_name>
	GetArraySize <scripts>
	k = 0
	#"0x0f46f6ae" = 0
	begin
		Scr = (<scripts> [<k>])
		if ((<Scr>.time + 40)>= (<time>)& (<Scr>.time)< (<time>)& (<Scr>.Scr)= solo)
			part2 = guitar
			#"0xa46b4bd5" = expert
			if (StructureContains structure = <Scr> params)
				tmpval = (<Scr>.params)
				if (StructureContains structure = <tmpval> part)
					part2 = (<tmpval>.part)
				endif
				if (StructureContains structure = <tmpval> diff)
					diff = (<tmpval>.diff)
				endif
			endif
			if (checksumequals a = <part> b = <part2>)
				if (checksumequals a = <diff> b = <#"0xa46b4bd5">)
					time = (<Scr>.time)
					#"0x0f46f6ae" = 1
					break
				endif
			endif
		endif
		k = (<k> + 1)
		if (<k> >= <array_Size>)
			return
		endif
	repeat (<array_Size>)
	if (<#"0x0f46f6ae"> = 0)
		printf 'why'
	endif
	k = (<k> + 1)
	found_soloend = 0
	endtime = (<time> + 5000)
	begin
		Scr = (<scripts> [<k>])
		if (<Scr>.time >= <time> & <Scr>.Scr = soloend)
			part2 = guitar
			#"0xa46b4bd5" = expert
			if (StructureContains structure = <Scr> params)
				tmpval = (<Scr>.params)
				if (StructureContains structure = <tmpval> part)
					part2 = (<tmpval>.part)
				endif
				if (StructureContains structure = <tmpval> diff)
					#"0xa46b4bd5" = (<tmpval>.diff)
				endif
			endif
			if (<part> = <part2>)
				if (<diff> = <#"0xa46b4bd5">)
					endtime = (<Scr>.time)
					found_soloend = 1
					break
				endif
			endif
		endif
		k = (<k> + 1)
		if (<k> >= <array_Size>)
			break
		endif
	repeat (<array_Size>)
	if (<found_soloend> = 0)
		printf 'why'
		return
	endif
	i = 1
	begin
		FormatText checksumName = player_status 'player%d_status' d = <i>
		if (<i> = 1)
			#"0x1b31142d" = current_difficulty
		elseif (<i> = 2)
			#"0x1b31142d" = current_difficulty2
		endif
		if (<part> = ($<player_status>.part)& <diff> = ($<#"0x1b31142d">))
			gemarrayid = ($<player_status>.current_song_gem_array)
			song_array = $<gemarrayid>
			GetArraySize song_array
			solo_first_note = 0
			begin
				if (<song_array> [<solo_first_note>] >= <time>)
					break
				endif
				solo_first_note = (<solo_first_note> + 3)
			repeat (<array_Size>)
			if (<i> = 1)
				Change last_solo_index_p1 = 0
				note_index = $note_index_p1
			elseif (<i> = 2)
				Change last_solo_index_p2 = 0
				note_index = $note_index_p2
			endif
			note_index = (<note_index> * 3)
			current_first_note = 0
			startTime = $current_starttime
			begin
				if (<song_array> [<current_first_note>] >= <startTime>)
					break
				endif
				current_first_note = (<current_first_note> + 3)
			repeat (<array_Size>)
			note_index = (<note_index> + <current_first_note> + 3)
			earlyhits = ((<note_index> - <solo_first_note>)/ 3)
			if (<i> = 1)
				hit_buffer = $solo_hit_buffer_p1
			elseif (<i> = 2)
				hit_buffer = $solo_hit_buffer_p2
			endif
			GetArraySize <hit_buffer>
			j = 0
			jj = 0
			if (<earlyhits> > 0)
				begin
					if (<hit_buffer> [(<array_Size> - 1)] = 1 & <song_array> [(<note_index> - (<jj> * 3))] >= <time>)
						j = (<j> + 1)
					endif
					jj = (<jj> + 1)
				repeat (<earlyhits>)
			endif
			k = 0
			GetArraySize song_array
			k = <solo_first_note>
			begin
				if (<song_array> [<k>] >= (<endtime>)|| <k> > <array_Size>)
					break
				endif
				k = (<k> + 3)
			repeat (((<array_Size> - <k>)/ 3))
			k = (<k> - <solo_first_note>)
			k = (<k> / 3)
			if (<i> = 1)
				Change solo_active_p1 = 1
				Change last_solo_hits_p1 = <j>
				Change last_solo_index_p1 = <j>
				Change last_solo_total_p1 = <k>
			elseif (<i> = 2)
				Change solo_active_p2 = 1
				Change last_solo_hits_p2 = <j>
				Change last_solo_index_p2 = <j>
				Change last_solo_total_p2 = <k>
			endif
			solo_ui_create Player = <i>
		endif
		i = (<i> + 1)
	repeat ($current_num_players)
endscript

script soloend\{part = guitar diff = expert}
	if ($game_mode = p2_battle || $#"0x6e482dae" = 0)
		return
	endif
	i = 1
	begin
		FormatText checksumName = player_status 'player%d_status' d = <i>
		if (<i> = 1)
			#"0x1b31142d" = current_difficulty
		elseif (<i> = 2)
			#"0x1b31142d" = current_difficulty2
		endif
		if (<part> = ($<player_status>.part)& <diff> = ($<#"0x1b31142d">))
			begin
				if (<i> = 1)
					if ($last_solo_index_p1 >= $last_solo_total_p1 || $solo_active_p1 = 0)
						break
					endif
				elseif (<i> = 2)
					if ($last_solo_index_p2 >= $last_solo_total_p2 || $solo_active_p2 = 0)
						break
					endif
				endif
				printf 'waiting for something to happen to the last few notes'
				wait 1 gameframe
			repeat
			if (<i> = 1)
				num = ($player1_status.score + ($last_solo_hits_p1 * $solo_bonus_pts))
				Change StructureName = player1_status score = <num>
				num1 = $last_solo_hits_p1
				num2 = $last_solo_total_p1
				spawnscriptnow solo_ui_end params = {
					Player = 1
				}
				Change last_solo_hits_p1 = 0
				Change last_solo_total_p1 = 0
			elseif (<i> = 2)
				num = ($player2_status.score + ($last_solo_hits_p2 * $solo_bonus_pts))
				Change StructureName = player2_status score = <num>
				num1 = $last_solo_hits_p2
				num2 = $last_solo_total_p2
				spawnscriptnow solo_ui_end params = {
					Player = 2
				}
				Change last_solo_hits_p2 = 0
				Change last_solo_total_p2 = 0
			endif
			solo_reset i = <i>
		endif
		i = (<i> + 1)
	repeat ($current_num_players)
endscript
#"0x56b9781b" = $#"0xf0fffbee"
#"0xe63b3ef1" = $#"0x868bc002"

script solo_ui_create\{Player = 1}
	FormatText checksumName = lsh_p 'last_solo_hits_p%d' d = <Player>
	FormatText checksumName = lst_p 'last_solo_total_p%d' d = <Player>
	num = ((100 * $<lsh_p>)/ $<lst_p>)
	FormatText textname = text '%d\%' d = <num>
	FormatText checksumName = solotxt 'solotxt%d' d = <Player>
	FormatText checksumName = gemcont 'gem_containerp%d' d = <Player>
	if (ScreenElementExists {
			id = <solotxt>
		})
		DestroyScreenElement {
			id = <solotxt>
		}
		killspawnedscript name = solo_ui_end
	endif
	CreateScreenElement {
		Type = TextElement
		parent = <gemcont>
		id = <solotxt>
		font = fontgrid_title_gh3
		Scale = 0.8
		rgba = [255 , 255 , 255 , 255]
		text = <text>
		just = [center , center]
		z_priority = 20
		Pos = (640.0, 296.0)
	}
endscript

script solo_ui_update\{Player = 1}
	FormatText checksumName = solotxt 'solotxt%d' d = <Player>
	FormatText checksumName = lsh_p 'last_solo_hits_p%d' d = <Player>
	FormatText checksumName = lst_p 'last_solo_total_p%d' d = <Player>
	FormatText checksumName = lsi_p 'last_solo_index_p%d' d = <Player>
	if (ScreenElementExists {
			id = <solotxt>
		})
		if ($solo_display_type = 0)
			num = ((100.0 * $<lsh_p>)/ $<lst_p>)
			MathFloor <num>
			FormatText textname = text '%d\%' d = <floor>
			Scale = (0.8 + (<num> / 100.0 / 2))
		else
			fractional = ($<lsh_p>)
			denum = ($<lst_p>)
			index = ($<lsi_p>)
			num = ((100.0 * <fractional>)/ <denum>)
			Scale = (0.8 + (<num> / 100.0 / 2))
			FormatText textname = text '%d / %e, %f / %e' d = <fractional> e = <denum> f = <index>
		endif
		SetScreenElementProps id = <solotxt> text = <text> Scale = 1.1
		DoScreenElementMorph id = <solotxt> Scale = <Scale> relative_scale
		DoScreenElementMorph id = <solotxt> time = 0.08 Scale = 0.9
		DoScreenElementMorph id = <solotxt> time = 0.08 Scale = <Scale> relative_scale
	endif
endscript

script solo_ui_end\{Player = 1}
	FormatText checksumName = solotxt 'solotxt%d' d = <Player>
	FormatText checksumName = lsh_p 'last_solo_hits_p%d' d = <Player>
	FormatText checksumName = lst_p 'last_solo_total_p%d' d = <Player>
	if (ScreenElementExists {
			id = <solotxt>
		})
		Bonus = ($<lsh_p> * $solo_bonus_pts)
		perf = ((100 * $<lsh_p>)/ $<lst_p>)
		DoScreenElementMorph id = <solotxt> time = 0.3 Scale = 1.8 relative_scale
		wait 1.5 seconds
		perf_text = 'BAD'
		if (<perf> <= 56)
			perf_text = 'POOR'
		elseif (<perf> <= 64)
			perf_text = 'OKAY'
		elseif (<perf> <= 76)
			perf_text = 'GOOD'
		elseif (<perf> <= 88)
			perf_text = 'GREAT'
		elseif (<perf> < 100)
			perf_text = 'AWESOME'
		elseif (<perf> >= 100)
			perf_text = 'PERFECT'
		endif
		FormatText textname = text '%t SOLO!' t = <perf_text>
		if (ScreenElementExists {
				id = <solotxt>
			})
			SetScreenElementProps id = <solotxt> text = <text>
			DoScreenElementMorph id = <solotxt> Scale = 0
			DoScreenElementMorph id = <solotxt> time = 0.1 Scale = 1
		endif
		wait 1.5 seconds
		FormatText textname = text '%d POINTS!' d = <Bonus>
		if (ScreenElementExists {
				id = <solotxt>
			})
			SetScreenElementProps id = <solotxt> text = <text>
			DoScreenElementMorph id = <solotxt> Scale = 0
			DoScreenElementMorph id = <solotxt> time = 0.1 Scale = 1
			wait 1.5 seconds
			DoScreenElementMorph id = <solotxt> time = 0.1 Scale = 0
		endif
		wait 0.1 seconds
		if (ScreenElementExists {
				id = <solotxt>
			})
			DestroyScreenElement {
				id = <solotxt>
			}
		endif
	endif
endscript

script solo_reset\{Player = 1}
	if (<Player> = 1)
		Change solo_active_p1 = 0
		Change last_solo_hits_p1 = 0
		Change last_solo_index_p1 = 0
		Change last_solo_total_p1 = 0
		Change note_index_p1 = 0
	elseif (<Player> = 2)
		Change solo_active_p2 = 0
		Change last_solo_hits_p2 = 0
		Change last_solo_index_p2 = 0
		Change last_solo_total_p2 = 0
		Change note_index_p2 = 0
	endif
	if (<Player> = 1)
		GetArraySize \{$#"0x39c33a22"}
	elseif (<Player> = 2)
		GetArraySize \{$#"0xa0ca6b98"}
	endif
	FormatText checksumName = array 'solo_hit_buffer_p%d' d = <Player>
	hit_buffer = $<array>
	i = 0
	begin
		SetArrayElement ArrayName = <array> GlobalArray index = <i> NewValue = 0
		i = (<i> + 1)
	repeat (<array_Size>)
	if (GotParam reset_hud)
		killspawnedscript name = solo_ui_end
		if (ScreenElementExists {
				id = <solotxt>
			})
			DestroyScreenElement {
				id = <solotxt>
			}
		endif
	endif
endscript

script set_solo_hit_buffer\{Player = 1 1}
	FormatText checksumName = array 'solo_hit_buffer_p%d' d = <Player>
	if (<Player> = 1)
		num = ($last_solo_index_p1 + 1)
		Change last_solo_index_p1 = <num>
		GetArraySize \{$#"0x39c33a22"}
	elseif (<Player> = 2)
		num = ($last_solo_index_p2 + 1)
		Change last_solo_index_p2 = <num>
		GetArraySize \{$#"0xa0ca6b98"}
	endif
	hit_buffer = $<array>
	i = 1
	SetArrayElement ArrayName = <array> GlobalArray index = (<array_Size> - 1)NewValue = <#"0x00000000">
	begin
		SetArrayElement ArrayName = <array> GlobalArray index = (<i> - 1)NewValue = ($<array> [<i>])
		i = (<i> + 1)
	repeat (<array_Size> - 1)
endscript
last_solo_hits_p1 = 0
last_solo_hits_p2 = 0
last_solo_total_p1 = 0
last_solo_total_p2 = 0
last_solo_index_p1 = 0
last_solo_index_p2 = 0
solo_active_p1 = 0
solo_active_p2 = 0
solo_bonus_pts = 50
solo_hit_buffer_p1 = [
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
]
solo_hit_buffer_p2 = [
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
	0
]
note_index_p1 = 0
note_index_p2 = 0
solo_display_type = 0
#"0x6e482dae" = 1
