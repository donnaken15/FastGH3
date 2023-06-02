
script create_join_server_menu
	CreateScreenElement \{Type = ContainerElement parent = root_window id = joining_screen_container Pos = (0.0, 0.0)}
	killspawnedscript \{name = destroy_loading_screen_spawned}
	create_menu_backdrop \{texture = #"0x4fb4b5e9"}
	displaySprite \{id = online_frame parent = joining_screen_container tex = #"0xfaffa7d8" Pos = (640.0, 100.0) just = [center top] z = 2}
	displaySprite \{id = #"0xf3ed3382" parent = joining_screen_container tex = #"0xf3ed3382" Pos = (640.0, 42.0) just = [center top] z = 2.0999999 dims = (256.0, 105.0)}
	if (($ui_flow_manager_state [0])= quick_match_joining_game_fs)
		<title_text> = "QUICKMATCH"
	elseif (($ui_flow_manager_state [0])= invite_joining_game_fs)
		<title_text> = "INVITATION"
	elseif (($ui_flow_manager_state [0])= private_match_joining_game_fs)
		<title_text> = "PRIVATE MATCH"
	else
		<title_text> = "BROWSE MATCHES"
	endif
	CreateScreenElement {
		Type = TextElement
		parent = joining_screen_container
		font = fontgrid_title_gh3
		Scale = 0.85
		rgba = ($online_dark_purple)
		text = <title_text>
		Pos = (640.0, 135.0)
		just = [center top]
		z_priority = 2.0999999
	}
	CreateScreenElement {
		Type = TextElement
		parent = joining_screen_container
		text = "JOINING GAME"
		just = [center center]
		Pos = (640.0, 340.0)
		rot_angle = 0
		font = fontgrid_title_gh3
		Scale = 1.0
		rgba = ($online_light_blue)
		z_priority = 2.0999999
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
	if ScreenElementExists \{id = dots_text}
		RunScriptOnScreenElement \{id = dots_text animate_dots params = {id = dots_text}}
	endif
endscript

script destroy_join_server_menu
	if ScreenElementExists \{id = joining_screen_container}
		DestroyScreenElement \{id = joining_screen_container}
	endif
	destroy_popup_warning_menu
	destroy_menu_backdrop
endscript

script create_joining_screen
	CreateScreenElement \{Type = ContainerElement parent = root_window id = joining_screen_container Pos = (0.0, 0.0)}
	create_menu_backdrop \{texture = venue_bg}
	CreateScreenElement \{Type = TextElement parent = joining_screen_container text = "JOINING GAME" just = [center center] Pos = (640.0, 340.0) rot_angle = 0 font = fontgrid_title_gh3 Scale = 2.0 rgba = [210 210 210 250] Shadow shadow_offs = (5.0, 5.0) shadow_rgba = [0 0 0 255] z_priority = 2.0}
	CreateScreenElement \{Type = TextElement parent = joining_screen_container id = joining_dots_text font = text_a5 Scale = 2.0 rgba = [210 210 210 250] text = "" just = [left top] z_priority = 2.0 Pos = (640.0, 450.0) Shadow shadow_offs = (5.0, 5.0) shadow_rgba = [0 0 0 255]}
	if ScreenElementExists \{id = joining_dots_text}
		RunScriptOnScreenElement \{id = joining_dots_text animate_dots params = {id = joining_dots_text}}
	endif
endscript

script destroy_joining_screen
	if ScreenElementExists \{id = joining_screen_container}
		DestroyScreenElement \{id = joining_screen_container}
	endif
	destroy_menu_backdrop
endscript
