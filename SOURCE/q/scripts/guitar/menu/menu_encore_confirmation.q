g_ec_balloons_pos_left = [
	(315.0, 325.0)
	(465.0, 405.0)
	(590.0, 340.0)
	(360.0, 440.0)
]
g_ec_balloons_pos_right = [
	(960.0, 340.0)
	(790.0, 400.0)
	(690.0, 360.0)
	(915.0, 440.0)
]
g_encore_ready = 0

script create_encore_confirmation_menu
	kill_start_key_binding
	menu_font = fontgrid_title_gh3
	menu_pos = (640.0, 480.0)
	new_menu scrollid = ec_scroll vmenuid = ec_vmenu menu_pos = <menu_pos> event_handlers = <ec_eh> spacing = -45
	LaunchEvent \{Type = unfocus target = ec_vmenu}
	CreateScreenElement \{Type = ContainerElement id = ec_container parent = root_window Pos = (0.0, 0.0)}
	offwhite = [223 223 223 255]
	menu_z = 100
	CreateScreenElement \{Type = SpriteElement id = encore_gradient parent = ec_container texture = gradient_128 rgba = [0 0 0 180] Pos = (0.0, 0.0) dims = (1280.0, 720.0) just = [left top] z_priority = -1}
	get_song_struct song = ($current_song)
	if (<song_struct>.checksum = bosstom)
		bossText = "PLAY AN ENCORE WITH TOM MORELLO!"
		bossdims = (800.0, 0.0)
	elseif (<song_struct>.checksum = bossslash)
		bossText = "PLAY AN ENCORE WITH SLASH!"
		bossdims = (800.0, 0.0)
	endif
	if GotParam \{bossText}
		displayText {
			parent = ec_container
			Pos = (640.0, 165.0)
			just = [center center]
			font = fontgrid_title_gh3
			rgba = [130 170 200 255]
			Scale = 1
			text = <bossText>
			z = <menu_z>
		}
		fit_text_in_rectangle id = <id> dims = <bossdims> keep_ar = 1
	else
		encore_text = "ENCORE!"
		StringLength string = <encore_text>
		StringToCharArray string = <encore_text>
		space_between = (50.0, 0.0)
		i = 0
		begin
			FormatText checksumName = encore_id 'ec_encore_text_%d' d = (<i> + 1)
			displayText {
				id = <encore_id>
				parent = ec_container
				Pos = <Pos>
				Scale = 2.25
				text = (<char_array> [<i>])
				just = [center center]
				rgba = [130 170 200 255]
				font = fontgrid_title_gh3
				noshadow
				z = <menu_z>
			}
			GetScreenElementDims id = <id>
			if (<i> = 0)
				<Pos> = ((660.0, 165.0) - (((<str_len> - 1)* <width>)* (0.5, 0.0)))
				SetScreenElementProps id = <id> Pos = <Pos>
			endif
			<Pos> = (<Pos> + <space_between>)
			<i> = (<i> + 1)
		repeat <str_len>
		spawnscriptnow ec_raise_headline params = {str_len = <str_len>}
	endif
	displaySprite \{id = ec_flash parent = ec_container tex = encore_flash alpha = 0 dims = (128.0, 128.0) just = [center center]}
	arm_pos = (270.0, 300.0)
	arm_add = (80.0, 0.0)
	arm_z = [1 3 5 7 8 6 4 2]
	arm_index = 0
	begin
		FormatText checksumName = arm_id 'ec_arm_0%d' d = <arm_index>
		rand_arm = Random (@ 1 @ 2 @ 3 @ 4 @ 5 @ 6 @ 7 @ 8)
		FormatText checksumName = arm_tex 'Encore_Arm_%d' d = <rand_arm>
		displaySprite id = <arm_id> parent = ec_container tex = <arm_tex> Pos = <arm_pos> dims = (180.0, 340.0) z = (<menu_z> + 10 + (<arm_z> [<arm_index>]))
		if (<rand_arm> = 4 || <rand_arm> = 8)
			<arm_id> ::SetTags higher = 1
		else
			<arm_id> ::SetTags higher = 0
		endif
		<arm_pos> = (<arm_pos> + <arm_add>)
		<arm_index> = (<arm_index> + 1)
	repeat 8
	spawnscriptnow \{ec_raise_fists}
	spawnscriptnow \{ec_flashes}
	get_song_struct song = ($current_song)
	if NOT StructureContains structure = <song_struct> boss
		stars = ($player1_status.stars)
		cash = ($player1_status.new_cash)
		Change \{StructureName = player1_status new_cash = 0}
		if ($game_mode = p2_career)
			score = ($player1_status.score + $player2_status.score)
		else
			score = ($player1_status.score)
		endif
		if (<stars> < 3)
			<stars> = 3
		endif
		casttointeger \{score}
		FormatText textname = scoretext "%d" d = <score> usecommas
		FormatText textname = moneytext "$%d" d = <cash> usecommas
		textscale = 0.8
		starscale = 0.125
		displayText {
			id = ec_scoretext
			font = text_a6
			parent = ec_container
			rgba = [223 223 223 255]
			Pos = (20000.0, 20000.0)
			Scale = 10
			text = <scoretext>
			just = [right center]
			z = (<menu_z> + 20)
		}
		i = 0
		begin
			FormatText checksumName = starchecksum 'star_id0%d' d = <i>
			GetRandomValue \{a = 0 b = 360 name = rot}
			displaySprite {
				parent = ec_container
				id = <starchecksum>
				Pos = (20000.0, 20000.0)
				tex = encore_star_outline
				just = [center center]
				Scale = 10
				rgba = [223 223 223 255]
				rot_angle = <rot>
				z = (<menu_z> + 20)
				relative_scale
			}
			FormatText checksumName = starchecksum 'star_id0%d_2' d = <i>
			displaySprite {
				parent = ec_container
				id = <starchecksum>
				Pos = (20000.0, 20000.0)
				tex = encore_star_outline
				just = [center center]
				Scale = 10
				rgba = [110 30 20 255]
				rot_angle = <rot>
				z = (<menu_z> + 21)
				relative_scale
			}
			<i> = (<i> + 1)
		repeat <stars>
		displayText {
			id = ec_moneytext
			font = text_a6
			parent = ec_container
			rgba = [223 223 223 255]
			Pos = (20000.0, 20000.0)
			Scale = 10
			text = <moneytext>
			just = [left center]
			z = (<menu_z> + 20)
		}
		wait \{1 seconds}
		SetScreenElementProps \{id = ec_scoretext Pos = (520.0, 220.0) alpha = 0}
		DoScreenElementMorph id = ec_scoretext Scale = <textscale> time = 0.5 alpha = 1
		SoundEvent \{event = GH3_Score_FlyIn}
		wait \{1 seconds}
		SetScreenElementProps \{id = ec_moneytext Pos = (760.0, 220.0) alpha = 0}
		DoScreenElementMorph id = ec_moneytext Scale = <textscale> time = 0.5 alpha = 1
		SoundEvent \{event = GH3_Cash_FlyIn}
		wait \{0.5 seconds}
		SoundEvent \{event = GH3_Cash_FlyIn_Hit}
		wait \{0.5 seconds}
		star_add = (40.0, 0.0)
		star_pos = (600.0, 220.0)
		switch <stars>
			case 4
				<star_pos> = (580.0, 220.0)
			case 5
				<star_pos> = (560.0, 220.0)
		endswitch
		<i> = 0
		begin
			SoundEvent \{event = GH3_Star_FlyIn}
			FormatText checksumName = starchecksum 'star_id0%d' d = <i>
			SetScreenElementProps id = <starchecksum> Pos = <star_pos>
			DoScreenElementMorph id = <starchecksum> Scale = <starscale> time = 0.25 relative_scale
			FormatText checksumName = starchecksum 'star_id0%d_2' d = <i>
			SetScreenElementProps id = <starchecksum> Pos = <star_pos>
			DoScreenElementMorph id = <starchecksum> Scale = (<starscale> - 0.025)time = 0.25 relative_scale
			wait \{0.25 seconds}
			<star_pos> = (<star_pos> + <star_add>)
			<i> = (<i> + 1)
		repeat <stars>
	else
		cash = ($player1_status.new_cash)
		Change \{StructureName = player1_status new_cash = 0}
		FormatText textname = moneytext "$%d" d = <cash> usecommas
		displayText {
			id = ec_moneytext
			font = text_a6
			parent = ec_container
			rgba = [223 223 223 255]
			Pos = (20000.0, 20000.0)
			Scale = 200
			text = <moneytext>
			just = [center center]
			noshadow
			z = (<menu_z> + 20)
		}
		wait \{1 seconds}
		SetScreenElementProps \{id = ec_moneytext Pos = (640.0, 220.0) alpha = 0}
		DoScreenElementMorph \{id = ec_moneytext Scale = 1 time = 0.5 alpha = 1}
		wait \{1 seconds}
	endif
	displaySprite parent = ec_container id = ec_crowd_1 Pos = (-2000.0, -2000.0) tex = encore_balloon just = [center center] Scale = 2 z = (<menu_z> + 50)
	displaySprite parent = ec_container id = ec_crowd_2 Pos = (-2000.0, -2000.0) tex = encore_balloon just = [center center] Scale = 2 z = (<menu_z> + 50)
	displaySprite parent = ec_container id = ec_crowd_3 Pos = (-2000.0, -2000.0) tex = encore_balloon just = [center center] Scale = 2 z = (<menu_z> + 50)
	displaySprite parent = ec_container id = ec_crowd_4 Pos = (-2000.0, -2000.0) tex = encore_balloon just = [center center] Scale = 2 z = (<menu_z> + 50)
	displayText id = ec_crowd_text_1 parent = ec_crowd_1 text = "yay!" Pos = (60.0, 35.0) rgba = [0 0 0 255] z = (<menu_z> + 51)just = [center center] Scale = 0.8 noshadow
	displayText id = ec_crowd_text_2 parent = ec_crowd_2 text = "yay!" Pos = (60.0, 35.0) rgba = [0 0 0 255] z = (<menu_z> + 51)just = [center center] Scale = 0.8 noshadow
	displayText id = ec_crowd_text_3 parent = ec_crowd_3 text = "yay!" Pos = (60.0, 35.0) rgba = [0 0 0 255] z = (<menu_z> + 51)just = [center center] Scale = 0.8 noshadow
	displayText id = ec_crowd_text_4 parent = ec_crowd_4 text = "yay!" Pos = (60.0, 35.0) rgba = [0 0 0 255] z = (<menu_z> + 51)just = [center center] Scale = 0.8 noshadow
	spawnscriptnow \{encore_crowd_shout}
	wait \{1 Second}
	Change \{g_encore_ready = 1}
	displaySprite parent = ec_container id = options_bg_1 tex = encore_menu_bg Pos = (640.0, 550.0) dims = (384.0, 192.0) just = [center center] z = (<menu_z> + 50)
	set_focus_color \{rgba = [110 30 20 255]}
	set_unfocus_color \{rgba = [135 170 200 255]}
	if NOT GotParam \{exclusive_device}
		exclusive_device = ($primary_controller)
	endif
	largest_width = 0
	CreateScreenElement \{Type = ContainerElement parent = ec_vmenu dims = (0.0, 100.0) event_handlers = [{focus ec_yes_highlight_focus params = {id = ec_play_encore}}{unfocus retail_menu_unfocus params = {id = ec_play_encore}}{pad_choose encore_play}]}
	CreateScreenElement {
		Type = TextElement
		id = ec_play_encore
		parent = <id>
		font = fontgrid_title_gh3
		text = "PLAY ENCORE"
		Scale = (0.8999999761581421, 1.0)
		rgba = [135 170 200 255]
		just = [center center]
		z_priority = (<menu_z> + 51)
	}
	SetScreenElementProps {
		id = <id>
		exclusive_device = <exclusive_device>
	}
	GetScreenElementDims id = <id>
	if (<width> > <largest_width>)
		<largest_width> = <width>
	endif
	CreateScreenElement \{Type = ContainerElement parent = ec_vmenu dims = (0.0, 100.0) event_handlers = [{focus ec_no_highlight_focus params = {id = ec_leave_encore}}{unfocus retail_menu_unfocus params = {id = ec_leave_encore}}{pad_choose encore_leave}]}
	CreateScreenElement {
		Type = TextElement
		id = ec_leave_encore
		parent = <id>
		font = fontgrid_title_gh3
		text = "LEAVE"
		Scale = (0.8999999761581421, 1.0)
		rgba = [135 170 200 255]
		just = [center center]
		z_priority = (<menu_z> + 51)
	}
	SetScreenElementProps {
		id = <id>
		exclusive_device = <exclusive_device>
	}
	GetScreenElementDims id = <id>
	if (<width> > <largest_width>)
		<largest_width> = <width>
	endif
	GetScreenElementDims \{id = options_bg_1}
	SetScreenElementProps id = options_bg_1 dims = (<largest_width> * (1.0, 0.0) + (150.0, 0.0) + (0.0, 192.0))
	get_song_struct song = ($current_song)
	if ((StructureContains structure = <song_struct> boss)|| $game_mode = p2_battle)
		set_current_battle_first_play
	endif
	displaySprite id = ec_hi_left parent = ec_container tex = encore_menu_bookend rgba = [110 30 20 255] z = (<menu_z> + 51)
	displaySprite id = ec_hi_right parent = ec_container tex = encore_menu_bookend rgba = [110 30 20 255] z = (<menu_z> + 51)
	Change \{user_control_pill_text_color = [0 0 0 255]}
	Change \{user_control_pill_color = [180 180 180 255]}
	ec_yes_highlight_focus \{id = ec_play_encore}
	LaunchEvent \{Type = focus target = ec_vmenu}
	add_user_control_helper text = "SELECT" button = green z = (<menu_z> + 100)
	add_user_control_helper text = "UP/DOWN" button = strumbar z = (<menu_z> + 100)
