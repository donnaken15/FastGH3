loading_screen_tips = [
	'Loading...'
	'LOADING'
	'LOADING THE LOADING'
	'<placeholder message>'
	'FPS: 9999999'
	'Made by donnaken15'
	'Nnnn gdgdga, KHH!'
	'lol'
	'LOL'
	'OMFG'
	'LMAO'
	'LMFAO'
	'ROFL'
	'OMGWTFBBQ'
	'Oh my good!'
	'As easy as one two three!'
	'Loadi- wait it already loaded.'
	'avg load time: 0ms'
	'\c4Fa\c2st\c5G\c3H\c63'
	'FASTER!'
	'BEATS POLYBIUS!'
	'DANNY DID IT FIRST'
	'TOBE DID IT FIRST'
	'WHY IS IT STILL LOADING?!'
	'\c2A\c6m\c5a\c4z\c8i\c3n\c7g\c1!'
	'harder, better, FASTER, stronger'
	'NOT FAST ENOUGH!'
	'GO!'
	'SPEED'
	'Follow @FastGH3 on Twitter for more updates.'
	'1.0 HOYP!!!'
	'Current version: 1.0-999010723'
	'NOW WITH CACHING!'
	'donnaken15.tk/fastgh3'
	'JURGEN IS HERE'
	'IMPOSSIBLE!'
	'fastfastfastfastfastfastfastfastfastfastfastfastfastfastfastfastfastfast'
	'fast'
	'NO LONGER WREAKING HAVOK'
	'PROGRAMMER SOX ARE LAME'
	'DIRECTLY CALLING OUT MY EX'
	'ONE CLICK MAGIC!'
	'you need more than debug\n- revup90'
	'\bf\bf\bc\bc\be\bd\be\bd\b2\b3\ba'
	'subscribe for daily \b2ideos'
	'Switch up the style and get yourself some c00l zonez by going to donnaken15.tk/fastgh3/zones.html'
	'6 MEGABYTE ZONES'
	'fastgh3'
	'FASTGH3'
	'C:\\windows\\fastgh3'
	''
	'the clone hero version of gh3'
	''
	'RUNNING ON APOCALYPSE'
	'start_gem_scroller()'
	'SALUTE TO THE SUN!!'
	'Now you can DOWNLOAD CHARTS THROUGH THIS GAME?! WHY DIDN\'T ANYONE THINK OF THIS!!'
	'5atu6w4zaw5atu6w4zaw5atu6w4zaw5atu6w4zaw'
	'IT\'S NOT FAST ENOUGH!'
	'MASSIVE ADBLOCK!'
	'SHE\'S TOO STONED! NINTENDO!'
	'I\nI\nO\n$\nV'
	'Aligning pointers...'
	''
	'ScreenShot Paused\n\b0\nScreen\b1\b2Drop	 \n\b3\nViewer'
	'For more fun with GH3 in general, check out progress on GH3+ at github.com/donnaken15/GH3-Plus'
	'4 PAK files? WHAT?!?'
	'ASPIRING TO REKT ASPYR'
	'FROM 4.7 GB TO 14.8 MB! WOW!'
	'Hey look, it works now! I think...'
	'IS THIS WORKING?!?!'
	'DON\'T CRASH!!'
	'SecuROM tried to kill Exile, but it failed, as HATRED struck it down, to the ground!'
	'Convenient!'
	'I got heX-ray mode on!'
	'New loading text for no reason!!'
	'Check out the FastGH3 settings for extra customization.'
	'Unlock even more fun by enabling Debug Menu in settings!'
	'I figured out..... I figured out animated textures. T/N: I did not figure out animated textures PSPS: I did (4 years later) PSPSPS: Actually, no PSPSPSPS: Actually, yes'
	'I bet you can\'t read this FAST enough!'
	'FC THIS!!!'
	'FIXED!'
	'BLOODY FAST\n100% No Slow Guaranteed'
	'I\'M RUNNING OUT OF THINGS TO SAY!'
	'YOU RESTARTED JUST TO SEE THIS MESSAGE!'
	'HAX!'
	'BOT!'
	'FAAAKE!!'
	'EPIC FAIL'
	'WHAT ARE YOU DOING'
	'WARNING: Requires x0.5 \b3 Presses'
	'unCHARTed'
	'\c9INVISIBLE INK'
	'are you actually reading these?'
	'CHARTS ON DEMAND'
	'FITS 4479 TIMES ON A FLASH DRIVE!'
	'uber song fc'
	'NAIL THE 540'
	'58,473 X 4\nStar Power + BS 360 Riff + Kissed the Sustain + FS Solo + FS 1440 GRYBRYBO'
	'ROCKING OUT IN THE ABYSS!!'
	'IN SECONDS!'
	'\c4ACCESS GRANTED'
	'sudo skate8.exe -gem_array fastgh3_song_expert'
	'It looks like you\'re trying to hit the note. Would you like help with:\n\b3 Strumming\n\b2 Holding down the frets'
	'!!!!!!! Guitarist not found !!!!!!!'
	'{UNKNOWN OPCODE 0}{UNKNOWN OPCODE 0}{UNKNOWN OPCODE 0}{UNKNOWN OPCODE 0}{UNKNOWN OPCODE 0}'
	'A.K.A: GH3DE, GH3DX, or GH3++'
	'__FASTcall void initGH3(int*)'
	'dummy'
	'Powered by Tony Hawk'
	'\c2I WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED'
]
g_loading_screen_split_container_id = id

