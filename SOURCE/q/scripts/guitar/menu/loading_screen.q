loading_screen_tips = []
g_loading_screen_split_container_id = id

script create_loading_strings
	GetArraySize \{$loading_screen_tips}
	if NOT (<array_size> = 0)
		return
	endif
	change loading_screen_tips = [
		'Loading...' 'LOADING' 'LOADING THE LOADING' '<placeholder message>'
		'FPS: 999999999999' 'Made by donnaken15' 'Nnnn gdgdga, KHH!'
		'lol' 'LOL' 'OMFG' 'LMAO' 'LMFAO' 'ROFL' 'OMGWTFBBQ' 'Oh my good!'
		'As easy as one two three!' 'Loadi- wait it already loaded.' 'avg load time: 0ms'
		'\c4Fa\c2st\c5G\c3H\c63' 'FASTER!' 'BEATS POLYBIUS!' 'DANNY DID IT FIRST' 'TOBE DID IT FIRST'
		'WHY IS IT STILL LOADING?!' '\c2A\c6m\c5a\c4z\c8i\c3n\c7g\c1!' 'harder, better, FASTER, stronger'
		'NOT FAST ENOUGH!' 'GO!' 'SPEED' 'Follow @FastGH3 on Twitter for more updates.' '1.1 HOYP!!!'
		'%VER%' 'NOW WITH CACHING!' 'donnaken15.com/fastgh3' 'JURGEN IS HERE' 'ONE CLICK MAGIC!'
		'IMPOSSIBLE!' 'fastfastfastfastfastfastfastfastfastfastfastfastfastfastfastfastfastfast' 'fast'
		'NO LONGER WREAKING HAVOK' 'PROGRAMMER SOX ARE LAME' 'DIRECTLY CALLING OUT MY EX'
		'PRAISE THE FOSSIL (which is now periodically updated by a third party) THAT IS HELIX'
		'you need more than debug\n- revup90' '\bf\bf\bc\bc\be\bd\be\bd\b2\b3\ba' 'subscribe for daily \b2ideos'
		'Switch up the style and get yourself some c00l zonez by going to donnaken15.com/fastgh3/zones.html'
		'5 MEGABYTE ZONES' 'fastgh3' 'FastGH3' 'FASTGH3' 'C:/windows/fastgh3' '\'\'the clone hero version of gh3\'\''
		'RUNNING ON APOCALYPSE' 'start_gem_scroller()' 'SALUTE TO THE SUN!!' 'UNIVERSES FC, YES! @#!^ YEAH!!'
		'Now you can DOWNLOAD CHARTS THROUGH THIS MOD?! WHY DIDN\'T ANYONE THINK OF THIS!?!' 'Murderous Speed'
		'5atu6w4zaw5atu6w4zaw5atu6w4zaw5atu6w4zaw' 'IT\'S NOT FAST ENOUGH!' 'MASSIVE ADBLOCK!' 'SHE\'S TOO STONED! NINTENDO!'
		'I\nI\nO\n$\nV' 'ALIGNING POINTERS...' 'ScreenShot Paused\n\b0\nScreen\b1\b2Drop    \n\b3\nViewer'
		'Frequently updated at github.com/donnaken15/FastGH3!' 'EXECUTING ACTIONS...!'
		'For more fun with GH3 in general, check out progress on GH3+ at github.com/donnaken15/GH3-Plus'
		'3 PAK files? WHAT?!?' 'ASPIRING TO REKT ASPYR' 'Hey look, it works now! I think...'
		'IS THIS WORKING?!?!' 'DON\'T CRASH!!' 'DON\'T BREAK!! PLEASE!! I DON\'T BEG FOR MUCH!!!'
		'SecuROM tried to kill Exile, but it failed, as HATRED struck it down, to the ground!'
		'Convenient!' 'I got heX-ray mode on!' 'New loading text for no reason!!'
		'Check out the FastGH3 settings for extra customization.'
		'Unlock even more fun by enabling Debug Menu in settings!'
		'\'\'I figured out..... I figured out animated textures. T/N: I did not figure out animated textures\'\' PSPS: I did (4 years later) PSPSPS: Actually, no PSPSPSPS: Actually, yes'
		'I bet you can\'t read this FAST enough!' 'FC THIS!!!' 'FIXED!' 'BLOODY FAST\n100% No Slow Guaranteed'
		'I\'M RUNNING OUT OF THINGS TO SAY!' 'YOU RESTARTED JUST TO SEE THIS MESSAGE!'
		'HAX!' 'BOT!' 'FAAAKE!!' 'EPIC FAIL' 'WHAT ARE YOU DOING' 'WARNING: Requires x0.5 \b3 Presses'
		'unCHARTed' '\c9INVISIBLE INK\n\nwait, uh oh' 'are you actually reading these?' 'CHARTS ON DEMAND'
		'FITS 5944 TIMES ON A FLASH DRIVE, DO THE MATH!' 'FROM 4.7 GB TO 11.0 MB! WOW!'
		/* formula: 1024/((11561002/1024/1024)/64)
		64 = usual flash drive GB capacity (<-- stuck in 2011 or something thinking this is common)
		"DO THE MATH"
		Reverse of original calc: (15*4346)/1024 *///
		'EVERY COPY OF FASTGH3 IS PERSONALIZED' 'FC OR LOSER!' 'YET ANOTHER DELUXE APPLICATION, YADA YADA YADA...!'
		//'Dj Yohan Producciones\nDj Yohan Producciones\nDj Yohan Producciones\nDj Yohan Producciones\nDj Yohan Producciones\nDj Yohan Producciones\nDj Yohan Producciones\nDj Yohan Producciones\nDj Yohan Producciones\nDj Yohan Producciones\nDj Yohan Producciones\nDj Yohan Producciones\nDj Yohan Producciones'
		'these texts are my version of minecraft splash text at this point' // was going to just make this a comment but this also works :P
		//
		// lord squill quotes, just because
		// https://donnaken15.com/sunfish/wiki/index.php/Level:Lord_Squill
		'Do you think this game is funny?'
		'This used to contain text from a game i decided i would never release.'
		'i stayed up all night working on this mod'
		'Is this game art?'
		//'Brains are evil. Destroy them. Destroy yours today.'
		'I wish the list of stuff i say was infinite.'
		'I am getting bored of writing these texts, or not, I don\'t know.'
		'Take your chances with surgery done for electronic plastic toys.'
		//
		'Everything comes from something.'
		'\n\n\n\c5<YOU ARE ONLY HUMAN>\n\nor are you?'
		//
		'No one will be able to find this text... maybe...'
		'HI YOUTUBE HI YOUTUBE HI YOUTUBE HI YOUTUBE HI YOUTUBE HI YOUTUBE HI YOUTUBE HI YOUTUBE HI YOUTUBE'
		'door giveaway 123 door giveaway 123 door giveaway 123 door giveaway 123 door giveaway 123 door giveaway 123 door giveaway 123'
		'uber song fc' 'NAIL THE 540' '58,473 X 4\nStar Power + BS 360 Riff + Kissed the Sustain + FS Solo + FS 1440 GRYBRYBO'
		'ROCKING OUT IN THE ABYSS!!' 'IN SECONDS...!' '\c4ACCESS GRANTED' '>sudo skate8.exe -gem_array fastgh3_song_expert'
		'It looks like you\'re trying to hit the note. Would you like help with:\n\b3 Strumming\n\b2 Holding down the frets\n\b0 SHUT UP!!!\n\b1 Applying tinfoil'
		'!!!!!!! Guitarist not found !!!!!!!' '(UNKNOWN OPCODE 0)(UNKNOWN OPCODE 0)(UNKNOWN OPCODE 0)(UNKNOWN OPCODE 0)(UNKNOWN OPCODE 0)(UNKNOWN OPCODE 0)(UNKNOWN OPCODE 0)(UNKNOWN OPCODE 0)'
		'LEXER ERROR (5189): Unknown token in array:   ()' 'A.K.A: GH3DE, GH3DX, or GH3++' '__FASTcall void initGH3(int*)'
		'dummy' 'This game is practically a mod of Tony Hawk\'s Project 8' 'Powered by Tony Hawk'
		'\c6AM: GAIN 3 STARS\n\c3PRO: GAIN 5 STARS\n\c5SICK: FULL COMBO SONG, GAIN 5 GOLDEN STARS'
		'\c6AM: HIT A HOPO PATTERN WITH YOUR WRIST OVER THE NECK\n\c3PRO: PLAY THE OPPOSITE HANDEDNESS WITH HYPERSPEED 10\n\c5SICK: PLAY THE OPPOSITE HANDEDNESS WITH THE GUITAR BEHIND YOUR BACK\c0' // i wrote this without realizing i already made a similar thing
		'This is a mod of Project 8 which is an update of American Wasteland which is an update of Underground 2 which is an update of Underground 1 which is an update of Pro Skater 4 which is an update of Pro Skater 3 which is an update of Pro Skater 2 which is an update of Pro Skater 1 which is an update of Apocalypse which is an update of MDK'
		'\c2I WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED\nI WILL NOT BE CONTAINED'
	]
