menu_pos = (200.0, 200.0)
debug_menu_params = {
	type = textelement
	font = text_a1
	scale = 0.75
	rgba = [127 127 127 191]
	just = [left top]
	z_priority = 100.0
	//Shadow
	//shadow_offs = (3.0, 3.0)
	//shadow_rgba = [0 0 0 255]
}

script create_debugging_menu
	//create_generic_backdrop
	CreateScreenElement \{Type = VScrollingMenu parent = pause_menu id = debug_scrolling_menu just = [left top] dims = (400.0, 480.0) Pos = $menu_pos}
	CreateScreenElement \{Type = VMenu parent = debug_scrolling_menu id = debug_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back back_to_retail_ui_flow}]}
	disable_pause
	CreateScreenElement \{$debug_menu_params parent = debug_vmenu text = 'Repeat Last Song' event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose select_start_song params = {uselaststarttime}}]}
	CreateScreenElement \{$debug_menu_params parent = debug_vmenu id = toggle_playermode_menuitem text = 'Play Song: 1p_quickplay' event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_left toggle_playermode_left}{pad_right toggle_playermode_right}{pad_choose select_playermode}]}
	toggle_playermode_setprop
	CreateScreenElement \{$debug_menu_params parent = debug_vmenu text = 'Settings' event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_settings_menu}]}
	CreateScreenElement \{$debug_menu_params parent = debug_vmenu text = "Skip Into Song" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_skipintosong_menu}]}
	CreateScreenElement \{$debug_menu_params parent = debug_vmenu text = "Screenshot" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose screen_shot}]}
	CreateScreenElement \{$debug_menu_params parent = debug_vmenu text = "Save Replay Buffer" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose save_replay}]}
	CreateScreenElement \{$debug_menu_params parent = debug_vmenu text = "Load Replay" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_replay_menu}]}
	CreateScreenElement \{$debug_menu_params parent = debug_vmenu text = "Reload Zones" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose RefreshCurrentZones}]}
	if ($fastgh3_branch = unpak)
		CreateScreenElement \{$debug_menu_params parent = debug_vmenu text = "Reload Scripts" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose reload_scripts}]}
	endif
	LaunchEvent \{Type = focus target = debug_vmenu}
endscript

script destroy_debugging_menu
	if ScreenElementExists \{id = debug_scrolling_menu}
		DestroyScreenElement \{id = debug_scrolling_menu}
	endif
	//destroy_generic_backdrop
endscript

script kill_debug_menus
	destroy_replay_menu
	destroy_songversion_menu
	destroy_settings_menu
	//destroy_character_viewer_menu
	destroy_skipintosong_menu
	//destroy_cameracut_menu
	destroy_difficulty_menu
	destroy_skipbytime_menu
	destroy_skipbymarker_menu
	destroy_skipbymeasure_menu
	destroy_looppoint_menu
endscript

script back_to_debug_menu
	kill_debug_menus
	create_debugging_menu
endscript

script destroy_all_debug_menus
	kill_debug_menus
	destroy_debugging_menu
endscript

script back_to_online_menu
	printf \{"---back_to_online_menu"}
	quit_network_game
	destroy_create_session_menu
	create_online_menu
endscript

script create_songversion_menu
	ui_menu_select_sfx
	destroy_debugging_menu
	//create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = songversion_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (40.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = songversion_scrolling_menu id = songversion_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_debug_menu}}]}
	CreateScreenElement \{$debug_menu_params parent = songversion_vmenu text = "Play GH3 Song" z_priority = 100.0 just = [left top] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_song_menu params = {version = gh3}}]}
	CreateScreenElement \{$debug_menu_params parent = songversion_vmenu text = "Play GH2 Song" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_song_menu params = {version = gh2}}]}
	CreateScreenElement \{$debug_menu_params parent = songversion_vmenu text = "Play GH1 Song" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_song_menu params = {version = gh1}}]}
	LaunchEvent \{Type = focus target = songversion_vmenu}
endscript

script back_to_songversion_menu
	destroy_song_menu
	create_songversion_menu
endscript

script destroy_songversion_menu
	if ScreenElementExists \{id = songversion_scrolling_menu}
		DestroyScreenElement \{id = songversion_scrolling_menu}
	endif
	//destroy_generic_backdrop
endscript

script create_song_menu\{version = gh3}
	ui_menu_select_sfx
	destroy_songversion_menu
	//create_generic_backdrop
	x_pos = 450
	if (<version> = gh1)
		<x_pos> = 455
	endif
	if (<version> = gh2)
		<x_pos> = 520
	endif
	if (<version> = gh3)
		<x_pos> = 500
	endif
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = song_scrolling_menu
		just = [left top]
		dims = (400.0, 250.0)
		Pos = ($menu_pos - (520.0, 0.0) + (<x_pos> * (1.0, 0.0)))
	}
	CreateScreenElement \{Type = VMenu parent = song_scrolling_menu id = song_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_songversion_menu}}]}
	array_entry = 0
	get_songlist_size
	begin
		get_songlist_checksum index = <array_entry>
		get_song_struct song = <song_checksum>
		if ((<song_struct>.version)= <version>)
			get_song_title song = <song_checksum>
			CreateScreenElement {
				$debug_menu_params
				parent = song_vmenu
				text = <song_title>
				event_handlers = [
					{focus menu_focus}
					{unfocus menu_unfocus}
					{pad_choose create_difficulty_menu params = {song_name = <song_checksum> version = <version> Player = 1}}
				]
			}
		endif
		<array_entry> = (<array_entry> + 1)
	repeat <array_Size>
	LaunchEvent \{Type = focus target = song_vmenu}
