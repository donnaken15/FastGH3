/*Z_Video_movie_viewport = {
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
}*///

movie_viewport = z_viewer_movie_viewport

script create_movie_viewport
	// pakman function that was originally here didn't return pakname on this branch for some reason
	// made me delusional for 5 hours
	movie_viewport = ($movie_viewport)
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
	movie_viewport = ($movie_viewport)
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

video_start_on_time = 0
video_looping = 0
video_hold_last_frame = 0
script preload_bgbink
	params = {}
	if ($video_looping = 0)
		params = { <params> no_looping }
	endif
	if ($video_hold_last_frame = 0)
		params = { <params> no_hold }
	endif
	stop_bgbink
	PreLoadMovie { movie = 'backgrnd_video' textureSlot = 2 TexturePri = -9999999 <params> } // non_blocking_seeking
endscript
script start_bgbink
	if isMoviePreLoaded \{textureSlot = 2}
		StartPreLoadedMovie \{textureSlot = 2}
	endif
endscript
script stop_bgbink
	if IsMoviePlaying \{textureSlot = 2}
		KillMovie \{textureSlot = 2}
	endif
endscript
script pause_bgbink
	if IsMoviePlaying \{textureSlot = 2}
		PauseMovie \{textureSlot = 2}
	endif
endscript
script unpause_bgbink
	if IsMoviePlaying \{textureSlot = 2}
		ResumeMovie \{textureSlot = 2}
		seek_bgbink
	endif
endscript
script seek_bgbink
	if ($try_fix_video_desync = 0)
		return
	endif
	if NOT IsMoviePlaying \{textureSlot = 2}
		return
	endif
	if ($estimate_video_fps = 0.0)
		return
	endif
	GetSongTimeMs
	MathPow ($estimate_video_fps / 30) exp = 2
	MathFloor ((((<time> + $video_start_on_time) / $estimate_video_fps) / 1.105) * <pow>)
	SeekMovie textureSlot = 2 frame = <floor> nowait
	//GetMovieFrame \{textureSlot = 2}
	//SeekMovie textureSlot = 2 frame = (<frame> - 1) nowait
endscript
script bgbink_calc_fps
	if ($try_fix_video_desync = 0)
		return
	endif
	//spawnscriptnow \{frame_display_test}
	begin
		if IsMoviePlaying \{textureSlot = 2}
			break
		endif
		Wait \{1 gameframe}
	repeat
	;begin
	;	GetMovieFrame \{textureSlot = 2}
	;	if (<frame> > 10)
	;		break
	;	endif
	;	Wait \{1 gameframe}
	;repeat
	sample_time = 0
	end_time = 10
	time = 0.0
	current_frame = 0
	array = [] // delta samples
	begin
		if NOT IsMoviePlaying \{textureSlot = 2}
			change \{estimate_video_fps = 0.0}
			return // in the case of restarting
		endif
		//ProfilingStart
		GetDeltaTime \{ignore_slomo}
		time = (<time> + <delta_time>)
		sample_time = (<sample_time> + <delta_time>)
		GetMovieFrame \{textureSlot = 2}
		if NOT (<current_frame> = <frame>)
			printf 'frame %f' f = <frame>
			time = (<time> * 1000000)
			CastToInteger \{time}
			AddArrayElement array=<array> element=<time>
			time = 0.0
			current_frame = <frame>
		endif
		//ProfilingEnd <...> 'bgbink_calc_fps' loop ____profiling_interval = ($fps_max)
		if (<sample_time> > <end_time>)
			break
		endif
		Wait \{1 gameframe}
	repeat
	Avg <array>
	change estimate_video_fps = (1 / (<avg> / 1000000))
	printstruct avg = <avg> fps = ($estimate_video_fps)
endscript
;script frame_display_test
;	if NOT ScreenElementExists \{id = frame_test}
;		CreateScreenElement {
;			type = TextElement
;			font = text_a1
;			pos = (90.0, 700.0)
;			just = [left bottom]
;			text = 'test'
;			scale = 0.7
;			rgba = [ 255 0 0 255 ]
;			parent = root_window
;			id = frame_test
;			font_spacing = -10
;			z_priority = 1000
;		}
;	endif
;	begin
;		if NOT IsMoviePlaying \{textureSlot = 2}
;			begin
;				if IsMoviePlaying \{textureSlot = 2}
;					break
;				endif
;				Wait \{1 gameframe}
;			repeat
;		endif
;		GetMovieFrame \{textureSlot = 2}
;		GetSongTimeMs
;		video_time = (<time> + $video_start_on_time)
;		MathFloor ((<video_time> / $estimate_video_fps) / 1.105)
;		MathPow ($estimate_video_fps / 30) exp = 2
;		if NOT ($estimate_video_fps = 0.0)
;			o = (<video_time> - <floor> * $estimate_video_fps)
;		else
;			o = 'n/a'
;		endif
;		FormatText {
;			textname = text 'TIME: %s, OFF: %o, FPS: %t, FRAME: %f, CALC SEEK: %c'
;			f = <frame> s = <video_time> o = <o> t = ($estimate_video_fps) c = (<floor> * <pow>)
;		}
;		SetScreenElementProps id = frame_test text = <text>
;		Wait \{1 gameframe}
;	repeat
;endscript
enable_video = 0
safe_to_seek = 0
estimate_video_fps = 0.0
try_fix_video_desync = 0
