/*Practice_NoteMapping = [
	{
		MidiNote = 60
		Scr = SoundEvent
		params = {
			event = Practice_Mode_Kick
		}
	}
	{
		MidiNote = 61
		Scr = SoundEvent
		params = {
			event = Practice_Mode_Tom3
		}
	}
	{
		MidiNote = 62
		Scr = SoundEvent
		params = {
			event = Practice_Mode_Tom2
		}
	}
	{
		MidiNote = 63
		Scr = SoundEvent
		params = {
			event = Practice_Mode_Tom1
		}
	}
	{
		MidiNote = 64
		Scr = SoundEvent
		params = {
			event = Practice_Mode_Snare
		}
	}
	{
		MidiNote = 65
		Scr = SoundEvent
		params = {
			event = Practice_Mode_HiHatClosed
		}
	}
	{
		MidiNote = 66
		Scr = SoundEvent
		params = {
			event = Practice_Mode_HiHatOpen
		}
	}
	{
		MidiNote = 67
		Scr = SoundEvent
		params = {
			event = Practice_Mode_Ride
		}
	}
	{
		MidiNote = 68
		Scr = SoundEvent
		params = {
			event = Practice_Mode_Crash1
		}
	}
	{
		MidiNote = 69
		Scr = SoundEvent
		params = {
			event = Practice_Mode_Crash2
		}
	}
]*///

script Practice_DummyFunction
	printf \{"Practice_DummyFunction"}
endscript
practice_font = fontgrid_title_gh3

script practicemode_init
	//if NOT ($current_speedfactor = 1.0)
		//SetNoteMappings \{section = drums mapping = $Practice_NoteMapping}
	//endif
	//Hide_Band
	CreateScreenElement \{Type = ContainerElement parent = root_window id = practice_container Pos = (0.0, 0.0)}
	CreateScreenElement {
		Type = TextElement
		parent = practice_container
		id = practice_sectiontext
		Scale = (1.100000023841858, 0.8999999761581421)
		Pos = (640.0, 160.0)
		font = ($practice_font)
		rgba = [255 255 255 255]
		alpha = 0
		just = [center top]
		z_priority = 3
	}
	spawnscriptnow \{practicemode_section}
endscript

script practicemode_section
	current_section_index = 0
	begin
		GetSongTimeMs
		if (<time> > $current_starttime)
			practice_sectiontext ::SetProps text = ($current_section_array [($current_section_array_entry)].marker)
			practice_sectiontext ::DoMorph \{alpha = 1.0 time = 0.5}
			current_section_index = ($current_section_array_entry)
			break
		endif
		wait \{1 gameframe}
	repeat
	begin
		GetSongTimeMs
		if (<time> > $current_endtime)
			practice_sectiontext ::DoMorph \{alpha = 0.0 time = 0.5}
			break
		elseif NOT (<current_section_index> = ($current_section_array_entry))
			practice_sectiontext ::DoMorph \{alpha = 0.0 time = 0.5}
			wait \{0.5 Second}
			practice_sectiontext ::SetProps text = ($current_section_array [($current_section_array_entry)].marker)
			practice_sectiontext ::DoMorph \{alpha = 1.0 time = 0.5}
			current_section_index = ($current_section_array_entry)
		endif
		wait \{1 gameframe}
	repeat
endscript

script practicemode_deinit
	//ClearNoteMappings \{section = practice}
	killspawnedscript \{name = practicemode_section}
	if ScreenElementExists \{id = practice_container}
		DestroyScreenElement \{id = practice_container}
	endif
endscript

practice_loop_modetext = ['Off' 'Section(s)' 'A>B (select to set B)' 'A>B']
script practice_loop_setprop \{text='UNKNOWN' id=practice_loop_button}
	FormatText textname=text 'Loop: %s' s=($practice_loop_modetext[$practice_loop_mode])
	SetScreenElementProps id=<id> text=<text>
endscript
practice_loop_mode = 0
script practice_loop_toggle
	SoundEvent \{event=ui_sfx_select}
	change practice_loop_mode=($practice_loop_mode+1)
	GetSongTimeMs
	CastToInteger \{songtime}
	if ($practice_loop_mode=0)
		Change disable_intro_originalsetting = ($disable_intro)
		change disable_intro = 1
	else
		Change disable_intro = ($disable_intro_originalsetting)
	endif
	if ($practice_loop_mode=2)
		change practice_loop_a = <time>
	endif
	if ($practice_loop_mode=3)
		change practice_loop_b = <time>
		if (($practice_loop_b - $practice_loop_a) < 1000)
			change \{practice_loop_mode=0}
			ui_flow_manager_respond_to_action \{action = select_loop_menu_3a}
		else
			ui_flow_manager_respond_to_action \{action = select_loop_menu_3b}
		endif
		return
	endif
	if ($practice_loop_mode>3)
		change \{practice_loop_mode=0}
	endif
	practice_loop_setprop
endscript
practice_loop_a = 0
practice_loop_b = 0
practice_ab_restart_fs = {
	create = create_loop_menu_3b
	Destroy = destroy_loop_menu_3b
	actions = [
		{
			action = continue
			func = practice_restart_song
			transition_screen = default_loading_screen
			flow_state = practice_play_song_fs
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
practice_loop_error_fs = {
	create = create_loop_menu_3a
	Destroy = destroy_popup_warning_menu
	actions = [
		{
			action = continue
			use_last_flow_state
		}
		{
			action = go_back
			use_last_flow_state
		}
	]
}
script create_loop_menu_3a
	disable_pause
	create_popup_warning_menu \{textblock = {text = "A>B loop cannot be less than a second." Pos = (640.0, 380.0)}player_device = $primary_controller menu_pos = (640.0, 465.0) dialog_dims = (275.0, 64.0) options = [{func = generic_respond_back text = 'OKAY'}]}
endscript
script create_loop_menu_3b
	disable_pause
	create_popup_warning_menu \{textblock = {text = "You have now set A>B points. Confirming will restart the song at point A. Do you wish to proceed?" Pos = (640.0, 380.0)}player_device = $primary_controller menu_pos = (640.0, 465.0) dialog_dims = (275.0, 64.0) options = [{func = practice_set_ab_mode text = "CONFIRM"}{func = practice_revert_ab_mode text = "CANCEL"}]}
endscript
script destroy_loop_menu_3b
	destroy_popup_warning_menu
endscript
script generic_respond_select
	ui_flow_manager_respond_to_action \{action = continue}
endscript
script generic_respond_back
	ui_flow_manager_respond_to_action \{action = go_back}
endscript
script practice_revert_ab_mode
	change \{practice_loop_mode=2}
	generic_respond_back
endscript
script practice_set_ab_mode
	change current_starttime = ($practice_loop_a) // |:|
	change practice_end_time = ($practice_loop_b)
	generic_respond_select
endscript

