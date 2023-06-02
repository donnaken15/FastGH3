
script #"0x1851973a"{= gh3 {
			menu_id = online_song_select_menu
			vmenu_id = online_song_select_vmenu
			pad_back_script = check_back_action_song_select
			Pos = (($menu_pos)- (200.0, 0.0))
		}}
	online_song_select_event_handlers = [
		{pad_back <pad_back_script>}
	]
	new_menu scrollid = <menu_id> vmenuid = <vmenu_id> use_backdrop = (1)menu_pos = <Pos> event_handlers = <online_song_select_event_handlers>
	array_entry = 0
	get_songlist_size
	begin
		get_songlist_checksum index = <array_entry>
		get_song_struct song = <song_checksum>
		if ((<song_struct>.version)= <version>)
			FormatText checksumName = temp_id 'song_number_%n' n = <array_entry>
			get_song_title song = <song_checksum>
			title = <song_title>
			CreateScreenElement {
				Type = TextElement
				parent = <vmenu_id>
				id = <temp_id>
				font = text_a1
				Scale = 0.75
				rgba = [210 210 210 250]
				text = <title>
				just = [left top]
				event_handlers = [
					{focus menu_focus}
					{unfocus menu_unfocus}
					{pad_choose local_player_song_selection params = {selection_value = <array_entry>}}
				]
			}
			check_for_flagged_songs {
				id = <temp_id>
				entry = <array_entry>
			}
		endif
		<array_entry> = (<array_entry> + 1)
	repeat <array_Size>
	LaunchEvent Type = focus target = <vmenu_id>
	get_number_of_song_selections
	if (<song_selections> = 0)
		Change \{ChooseTieBreaker = 1}
	endif
endscript

script destroy_online_song_select_menu
	destroy_menu \{menu_id = online_song_select_menu}
	destroy_menu_backdrop
endscript

script check_forward_action_song_select
	if (($LocalPlayerSetlistFinalized)= 1)
		ui_flow_manager_respond_to_action \{action = selected_all_songs}
	else
		local_player_song_selection <...>
	endif
endscript

script check_back_action_song_select
	if (($LocalPlayerSongSelections)= 0)
		check_for_final_song_selection
		check_tie_breaker_is_selected
		if ((<can_select_final_song> = true)& (<tie_breaker_selected> = true))
			local_player_song_deselection
		else
			SendNetMessage \{Type = song_selection song_index = -1 selection_value = 0 final_selection = -1 tie_breaker_selection = -1 menu_jump = -1}
			clear_setlists
			ui_flow_manager_respond_to_action \{action = go_back}
		endif
	else
		local_player_song_deselection
	endif
endscript

script network_player_back_to_guitar_select
	clear_setlists
	ui_flow_manager_respond_to_action \{action = go_back_to_guitar_select}
endscript

script local_player_song_selection
	if (($ChooseTieBreaker)= 1)
		check_tie_breaker_is_selected
		if (<tie_breaker_selected> = FALSE)
			SetArrayElement ArrayName = FinalSongList GlobalArray index = (($NumberOfSongsInfo [($NumberOfSongs [($MenuControl)].value)].value)- 1)NewValue = <selection_value>
			tie_breaker = 1
			final = 1
			Change \{LocalPlayerSetlistFinalized = 1}
		endif
		check_final_setlist_ready
		ui_flow_manager_respond_to_action \{action = selected_all_songs}
	else
		if IsHost
			SetArrayElement ArrayName = FinalSongList GlobalArray index = ($LocalPlayerSongSelections * 2)NewValue = <selection_value>
		else
			SetArrayElement ArrayName = FinalSongList GlobalArray index = (($LocalPlayerSongSelections * 2)+ 1)NewValue = <selection_value>
		endif
		SetArrayElement ArrayName = LocalPlayerSongList GlobalArray index = ($LocalPlayerSongSelections)NewValue = <selection_value>
		tie_breaker = 0
		Change LocalPlayerSongSelections = ($LocalPlayerSongSelections + 1)
		get_number_of_song_selections
		if (<song_selections> = ($LocalPlayerSongSelections))
			check_for_final_song_selection
			if (<can_select_final_song> = true)
				Change \{ChooseTieBreaker = 1}
				final = 0
			else
				Change \{LocalPlayerSetlistFinalized = 1}
				final = 1
				check_final_setlist_ready
				ui_flow_manager_respond_to_action \{action = selected_all_songs}
			endif
		else
			final = 0
		endif
	endif
	SendNetMessage {
		Type = song_selection
		song_index = <selection_value>
		selection_value = 1
		final_selection = <final>
		tie_breaker_selection = <tie_breaker>
		menu_jump = 0
	}
	local_player_flag_selected_song <...>
endscript