endscript

script back_to_song_menu
	destroy_difficulty_menu
	create_song_menu version = <version>
endscript

script destroy_song_menu
	if ScreenElementExists \{id = song_scrolling_menu}
		DestroyScreenElement \{id = song_scrolling_menu}
	endif
	//destroy_generic_backdrop
endscript

script create_difficulty_menu
	destroy_song_menu
	destroy_difficulty_menu
	//create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = difficulty_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (70.0, 0.0))
	}
	CreateScreenElement {
		Type = VMenu
		parent = difficulty_menu
		id = difficulty_vmenu
		Pos = (0.0, 0.0)
		just = [left top]
		event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}
			{pad_down generic_menu_up_or_down_sound params = {down}}
			{pad_back generic_menu_pad_back params = {callback = back_to_song_menu version = <version>}}
		]
	}
	array_entry = 0
	GetArraySize \{$difficulty_list}
	begin
		difficulty_count = ($difficulty_list [<array_entry>])
		get_difficulty_text difficulty = <difficulty_count>
		if (<Player> = 2)
			CreateScreenElement {
				$debug_menu_params
				parent = difficulty_vmenu
				text = <difficulty_text>
				event_handlers = [
					{focus menu_focus}
					{unfocus menu_unfocus}
					{pad_choose select_start_song params = {song_name = <song_name> difficulty2 = ($difficulty_list [<array_entry>])difficulty = <difficulty>}}
				]
			}
		else
			if ($current_num_players = 2)
				CreateScreenElement {
					$debug_menu_params
					parent = difficulty_vmenu
					text = <difficulty_text>
					event_handlers = [
						{focus menu_focus}
						{unfocus menu_unfocus}
						{pad_choose create_difficulty_menu params = {song_name = <song_name> version = <version> difficulty = ($difficulty_list [<array_entry>])Player = 2}}
					]
				}
			else
				CreateScreenElement {
					$debug_menu_params
					parent = difficulty_vmenu
					text = <difficulty_text>
					event_handlers = [
						{focus menu_focus}
						{unfocus menu_unfocus}
						{pad_choose select_start_song params = {difficulty = ($difficulty_list [<array_entry>])song_name = <song_name>}}
					]
				}
			endif
		endif
		<array_entry> = (<array_entry> + 1)
	repeat <array_Size>
	LaunchEvent \{Type = focus target = difficulty_vmenu}
endscript

script destroy_difficulty_menu
	if ScreenElementExists \{id = difficulty_menu}
		DestroyScreenElement \{id = difficulty_menu}
	endif
	//destroy_generic_backdrop
endscript

script create_settings_menu
	ui_menu_select_sfx
	destroy_debugging_menu
	//create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = settings_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos - (30.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = settings_scrolling_menu id = settings_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_debug_menu}}]}
	//CreateScreenElement \{$debug_menu_params parent = settings_vmenu text = "Change Venue" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_changevenue_menu}]}
	//CreateScreenElement \{$debug_menu_params parent = settings_vmenu text = "Change Guitar" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_changeguitar_menu params = {Type = guitar}}]}
	//CreateScreenElement \{$debug_menu_params parent = settings_vmenu text = "Change Bass" just = [left top] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_changeguitar_menu params = {Type = bass}}]}
	//CreateScreenElement \{$debug_menu_params parent = settings_vmenu id = toggle_visibility_menuitem text = "Toggle visibility" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_togglevisibility_menu}]}
	CreateScreenElement \{$debug_menu_params parent = settings_vmenu id = select_slomo_menuitem text = "Select Slomo : 1.0" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose select_slomo}]}
	select_slomo_setprop
	//CreateScreenElement \{$debug_menu_params parent = settings_vmenu id = toggle_showmeasures_menuitem text = "Show Measures" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_showmeasures}]}
	//toggle_showmeasures_setprop
	//CreateScreenElement \{$debug_menu_params parent = settings_vmenu id = toggle_showcameraname_menuitem text = "Show Camera Name" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_showcameraname}]}
	//toggle_showcameraname_setprop
	CreateScreenElement \{$debug_menu_params parent = settings_vmenu id = toggle_inputlog_menuitem text = "Show Input Log" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_inputlog}]}
	toggle_inputlog_setprop
	CreateScreenElement \{$debug_menu_params parent = settings_vmenu id = toggle_botp1_menuitem text = "Toggle Bot P1" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_botp1}]}
	toggle_botp1_setprop
	CreateScreenElement \{$debug_menu_params parent = settings_vmenu id = toggle_botp2_menuitem text = "Toggle Bot P2" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_botp2}]}
	toggle_botp2_setprop
	CreateScreenElement \{$debug_menu_params parent = settings_vmenu id = edit_inputlog_lines_menuitem text = "Input Log Lines" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_left edit_inputlog_lines_left}{pad_right edit_inputlog_lines_right}]}
	edit_inputlog_lines_setprop
	//CreateScreenElement \{$debug_menu_params parent = settings_vmenu id = toggle_tilt_menuitem text = "Show Input Log" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_tilt}]}
	//toggle_tilt_setprop
	CreateScreenElement \{$debug_menu_params parent = settings_vmenu id = toggle_leftyflip_menuitem text = "Leftyflip" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_leftyflip}]}
	toggle_leftyflip_setprop
	//CreateScreenElement \{$debug_menu_params parent = settings_vmenu id = create_cameracut_menuitem text = "Select CameraCut" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_cameracut_menu}]}
	//CreateScreenElement \{$debug_menu_params parent = settings_vmenu text = "Toggle GPU Time" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_global params = {global_toggle = show_gpu_time}}]}
	//CreateScreenElement \{$debug_menu_params parent = settings_vmenu text = "Toggle CPU Time" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_global params = {global_toggle = show_cpu_time}}]}
	CreateScreenElement \{$debug_menu_params parent = settings_vmenu id = toggle_forcescore_menuitem text = "Force Score" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_forcescore}]}
	toggle_forcescore_setprop
	LaunchEvent \{Type = focus target = settings_vmenu}
