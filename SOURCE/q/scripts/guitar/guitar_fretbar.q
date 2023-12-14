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
