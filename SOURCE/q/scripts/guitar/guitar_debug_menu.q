menu_pos = (675.0, 100.0)

script create_debugging_menu
	create_generic_backdrop
	CreateScreenElement \{Type = VScrollingMenu parent = pause_menu id = debug_scrolling_menu just = [left top] dims = (400.0, 480.0) Pos = $#"0xe787d761"}
	CreateScreenElement \{Type = VMenu parent = debug_scrolling_menu id = debug_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back back_to_retail_ui_flow}]}
	disable_pause
	CreateScreenElement \{Type = TextElement parent = debug_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Screenshot" z_priority = 100.0 just = [left top] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose playday_unlockall}]}
	CreateScreenElement \{Type = TextElement parent = debug_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Repeat Last Song" z_priority = 100.0 just = [left top] Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose select_start_song params = {uselaststarttime}}]}
	CreateScreenElement \{Type = TextElement parent = debug_vmenu id = toggle_playermode_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Play Song: 1p_quickplay" z_priority = 100.0 just = [left top] Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_left toggle_playermode_left}{pad_right toggle_playermode_right}{pad_choose select_playermode}]}
	toggle_playermode_setprop
	CreateScreenElement \{Type = TextElement parent = debug_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Settings" z_priority = 100.0 just = [left top] Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_settings_menu}]}
	CreateScreenElement \{Type = TextElement parent = debug_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Character Select" just = [left top] z_priority = 100.0 Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_character_viewer_menu}]}
	CreateScreenElement \{Type = TextElement parent = debug_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Skip Into Song" just = [left top] z_priority = 100.0 Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_skipintosong_menu}]}
	CreateScreenElement \{Type = TextElement parent = debug_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Save Replay Buffer" just = [left top] z_priority = 100.0 Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose save_replay}]}
	CreateScreenElement \{Type = TextElement parent = debug_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Load Replay" just = [left top] z_priority = 100.0 Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_replay_menu}]}
	CreateScreenElement \{Type = TextElement parent = debug_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Play Credits" just = [left top] z_priority = 100.0 Shadow shadow_offs = (3.0, 3.0) shadow_rgba = [0 0 0 255] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose debug_playcredits}]}
	LaunchEvent \{Type = focus target = debug_vmenu}
endscript

script destroy_debugging_menu
	if ScreenElementExists \{id = debug_scrolling_menu}
		DestroyScreenElement \{id = debug_scrolling_menu}
	endif
	destroy_generic_backdrop
endscript

script back_to_debug_menu
	destroy_replay_menu
	destroy_songversion_menu
	destroy_settings_menu
	destroy_character_viewer_menu
	destroy_skipintosong_menu
	destroy_cameracut_menu
	destroy_difficulty_menu
	destroy_skipbytime_menu
	destroy_skipbymarker_menu
	destroy_skipbymeasure_menu
	destroy_looppoint_menu
	create_debugging_menu
endscript

script destroy_all_debug_menus
	destroy_replay_menu
	destroy_songversion_menu
	destroy_settings_menu
	destroy_character_viewer_menu
	destroy_skipintosong_menu
	destroy_cameracut_menu
	destroy_difficulty_menu
	destroy_skipbytime_menu
	destroy_skipbymarker_menu
	destroy_skipbymeasure_menu
	destroy_looppoint_menu
	destroy_debugging_menu
endscript
debug_playcredits_active = 0

script debug_playcredits
endscript

script playday_unlockall
	get_song_title
	getsongtime
	FormatText textname = FileName 'screen_%s_%t' s = <song_title> t = <songtime>
	ScreenShot FileName = <FileName>
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
	create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = songversion_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (40.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = songversion_scrolling_menu id = songversion_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_debug_menu}}]}
	CreateScreenElement \{Type = TextElement parent = songversion_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Play GH3 Song" z_priority = 100.0 just = [left top] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_song_menu params = {version = gh3}}]}
	CreateScreenElement \{Type = TextElement parent = songversion_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Play GH2 Song" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_song_menu params = {version = gh2}}]}
	CreateScreenElement \{Type = TextElement parent = songversion_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Play GH1 Song" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_song_menu params = {version = gh1}}]}
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
	destroy_generic_backdrop
endscript

script create_song_menu\{version = gh3}
	ui_menu_select_sfx
	destroy_songversion_menu
	create_generic_backdrop
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
				Type = TextElement
				parent = song_vmenu
				font = #"0x45aae5c4"
				Scale = 0.75
				rgba = [210 210 210 250]
				text = <song_title>
				just = [left top]
				z_priority = 100.0
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
	destroy_generic_backdrop
endscript

script create_difficulty_menu
	destroy_song_menu
	destroy_difficulty_menu
	create_generic_backdrop
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
	GetArraySize \{$#"0x6c609315"}
	begin
		difficulty_count = ($difficulty_list [<array_entry>])
		get_difficulty_text difficulty = <difficulty_count>
		if (<Player> = 2)
			CreateScreenElement {
				Type = TextElement
				parent = difficulty_vmenu
				font = #"0x45aae5c4"
				Scale = 0.75
				rgba = [210 210 210 250]
				text = <difficulty_text>
				z_priority = 100.0
				just = [left top]
				event_handlers = [
					{focus menu_focus}
					{unfocus menu_unfocus}
					{pad_choose select_start_song params = {song_name = <song_name> difficulty2 = ($difficulty_list [<array_entry>])difficulty = <difficulty>}}
				]
			}
		else
			if ($current_num_players = 2)
				CreateScreenElement {
					Type = TextElement
					parent = difficulty_vmenu
					font = #"0x45aae5c4"
					Scale = 0.75
					rgba = [210 210 210 250]
					text = <difficulty_text>
					just = [left top]
					z_priority = 100.0
					event_handlers = [
						{focus menu_focus}
						{unfocus menu_unfocus}
						{pad_choose create_difficulty_menu params = {song_name = <song_name> version = <version> difficulty = ($difficulty_list [<array_entry>])Player = 2}}
					]
				}
			else
				CreateScreenElement {
					Type = TextElement
					parent = difficulty_vmenu
					font = #"0x45aae5c4"
					Scale = 0.75
					rgba = [210 210 210 250]
					text = <difficulty_text>
					just = [left top]
					z_priority = 100.0
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
	destroy_generic_backdrop
endscript

script create_settings_menu
	ui_menu_select_sfx
	destroy_debugging_menu
	create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = settings_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos - (30.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = settings_scrolling_menu id = settings_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_debug_menu}}]}
	CreateScreenElement \{Type = TextElement parent = settings_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Change Venue" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_changevenue_menu}]}
	CreateScreenElement \{Type = TextElement parent = settings_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Change Guitar" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_changeguitar_menu params = {Type = guitar}}]}
	CreateScreenElement \{Type = TextElement parent = settings_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Change Bass" just = [left top] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_changeguitar_menu params = {Type = bass}}]}
	CreateScreenElement \{Type = TextElement parent = settings_vmenu id = toggle_visibility_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Toggle visibility" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_togglevisibility_menu}]}
	CreateScreenElement \{Type = TextElement parent = settings_vmenu id = select_slomo_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Select Slomo : 1.0" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose select_slomo}]}
	select_slomo_setprop
	CreateScreenElement \{Type = TextElement parent = settings_vmenu id = toggle_showmeasures_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Show Measures" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_showmeasures}]}
	toggle_showmeasures_setprop
	CreateScreenElement \{Type = TextElement parent = settings_vmenu id = toggle_showcameraname_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Show Camera Name" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_showcameraname}]}
	toggle_showcameraname_setprop
	CreateScreenElement \{Type = TextElement parent = settings_vmenu id = toggle_inputlog_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Show Input Log" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_inputlog}]}
	toggle_inputlog_setprop
	CreateScreenElement \{Type = TextElement parent = settings_vmenu id = toggle_botp1_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Toggle Bot P1" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_botp1}]}
	toggle_botp1_setprop
	CreateScreenElement \{Type = TextElement parent = settings_vmenu id = toggle_botp2_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Toggle Bot P2" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_botp2}]}
	toggle_botp2_setprop
	CreateScreenElement \{Type = TextElement parent = settings_vmenu id = edit_inputlog_lines_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Input Log Lines" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_left edit_inputlog_lines_left}{pad_right edit_inputlog_lines_right}]}
	edit_inputlog_lines_setprop
	CreateScreenElement \{Type = TextElement parent = settings_vmenu id = toggle_tilt_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Show Input Log" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_tilt}]}
	toggle_tilt_setprop
	CreateScreenElement \{Type = TextElement parent = settings_vmenu id = toggle_leftyflip_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Leftyflip" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_leftyflip}]}
	toggle_leftyflip_setprop
	CreateScreenElement \{Type = TextElement parent = settings_vmenu id = create_cameracut_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Select CameraCut" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_cameracut_menu}]}
	CreateScreenElement \{Type = TextElement parent = settings_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Toggle GPU Time" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_global params = {global_toggle = show_gpu_time}}]}
	CreateScreenElement \{Type = TextElement parent = settings_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Toggle CPU Time" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_global params = {global_toggle = show_cpu_time}}]}
	CreateScreenElement \{Type = TextElement parent = settings_vmenu id = toggle_forcescore_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Force Score" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_forcescore}]}
	toggle_forcescore_setprop
	LaunchEvent \{Type = focus target = settings_vmenu}
endscript

script back_to_settings_menu
	destroy_changevenue_menu
	destroy_changehighway_menu
	destroy_changeguitar_menu
	destroy_togglevisibility_menu
	destroy_cameracut_menu
	create_settings_menu
endscript

script destroy_settings_menu
	if ScreenElementExists \{id = settings_scrolling_menu}
		DestroyScreenElement \{id = settings_scrolling_menu}
	endif
	destroy_generic_backdrop
endscript
CameraCutPrefixArray = [
	''
]

script create_cameracut_menu
	ui_menu_select_sfx
	destroy_settings_menu
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = selectcameracut_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos - (30.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = selectcameracut_scrolling_menu id = selectcameracut_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_settings_menu}}]}
	CreateScreenElement \{Type = TextElement parent = selectcameracut_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "off" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose select_cameracut params = {Camera_Array_pakname = None Camera_Array = None array_count = None}}]}
	GetPakManCurrentName \{map = zones}
	camera_count = 0
	GetArraySize \{$#"0x1e755dd6"}
	camera_array_size = <array_Size>
	begin
		FormatText checksumName = Camera_Array '%s_%p' s = <pakname> p = ($CameraCutPrefixArray [<camera_count>])
		if GlobalExists name = <Camera_Array>
			GetArraySize $<Camera_Array>
			array_count = 0
			begin
				FormatText textname = Camera_Name "%s_%p_%i" s = <pakname> p = ($CameraCutPrefixArray [<camera_count>])i = <array_count>
				if StructureContains structure = ($<Camera_Array> [<array_count>])name
					FormatText textname = Camera_Name "%s" s = ($<Camera_Array> [<array_count>].name)DontAssertForChecksums
				elseif StructureContains structure = ($<Camera_Array> [<array_count>])params
					if StructureContains structure = ($<Camera_Array> [<array_count>].params)name
						FormatText textname = Camera_Name "%s" s = ($<Camera_Array> [<array_count>].params.name)DontAssertForChecksums
					endif
				endif
				CreateScreenElement {
					Type = TextElement
					parent = selectcameracut_vmenu
					font = #"0x45aae5c4"
					Scale = 0.75
					rgba = [210 210 210 250]
					text = <Camera_Name>
					z_priority = 100.0
					just = [left top]
					event_handlers = [
						{focus menu_focus}
						{unfocus menu_unfocus}
						{pad_choose select_cameracut params = {Camera_Array_pakname = <pakname> Camera_Array = ($CameraCutPrefixArray [<camera_count>])array_count = <array_count>}}
						{pad_square select_cameracut params = {Camera_Array_pakname = <pakname> Camera_Array = ($CameraCutPrefixArray [<camera_count>])array_count = <array_count> jumptoviewer}}
					]
				}
				<array_count> = (<array_count> + 1)
			repeat <array_Size>
		endif
		camera_count = (<camera_count> + 1)
	repeat <camera_array_size>
	LaunchEvent \{Type = focus target = selectcameracut_vmenu}
endscript

script back_to_cameracut_menu
	create_cameracut_menu
endscript

script destroy_cameracut_menu
	if ScreenElementExists \{id = selectcameracut_scrolling_menu}
		DestroyScreenElement \{id = selectcameracut_scrolling_menu}
	endif
	destroy_generic_backdrop
endscript
debug_camera_array = None
debug_camera_array_pakname = None
debug_camera_array_count = 0

script select_cameracut
	ui_menu_select_sfx
	Change debug_camera_array = <Camera_Array>
	Change debug_camera_array_pakname = <Camera_Array_pakname>
	Change debug_camera_array_count = <array_count>
	destroy_cameracuts
	wait \{3 gameframes}
	create_cameracuts
	if GotParam \{jumptoviewer}
		destroy_all_debug_menus
		unpausegh3
		enable_pause
		Change \{viewer_buttons_enabled = 1}
		ToggleViewMode
	endif
endscript

script create_character_viewer_menu
	ui_menu_select_sfx
	destroy_debugging_menu
	create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = character_viewer_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos - (30.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = character_viewer_scrolling_menu id = character_viewer_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_debug_menu}}]}
	CreateScreenElement \{Type = TextElement parent = character_viewer_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Change Guitarist" z_priority = 100.0 just = [left top] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_changeguitarist_menu}]}
	CreateScreenElement \{Type = TextElement parent = character_viewer_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Change Bassist" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_changebassist_menu}]}
	CreateScreenElement \{Type = TextElement parent = character_viewer_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Change Vocalist" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_changevocalist_menu}]}
	CreateScreenElement \{Type = TextElement parent = character_viewer_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Change Drummer" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_changedrummer_menu}]}
	LaunchEvent \{Type = focus target = character_viewer_vmenu}
endscript

script back_to_character_viewer_menu
	destroy_changeguitarist_menu
	destroy_changebassist_menu
	destroy_changevocalist_menu
	destroy_changedrummer_menu
	create_character_viewer_menu
endscript

script destroy_character_viewer_menu
	if ScreenElementExists \{id = character_viewer_scrolling_menu}
		DestroyScreenElement \{id = character_viewer_scrolling_menu}
	endif
	destroy_generic_backdrop
endscript

script create_changeguitarist_menu
	ui_menu_select_sfx
	destroy_character_viewer_menu
	create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = changeguitarist_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (70.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = changeguitarist_scrolling_menu id = changeguitarist_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_character_viewer_menu}}]}
	get_musician_profile_size
	index = 0
	begin
		get_musician_profile_struct index = <index>
		Type = (<profile_struct>.Type)
		if ((<Type> = GUITARIST)|| (<Type> = any))
			CreateScreenElement {
				Type = TextElement
				parent = changeguitarist_vmenu
				font = #"0x45aae5c4"
				Scale = 0.75
				rgba = [210 210 210 250]
				text = (<profile_struct>.fullname)
				just = [left top]
				z_priority = 100.0
				event_handlers = [
					{focus menu_focus}
					{unfocus menu_unfocus}
					{pad_choose debug_menu_choose_guitarist params = {index = <index>}}
				]
			}
		endif
		index = (<index> + 1)
	repeat <array_Size>
	LaunchEvent \{Type = focus target = changeguitarist_vmenu}
endscript

script destroy_changeguitarist_menu
	if ScreenElementExists \{id = changeguitarist_scrolling_menu}
		DestroyScreenElement \{id = changeguitarist_scrolling_menu}
	endif
	destroy_generic_backdrop
endscript

script debug_menu_choose_guitarist
	kill_gem_scroller
	get_musician_profile_struct index = <index>
	FormatText checksumName = guitarist_id '%s' s = (<profile_struct>.name)
	Change StructureName = player1_status character_id = <guitarist_id>
	if NOT create_guitarist \{useoldpos}
		DownloadContentLost
	endif
	restart_gem_scroller song_name = ($current_song)difficulty = ($current_difficulty)difficulty2 = ($current_difficulty2)startTime = ($current_starttime)device_num = <device_num>
endscript

script create_changebassist_menu
	ui_menu_select_sfx
	destroy_character_viewer_menu
	create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = changebassist_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (70.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = changebassist_scrolling_menu id = changebassist_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_character_viewer_menu}}]}
	get_musician_profile_size
	index = 0
	begin
		get_musician_profile_struct index = <index>
		Type = (<profile_struct>.Type)
		if ((<Type> = BASSIST)|| (<Type> = any))
			CreateScreenElement {
				Type = TextElement
				parent = changebassist_vmenu
				font = #"0x45aae5c4"
				Scale = 0.75
				rgba = [210 210 210 250]
				text = (<profile_struct>.name)
				just = [left top]
				z_priority = 100.0
				event_handlers = [
					{focus menu_focus}
					{unfocus menu_unfocus}
					{pad_choose create_bassist params = {profile_name = (<info_struct>.name)useoldpos}}
				]
			}
		endif
		index = (<index> + 1)
	repeat <array_Size>
	LaunchEvent \{Type = focus target = changebassist_vmenu}
endscript

script destroy_changebassist_menu
	if ScreenElementExists \{id = changebassist_scrolling_menu}
		DestroyScreenElement \{id = changebassist_scrolling_menu}
	endif
	destroy_generic_backdrop
endscript

script create_changevocalist_menu
	ui_menu_select_sfx
	destroy_character_viewer_menu
	create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = changevocalist_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (70.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = changevocalist_scrolling_menu id = changevocalist_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_character_viewer_menu}}]}
	get_musician_profile_size
	index = 0
	begin
		get_musician_profile_struct index = <index>
		Type = (<profile_struct>.Type)
		if ((<Type> = vocalist)|| (<Type> = any))
			CreateScreenElement {
				Type = TextElement
				parent = changevocalist_vmenu
				font = #"0x45aae5c4"
				Scale = 0.75
				rgba = [210 210 210 250]
				text = (<profile_struct>.name)
				just = [left top]
				z_priority = 100.0
				event_handlers = [
					{focus menu_focus}
					{unfocus menu_unfocus}
					{pad_choose create_vocalist params = {profile_name = (<info_struct>.name)useoldpos}}
				]
			}
		endif
		index = (<index> + 1)
	repeat <array_Size>
	LaunchEvent \{Type = focus target = changevocalist_vmenu}
endscript

script destroy_changevocalist_menu
	if ScreenElementExists \{id = changevocalist_scrolling_menu}
		DestroyScreenElement \{id = changevocalist_scrolling_menu}
	endif
	destroy_generic_backdrop
endscript

script create_changedrummer_menu
	ui_menu_select_sfx
	destroy_character_viewer_menu
	create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = changedrummer_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (70.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = changedrummer_scrolling_menu id = changedrummer_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_character_viewer_menu}}]}
	get_musician_profile_size
	index = 0
	begin
		get_musician_profile_struct index = <index>
		Type = (<profile_struct>.Type)
		if ((<Type> = drummer)|| (<Type> = any))
			CreateScreenElement {
				Type = TextElement
				parent = changedrummer_vmenu
				font = #"0x45aae5c4"
				Scale = 0.75
				rgba = [210 210 210 250]
				text = (<profile_struct>.name)
				just = [left top]
				z_priority = 100.0
				event_handlers = [
					{focus menu_focus}
					{unfocus menu_unfocus}
					{pad_choose create_drummer params = {profile_name = (<info_struct>.name)useoldpos}}
				]
			}
		endif
		index = (<index> + 1)
	repeat <array_Size>
	LaunchEvent \{Type = focus target = changedrummer_vmenu}
endscript

script destroy_changedrummer_menu
	if ScreenElementExists \{id = changedrummer_scrolling_menu}
		DestroyScreenElement \{id = changedrummer_scrolling_menu}
	endif
	destroy_generic_backdrop
endscript

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
	setslomo \{$#"0x16d91bc1"}
	setslomo_song \{slomo = $#"0x16d91bc1"}
	Player = 1
	begin
		FormatText checksumName = player_status 'player%i_status' i = <Player>
		Change StructureName = <player_status> check_time_early = ($check_time_early * $current_speedfactor)
		Change StructureName = <player_status> check_time_late = ($check_time_late * $current_speedfactor)
		Player = (<Player> + 1)
	repeat $current_num_players
endscript

script select_slomo_setprop
	FormatText \{textname = slomo_text "Select Slomo : %s" s = $#"0x16d91bc1"}
	select_slomo_menuitem ::SetProps text = <slomo_text>
endscript
debug_showmeasures = OFF

script toggle_showmeasures
	ui_menu_select_sfx
	if ($debug_showmeasures = OFF)
		Change \{debug_showmeasures = On}
	else
		Change \{debug_showmeasures = OFF}
	endif
	toggle_showmeasures_setprop
endscript

script toggle_showmeasures_setprop
	if ($debug_showmeasures = OFF)
		toggle_showmeasures_menuitem ::SetProps \{text = "Show Measures : off"}
	else
		toggle_showmeasures_menuitem ::SetProps \{text = "Show Measures : on"}
	endif
endscript
debug_showcameraname = OFF

script toggle_showcameraname
	ui_menu_select_sfx
	if ScreenElementExists \{id = debug_camera_name_text}
		DestroyScreenElement \{id = debug_camera_name_text}
	endif
	if ($debug_showcameraname = OFF)
		Change \{debug_showcameraname = On}
		CreateScreenElement \{Type = TextElement parent = root_window id = debug_camera_name_text font = #"0x45aae5c4" Pos = (640.0, 32.0) just = [center top] Scale = 1.0 rgba = [210 210 210 250] text = "Camera Name" z_priority = 100.0 z_priority = 1.0 alpha = 1}
	else
		Change \{debug_showcameraname = OFF}
	endif
	toggle_showcameraname_setprop
	CameraCuts_UpdateDebugCameraName
endscript

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

script toggle_showcameraname_setprop
	if ($debug_showcameraname = OFF)
		toggle_showcameraname_menuitem ::SetProps \{text = "Show Camera Name : off"}
	else
		toggle_showcameraname_menuitem ::SetProps \{text = "Show Camera Name : on"}
	endif
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
	GetGlobalTags \{user_options}
	if (<lefty_flip_p1> = 0)
		SetGlobalTags \{user_options params = {lefty_flip_p1 = 1}}
	else
		SetGlobalTags \{user_options params = {lefty_flip_p1 = 0}}
	endif
	GetGlobalTags \{user_options}
	Change StructureName = <player_status> lefthanded_gems = <lefty_flip_p1>
	Change StructureName = <player_status> lefthanded_button_ups = <lefty_flip_p1>
	toggle_leftyflip_setprop
endscript

script toggle_leftyflip_setprop
	GetGlobalTags \{user_options}
	if (<lefty_flip_p1> = 0)
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

script create_changevenue_menu
	ui_menu_select_sfx
	destroy_settings_menu
	create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = changevenue_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (70.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = changevenue_scrolling_menu id = changevenue_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_settings_menu}}]}
	get_LevelZoneArray_size
	array_count = 0
	begin
		get_LevelZoneArray_checksum index = <array_count>
		CreateScreenElement {
			Type = TextElement
			parent = changevenue_vmenu
			font = #"0x45aae5c4"
			Scale = 0.75
			rgba = [210 210 210 250]
			text = ($LevelZones.<level_checksum>.title)
			just = [left top]
			z_priority = 100.0
			event_handlers = [
				{focus menu_focus}
				{unfocus menu_unfocus}
				{pad_choose select_venue params = {level = <level_checksum> norestart}}
			]
		}
		<array_count> = (<array_count> + 1)
	repeat <array_Size>
	LaunchEvent \{Type = focus target = changevenue_vmenu}
endscript

script back_to_changevenue_menu
	create_changevenue_menu
endscript

script destroy_changevenue_menu
	if ScreenElementExists \{id = changevenue_scrolling_menu}
		DestroyScreenElement \{id = changevenue_scrolling_menu}
	endif
	destroy_generic_backdrop
endscript

script select_venue
	ui_menu_select_sfx
	kill_gem_scroller
	ResetWaypoints
	if GotParam \{level}
		Change current_level = <level>
	endif
	SetPakManCurrentBlock \{map = zones pak = None block_scripts = 1}
	ChangeNodeFlag \{LS_3_5_PRE 1}
	ChangeNodeFlag \{LS_3_5_POST 0}
	ChangeNodeFlag \{LS_ENCORE_PRE 1}
	ChangeNodeFlag \{LS_ENCORE_POST 0}
	Load_Venue \{block_scripts = 1}
	setup_bg_viewport
	restore_dummy_bg_camera
	disable_bg_viewport_properties
	create_movie_viewport
	if ($current_level = load_z_testlevel_peds)
		spawnscriptnow \{testlevel_debug}
	else
		if NOT create_band
			DownloadContentLost
		endif
		create_crowd_models
		crowd_reset \{player_status = player1_status Player = 1}
	endif
	enable_pause
	restore_start_key_binding
	if NOT GotParam \{norestart}
		gh3_start_pressed
		restart_gem_scroller song_name = ($current_song)difficulty = ($current_difficulty)difficulty2 = ($current_difficulty2)startTime = ($current_starttime)device_num = <device_num>
	else
		ToggleViewMode
		ToggleViewMode
	endif
endscript

script testlevel_debug
	begin
		if ControllerMake \{Circle 0}
			next_peds
		endif
		if ControllerMake \{Circle 1}
			next_peds
		endif
		wait \{1 gameframe}
	repeat
endscript
debug_ped_row = 0

script next_peds
	kill \{prefix = Z_TestLevel_Peds_Row0}
	kill \{prefix = Z_TestLevel_Peds_Row1}
	kill \{prefix = Z_TestLevel_Peds_Row2}
	kill \{prefix = Z_TestLevel_Peds_Row3}
	kill \{prefix = Z_TestLevel_Peds_Row4}
	kill \{prefix = Z_TestLevel_Peds_Row5}
	kill \{prefix = Z_TestLevel_Peds_Row6}
	kill \{prefix = Z_TestLevel_Peds_Row7}
	wait \{1 gameframe}
	begin
		Change debug_ped_row = ($debug_ped_row + 1)
		FormatText checksumName = row 'Z_TestLevel_Peds_row%r' r = ($debug_ped_row)
		create prefix = <row>
		if IsAlive prefix = <row>
			break
		else
			Change \{debug_ped_row = -1}
		endif
	repeat
endscript

script back_to_changehighway_menu
	create_changehighway_menu
endscript

script destroy_changehighway_menu
	if ScreenElementExists \{id = changehighway_scrolling_menu}
		DestroyScreenElement \{id = changehighway_scrolling_menu}
	endif
	destroy_generic_backdrop
endscript

script create_changeguitar_menu\{Type = guitar}
	ui_menu_select_sfx
	destroy_settings_menu
	create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = changeguitar_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (70.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = changeguitar_scrolling_menu id = changeguitar_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_settings_menu}}]}
	get_musician_instrument_size
	array_count = 0
	begin
		get_musician_instrument_struct index = <array_count>
		if (<Type> = (<info_struct>.Type))
			printf "Creating %i" i = (<info_struct>.name)
			CreateScreenElement {
				Type = TextElement
				parent = changeguitar_vmenu
				font = #"0x45aae5c4"
				Scale = 0.75
				rgba = [210 210 210 250]
				text = (<info_struct>.name)
				just = [left top]
				z_priority = 100.0
				event_handlers = [
					{focus menu_focus}
					{unfocus menu_unfocus}
					{pad_choose select_guitar params = {guitar = <array_count> Type = <Type>}}
				]
			}
		endif
		<array_count> = (<array_count> + 1)
	repeat <array_Size>
	LaunchEvent \{Type = focus target = changeguitar_vmenu}
endscript

script back_to_changeguitar_menu
	create_changeguitar_menu
endscript

script destroy_changeguitar_menu
	if ScreenElementExists \{id = changeguitar_scrolling_menu}
		DestroyScreenElement \{id = changeguitar_scrolling_menu}
	endif
	destroy_generic_backdrop
endscript

script select_guitar\{Type = guitar}
	ui_menu_select_sfx
	kill_gem_scroller
	if (<Type> = guitar)
		get_musician_instrument_struct index = <guitar>
		Change StructureName = player1_status instrument_id = (<info_struct>.desc_id)
	else
		get_musician_instrument_struct index = <guitar>
		Change current_bass_model = (<info_struct>.desc_id)
	endif
	select_start_song
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
	create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = togglevisibility_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (70.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = togglevisibility_scrolling_menu id = togglevisibility_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_settings_menu}}]}
	CreateScreenElement \{Type = TextElement parent = togglevisibility_vmenu id = toggle_bandvisible_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Toggle band" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_bandvisible}]}
	toggle_bandvisible_setprop
	GetArraySize \{$#"0x8e8106d0"}
	array_count = 0
	begin
		FormatText checksumName = type_checksum '%s' s = ($HideByType_List [<array_count>])
		FormatText checksumName = menuitem_checksum 'toggle_hidebytype_menuitem_%s' s = ($HideByType_List [<array_count>])
		CreateScreenElement {
			Type = TextElement
			parent = togglevisibility_vmenu
			id = <menuitem_checksum>
			font = #"0x45aae5c4"
			Scale = 0.75
			rgba = [210 210 210 250]
			text = ""
			just = [left top]
			z_priority = 100.0
			event_handlers = [
				{focus menu_focus}
				{unfocus menu_unfocus}
				{pad_choose toggle_hidebytype params = {Type = type_checksum array_count = <array_count>}}
			]
		}
		array_count = (<array_count> + 1)
	repeat <array_Size>
	toggle_hidebytype_setprop
	CreateScreenElement \{Type = TextElement parent = togglevisibility_vmenu id = toggle_highway_menuitem font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Toggle highway" z_priority = 100.0 just = [left top] event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose toggle_highway}]}
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
	destroy_generic_backdrop
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
	ui_menu_select_sfx
	if ($bandvisible = OFF)
		Change \{bandvisible = On}
	else
		Change \{bandvisible = OFF}
	endif
	set_bandvisible
	toggle_bandvisible_setprop
endscript

script set_bandvisible
	if ($bandvisible = OFF)
		if CompositeObjectExists \{GUITARIST}
			GUITARIST ::Hide
		endif
		if CompositeObjectExists \{vocalist}
			vocalist ::Hide
		endif
		if CompositeObjectExists \{BASSIST}
			BASSIST ::Hide
		endif
		if CompositeObjectExists \{drummer}
			drummer ::Hide
		endif
	else
		if CompositeObjectExists \{GUITARIST}
			GUITARIST ::unhide
		endif
		if CompositeObjectExists \{vocalist}
			vocalist ::unhide
		endif
		if CompositeObjectExists \{BASSIST}
			BASSIST ::unhide
		endif
		if CompositeObjectExists \{drummer}
			drummer ::unhide
		endif
	endif
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
	GetArraySize \{$#"0x8e8106d0"}
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
	GetArraySize \{$#"0x8e8106d0"}
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
	create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = skipintosong_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (20.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = skipintosong_scrolling_menu id = skipintosong_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_debug_menu}}]}
	CreateScreenElement \{Type = TextElement parent = skipintosong_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Skip By Time" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_skipbytime_menu}]}
	CreateScreenElement \{Type = TextElement parent = skipintosong_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Skip By Marker" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_skipbymarker_menu}]}
	CreateScreenElement \{Type = TextElement parent = skipintosong_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Skip By Measure" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_skipbymeasure_menu}]}
	CreateScreenElement \{Type = TextElement parent = skipintosong_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Set Loop Point" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_looppoint_menu}]}
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
	destroy_generic_backdrop
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
	create_generic_backdrop
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
			Type = TextElement
			parent = skipbytime_vmenu
			font = #"0x45aae5c4"
			Scale = 0.75
			rgba = [210 210 210 250]
			text = "No Loop Point"
			just = [left top]
			z_priority = 100.0
			event_handlers = [
				{focus menu_focus}
				{unfocus menu_unfocus}
				{pad_choose <menu_func> params = {startTime = -1000000}}
			]
		}
	endif
	get_song_prefix song = ($current_song)
	FormatText checksumName = fretbar_array '%s_fretbars' s = <song_prefix> AddToStringLookup
	GetArraySize $<fretbar_array>
	max_time = (($<fretbar_array> [(<array_Size> - 1)])/ 1000)
	current_time = 0
	begin
		FormatText textname = menu_itemname "Time %ss" s = <current_time>
		if (<current_time> < <max_time>)
			CreateScreenElement {
				Type = TextElement
				parent = skipbytime_vmenu
				font = #"0x45aae5c4"
				Scale = 0.75
				rgba = [210 210 210 250]
				text = <menu_itemname>
				just = [left top]
				z_priority = 100.0
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
	destroy_generic_backdrop
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
	create_generic_backdrop
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
			Type = TextElement
			parent = skipbymarker_vmenu
			font = #"0x45aae5c4"
			Scale = 0.75
			rgba = [210 210 210 250]
			text = "No Loop Point"
			just = [left top]
			z_priority = 100.0
			event_handlers = [
				{focus menu_focus}
				{unfocus menu_unfocus}
				{pad_choose <menu_func> params = {startTime = -1000000}}
			]
		}
	endif
	get_song_prefix song = ($current_song)
	FormatText checksumName = marker_array '%s_markers' s = <song_prefix>
	GetArraySize $<marker_array>
	if (<array_Size> = 0)
		CreateScreenElement {
			Type = TextElement
			parent = skipbymarker_vmenu
			font = #"0x45aae5c4"
			Scale = 0.75
			rgba = [210 210 210 250]
			text = "start"
			just = [left top]
			z_priority = 100.0
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
				Type = TextElement
				parent = skipbymarker_vmenu
				font = #"0x45aae5c4"
				Scale = 0.75
				rgba = [210 210 210 250]
				text = <menu_itemname>
				just = [left top]
				z_priority = 100.0
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
	destroy_generic_backdrop
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
	create_generic_backdrop
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
			Type = TextElement
			parent = skipbymeasure_vmenu
			font = #"0x45aae5c4"
			Scale = 0.75
			rgba = [210 210 210 250]
			text = "No Loop Point"
			just = [left top]
			z_priority = 100.0
			event_handlers = [
				{focus menu_focus}
				{unfocus menu_unfocus}
				{pad_choose <menu_func> params = {startTime = -1000000}}
			]
		}
	endif
	get_song_prefix song = ($current_song)
	FormatText checksumName = fretbar_array '%s_fretbars' s = <song_prefix> AddToStringLookup
	FormatText checksumName = timesig '%s_timesig' s = <song_prefix> AddToStringLookup
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
					Type = TextElement
					parent = skipbymeasure_vmenu
					font = #"0x45aae5c4"
					Scale = 0.75
					rgba = [210 210 210 250]
					text = <menu_itemname>
					just = [left top]
					z_priority = 100.0
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
	destroy_generic_backdrop
endscript

script create_looppoint_menu
	ui_menu_select_sfx
	destroy_skipintosong_menu
	create_generic_backdrop
	CreateScreenElement {
		Type = VScrollingMenu
		parent = pause_menu
		id = looppoint_scrolling_menu
		just = [left top]
		dims = (400.0, 480.0)
		Pos = ($menu_pos + (20.0, 0.0))
	}
	CreateScreenElement \{Type = VMenu parent = looppoint_scrolling_menu id = looppoint_vmenu Pos = (0.0, 0.0) just = [left top] event_handlers = [{pad_up generic_menu_up_or_down_sound params = {up}}{pad_down generic_menu_up_or_down_sound params = {down}}{pad_back generic_menu_pad_back params = {callback = back_to_skipintosong_menu}}]}
	CreateScreenElement \{Type = TextElement parent = looppoint_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Loop By Time" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_skipbytime_menu params = {looppoint}}]}
	CreateScreenElement \{Type = TextElement parent = looppoint_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Loop By Marker" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_skipbymarker_menu params = {looppoint}}]}
	CreateScreenElement \{Type = TextElement parent = looppoint_vmenu font = #"0x45aae5c4" Scale = 0.75 rgba = [210 210 210 250] text = "Loop By Measure" just = [left top] z_priority = 100.0 event_handlers = [{focus menu_focus}{unfocus menu_unfocus}{pad_choose create_skipbymeasure_menu params = {looppoint}}]}
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
	destroy_generic_backdrop
endscript

script set_looppoint
	ui_menu_select_sfx
	Change current_looppoint = <startTime>
	gh3_start_pressed
endscript

script create_replay_menu
	ui_menu_select_sfx
	destroy_debugging_menu
	create_generic_backdrop
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
			Type = TextElement
			parent = replay_vmenu
			font = #"0x45aae5c4"
			Scale = 0.75
			rgba = [210 210 210 250]
			text = <basename>
			just = [left top]
			z_priority = 100.0
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
	destroy_generic_backdrop
endscript

script select_start_song
	Change \{current_transition = debugintro}
	SpawnScriptLater start_song params = <...>
	switch ($game_mode)
		case p1_career
			ui_flow_manager_respond_to_action \{action = set_p1_career}
		case p2_career
			ui_flow_manager_respond_to_action \{action = set_p2_career}
		case p1_quickplay
			ui_flow_manager_respond_to_action \{action = set_p1_quickplay}
		case p2_faceoff
		case p2_battle
		case p2_pro_faceoff
			ui_flow_manager_respond_to_action \{action = set_p2_general}
		case training
			ui_flow_manager_respond_to_action \{action = set_p1_training}
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

script menu_focus
	GetTags
	printstruct <...>
	SetScreenElementProps id = <id> rgba = [210 130 0 250]
endscript

script menu_unfocus
	GetTags
	SetScreenElementProps id = <id> rgba = [210 210 210 250]
endscript
debug_menu_mode = 1

script switch_to_retail_menu
	destroy_all_debug_menus
	Change debug_menu_mode = (0)
	start_flow_manager
endscript

script switch_to_debug_menu
	shut_down_flow_manager
	Change debug_menu_mode = (1)
	destroy_all_debug_menus
	create_debugging_menu
endscript

script back_to_retail_ui_flow
	destroy_debugging_menu
	ui_flow_manager_respond_to_action \{action = go_back}
	enable_pause
endscript

script toggle_global
	printstruct <...>
	if GotParam \{global_toggle}
		if ($<global_toggle> = 1)
			Change GlobalName = <global_toggle> NewValue = 0
		else
			Change GlobalName = <global_toggle> NewValue = 1
		endif
	endif
endscript
