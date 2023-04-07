training_star_power_tutorial_script = [
	{
		call = training_star_power_tutorial_startup
	}
	{
		time = 100
		call = training_2_1_show_title
	}
	{
		lesson = 1
		call = training_2_1_start_gem_scroller
	}
	{
		call = training_2_1_explain
	}
	{
		call = training_2_1_wait_for_star_power
	}
	{
		call = training_2_1_lesson_complete
	}
	{
		lesson = 2
		call = training_2_2_start_gem_scroller
	}
	{
		call = training_2_2_show_whammy
	}
	{
		call = training_2_2_watch_for_star_power
	}
	{
		call = training_2_2_lesson_complete
	}
	{
		lesson = 3
		call = training_2_3_start_gem_scroller
	}
	{
		call = training_2_3_explain
	}
	{
		call = training_2_3_wait_for_star_power
	}
	{
		call = training_2_3_watch_for_notes_hit
	}
	{
		call = training_2_3_end
	}
	{
		call = training_2_tutorial_complete_message
	}
	{
		call = training_2_end
	}
]

script training_star_power_tutorial_startup
	training_init_session
	LaunchEvent \{Type = unfocus target = root_window}
	training_create_narrator_icons
endscript

script training_2_1_show_title
	training_show_title \{title = "Star Power Tutorial"}
	begin
		if ($transitions_locked = 0)
			break
		endif
		wait \{1 gameframe}
	repeat
	create_training_pause_handler
	wait \{3 seconds ignoreslomo}
	training_destroy_title
endscript
lesson_complete = 0

script training_2_1_start_gem_scroller
	destroy_band
	training_start_gem_scroller \{song = Tutorial_2B}
	if ScreenElementExists \{id = menu_tutorial}
		LaunchEvent \{Type = unfocus target = menu_tutorial}
		destroy_menu \{menu_id = menu_tutorial}
	endif
	event_handlers = [
		{song_wonp1 training_song_won}
		{star_sequence_bonusp1 hit_star_power_sequence}
		{pad_start show_training_pause_screen}
	]
	new_menu {
		scrollid = menu_tutorial
		vmenuid = vmenu_tutorial
		menu_pos = (120.0, 190.0)
		use_backdrop = 0
		event_handlers = <event_handlers>
	}
	training_set_lesson_header_text \{text = "LESSON 1: STAR COMBOS"}
	training_set_lesson_header_body \{text = "Hit every note in a Star Combo for a Star Power Boost"}
	training_show_lesson_header
	safe_show \{id = lou_icon}
	Change \{lesson_complete = 0}
	Change \{training_received_star_power = 0}
	Change \{notes_hit = 0}
	training_wait_for_gem_scroller_startup
endscript

script training_2_1_explain
	wait \{3.5 seconds ignoreslomo}
	training_pause_gem_scroller
	training_play_sound \{Sound = 'Tutorial_2A_01_lou'}
	wait \{3 seconds ignoreslomo}
	if training_are_notes_flipped
		training_add_arrow \{id = training_arrow2 life = 10 Pos = (735.0, 360.0) Scale = 0.7}
	else
		training_add_arrow \{id = training_arrow2 life = 10 Pos = (532.0, 360.0) Scale = 0.7}
	endif
	training_wait_for_sound \{Sound = 'Tutorial_2A_01_lou' wait}
	training_set_task_header_body \{text = "Nail the Star Combo to continue"}
	training_show_task_header
	wait \{2 seconds ignoreslomo}
	training_resume_gem_scroller
endscript
training_received_star_power = 0

script hit_star_power_sequence
	printf \{channel = training "hit_star_power_sequence............."}
	Change \{training_received_star_power = 1}
endscript

script training_2_1_wait_for_star_power
	Change \{training_received_star_power = 0}
	begin
		if ($training_song_over = 1)
			return
		endif
		if ($training_received_star_power = 1)
			break
		endif
		wait \{1 gameframe}
	repeat
endscript