script local_player_song_deselection
	if (($LocalPlayerSetlistFinalized)= 1)
		Change \{LocalPlayerSetlistFinalized = 0}
	endif
	check_tie_breaker_is_selected
	if ((($ChooseTieBreaker)= 1)& (<tie_breaker_selected> = true))
		tie_breaker = 1
		index = ($FinalSongList [(($NumberOfSongsInfo [($NumberOfSongs [($MenuControl)].value)].value)-1)])
		SetArrayElement ArrayName = FinalSongList GlobalArray index = (($NumberOfSongsInfo [($NumberOfSongs [($MenuControl)].value)].value)-1)NewValue = -1
	else
		printf \{"deselecting song"}
		if ((<tie_breaker_selected> = FALSE)& (($ChooseTieBreaker)= 1))
			Change \{ChooseTieBreaker = 0}
		endif
		tie_breaker = 0
		Change LocalPlayerSongSelections = ($LocalPlayerSongSelections - 1)
		if IsHost
			SetArrayElement ArrayName = FinalSongList GlobalArray index = ($LocalPlayerSongSelections * 2)NewValue = -1
		else
			SetArrayElement ArrayName = FinalSongList GlobalArray index = (($LocalPlayerSongSelections * 2)+ 1)NewValue = -1
		endif
		song_index = ($LocalPlayerSongList [($LocalPlayerSongSelections)])
		SetArrayElement ArrayName = LocalPlayerSongList GlobalArray index = ($LocalPlayerSongSelections)NewValue = -1
		index = <song_index>
	endif
	SendNetMessage {
		Type = song_selection
		song_index = -1
		selection_value = -1
		final_selection = 0
		tie_breaker_selection = <tie_breaker>
		menu_jump = 0
	}
	local_player_unflag_selected_song selection_value = <index>
endscript

script network_player_song_selection
	if (<tie_breaker_selection> = 1)
		SetArrayElement ArrayName = FinalSongList GlobalArray index = (($NumberOfSongsInfo [($NumberOfSongs [($MenuControl)].value)].value)-1)NewValue = <song_index>
		tie_breaker = true
	else
		if IsHost
			SetArrayElement ArrayName = FinalSongList GlobalArray index = (($RemotePlayerSongSelections * 2)+ 1)NewValue = <song_index>
		else
			SetArrayElement ArrayName = FinalSongList GlobalArray index = ($RemotePlayerSongSelections * 2)NewValue = <song_index>
		endif
		SetArrayElement ArrayName = RemotePlayerSongList GlobalArray index = ($RemotePlayerSongSelections)NewValue = <song_index>
		tie_breaker = FALSE
	endif
	if (<final_selection> = 1)
		Change \{RemotePlayerSetlistFinalized = 1}
		check_final_setlist_ready
	endif
	if (($ui_flow_manager_state [0])= final_set_list_fs)
		network_player_change_final_setlist Type = select tie_breaker_song = <tie_breaker>
	else
		network_player_flag_selected_song <...>
	endif
	if NOT (<tie_breaker> = true)
		Change RemotePlayerSongSelections = ($RemotePlayerSongSelections + 1)
	endif
endscript

script network_player_song_deselection
	if (($RemotePlayerSetlistFinalized)= 1)
		Change \{RemotePlayerSetlistFinalized = 0}
	endif
	if (<tie_breaker_selection> = 1)
		index = ($FinalSongList [(($NumberOfSongsInfo [($NumberOfSongs [($MenuControl)].value)].value)-1)])
		SetArrayElement ArrayName = FinalSongList GlobalArray index = (($NumberOfSongsInfo [($NumberOfSongs [($MenuControl)].value)].value)-1)NewValue = -1
		tie_breaker = true
	else
		Change RemotePlayerSongSelections = ($RemotePlayerSongSelections - 1)
		if IsHost
			SetArrayElement ArrayName = FinalSongList GlobalArray index = (($RemotePlayerSongSelections * 2)+ 1)NewValue = -1
		else
			SetArrayElement ArrayName = FinalSongList GlobalArray index = ($RemotePlayerSongSelections * 2)NewValue = -1
		endif
		index = ($RemotePlayerSongList [($RemotePlayerSongSelections)])
		SetArrayElement ArrayName = RemotePlayerSongList GlobalArray index = ($RemotePlayerSongSelections)NewValue = -1
		tie_breaker = FALSE
	endif
	if (($ui_flow_manager_state [0])= final_set_list_fs)
		network_player_change_final_setlist Type = unselect tie_breaker_song = <tie_breaker>
	else
		network_player_unflag_selected_song song_index = <index>
	endif
endscript

script network_player_update_song_select
	if (<menu_jump> = 1)
		if (($ui_flow_manager_state [0])= online_song_select_fs)
			ui_flow_manager_respond_to_action \{action = selected_all_songs}
		endif
	endif
	if (<menu_jump> = -1)
		network_player_back_to_guitar_select
	endif
