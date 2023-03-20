
script create_press_any_button_menu
	ReAcquireControllers
	Change \{primary_controller_assigned = 0}
	Change \{main_menu_movie_first_time = 0}
	SoundEvent \{event = Menu_Guitar_Lick_SFX}
	spawnscriptnow \{Menu_Music_On params = {waitforguitarlick = 1}}
	create_menu_backdrop \{texture = #"0x767a45d7"}
	CreateScreenElement \{Type = ContainerElement parent = root_window id = pab_container Pos = (0.0, 0.0)}
	menu_press_any_button_create_obvious_text
	spawnscriptnow \{check_for_any_input}
	if NotCD
		if ($show_movies = 0)
			return
		endif
	endif
	spawnscriptnow \{attract_mode_spawner}
endscript

script destroy_press_any_button_menu
	destroy_menu \{menu_id = pab_container}
	destroy_menu_backdrop
	killspawnedscript \{name = check_for_any_input}
	killspawnedscript \{name = attract_mode_spawner}
endscript

script attract_mode_spawner
endscript
last_attract_mode = -1
is_attract_mode = 0

script create_attract_mode
	Change \{is_attract_mode = 1}
	create_loading_screen
	SoundBussUnlock \{Guitar_Balance}
	SoundBussUnlock \{Band_Balance}
	SetSoundBussParams \{Guitar_Balance = {vol = -100.0}time = 1.5}
	SetSoundBussParams \{Band_Balance = {vol = -100.0}time = 1.5}
	SoundBussLock \{Guitar_Balance}
	SoundBussLock \{Band_Balance}
	kill_start_key_binding
	GetArraySize \{$#"0x17c1708b"}
	if (<array_Size> = 1)
		attract_mode_index = 0
	else
		if ($last_attract_mode >= 0)
			GetRandomValue name = attract_mode_index integer a = 0 b = (<array_Size> - 2)
			if (<attract_mode_index> >= $last_attract_mode)
				attract_mode_index = (<attract_mode_index> + 1)
			endif
		else
			GetRandomValue name = attract_mode_index integer a = 0 b = (<array_Size> - 1)
		endif
		Change last_attract_mode = <attract_mode_index>
	endif
	p1_outfit = 1
	p2_outfit = 1
	p1_style = 1
	p2_style = 1
	AddParams ($Attract_Mode_Info [<attract_mode_index>])
	Change \{StructureName = player1_status bot_play = 1}
	Change \{StructureName = player2_status bot_play = 1}
	Change current_level = <level>
	Change game_mode = <mode>
	if ($game_mode = p2_faceoff || $game_mode = p2_pro_faceoff)
		Change \{current_num_players = 2}
	else
		Change \{current_num_players = 1}
	endif
	Change StructureName = player1_status character_id = <p1_character_id>
	Change StructureName = player2_status character_id = <p2_character_id>
	Change StructureName = player1_status instrument_id = <p1_instrument_id>
	Change StructureName = player2_status instrument_id = <p2_instrument_id>
	Change StructureName = player1_status outfit = <p1_outfit>
	Change StructureName = player2_status outfit = <p2_outfit>
	Change StructureName = player1_status style = <p1_style>
	Change StructureName = player2_status style = <p2_style>
	SoundBussUnlock \{Master}
	SetSoundBussParams \{Master = {vol = -11.0}time = 0.5}
	SoundBussLock \{Master}
	mark_unsafe_for_shutdown
	UnPauseGame
	Load_Venue
	start_gem_scroller song_name = <song> difficulty = <p1_difficulty> difficulty2 = <p2_difficulty> startTime = 0 device_num = ($player1_status.controller)
	create_attract_mode_text
	StopRendering
	destroy_loading_screen
	SoundBussUnlock \{Guitar_Balance}
	SoundBussUnlock \{Band_Balance}
	SetSoundBussParams {Guitar_Balance = {vol = (($Default_BussSet.Guitar_Balance.vol)- 1.5)}}
	SetSoundBussParams {Band_Balance = {vol = (($Default_BussSet.Band_Balance.vol)- 1.5)}}
	SoundBussLock \{Guitar_Balance}
	SoundBussLock \{Band_Balance}
	spawnscriptnow \{check_for_attract_mode_input}
endscript

script create_attract_mode_text
	CreateScreenElement \{Type = ContainerElement parent = root_window id = am_container Pos = (0.0, 0.0)}
	text = " PRESS GREEN TWICE TO ROCK "
	text_pos = (640.0, 637.0)
	CreateScreenElement {
		Type = TextElement
		text = <text>
		Pos = <text_pos>
		parent = am_container
		rgba = [220 220 220 255]
		font = fontgrid_title_gh3
		just = [center bottom]
		Scale = 0.9
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [110 20 80 250]
	}
	CreateScreenElement \{Type = SpriteElement parent = am_container texture = #"0xda2408b2" dims = (225.0, 225.0) Pos = (640.0, 490.0) just = [center center]}
endscript

script destroy_attract_mode_text
	destroy_menu \{menu_id = am_container}
	StopAllSounds
	SoundBussUnlock \{Master}
	SetSoundBussParams {Master = {vol = ($Default_BussSet.Master.vol)}}
	SoundBussLock \{Master}
endscript

script check_for_attract_mode_input
	begin
		GetButtonsPressed
		if NOT (<makes> = 0)
			break
		endif
		if NOT ($invite_controller = -1)
			break
		endif
		wait \{1 gameframe}
	repeat
	wait_for_safe_shutdown
	spawnscriptnow \{ui_flow_manager_respond_to_action params = {action = exit_attract_mode}}
endscript

script destroy_attract_mode
	PauseGame
	destroy_attract_mode_text
	killspawnedscript \{name = check_for_attract_mode_input}
	kill_gem_scroller
	Change \{StructureName = player1_status bot_play = 0}
	Change \{StructureName = player2_status bot_play = 0}
	UnPauseGame
	kill_start_key_binding
	Change \{is_attract_mode = 0}
endscript
invalid_controller_lock = 0

script check_for_any_input\{button1 = {}button2 = {}}
	begin
		GetButtonsPressed
		if (<makes> = 0)
			break
		endif
		wait \{1 gameframe}
	repeat
	begin
		if NOT IsWinPort
			if IsStandardGuitarControllerPluggedIn
				if English
					notify_box scale1 = (0.6000000238418579, 0.75) scale2 = (0.5, 0.6000000238418579) container_pos = (0.0, 350.0) container_id = notify_invalid_device line1 = "An unsupported guitar peripheral has been detected." line2 = "Connect either a Guitar Hero guitar or" line3 = "Xbox 360 controller and press START to continue." menu_z = 510000 FormatText textname = pakname '%s_text.pak' s = <stem>
				elseif French
					notify_box \{scale1 = (0.6000000238418579, 0.75) scale2 = (0.5, 0.6000000238418579) container_pos = (0.0, 350.0) container_id = notify_invalid_device line1 = "Une guitare non compatible a été détectée." line2 = "Veuillez connecter une manette guitare Guitar Hero ou une" line3 = "manette Xbox 360, et appuyez sur Start pour continuer." menu_z = 510000}
				elseif Italian
					notify_box \{scale1 = (0.6000000238418579, 0.75) scale2 = (0.5, 0.6000000238418579) container_pos = (0.0, 350.0) container_id = notify_invalid_device line1 = "È stato rilevato un controller chitarra non supportato." line2 = "Connettere una chitarra di Guitar Hero o" line3 = "un Controller Xbox 360 e premere START per continuare." menu_z = 510000}
				elseif German
					notify_box \{scale1 = (0.3800000250339508, 0.75) scale2 = (0.5, 0.6000000238418579) container_pos = (0.0, 350.0) container_id = notify_invalid_device line1 = "Ein Peripheriegerät wurde gefunden, das nicht von der Xbox 360 Konsole unterstützt wird." line2 = "Schließen Sie entweder eine Guitar Hero-Gitarre oder einen" line3 = "Xbox 360 Controller an und drücken Sie START, um fortzufahren." menu_z = 510000}
				elseif Spanish
					notify_box \{scale1 = (0.45000001788139343, 0.75) scale2 = (0.5, 0.6000000238418579) container_pos = (0.0, 350.0) container_id = notify_invalid_device line1 = "Se ha detectado un mando de guitarra periférico incompatible con la consola." line2 = "Conecta el mando de guitarra de Guitar Hero o" line3 = "el Mando Xbox 360 y pulsa START para continuar." menu_z = 510000}
				endif
				CreateScreenElement \{Type = SpriteElement id = controller_fader parent = root_window texture = #"0x767a45d7" rgba = [0 0 0 255] Pos = (640.0, 360.0) dims = (1280.0, 720.0) just = [center center] z_priority = 509000 alpha = 0.7}
				Change \{invalid_controller_lock = 1}
				begin
					if NOT IsStandardGuitarControllerPluggedIn
						break
					endif
					wait \{1 gameframe}
				repeat
				kill_notify_box \{container_id = notify_invalid_device}
				DestroyScreenElement \{id = controller_fader}
				Change \{invalid_controller_lock = 0}
			endif
		endif
		if NOT ($invite_controller = -1)
			spawnscriptnow ui_flow_manager_respond_to_action params = {action = continue flow_state_func_params = {device_num = ($invite_controller)}}
			break
		endif
		continue = 0
		if GotParam \{use_primary_controller}
			if GuitarControllerMake <button1> ($primary_controller)
				<continue> = 1
			elseif GuitarControllerMake <button2> ($primary_controller)
				<continue> = 1
			endif
		else
			GetButtonsPressed <button1>
			if NOT (<makes> = 0)
				<continue> = 1
			endif
		endif
		if (<continue> = 1)
			spawnscriptnow ui_flow_manager_respond_to_action params = {action = continue flow_state_func_params = {device_num = <device_num>}}
			break
		endif
		wait \{1 gameframe}
	repeat
endscript

script menu_press_any_button_create_obvious_text
	text = "PRESS ANY\nBUTTON TO PLAY\n"
	text_pos = (400.0, 256.0)
	CreateScreenElement {
		Type = TextBlockElement
		parent = pab_container
		font = fontgrid_title_gh3
		text = <text>
		dims = (480.0, 320.0)
		Pos = <text_pos>
		just = [left top]
		internal_just = [center top]
		rgba = [255 255 255 255]
		Scale = 1.0
		allow_expansion
	}
endscript
