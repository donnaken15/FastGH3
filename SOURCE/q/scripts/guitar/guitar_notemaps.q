Drums_AutoNoteMapping = [
	{
		MidiNote = 70
		Scr = Countoff_NoteMap
		params = {
		}
	}
]
Crowd_AutoNoteMapping = [
	{
		MidiNote = 72
		Scr = EmptyScript
		params = {
		}
	}
]

script NoteMap_Dummy
	printf \{"dummy"}
endscript

script Countoff_NoteMap
	spawnscriptnow GH_SFX_Countoff_Logic params = {<...> }
endscript

script notemap_startiterator
	FormatText checksumName = global_notemapping '%s_AutoNoteMapping' s = <event_string>
	if NOT GlobalExists name = <global_notemapping> Type = array
		return
	endif
	FormatText checksumName = event_checksum '%s' s = <event_string>
	SetNoteMappings section = <event_checksum> mapping = $<global_notemapping>
	spawnscriptnow notemap_iterator params = {<...> }
endscript

script notemap_deinit
	ClearNoteMappings \{section = all}
	killspawnedscript \{name = notemap_iterator}
	killspawnedscript \{name = notemap_startiterator}
endscript

script notemap_iterator
	printf "Notemap Iterator started with time %d" d = <time_offset>
	get_song_prefix song = <song_name>
	FormatText checksumName = event_array '%s_%e_notes' s = <song_prefix> e = <event_string> AddToStringLookup
	if NOT GlobalExists name = <event_array> Type = array
		printf \{"No Drums Notes for Drums Iterator?"}
		return
	endif
	array_entry = 0
	fretbar_count = 0
	GetArraySize $<event_array>
	event_array_size = <array_Size>
	GetSongTimeMs time_offset = <time_offset>
	if NOT (<event_array_size> = 0)
		begin
			if ((<time> - <skipleadin>)< $<event_array> [<array_entry>] [0])
				break
			endif
			<array_entry> = (<array_entry> + 1)
		repeat <event_array_size>
		event_array_size = (<event_array_size> - <array_entry>)
		if NOT (<event_array_size> = 0)
			begin
				TimeMarkerReached_SetParams time_offset = <time_offset> array = <event_array> array_entry = <array_entry> ArrayOfArrays
				begin
					if TimeMarkerReached
						GetSongTimeMs time_offset = <time_offset>
						break
					endif
					wait \{1 gameframe}
				repeat
				TimeMarkerReached_ClearParams
				note = ($<event_array> [<array_entry>] [1])
				if GetNoteMapping section = <event_checksum> note = <note>
					GetArraySize ($<event_array> [<array_entry>])
					velocity = 100
					if (<array_Size> > 3)
						velocity = ($<event_array> [<array_entry>] [3])
					endif
					spawnscriptnow (<note_data>.Scr)params = {(<note_data>.params)length = ($<event_array> [<array_entry>] [2])velocity = <velocity>}
				endif
				<array_entry> = (<array_entry> + 1)
			repeat <event_array_size>
		endif
	endif
endscript