script training_2_1_lesson_complete
	destroy_menu \{menu_id = menu_tutorial}
	create_training_pause_handler
	wait \{0.75 seconds ignoreslomo}
	StopAllSounds
	PauseGame
	PauseGh3Sounds
	training_hide_lesson_header
	training_hide_task_header
	wait \{0.5 seconds ignoreslomo}
	KillCamAnim \{name = ch_view_cam}
	kill_gem_scroller
	destroy_bg_viewport
	setup_bg_viewport
	PlayIGCCam \{id = cs_view_cam_id name = ch_view_cam viewport = bg_viewport LockTo = World Pos = (-0.06880699843168259, 1.5990009307861328, 5.797596454620361) Quat = (0.000506000011228025, 0.9994299411773682, -0.017537998035550117) FOV = 72.0 play_hold = 1 interrupt_current}
	CreateScreenElement {
		Type = TextElement
		parent = training_container
		id = tuning_complete_text
		just = [center center]
		Pos = (640.0, 350.0)
		font = ($training_font)
		text = "Lesson Complete"
		Scale = 1.0
		rgba = ($training_text_color)
	}
	UnpauseGh3Sounds
	UnPauseGame
	SoundEvent \{event = Tutorial_Mode_Finish_Chord_02}
	wait \{2 seconds ignoreslomo}
	safe_destroy \{id = tuning_complete_text}
endscript

script training_2_2_start_gem_scroller
	destroy_band
	training_start_gem_scroller \{song = Tutorial_2B}
	if ScreenElementExists \{id = menu_tutorial}
		LaunchEvent \{Type = unfocus target = menu_tutorial}
		destroy_menu \{menu_id = menu_tutorial}
	endif
	event_handlers = [
		{song_wonp1 training_song_won}
		{pad_start show_training_pause_screen}
	]
	new_menu {
		scrollid = menu_tutorial
		vmenuid = vmenu_tutorial
		menu_pos = (120.0, 190.0)
		use_backdrop = 0
		event_handlers = <event_handlers>
	}
	Change \{training_received_star_power = 0}
	training_wait_for_gem_scroller_startup
endscript

script training_create_whammy_sprites
	if IsWinPort
		whammy_pos = (582.0, 405.0)
	else
		whammy_pos = (666.0, 416.0)
	endif
	whammy_scale = (0.699999988079071, 0.699999988079071)
	z = 21
	CreateScreenElement {
		parent = training_container
		Type = SpriteElement
		id = guitar_whammy_up
		just = [center center]
		texture = #"0x6b250f8a"
		Pos = <whammy_pos>
		rot_angle = 0
		rgba = [255 255 255 255]
		Scale = <whammy_scale>
		z_priority = <z>
	}
	CreateScreenElement {
		parent = training_container
		Type = SpriteElement
		id = guitar_whammy_down
		just = [center center]
		texture = #"0x647871ac"
		Pos = <whammy_pos>
		rot_angle = 0
		rgba = [255 255 255 255]
		Scale = <whammy_scale>
		z_priority = <z>
	}
	CreateScreenElement {
		parent = training_container
		Type = SpriteElement
		id = guitar_whammy_turn1
		just = [center center]
		texture = #"0xd755751a"
		Pos = <whammy_pos>
		rot_angle = 0
		rgba = [255 255 255 255]
		Scale = <whammy_scale>
		z_priority = <z>
	}
	CreateScreenElement {
		parent = training_container
		Type = SpriteElement
		id = guitar_whammy_turn2
		just = [center center]
		texture = #"0x4e5c24a0"
		Pos = <whammy_pos>
		rot_angle = 0
		rgba = [255 255 255 255]
		Scale = <whammy_scale>
		z_priority = <z>
	}
	safe_hide \{id = guitar_whammy_down}
	safe_hide \{id = guitar_whammy_turn1}
	safe_hide \{id = guitar_whammy_turn2}
endscript

