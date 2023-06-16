#"0x4d8e5ad2" = ''

script #"0xc662b917"
	#"0x1766ab99" {
		mode = loginAccount
		title = "Enter text"
		container = accountLoginContainer
	}
endscript

script #"0x1766ab99"
	// keyboard input hack
	// TODO: better one
	/*printf \{"--- create_winport_account_management_screen"}
	z = 110
	create_menu_backdrop \{texture = #"0x4fb4b5e9"}
	if ((GotParam yellowButtonAction)& (GotParam blueButtonAction))
		Handlers = [
			{focus net_warning_focus}
			{unfocus net_warning_unfocus}
			{pad_choose ui_flow_manager_respond_to_action params = {action = executeLogin}}
			{pad_option2 <yellowButtonAction>}
			{pad_option <blueButtonAction>}
			{pad_back cancel_winport_account_management_screen params = {mode = <mode>}}
		]
	elseif (GotParam yellowButtonAction)
		Handlers = [
			{focus net_warning_focus}
			{unfocus net_warning_unfocus}
			{pad_choose ui_flow_manager_respond_to_action params = {action = executeLogin}}
			{pad_option2 <yellowButtonAction>}
			{pad_back cancel_winport_account_management_screen params = {mode = <mode>}}
		]
	elseif (GotParam blueButtonAction)
		Handlers = [
			{focus net_warning_focus}
			{unfocus net_warning_unfocus}
			{pad_choose ui_flow_manager_respond_to_action params = {action = executeLogin}}
			{pad_option <blueButtonAction>}
			{pad_back cancel_winport_account_management_screen params = {mode = <mode>}}
		]
	else
		Handlers = [
			{focus net_warning_focus}
			{unfocus net_warning_unfocus}
			{pad_choose ui_flow_manager_respond_to_action params = {action = executeLogin}}
			{pad_back cancel_winport_account_management_screen params = {mode = <mode>}}
		]
	endif
	CreateScreenElement {
		Type = ContainerElement
		parent = root_window
		id = <container>
		Pos = (0.0, 0.0)
		event_handlers = <Handlers>
	}
	NetSessionFunc func = InitializeLoginFields params = {loginMode = <mode>}
	displaySprite parent = <container> tex = dialog_title_bg dims = (300.0, 230.0) z = 9 Pos = (640.0, 40.0) just = [right top] flip_v
	displaySprite parent = <container> tex = dialog_title_bg dims = (300.0, 230.0) z = 9 Pos = (640.0, 40.0) just = [left top]
	CreateScreenElement {
		Type = TextElement
		parent = <container>
		font = fontgrid_title_gh3
		Scale = 1.0
		rgba = [223 223 223 250]
		text = <title>
		just = [center top]
		z_priority = 10.0
		Pos = (640.0, 125.0)
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
	}
	fit_text_in_rectangle id = <id> dims = (400.0, 75.0) Pos = (640.0, 125.0) only_if_larger_x = 1 only_if_larger_y = 1 just = center
	CreateScreenElement {
		Type = TextElement
		parent = <container>
		id = capsLockField
		font = text_a4
		Scale = 0.6
		rgba = [255 0 0 255]
		text = "(Caps Lock Is On)"
		just = [center top]
		z_priority = 10.0
		Pos = (640.0, 530.0)
		Shadow
		shadow_offs = (1.0, 1.0)
		shadow_rgba = [0 0 0 255]
	}
	fit_text_in_rectangle id = <id> dims = (600.0, 25.0) Pos = (640.0, 595.0) only_if_larger_x = 1 only_if_larger_y = 1 just = center keep_ar = 1
	<Pos> = (375.0, 290.0)
	create_winport_login_field container = <container> Pos = <Pos> label = "Script:	  " labelId = usernameLabelId prefixId = usernamePrefixId cursorId = usernameCursorId suffixId = usernameSuffixId ang = 0.0
	GetScreenElementDims \{id = usernameLabelId}
	lineHeight = (<height> + 8)
	if (<mode> = loginAccount || <mode> = deleteAccount || <mode> = changeAccount)
		Pos = (<Pos> + ((0.0, 1.0) * <lineHeight>))
		create_winport_login_field container = <container> Pos = <Pos> label = "dummy	  " labelId = passwordLabelId prefixId = passwordPrefixId cursorId = passwordCursorId suffixId = passwordSuffixId ang = 0.2
	endif
	if (<mode> = createAccount || <mode> = changeAccount || <mode> = resetAccount)
		Pos = (<Pos> + ((0.0, 1.0) * <lineHeight>))
		create_winport_login_field container = <container> Pos = <Pos> label = "New Password: " labelId = newPassword1LabelId prefixId = newPassword1PrefixId cursorId = newPassword1CursorId suffixId = newPassword1SuffixId ang = -0.6
		Pos = (<Pos> + ((0.0, 1.0) * <lineHeight>))
		create_winport_login_field container = <container> Pos = <Pos> label = "Repeat New Password: " labelId = newPassword2LabelId prefixId = newPassword2PrefixId cursorId = newPassword2CursorId suffixId = newPassword2SuffixId ang = 0.5
	endif
	if (<mode> = createAccount || <mode> = resetAccount)
		Pos = (<Pos> + ((0.0, 1.0) * <lineHeight>))
		create_winport_login_field container = <container> Pos = <Pos> label = "License: " labelId = licenseLabelId prefixId = licensePrefixId cursorId = licenseCursorId suffixId = licenseSuffixId ang = 1.5
	endif
	add_user_control_helper \{text = "ACCEPT" button = green z = 100}
	add_user_control_helper \{text = $menu_text_back button = red z = 100}
	if GotParam \{yellowButtonText}
		add_user_control_helper text = <yellowButtonText> button = yellow z = 100
	endif
	if GotParam \{blueButtonText}
		add_user_control_helper text = <blueButtonText> button = blue z = 100
	endif
	LaunchEvent Type = focus target = <container>
	begin
		if (IsCapsLockOn)
			SetScreenElementProps \{id = capsLockField alpha = 1.0}
		else
			SetScreenElementProps \{id = capsLockField alpha = 0.0}
		endif
		update_winport_login_field \{Field = username labelId = usernameLabelId prefixId = usernamePrefixId cursorId = usernameCursorId suffixId = usernameSuffixId}
		update_winport_login_field \{Field = password labelId = passwordLabelId prefixId = passwordPrefixId cursorId = passwordCursorId suffixId = passwordSuffixId}
		update_winport_login_field \{Field = newPassword1 labelId = newPassword1LabelId prefixId = newPassword1PrefixId cursorId = newPassword1CursorId suffixId = newPassword1SuffixId}
		update_winport_login_field \{Field = newPassword2 labelId = newPassword2LabelId prefixId = newPassword2PrefixId cursorId = newPassword2CursorId suffixId = newPassword2SuffixId}
		update_winport_login_field \{Field = license labelId = licenseLabelId prefixId = licensePrefixId cursorId = licenseCursorId suffixId = licenseSuffixId}
		wait \{1 Frame}
		if NOT (ScreenElementExists id = <container>)
			return
		endif
		NetSessionFunc \{func = GetLoginEntry}
		if (<loginEntry> = loginAccepted)
			break
		endif
		if (<loginEntry> = loginAborted)
			break
		endif
		if ((GotParam yellowButtonAction)& (<loginEntry> = loginOption1))
			printf \{"Got yellowButtonAction button"}
			break
		endif
		if ((GotParam blueButtonAction)& (<loginEntry> = loginOption2))
			printf \{"Got blueButtonAction button"}
			break
		endif
	repeat
	text = $#"0x4faef07e"
	printstruct <...>
	switch <loginEntry>
		case loginAccepted
			ui_flow_manager_respond_to_action \{action = executeLogin}
		case loginOption1
			printf \{"Executing option 1"}
			ui_flow_manager_respond_to_action \{action = executeOption1}
		case loginOption2
			printf \{"Executing option 2"}
			ui_flow_manager_respond_to_action \{action = executeOption2}
		case loginAborted
			cancel_winport_account_management_screen mode = <mode>
	endswitch*//
