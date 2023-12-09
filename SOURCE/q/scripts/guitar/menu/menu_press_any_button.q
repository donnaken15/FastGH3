
script create_press_any_button_menu
	ReAcquireControllers
	Change \{primary_controller_assigned = 0}
	Change \{main_menu_movie_first_time = 0}
	//SoundEvent \{event = Menu_Guitar_Lick_SFX}
	//spawnscriptnow \{Menu_Music_On params = {waitforguitarlick = 1}}
	create_menu_backdrop \{texture = black}
	CreateScreenElement \{Type = ContainerElement parent = root_window id = pab_container Pos = (0.0, 0.0)}
	menu_press_any_button_create_obvious_text
	spawnscriptnow \{check_for_any_input}
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
endscript

script create_attract_mode_text
endscript

script destroy_attract_mode_text
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
				notify_box scale1 = (0.6, 0.75) scale2 = (0.5, 0.6) container_pos = (0.0, 350.0) container_id = notify_invalid_device line1 = "An unsupported guitar peripheral has been detected." line2 = "Connect either a Guitar Hero guitar or" line3 = "Xbox 360 controller and press START to continue." menu_z = 510000
				CreateScreenElement \{Type = SpriteElement id = controller_fader parent = root_window texture = black rgba = [0 0 0 255] Pos = (640.0, 360.0) dims = (1280.0, 720.0) just = [center center] z_priority = 509000 alpha = 0.7}
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
			spawnscriptnow \{ui_flow_manager_respond_to_action params = {action = continue flow_state_func_params = {device_num = $invite_controller}}}
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
	CreateScreenElement \{ Type = SpriteElement parent = pab_container texture = FastGH3_logo just = [center center] Pos = (640.0, 160.0) Scale = 1.2 }
	CreateScreenElement \{ Type = TextBlockElement parent = pab_container font = fontgrid_title_gh3 text = 'PRESS ANY\nBUTTON TO PLAY' dims = (800.0, 320.0) Pos = (640.0, 320.0) just = [center top] internal_just = [center top] rgba = [255 255 255 255] Scale = 1.4 allow_expansion }
endscript
