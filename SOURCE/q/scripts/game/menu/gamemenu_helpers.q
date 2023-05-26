Default_Font_Colors = [
	[
		200
		200
		200
		255
	]
	[
		180
		80
		80
		255
	]
	[
		80
		120
		180
		255
	]
	[
		80
		180
		120
		255
	]
	[
		180
		140
		60
		255
	]
	[
		200
		100
		40
		255
	]
	[
		140
		100
		180
		255
	]
	[
		0
		180
		180
		255
	]
	[
		0
		0
		0
		255
	]
	[
		40
		40
		40
		255
	]
	[
		90
		90
		90
		255
	]
	[
		140
		140
		140
		255
	]
]
bedroom_select_skater = came_from_new_life
lens_flare_visible_before_pause = 1
is_changing_levels = 0

script handle_pause_continue
	root_window ::GetTags
	if GotParam \{pause_controller}
		if NOT (<pause_controller> = <device_num>)
			return
		endif
	endif
	unpause_game_and_destroy_pause_menu
endscript

script pause_game_and_create_pause_menu
	do_actual_pause <...>
	ui_change_state \{state = Uistate_pausemenu}
endscript

script do_actual_pause
	printf \{"--- do_actual_pause"}
	if NOT CD
		DumpProgressLog
	endif
	if NOT InNetGame
		printf \{"-------------------- PAUSING GAME ----------------------"}
		PauseGame
		GMan_PauseAllGoals
	endif
	if ScreenElementExists \{id = root_window}
		SetScreenElementProps \{id = root_window tags = {menu_state = On}}
	endif
	if InNetGame
		if NOT IsObserving
			if ObjectExists \{id = skater}
				skater ::NetDisablePlayerInput
			endif
		endif
		EnableActuators \{0}
	endif
	if InSplitScreenGame
		EnableActuators \{0}
	endif
	Change \{viewer_buttons_enabled = 0}
endscript

script unpause_game_and_destroy_pause_menu
	printf \{"--- unpause_game_and_destroy_pause_menu"}
	do_actual_unpause <...>
	printf \{"unpause_game_and_destroy_pause_menu 1"}
	ui_change_state \{state = Uistate_gameplay}
	printf \{"unpause_game_and_destroy_pause_menu 2"}
endscript

script do_actual_unpause
	printf \{"--- do_actual_unpause"}
	Change \{check_for_unplugged_controllers = 0}
	ClearViewerObject
	Debounce \{X time = 0.3}
	Debounce \{Triangle time = 0.3}
	Debounce \{Circle time = 0.3}
	Debounce \{Square time = 0.3}
	pause_menu_gradient \{OFF}
	Change \{inside_pause = 0}
	Change \{no_focus_sound = 1}
	if InNetGame
		if NOT IsObserving
			if ObjectExists \{id = skater}
				skater ::NetEnablePlayerInput
			endif
		endif
		EnableActuators \{1}
	endif
	if InSplitScreenGame
		EnableActuators \{1}
	endif
	if NOT InNetGame
		printf \{'-------------------- UNPAUSING GAME ----------------------'}
		UnPauseGame
	endif
	PauseStream \{0}
	PauseMusic \{0}
	GMan_UnPauseAllGoals
	if NOT InNetGame
		if NOT GameModeEquals \{is_horse}
			unpauseskaters
		endif
	endif
	if GMan_HasActiveGoals
		GMan_ToggleAllGoalTriggers \{Hide = 1}
	endif
	Change \{check_for_unplugged_controllers = 1}
	if ScreenElementExists \{id = root_window}
		SetScreenElementProps \{id = root_window tags = {menu_state = OFF}}
	endif
	Change \{viewer_buttons_enabled = 1}
endscript

script enable_new_ui_system
	MemPushContext \{AIHeap}
	RegisterBehaviors_Debug
	RegisterBehaviors_RunScript
	RegisterBehaviors_RunBehavior
	MemPopContext
	RegisterUIBehaviors
endscript
ui_controller_which_paused = 0

