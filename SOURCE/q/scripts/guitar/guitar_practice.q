Practice_NoteMapping = [
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
]

script Practice_DummyFunction
	printf \{"Practice_DummyFunction"}
endscript
practice_font = fontgrid_title_gh3

script practicemode_init
	if NOT ($current_speedfactor = 1.0)
		SetNoteMappings \{section = drums mapping = $Practice_NoteMapping}
	endif
	Hide_Band
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
	ClearNoteMappings \{section = practice}
	killspawnedscript \{name = practicemode_section}
	if ScreenElementExists \{id = practice_container}
		DestroyScreenElement \{id = practice_container}
	endif
endscript
