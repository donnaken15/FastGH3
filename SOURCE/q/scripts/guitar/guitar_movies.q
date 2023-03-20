Z_Video_movie_viewport = {
	id = movie1_viewport
	texture = viewport9
	textureasset = None
	texdict = #"0x951bbad8"
	textureSlot = 0
	movie = 'encore_video_shoot'
	start_frame = 0
	loop_start = 0
	loop_end = -1
	viewport_style = cutscene_movie_surface
}
Z_Video_movie_viewport_ps3 = {
	id = movie1_viewport
	texture = viewport9
	textureasset = None
	texdict = #"0x951bbad8"
	textureSlot = 0
	movie = 'encore_video_shoot'
	start_frame = 0
	loop_start = 0
	loop_end = -1
	viewport_style = cutscene_movie_surface_ps3
}

script create_movie_viewport
	GetPakManCurrentName \{map = zones}
	if isps3
		FormatText checksumName = movie_viewport '%s_movie_viewport_ps3' s = <pakname>
	else
		FormatText checksumName = movie_viewport '%s_movie_viewport' s = <pakname>
	endif
	if NOT GlobalExists name = <movie_viewport>
		return
	endif
	CreateScreenElement {
		parent = root_window
		just = [center center]
		Type = ViewportElement
		id = ($<movie_viewport>.id)
		texture = ($<movie_viewport>.texture)
		Pos = (2000.0, 200.0)
		dims = (64.0, 64.0)
		alpha = 1
		style = ($<movie_viewport>.viewport_style)
	}
	SetSearchAllAssetContexts
	CreateViewportTextureOverride {
		id = ($<movie_viewport>.id)
		viewportid = ($<movie_viewport>.id)
		texture = ($<movie_viewport>.textureasset)
		texdict = ($<movie_viewport>.texdict)
	}
	SetSearchAllAssetContexts \{OFF}
endscript

script destroy_movie_viewport
	GetPakManCurrentName \{map = zones}
	FormatText checksumName = movie_viewport '%s_movie_viewport' s = <pakname>
	if NOT GlobalExists name = <movie_viewport>
		return
	endif
	KillMovie textureSlot = ($<movie_viewport>.textureSlot)
	if ScreenElementExists id = ($<movie_viewport>.id)
		SetSearchAllAssetContexts
		DestroyViewportTextureOverride id = ($<movie_viewport>.id)
		SetSearchAllAssetContexts \{OFF}
		DestroyScreenElement id = ($<movie_viewport>.id)
	endif
	killspawnedscript \{id = movie_scripts}
endscript

script PauseFullScreenMovie
	if IsMoviePlaying \{textureSlot = 0}
		PauseMovie \{textureSlot = 0}
	endif
endscript

script UnPauseFullScreenMovie
	if IsMoviePlaying \{textureSlot = 0}
		ResumeMovie \{textureSlot = 0}
	endif
endscript

script PlayMovieAndWait
	if NotCD
		if ($show_movies = 0)
			return
		endif
	endif
	mark_unsafe_for_shutdown
	if NOT GotParam \{noblack}
		fadetoblack \{On time = 0 alpha = 1.0 z_priority = -10}
	endif
	if NOT GotParam \{noletterbox}
		GetDisplaySettings
		if (<widescreen> = true)
			SetScreen \{hardware_letterbox = 0}
		else
			SetScreen \{hardware_letterbox = 1}
		endif
	endif
	printf "Playing Movie %s" s = <movie>
	PlayMovie {textureSlot = 0
		TexturePri = 1000
		no_looping
		no_hold
		<...> }
	wait \{2 gameframes}
	if GotParam \{noblack}
		fadetoblack \{OFF time = 0}
	endif
	NotHeld = 0
	begin
		if NOT IsMoviePlaying \{textureSlot = 0}
			break
		endif
		GetButtonsPressed \{StartAndA}
		if NOT (<makes> = 0)
			if (<NotHeld> = 1)
				KillMovie \{textureSlot = 0}
				break
			endif
		else
			NotHeld = 1
		endif
		wait \{1 gameframes}
	repeat
	if NOT GotParam \{noblack}
		wait \{2 gameframes}
		printf "Finished Playing Movie %s" s = <movie>
		fadetoblack \{OFF time = 0}
	endif
	if NOT GotParam \{noletterbox}
		SetScreen \{hardware_letterbox = 0}
	endif
	mark_safe_for_shutdown
endscript
#"0x89f66c79" = {
	#"0x071b048c"
	no_hold
}

script #"0x876d2a82"
	#"0x6f142d6a"
	movie = 'backgrnd_video'
	if NOT IsMovieInBuffer movie = <movie>
		buffer_slot = 0
		FreeMovieBuffer buffer_slot = <buffer_slot>
		if GotExtraMemory
			MemPushContext \{debugheap}
		endif
		AllocateMovieBuffer buffer_slot = <buffer_slot> movie = 'movies\bik\backgrnd_video.bik.xen'
		if GotExtraMemory
			MemPopContext
		endif
		LoadMovieIntoBuffer buffer_slot = <buffer_slot> movie = <movie>
	endif
endscript

script #"0x1debfd1e"
	params = $#"0x89f66c79"
	PlayMovieFromBuffer {
		buffer_slot = 0
		textureSlot = 2
		TexturePri = 0
		<params>
	}
endscript

script #"0x6f142d6a"
	if IsWinPort
		if IsMoviePlaying \{textureSlot = 2}
			KillMovie \{textureSlot = 2}
		endif
	endif
endscript

script #"0x3cfb4303"
	if IsMoviePlaying \{textureSlot = 2}
		PauseMovie \{textureSlot = 2}
	endif
endscript

script #"0x0c4cf76d"
	if IsMoviePlaying \{textureSlot = 2}
		ResumeMovie \{textureSlot = 2}
	endif
endscript
#"0x633e187f" = 0