endscript
#"0x4faef07e" = ''
#"0x8232b0dc" = ''
#"0x294ccb3a" = ''
#"0x15a8b641" = ''

script #"0xad13e27c"
	FormatText checksumName = Scr '%s' s = ($#"0x4faef07e")
	if (ScriptExists <Scr>)
		spawnscriptnow <Scr>
	endif
endscript
#"0xde5731fa" = {
	create = #"0xc662b917"
	Destroy = destroy_winport_account_login_screen
	actions = [
		{
			action = executeLogin
			func = #"0xad13e27c"
			flow_state = quickplay_pause_options_fs
		}
		{
			action = executeOption1
			flow_state = quickplay_pause_options_fs
		}
		{
			action = executeOption2
			flow_state = quickplay_pause_options_fs
		}
		{
			action = back_to_connection_status
			flow_state = quickplay_pause_options_fs
		}
		{
			action = back_to_main
			flow_state = quickplay_pause_options_fs
		}
	]
}

script lefty_toggle\{player_status = player1_status}
	if ($<player_status>.player = 1)
		toggle_global \{p1_lefty}
		left = $p1_lefty
	else
		toggle_global \{p2_lefty}
		left = $p2_lefty
	endif
	if GotParam \{save}
		if ($<player_status>.player = 1)
			text = 'Player1' // Y U NO WORK FORMATTEXT
		else
			text = 'Player2'
		endif
		FGH3Config sect=<text> 'Lefty' set=<left>
	endif
	Change StructureName = <player_status> lefthanded_gems = <left>
	begin
		if NOT GameIsPaused
			break
		endif
		wait \{1 gameframe}
	repeat
	wait ((0.28 / $current_speedfactor) * $<player_status>.scroll_time) seconds
	animate_lefty_flip other_player_status = <player_status>
	Change StructureName = <player_status> lefthanded_button_ups = <left>
