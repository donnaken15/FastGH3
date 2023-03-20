
script net_create_choose_part_menu
	ResetInstrumentSelections
	ui_print_gamertags \{pos1 = (500.0, 100.0) pos2 = (780.0, 550.0) dims = (330.0, 35.0) just1 = [center top] just2 = [center top]}
	create_choose_part_menu
endscript

script net_choose_part_screen_elements
	CreateScreenElement \{Type = VMenu parent = si_scrolling_menu id = si_vmenu_p1 event_handlers = [{pad_up select_instrument_scroll params = {Player = 1 Dir = up}}{pad_down select_instrument_scroll params = {Player = 1 Dir = down}}{pad_choose net_request_instrument params = {Player = 1}}{pad_back net_instrument_go_back params = {Player = 1}}{pad_start menu_show_gamercard}] exclusive_device = $#"0xab76e33e"}
	CreateScreenElement \{Type = VMenu parent = si_scrolling_menu id = si_vmenu_p2}
endscript

script net_request_instrument
	SendNetMessage {
		Type = instrument_selection
		value = ($g_si_player1_index + 2)
	}
endscript

script net_select_instrument
	if (<instrument_index> < 0)
		select_instrument_go_back Player = <Player>
		return
	endif
	if (<Player> = 1)
		if NOT ($g_si_player1_index = <instrument_index>)
			Change \{g_si_player1_locked = 1}
			Change g_si_player1_index = <instrument_index>
		endif
	else
		if NOT ($g_si_player2_index = <instrument_index>)
			Change \{g_si_player2_locked = 1}
			Change g_si_player2_index = <instrument_index>
			force_instrument_highlight Player = <Player>
		endif
	endif
	choose_part_menu_select_part Player = <Player>
endscript

script force_instrument_highlight
	if (<Player> = 1)
		if ($g_si_player1_index = 0)
			SetScreenElementProps \{id = si_hilite_p1 Pos = $#"0x8c59897e"}
			SetScreenElementProps id = si_hilite_bookend_p1a Pos = ($g_si_hilitep1_pos + (0.0, 10.0))
		else
			SetScreenElementProps id = si_hilite_p1 Pos = ($g_si_hilitep1_pos + (0.0, 50.0))
			SetScreenElementProps id = si_hilite_bookend_p1a Pos = ($g_si_hilitep1_pos + (0.0, 60.0))
		endif
	else
		if ($g_si_player2_index = 0)
			SetScreenElementProps \{id = si_hilite_p2 Pos = $#"0xcbf9f3ae" flip_h}
			SetScreenElementProps id = si_hilite_bookend_p2a Pos = ($g_si_hilitep2_pos + (0.0, 20.0))
		else
			SetScreenElementProps id = si_hilite_p2 Pos = ($g_si_hilitep2_pos + (0.0, 50.0))flip_h
			SetScreenElementProps id = si_hilite_bookend_p2a Pos = ($g_si_hilitep2_pos + (0.0, 70.0))
		endif
	endif
	select_instrument_randomize_bookends Player = <Player>
endscript

script net_instrument_go_back
	SendNetMessage \{Type = instrument_selection value = 1}
endscript