endscript

script back_to_settings_menu
	//destroy_changevenue_menu
	//destroy_changehighway_menu
	//destroy_changeguitar_menu
	destroy_togglevisibility_menu
	//destroy_cameracut_menu
	create_settings_menu
endscript

script destroy_settings_menu
	if ScreenElementExists \{id = settings_scrolling_menu}
		DestroyScreenElement \{id = settings_scrolling_menu}
	endif
	//destroy_generic_backdrop
endscript
CameraCutPrefixArray = [
	''
]

debug_camera_array = None
debug_camera_array_pakname = None
debug_camera_array_count = 0

script select_playermode
	Change player1_device = <device_num>
	translate_gamemode
	create_songversion_menu
endscript

script translate_gamemode
	switch $game_mode
		case p1_quickplay
			Change \{StructureName = player1_status part = guitar}
			Change \{current_num_players = 1}
		case p1_career
			Change \{StructureName = player1_status part = guitar}
			Change \{current_num_players = 1}
		case p1_improv
			Change \{StructureName = player1_status part = guitar}
			Change \{current_num_players = 1}
		case p1_boss
			Change \{StructureName = player1_status part = guitar}
			Change \{current_num_players = 1}
		case p2_faceoff
			Change \{StructureName = player1_status part = guitar}
			Change \{StructureName = player2_status part = guitar}
			Change \{current_num_players = 2}
		case p2_coop
			Change \{StructureName = player1_status part = guitar}
			Change \{StructureName = player2_status part = rhythm}
			Change \{current_num_players = 2}
		case p2_battle
			Change \{StructureName = player1_status part = guitar}
			Change \{StructureName = player2_status part = guitar}
			Change \{current_num_players = 2}
		case p2_career
			Change \{StructureName = player1_status part = guitar}
			Change \{StructureName = player2_status part = rhythm}
			Change \{current_num_players = 2}
		case training
			Change \{StructureName = player1_status part = guitar}
			Change \{current_num_players = 1}
	endswitch
endscript

script toggle_playermode_left
	switch $game_mode
		case p1_quickplay
			Change \{game_mode = training}
		case p1_career
			Change \{game_mode = p1_quickplay}
		case p1_improv
			Change \{game_mode = p1_career}
		case p1_boss
			Change \{game_mode = p1_improv}
		case p2_faceoff
			Change \{game_mode = p1_boss}
		case p2_coop
			Change \{game_mode = p2_faceoff}
		case p2_battle
			Change \{game_mode = p2_coop}
		case p2_career
			Change \{game_mode = p2_battle}
		case training
			Change \{game_mode = p2_career}
	endswitch
	toggle_playermode_setprop
endscript

script toggle_playermode_right
	switch $game_mode
		case p1_quickplay
			Change \{game_mode = p1_career}
		case p1_career
			Change \{game_mode = p1_improv}
		case p1_improv
			Change \{game_mode = p1_boss}
		case p1_boss
			Change \{game_mode = p2_faceoff}
		case p2_faceoff
			Change \{game_mode = p2_coop}
		case p2_coop
			Change \{game_mode = p2_battle}
		case p2_battle
			Change \{game_mode = p2_career}
		case p2_career
			Change \{game_mode = training}
		case training
			Change \{game_mode = p1_quickplay}
	endswitch
	toggle_playermode_setprop
endscript

script toggle_playermode_setprop
	switch $game_mode
		case p1_quickplay
			toggle_playermode_menuitem ::SetProps \{text = "Play Song: p1_quickplay"}
		case p1_career
			toggle_playermode_menuitem ::SetProps \{text = "Play Song: p1_career"}
		case p1_improv
			toggle_playermode_menuitem ::SetProps \{text = "Play Song: p1_improv"}
		case p1_boss
			toggle_playermode_menuitem ::SetProps \{text = "Play Song: p1_boss"}
		case p2_faceoff
			toggle_playermode_menuitem ::SetProps \{text = "Play Song: p2_faceoff"}
		case p2_coop
			toggle_playermode_menuitem ::SetProps \{text = "Play Song: p2_coop"}
		case p2_battle
			toggle_playermode_menuitem ::SetProps \{text = "Play Song: p2_battle"}
		case p2_career
			toggle_playermode_menuitem ::SetProps \{text = "Play Song: p2_career"}
		case training
			toggle_playermode_menuitem ::SetProps \{text = "Play Song: training"}
	endswitch
endscript

