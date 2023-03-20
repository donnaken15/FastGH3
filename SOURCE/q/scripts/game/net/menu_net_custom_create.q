
script create_custom_create_menu\{menu_type = custom_match menu_id = custom_match_menu vmenu_id = custom_match_vmenu}
	match_type_vmenu_id = match_type_selection
	match_type_text_id = match_type_selection_text
	game_mode_vmenu_id = game_mode_selection
	game_mode_text_id = game_mode_selection_text
	difficulty_vmenu_id = difficulty_selection
	difficulty_text_id = difficulty_selection_text
	num_songs_vmenu_id = number_of_songs_selection
	num_songs_text_id = number_of_songs_selection_text
	tie_breaker_vmenu_id = tie_breaker_selection
	tie_breaker_text_id = tie_breaker_selection_text
	CreateScreenElement {
		Type = VScrollingMenu
		parent = root_window
		id = <menu_id>
		just = [center top]
		dims = (500.0, 480.0)
		Pos = (640.0, 290.0)
		z_priority = 1
	}
	CreateScreenElement {
		Type = VMenu
		parent = <menu_id>
		id = <vmenu_id>
		Pos = (205.0, 0.0)
		just = [center top]
		internal_just = [left top]
		dims = (500.0, 480.0)
		event_handlers = [
			{pad_back ui_flow_manager_respond_to_action params = {action = go_back}}
			{pad_back generic_menu_pad_back_sound}
			{pad_up generic_menu_up_or_down_sound params = {up}}
			{pad_down generic_menu_up_or_down_sound params = {down}}
		]
		exclusive_device = ($primary_controller)
	}
	create_menu_backdrop \{texture = #"0x4fb4b5e9"}
	CreateScreenElement \{Type = ContainerElement parent = root_window id = custom_search_container Pos = (0.0, 0.0)}
	displaySprite \{id = online_frame parent = custom_search_container tex = #"0xfaffa7d8" Pos = (640.0, 100.0) just = [center top] z = 2}
	displaySprite \{id = #"0xf3ed3382" parent = custom_search_container tex = #"0xf3ed3382" Pos = (640.0, 42.0) just = [center top] z = 3 dims = (256.0, 105.0)}
	CreateScreenElement {
		Type = TextElement
		parent = custom_search_container
		font = fontgrid_title_gh3
		Scale = 0.85
		rgba = ($online_dark_purple)
		text = "BROWSE MATCHES"
		Pos = (640.0, 135.0)
		just = [center top]
		z_priority = 100.0
	}
	CreateScreenElement {
		Type = TextElement
		id = game_mode
		parent = <vmenu_id>
		font = fontgrid_title_gh3
		Scale = 0.65
		rgba = ($online_light_blue)
		text = "GAME MODE:"
		just = [left top]
		z_priority = 100.0
		event_handlers = [
			{focus net_custom_ui_focus params = {this_id = game_mode text_id = <game_mode_text_id> VMenu = <vmenu_id>}}
			{unfocus net_custom_ui_unfocus params = {text_id = <game_mode_text_id>}}
			{pad_choose net_custom_ui_change_focus params = {this_id = game_mode text_id = <game_mode_text_id> to = <game_mode_vmenu_id> from = <vmenu_id>}}
			{pad_choose net_copy_intial_params params = {copy_from = SearchGameModeValue copy_to = CopyOfGlobal}}
		]
	}
	CreateScreenElement {
		Type = VMenu
		id = <game_mode_vmenu_id>
		parent = game_mode
		Pos = (550.0, 0.0)
		just = [left top]
		internal_just = [left top]
		event_handlers = [
			{pad_up animate_helper_arrows params = {direction = up}}
			{pad_down animate_helper_arrows params = {direction = down}}
			{pad_up net_custom_up_down params = {text = <game_mode_text_id> Global = CopyOfGlobal Type = mode direction = up}}
			{pad_down net_custom_up_down params = {text = <game_mode_text_id> Global = CopyOfGlobal Type = mode direction = down}}
			{pad_back net_commit_or_reset_params params = {text = <game_mode_text_id> Global = SearchGameModeValue Type = mode}}
			{pad_back net_custom_ui_change_unfocus params = {action = back to = <vmenu_id> from = <game_mode_vmenu_id> menu = search}}
			{pad_choose net_commit_or_reset_params params = {commit copy_from = CopyOfGlobal copy_to = SearchGameModeValue}}
			{pad_choose net_custom_ui_change_unfocus params = {action = choose to = <vmenu_id> from = <game_mode_vmenu_id> menu = search}}
		]
	}
	CreateScreenElement {
		Type = TextElement
		id = <game_mode_text_id>
		parent = <game_mode_vmenu_id>
		font = fontgrid_title_gh3
		Scale = 1.0
		rgba = ($online_light_blue)
		text = ($FilterTypes.mode.values [($SearchGameModeValue)])
		just = [left top]
		z_priority = 100.0
	}
	fit_text_into_menu_item id = <id> max_width = 375
	CreateScreenElement {
		Type = TextElement
		id = difficulty
		parent = <vmenu_id>
		font = fontgrid_title_gh3
		Scale = 0.65
		rgba = ($online_light_blue)
		text = "DIFFICULTY:"
		just = [left top]
		z_priority = 100.0
		event_handlers = [
			{focus net_custom_ui_focus params = {this_id = difficulty text_id = <difficulty_text_id> VMenu = <vmenu_id>}}
			{unfocus net_custom_ui_unfocus params = {text_id = <difficulty_text_id>}}
			{pad_choose net_custom_ui_change_focus params = {this_id = difficulty text_id = <difficulty_text_id> to = <difficulty_vmenu_id> from = <vmenu_id>}}
			{pad_choose net_copy_intial_params params = {copy_from = SearchDifficultyValue copy_to = CopyOfGlobal}}
		]
	}
	CreateScreenElement {
		Type = VMenu
		id = <difficulty_vmenu_id>
		parent = difficulty
		Pos = (550.0, 0.0)
		just = [left top]
		internal_just = [left top]
		event_handlers = [
			{pad_up animate_helper_arrows params = {direction = up}}
			{pad_down animate_helper_arrows params = {direction = down}}
			{pad_up net_custom_up_down params = {text = <difficulty_text_id> Global = CopyOfGlobal Type = diff direction = up}}
			{pad_down net_custom_up_down params = {text = <difficulty_text_id> Global = CopyOfGlobal Type = diff direction = down}}
			{pad_back net_commit_or_reset_params params = {text = <difficulty_text_id> Global = SearchDifficultyValue Type = diff}}
			{pad_back net_custom_ui_change_unfocus params = {action = back to = <vmenu_id> from = <difficulty_vmenu_id> menu = search diff_focus}}
			{pad_choose net_commit_or_reset_params params = {commit copy_from = CopyOfGlobal copy_to = SearchDifficultyValue}}
			{pad_choose net_custom_ui_change_unfocus params = {action = choose to = <vmenu_id> from = <difficulty_vmenu_id> menu = search diff_focus}}
		]
	}
	CreateScreenElement {
		Type = TextElement
		id = <difficulty_text_id>
		parent = <difficulty_vmenu_id>
		font = fontgrid_title_gh3
		Scale = 1.0
		rgba = ($online_light_blue)
		text = ($FilterTypes.diff.values [($SearchDifficultyValue)])
		just = [left top]
		z_priority = 100.0
	}
	fit_text_into_menu_item id = <id> max_width = 375
	CreateScreenElement {
		Type = TextElement
		id = number_of_songs
		parent = <vmenu_id>
		font = fontgrid_title_gh3
		Scale = 0.65
		rgba = ($online_light_blue)
		text = "NUMBER OF SONGS:"
		just = [left top]
		z_priority = 100.0
		event_handlers = [
			{focus net_custom_ui_focus params = {this_id = number_of_songs text_id = <num_songs_text_id> VMenu = <vmenu_id>}}
			{unfocus net_custom_ui_unfocus params = {text_id = <num_songs_text_id>}}
			{pad_choose net_custom_ui_change_focus params = {this_id = number_of_songs text_id = <num_songs_text_id> to = <num_songs_vmenu_id> from = <vmenu_id>}}
			{pad_choose net_copy_intial_params params = {copy_from = SearchNumSongsValue copy_to = CopyOfGlobal}}
		]
	}
	CreateScreenElement {
		Type = VMenu
		id = <num_songs_vmenu_id>
		parent = number_of_songs
		Pos = (550.0, 0.0)
		just = [left top]
		internal_just = [left top]
		event_handlers = [
			{pad_up animate_helper_arrows params = {direction = up}}
			{pad_down animate_helper_arrows params = {direction = down}}
			{pad_up net_custom_up_down params = {text = <num_songs_text_id> Global = CopyOfGlobal Type = num_songs direction = up}}
			{pad_down net_custom_up_down params = {text = <num_songs_text_id> Global = CopyOfGlobal Type = num_songs direction = down}}
			{pad_back net_commit_or_reset_params params = {text = <num_songs_text_id> Global = SearchNumSongsValue Type = num_songs}}
			{pad_back net_custom_ui_change_unfocus params = {action = back to = <vmenu_id> from = <num_songs_vmenu_id> menu = search}}
			{pad_choose net_commit_or_reset_params params = {commit copy_from = CopyOfGlobal copy_to = SearchNumSongsValue}}
			{pad_choose net_custom_ui_change_unfocus params = {action = choose to = <vmenu_id> from = <num_songs_vmenu_id> menu = search}}
		]
	}
	CreateScreenElement {
		Type = TextElement
		id = <num_songs_text_id>
		parent = <num_songs_vmenu_id>
		font = fontgrid_title_gh3
		Scale = 1.0
		rgba = ($online_light_blue)
		text = ($FilterTypes.num_songs.values [($SearchNumSongsValue)])
		just = [left top]
		z_priority = 100.0
	}
	fit_text_into_menu_item id = <id> max_width = 375
	CreateScreenElement {
		Type = TextElement
		id = submit_selection
		parent = <vmenu_id>
		font = fontgrid_title_gh3
		Scale = 0.65
		rgba = ($online_light_blue)
		text = "DONE"
		just = [left top]
		z_priority = 100.0
		event_handlers = [
			{focus net_custom_ui_focus params = {this_id = submit_selection VMenu = <vmenu_id>}}
			{unfocus net_custom_ui_unfocus}
			{pad_choose custom_create_select_done}
		]
	}
	<vmenu_id> ::SetTags current_focus = first_time
	block_unblock_difficulty_actions \{menu = search}
	set_focus_color rgba = ($online_dark_purple)
	set_unfocus_color rgba = ($online_light_blue)
	Change \{user_control_pill_text_color = [0 0 0 255]}
	Change \{user_control_pill_color = [180 180 180 255]}
	add_user_control_helper \{text = "SELECT" button = green z = 100}
	add_user_control_helper \{text = "BACK" button = red z = 100}
	add_user_control_helper \{text = "UP/DOWN" button = strumbar z = 100}
	LaunchEvent Type = focus target = <vmenu_id>
endscript

script destroy_custom_create_menu
	if ScreenElementExists \{id = custom_search_container}
		DestroyScreenElement \{id = custom_search_container}
	endif
	if ScreenElementExists \{id = custom_match_menu}
		DestroyScreenElement \{id = custom_match_menu}
	endif
	clean_up_user_control_helpers
	destroy_menu_backdrop
endscript

script custom_create_select_done
	Change match_type = ($FilterTypes.Type.checksum [($SearchMatchTypeValue)])
	set_network_preferences
	ui_flow_manager_respond_to_action \{action = select_done}
endscript

script net_custom_ui_change_focus
	LaunchEvent Type = unfocus target = <from>
	SoundEvent \{event = ui_sfx_select}
	wait \{1 Frame}
	if ScreenElementExists id = <this_id>
		<this_id> ::SetProps rgba = ($online_dark_purple)
		<text_id> ::SetProps rgba = ($online_dark_purple)
	endif
	if ScreenElementExists \{id = arrow_down}
		DoScreenElementMorph \{id = arrow_down alpha = 1.0 time = 0.1}
	endif
	if ScreenElementExists \{id = arrow_up}
		DoScreenElementMorph \{id = arrow_up alpha = 1.0 time = 0.1}
	endif
	if ScreenElementExists \{id = bookend1_over}
		bookend1_over ::SetProps \{alpha = 0.0}
	endif
	if ScreenElementExists \{id = highlight_over}
		highlight_over ::GetProps
		highlight_over ::DoMorph Pos = (<Pos> + (480.0, 0.0))time = 0.1
	endif
	if ScreenElementExists \{id = bookend2_over}
		bookend2_over ::SetProps \{alpha = 1.0}
	endif
	LaunchEvent Type = focus target = <to>
endscript

script net_custom_ui_change_unfocus
	LaunchEvent Type = unfocus target = <from>
	if (<action> = choose)
		SoundEvent \{event = ui_sfx_select}
	else
		SoundEvent \{event = Generic_menu_back_SFX}
	endif
	if ScreenElementExists \{id = arrow_down}
		DoScreenElementMorph \{id = arrow_down alpha = 0.0 time = 0.1}
	endif
	if ScreenElementExists \{id = arrow_up}
		DoScreenElementMorph \{id = arrow_up alpha = 0.0 time = 0.1}
	endif
	if ScreenElementExists \{id = bookend2_over}
		bookend2_over ::SetProps \{alpha = 0.0}
	endif
	if ScreenElementExists \{id = highlight_over}
		highlight_over ::GetProps
		highlight_over ::DoMorph Pos = (<Pos> + (-480.0, 0.0))time = 0.1
	endif
	if ScreenElementExists \{id = bookend1_over}
		bookend1_over ::SetProps \{alpha = 1.0}
	endif
	block_unblock_difficulty_actions <...>
	LaunchEvent Type = focus target = <to>
endscript

script net_custom_ui_focus
	<VMenu> ::GetTags
	if NOT (<current_focus> = <this_id>)
		destroy_prev_selection_highlight
		if ScreenElementExists id = <this_id>
			if (<this_id> = submit_selection)
				displaySprite id = highlight_over parent = <this_id> tex = white Pos = (-25.0, -10.0) dims = (480.0, 63.0) rgba = ($online_light_blue)just = [left top] z = 4
				displaySprite id = bookend1_over parent = <this_id> tex = #"0x40f8daf3" Pos = (-59.0, 20.0) dims = (60.0, 50.0) rgba = ($online_light_blue)just = [left center] z = 4
				displaySprite id = bookend2_over parent = <this_id> tex = #"0x40f8daf3" Pos = (445.0, 20.0) dims = (60.0, 50.0) rgba = ($online_light_blue)just = [left center] z = 4
			else
				displaySprite id = highlight_under parent = <this_id> tex = white Pos = (-25.0, -10.0) dims = (960.0, 63.0) rgba = ($online_light_purple)just = [left top] z = 3
				displaySprite id = bookend1_under parent = <this_id> tex = #"0x40f8daf3" Pos = (-59.0, 20.0) dims = (60.0, 50.0) rgba = ($online_light_purple)just = [left center] z = 3
				displaySprite id = bookend2_under parent = <this_id> tex = #"0x40f8daf3" Pos = (923.0, 20.0) dims = (60.0, 50.0) rgba = ($online_light_purple)just = [left center] z = 3
				displaySprite id = highlight_over parent = <this_id> tex = white Pos = (-25.0, -10.0) dims = (480.0, 63.0) rgba = ($online_light_blue)just = [left top] z = 4
				displaySprite id = bookend1_over parent = <this_id> tex = #"0x40f8daf3" Pos = (-59.0, 20.0) dims = (60.0, 50.0) rgba = ($online_light_blue)just = [left center] z = 4
				displaySprite id = bookend2_over parent = <this_id> tex = #"0x40f8daf3" Pos = (923.0, 20.0) dims = (60.0, 50.0) rgba = ($online_light_blue)just = [left center] z = 4
				displaySprite id = arrow_down parent = <this_id> tex = #"0x1877d61c" Pos = (490.0, 40.0) dims = (44.0, 32.0) rgba = ($online_dark_purple)just = [center center] z = 5
				displaySprite id = arrow_up parent = <this_id> tex = #"0x1877d61c" Pos = (490.0, 0.0) dims = (44.0, 32.0) rgba = ($online_dark_purple)just = [center center] z = 5 flip_h
				bookend2_over ::SetProps \{alpha = 0.0}
				arrow_down ::SetProps \{alpha = 0.0}
				arrow_up ::SetProps \{alpha = 0.0 preserve_flip}
			endif
		endif
		<VMenu> ::SetTags current_focus = <this_id>
	endif
	retail_menu_focus
	if ScreenElementExists id = <text_id>
		<text_id> ::SetProps rgba = ($online_dark_purple)
	endif
endscript

script net_custom_ui_unfocus
	retail_menu_unfocus
	if ScreenElementExists id = <text_id>
		<text_id> ::SetProps rgba = ($online_light_blue)
	endif
endscript

script destroy_prev_selection_highlight
	if ScreenElementExists \{id = highlight_under}
		DestroyScreenElement \{id = highlight_under}
	endif
	if ScreenElementExists \{id = bookend1_under}
		DestroyScreenElement \{id = bookend1_under}
	endif
	if ScreenElementExists \{id = bookend2_under}
		DestroyScreenElement \{id = bookend2_under}
	endif
	if ScreenElementExists \{id = highlight_over}
		DestroyScreenElement \{id = highlight_over}
	endif
	if ScreenElementExists \{id = bookend1_over}
		DestroyScreenElement \{id = bookend1_over}
	endif
	if ScreenElementExists \{id = bookend2_over}
		DestroyScreenElement \{id = bookend2_over}
	endif
	if ScreenElementExists \{id = arrow_up}
		DestroyScreenElement \{id = arrow_up}
	endif
	if ScreenElementExists \{id = arrow_down}
		DestroyScreenElement \{id = arrow_down}
	endif
endscript

script animate_helper_arrows
	if (<direction> = up)
		generic_menu_up_or_down_sound \{up}
		if ScreenElementExists \{id = arrow_up}
			arrow_up ::DoMorph \{Scale = (1.7999999523162842, 1.5) time = 0.1}
			arrow_up ::DoMorph \{Scale = (1.375, 1.0) time = 0.1}
		endif
	else
		generic_menu_up_or_down_sound \{down}
		if ScreenElementExists \{id = arrow_down}
			arrow_down ::DoMorph \{Scale = (1.7999999523162842, 1.5) time = 0.1}
			arrow_down ::DoMorph \{Scale = (1.375, 1.0) time = 0.1}
		endif
	endif
endscript
