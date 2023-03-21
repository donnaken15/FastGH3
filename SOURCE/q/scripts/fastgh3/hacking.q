#"0x4d8e5ad2" = ''

script #"0xc662b917"
	#"0x1766ab99" {
		mode = loginAccount
		title = "Enter text"
		container = accountLoginContainer
	}
endscript

script #"0x1766ab99"
	printf \{"--- create_winport_account_management_screen"}
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
	displaySprite parent = <container> tex = #"0x7464ad56" dims = (300.0, 230.0) z = 9 Pos = (640.0, 40.0) just = [right top] flip_v
	displaySprite parent = <container> tex = #"0x7464ad56" dims = (300.0, 230.0) z = 9 Pos = (640.0, 40.0) just = [left top]
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
		font = #"0x35c0114b"
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
	add_user_control_helper \{text = "BACK" button = red z = 100}
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
	endswitch
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
			action = account_create
			flow_state = online_winport_start_account_create_fs
		}
		{
			action = account_change
			flow_state = online_winport_start_account_change_fs
		}
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
	leftt = 1
	if ($<player_status>.lefthanded_gems = 1)
		leftt = 0
	endif
	Change StructureName = <player_status> lefthanded_gems = <leftt>
	wait 0.95 seconds
	animate_lefty_flip other_player_status = <player_status>
	Change StructureName = <player_status> lefthanded_button_ups = <leftt>
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

script muh_arby_bot_star
	if ($player1_status.bot_play = 0 && $player2_status.bot_play = 0)
		//printf \{'bot not turned on!!!!!!!!!!!!!'}
		return
	endif
	if (($game_mode = p2_career || $game_mode = p2_coop) && ($player1_status.bot_play = 0 || $player2_status.bot_play = 0))
		return
	endif
	begin
		wait_beats \{16}
		player = 1
		begin
			formattext checksumname = player_status 'player%d_status' d = <player>
			if ($<player_status>.bot_play = 1)
				if ($<player_status>.star_power_amount >= 50.0)
					spawnscriptnow star_power_activate_and_drain params = {
						player_status = <player_status>
						Player = <player>
						player_text = ($<player_status>.text)
					}
				endif
			endif
			player = (<player> + 1)
		repeat $current_num_players
	repeat
endscript

// TODO: only print necessary info
script PrintPlayer\{player_status = player1_status}
	printstruct $<player_status>
endscript

script #"0xbee285d9"
	CreateScreenElement {
		Type = TextElement
		parent = root_window
		id = #"0xd968b859"
		font = #"0x45aae5c4"
		Pos = (128.0, 64.0)
		just = [left , top]
		Scale = (1.0, 1.0)
		rgba = [255 , 255 , 255 , 255]
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