script training_create_whammy_arrows
	if IsWinPort
		whammy_pos = (532.0, 345.0)
	else
		whammy_pos = (616.0, 356.0)
	endif
	whammy_scale = (0.699999988079071, 0.699999988079071)
	z = 21
	CreateScreenElement {
		parent = training_container
		Type = SpriteElement
		id = guitar_whammy_up_arrow
		just = [center center]
		texture = #"0x8abca6ec"
		Pos = <whammy_pos>
		rot_angle = 0
		rgba = [255 255 255 255]
		Scale = <whammy_scale>
		z_priority = <z>
	}
	CreateScreenElement {
		parent = training_container
		Type = SpriteElement
		id = guitar_whammy_down_arrow
		just = [center center]
		texture = #"0x61b6620d"
		Pos = <whammy_pos>
		rot_angle = 0
		rgba = [255 255 255 255]
		Scale = <whammy_scale>
		z_priority = <z>
	}
	whammy_pos = (671.0, 366.0)
	CreateScreenElement {
		parent = training_container
		Type = SpriteElement
		id = training_arrow_red_start
		just = [center center]
		texture = #"0x08ee5daf"
		Pos = <whammy_pos>
		rot_angle = 0
		rgba = [255 255 255 255]
		Scale = <whammy_scale>
		z_priority = <z>
	}
	CreateScreenElement {
		parent = training_container
		Type = SpriteElement
		id = training_arrow_red_middle
		just = [center center]
		texture = #"0x777b4282"
		Pos = <whammy_pos>
		rot_angle = 0
		rgba = [255 255 255 255]
		Scale = <whammy_scale>
		z_priority = <z>
	}
	CreateScreenElement {
		parent = training_container
		Type = SpriteElement
		id = training_arrow_red_end
		just = [center center]
		texture = #"0x6beb2ff3"
		Pos = <whammy_pos>
		rot_angle = 0
		rgba = [255 255 255 255]
		Scale = <whammy_scale>
		z_priority = <z>
	}
	safe_hide \{id = guitar_whammy_up_arrow}
	safe_hide \{id = guitar_whammy_down_arrow}
	safe_hide \{id = training_arrow_red_start}
	safe_hide \{id = training_arrow_red_middle}
	safe_hide \{id = training_arrow_red_end}
endscript

script training_2_2_show_whammy
	wait \{1 seconds ignoreslomo}
	training_pause_gem_scroller
	training_set_lesson_header_text \{text = "LESSON 2: WHAMMY BAR"}
	training_set_lesson_header_body \{text = ""}
	training_show_lesson_header
	safe_show \{id = lou_icon}
	//CreateScreenElement \{parent = training_container Type = SpriteElement id = guitar_sprite just = [center center] texture = #"0x93f6bad9" Pos = (300.0, 350.0) rot_angle = 0 rgba = [255 255 255 255] Scale = (0.6000000238418579, 0.6000000238418579) z_priority = 20}
	training_create_whammy_sprites
	training_create_whammy_arrows
	if IsWinPort
		training_add_arrow \{id = training_whammy_indicator life = 7 Pos = (601.0, 339.0) Scale = 0.7 z = 60}
	else
		training_add_arrow \{id = training_whammy_indicator life = 7 Pos = (685.0, 350.0) Scale = 0.7 z = 60}
	endif
	training_play_sound \{Sound = 'Tutorial_2B_01_lou'}
	wait \{7 seconds ignoreslomo}
	training_2_2_animate_whammy_turn
	wait \{10 seconds ignoreslomo}
	training_2_2_animate_whammy_up_down
	wait \{2 seconds ignoreslomo}
	training_wait_for_sound \{Sound = 'Tutorial_2B_01_lou'}
	training_2_2_destroy_sprites
	training_set_lesson_header_body \{text = "After playing a note, move the whammy bar in and out to extract Star Power"}
	training_show_lesson_header
	training_set_task_header_body \{text = "Boost the Star Power meter to continue"}
	training_show_task_header
	training_play_sound \{Sound = 'Tutorial_2B_02_lou' wait}
	training_resume_gem_scroller
endscript

script training_2_2_animate_whammy_up_down
	safe_show \{id = guitar_whammy_up_arrow}
	wait \{0.75 seconds ignoreslomo}
	safe_hide \{id = guitar_whammy_up_arrow}
	begin
		safe_show \{id = guitar_whammy_down_arrow}
		safe_hide \{id = guitar_whammy_up}
		safe_show \{id = guitar_whammy_down}
		wait \{0.75 seconds ignoreslomo}
		safe_hide \{id = guitar_whammy_down_arrow}
		safe_show \{id = guitar_whammy_up_arrow}
		safe_hide \{id = guitar_whammy_down}
		safe_show \{id = guitar_whammy_up}
		wait \{0.75 seconds ignoreslomo}
		safe_hide \{id = guitar_whammy_up_arrow}
	repeat 2
