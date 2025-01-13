training_battle_tutorial_script = [
	{
		call = training_battle_tutorial_startup
	}
	{
		time = 100
		call = training_3_show_title
	}
	{
		lesson = 1
		call = training_3_1_start_gem_scroller
	}
	{
		call = training_3_1_show_lesson
	}
	{
		call = training_3_1_wait_for_star_power
	}
	{
		call = training_3_2_show_lesson
	}
	{
		call = training_3_2_wait_for_attack
	}
	{
		call = training_3_2_show_complete_message
	}
	{
		lesson = 3
		call = training_3_3_start_gem_scroller
	}
	{
		call = training_3_3_show_lesson
	}
	{
		call = training_3_3_wait_for_attack
	}
	{
		call = training_3_3_wait_for_attack
	}
	{
		call = training_3_3_show_complete_message
	}
	{
		lesson = 4
		call = training_3_4_start_gem_scroller
	}
	{
		call = training_3_4_show_lesson
	}
	{
		call = training_3_4_wait_for_attack
	}
	{
		call = training_3_4_wait_for_attack
	}
	{
		call = training_3_4_show_complete_message
	}
	{
		call = training_basic_tutorial_3_end
	}
]

script training_battle_tutorial_startup
	training_init_session
	LaunchEvent \{Type = unfocus target = root_window}
	Change \{StructureName = player2_status character_id = axel}
	create_guitarist \{name = BASSIST}
	BASSIST ::Hide
	training_create_narrator_icons
endscript

script training_3_show_title
	training_show_title \{title = "Guitar Hero Battle Tutorial"}
	begin
		if ($transitions_locked = 0)
			break
		endif
		wait \{1 gameframe}
	repeat
	create_training_pause_handler
	safe_show \{id = god_icon}
	training_play_sound \{Sound = 'Tutorial_3_Intro_01_God' wait}
	training_destroy_title
endscript

script training_3_1_start_gem_scroller
	destroy_band
	Change \{game_mode = tutorial}
	Change \{boss_battle = 1}
	Change \{tutorial_disable_hud = 1}
	training_start_gem_scroller \{song = Tutorial_3A no_score_update}
	killspawnedscript \{name = update_score_fast}
	training_wait_for_gem_scroller_startup
endscript

script training_3_1_show_lesson
	wait \{1 seconds ignoreslomo}
	training_pause_gem_scroller
	training_set_lesson_header_text \{text = "LESSON 1: ACQUIRING POWERUPS"}
	training_set_lesson_header_body \{text = "1. Complete a Battle Power sequence to receive a Guitar Battle power-up"}
	training_show_lesson_header
	safe_show \{id = god_icon}
	training_play_sound \{Sound = 'Tutorial_3A_01_God' wait}
	training_set_task_header_body \{text = "Hit star sequence to continue"}
	training_show_task_header
	wait \{2 seconds ignoreslomo}
	training_resume_gem_scroller
endscript