endscript

script destroy_encore_confirmation_menu
	restore_start_key_binding
	clean_up_user_control_helpers
	killspawnedscript \{name = ec_flashes}
	killspawnedscript \{name = ec_raise_fists}
	Change \{g_encore_ready = 0}
	destroy_menu \{menu_id = ec_scroll}
	destroy_menu \{menu_id = ec_container}
	destroy_pause_menu_frame
	killspawnedscript \{name = encore_crowd_shout}
	PreEncore_Crowd_Build_SFX_STOP
endscript

script ec_yes_highlight_focus
	retail_menu_focus <...>
	GetScreenElementDims id = <id>
	SetScreenElementProps id = ec_hi_left Pos = ((630.0, 500.0) - (<width> * (0.5, 0.0)))flip_v just = [right top]
	SetScreenElementProps id = ec_hi_right Pos = ((650.0, 500.0) + (<width> * (0.5, 0.0)))just = [left top]
endscript

script ec_no_highlight_focus
	retail_menu_focus <...>
	GetScreenElementDims id = <id>
	SetScreenElementProps id = ec_hi_left Pos = ((630.0, 560.0) - (<width> * (0.5, 0.0)))flip_v just = [right top]
	SetScreenElementProps id = ec_hi_right Pos = ((650.0, 560.0) + (<width> * (0.5, 0.0)))just = [left top]