endscript

script create_loading_screen\{mode = play_song}
	kill_start_key_binding
	if ($enable_video = 1)
		return
	endif
	Change \{is_changing_levels = 1}
	GetArraySize ($loading_screen_tips)
	GetRandomValue name = rand_num a = 0 b = (<array_Size> - 1)integer
	rand_tip = ($loading_screen_tips [<rand_num>])
	if StringEquals a=<rand_tip> b='%VER%'
		formattext \{textname=rand_tip 'Current version: %b' b=$fastgh3_build}
	endif
	if (<mode> = play_song || <mode> = play_encore || <mode> = play_boss || <mode> = restart_song)
		killspawnedscript \{name = jiggle_text_array_elements}
		if ScreenElementExists \{id = $g_loading_screen_split_container_id}
			DestroyScreenElement \{id = $g_loading_screen_split_container_id}
		endif
		/*PlayMovieFromBuffer {
			buffer_slot = <buffer_slot>
			textureSlot = 2
			no_hold
			wait_until_rendered
			TexturePri = 4999
		}*///
		CreateScreenElement {
			Type = SpriteElement
			parent = root_window
			texture = FastGH3_logo
			id = FGH3_load_logo
			just = [center center]
			Pos = (380,240)
			Scale = 0.8
			z = 5000
		}
		CreateScreenElement {
			Type = TextBlockElement
			parent = root_window
			id = loading_tip_text
			text = <rand_tip>
			font = text_a4
			Scale = 0.9
			just = [center center]
			internal_just = [center center]
			dims = (700.0, 680.0)
			Pos = (860.0, 360.0)
			rgba = [255 255 255 255]
			z_priority = 5000
			Shadow
			shadow_offs = (5.0, 5.0)
			shadow_rgba = [0 0 0 255]
		}
		split_text_into_array_elements \{text = "LOADING" text_pos = (250.0, 400.0) space_between = (40.0, 0.0) flags = {rgba = [255 255 255 255] Scale = 2.0 z_priority = 6000 font = text_a10 just = [center center] alpha = 1}}
		Change g_loading_screen_split_container_id = <container_id>
		spawnscriptnow \{jiggle_text_array_elements params = {id = $g_loading_screen_split_container_id time = 1.0 wait_time = 3000 explode = 0}}
	else
		killspawnedscript \{name = destroy_loading_screen_spawned}
		CreateScreenElement \{Type = ContainerElement parent = root_window id = loading_screen_container Pos = (0.0, 0.0)}
		CreateScreenElement \{Type = SpriteElement parent = loading_screen_container texture = loading_flying_static Pos = (640.0, 360.0) just = [center center] dims = (1280.0, 720.0)}
	endif
endscript

script destroy_loading_screen
	destroy_menu \{menu_id = loading_tip_text}
	killspawnedscript \{name = jiggle_text_array_elements}
	if ScreenElementExists \{id = FGH3_load_logo}
		DestroyScreenElement \{id = FGH3_load_logo}
	endif
	if ScreenElementExists \{id = $g_loading_screen_split_container_id}
		DestroyScreenElement \{id = $g_loading_screen_split_container_id}
	endif
	spawnscriptnow \{destroy_loading_screen_spawned params={time=0.1}}
	HideLoadingScreen
	if ($playing_song = 0)
		Change \{is_changing_levels = 0}
	endif
endscript

script destroy_loading_screen_spawned\{time = 0.3}
	ProfilingStart
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
	ProfilingEnd <...> 'destroy_loading_screen_spawned'
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