script training_3_1_wait_for_star_power
	if ScreenElementExists \{id = menu_tutorial}
		LaunchEvent \{Type = unfocus target = menu_tutorial}
		destroy_menu \{menu_id = menu_tutorial}
	endif
	event_handlers = [
		{song_wonp1 training_song_won}
		{song_wonp2 training_song_won}
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
	begin
		if ($training_song_over = 1)
			return
		endif
		current_num_powerups = ($player1_status.current_num_powerups)
		if (<current_num_powerups> > 0)
			break
		endif
		wait \{1 gameframe}
	repeat
	EnableInput OFF controller = ($player1_status.controller)
	Change \{StructureName = player1_status star_power_usable = 0}
	wait \{1.0 seconds ignoreslomo}
endscript

script training_3_1_show_complete_message
	SoundEvent \{event = Tutorial_Mode_Finish_Chord}
	safe_destroy \{id = notes_hit_text}
	training_hide_lesson_header
	training_hide_task_header
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
	wait \{2 seconds ignoreslomo}
	safe_destroy \{id = tuning_complete_text}
endscript

script training_3_2_show_lesson
	EnableInput OFF controller = ($player1_status.controller)
	training_pause_gem_scroller
	if ($player1_status.current_num_powerups = 0)
		bossbattle_ready \{battle_gem = 0 player_status = player1_status}
	endif
	EnableInput OFF controller = ($player1_status.controller)
	Change \{StructureName = player1_status star_power_usable = 0}
	training_set_lesson_header_text \{text = "LESSON 2: USING POWERUPS"}
	training_set_lesson_header_body \{text = ""}
	training_show_lesson_header
	training_hide_task_header
	safe_hide \{id = god_icon}
	safe_show \{id = lou_icon}
	Change \{StructureName = player1_status last_selected_attack = -1}
	training_play_sound \{Sound = 'Tutorial_3B_01_Lou'}
	wait \{25.5 seconds ignoreslomo}
	//CreateScreenElement \{parent = training_container Type = SpriteElement id = guitar_sprite just = [center center] texture = tutorial_controller_guitar Pos = (400.0, 400.0) rot_angle = 45 rgba = [255 255 255 255] Scale = (0.8, 0.8) z_priority = 50}
	wait \{2.5 seconds ignoreslomo}
	//DoScreenElementMorph \{id = guitar_sprite rot_angle = 0 time = 1.0}
	wait \{3.5 seconds ignoreslomo}
	//safe_hide \{id = guitar_sprite}
	//DoScreenElementMorph \{id = guitar_sprite rot_angle = 45 time = 0.0}
	training_wait_for_sound \{Sound = 'Tutorial_3B_01_Lou'}
	training_set_task_header_body \{text = "Tilt guitar upward to unleash attack"}
	training_show_task_header
	wait \{2 seconds ignoreslomo}
	training_resume_gem_scroller
	EnableInput controller = ($player1_status.controller)
	Change \{StructureName = player1_status star_power_usable = 1}
endscript

script training_3_2_wait_for_attack
	begin
		if ($training_song_over = 1)
			return
		endif
		if ($player2_status.shake_notes != -1)
			break
		endif
		wait \{1 gameframe}
	repeat
	wait \{1.5 seconds ignoreslomo}
endscript

script training_3_2_show_complete_message
	SoundEvent \{event = Tutorial_Mode_Finish_Chord}
	if ScreenElementExists \{id = menu_tutorial}
		destroy_menu \{menu_id = menu_tutorial}
	endif
	create_training_pause_handler
	safe_destroy \{id = notes_hit_text}
	training_hide_lesson_header
	training_hide_task_header
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
	wait \{2 seconds ignoreslomo}
	safe_hide \{id = lou_icon}
	safe_destroy \{id = tuning_complete_text}
endscript

script training_3_3_start_gem_scroller
	destroy_band
	Change \{game_mode = tutorial}
	Change \{boss_battle = 1}
	Change \{tutorial_disable_hud = 1}
	training_start_gem_scroller \{song = Tutorial_3C disable_hud no_score_update}
	killspawnedscript \{name = update_score_fast}
	training_wait_for_gem_scroller_startup
endscript

script training_3_3_show_lesson
	wait \{1 seconds ignoreslomo}
	Change \{StructureName = player1_status current_num_powerups = 0}
	bossbattle_ready \{battle_gem = 5 player_status = player2_status}
	wait \{1.0 seconds ignoreslomo}
	training_pause_gem_scroller
	training_set_lesson_header_text \{text = "LESSON 3: DIFFERENT ATTACKS"}
	training_set_lesson_header_body \{text = ""}
	training_show_lesson_header
	training_hide_task_header
	safe_show \{id = god_icon}
	training_play_sound \{Sound = 'Tutorial_3C_01_God' wait}
	training_set_task_header_body \{text = "Quickly tap the button of the broken string"}
	training_show_task_header
	wait \{1 seconds ignoreslomo}
	training_resume_gem_scroller
	wait \{1 seconds ignoreslomo}
	bossbattle_trigger_on \{player_status = player2_status}
	wait \{1 seconds ignoreslomo}
	if ScreenElementExists \{id = menu_tutorial}
		LaunchEvent \{Type = unfocus target = menu_tutorial}
		destroy_menu \{menu_id = menu_tutorial}
	endif
	event_handlers = [
		{song_wonp1 training_song_won}
		{song_wonp2 training_song_won}
		{pad_start show_training_pause_screen}
	]
	new_menu {
		scrollid = menu_tutorial
		vmenuid = vmenu_tutorial
		menu_pos = (120.0, 190.0)
		use_backdrop = 0
		event_handlers = <event_handlers>
	}
endscript

script training_3_3_wait_for_attack
	begin
		if ($training_song_over = 1)
			return
		endif
		if ($player1_status.broken_string_mask = 0)
			break
		endif
		wait \{1 gameframe}
	repeat
endscript

script training_3_3_show_complete_message
	if ScreenElementExists \{id = menu_tutorial}
		destroy_menu \{menu_id = menu_tutorial}
	endif
	create_training_pause_handler
	wait \{0.75 seconds ignoreslomo}
	SoundEvent \{event = Tutorial_Mode_Finish_Chord_03}
	safe_destroy \{id = notes_hit_text}
	training_hide_lesson_header
	training_hide_task_header
	PauseGame
	PauseGh3Sounds
	StopAllSounds
	wait \{0.5 seconds ignoreslomo}
	KillCamAnim \{name = ch_view_cam}
	kill_gem_scroller
	destroy_bg_viewport
	setup_bg_viewport
	PlayIGCCam \{id = cs_view_cam_id name = ch_view_cam viewport = bg_viewport LockTo = World Pos = (-0.06880699843168259, 1.5990009307861328, 5.797596454620361) Quat = (0.000506000011228025, 0.9994299411773682, -0.017537998035550117) FOV = 72.0 play_hold = 1 interrupt_current}
	UnpauseGh3Sounds
	UnPauseGame
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
	wait \{2.0 seconds ignoreslomo}
	safe_hide \{id = god_icon}
	safe_destroy \{id = tuning_complete_text}
endscript

script training_3_4_start_gem_scroller
	destroy_band
	Change \{game_mode = tutorial}
	Change \{boss_battle = 1}
	Change \{tutorial_disable_hud = 1}
	training_start_gem_scroller \{song = Tutorial_3D disable_hud no_score_update}
	killspawnedscript \{name = update_score_fast}
	training_wait_for_gem_scroller_startup
endscript

script training_3_4_show_lesson
	wait \{1 seconds ignoreslomo}
	training_pause_gem_scroller
	training_set_lesson_header_text \{text = "LESSON 4: MULTIPLE ATTACKS"}
	training_set_lesson_header_body \{text = ""}
	training_show_lesson_header
	training_hide_task_header
	safe_show \{id = lou_icon}
	Change \{StructureName = player1_status last_selected_attack = -1}
	training_play_sound \{Sound = 'Tutorial_3D_01_Lou' wait}
	training_set_task_header_body \{text = "Use both attacks to damage opponent"}
	training_show_task_header
	Change \{StructureName = player1_status current_num_powerups = 0}
	bossbattle_ready \{battle_gem = 0 player_status = player1_status}
	bossbattle_ready \{battle_gem = 2 player_status = player1_status}
	EnableInput OFF controller = ($player1_status.controller)
	Change \{StructureName = player1_status star_power_usable = 0}
	wait \{2 seconds ignoreslomo}
	training_resume_gem_scroller
	if ScreenElementExists \{id = menu_tutorial}
		LaunchEvent \{Type = unfocus target = menu_tutorial}
		destroy_menu \{menu_id = menu_tutorial}
	endif
	event_handlers = [
		{song_wonp1 training_song_won}
		{song_wonp2 training_song_won}
		{pad_start show_training_pause_screen}
	]
	new_menu {
		scrollid = menu_tutorial
		vmenuid = vmenu_tutorial
		menu_pos = (120.0, 190.0)
		use_backdrop = 0
		event_handlers = <event_handlers>
	}
	EnableInput controller = ($player1_status.controller)
	Change \{StructureName = player1_status star_power_usable = 1}
endscript

script training_3_4_wait_for_attack
	old_num_attacks = ($player1_status.current_num_powerups)
	begin
		if ($training_song_over = 1)
			return
		endif
		num_attacks = ($player1_status.current_num_powerups)
		if (<num_attacks> < <old_num_attacks>)
			break
		endif
		if (<num_attacks> > <old_num_attacks>)
			old_num_attacks = <num_attacks>
		endif
		wait \{1 gameframe}
	repeat
endscript

script training_3_4_show_complete_message
	if ScreenElementExists \{id = menu_tutorial}
		destroy_menu \{menu_id = menu_tutorial}
	endif
	create_training_pause_handler
	wait \{0.75 seconds ignoreslomo}
	SoundEvent \{event = Tutorial_Mode_Finish_Chord_03}
	safe_destroy \{id = notes_hit_text}
	training_hide_lesson_header
	training_hide_task_header
	PauseGame
	PauseGh3Sounds
	StopAllSounds
	wait \{0.5 seconds ignoreslomo}
	KillCamAnim \{name = ch_view_cam}
	kill_gem_scroller
	destroy_bg_viewport
	setup_bg_viewport
	PlayIGCCam \{id = cs_view_cam_id name = ch_view_cam viewport = bg_viewport LockTo = World Pos = (-0.06880699843168259, 1.5990009307861328, 5.797596454620361) Quat = (0.000506000011228025, 0.9994299411773682, -0.017537998035550117) FOV = 72.0 play_hold = 1 interrupt_current}
	UnpauseGh3Sounds
	UnPauseGame
	CreateScreenElement {
		Type = TextElement
		parent = training_container
		id = tuning_complete_text
		just = [center center]
		Pos = (640.0, 350.0)
		font = ($training_font)
		text = "Guitar Battle Tutorial Complete"
		Scale = 1.0
		rgba = ($training_text_color)
	}
	wait \{0.5 seconds ignoreslomo}
	training_play_sound \{Sound = 'Tutorial_3_outro' wait}
	safe_hide \{id = lou_icon}
	safe_destroy \{id = tuning_complete_text}
endscript

script training_basic_tutorial_3_end
	training_kill_session
	Change \{tutorial_disable_hud = 0}
	if ScreenElementExists \{id = training_container}
		DestroyScreenElement \{id = training_container}
	endif
	if ScreenElementExists \{id = menu_tutorial}
		LaunchEvent \{Type = unfocus target = menu_tutorial}
		destroy_menu \{menu_id = menu_tutorial}
	endif
	training_destroy_narrator_icons
	SetScreenElementProps \{id = root_window event_handlers = [{pad_start gh3_start_pressed}] replace_handlers}
	SetGlobalTags \{training params = {guitar_battle_lesson = complete}}
	training_check_for_all_tutorials_finished
	ui_flow_manager_respond_to_action \{action = complete_tutorial}
endscript
