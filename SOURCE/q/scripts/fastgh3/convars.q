

manual = {}
script decompress_help
	change manual = {
		help = {
			'Find help about a convar/concommand.'
			params = [ { 'script' } ]
			name = 'help'
		}
		give = {
			'Give item to player.'
			params = [
				{ item name = #"0x00000000" }
				{ player name = player }
			]
			name = 'give'
		}
		fps = {
			'Frame rate limiter.'
			//params = [ { fps } ]
			name = 'fps'
			cvar = fps_max
		}
		sv_speed = {
			'Change speed of the song.'
			params = [ { speed } ]
			name = 'sv_speed'
			cvar = current_speedfactor
		}
	}
endscript
script help
	if NOT GotParam \{#"0x00000000"}
		help \{help}
		return
	endif
	if NOT ScriptExists <#"0x00000000">
		printf 'Script does not exist.'
		return
	endif
	if NOT StructureContains structure=($manual) <#"0x00000000">
		printf 'Script does not have information.'
		return
	endif
	info = ($manual.<#"0x00000000">)
	if StructureContains \{structure=info name}
		name = (<info>.name)
	else
		name = <#"0x00000000">
	endif
	if StructureContains \{structure=info cvar}
		formattext textname = helptext "%s = (%v)" s = (<info>.name) v = (<info>.cvar) // wtf, old syntax moment
	else
		formattext textname = helptext "%n" n = <name>
		params = (<info>.params)
		GetArraySize <params>
		i = 0
		begin
			param = (<params>[<i>])
			if StructureContains \{structure=param name}
				if NOT (<param>.name = #"0x00000000")
					formattext textname = helptext "%s %p =" s = <helptext> p = (<param>.name)
				endif
			endif
			formattext textname = helptext "%s <%p>" s = <helptext> p = (<param>.#"0x00000000")
			Increment \{i}
		repeat <array_size>
	endif
	printf "%h" h = <helptext>
	printf " - %s" s = (<info>.#"0x00000000")
endscript

// console command like
script give \{player = 1}
	if NOT GotParam \{#"0x00000000"}
		help \{give}
		return
	endif
	if (<player> = 2)
		player_status = player2_status
	else
		player_status = player1_status
	endif
	switch <#"0x00000000">
		case health
			//begin
			//	IncreaseCrowd player_status=<player_status>
			//repeat 10
			Change StructureName = <player_status> current_health = ($<player_status>.current_health + 0.5)
			if ($<player_status>.current_health > 2.0)
				Change StructureName = <player_status> current_health = 2.0
			endif
			return
	endswitch
	if NOT ($game_mode = p2_battle)
		switch <#"0x00000000">
			case starpower
				increase_star_power amount = 50.0 player_status = <player_status>
				return
		endswitch
	else
		params = { player_status = <player_status> battle_text = 1 }
		switch <#"0x00000000">
			case starpower
				battlemode_ready { battle_gem = 8 <params> }
				return
			case lightning
				battlemode_ready { battle_gem = 0 <params> }
				return
			case difficulty
				battlemode_ready { battle_gem = 1 <params> }
				return
			case double
				battlemode_ready { battle_gem = 2 <params> }
				return
			case steal
				battlemode_ready { battle_gem = 3 <params> }
				return
			case lefty
				battlemode_ready { battle_gem = 4 <params> }
				return
			case string
				battlemode_ready { battle_gem = 5 <params> }
				return
			case whammy
				battlemode_ready { battle_gem = 6 <params> }
				return
			case deth
				battlemode_ready { battle_gem = 7 <params> }
				return
		endswitch
	endif
	printf 'unknown item: %i' i = <#"0x00000000">
endscript

script fps
	if NOT GotParam \{#"0x00000000"}
		help \{fps}
		return
	endif
	change fps_max = <#"0x00000000">
endscript

script sv_speed
	if NOT GotParam \{#"0x00000000"}
		help \{sv_speed}
		return
	endif
	change current_speedfactor = <#"0x00000000">
	update_slomo
endscript

script sv_mode \{players = 0}
	if NOT GotParam \{#"0x00000000"}
		help \{sv_mode}
		return
	endif
	restore_start_key_binding
	switch <#"0x00000000">
		case 1
			#"0x00000000" = training
		//case 2 // CRASHING AGAIN
		//	#"0x00000000" = p2_coop
		case 3
			#"0x00000000" = p2_faceoff
		case 4
			#"0x00000000" = p2_pro_faceoff
		case p1_career
		case training
		//case p2_coop
		//case p2_career
		case p2_faceoff
		case p2_pro_faceoff
		case p1_quickplay
		case p2_battle
			EmptyScript
		case 0
		default
			#"0x00000000" = p1_quickplay
	endswitch
	printstruct <...>
	change game_mode = <#"0x00000000">
	got_players = 0
	if NOT (<players> < 1 & <players> > 2)
		got_players = 1
	endif
	if (<got_players> = 0)
		switch $game_mode
			//case p2_coop
			//case p2_career
			case p2_faceoff
			case p2_battle
				players = 2
			case training
			case p1_quickplay
			case p1_career
			default
				players = 1
		endswitch
	endif
	change current_num_players = (<players> + 1)
	restart_song
endscript

script xy \{x=0 y=0}
	return pair = (((1.0, 0.0) * <x>) + ((0.0, 1.0) * <y>))
endscript

script #"draw base" \{x=640 y=360 just=[center center] parent=root_window alpha=1 scale=1.0}
	if GotParam \{w}
		if GotParam \{h}
			xy x = <w> y = <h>
		endif
	endif
	if GotParam \{pair}
		dims = <pair>
		RemoveComponent \{pair}
	endif
	if GotParam \{x}
		if GotParam \{y}
			xy x = <x> y = <y>
		endif
	endif
	RemoveComponent \{x}
	RemoveComponent \{y}
	CreateScreenElement {
		type = <type>
		font = <font>
		pos = <pair>
		just = <just>
		text = <text>
		id = <id>
		parent = <parent>
		dims = <dims>
		scale = <scale>
		alpha = <alpha>
		texture = <texture>
		material = <material>
		z_priority = <z>
		rot_angle = <angle>
	}
	printf 'The id for this text element is %s' s = <id>
endscript

script drawtext \{font=fontgrid_title_gh3 text='Hello, world!' id=mytext}
	#"draw base" type = textelement <...>
endscript

script drawsprite \{id=mysprite}
	if NOT GotParam \{texture}
		if NOT GotParam \{material}
			texture = sprite_missing
		endif
	endif
	printstruct <...>
	#"draw base" type = spriteelement <...>
endscript

script killelement
	if ScreenElementExists id = <id>
		DestroyScreenElement <...>
	endif
endscript


