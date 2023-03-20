
script net_setup_solo_hud
	GetArraySize \{$#"0xc3fc0bc3"}
	array_entry = 0
	get_num_players_by_gamemode
	begin
		id = ($hud_screen_elements [<array_entry>].id)
		ExtendCrc <id> ($player2_status.text)out = id
		Pos = ($hud_screen_elements [<array_entry>].Pos)
		yoff = ($hud_screen_elements [<array_entry>].yoff)
		if (<num_players> = 2)
			px = (<Pos>.(1.0, 0.0))
			py = (<Pos>.(0.0, 1.0))
			px = (<px> * 0.4 + 640)
			py = (<py> - <yoff>)
			Pos = (<px> * (1.0, 0.0) + <py> * (0.0, 1.0))
		endif
		CreateScreenElement {
			Type = TextElement
			parent = <hud_destroygroup>
			font = #"0xdbce7067"
			just = [left top]
			Scale = 1.0
			rgba = [210 210 210 250]
			z_priority = 80.0
			($hud_screen_elements [<array_entry>])
			Pos = <Pos>
			id = <id>
		}
		array_entry = (<array_entry> + 1)
	repeat <array_Size>
	reset_hud_text player_text = ($player2_status.text)
	if ($game_mode = p2_career)
		Change \{g_hud_2d_struct_used = career_hud_2d_elements}
	elseif ($game_mode = p2_faceoff || $game_mode = p2_pro_faceoff)
		Change \{g_hud_2d_struct_used = net_faceoff_hud_2d_elements_solo}
	elseif ($game_mode = p2_battle || ($boss_battle = 1))
		Change \{g_hud_2d_struct_used = net_battle_hud_2d_elements_solo}
	else
		Change \{g_hud_2d_struct_used = career_hud_2d_elements}
	endif
	ExtendCrc HUD_2D_Container ($<player_status>.text)out = new_2d_container
	if NOT ScreenElementExists id = <new_2d_container>
		CreateScreenElement {
			Type = ContainerElement
			parent = root_window
			Pos = (0.0, 0.0)
			just = [left top]
			id = <new_2d_container>
			Scale = (($g_hud_2d_struct_used).Scale)
		}
	endif
	create_2d_hud_elements parent = <new_2d_container> player_text = ($<player_status>.text)elements_structure = $g_hud_2d_struct_used
	ExtendCrc \{HUD_2D_Container 'p2' out = new_2d_container}
	if NOT ScreenElementExists id = <new_2d_container>
		CreateScreenElement {
			Type = ContainerElement
			parent = root_window
			Pos = (0.0, 0.0)
			just = [left top]
			id = <new_2d_container>
			Scale = (($g_hud_2d_struct_used).Scale)
		}
	endif
	create_2d_hud_elements parent = <new_2d_container> player_text = 'p2' elements_structure = $g_hud_2d_struct_used
endscript