endscript

script encore_play
	if ($g_encore_ready)
		spawnscriptnow \{GH3_SFX_Encore_Accept}
		ui_flow_manager_respond_to_action \{action = continue}
	endif
endscript

script encore_leave
	if ($g_encore_ready)
		spawnscriptnow \{GH3_SFX_Encore_Decline}
		spawnscriptnow \{xenon_singleplayer_session_complete_uninit}
		ui_flow_manager_respond_to_action \{action = quit}
	endif
endscript

script encore_crowd_shout
	shout_text = [
		"yeah!"
		"rock!"
		"again!"
		"whoo!"
		"yay!"
		"more!"
	]
	GetArraySize <shout_text>
	begin
		i = 0
		begin
			FormatText checksumName = balloon_id 'ec_crowd_%d' d = <i>
			FormatText checksumName = balloon_text 'ec_crowd_text_%d' d = <i>
			side = Random (@ 1 @ 2)
			rand = Random (@ 0 @ 1 @ 2 @ 3)
			if (<side> = 1)
				balloon_array = g_ec_balloons_pos_left
			else
				balloon_array = g_ec_balloons_pos_right
			endif
			GetRandomValue a = 0 b = (<array_Size> - 1)name = rand_text integer
			if ScreenElementExists id = <balloon_id>
				SetScreenElementProps id = <balloon_id> Pos = ($<balloon_array> [<rand>])
				if ScreenElementExists id = <balloon_text>
					SetScreenElementProps id = <balloon_text> text = (<shout_text> [<rand_text>])Scale = 1
					fit_text_in_rectangle id = <balloon_text> only_if_larger_x = 1 dims = (90.0, 50.0) keep_ar = 1
				endif
				DoScreenElementMorph id = <balloon_id> alpha = 1 time = 0.125
				wait \{0.5 seconds}
				DoScreenElementMorph id = <balloon_id> alpha = 0 time = 0.5
				wait \{0.5 seconds}
			endif
			Mod a = <i> b = 2
			if (<Mod> = 0)
				wait \{1 Second}
			endif
			<i> = (<i> + 1)
		repeat 4
	repeat