endscript

script training_2_2_animate_whammy_turn
	safe_show \{id = training_arrow_red_start}
	wait \{0.75 seconds ignoreslomo}
	safe_hide \{id = training_arrow_red_start}
	begin
		safe_show \{id = training_arrow_red_middle}
		safe_hide \{id = guitar_whammy_up}
		safe_show \{id = guitar_whammy_turn1}
		wait \{0.75 seconds ignoreslomo}
		safe_hide \{id = training_arrow_red_middle}
		safe_show \{id = training_arrow_red_end}
		safe_hide \{id = guitar_whammy_turn1}
		safe_show \{id = guitar_whammy_turn2}
		wait \{0.75 seconds ignoreslomo}
		safe_hide \{id = training_arrow_red_end}
		safe_show \{id = training_arrow_red_middle}
		safe_hide \{id = guitar_whammy_turn2}
		safe_show \{id = guitar_whammy_turn1}
		wait \{0.75 seconds ignoreslomo}
		safe_hide \{id = training_arrow_red_middle}
		safe_show \{id = training_arrow_red_start}
		safe_hide \{id = guitar_whammy_turn1}
		safe_show \{id = guitar_whammy_up}
		wait \{0.75 seconds ignoreslomo}
		safe_hide \{id = training_arrow_red_start}
	repeat 2
endscript

script training_2_2_destroy_sprites
	safe_destroy \{id = guitar_sprite}
	safe_destroy \{id = guitar_whammy_up}
	safe_destroy \{id = guitar_whammy_down}
	safe_destroy \{id = guitar_whammy_turn1}
	safe_destroy \{id = guitar_whammy_turn2}
	safe_destroy \{id = guitar_whammy_up_arrow}
	safe_destroy \{id = guitar_whammy_down_arrow}
	safe_destroy \{id = training_arrow_red_start}
	safe_destroy \{id = training_arrow_red_middle}
	safe_destroy \{id = training_arrow_red_end}
endscript

script training_2_2_watch_for_star_power
	Change \{lesson_complete = 0}
	elapsed_time = 0
	sound_played = FALSE
	begin
		if (<sound_played> = FALSE)
			GetDeltaTime
			elapsed_time = (<elapsed_time> + <delta_time>)
			if (<elapsed_time> > 20.0 & ($player1_status.star_power_amount < 25))
				training_play_sound \{Sound = 'Tutorial_2B_03_lou'}
				sound_played = true
				printf \{channel = training "playing help sound....."}
			endif
		endif
		if ($player1_status.star_power_amount >= 50.0)
			printf \{channel = training "star power ready !!!!!!!!!!!!!!"}
			break
		endif
		if ($training_song_over = 1)
			printf \{channel = training "Song Over! "}
			return
		endif
		wait \{1 gameframe}
	repeat
endscript

script training_2_2_lesson_complete
	SoundEvent \{event = Tutorial_Mode_Finish_Chord_02}
	EnableInput OFF controller = ($player1_status.controller)
	Change \{StructureName = player1_status star_power_usable = 0}
	destroy_menu \{menu_id = menu_tutorial}
	create_training_pause_handler
	wait \{0.75 seconds}
	StopAllSounds
	PauseGame
	PauseGh3Sounds
	training_hide_lesson_header
	training_hide_task_header
	wait \{0.5 seconds ignoreslomo}
	KillCamAnim \{name = ch_view_cam}
	kill_gem_scroller
	destroy_bg_viewport
	setup_bg_viewport
	PlayIGCCam \{id = cs_view_cam_id name = ch_view_cam viewport = bg_viewport LockTo = World Pos = (-0.06880699843168259, 1.5990009307861328, 5.797596454620361) Quat = (0.000506000011228025, 0.9994299411773682, -0.017537998035550117) FOV = 72.0 play_hold = 1 interrupt_current}
	CreateScreenElement {
		Type = TextElement
		parent = training_container
		id = tuning_complete_text
		just = [center center]
		Pos = (640.0, 350.0)
		font = ($training_font)
		text = "Lesson Complete"
		Scale = 1.0
		rgba = ($training_text_color)
	}
	UnpauseGh3Sounds
	UnPauseGame
	wait \{0.5 seconds}
	training_play_sound \{Sound = 'Tutorial_2B_04_Lou' wait}
	safe_destroy \{id = tuning_complete_text}
	wait \{1 seconds}
