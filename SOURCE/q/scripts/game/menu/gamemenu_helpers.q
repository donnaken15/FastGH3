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
	GetArraySize \{$comp_texts}
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
	GetArraySize \{$comp_texts}
	<index> = 0
	begin
		<id> = ($comp_texts [<index>])
		if ObjectExists id = <id>
			DoScreenElementMorph id = <id> time = 0 Scale = 1
		endif
		<index> = (<index> + 1)
	repeat <array_Size>
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
	printf \{'generic_menu_pad_back Parameters = '}
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
	//printf \{'--- generic_menu_up_or_down_sound'}
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
	printf \{'here %s' s = $disable_menu_sounds}
	if ($disable_menu_sounds = 0)
		printf \{'sklajkjahsdflhasdlasdf'} // LOL
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