endscript

script ec_raise_fists
	begin
		i = 0
		begin
			GetRandomValue \{a = 0.1 b = 0.3 name = wait_time}
			rand_arm = Random (@ 1 @ 2 @ 3 @ 4 @ 5 @ 6 @ 7 @ 8)
			FormatText checksumName = arm_id 'ec_arm_0%d' d = <i>
			GetScreenElementProps id = <arm_id>
			if ScreenElementExists id = <arm_id>
				<arm_id> ::GetTags
				<arm_id> ::SetTags Pos = <Pos> chance = <rand_arm>
				if (<higher> = 1)
					up_pos = (<Pos> - (0.0, 80.0))
				else
					up_pos = (<Pos> - (0.0, 50.0))
				endif
				DoScreenElementMorph id = <arm_id> Pos = <up_pos> time = <wait_time> motion = ease_in
			endif
			<i> = (<i> + 1)
		repeat 8
		wait \{0.3 seconds}
		<i> = 0
		begin
			GetRandomValue \{a = 0.1 b = 0.3 name = wait_time}
			FormatText checksumName = arm_id 'ec_arm_0%d' d = <i>
			if ScreenElementExists id = <arm_id>
				<arm_id> ::GetTags
				DoScreenElementMorph id = <arm_id> Pos = (<Pos>)time = (<wait_time> * 2.0)motion = ease_out
			endif
			<i> = (<i> + 1)
		repeat 8
		wait \{0.3 seconds}
	repeat