script create_loading_screen\{mode = play_song}
	kill_start_key_binding
	if ($#"0x633e187f" = 1)
		return
	endif
	Change \{is_changing_levels = 1}
	GetArraySize ($loading_screen_tips)
	GetRandomValue name = rand_num a = 0 b = (<array_Size> - 1)integer
	rand_tip = ($loading_screen_tips [<rand_num>])
	if (<mode> = play_song || <mode> = play_encore || <mode> = play_boss || <mode> = restart_song)
		killspawnedscript \{name = jiggle_text_array_elements}
		if ScreenElementExists \{id = $#"0x0e5821a3"}
			DestroyScreenElement \{id = $#"0x0e5821a3"}
		endif
		PlayMovieFromBuffer {
			buffer_slot = <buffer_slot>
			textureSlot = 2
			no_hold
			wait_until_rendered
			TexturePri = 4999
		}
		CreateScreenElement {
			Type = TextBlockElement
			parent = root_window
			id = loading_tip_text
			text = <rand_tip>
			font = #"0x35c0114b"
			Scale = 0.9
			just = [center center]
			dims = (350.0, 480.0)
			Pos = (860.0, 300.0)
			rgba = [255 255 255 255]
			z_priority = 5000
			Shadow
			shadow_offs = (5.0, 5.0)
			shadow_rgba = [0 0 0 255]
		}
		split_text_into_array_elements \{text = "LOADING" text_pos = (400.0, 560.0) space_between = (40.0, 0.0) flags = {rgba = [255 255 255 255] Scale = 2.0 z_priority = 6000 font = #"0xba959ce0" just = [center center] alpha = 1}}
		Change g_loading_screen_split_container_id = <container_id>
		spawnscriptnow \{jiggle_text_array_elements params = {id = $#"0x0e5821a3" time = 1.0 wait_time = 3000 explode = 0}}
	else
		killspawnedscript \{name = destroy_loading_screen_spawned}
		CreateScreenElement \{Type = ContainerElement parent = root_window id = loading_screen_container Pos = (0.0, 0.0)}
		CreateScreenElement \{Type = SpriteElement parent = loading_screen_container texture = #"0xcbbcc379" Pos = (640.0, 360.0) just = [center center] dims = (1280.0, 720.0)}
	endif
endscript

script destroy_loading_screen
	destroy_menu \{menu_id = loading_tip_text}
	killspawnedscript \{name = jiggle_text_array_elements}
	if ScreenElementExists \{id = $#"0x0e5821a3"}
		DestroyScreenElement \{id = $#"0x0e5821a3"}
	endif
	spawnscriptnow \{destroy_loading_screen_spawned}
	HideLoadingScreen
	if ($playing_song = 0)
		Change \{is_changing_levels = 0}
	endif
endscript

script destroy_loading_screen_spawned\{time = 0.3}
	OnExitRun \{destroy_loading_screen_finish}
	if (<time> > 0)
		if ScreenElementExists \{id = menu_backdrop_container}
			DoScreenElementMorph id = menu_backdrop_container alpha = 0 time = <time>
		endif
		if ScreenElementExists \{id = loading_screen_container}
			DoScreenElementMorph id = loading_screen_container alpha = 0 time = <time>
		endif
		wait <time> seconds
	endif
endscript

script destroy_loading_screen_finish
	if ScreenElementExists \{id = loading_screen_container}
		DestroyScreenElement \{id = loading_screen_container}
	endif
	destroy_menu_backdrop
endscript

script refresh_screen
	destroy_loading_screen
	create_loading_screen
endscript