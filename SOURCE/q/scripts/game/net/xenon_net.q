xboxlive_num_results = 0

script xboxlive_menu_optimatch_results_stop
	NetSessionFunc \{Obj = match func = stop_server_list}
	if GotParam \{xboxlive_num_results}
		xboxlive_menu_optimatch_results_end xboxlive_num_results = <xboxlive_num_results>
	else
		xboxlive_menu_optimatch_results_end \{xboxlive_num_results = 0}
	endif
endscript

script xboxlive_menu_optimatch_results_end
	destroy_server_list_searching_dialog
	if GotParam \{xboxlive_num_results}
		Change xboxlive_num_results = <xboxlive_num_results>
	endif
	printf "xboxlive_menu_optimatch_results_end : %d" d = ($xboxlive_num_results)
	if (($xboxlive_num_results)= 0)
		if CheckForSignIn
			if ScreenElementExists \{id = search_results_container}
				create_server_list_create_match_dialog
			else
				printf \{"our serverlist doesn't exist any more"}
			endif
		endif
	else
		SpawnScript \{xboxlive_menu_optimatch_results_wait_and_focus}
	endif
endscript

script xboxlive_menu_optimatch_results_wait_and_focus
	wait \{1 gameframes}
	set_focus_color rgba = ($online_dark_purple)
	set_unfocus_color rgba = ($online_light_blue)
	if ScreenElementExists \{id = search_results_vmenu}
		LaunchEvent \{Type = focus target = search_results_vmenu}
		SetScreenElementProps \{id = search_results_vmenu enable_pad_handling}
	endif
	if ScreenElementExists \{id = search_results_container}
		GetScreenElementChildren \{id = search_results_container}
		if GotParam \{children}
			GetArraySize \{children}
			i = 0
			begin
				if ScreenElementExists id = (<children> [<i>])
					(<children> [<i>])::GetTags
					if NOT GotParam \{highlight}
						(<children> [<i>])::SetProps preserve_flip alpha = 1.0
					endif
					<i> = (<i> + 1)
				endif
			repeat <array_Size>
		endif
	endif
endscript

script xboxlive_menu_optimatch_results_item_add
	printf \{"--- xboxlive_menu_optimatch_results_item_add"}
	printstruct <...>
	if (<num_players> < 2)
		Change xboxlive_num_results = (($xboxlive_num_results)+ 1)
		if NOT ScreenElementExists \{id = search_results_vmenu}
			printf \{"Warning! tried to add a server when results menu not up"}
			return
		endif
		translate_server_checksums_to_strings {
			game_mode_checksum = <game_mode>
			num_songs_checksum = <num_songs>
			difficulty_checksum = <difficulty>
		}
		if ($match_type = Ranked)
			<host_text> = "HOST"
		else
			<host_text> = <server_name>
		endif
		CreateScreenElement \{Type = ContainerElement parent = search_results_vmenu dims = (210.0, 30.0) Pos = (0.0, 0.0) just = [left top]}
		<container_element> = <id>
		<id> ::SetProps {
			event_handlers = [
				{focus serverlist_focus params = {parent = <id>}}
				{unfocus serverlist_unfocus params = {parent = <id>}}
				{pad_choose net_choose_server params = {id = <server_id>}}
			]
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = <container_element>
			local_id = highlight_bar
			texture = white
			dims = (625.0, 30.0)
			rgba = ($online_light_blue)
			Pos = (-4.0, 0.0)
			just = [left top]
			z_priority = 4
		}
		<id> ::SetTags highlight = 1
		<id> ::SetProps alpha = 0.0
		CreateScreenElement {
			Type = SpriteElement
			parent = <container_element>
			local_id = bookend_left
			texture = character_hub_hilite_bookend
			dims = (35.0, 35.0)
			rgba = ($online_light_blue)
			Pos = (-5.0, -3.0)
			just = [center top]
			z_priority = 4
		}
		<id> ::SetTags highlight = 1
		<id> ::SetProps alpha = 0.0
		CreateScreenElement {
			Type = SpriteElement
			parent = <container_element>
			local_id = bookend_right
			texture = character_hub_hilite_bookend
			dims = (35.0, 35.0)
			rgba = ($online_light_blue)
			Pos = (632.0, -3.0)
			just = [center top]
			z_priority = 4
		}
		<id> ::SetTags highlight = 1
		<id> ::SetProps alpha = 0.0
		CreateScreenElement {
			Type = TextElement
			parent = <container_element>
			font = text_a5
			local_id = server_name
			Scale = (0.75, 0.6500000357627869)
			rgba = ($online_light_blue)
			text = <host_text>
			just = [left top]
			internal_just = [left top]
			z_priority = 10.0
		}
		<server_entry_id> = <id>
		fit_text_into_menu_item id = <id> max_width = 200
		CreateScreenElement {
			Type = TextElement
			parent = <container_element>
			font = text_a5
			local_id = mode
			Scale = (0.75, 0.6500000357627869)
			rgba = ($online_light_blue)
			text = <game_mode_value>
			Pos = (220.0, 0.0)
			just = [left top]
			internal_just = [left top]
			z_priority = 10.0
		}
		fit_text_into_menu_item id = <id> max_width = 200
		CreateScreenElement {
			Type = TextElement
			parent = <container_element>
			font = text_a5
			local_id = songs
			Scale = (0.75, 0.6500000357627869)
			rgba = ($online_light_blue)
			text = <num_songs_value>
			Pos = (460.0, 0.0)
			just = [left top]
			internal_just = [left top]
			z_priority = 10.0
		}
		get_qos_color qos = <qos>
		CreateScreenElement {
			Type = SpriteElement
			parent = <container_element>
			local_id = signal_bar1
			texture = white
			Pos = (552.0, 26.5)
			dims = (7.5, 5.0)
			rgba = <Color>
			just = [left bottom]
			z_priority = 10.0
			alpha = 1.0
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = <container_element>
			local_id = signal_bar2
			texture = white
			Pos = (566.0, 26.5)
			dims = (7.5, 10.0)
			rgba = <Color>
			just = [left bottom]
			z_priority = 10.0
			alpha = 0.0
		}
		if (<qos> > 2.0)
			<id> ::SetProps alpha = 1.0
		endif
		CreateScreenElement {
			Type = SpriteElement
			parent = <container_element>
			local_id = signal_bar3
			texture = white
			Pos = (580.0, 26.5)
			dims = (7.5, 15.0)
			rgba = <Color>
			just = [left bottom]
			z_priority = 10.0
			alpha = 0.0
		}
		if (<qos> > 4.0)
			<id> ::SetProps alpha = 1.0
		endif
		CreateScreenElement {
			Type = SpriteElement
			parent = <container_element>
			local_id = signal_bar4
			texture = white
			Pos = (594.0, 26.5)
			dims = (7.5, 20.0)
			rgba = <Color>
			just = [left bottom]
			z_priority = 10.0
			alpha = 0.0
		}
		if (<qos> > 6.0)
			<id> ::SetProps alpha = 1.0
		endif
		CreateScreenElement {
			Type = SpriteElement
			parent = <container_element>
			local_id = signal_bar5
			texture = white
			Pos = (608.0, 26.5)
			dims = (7.5, 25.0)
			rgba = <Color>
			just = [left bottom]
			z_priority = 10.0
			alpha = 0.0
		}
		if (<qos> > 8)
			<id> ::SetProps alpha = 1.0
		endif
	endif
