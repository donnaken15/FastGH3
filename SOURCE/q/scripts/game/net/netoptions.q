default_master_servers = [
	{
		name = '205.147.4.17'
	}
	{
		name = '63.241.179.8'
	}
	{
		name = '205.147.28.3'
	}
]
default_network_preferences = {
	game_type = {
		ui_string = "Faceoff"
		checksum = p2_faceoff
	}
	num_players = {
		ui_string = "2 Players"
		checksum = num_2
		value = 2
	}
	private_slots = {
		ui_string = "0 Players"
		checksum = num_0
		value = 0
	}
	Ranked = {
		ui_string = "Player"
		checksum = Player
		value = 1
	}
	num_observers = {
		ui_string = "No Observers"
		checksum = num_1
		value = 1
	}
	team_mode = {
		ui_string = "None"
		checksum = teams_none
	}
	password = {
		ui_string = ""
	}
	level = {
		ui_string = "Houses"
		checksum = load_z_houses
	}
	server_name = {
		ui_string = "Neversoft"
	}
	network_id = {
		ui_string = "Guitar Hero 3"
	}
	ip_address = {
		ui_string = "192.168.0.10"
	}
	gateway = {
		ui_string = "192.168.0.1"
	}
	subnet_mask = {
		ui_string = "255.255.0.0"
	}
	auto_dns = {
		ui_string = "Yes"
		checksum = boolean_true
	}
	dns_server = {
		ui_string = "192.168.0.1"
	}
	dns_server2 = {
		ui_string = "192.168.0.2"
	}
	device_type = {
		ui_string = "None"
		checksum = device_none
	}
	broadband_type = {
		ui_string = "Auto-Detect (DHCP)"
		checksum = ip_dhcp
	}
	host_name = {
		ui_string = ""
	}
	domain_name = {
		ui_string = ""
	}
	skill_level = {
		ui_string = "3: Hold My Own"
		checksum = num_3
	}
	use_default_master_servers = {
		ui_string = "Yes"
		checksum = boolean_true
	}
	show_names = {
		ui_string = "On"
		checksum = boolean_true
	}
	buddy_array = [
	]
}

script launch_network_options_menu
	RunScriptOnScreenElement \{id = current_menu_anchor menu_offscreen callback = create_network_options_menu}
endscript

script back_from_net_options_menu
	go_to_sub_menu = 0
	PauseMusicAndStreams
	if IsTrue \{$InNetOptionsFromNetPlay}
		printf \{"********************* InNetOptionsFromNetPlay *******************"}
		go_to_sub_menu = 1
	else
		if IsTrue \{$InNetOptionsFromFaceDownload}
			printf \{"********************* InNetOptionsFromFaceDownload *******************"}
			go_to_sub_menu = 1
		endif
	endif
	if (<go_to_sub_menu> = 1)
		GetPreferenceChecksum \{pref_type = network device_type}
		switch <checksum>
			case device_none
				if IsTrue \{$InNetOptionsFromNetPlay}
					create_ss_menu
				else
					face_back_from_net_setup
				endif
			default
				if ObjectExists \{id = current_menu_anchor}
					DestroyScreenElement \{id = current_menu_anchor}
				endif
				if IsTrue \{$InNetOptionsFromNetPlay}
					do_network_setup \{error_script = back_from_startup_error_dialog success_script = net_setup_from_net_play_successful need_setup_script = create_net_startup_need_setup_dialog}
				else
					do_network_setup \{error_script = face_back_from_net_setup success_script = create_face_download_menu_from_net_setup need_setup_script = face_create_net_startup_need_setup_dialog}
				endif
		endswitch
		Change \{InNetOptionsFromNetPlay = 0}
		Change \{InNetOptionsFromFaceDownload = 0}
		UnpauseMusicAndStreams
	else
		UnpauseMusicAndStreams
	endif
endscript

script net_options_menu_back_from_keyboard
	destroy_onscreen_keyboard
	create_network_options_menu
endscript

script maybe_load_net_settings
	skater ::Hide
	launch_load_network_settings
endscript

script launch_load_net_config
	RunScriptOnScreenElement \{id = current_menu_anchor menu_offscreen callback = _CreationOptionsLoadNetConfig}
endscript

script back_from_hardware_setup_refused_dialog
	dialog_box_exit
	create_manual_net_setup
endscript

script back_from_load_refused_dialog
	dialog_box_exit
	create_network_options_menu
endscript

script launch_hardware_setup_refused_dialog
	RunScriptOnScreenElement \{id = current_menu_anchor menu_offscreen callback = create_hardware_setup_refused_dialog}
endscript

script create_hardware_setup_refused_dialog
	create_dialog_box \{title = net_notice_msg text = net_error_cant_change_device buttons = [{text = "ok" pad_choose_script = back_from_hardware_setup_refused_dialog}]}
endscript

script create_net_load_refused_dialog
	create_dialog_box \{title = net_notice_msg text = net_error_cant_load_settings buttons = [{text = "back" pad_choose_script = back_from_load_refused_dialog}{text = "restart" pad_choose_script = restart_ps2}]}
endscript

script launch_hardware_setup
	RunScriptOnScreenElement \{id = current_menu_anchor menu_offscreen callback = create_hardware_setup_menu}
endscript

script launch_connection_settings
	if ObjectExists \{id = current_menu_anchor}
		RunScriptOnScreenElement \{id = current_menu_anchor menu_offscreen callback = create_connection_settings}
	else
		dialog_box_exit
		create_connection_settings
	endif
endscript

script back_from_startup_error_dialog
	printf \{"**** in back_from_startup_error_dialog"}
	NetSessionFunc \{func = match_uninit}
	NetSessionFunc \{func = content_uninit}
	NetSessionFunc \{func = presence_uninit}
	Change \{NeedsToDownloadStats = 1}
	UnpauseMusicAndStreams
	dialog_box_exit
	if ObjectExists \{id = select_skater_anchor}
		DestroyScreenElement \{id = select_skater_anchor}
		restore_start_key_binding
	endif
	skater ::CancelRotateDisplay
	create_main_menu
endscript

script create_net_startup_error_dialog
	create_dialog_box {title = net_error_msg
		text = <text>
		buttons = [{text = "ok" pad_choose_script = <error_script>}
		]
	}
endscript