script select_slomo
	ui_menu_select_sfx
	speedfactor = ($current_speedfactor * 10.0)
	casttointeger \{speedfactor}
	speedfactor = (<speedfactor> + 1)
	if (<speedfactor> > 10)
		speedfactor = 1
	endif
	if (<speedfactor> < 1)
		speedfactor = 1
	endif
	Change current_speedfactor = (<speedfactor> / 10.0)
	update_slomo
	select_slomo_setprop
endscript

script update_slomo
	setslomo \{$current_speedfactor}
	setslomo_song \{slomo = $current_speedfactor}
	Player = 1
	begin
		FormatText checksumName = player_status 'player%i_status' i = <Player>
		// this is probably meant to tighten it as if it were still 100% but it doesn't take effect until restart
		Change StructureName = <player_status> check_time_early = ($check_time_early * $current_speedfactor)
		Change StructureName = <player_status> check_time_late = ($check_time_late * $current_speedfactor)
		Player = (<Player> + 1)
	repeat $current_num_players
endscript

script select_slomo_setprop
	FormatText \{textname = slomo_text "Select Slomo : %s" s = $current_speedfactor}
	select_slomo_menuitem ::SetProps text = <slomo_text>
endscript
debug_showmeasures = OFF

script toggle_inputlog
	ui_menu_select_sfx
	kill_debug_elements
	if ($show_play_log = 0)
		Change \{show_play_log = 1}
	else
		Change \{show_play_log = 0}
	endif
	toggle_inputlog_setprop
	init_play_log
endscript

script toggle_botp1
	ui_menu_select_sfx
	kill_debug_elements
	Change StructureName = player1_status bot_play = (1 - ($player1_status.bot_play))
	toggle_botp1_setprop
endscript

script toggle_botp2
	ui_menu_select_sfx
	kill_debug_elements
	Change StructureName = player2_status bot_play = (1 - ($player2_status.bot_play))
	toggle_botp2_setprop
endscript

script edit_inputlog_lines_left
	ui_menu_select_sfx
	kill_debug_elements
	Change play_log_lines = ($play_log_lines -1)
	if ($play_log_lines < 1)
		Change \{play_log_lines = 1}
	endif
	edit_inputlog_lines_setprop
	init_play_log
endscript

script edit_inputlog_lines_right
	ui_menu_select_sfx
	kill_debug_elements
	Change play_log_lines = ($play_log_lines + 1)
	if ($play_log_lines > 10)
		Change \{play_log_lines = 10}
	endif
	edit_inputlog_lines_setprop
	init_play_log
endscript

script toggle_tilt
	ui_menu_select_sfx
	kill_debug_elements
	if ($show_guitar_tilt = 0)
		Change \{show_guitar_tilt = 1}
	else
		Change \{show_guitar_tilt = 0}
	endif
	toggle_tilt_setprop
	init_play_log
endscript

script toggle_inputlog_setprop
	if ($show_play_log = 0)
		toggle_inputlog_menuitem ::SetProps \{text = "Show Input Log : off"}
	else
		toggle_inputlog_menuitem ::SetProps \{text = "Show Input Log : on"}
	endif
endscript

script toggle_botp1_setprop
	if (($player1_status.bot_play)= 0)
		toggle_botp1_menuitem ::SetProps \{text = "Toggle Bot P1: Off"}
	else
		toggle_botp1_menuitem ::SetProps \{text = "Toggle Bot P1: On"}
	endif
endscript

script toggle_botp2_setprop
	if (($player2_status.bot_play)= 0)
		toggle_botp2_menuitem ::SetProps \{text = "Toggle Bot P2: Off"}
	else
		toggle_botp2_menuitem ::SetProps \{text = "Toggle Bot P2: On"}
	endif
endscript

script edit_inputlog_lines_setprop
	FormatText textname = text "Input Log Lines: %l" l = ($play_log_lines)DontAssertForChecksums
	edit_inputlog_lines_menuitem ::SetProps text = <text>
endscript

script toggle_tilt_setprop
	if ($show_guitar_tilt = 0)
		toggle_tilt_menuitem ::SetProps \{text = "Show Tilt : off"}
	else
		toggle_tilt_menuitem ::SetProps \{text = "Show Tilt : on"}
	endif
endscript

script toggle_leftyflip
	ui_menu_select_sfx
	toggle_global \{p1_lefty}
	Change \{StructureName = player1_status lefthanded_gems = $p1_lefty}
	Change \{StructureName = player1_status lefthanded_button_ups = $p1_lefty}
	toggle_leftyflip_setprop
endscript

script toggle_leftyflip_setprop
	if ($p1_lefty = 0)
		toggle_leftyflip_menuitem ::SetProps \{text = "Lefty Flip : off"}
	else
		toggle_leftyflip_menuitem ::SetProps \{text = "Lefty Flip : on"}
	endif
endscript
debug_forcescore = OFF

script toggle_forcescore
	ui_menu_select_sfx
	switch $debug_forcescore
		case OFF
			Change \{debug_forcescore = poor}
		case poor
			Change \{debug_forcescore = medium}
		case medium
			Change \{debug_forcescore = good}
		case good
			Change \{debug_forcescore = OFF}
		default
			Change \{debug_forcescore = OFF}
	endswitch
	CrowdIncrease \{player_status = player1_status}
	toggle_forcescore_setprop
endscript

