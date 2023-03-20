credits_menu_font = #"0x35c0114b"

script create_credits_menu
	if NOT ($end_credits = 1)
		disable_pause
		StopRendering
		Change \{current_level = load_z_credits}
		Load_Venue
		StartRendering
	endif
	PushAssetContext \{context = z_credits}
	if NOT ($end_credits = 1)
		CreateScreenElement \{Type = ContainerElement parent = root_window id = credits_backdrop_container Pos = (0.0, 0.0) just = [left top]}
		CreateScreenElement \{Type = SpriteElement id = credits_backdrop parent = credits_backdrop_container texture = #"0x78909b29" rgba = [255 255 255 255] Pos = (640.0, 360.0) dims = (1280.0, 720.0) just = [center center] z_priority = 0 alpha = 1}
	endif
	PopAssetContext
	if NOT ($end_credits = 1)
		event_handlers = [
			{pad_back ui_flow_manager_respond_to_action params = {action = go_back}}
		]
		new_menu scrollid = mc_scroll vmenuid = mc_vmenu event_handlers = <event_handlers>
		add_user_control_helper \{text = "BACK" button = red z = 1001}
	else
		new_menu \{scrollid = mc_scroll vmenuid = mc_vmenu}
	endif
	text_params = {parent = mc_vmenu Type = TextElement font = ($credits_menu_font)rgba = ($menu_unfocus_color)}
	spawnscriptnow \{scrolling_list_begin}
endscript

script destroy_credits_menu
	clean_up_user_control_helpers
	destroy_menu \{menu_id = mc_scroll}
	destroy_menu \{menu_id = credits_list_container}
	killspawnedscript \{name = start_team_photos}
	killspawnedscript \{name = fadein_team_photos}
	killspawnedscript \{name = scrolling_list_begin}
	killspawnedscript \{name = fade_in_credit_item}
	if ScreenElementExists \{id = team_photos_container}
		DestroyScreenElement \{id = team_photos_container}
	endif
	if ScreenElementExists \{id = credits_backdrop_container}
		DestroyScreenElement \{id = credits_backdrop_container}
	endif
endscript

script scrolling_list_begin
	if ($end_credits = 1)
		wait \{2 seconds}
	endif
	scrolling_list_init_credits
	scrolling_list_add_item <...>
	spawnscriptnow \{start_team_photos}
endscript

script scrolling_list_add_item\{i = 0}
	if (<i> = 0)
		if NOT ($end_credits = 1)
			<i> = 6
		endif
	endif
	if ($end_credits = 1)
		z_priority_credits = -1
	else
		z_priority_credits = 1000
	endif
	GetArraySize ($Credits)
	if (<i> = <array_Size>)
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
	if StructureContains structure = ($Credits [<i>])item
		text = (($Credits [<i>]).item)
	else
		text = " "
	endif
	if StructureContains structure = ($Credits [<i>])heading
		Scale = <scale_head>
		Color = <color_head>
		color_shadow = [20 10 5 90]
		shadow_offs = (3.0, 3.0)
	else
		Scale = <scale_body>
		Color = <color_body>
		color_shadow = [0 0 0 255]
		shadow_offs = (1.0, 1.0)
	endif
	if StructureContains structure = ($Credits [<i>])title
		Scale = <scale_title>
		Color = <color_title>
		color_shadow = [20 10 5 90]
		shadow_offs = (3.0, 3.0)
	endif
	if StructureContains structure = ($Credits [<i>])small
		Scale = 0.5
		Color = <color_body>
		color_shadow = [0 0 0 255]
		shadow_offs = (1.0, 1.0)
	endif
	FormatText checksumName = item_id 'item_%n' n = <i>
	if ScreenElementExists id = <item_id>
		DestroyScreenElement id = <item_id>
	endif
	CreateScreenElement {
		Type = TextBlockElement
		id = <item_id>
		parent = credits_list_container
		font = #"0x35c0114b"
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
	DoMorph time = (<time>)Pos = <target_pos>
	if ScreenElementExists id = <item_id>
		DestroyScreenElement id = <item_id>
	endif
endscript

script fade_in_credit_item
	fade_duration = 15
	item_alpha = 0.0
	begin
		<item_alpha> = (<item_alpha> + (1.0 / <fade_duration>))
		if ScreenElementExists id = <item_id>
			<item_id> ::SetProps alpha = <item_alpha>
		endif
		wait \{4 gameframes}
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
team_photo_textures_l = [
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
]
team_photo_textures_r = [
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
	#"0x767a45d7"
]

script start_team_photos
	FormatText \{checksumName = team_photos_container 'team_photos_container'}
	CreateScreenElement {
		Type = ContainerElement
		parent = root_window
		id = <team_photos_container>
		just = [left top]
		Pos = (0.0, 0.0)
	}
	wait \{5 seconds}
	spawnscriptnow fadein_team_photos params = {team_photos_container = <team_photos_container> rot_direction = -1 texture_array = team_photo_textures_l Pos = (395.0, 200.0) Frame = 1}
	wait \{0.25 seconds}
	spawnscriptnow fadein_team_photos params = {team_photos_container = <team_photos_container> rot_direction = 1 texture_array = team_photo_textures_r Pos = (905.0, 200.0) Frame = 2}
endscript

script fadein_team_photos\{Pos = (350.0, 150.0)}
	photo_count = 0
	maximum_rotate = 20
	photo_wait = 5
	GetArraySize $<texture_array>
	begin
		FormatText checksumName = team_photo_checksum 'team_photo_%s_%f' s = <photo_count> f = <Frame>
		texture = ($<texture_array> [<photo_count>])
		if ScreenElementExists id = <team_photo_checksum>
			DestroyScreenElement id = <team_photo_checksum>
		endif
		PushAssetContext \{context = z_credits}
		if ($end_credits = 1)
			z_priority_team_photos = -2
		else
			z_priority_team_photos = 25
		endif
		CreateScreenElement {
			Type = SpriteElement
			id = <team_photo_checksum>
			parent = <team_photos_container>
			texture = <texture>
			rgba = [255 255 255 255]
			Pos = <Pos>
			alpha = 0
			Scale = 0.7
			just = [center center]
			z_priority = <z_priority_team_photos>
		}
		PopAssetContext
		GetRandomValue name = random_rot a = 10 b = <maximum_rotate> integer
		<random_rot> = (<random_rot> * <rot_direction>)
		Scale = 1.15
		if (<texture> = #"0xb60b1678" || <texture> = #"0x64e89de4"
			|| <texture> = #"0x638559fd" || <texture> = #"0x1482696b"
			|| <texture> = #"0xf33a446c")
			<Scale> = 1.3
		endif
		if (<texture> = #"0xcfd7aedc" || <texture> = #"0x8d8b38d1" ||
			<texture> = #"0x21d9cff0" || <texture> = #"0xc2caae16" ||
			<texture> = #"0x51b33b7f")
			<Scale> = 1.2
		endif
		DoScreenElementMorph id = <team_photo_checksum> rot_angle = <random_rot> time = 2 alpha = 1 Scale = <Scale>
		wait <photo_wait> seconds
		DoScreenElementMorph id = <team_photo_checksum> time = 2 alpha = 0
		wait \{2 seconds}
		if ScreenElementExists id = <team_photo_checksum>
			DestroyScreenElement id = <team_photo_checksum>
		endif
		<photo_count> = (<photo_count> + 1)
	repeat <array_Size>
endscript

script scrolling_list_init_credits
	if ($end_credits = 1)
		rate = 119.0
	else
		rate = 60.0
	endif
	if ($end_credits = 1)
		screen_height = 375
		base_pos = ((640.0, 0.0) + ((0.0, 1.0) * <screen_height>))
		column_width = 500
	else
		screen_height = 720
		base_pos = ((640.0, 0.0) + ((0.0, 1.0) * <screen_height>))
		column_width = 500
	endif
	spacer = 5
	column_width = 450
	if ($end_credits = 1)
		scale_head = 0.65
		color_head = [180 165 120 255]
		scale_body = 0.55
		color_body = [180 200 200 255]
		scale_title = 0.55
		color_title = [180 165 120 255]
	else
		scale_head = 0.65
		color_head = [180 165 120 255]
		scale_body = 0.55
		color_body = [180 200 200 255]
		scale_title = 0.55
		color_title = [180 165 120 255]
	endif
	dims = (<column_width> * (1.0, 0.0))
	if ScreenElementExists \{id = credits_list_container}
		DestroyScreenElement \{id = credits_list_container}
	endif
	CreateScreenElement \{Type = ContainerElement parent = root_window id = credits_list_container Pos = (0.0, 0.0)}
	return <...>
endscript
Credits = [
	{
		title
		item = ""
	}
]
