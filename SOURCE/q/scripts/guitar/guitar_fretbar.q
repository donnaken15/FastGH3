thin_fretbar_timesigs = {
	t2d4 = $thin_fretbar_8note_params
	t3d4 = $thin_fretbar_8note_params
	t4d4 = $thin_fretbar_8note_params
	t5d4 = $thin_fretbar_8note_params
	t6d4 = $thin_fretbar_8note_params
	t3d8 = $thin_fretbar_16note_params
	t6d8 = $thin_fretbar_16note_params
	t12d8 = $thin_fretbar_16note_params
}
thin_fretbar_8note_params = {
	low_bpm = 1
	high_bpm = 180
}
thin_fretbar_16note_params = {
	low_bpm = 1
	high_bpm = 120
}
fretbar_prefix_type = {
	thin = 'thin'
	medium = 'medium'
	thick = 'thick'
}

script create_fretbar\{Scale = (40.0, 0.25)}
	Create2DFretbar <...>
	//if ($debug_showmeasures = ON)
	//	create_debug_measure_text <...>
	//endif
endscript

script fretbar_iterator
	fretbar_iterator_CFunc_Setup
	begin
		if fretbar_iterator_CFunc
			break
		endif
		wait \{1 gameframe}
	repeat
	fretbar_iterator_CFunc_Cleanup
endscript

script kill_fretbar2d
	if ScreenElementExists id = <fretbar_id>
		DestroyGem name = <fretbar_id>
	endif
endscript

script fretbar_events
	SetEventHandler response = switch_script event = kill_objects Scr = kill_fretbar2d params = {<...> }group = gem_group
endscript

script fretbar_update_tempo
	fretbar_update_tempo_CFunc_Setup
	begin
		if fretbar_update_tempo_CFunc
			break
		endif
		wait \{1 gameframe}
	repeat
	fretbar_update_tempo_CFunc_Cleanup
endscript

script fretbar_update_hammer_on_tolerance
	fretbar_update_hammer_on_tolerance_CFunc_Setup
	begin
		if fretbar_update_hammer_on_tolerance_CFunc
			break
		endif
		wait \{1 gameframe}
	repeat
	fretbar_update_hammer_on_tolerance_CFunc_Cleanup
endscript

/* // not working, why
script debugNoteCRC \{name = 'gem' color = 'green' array_entry = 0 player = 1}
	formattext checksumName = debug_id '%n_%d_%s_p%p' n = <name> d = <array_entry> s = <color> p = <player>
	//printf '%n_%d_%s_p%p' n = <name> d = <array_entry> s = <color> p = <player>
	// taking narrow blinded guess how this is generated in cfuncs for highway
	return debug_id = <debug_id>
endscript

script create_debug_measure_text
	debugNoteCRC name = 'fret' color = ($fretbar_prefix_type.<fretbar_scale>) array_entry = <array_entry> player = <player>
	//printstruct <...>
	fretbar_id = <debug_id>
	if NOT ScreenElementExists <fretbar_id>
		printf 'why'
		//printstruct <...>
	endif
	//if NOT (<fretbar_scale> = thick)
	//	return
	//endif
	if NOT ScreenElementExists \{id = hud_destroygroup_windowp1}
		return
	endif
	if NOT ScreenElementExists \{id = debug_measure_window}
		CreateScreenElement \{Type = ContainerElement parent = hud_destroygroup_windowp1 id = debug_measure_window Pos = (0.0, 0.0) just = [left top]}
	endif
	FormatText textname = measure_text "%i" i = <measure>
	FormatText checksumName = measure_checksum 'measuretext_%i' i = <measure>
	CreateScreenElement {
		Type = TextElement
		parent = debug_measure_window
		id = <measure_checksum>
		font = text_a1
		Pos = (200.0, 32.0)
		just = [center top]
		Scale = 1.0
		rgba = [210 210 210 250]
		text = <measure_text>
		z_priority = 1.0
	}
	spawnscriptnow move_debug_measure_text params = {<...> }id = debug_measure_text
endscript

script move_debug_measure_text
	begin
		if ScreenElementExists <fretbar_id>
			GetScreenElementPosition <fretbar_id>
			Pos = (<screenelementpos> + (2.0, 0.0))
			DoScreenElementMorph <measure_checksum> Pos = <Pos>
			wait \{1 gameframe}
		else
			DestroyScreenElement id = <measure_checksum>
			break
		endif
	repeat
endscript

script destroy_debug_measure_text
	if ScreenElementExists \{id = debug_measure_window}
		DestroyScreenElement \{id = debug_measure_window}
	endif
	killspawnedscript \{id = debug_measure_text}
endscript*/