endscript

script translate_server_checksums_to_strings
	printstruct <...>
	if GotParam \{game_mode_checksum}
		switch (<game_mode_checksum>)
			case p2_battle
				<game_mode_value> = "BATTLE"
			case p2_faceoff
				<game_mode_value> = "FACE-OFF"
			case p2_pro_faceoff
				<game_mode_value> = "PRO FACE-OFF"
				if GotParam \{difficulty_checksum}
					switch (<difficulty_checksum>)
						case easy
							<game_mode_value> = "PRO FACE-OFF EASY"
						case medium
							<game_mode_value> = "PRO FACE-OFF MED"
						case hard
							<game_mode_value> = "PRO FACE-OFF HARD"
						case expert
							<game_mode_value> = "PRO FACE-OFF EXP"
					endswitch
				endif
			case p2_coop
				<game_mode_value> = "CO-OP"
		endswitch
	endif
	if GotParam \{num_songs_checksum}
		switch (<num_songs_checksum>)
			case num_1
				<num_songs_value> = "1"
			case num_3
				<num_songs_value> = "3"
			case num_5
				<num_songs_value> = "5"
			case num_7
				<num_songs_value> = "7"
		endswitch
	endif
	return num_songs_value = <num_songs_value> game_mode_value = <game_mode_value>
endscript

script serverlist_focus
	Obj_GetID
	DoScreenElementMorph id = {<objID> child = server_name}rgba = ($online_dark_purple)
	DoScreenElementMorph id = {<objID> child = mode}rgba = ($online_dark_purple)
	DoScreenElementMorph id = {<objID> child = songs}rgba = ($online_dark_purple)
	DoScreenElementMorph id = {<objID> child = highlight_bar}alpha = 1.0
	DoScreenElementMorph id = {<objID> child = bookend_left}alpha = 1.0
	DoScreenElementMorph id = {<objID> child = bookend_right}alpha = 1.0
endscript

script serverlist_unfocus
	Obj_GetID
	DoScreenElementMorph id = {<objID> child = server_name}rgba = ($online_light_blue)
	DoScreenElementMorph id = {<objID> child = mode}rgba = ($online_light_blue)
	DoScreenElementMorph id = {<objID> child = songs}rgba = ($online_light_blue)
	DoScreenElementMorph id = {<objID> child = highlight_bar}alpha = 0.0
	DoScreenElementMorph id = {<objID> child = bookend_left}alpha = 0.0
	DoScreenElementMorph id = {<objID> child = bookend_right}alpha = 0.0
endscript

script get_qos_color
	Color = ($online_red)
	if (<qos> > 3)
		Color = ($online_orange)
	endif
	if (<qos> > 5)
		Color = ($online_yellow)
	endif
	if (<qos> > 7)
		Color = ($online_green)
	endif
	return Color = <Color>
endscript