script toggle_forcescore_setprop
	switch $debug_forcescore
		case OFF
			toggle_forcescore_menuitem ::SetProps \{text = "Force Score : off"}
		case poor
			toggle_forcescore_menuitem ::SetProps \{text = "Force Score : poor"}
		case medium
			toggle_forcescore_menuitem ::SetProps \{text = "Force Score : medium"}
		case good
			toggle_forcescore_menuitem ::SetProps \{text = "Force Score : good"}
		default
			toggle_forcescore_menuitem ::SetProps \{text = "Force Score : off"}
	endswitch
endscript

script back_to_changehighway_menu
	create_changehighway_menu
endscript

script destroy_changehighway_menu
	if ScreenElementExists \{id = changehighway_scrolling_menu}
		DestroyScreenElement \{id = changehighway_scrolling_menu}
	endif
	//destroy_generic_backdrop
endscript

HideByType_List = [
	'real_crowd'
	'stage'
	'scene_ped'
]
HideByType_Visible = [
	On
	On
	On
]

script create_togglevisibility_menu
	ui_menu_select_sfx
	destroy_settings_menu
	//create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = togglevisibility_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (70.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = togglevisibility_scrolling_menu id = togglevisibility_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_settings_menu}}]}
	CreateScreenElement \{$debug_menu_params parent = togglevisibility_vmenu id = toggle_bandvisible_menuitem text = "Toggle band" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_bandvisible}]}
	toggle_bandvisible_setprop
	GetArraySize \{$HideByType_List}
	array_count = 0
	begin
		FormatText checksumName = type_checksum '%s' s = ($HideByType_List [<array_count>])
		FormatText checksumName = menuitem_checksum 'toggle_hidebytype_menuitem_%s' s = ($HideByType_List [<array_count>])
		CreateScreenElement {
			$debug_menu_params
			parent = togglevisibility_vmenu
			id = <menuitem_checksum>
			text = ""
			event_handlers = [
				{focus menu_focus}
				{unfocus menu_unfocus}
				{pad_choose toggle_hidebytype params = {Type = type_checksum array_count = <array_count>}}
			]
		}
		array_count = (<array_count> + 1)
	repeat <array_Size>
	toggle_hidebytype_setprop
	CreateScreenElement \{$debug_menu_params parent = togglevisibility_vmenu id = toggle_highway_menuitem text = "Toggle highway" z_priority = 100.0 just = [left top] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_highway}]}
	toggle_highway_setprop
	LaunchEvent \{Type = focus target = togglevisibility_vmenu}
endscript

script back_to_togglevisibility_menu
	create_togglevisibility_menu
endscript

script destroy_togglevisibility_menu
	if ScreenElementExists \{id = togglevisibility_scrolling_menu}
		DestroyScreenElement \{id = togglevisibility_scrolling_menu}
	endif
	//destroy_generic_backdrop
endscript
highwayvisible = On

script toggle_highway
	ui_menu_select_sfx
	if ($highwayvisible = OFF)
		if ScreenElementExists \{id = gem_containerp1}
			DoScreenElementMorph \{id = gem_containerp1 alpha = 1}
		endif
		if ScreenElementExists \{id = gem_containerp2}
			DoScreenElementMorph \{id = gem_containerp2 alpha = 1}
		endif
		enable_highway_prepass
		Change \{highwayvisible = On}
	else
		if ScreenElementExists \{id = gem_containerp1}
			DoScreenElementMorph \{id = gem_containerp1 alpha = 0}
		endif
		if ScreenElementExists \{id = gem_containerp2}
			DoScreenElementMorph \{id = gem_containerp2 alpha = 0}
		endif
		disable_highway_prepass
		Change \{highwayvisible = OFF}
	endif
	toggle_highway_setprop
endscript

script toggle_highway_setprop
	if ($highwayvisible = OFF)
		toggle_highway_menuitem ::SetProps \{text = "Toggle highway : off"}
	else
		toggle_highway_menuitem ::SetProps \{text = "Toggle highway : on"}
	endif
endscript
bandvisible = On

script toggle_bandvisible
endscript

script set_bandvisible
endscript

script toggle_bandvisible_setprop
	if ($bandvisible = OFF)
		toggle_bandvisible_menuitem ::SetProps \{text = "Toggle band : off"}
	else
		toggle_bandvisible_menuitem ::SetProps \{text = "Toggle band : on"}
	endif
endscript

script toggle_hidebytype
	ui_menu_select_sfx
	if (($HideByType_Visible [<array_count>])= OFF)
		SetArrayElement ArrayName = HideByType_Visible GlobalArray index = <array_count> NewValue = On
	else
		SetArrayElement ArrayName = HideByType_Visible GlobalArray index = <array_count> NewValue = OFF
	endif
	set_hidebytype
	toggle_hidebytype_setprop
endscript

script set_hidebytype
	GetArraySize \{$HideByType_List}
	array_count = 0
	begin
		FormatText checksumName = type_checksum '%s' s = ($HideByType_List [<array_count>])
		if (($HideByType_Visible [<array_count>])= OFF)
			HideObjectByType Type = <type_checksum>
		else
			HideObjectByType Type = <type_checksum> unhide
		endif
		array_count = (<array_count> + 1)
	repeat <array_Size>
endscript