endscript

script ec_raise_headline
	begin
		i = 0
		begin
			GetRandomValue \{a = 0.05 b = 0.15 name = wait_time}
			FormatText checksumName = text_id 'ec_encore_text_%d' d = (<i> + 1)
			if ScreenElementExists id = <text_id>
				GetScreenElementProps id = <text_id>
				<text_id> ::GetTags
				<text_id> ::SetTags Pos = <Pos>
				DoScreenElementMorph id = <text_id> Pos = (<Pos> - (0.0, 22.0))time = <wait_time>
			endif
			<i> = (<i> + 1)
		repeat <str_len>
		wait \{0.15 seconds}
		<i> = 0
		begin
			GetRandomValue \{a = 0.05 b = 0.15 name = wait_time}
			FormatText checksumName = text_id 'ec_encore_text_%d' d = (<i> + 1)
			if ScreenElementExists id = <text_id>
				<text_id> ::GetTags
				DoScreenElementMorph id = <text_id> Pos = <Pos> time = (<wait_time> * 2.0)
			endif
			<i> = (<i> + 1)
		repeat <str_len>
		wait \{0.15 seconds}
	repeat
endscript

script ec_flashes
	begin
		GetRandomValue \{a = 400 b = 900 name = x_pos}
		GetRandomValue \{a = 400 b = 500 name = y_pos}
		GetRandomValue \{a = 96 b = 256 name = rand_dim}
		GetRandomValue \{a = 0 b = 360 name = rand_rot}
		Pos = (<x_pos> * (1.0, 0.0) + <y_pos> * (0.0, 1.0))
		dims = (<rand_dim> * (1.0, 0.0) + <rand_dim> * (0.0, 1.0))
		if ScreenElementExists \{id = ec_flash}
			SetScreenElementProps id = ec_flash Pos = <Pos> dims = <dims> rot_angle = <rand_rot> alpha = 1
			ec_flash ::DoMorph alpha = 0 dims = (<dims> * 0.5)time = 0.2
			ec_flash ::DoMorph dims = <dims>
		endif
	repeat
endscript
