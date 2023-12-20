credits_menu_font = text_a4

script create_credits_menu
	if NOT ($end_credits = 1)
		disable_pause
		StopRendering
		//Change \{current_level = load_z_credits}
		//Load_Venue
		StartRendering
	endif
	//PushAssetContext \{context = z_credits}
	if NOT ($end_credits = 1)
		CreateScreenElement \{Type = ContainerElement parent = root_window id = credits_backdrop_container Pos = (0.0, 0.0) just = [left top]}
		//CreateScreenElement \{Type = SpriteElement id = credits_backdrop parent = credits_backdrop_container texture = black rgba = [255 255 255 255] Pos = (640.0, 360.0) dims = (1280.0, 720.0) just = [center center] z_priority = 0 alpha = 1}
		create_menu_backdrop \{texture = black z = 999}
	endif
	//PopAssetContext
	if NOT ($end_credits = 1)
		event_handlers = [
			{pad_back ui_flow_manager_respond_to_action params = {action = go_back}}
		]
		new_menu scrollid = mc_scroll vmenuid = mc_vmenu event_handlers = <event_handlers>
		add_user_control_helper \{text = $menu_text_back button = red z = 1001}
	else
		new_menu \{scrollid = mc_scroll vmenuid = mc_vmenu}
	endif
	text_params = {parent = mc_vmenu Type = TextElement font = ($credits_menu_font) rgba = ($menu_unfocus_color)}
	spawnscriptnow \{scrolling_list_begin}
endscript

script destroy_credits_menu
	clean_up_user_control_helpers
	destroy_menu \{menu_id = mc_scroll}
	destroy_menu \{menu_id = credits_list_container}
	killspawnedscript \{name = scrolling_list_begin}
	killspawnedscript \{name = fade_in_credit_item}
	destroy_menu_backdrop
endscript

script scrolling_list_begin
	decompress_credits
	if ($end_credits = 1)
		wait \{2 seconds}
	endif
	scrolling_list_init_credits
	scrolling_list_add_item <...>
endscript

script scrolling_list_add_item\{i = 0}
	if ($end_credits = 1)
		z_priority_credits = -1
	else
		z_priority_credits = 1000
	endif
	GetArraySize ($Credits)
	if (<i> >= <array_Size>)
		printf \{"** END OF CREDITS **"}
		wait <time> seconds
		if ScreenElementExists \{id = credits_list_container}
			DestroyScreenElement \{id = credits_list_container}
		endif
		if NOT ($end_credits = 1)
			ui_flow_manager_respond_to_action \{action = go_back}
		endif
		return
	endif
	FormatText checksumName = item_id 'item_%n' n = <i>
	if ScreenElementExists id = <item_id>
		DestroyScreenElement id = <item_id>
	endif
	if NOT StructureContains structure = ($Credits[<i>]) image
		if StructureContains structure = ($Credits[<i>]) item
			text = (($Credits [<i>]).item)
		else
			text = " "
		endif
		if StructureContains structure = ($Credits[<i>]) heading
			Scale = <scale_head>
			Color = <color_head>
			color_shadow = [20 10 5 90]
			shadow_offs = (3.0, 3.0)
		elseif StructureContains structure = ($Credits[<i>]) title
			Scale = <scale_title>
			Color = <color_title>
			color_shadow = [20 10 5 90]
			shadow_offs = (3.0, 3.0)
		elseif StructureContains structure = ($Credits[<i>]) small
			Scale = 0.5
			Color = <color_body>
			color_shadow = [0 0 0 255]
			shadow_offs = (1.0, 1.0)
		else
			Scale = <scale_body>
			Color = <color_body>
			color_shadow = [0 0 0 255]
			shadow_offs = (1.0, 1.0)
		endif
		CreateScreenElement {
			Type = TextBlockElement
			id = <item_id>
			parent = credits_list_container
			font = text_a4
			dims = <dims>
			allow_expansion
			Pos = (0.0, 0.0)
			internal_scale = <Scale>
			text = <text>
			just = [center bottom]
			internal_just = [center bottom]
			rgba = <Color>
			alpha = 0
			Shadow
			shadow_offs = <shadow_offs>
			shadow_rgba = <color_shadow>
			z_priority = <z_priority_credits>
		}
		GetScreenElementDims id = <item_id>
	else
		CreateScreenElement {
			Type = SpriteElement
			id = <item_id>
			parent = credits_list_container
			texture = (($Credits[<i>]).image)
			Pos = (0.0, 0.0)
			scale = <image_scale>
			just = [center bottom]
			alpha = 0
			z_priority = <z_priority_credits>
		}
		height = (($Credits[<i>]).height)
	endif
	item_height = (<height> + <spacer>)
	item_pos = (<base_pos> + (<item_height> * (0.0, 1.0)))
	SetScreenElementProps id = <item_id> Pos = <item_pos>
	distance = (<screen_height> + ((<item_pos>.(0.0, 1.0))- <screen_height>))
	time = (<distance> / <rate>)
	if ScreenElementExists id = <item_id>
		RunScriptOnScreenElement id = <item_id> scrolling_list_move_item params = {<...> }
	endif