script toggle_hidebytype_setprop
	GetArraySize \{$HideByType_List}
	array_count = 0
	begin
		if (($HideByType_Visible [<array_count>])= OFF)
			FormatText textname = menutext "Toggle %s : off" s = ($HideByType_List [<array_count>])
		else
			FormatText textname = menutext "Toggle %s : on" s = ($HideByType_List [<array_count>])
		endif
		FormatText checksumName = menuitem_checksum 'toggle_hidebytype_menuitem_%s' s = ($HideByType_List [<array_count>])
		<menuitem_checksum> ::SetProps text = <menutext>
		array_count = (<array_count> + 1)
	repeat <array_Size>
endscript

script create_skipintosong_menu
	ui_menu_select_sfx
	destroy_debugging_menu
	//create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = skipintosong_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (20.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = skipintosong_scrolling_menu id = skipintosong_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_debug_menu}}]}
	CreateScreenElement \{$debug_menu_params parent = skipintosong_vmenu text = "Skip By Time" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_skipbytime_menu}]}
	CreateScreenElement \{$debug_menu_params parent = skipintosong_vmenu text = "Skip By Marker" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_skipbymarker_menu}]}
	CreateScreenElement \{$debug_menu_params parent = skipintosong_vmenu text = "Skip By Measure" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_skipbymeasure_menu}]}
	CreateScreenElement \{$debug_menu_params parent = skipintosong_vmenu text = "Set Loop Point" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_looppoint_menu}]}
	LaunchEvent \{Type = focus target = skipintosong_vmenu}
endscript

script back_to_skipintosong_menu
	destroy_skipbytime_menu
	destroy_skipbymarker_menu
	destroy_skipbymeasure_menu
	destroy_looppoint_menu
	create_skipintosong_menu
endscript

script destroy_skipintosong_menu
	if ScreenElementExists \{id = skipintosong_scrolling_menu}
		DestroyScreenElement \{id = skipintosong_scrolling_menu}
	endif
	//destroy_generic_backdrop
endscript

script create_skipbytime_menu
	ui_menu_select_sfx
	if GotParam \{looppoint}
		destroy_looppoint_menu
		callback = back_to_looppoint_menu
	else
		destroy_skipintosong_menu
		callback = back_to_skipintosong_menu
	endif
	//create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = skipbytime_scrolling_menu
		just = [left top]
		dims = (400.0, 250.0)
		Pos = ($menu_pos + (70.0, 0.0))
	}
	CreateScreenElement {
		Type = VMenu
		parent = skipbytime_scrolling_menu
		id = skipbytime_vmenu
		Pos = (0.0, 0.0)
		just = [left top]
		event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}
			{pad_down generic_menu_up_or_down_sound params = {down}}
			{pad_back generic_menu_pad_back params = {callback = <callback>}}
		]
	}
	menu_func = select_start_song
	if GotParam \{looppoint}
		menu_func = set_looppoint
		CreateScreenElement {
			$debug_menu_params
			parent = skipbytime_vmenu
			text = "No Loop Point"
			event_handlers = [
				{focus menu_focus}
				{unfocus menu_unfocus}
				{pad_choose <menu_func> params = {startTime = -1000000}}
			]
		}
	endif
	ExtendCrc \{$current_song '_fretbars' out=fretbar_array}
	GetArraySize $<fretbar_array>
	max_time = (($<fretbar_array> [(<array_Size> - 1)])/ 1000)
	current_time = 0
	begin
		FormatText textname = menu_itemname "Time %ss" s = <current_time>
		if (<current_time> < <max_time>)
			CreateScreenElement {
				$debug_menu_params
				parent = skipbytime_vmenu
				text = <menu_itemname>
				event_handlers = [
					{focus menu_focus}
					{unfocus menu_unfocus}
					{pad_choose <menu_func> params = {song_name = ($current_song)difficulty = ($current_difficulty)difficulty2 = ($current_difficulty2)startTime = (<current_time> * 1000)}}
				]
			}
		else
			break
		endif
		current_time = (<current_time> + 5)
	repeat
	LaunchEvent \{Type = focus target = skipbytime_vmenu}
endscript

script back_to_skipbytime_menu
	create_skipbytime_menu
endscript

script destroy_skipbytime_menu
	if ScreenElementExists \{id = skipbytime_scrolling_menu}
		DestroyScreenElement \{id = skipbytime_scrolling_menu}
	endif
	//destroy_generic_backdrop
endscript