endscript

script training_2_3_start_gem_scroller
	destroy_band
	training_start_gem_scroller \{song = Tutorial_2C}
	if ScreenElementExists \{id = menu_tutorial}
		LaunchEvent \{Type = unfocus target = menu_tutorial}
		destroy_menu \{menu_id = menu_tutorial}
	endif
	event_handlers = [
		{song_wonp1 training_song_won}
		{star_power_onp1 training_set_star_power_active}
		{pad_start show_training_pause_screen}
	]
	new_menu {
		scrollid = menu_tutorial
		vmenuid = vmenu_tutorial
		menu_pos = (120.0, 190.0)
		use_backdrop = 0
		event_handlers = <event_handlers>
	}
	training_set_lesson_header_text \{text = "LESSON 3: TILT FOR STAR POWER"}
	training_set_lesson_header_body \{text = ""}
	training_show_lesson_header
	safe_show \{id = lou_icon}
	Change \{training_received_star_power = 0}
	Change \{notes_hit = 0}
	Change \{StructureName = player1_status star_power_amount = 0}
	Change \{lesson_complete = 0}
	training_wait_for_gem_scroller_startup
endscript

script training_2_3_explain
	wait \{2.0 seconds ignoreslomo}
	training_pause_gem_scroller
	training_play_sound \{Sound = 'Tutorial_2C_01_lou'}
	training_add_arrow \{id = training_arrow2 life = 6 Pos = (970.0, 430.0) Scale = 0.7 rot = 0}
	wait \{7.0 seconds ignoreslomo}
	CreateScreenElement \{parent = training_container Type = SpriteElement id = guitar_sprite just = [center center] texture = #"0xe63215c3" Pos = (630.0, 400.0) rot_angle = 45 rgba = [255 255 255 255] Scale = (0.800000011920929, 0.800000011920929) z_priority = 4}
	wait \{0.5 seconds ignoreslomo}
	DoScreenElementMorph \{id = guitar_sprite rot_angle = 0 time = 1.0}
	wait \{3.75 seconds ignoreslomo}
	safe_hide \{id = guitar_sprite}
	DoScreenElementMorph \{id = guitar_sprite rot_angle = 45 time = 0.0}
	wait \{10.0 seconds ignoreslomo}
	safe_show \{id = guitar_sprite}
	wait \{1.5 seconds ignoreslomo}
	DoScreenElementMorph \{id = guitar_sprite rot_angle = 0 time = 1.0}
	training_wait_for_sound \{Sound = 'Tutorial_2C_01_lou'}
	training_set_lesson_header_body \{text = "Tilt the guitar upright to activate star power.\nOnce it is activated, you can drop it back down"}
	training_show_lesson_header
	training_set_task_header_body \{text = "Tilt for Star Power and hit 8 notes to continue"}
	training_show_task_header
	training_2_3_destroy_sprites
	training_resume_gem_scroller
endscript
training_star_power_active = 0

script training_set_star_power_active
	Change \{training_star_power_active = 1}
endscript

script training_2_3_wait_for_star_power
	Change \{training_star_power_active = 0}
	Change \{lesson_complete = 0}
	Change \{training_song_over = 0}
	EnableInput controller = ($player1_status.controller)
	Change \{StructureName = player1_status star_power_usable = 1}
	increase_star_power \{amount = 100}
	begin
		if ($training_song_over = 1)
			return
		endif
		if ($training_star_power_active = 1 || $player1_status.star_power_used = 1)
			break
		endif
		wait \{1 gameframe}
	repeat
endscript

script training_2_3_watch_for_notes_hit
	Change \{notes_hit = 0}
	if ScreenElementExists \{id = menu_tutorial}
		LaunchEvent \{Type = unfocus target = menu_tutorial}
		destroy_menu \{menu_id = menu_tutorial}
	endif
	event_handlers = [
		{song_wonp1 training_song_won}
		{hit_notesp1 lesson2_hit_note}
		{pad_start show_training_pause_screen}
	]
	new_menu {
		scrollid = menu_tutorial
		vmenuid = vmenu_tutorial
		menu_pos = (120.0, 190.0)
		use_backdrop = 0
		event_handlers = <event_handlers>
	}
	begin
		printf \{channel = training "notes hit %a " a = $#"0x4c0d1319"}
		Change \{StructureName = player1_status star_power_amount = 100}
		if ($training_song_over = 1)
			printf \{channel = training "done! "}
			return
		endif
		if ($notes_hit >= 8)
			printf \{channel = training "done! "}
			return
		endif
		wait \{1 gameframe}
	repeat
endscript

script training_set_lesson_complete
	printf \{channel = training "setting lesson complete................."}
	Change \{lesson_complete = 1}
endscript

script training_2_tutorial_complete_message
	SoundEvent \{event = Tutorial_Mode_Finish_Chord}
	training_hide_lesson_header
	training_hide_task_header
	safe_hide \{id = lou_icon}
	CreateScreenElement {
		Type = TextElement
		parent = training_container
		id = lesson_complete_text
		just = [center center]
		Pos = (640.0, 350.0)
		font = ($training_font)
		text = "Star Power Tutorial Complete!"
		Scale = 1.0
		rgba = ($training_text_color)
	}
	safe_show \{id = god_icon}
	training_play_sound \{Sound = 'Tutorial_2C_02_god' wait}
	safe_hide \{id = god_icon}
	DestroyScreenElement \{id = lesson_complete_text}
endscript

script training_2_3_destroy_sprites
	safe_destroy \{id = guitar_sprite}
endscript

script training_2_3_end
	printf \{channel = training "training_2_3_end........."}
	wait \{1 seconds ignoreslomo}
	training_2_3_destroy_sprites
	if ScreenElementExists \{id = menu_tutorial}
		destroy_menu \{menu_id = menu_tutorial}
		create_training_pause_handler
	endif
	if ScreenElementExists \{id = notes_hit_text}
		DestroyScreenElement \{id = notes_hit_text}
	endif
	PauseGame
	PauseGh3Sounds
	wait \{0.5 seconds ignoreslomo}
	KillCamAnim \{name = ch_view_cam}
	kill_gem_scroller
	destroy_bg_viewport
	setup_bg_viewport
	PlayIGCCam \{id = cs_view_cam_id name = ch_view_cam viewport = bg_viewport LockTo = World Pos = (-0.06880699843168259, 1.5990009307861328, 5.797596454620361) Quat = (0.000506000011228025, 0.9994299411773682, -0.017537998035550117) FOV = 72.0 play_hold = 1 interrupt_current}
	UnpauseGh3Sounds
	UnPauseGame
endscript

script training_2_end
	training_kill_session
	if ScreenElementExists \{id = training_container}
		DestroyScreenElement \{id = training_container}
	endif
	if ScreenElementExists \{id = menu_tutorial}
		LaunchEvent \{Type = unfocus target = menu_tutorial}
		destroy_menu \{menu_id = menu_tutorial}
	endif
	training_destroy_narrator_icons
	SetScreenElementProps \{id = root_window event_handlers = [{pad_start gh3_start_pressed}] replace_handlers}
	SetGlobalTags \{training params = {star_power_lesson = complete}}
	training_check_for_all_tutorials_finished
	ui_flow_manager_respond_to_action \{action = complete_tutorial}
endscript

script lesson2_hit_note
	Change notes_hit = ($notes_hit + 1)
	if (($notes_hit = 1)|| ($notes_hit = 4))
		GetRandomValue \{name = random_value a = 0 b = 10}
		if (<random_value> < 5)
			training_play_sound \{Sound = 'Tutorial_God_Positive_01'}
		elseif (<random_value> < 10)
			training_play_sound \{Sound = 'Tutorial_God_Positive_02'}
		endif
	endif
	training_display_notes_hit \{notes_hit = $#"0x4c0d1319"}
endscript
