controller_unplugged_frame_count = 5
unplugged_controller = -1

script controller_unplugged
	printf \{"--- controller_unplugged"}
	Change unplugged_controller = <device_num>
	if ($playing_song = 1)
		if NOT GameIsPaused
			ui_flow_manager_respond_to_action \{action = controller_disconnect}
			Change \{check_for_unplugged_controllers = 0}
		endif
	else
		if isps3
			create_controller_disconnect_menu
			Change \{check_for_unplugged_controllers = 0}
		endif
	endif
	if NOT GameIsPaused
		gh3_start_pressed \{no_back}
	endif
endscript

script create_controller_unplugged_dialog\{pad_choose_script = controller_refresh}
	printf \{"--- create_controller_unplugged_dialog"}
	if ScreenElementExists \{id = ui_mainmenu_wait_anchor}
		return
	endif
	if isXenon
		if InFrontEnd
			return
		endif
	endif
	if InNetGame
		return
	endif
	if ScreenElementExists \{id = link_lost_dialog_anchor}
		dialog_box_exit \{anchor_id = link_lost_dialog_anchor}
	endif
	sysnotify_wait_until_safe
	wait \{1 Frame}
	sysnotify_handle_pause
	SetScreenElementLock \{id = root_window OFF}
	if NOT InFrontEnd
		if IsMoviePlaying \{textureSlot = 0}
			PauseMovie \{textureSlot = 0}
		endif
		if IsMoviePlaying \{textureSlot = 1}
			PauseMovie \{textureSlot = 1}
		endif
	endif
	if GotParam \{leaving_net_game}
		CreatePlatformMessageBox {
			title = "CONTROLLER DISCONNECTED"
			message = "Please reconnect the controller."
			buttons = [
				"GO TO MAIN MENU"
			]
			user = <device_num>
			active_button = 0
		}
		controller_reconnected \{leaving_net_game}
	else
		CreatePlatformMessageBox {
			title = "CONTROLLER"
			message = "Please reconnect the controller."
			buttons = [
				"CONTINUE"
			]
			user = <device_num>
			active_button = 0
		}
		controller_reconnected
	endif
	if NOT InFrontEnd
		if IsMoviePlaying \{textureSlot = 0}
			ResumeMovie \{textureSlot = 0}
		endif
		if IsMoviePlaying \{textureSlot = 1}
			ResumeMovie \{textureSlot = 1}
		endif
	endif
endscript

script controller_refresh
	if (<original_device_num> = <device_num>)
		controller_reconnected <...>
		if NOT (AbortScript = DefaultAbortScript)
			Goto \{reload_anims_then_run_abort_script}
		endif
	endif
endscript

script controller_reconnected
	if NOT GotParam \{leaving_net_game}
		if NOT InFrontEnd
			if NOT ScreenElementExists \{id = view_goals_root}
				if NOT ScreenElementExists \{id = timeline_vmenu}
					Restore_skater_camera
				endif
			endif
		endif
	endif
	dialog_box_exit \{anchor_id = link_lost_dialog_anchor dont_focus}
	if ScreenElementExists \{id = controller_unplugged_dialog_anchor}
		DestroyScreenElement \{id = controller_unplugged_dialog_anchor}
	endif
	if ScreenElementExists \{id = keyboard_vmenu}
		LaunchEvent \{Type = focus target = keyboard_vmenu}
	endif
	if NOT GotParam \{leaving_net_game}
		sysnotify_handle_unpause
	endif
	if ScreenElementExists \{id = dialog_box_anchor}
		LaunchEvent \{Type = focus target = dialog_box_vmenu}
		DoScreenElementMorph \{id = dialog_box_anchor alpha = 1}
	else
		if ScreenElementExists \{id = current_menu_anchor}
			LaunchEvent \{Type = focus target = current_menu_anchor}
			if ScreenElementExists \{id = current_menu}
				LaunchEvent \{Type = focus target = current_menu}
			endif
		endif
	endif
	if GotParam \{leaving_net_game}
		printf \{"quitting network game!!!!!!!!!!!!!!!!!!!"}
		UnPauseGame
		quit_network_game
	else
		SpawnScriptLater \{wait_and_check_for_unplugged_controllers}
	endif
endscript

script wait_and_check_for_unplugged_controllers\{time = 50}
	wait <time>
	Change \{check_for_unplugged_controllers = 1}
endscript