script create_skipbymarker_menu
	ui_menu_select_sfx
	if GotParam \{looppoint}
		destroy_looppoint_menu
		callback = back_to_looppoint_menu
	else
		destroy_skipintosong_menu
		callback = back_to_skipintosong_menu
	endif
	//create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = skipbymarker_scrolling_menu
		just = [left top]
		dims = (400.0, 250.0)
		Pos = ($menu_pos + (30.0, 0.0))
	}
	CreateScreenElement {
		Type = VMenu
		parent = skipbymarker_scrolling_menu
		id = skipbymarker_vmenu
		Pos = (0.0, 0.0)
		just = [left top]
		event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}
			{pad_down generic_menu_up_or_down_sound params = {down}}
			{pad_back generic_menu_pad_back params = {callback = <callback>}}
		]
	}
	menu_func = select_start_song
	if GotParam \{looppoint}
		menu_func = set_looppoint
		CreateScreenElement {
			$debug_menu_params
			parent = skipbymarker_vmenu
			text = "No Loop Point"
			event_handlers = [
				{focus menu_focus}
				{unfocus menu_unfocus}
				{pad_choose <menu_func> params = {startTime = -1000000}}
			]
		}
	endif
	ExtendCrc \{$current_song '_markers' out=marker_array}
	GetArraySize $<marker_array>
	if (<array_Size> = 0)
		CreateScreenElement {
			$debug_menu_params
			parent = skipbymarker_vmenu
			text = "start"
			event_handlers = [
				{focus menu_focus}
				{unfocus menu_unfocus}
				{pad_choose <menu_func> params = {song_name = ($current_song)difficulty = ($current_difficulty)difficulty2 = ($current_difficulty2)startTime = -1000000}}
			]
		}
	else
		marker_count = 0
		begin
			FormatText textname = menu_itemname "%m (%ss)" m = ($<marker_array> [<marker_count>].marker)s = (($<marker_array> [<marker_count>].time)/ 1000)
			CreateScreenElement {
				$debug_menu_params
				parent = skipbymarker_vmenu
				text = <menu_itemname>
				event_handlers = [
					{focus menu_focus}
					{unfocus menu_unfocus}
					{pad_choose restart_gem_scroller params = {song_name = ($current_song)difficulty = ($current_difficulty)difficulty2 = ($current_difficulty2)startTime = ($<marker_array> [<marker_count>].time)startmarker = <marker_count>}}
				]
			}
			marker_count = (<marker_count> + 1)
		repeat <array_Size>
	endif
	LaunchEvent \{Type = focus target = skipbymarker_vmenu}
endscript

script back_to_skipbymarker_menu
	create_skipbymarker_menu
endscript

script destroy_skipbymarker_menu
	if ScreenElementExists \{id = skipbymarker_scrolling_menu}
		DestroyScreenElement \{id = skipbymarker_scrolling_menu}
	endif
	//destroy_generic_backdrop
endscript

script create_skipbymeasure_menu
	ui_menu_select_sfx
	if GotParam \{looppoint}
		destroy_looppoint_menu
		callback = back_to_looppoint_menu
	else
		destroy_skipintosong_menu
		callback = back_to_skipintosong_menu
	endif
	//create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = skipbymeasure_scrolling_menu
		just = [left top]
		dims = (400.0, 250.0)
		Pos = ($menu_pos + (-30.0, 0.0))
	}
	CreateScreenElement {
		Type = VMenu
		parent = skipbymeasure_scrolling_menu
		id = skipbymeasure_vmenu
		Pos = (0.0, 0.0)
		just = [left top]
		event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}
			{pad_down generic_menu_up_or_down_sound params = {down}}
			{pad_back generic_menu_pad_back params = {callback = <callback>}}
		]
	}
	menu_func = select_start_song
	if GotParam \{looppoint}
		menu_func = set_looppoint
		CreateScreenElement {
			$debug_menu_params
			parent = skipbymeasure_vmenu
			text = "No Loop Point"
			event_handlers = [
				{focus menu_focus}
				{unfocus menu_unfocus}
				{pad_choose <menu_func> params = {startTime = -1000000}}
			]
		}
	endif
	ExtendCrc \{$current_song '_fretbars' out=fretbar_array}
	ExtendCrc \{$current_song '_timesig' out=timesig}
	GetArraySize $<timesig>
	timesig_entry = 0
	timesig_size = <array_Size>
	timesig_num = 0
	measure_count = 0
	GetArraySize $<fretbar_array>
	array_entry = 0
	fretbar_count = 0
	begin
		if (<timesig_entry> < <timesig_size>)
			if ($<timesig> [<timesig_entry>] [0] <= $<fretbar_array> [<array_entry>])
				<timesig_num> = ($<timesig> [<timesig_entry>] [1])
				fretbar_count = 0
				timesig_entry = (<timesig_entry> + 1)
			endif
		endif
		fretbar_count = (<fretbar_count> + 1)
		if (<fretbar_count> = <timesig_num>)
			measure_count = (<measure_count> + 1)
			fretbar_count = 0
		endif
		array_entry = (<array_entry> + 1)
	repeat <array_Size>
	if (<measure_count> > 150)
		measures_per_menuitem = 2
	else
		measures_per_menuitem = 1
	endif
	timesig_entry = 0
	measure_count = 0
	array_entry = 0
	fretbar_count = 0
	measures_per_menuitem_count = 0
	begin
		if (<timesig_entry> < <timesig_size>)
			if ($<timesig> [<timesig_entry>] [0] <= $<fretbar_array> [<array_entry>])
				<timesig_num> = ($<timesig> [<timesig_entry>] [1])
				fretbar_count = 0
				timesig_entry = (<timesig_entry> + 1)
			endif
		endif
		if (<fretbar_count> = 0)
			measures_per_menuitem_count = (<measures_per_menuitem_count> + 1)
			if (<measures_per_menuitem_count> = <measures_per_menuitem>)
				time = ($<fretbar_array> [(<array_entry>)])
				FormatText textname = menu_itemname "Measure %m (%ss)" s = (<time> / 1000.0)m = <measure_count>
				printf "%m" m = <menu_itemname>
				CreateScreenElement {
					$debug_menu_params
					parent = skipbymeasure_vmenu
					text = <menu_itemname>
					event_handlers = [
						{focus menu_focus}
						{unfocus menu_unfocus}
						{pad_choose <menu_func> params = {song_name = ($current_song)difficulty = ($current_difficulty)difficulty2 = ($current_difficulty2)startTime = <time>}}
					]
				}
				measures_per_menuitem_count = 0
			endif
		endif
		fretbar_count = (<fretbar_count> + 1)
		if (<fretbar_count> = <timesig_num>)
			measure_count = (<measure_count> + 1)
			fretbar_count = 0
		endif
		array_entry = (<array_entry> + 1)
	repeat <array_Size>
	LaunchEvent \{Type = focus target = skipbymeasure_vmenu}