script handle_start_pressed
	if NOT RenderingEnabled
		return
	endif
	if IsTrue \{$#"0x39899380"}
		printf \{"handle_start_pressed: $paused_for_hardware is true, ending"}
		return
	endif
	if IsTrue \{$#"0x75cb7691"}
		printf \{"handle_start_pressed: $sysnotify_wait_in_progress is true, ending"}
		return
	endif
	if ($is_changing_levels = 1)
		printf \{"handle_start_pressed: $is_changing_levels is true, ending"}
		return
	endif
	if IsTrue \{$#"0x81927cef"}
		printf \{"handle_start_pressed: $ingame_save_active is true, ending"}
		return
	endif
	if InFrontEnd
		printf \{"handle_start_pressed: InFrontEnd is true, ending"}
		return
	endif
	root_window ::GetTags
	Change ui_controller_which_paused = <device_num>
	if checksumequals a = <menu_state> b = On
		if GotParam \{pause_controller}
			if NOT (<pause_controller> = -1)
				if NOT (<device_num> = <pause_controller>)
					return
				endif
			endif
		endif
		do_actual_unpause
		broadcastevent \{Type = event_unpause_game}
		ui_change_state \{state = Uistate_gameplay}
		Change \{inside_pause = 0}
	endif
	if checksumequals a = <menu_state> b = OFF
		if NOT InMultiPlayerGame
			if NOT ControllerBoundToSkater controller = <device_num> skater = 0
				return
			endif
		else
			if InSplitScreenGame
				if NOT ControllerBoundToSkater controller = <device_num> skater = 0
					if NOT ControllerBoundToSkater controller = <device_num> skater = 1
						return
					endif
				endif
			endif
		endif
		if InNetGame
			if NOT ControllerBoundToSkater controller = <device_num> skater = 0
				return
			endif
		endif
		SetTags pause_controller = <device_num>
		if NOT InNetGame
			GetSkaterId
			if GetSkaterCamAnimParams skater = <objID>
				if (<allow_pause> = 0)
					return
				endif
			endif
		endif
		broadcastevent \{Type = event_pause_game}
		if GMan_GoalIsActive \{goal = m_pro_burnquist}
			wait \{2 gameframe}
		endif
		do_actual_pause
		set_pause_menu_allow_continue
		if InTraining
			ui_change_state \{state = UIState_Training_PauseMenu}
		else
			ui_change_state \{state = Uistate_pausemenu}
		endif
	endif
endscript

script set_pause_menu_allow_continue
	if GotParam \{OFF}
		root_window ::SetTags \{no_exit_pause_menu = 1}
	else
		root_window ::RemoveTags \{tags = [no_exit_pause_menu]}
	endif
endscript

script set_custom_restart
	if NOT skater ::InAir
		skater ::SetCustomRestart \{Set}
	endif
endscript

script skip_to_custom_restart
	skater ::SkipToCustomRestart
endscript

script set_sub_bg\{parent = current_menu_anchor Pos = (326.0, 115.0) Scale = (1.1700000762939453, 1.100000023841858) just = [center top]}
	CreateScreenElement {
		Type = SpriteElement
		parent = <parent>
		texture = options_bg
		draw_behind_parent
		Pos = <Pos>
		Scale = <Scale>
		just = <just>
		rgba = [128 128 128 128]
		z_priority = 1
	}
endscript

script hide_everything
	DoScreenElementMorph \{id = root_window time = 0 Scale = 0}
endscript

script unhide_everything
	DoScreenElementMorph \{id = root_window time = 0 Scale = 1}
endscript
hide_all_hud_sprites = $WhyAmIBeingCalled
hide_all_hud_items = $WhyAmIBeingCalled
show_all_hud_sprites = $WhyAmIBeingCalled
show_all_hud_items = $WhyAmIBeingCalled
hide_speech_boxes = $WhyAmIBeingCalled
unhide_speech_boxes = $WhyAmIBeingCalled
kill_speech_boxes = $WhyAmIBeingCalled
hide_landing_msg = $WhyAmIBeingCalled
unhide_landing_msg = $WhyAmIBeingCalled
hide_3d_goal_arrow = $WhyAmIBeingCalled
unhide_3d_goal_arrow = $WhyAmIBeingCalled
hide_net_scores = $WhyAmIBeingCalled
unhide_net_scores = $WhyAmIBeingCalled
hide_current_goal = $WhyAmIBeingCalled
comp_texts = [
	Eric_Text
	Ron_Text
	Johnny_Text
	Chicken_Text
	Raven_Text
	final_scores
	goal_comp_out_of_bounds_warning
]

script hide_comp_text
	GetArraySize \{$#"0x27365d4e"}
	<index> = 0
	begin
		<id> = ($comp_texts [<index>])
		if ObjectExists id = <id>
			DoScreenElementMorph id = <id> time = 0 Scale = 0
		endif
		<index> = (<index> + 1)
	repeat <array_Size>
endscript

script unhide_comp_text
	GetArraySize \{$#"0x27365d4e"}
	<index> = 0
	begin
		<id> = ($comp_texts [<index>])
		if ObjectExists id = <id>
			DoScreenElementMorph id = <id> time = 0 Scale = 1
		endif
		<index> = (<index> + 1)
	repeat <array_Size>
endscript

script unhide_current_goal
	if ObjectExists \{id = current_goal}
		DoScreenElementMorph \{id = current_goal time = 0 Scale = 0.83}
	endif
	if ObjectExists \{id = mp_goal_text}
		DoScreenElementMorph \{id = mp_goal_text time = 0 Scale = 0.83}
	endif
	if ObjectExists \{id = sc_goal_text}
		DoScreenElementMorph \{id = sc_goal_text time = 0 Scale = 0.83}
	endif
	if ObjectExists \{id = Eric_score}
		DoScreenElementMorph \{id = Eric_score time = 0 Scale = 0.83}
	endif
endscript

script hide_death_msg
	if ObjectExists \{id = death_message}
		DoScreenElementMorph \{id = death_message time = 0 Scale = 0}
	endif
endscript

script unhide_death_msg
	if ObjectExists \{id = death_message}
		DoScreenElementMorph \{id = death_message time = 0 Scale = 1}
	endif
endscript

script hide_tips
	if ObjectExists \{id = skater_hint}
		DoScreenElementMorph \{id = skater_hint time = 0 Pos = (320.0, 11050.0)}
	endif
endscript

script unhide_tips
	if ObjectExists \{id = skater_hint}
		DoScreenElementMorph \{id = skater_hint time = 0 Pos = (320.0, 150.0)}
	endif
endscript

script menu_quit_no
	generic_menu_pad_back_sound
	dialog_box_exit
	pause_game_and_create_pause_menu
endscript

script change_gamemode_career
	printf \{"********** CHANGING GAME MODE TO CAREER"}
	EnableSun
	SetGameType \{career}
	SetCurrentGameType
	CareerFunc \{func = SetAppropriateNodeFlags}
endscript

script change_gamemode_classic
	printf \{"********** CHANGING GAME MODE TO CLASSIC"}
	EnableSun
	SetGameType \{classic}
	SetCurrentGameType
	CareerFunc \{func = SetAppropriateNodeFlags}
endscript

script change_gamemode_coop
	printf \{"********** CHANGING GAME MODE TO CO-OP"}
	EnableSun
	SetGameType \{coop}
	SetCurrentGameType
	CareerFunc \{func = SetAppropriateNodeFlags}
endscript

script change_gamemode_net
	printf \{"********** CHANGING GAME MODE TO NET!!!"}
	DisableSun
	SetGameType \{net}
	SetCurrentGameType
	CareerFunc \{func = SetAppropriateNodeFlags}
endscript

script change_gamemode_singlesession
	EnableSun
	SetGameType \{singlesession}
	SetCurrentGameType
	CareerFunc \{func = SetAppropriateNodeFlags}
endscript

script change_gamemode_freeskate_2p
	DisableSun
	SetGameType \{freeskate2p}
	SetCurrentGameType
	CareerFunc \{func = SetAppropriateNodeFlags}
endscript

script animate_in
	SetButtonEventMappings \{block_menu_input}
	SetScreenElementProps \{id = root_window tags = {menu_state = entering}}
	LaunchEvent Type = focus target = <menu_id>
	DoMorph \{time = 0.05 rot_angle = 3 Pos = (40.0, 0.0) alpha = 1}
	DoMorph \{time = 0.01 rot_angle = 0 Pos = (10.0, 0.0)}
	SetScreenElementProps \{id = root_window tags = {menu_state = On}}
	if NOT GotParam \{dont_unblock}
		SetButtonEventMappings \{unblock_menu_input}
	endif
endscript

script menu_onscreen\{menu_id = current_menu_anchor}
	DoMorph \{Scale = 1 time = 0}
	if GotParam \{Pos}
		DoMorph Pos = <Pos>
	endif
	SetProps \{just = [center center]}
	GetTags
	if GotParam \{focus_child}
		LaunchEvent Type = focus target = <menu_id> data = {child_id = <focus_child>}
	else
		LaunchEvent Type = focus target = <id>
	endif
	if NOT GotParam \{preserve_menu_state}
		SetScreenElementProps \{id = root_window tags = {menu_state = On}}
	endif
endscript

script animate_out\{menu_id = current_menu_anchor}
	SetButtonEventMappings \{block_menu_input}
	SetScreenElementProps \{id = root_window tags = {menu_state = leaving}}
	GetTags
	SetProps \{just = [center center]}
	DoMorph \{time = 0 Scale = 1.0}
	DoMorph \{time = 0.3 alpha = 0}
	SetScreenElementProps \{id = root_window tags = {menu_state = OFF}}
	SetScreenElementLock \{id = root_window OFF}
	DestroyScreenElement id = <menu_id>
	SetButtonEventMappings \{unblock_menu_input}
endscript

script menu_offscreen
	SetScreenElementProps \{id = root_window tags = {menu_state = OFF}}
	SetScreenElementLock \{id = root_window OFF}
	GetTags
	LaunchEvent Type = unfocus target = <id>
	DestroyScreenElement id = <id> recurse
endscript

script hide_root_window
	SetScreenElementProps \{id = root_window Hide}
endscript

script unhide_root_window
	SetScreenElementProps \{id = root_window unhide}
endscript

script generic_menu_update_arrows\{menu_id = current_menu}
	if NOT ObjectExists id = <up_arrow_id>
		return
	endif
	if NOT ObjectExists id = <down_arrow_id>
		return
	endif
	if <menu_id> ::Menu_SelectedIndexIs first
		SetScreenElementProps {
			id = <up_arrow_id>
			rgba = [128 128 128 0]
		}
	else
		SetScreenElementProps {
			id = <up_arrow_id>
			rgba = [128 128 128 128]
		}
	endif
	if <menu_id> ::Menu_SelectedIndexIs LAST
		SetScreenElementProps {
			id = <down_arrow_id>
			rgba = [128 128 128 0]
		}
	else
		SetScreenElementProps {
			id = <down_arrow_id>
			rgba = [128 128 128 128]
		}
	endif
endscript

script generic_menu_pad_back
	printf \{"generic_menu_pad_back Parameters = "}
	generic_menu_pad_back_sound
	if GotParam \{callback}
		<callback> <...>
	endif
endscript

script generic_menu_pad_choose
	if GotParam \{callback}
		<callback> <...>
	endif
endscript

script generic_menu_pad_back_sound
endscript

script generic_menu_pad_up_down_sound
endscript

script generic_menu_pad_choose_sound
	SoundEvent \{event = ui_sfx_select}
endscript
disable_menu_sounds = 0

script generic_menu_up_or_down_sound\{menu_id = current_menu}
	//printf \{"--- generic_menu_up_or_down_sound"}
	if ($disable_menu_sounds = 0)
		SoundEvent \{event = ui_sfx_scroll}
		SoundEvent \{event = ui_sfx_scroll_add}
	endif
endscript

script generic_menu_scroll_sideways_sound
	if ($disable_menu_sounds = 0)
		SoundEvent \{event = Generic_menu_pad_sideways_SFX}
	endif
endscript

script generic_keyboard_sound
endscript

script theme_menu_pad_choose_sound
	SoundEvent \{event = Generic_menu_pad_choose_SFX}
endscript

script generic_pause_exit_sound
	SoundEvent \{event = Generic_menu_pad_back_SFX}
endscript

script videophone_menu_up_or_down_sound\{menu_id = current_menu}
	if ($disable_menu_sounds = 0)
		if GotParam \{up}
			SoundEvent \{event = VP_menu_pad_up_SFX}
		endif
		if GotParam \{down}
			SoundEvent \{event = VP_menu_pad_down_SFX}
		endif
	endif
endscript

script Videophone_pad_back_sound
	SoundEvent \{event = VP_menu_pad_back_SFX}
endscript

script Videophone_pad_choose_sound
	SoundEvent \{event = VP_menu_pad_Select_SFX}
endscript

script cas_menu_pad_choose_sound
	SoundEvent \{event = CAS_menu_pad_choose_SFX}
endscript

script cas_menu_up_or_down_sound\{menu_id = current_menu}
	if ($disable_menu_sounds = 0)
		if GotParam \{up}
			SoundEvent \{event = CAS_menu_pad_up_SFX}
		endif
		if GotParam \{down}
			SoundEvent \{event = CAS_menu_pad_down_SFX}
		endif
	endif
endscript

script menu_audio_settings_band_volume_sound
	if ($disable_menu_sounds = 0)
		SoundEvent \{event = ui_sfx_bandvol}
	endif
endscript

script menu_audio_settings_guitar_volume_sound
	if ($disable_menu_sounds = 0)
		SoundEvent \{event = ui_sfx_guitvol}
	endif
endscript

script menu_audio_settings_fx_volume_sound
	if ($disable_menu_sounds = 0)
		SoundEvent \{event = ui_sfx_crowdvol}
	endif
endscript

script menu_video_settings_lefty_flip_sound
	if ($disable_menu_sounds = 0)
		SoundEvent \{event = Box_Check_SFX}
	endif
endscript

script menu_video_settings_calibrate_strum_sound
	if ($disable_menu_sounds = 0)
		generic_menu_up_or_down_sound
	endif
endscript

script menu_video_settings_calibrate_reset_to_zero_sound
	if ($disable_menu_sounds = 0)
		SoundEvent \{event = ui_sfx_select}
	endif
endscript

script menu_song_complete_sound
	if ($disable_menu_sounds = 0)
		SoundEvent \{event = ui_sfx_select}
	endif
endscript

script menu_get_sponsor_sound
	if ($disable_menu_sounds = 0)
		SoundEvent \{event = ui_sfx_select}
	endif
endscript

script menu_setlist_bonus_tab_sound
	printf \{"here %s" s = $#"0x409c5191"}
	if ($disable_menu_sounds = 0)
		printf \{"sklajkjahsdflhasdlasdf"}
		SoundEvent \{event = ui_sfx_select}
	endif
endscript

script menu_setlist_downloads_tab_sound
	if ($disable_menu_sounds = 0)
		SoundEvent \{event = ui_sfx_select}
	endif
endscript

script menu_setlist_setlist_tab_sound
	if ($disable_menu_sounds = 0)
		SoundEvent \{event = ui_sfx_select}
	endif
endscript

script reset_gamemode
	ResetToDefaultProfile \{name = custom_story}
	CareerFunc \{func = reset}
	if ObjectExists \{id = skater}
		skater ::RecordComponent_ResetComponent
	endif
	GMan_ResetCareer
	CareerFunc \{func = SetAppropriateNodeFlags}
	training_reset_checkpoints
	UnsetGlobalFlag \{flag = $#"0xa80886a9"}
	GetArraySize \{$#"0x9fea7c63"}
	index = 0
	begin
		printf "clearing global flag %d" d = ($STORY_CLEAR_GLOBAL_FLAGS [<index>])
		UnsetGlobalFlag flag = ($STORY_CLEAR_GLOBAL_FLAGS [<index>])
		<index> = (<index> + 1)
	repeat <array_Size>
	if GetGlobalFlag \{flag = $#"0xfe89f0d9"}
		cheat_unlock_the_vans
	endif
endscript

script generic_menu_animate_in\{menu = current_menu_anchor}
	if GotParam \{Force}
		<menu> ::SetTags animate_me = 1
	else
		if NOT <menu> ::GetSingleTag animate_me
			return
		endif
	endif
	if GotParam \{Pos}
		ScreenElementPos = <Pos>
	else
		GetScreenElementPosition id = <menu>
	endif
	DoScreenElementMorph id = <menu> Pos = (<ScreenElementPos> + (640.0, 0.0))time = 0
	DoScreenElementMorph id = <menu> Pos = <ScreenElementPos> time = 0.15
	if NOT GotParam \{no_wait}
		wait \{0.2 seconds}
	endif
endscript

script generic_menu_animate_out\{menu = current_menu_anchor}
	if GotParam \{Force}
		<menu> ::SetTags animate_me = 1
	endif
	if NOT <menu> ::GetSingleTag animate_me
		return
	endif
	if GotParam \{Pos}
		ScreenElementPos = <Pos>
	else
		GetScreenElementPosition id = <menu>
	endif
	DoScreenElementMorph id = <menu> Pos = (<ScreenElementPos> + (640.0, 0.0))time = 0.15
	wait \{0.2 seconds}
endscript

script generic_animate_out_last_menu
	if ObjectExists \{id = current_menu}
		if current_menu ::GetSingleTag \{animate_me}
			generic_menu_animate_out \{menu = current_menu}
			return
		endif
	endif
	if ObjectExists \{id = current_menu_anchor}
		if current_menu_anchor ::GetSingleTag \{animate_me}
			generic_menu_animate_out
			return
		endif
	endif
	if ObjectExists \{id = sub_menu}
		if sub_menu ::GetSingleTag \{animate_me}
			generic_menu_animate_out \{Force menu = sub_menu Pos = (320.0, 240.0)}
			return
		endif
	endif
endscript

script RunScriptOnScreenElement_script
	RunScriptOnScreenElement <...>
endscript