endscript

script scrolling_list_move_item
	spawnscriptnow scrolling_list_queue_next_item params = {<...> }
	spawnscriptnow fade_in_credit_item params = {<...> }
	target_pos = (<item_pos> - ((0.0, 1.0) * <distance>))
	alpha_pos_y = (<distance> / <time>)
	<alpha_pos> = (<item_pos> - ((0.0, 1.0) * <alpha_pos_y>))
	DoMorph time = (<time>) Pos = <target_pos>
	if ScreenElementExists id = <item_id>
		DestroyScreenElement id = <item_id>
	endif
endscript

script fade_in_credit_item
	GetDeltaTime
	fade_duration = (0.25/<delta_time>)
	item_alpha = 0.0
	begin
		<item_alpha> = (<item_alpha> + (1.0 / <fade_duration>))
		if (<item_alpha> > 1)
			break
		endif
		if ScreenElementExists id = <item_id>
			<item_id> ::SetProps alpha = <item_alpha>
		endif
		wait \{1 gameframes}
	repeat <fade_duration>
endscript

script scrolling_list_queue_next_item
	begin
		if ScreenElementExists id = <item_id>
			GetScreenElementProps id = <item_id>
		endif
		pos_y = (<Pos>.(0.0, 1.0))
		if (<pos_y> < <screen_height>)
			<i> = (<i> + 1)
			scrolling_list_add_item <...>
			return
		endif
		wait \{1 Frame}
	repeat
endscript

script scrolling_list_init_credits
	if ($end_credits = 1)
		rate = 80.0
	else
		rate = 60.0
	endif
	if ($end_credits = 1)
		image_scale = 0.5
		screen_height = 375
		base_pos = ((640.0, 0.0) + ((0.0, 1.0) * <screen_height>))
		//column_width = 1200
		scale_head = 0.6
		color_head = [255 120 130 255]
		scale_title = 0.5
		color_title = [143 255 199 255]
		scale_body = 0.4
		color_body = [180 200 200 255]
		spacer = 2
	else
		image_scale = 1.0
		screen_height = 720
		base_pos = ((640.0, 0.0) + ((0.0, 1.0) * <screen_height>))
		//column_width = 1200
		scale_head = 0.9
		color_head = [255 120 130 255]
		scale_title = 0.7
		color_title = [143 255 199 255]
		scale_body = 0.55
		color_body = [180 200 200 255]
		spacer = 0
	endif
	column_width = 1000
	dims = (<column_width> * (1.0, 0.0))
	if ScreenElementExists \{id = credits_list_container}
		DestroyScreenElement \{id = credits_list_container}
	endif
	CreateScreenElement \{Type = ContainerElement parent = root_window id = credits_list_container Pos = (0.0, 0.0)}
	return <...>
endscript