endscript

script back_to_skipbymeasure_menu
	create_skipbymeasure_menu
endscript

script destroy_skipbymeasure_menu
	if ScreenElementExists \{id = skipbymeasure_scrolling_menu}
		DestroyScreenElement \{id = skipbymeasure_scrolling_menu}
	endif
	//destroy_generic_backdrop
endscript

script create_looppoint_menu
	ui_menu_select_sfx
	destroy_skipintosong_menu
	//create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = looppoint_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (20.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = looppoint_scrolling_menu id = looppoint_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_skipintosong_menu}}]}
	CreateScreenElement \{$debug_menu_params parent = looppoint_vmenu text = "Loop By Time" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_skipbytime_menu params = {looppoint}}]}
	CreateScreenElement \{$debug_menu_params parent = looppoint_vmenu text = "Loop By Marker" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_skipbymarker_menu params = {looppoint}}]}
	CreateScreenElement \{$debug_menu_params parent = looppoint_vmenu text = "Loop By Measure" event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_skipbymeasure_menu params = {looppoint}}]}
	LaunchEvent \{Type = focus target = looppoint_vmenu}
endscript

script back_to_looppoint_menu
	destroy_skipbytime_menu
	destroy_skipbymarker_menu
	destroy_skipbymeasure_menu
	create_looppoint_menu
endscript

script destroy_looppoint_menu
	if ScreenElementExists \{id = looppoint_scrolling_menu}
		DestroyScreenElement \{id = looppoint_scrolling_menu}
	endif
	//destroy_generic_backdrop
endscript

script set_looppoint
	ui_menu_select_sfx
	Change current_looppoint = <startTime>
	gh3_start_pressed
endscript

script create_replay_menu
	ui_menu_select_sfx
	destroy_debugging_menu
	//create_generic_backdrop
	x_pos = 450
	CreateScreenElement \{Type = VScrollingMenu parent = pause_menu id = replay_scrolling_menu just = [left top] dims = (400.0, 250.0) Pos = (450.0, 120.0)}
	CreateScreenElement \{Type = VMenu parent = replay_scrolling_menu id = replay_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_debug_menu}}]}
	StartWildcardSearch \{wildcard = 'REPLAYS\*.rep'}
	index = 0
	begin
		if NOT GetWildcardFile
			break
		endif
		CreateScreenElement {
			$debug_menu_params
			parent = replay_vmenu
			text = <basename>
			event_handlers = [
				{focus menu_focus}
				{unfocus menu_unfocus}
				{pad_choose restart_gem_scroller params = {replay = <FileName> song_name = "blah" difficulty = "blah" difficulty2 = "blah"}}
			]
		}
		<index> = (<index> + 1)
	repeat
	EndWildcardSearch
	LaunchEvent \{Type = focus target = replay_vmenu}
endscript

script destroy_replay_menu
	if ScreenElementExists \{id = replay_scrolling_menu}
		DestroyScreenElement \{id = replay_scrolling_menu}
	endif
	//destroy_generic_backdrop
endscript

script select_start_song
	Change \{current_transition = debugintro}
	SpawnScriptLater start_song params = <...>
	switch ($game_mode)
		case p1_career
			ui_flow_manager_respond_to_action \{play_sound = 0 action = set_p1_career}
		case p2_career
			ui_flow_manager_respond_to_action \{play_sound = 0 action = set_p2_career}
		case p1_quickplay
			ui_flow_manager_respond_to_action \{play_sound = 0 action = set_p1_quickplay}
		case p2_faceoff
		case p2_battle
		case p2_pro_faceoff
			ui_flow_manager_respond_to_action \{play_sound = 0 action = set_p2_general}
		case training
			ui_flow_manager_respond_to_action \{play_sound = 0 action = set_p1_training}
	endswitch
	destroy_all_debug_menus
endscript

script ui_menu_scroll_sfx
	SoundEvent \{event = ui_sfx_scroll}
	SoundEvent \{event = ui_sfx_scroll_add}
endscript

script ui_menu_select_sfx
	SoundEvent \{event = ui_sfx_select}
endscript

script menu_focus \{rgba = [255 255 255 255]}
	GetTags
	SetScreenElementProps id = <id> rgba = <rgba>
endscript

script menu_unfocus \{rgba = [127 127 127 191]}
	GetTags
	SetScreenElementProps id = <id> rgba = <rgba>
endscript
debug_menu_mode = 1

script switch_to_retail_menu
	destroy_all_debug_menus
	Change \{debug_menu_mode = 0}
	start_flow_manager
endscript

script switch_to_debug_menu
	shut_down_flow_manager
	Change \{debug_menu_mode = 1}
	destroy_all_debug_menus
	create_debugging_menu
endscript

script back_to_retail_ui_flow
	destroy_debugging_menu
	ui_flow_manager_respond_to_action \{action = go_back}
	enable_pause
endscript

script toggle_global
	if ($<#"0x00000000"> = 1)
		Change GlobalName = <#"0x00000000"> NewValue = 0
	else
		Change GlobalName = <#"0x00000000"> NewValue = 1
	endif
endscript
