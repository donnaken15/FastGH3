
script create_online_server_list
	Change \{xboxlive_num_results = 0}
	CreateScreenElement \{Type = VScrollingMenu parent = root_window id = search_results_menu just = [left top] dims = (625.0, 300.0) Pos = (328.0, 272.0) z_priority = 1}
	if ($gPrivateMatchId = 0)
		Handlers = [
			{pad_back generic_menu_pad_back params = {callback = menu_flow_go_back}}
			{pad_up generic_menu_up_or_down_sound params = {up}}
			{pad_down generic_menu_up_or_down_sound params = {down}}
			{pad_square refresh_server_list}
		]
	else
		Handlers = [
			{pad_back generic_menu_pad_back params = {callback = menu_flow_go_back}}
			{pad_up generic_menu_up_or_down_sound params = {up}}
			{pad_down generic_menu_up_or_down_sound params = {down}}
			{pad_square refresh_server_list}
		]
	endif
	CreateScreenElement {
		Type = VMenu
		parent = search_results_menu
		id = search_results_vmenu
		Pos = (0.0, 0.0)
		just = [left top]
		internal_just = [left top]
		dims = (625.0, 300.0)
		event_handlers = <Handlers>
	}
	create_menu_backdrop \{texture = #"0x4fb4b5e9"}
	set_focus_color rgba = ($online_dark_purple)
	set_unfocus_color rgba = ($online_light_blue)
	Change \{user_control_pill_text_color = [0 0 0 255]}
	Change \{user_control_pill_color = [180 180 180 255]}
	Change \{user_control_pill_gap = 100}
	Change \{pill_helper_max_width = 90}
	SetScreenElementProps \{id = search_results_vmenu disable_pad_handling}
	LaunchEvent \{Type = unfocus target = search_results_vmenu}
	NetSessionFunc \{Obj = match func = stop_server_list}
	NetSessionFunc \{Obj = match func = free_server_list}
	CreateScreenElement \{Type = ContainerElement parent = root_window id = search_results_container Pos = (0.0, 0.0)}
	displaySprite \{id = online_frame parent = search_results_container tex = #"0xfaffa7d8" Pos = (640.0, 100.0) just = [center top] z = 2}
	<id> ::SetTags hide_on_search = 0
	displaySprite \{id = #"0xf3ed3382" parent = search_results_container tex = #"0xf3ed3382" Pos = (640.0, 42.0) just = [center top] z = 2.0999999 dims = (256.0, 105.0)}
	<id> ::SetTags hide_on_search = 0
	if (($ui_flow_manager_state [0])= online_server_list_fs)
		<title_text> = "BROWSE MATCHES"
	elseif (($ui_flow_manager_state [0])= private_match_search_fs)
		<title_text> = "PRIVATE MATCH"
	else
		<title_text> = "QUICKMATCH"
	endif
	CreateScreenElement {
		Type = TextElement
		parent = search_results_container
		font = fontgrid_title_gh3
		Scale = 0.85
		rgba = ($online_dark_purple)
		text = <title_text>
		Pos = (640.0, 135.0)
		just = [center top]
		z_priority = 2.0999999
	}
	<id> ::SetTags hide_on_search = 0
	if (($ui_flow_manager_state [0])= online_server_list_fs)
		displaySprite id = arrow_up parent = search_results_container tex = #"0x1877d61c" Pos = (640.0, 250.0) dims = (44.0, 32.0) rgba = ($online_light_blue)just = [center center] z = 2.0999999 flip_h
		<id> ::SetTags hide_on_search = 1
		displaySprite id = arrow_down parent = search_results_container tex = #"0x1877d61c" Pos = (640.0, 590.0) dims = (44.0, 32.0) rgba = ($online_light_blue)just = [center center] z = 2.0999999
		<id> ::SetTags hide_on_search = 1
		displaySprite parent = search_results_container tex = white rgba = ($online_light_grey)Pos = (325.0, 270.0) just = [left top] z = 2.0999999 dims = (625.0, 30.0)
		<id> ::SetTags hide_on_search = 1
		displaySprite parent = search_results_container tex = white rgba = ($online_light_grey)Pos = (325.0, 330.0) just = [left top] z = 2.0999999 dims = (625.0, 30.0)
		<id> ::SetTags hide_on_search = 1
		displaySprite parent = search_results_container tex = white rgba = ($online_light_grey)Pos = (325.0, 390.0) just = [left top] z = 2.0999999 dims = (625.0, 30.0)
		<id> ::SetTags hide_on_search = 1
		displaySprite parent = search_results_container tex = white rgba = ($online_light_grey)Pos = (325.0, 450.0) just = [left top] z = 2.0999999 dims = (625.0, 30.0)
		<id> ::SetTags hide_on_search = 1
		displaySprite parent = search_results_container tex = white rgba = ($online_light_grey)Pos = (325.0, 510.0) just = [left top] z = 2.0999999 dims = (625.0, 30.0)
		<id> ::SetTags hide_on_search = 1
		if isXenon
			CreateScreenElement {
				Type = TextElement
				parent = search_results_container
				font = fontgrid_title_gh3
				Scale = (0.699999988079071, 0.75)
				rgba = ($online_light_blue)
				text = "HOST"
				just = [left top]
				Pos = (320.0, 210.0)
				z_priority = 2.0999999
			}
		else
			CreateScreenElement {
				Type = TextElement
				parent = search_results_container
				font = fontgrid_title_gh3
				Scale = (0.699999988079071, 0.75)
				rgba = ($online_light_blue)
				text = "NAME"
				just = [left top]
				Pos = (320.0, 210.0)
				z_priority = 2.0999999
			}
		endif
		fit_text_into_menu_item id = <id> max_width = 225
		<id> ::SetTags hide_on_search = 1
		CreateScreenElement {
			Type = TextElement
			parent = search_results_container
			font = fontgrid_title_gh3
			Scale = (0.699999988079071, 0.75)
			rgba = ($online_light_blue)
			text = "MODE"
			just = [left top]
			Pos = (550.0, 210.0)
			z_priority = 2.0999999
		}
		fit_text_into_menu_item id = <id> max_width = 190
		<id> ::SetTags hide_on_search = 1
		CreateScreenElement {
			Type = TextElement
			parent = search_results_container
			font = fontgrid_title_gh3
			Scale = (0.699999988079071, 0.75)
			rgba = ($online_light_blue)
			text = "SONGS"
			just = [left top]
			Pos = (750.0, 210.0)
			z_priority = 2.0999999
		}
		fit_text_into_menu_item id = <id> max_width = 100
		<id> ::SetTags hide_on_search = 1
		CreateScreenElement {
			Type = TextElement
			parent = search_results_container
			font = fontgrid_title_gh3
			Scale = (0.699999988079071, 0.75)
			rgba = ($online_light_blue)
			text = "SIGNAL"
			just = [left top]
			Pos = (860.0, 210.0)
			z_priority = 2.0999999
		}
		fit_text_into_menu_item id = <id> max_width = 100
		<id> ::SetTags hide_on_search = 1
		if ScreenElementExists \{id = search_results_container}
			GetScreenElementChildren \{id = search_results_container}
			if GotParam \{children}
				GetArraySize \{children}
				i = 0
				begin
					if ScreenElementExists id = (<children> [<i>])
						(<children> [<i>])::GetTags
						if (<hide_on_search> = 1)
							(<children> [<i>])::SetProps preserve_flip alpha = 0.0
						endif
						<i> = (<i> + 1)
					endif
				repeat <array_Size>
			endif
		endif
		get_custom_match_search_params
		NetSessionFunc Obj = match func = set_search_params params = <...>
		NetSessionFunc \{Obj = match func = set_server_list_mode params = {optimatch}}
		search_results_vmenu ::SetTags \{search_type = custom_search}
	elseif (($ui_flow_manager_state [0])= private_match_search_fs)
		get_private_match_search_params
		NetSessionFunc Obj = match func = set_search_params params = <...>
		NetSessionFunc \{Obj = match func = set_server_list_mode params = {quickmatch}}
		search_results_vmenu ::SetTags \{search_type = quickmatch_search}
	else
		get_quick_match_search_params
		NetSessionFunc Obj = match func = set_search_params params = <...>
		NetSessionFunc \{Obj = match func = set_server_list_mode params = {quickmatch}}
		search_results_vmenu ::SetTags \{search_type = quickmatch_search}
	endif
	NetSessionFunc \{Obj = match func = start_server_list}
	add_user_control_helper \{text = "SELECT" button = green z = 100}
	add_user_control_helper \{text = "BACK" button = red z = 100}
	add_user_control_helper \{text = "REFRESH" button = blue z = 100}
	add_user_control_helper \{text = "UP/DOWN" button = strumbar z = 100}
	create_server_list_searching_dialog
endscript

script destroy_online_server_list
	if ScreenElementExists \{id = searching_dialog_container}
		DestroyScreenElement \{id = searching_dialog_container}
	endif
	destroy_pause_menu_frame
	destroy_menu \{menu_id = server_list_searching_dialog_menu}
	if ScreenElementExists \{id = search_results_container}
		DestroyScreenElement \{id = search_results_container}
	endif
	clean_up_user_control_helpers
	if ScreenElementExists \{id = search_results_menu}
		DestroyScreenElement \{id = search_results_menu}
	endif
	destroy_menu_backdrop
	destroy_pause_menu_frame
	destroy_menu \{menu_id = server_list_searching_dialog_menu}
	if ScreenElementExists \{id = searching_dialog_container}
		DestroyScreenElement \{id = searching_dialog_container}
	endif
	destroy_pause_menu_frame
	destroy_menu \{menu_id = server_list_create_match_dialog_menu}
	if ScreenElementExists \{id = create_match_dialog_container}
		DestroyScreenElement \{id = create_match_dialog_container}
	endif
endscript

script net_chosen_join_server
	JoinServer <...>
	ui_flow_manager_respond_to_action \{action = select_server}
endscript

script net_choose_server
	NetSessionFunc Obj = match func = choose_server params = {id = <id>}
	ui_flow_manager_respond_to_action \{action = select_server}
endscript

script clear_search_list
	if ScreenElementExists \{id = search_results_vmenu}
		GetScreenElementChildren \{id = search_results_vmenu}
		if GotParam \{children}
			GetArraySize \{children}
			i = 0
			begin
				if ScreenElementExists id = (<children> [<i>])
					DestroyScreenElement id = (<children> [<i>])
					<i> = (<i> + 1)
				endif
			repeat <array_Size>
		endif
	endif
endscript

script refresh_server_list
	LaunchEvent \{Type = unfocus target = search_results_vmenu}
	if ScreenElementExists \{id = server_list_create_match_dialog_vmenu}
		LaunchEvent \{Type = unfocus target = server_list_create_match_dialog_vmenu}
	endif
	if ScreenElementExists \{id = search_results_container}
		GetScreenElementChildren \{id = search_results_container}
		if GotParam \{children}
			GetArraySize \{children}
			i = 0
			begin
				if ScreenElementExists id = (<children> [<i>])
					(<children> [<i>])::GetTags
					if (<hide_on_search> = 1)
						(<children> [<i>])::SetProps preserve_flip alpha = 0.0
					endif
					<i> = (<i> + 1)
				endif
			repeat <array_Size>
		endif
	endif
	if NOT ScreenElementExists \{id = server_list_searching_dialog_menu}
		if ScreenElementExists \{id = server_list_create_match_dialog_menu}
			destroy_server_list_create_match_dialog
		endif
		search_results_vmenu ::GetTags
		NetSessionFunc \{Obj = match func = stop_server_list}
		NetSessionFunc \{Obj = match func = free_server_list}
		clear_search_list
		if ($gPrivateMatchId != 0)
			get_private_match_search_params
			NetSessionFunc Obj = match func = set_search_params params = <...>
			NetSessionFunc \{Obj = match func = set_server_list_mode params = {quickmatch}}
		elseif (<search_type> = custom_search)
			get_custom_match_search_params
			NetSessionFunc Obj = match func = set_search_params params = <...>
			NetSessionFunc \{Obj = match func = set_server_list_mode params = {optimatch}}
		else
			get_quick_match_search_params
			NetSessionFunc Obj = match func = set_search_params params = <...>
			NetSessionFunc \{Obj = match func = set_server_list_mode params = {quickmatch}}
		endif
		NetSessionFunc \{Obj = match func = start_server_list}
		create_server_list_searching_dialog
	endif
endscript

script create_server_list_searching_dialog\{menu_id = server_list_searching_dialog_menu vmenu_id = server_list_searching_dialog_vmenu pad_back_script = searching_dialog_select_cancel}
	CreateScreenElement {
		Type = VScrollingMenu
		parent = search_results_container
		id = <menu_id>
		just = [left top]
		dims = (625.0, 300.0)
		Pos = (328.0, 450.0)
		z_priority = 2.0999999
	}
	CreateScreenElement {
		Type = VMenu
		parent = <menu_id>
		id = <vmenu_id>
		Pos = (0.0, 0.0)
		just = [left top]
		internal_just = [center top]
		dims = (625.0, 300.0)
		event_handlers = [
			{pad_back <pad_back_script>}
			{pad_up generic_menu_up_or_down_sound params = {up}}
			{pad_down generic_menu_up_or_down_sound params = {down}}
		]
	}
	CreateScreenElement \{Type = ContainerElement parent = search_results_container id = searching_dialog_container Pos = (0.0, 0.0)}
	displaySprite id = search_arrow_up parent = searching_dialog_container tex = #"0x1877d61c" Pos = (640.0, 424.0) dims = (44.0, 32.0) rgba = ($online_light_blue)just = [center center] z = 2.0999999 flip_h
	displaySprite id = search_arrow_down parent = searching_dialog_container tex = #"0x1877d61c" Pos = (640.0, 545.0) dims = (44.0, 32.0) rgba = ($online_light_blue)just = [center center] z = 2.0999999
	CreateScreenElement {
		Type = TextElement
		parent = searching_dialog_container
		font = fontgrid_title_gh3
		Scale = 1.0
		rgba = ($online_light_blue)
		text = "Finding sessions"
		just = [center top]
		z_priority = 2.0999999
		Pos = (640.0, 300.0)
	}
	GetScreenElementDims id = <id>
	CreateScreenElement {
		Type = TextElement
		parent = <id>
		id = dots_text
		font = fontgrid_title_gh3
		Scale = 0.65
		rgba = ($online_light_blue)
		text = ""
		just = [left top]
		z_priority = 2.0999999
		Pos = (<width> * (1.0, 0.0) + (5.0, 15.0))
	}
	add_searching_menu_item vmenu_id = <vmenu_id> choose_script = searching_dialog_select_stop text = "STOP"
	add_searching_menu_item vmenu_id = <vmenu_id> choose_script = searching_dialog_select_cancel text = "CANCEL"
	set_focus_color rgba = ($online_dark_purple)
	set_unfocus_color rgba = (online_light_blue)
	if ScreenElementExists \{id = dots_text}
		RunScriptOnScreenElement \{id = dots_text animate_dots params = {id = dots_text}}
	endif
	LaunchEvent \{Type = focus target = server_list_searching_dialog_vmenu}
endscript

script destroy_server_list_searching_dialog
	destroy_menu \{menu_id = server_list_searching_dialog_menu}
	if ScreenElementExists \{id = searching_dialog_container}
		DestroyScreenElement \{id = searching_dialog_container}
	endif
endscript

script searching_dialog_select_stop
	xboxlive_menu_optimatch_results_stop
endscript

script searching_dialog_select_cancel
	destroy_server_list_searching_dialog
	NetSessionFunc \{Obj = match func = stop_server_list}
	NetSessionFunc \{Obj = match func = free_server_list}
	ui_flow_manager_respond_to_action \{action = response_cancel_selected}
endscript

script create_server_list_create_match_dialog\{menu_id = server_list_create_match_dialog_menu vmenu_id = server_list_create_match_dialog_vmenu}
	CreateScreenElement {
		Type = VScrollingMenu
		parent = search_results_container
		id = <menu_id>
		just = [left top]
		dims = (625.0, 300.0)
		Pos = (328.0, 450.0)
		z_priority = 2.0999999
	}
	if ($gPrivateMatchId = 0)
		Handlers = [
			{pad_back create_match_dialog_select_cancel}
			{pad_square refresh_server_list}
			{pad_up generic_menu_up_or_down_sound params = {up}}
			{pad_down generic_menu_up_or_down_sound params = {down}}
		]
	else
		Handlers = [
			{pad_back create_match_dialog_select_back}
			{pad_square refresh_server_list}
			{pad_up generic_menu_up_or_down_sound params = {up}}
			{pad_down generic_menu_up_or_down_sound params = {down}}
		]
	endif
	CreateScreenElement {
		Type = VMenu
		parent = <menu_id>
		id = <vmenu_id>
		Pos = (0.0, 0.0)
		just = [left top]
		internal_just = [center top]
		dims = (625.0, 300.0)
		event_handlers = <Handlers>
	}
	CreateScreenElement \{Type = ContainerElement parent = search_results_container id = create_match_dialog_container Pos = (0.0, 0.0)}
	CreateScreenElement {
		Type = TextBlockElement
		parent = create_match_dialog_container
		font = fontgrid_title_gh3
		Scale = (0.6500000357627869, 0.6500000357627869)
		rgba = ($online_light_blue)
		text = "No sessions are available.\nWould you like to\ncreate a match?"
		just = [center top]
		internal_just = [center top]
		z_priority = 2.0999999
		Pos = (640.0, 275.0)
		dims = (600.0, 370.0)
	}
	displaySprite id = search_arrow_up parent = create_match_dialog_container tex = #"0x1877d61c" Pos = (640.0, 424.0) dims = (44.0, 32.0) rgba = ($online_light_blue)just = [center center] z = 2.0999999 flip_h
	displaySprite id = search_ arrow_down parent = create_match_dialog_container tex = #"0x1877d61c" Pos = (640.0, 545.0) dims = (44.0, 32.0) rgba = ($online_light_blue)just = [center center] z = 2.0999999
	add_searching_menu_item vmenu_id = <vmenu_id> choose_script = create_match_dialog_select_create text = "CREATE MATCH"
	add_searching_menu_item vmenu_id = <vmenu_id> choose_script = create_match_dialog_select_cancel text = "CANCEL"
	create_match_dialog_focus
endscript

script destroy_server_list_create_match_dialog
	create_match_dialog_unfocus
	destroy_menu \{menu_id = server_list_create_match_dialog_menu}
	if ScreenElementExists \{id = create_match_dialog_container}
		DestroyScreenElement \{id = create_match_dialog_container}
	endif
endscript

script create_match_dialog_select_create
	destroy_server_list_create_match_dialog
	ui_flow_manager_respond_to_action \{action = response_create_selected create_params = {menu_type = create_match}}
endscript

script create_match_dialog_select_cancel
	destroy_server_list_create_match_dialog
	ui_flow_manager_respond_to_action \{action = response_cancel_selected}
endscript

script create_match_dialog_select_back
	destroy_server_list_create_match_dialog
	ui_flow_manager_respond_to_action \{action = go_back}
endscript

script create_match_dialog_focus
	LaunchEvent \{Type = unfocus target = search_results_vmenu}
	LaunchEvent \{Type = focus target = server_list_create_match_dialog_vmenu}
endscript

script create_match_dialog_unfocus
	LaunchEvent \{Type = unfocus target = server_list_create_match_dialog_vmenu}
	LaunchEvent \{Type = focus target = search_results_vmenu}
endscript
dots_array = [
	" "
	"."
	". ."
	". . ."
]

script animate_dots
	num_dots = 0
	begin
		FormatText textname = new_text "%a" a = ($dots_array [<num_dots>])
		<id> ::SetProps text = <new_text>
		if (<num_dots> = 3)
			<num_dots> = 0
		else
			<num_dots> = (<num_dots> + 1)
		endif
		wait \{0.5 Second}
	repeat
endscript