script decompress_credits
	GetArraySize \{$Credits}
	if NOT (<array_size> = 0)
		return
	endif
	change Credits = [
		{ image = FastGH3_logo height = 140 }
		{ item = '(FastGH3 Ain\'t Smaller Than Guitar Hero 3)' heading }
		{ item = 'UNOFFICIAL, UNPARTICIPATING, UNINVOLVED STAFF ROLL' title }
		{ emptyspace }
		{ item = 'Wesley Kennedy / donnaken15' heading }
		{ item = 'Main developer' title }
		{ item = 'Launcher code' }
		{ item = 'Audio encoding scripts' }
		{ item = 'Script modifications' }
		{ item = 'Game optimization' }
		{ item = 'Solo scripts' }
		{ item = 'Data building automation' }
		{ item = 'Console/commands/interpreter' }
		{ item = 'Google Drive to FastGH3' }
		{ item = 'Custom Zones' title }
		{ item = 'Rock Band 1' }
		{ item = 'Guitar Hero 2' }
		{ item = 'GH3 WOR Mod (Re-ported)' }
		{ item = 'Porting old GH3 Zones' }
		{ item = 'QbScript Mods' title }
		{ item = 'JORSpy' }
		{ item = 'Reverse engineering' title }
		{ item = 'IDA annotations' }
		{ item = 'Texture/Material hacking' }
		{ item = 'GH3+ Plugins' title }
		{ item = 'Discord Rich Presence' }
		{ item = 'QDB (QbScript debugger)' }
		{ item = 'Logger' }
		{ item = 'TapHopoChord' title }
		{ item = 'Open sustains' }
		{ item = 'Overlapping starpower' }
		{ item = 'FastGH3 core plugin' title }
		{ item = 'Fast texture loading' }
		{ item = 'Graphical highway fixes' }
		{ item = 'Framerate control' }
		{ item = 'INI config code' }
		{ emptyspace }
		{ item = 'Dan Doyle / ExileLord' heading }
		{ item = 'Guitar Hero III+ developer' title }
		{ item = 'Open and tap notes' }
		{ item = 'Hopo chords' }
		{ item = 'Core library' }
		{ item = 'GH3+ Plugins' title }
		{ item = 'TapHopoChord' }
		{ item = 'NoteLimitFix' }
		{ item = 'SongLimitFix' }
		{ item = 'Reverse engineering' title }
		{ item = 'IDA annotations' }
		{ item = 'Miscellaneous' title }
		{ item = 'Chart file parser and classes' }
		{ emptyspace }
		{ item = 'Zedek the Plague Doctor' heading }
		{ item = 'Guitar Hero SDK' title }
		{ item = 'PAK functions' }
		{ item = 'NodeQBC' title }
		{ item = 'Script compiler' }
		{ emptyspace }
		{ item = 'Nanook' heading }
		{ item = 'QueenBee library' title }
		{ item = 'Parser code and classes' }
		{ emptyspace }
		{ item = 'Miscellaneous credits' heading }
		{ item = 'De-SecuROM\'d executable' title }
		{ item = 'GameCopyWorld / HATRED' }
		{ item = 'Audio encoding tools' title }
		{ item = 'RealNetworks' }
		{ item = 'Maik Merten' }
		{ item = 'SoX developers' }
		{ item = 'media-autobuild-suite' }
		{ item = 'mid2chart' title }
		{ item = 'raphaelgoulart' }
		{ item = 'Old QbScript compiler/decompiler' title }
		{ item = 'Vsync Flame Fix' title }
		{ item = 'adituv' }
		{ emptyspace }
		{ item = 'Project pages' heading }
		{ item = 'Homepage' title }
		{ item = 'https://donnaken15.cf/FastGH3' }
		{ item = 'Repository' title }
		{ item = 'https://github.com/donnaken15/FastGH3' }
		{ item = 'Twitter' title }
		{ item = 'https://twitter.com/FastGH3' }
		{ emptyspace }
		{ item = 'Developer links' heading }
		{ item = 'Wesley' title }
		{ item = 'https://donnaken15.cf/' }
		{ item = 'https://twitter.com/ptr__WESLEY' }
		{ item = 'https://youtube.com/donnaken15' }
		{ item = 'https://github.com/donnaken15' }
		{ item = 'ExileLord' title }
		{ item = 'https://github.com/ExileLord' }
		{ emptyspace }
		{ item = 'Abandonware credits' heading }
		{ item = 'Neversoft' title }
		{ item = 'Game Engine' }
		{ item = 'Developers' }
		{ item = 'Activision' title }
		{ item = 'Copyright' }
		{ item = 'Assets' }
		{ item = 'Aspyr' title }
		{ item = 'Microsoft?' title }
		{ emptyspace }
		{ item = 'Landmark Versions' heading }
		{ item = '1.0-999010247' title }
		{ item = 'Released July 9, 2021' }
		{ item = '39.9 MB / 13.4 MB' }
		{ item = '1.0-999010389' title }
		{ item = 'Released November 25, 2021' }
		{ item = '37.4 MB / 12.8 MB' }
		{ item = '1.0-999010573' title }
		{ item = 'Released May 7, 2022' }
		{ item = '23.4 MB / 11.7 MB' }
		{ item = '1.0-999010723' title }
		{ item = 'Released November 29, 2022' }
		{ item = '15.1 MB / 10.7 MB' }
		{ item = '1.0-999010889' title }
		{ item = 'Released July 4, 2023' }
		{ item = '13.0 MB / 9.0 MB' }
		{ item = 'Check for more information at' }
		{ item = 'https://donnaken15.cf/dev.html' }
		{ emptyspace }
		{ item = 'Thank you for playing!!' heading }
		{ item = 'Created 2017--2023' title }
	]
endscript
Credits = []