endscript

script wait_beats\{1}
	begin
		last_beat_flip = $beat_flip
		begin
			cur_beat_flip = $beat_flip
			if (<last_beat_flip> != <cur_beat_flip>)
				break
			endif
			wait 1 gameframe
		repeat
	repeat (<#"0x00000000">)
	return
endscript

script everyone_deploy // :P
	player = 1
	begin
		formattext checksumname = player_status 'player%d_status' d = <player>
		if ($<player_status>.bot_play = 1)
			if ($<player_status>.star_power_used = 0)
				if ($<player_status>.star_power_amount >= 50.0)
					spawnscriptnow star_power_activate_and_drain params = {
						player_status = <player_status>
						Player = <player>
						player_text = ($<player_status>.text)
					}
				endif
			endif
		endif
		player = (<player> + 1)
	repeat $current_num_players
endscript

fastgh3_path_triggers = []
// soulless 1 path from CHOpt
//fastgh3_path_triggers = [9446 18638 37851 57127 85851 151148 191936 265276 298148 334978]
script muh_arby_bot_star
	if ($player1_status.bot_play = 0 & $player2_status.bot_play = 0)
		printf \{'bot not turned on!!!!!!!!!!!!!'}
		return
	endif
	if (($game_mode = p2_career || $game_mode = p2_coop) & ($player1_status.bot_play = 0 || $player2_status.bot_play = 0))
		printf \{'co-op with bot, manual triggering by player enabled'}
		return
	endif
	getarraysize \{$fastgh3_path_triggers}
	if (<array_size> = 0)
		printf \{'star power bot: triggering every 16 beats'}
		begin
			wait_beats \{16}
			everyone_deploy
		repeat
	else
		printf \{'star power bot: using provided path'}
		i = 0
		begin
			begin
				GetSongTimeMs
				if ($fastgh3_path_triggers[<i>] < <time>)
					break
				endif
				Wait \{1 gameframe}
			repeat
			Increment \{i}
			everyone_deploy
		repeat <array_size>
	endif
endscript

// TODO: only print necessary info
script PrintPlayer\{player_status = player1_status}
	/**player_status = $<player_status>
	printstruct {
		player = {
			controller = (<player_status>.controller)
			Player = (<player_status>.Player)
			star_power_usable = (<player_status>.star_power_usable)
			star_power_amount = (<player_status>.star_power_amount)
			star_tilt_threshold = (<player_status>.star_tilt_threshold)
			playline_song_measure_time = (<player_status>.playline_song_measure_time)
			star_power_used = (<player_status>.star_power_used)
			current_run = (<player_status>.current_run)
			//resting_whammy_position = (<player_status>.resting_whammy_position)
			bot_play = (<player_status>.bot_play)
			//bot_pattern = (<player_status>.bot_pattern)
			//bot_strum = (<player_status>.bot_strum)
			part = (<player_status>.part)
			lefthanded_gems = (<player_status>.lefthanded_gems)
			current_song_gem_array = (<player_status>.current_song_gem_array)
			//current_song_fretbar_array = (<player_status>.current_song_fretbar_array)
			current_song_star_array = (<player_status>.current_song_star_array)
			//current_star_array_entry = (<player_status>.current_star_array_entry)
			current_song_beat_time = (<player_status>.current_song_beat_time)
			playline_song_beat_time = (<player_status>.playline_song_beat_time)
			current_song_measure_time = (<player_status>.current_song_measure_time)
			//time_in_lead = (<player_status>.time_in_lead)
			hammer_on_tolerance = (<player_status>.hammer_on_tolerance)
			check_time_early = (<player_status>.check_time_early)
			check_time_late = (<player_status>.check_time_late)
			whammy_on = (<player_status>.whammy_on)
			star_power_sequence = (<player_status>.star_power_sequence)
			star_power_note_count = (<player_status>.star_power_note_count)
			score = (<player_status>.score)
			notes_hit = (<player_status>.notes_hit)
			total_notes = (<player_status>.total_notes)
			best_run = (<player_status>.best_run)
			max_notes = (<player_status>.max_notes)
			base_score = (<player_status>.base_score)
			stars = (<player_status>.stars)
			sp_phrases_hit = (<player_status>.sp_phrases_hit)
			sp_phrases_total = (<player_status>.sp_phrases_total)
			multiplier_count = (<player_status>.multiplier_count)
			num_multiplier = (<player_status>.num_multiplier)
			sim_bot_score = (<player_status>.sim_bot_score)
			scroll_time = (<player_status>.scroll_time)
			game_speed = (<player_status>.game_speed)
			highway_speed = (<player_status>.highway_speed)
			//highway_material = (<player_status>.highway_material)
			guitar_volume = (<player_status>.guitar_volume)
			last_guitar_volume = (<player_status>.last_guitar_volume)
			last_faceoff_note = (<player_status>.last_faceoff_note)
			is_local_client = (<player_status>.is_local_client)
			//current_num_powerups = (<player_status>.current_num_powerups)
			death_lick_attack = (<player_status>.death_lick_attack)
			//broken_string_mask = (<player_status>.broken_string_mask)
			//broken_string_green = (<player_status>.broken_string_green)
			//broken_string_red = (<player_status>.broken_string_red)
			//broken_string_yellow = (<player_status>.broken_string_yellow)
			//broken_string_blue = (<player_status>.broken_string_blue)
			//broken_string_orange = (<player_status>.broken_string_orange)
			//gem_filler_enabled_time_on = (<player_status>.gem_filler_enabled_time_on)
			//gem_filler_enabled_time_off = (<player_status>.gem_filler_enabled_time_off)
			current_health = (<player_status>.current_health)
			button_checker_up_time = (<player_status>.button_checker_up_time)
			last_playline_song_beat_time = (<player_status>.last_playline_song_beat_time)
			last_playline_song_beat_change_time = (<player_status>.last_playline_song_beat_change_time)
		}
	}/**/
	//printstruct $<player_status>
endscript

script #"0xbee285d9"
	CreateScreenElement {
		Type = TextElement
		parent = root_window
		id = #"0xd968b859"
		font = text_a1
		Pos = (128.0, 64.0)
		just = [left , top]
		Scale = (1.0, 1.0)
		rgba = [255 255 255 255]
		text = 'test'
		z_priority = 1000
		alpha = 1
	}
	begin
		WinPortSioGetControlPress deviceNum = ($winport_bb_device_num)actionNum = 0
		FormatText textname = text 'test: %d: %d' d = ($winport_bb_device_num)d = <controlNum>
		SetScreenElementProps id = #"0xd968b859" text = <text>
		wait 1 gameframe
	repeat (10000)
	if (ScreenElementExists {
			id = #"0xd968b859"
		})
		DestroyScreenElement {
			id = #"0xd968b859"
		}
	endif
endscript

script ProfilingStart
	//return
	AddParams \{time = 0.0} // fallback if ProfileTime is not patched by FastGH3 plugin
	ProfileTime
	return ____profiling_checkpoint_1 = <time>
endscript
script ProfilingEnd \{ #"0x00000000" = 'unnamed script' ____profiling_i = 0 ____profiling_interval = 60 }
	//return
	AddParams \{time = 0.0}
	ProfileTime
	<____profiling_time> = ((<time> - <____profiling_checkpoint_1>) * 0.0001)
	if NOT GotParam \{ loop }
		printf 'profiled script %s, %t ms' s = <#"0x00000000"> t = <____profiling_time>
		return profile_time = <____profiling_time>
	endif
	Increment \{____profiling_i}
	if (<____profiling_i> > <____profiling_interval>)
		<____profiling_i> = 0
		printf 'profiled script %s, %t ms' s = <#"0x00000000"> t = <____profiling_time> // C++ broken >:(
	endif
	return profile_time = <____profiling_time> ____profiling_i = <____profiling_i>
endscript