endscript

script check_for_matching_song
	if (<local> = true)
		GetArraySize \{$RemotePlayerSongList}
		array_count = 0
		begin
			if (($RemotePlayerSongList [<array_count>])= <index>)
				return \{found_match = true}
			endif
			<array_count> = (<array_count> + 1)
		repeat <array_Size>
	else
		GetArraySize \{$LocalPlayerSongList}
		array_count = 0
		begin
			if (($LocalPlayerSongList [<array_count>])= <index>)
				return \{found_match = true}
			endif
			<array_count> = (<array_count> + 1)
		repeat <array_Size>
	endif
endscript

script check_songlist_for_song
	<array_count> = 0
	GetArraySize $<global_array>
	begin
		if (($<global_array> [<array_count>])= <song_index>)
			found = true
		endif
		<array_count> = (<array_count> + 1)
	repeat <array_Size>
	return found_song = <found>
endscript

script check_for_flagged_songs
	found_local = FALSE
	found_remote = FALSE
	found_final = FALSE
	check_songlist_for_song song_index = <entry> global_array = FinalSongList
	<found_final> = <found_song>
	if (<found_final> = true)
		FormatText checksumName = song_number 'song_number_%n' n = <entry>
		get_songlist_checksum index = <entry>
		get_song_title song = <song_checksum>
		title = <song_title>
		check_songlist_for_song song_index = <entry> global_array = LocalPlayerSongList
		<found_local> = <found_song>
		check_songlist_for_song song_index = <entry> global_array = RemotePlayerSongList
		<found_remote> = <found_song>
		printstruct <...>
		if ((<found_local> = FALSE)& (<found_remote> = FALSE))
			FormatText textname = new_song_text "*** %s ***" s = <title>
		elseif ((<found_local> = true)& (<found_remote> = FALSE))
			FormatText textname = new_song_text "*** %s" s = <title>
		elseif ((<found_local> = FALSE)& (<found_remote> = true))
			FormatText textname = new_song_text "%s ***" s = <title>
		elseif ((<found_local> = true)& (<found_remote> = true))
			FormatText textname = new_song_text "*** %s ***" s = <title>
		endif
		<id> ::SetProps text = <new_song_text>
	endif
endscript

script local_player_flag_selected_song
	if ScreenElementExists \{id = online_song_select_vmenu}
		check_for_matching_song index = <selection_value> local = true
		found = <found_match>
		FormatText checksumName = song_number 'song_number_%n' n = <selection_value>
		get_songlist_checksum index = <selection_value>
		get_song_title song = <song_checksum>
		title = <song_title>
		if (found = true)
			FormatText textname = new_song_text "*** %s ***" s = <title>
		else
			FormatText textname = new_song_text "*** %s" s = <title>
		endif
		<song_number> ::SetProps text = <new_song_text>
	endif
endscript

script local_player_unflag_selected_song
	if ScreenElementExists \{id = online_song_select_vmenu}
		check_for_matching_song index = <selection_value> local = true
		found = <found_match>
		FormatText checksumName = song_number 'song_number_%n' n = <selection_value>
		get_songlist_checksum index = <selection_value>
		get_song_title song = <song_checksum>
		title = <song_title>
		if (found = true)
			FormatText textname = new_song_text "%s ***" s = <title>
		else
			FormatText textname = new_song_text "%s" s = <title>
		endif
		<song_number> ::SetProps text = <new_song_text>
	endif
endscript

script network_player_flag_selected_song
	check_for_matching_song index = <song_index> local = FALSE
	found = <found_match>
	FormatText checksumName = song_number 'song_number_%n' n = <song_index>
	get_songlist_checksum index = <song_index>
	get_song_title song = <song_checksum>
	title = <song_title>
	if (found = true)
		FormatText textname = new_song_text "*** %s ***" s = <title>
	else
		FormatText textname = new_song_text "%s ***" s = <title>
	endif
	<song_number> ::SetProps text = <new_song_text>
endscript

script network_player_unflag_selected_song
	check_for_matching_song index = <song_index> local = FALSE
	found = <found_match>
	FormatText checksumName = song_number 'song_number_%n' n = <song_index>
	get_songlist_checksum index = <song_index>
	get_song_title song = <song_checksum>
	title = <song_title>
	if (found = true)
		FormatText textname = new_song_text "*** %s" s = <title>
	else
		FormatText textname = new_song_text "%s" s = <title>
	endif
	<song_number> ::SetProps text = <new_song_text>
endscript

script check_tie_breaker_is_selected
	if (($FinalSongList [(($NumberOfSongsInfo [($NumberOfSongs [($MenuControl)].value)].value)-1)])> -1)
		return \{tie_breaker_selected = true}
	else
		return \{tie_breaker_selected = FALSE}
	endif
endscript
