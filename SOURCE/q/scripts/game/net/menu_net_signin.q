loginTextColor = [
	255
	200
	0
	255
]
gPrivateMatchId = 0

script create_winport_account_login_screen
	NetSessionFunc \{func = GetAutoLoginSetting}
	if (<autoLoginSetting> = autoLoginOn & NetSessionFunc func = HasExistingLogin)
		NetSessionFunc \{func = InitializeLoginFields params = {loginMode = loginAccount}}
		ui_flow_manager_respond_to_action \{action = executeLogin}
	else
		create_winport_account_management_screen \{mode = loginAccount title = "Account Login" container = accountLoginContainer yellowButtonText = "CHANGE PASSWORD" yellowButtonAction = start_winport_account_change_screen blueButtonText = "NEW ACCOUNT" blueButtonAction = start_winport_account_create_screen}
	endif
endscript

script destroy_winport_account_login_screen
	destroy_winport_account_management_screen \{container = accountLoginContainer}
endscript

script start_winport_account_login_screen
	ui_flow_manager_respond_to_action \{action = account_login}
endscript

script winport_null_action
endscript

script destroy_winport_account_management_screen
	NetSessionFunc \{func = DestroyLoginFields}
	if (ScreenElementExists id = <container>)
		DestroyScreenElement id = <container>
	endif
	clean_up_user_control_helpers
	destroy_menu_backdrop
endscript

script cancel_winport_account_management_screen
	if (<mode> = loginAccount)
		if (NetSessionFunc func = HasExistingLogin)
			ui_flow_manager_respond_to_action \{action = back_to_main}
		else
			ui_flow_manager_respond_to_action \{action = back_to_connection_status}
		endif
	else
		ui_flow_manager_respond_to_action \{action = back}
	endif
endscript

script create_winport_login_field
	CreateScreenElement {
		Type = ContainerElement
		parent = <container>
		rot_angle = <ang>
	}
	rotContainer = <id>
	CreateScreenElement {
		Type = TextElement
		parent = <rotContainer>
		id = <labelId>
		font = fontgrid_title_gh3
		Scale = 0.8
		rgba = $loginTextColor
		text = <label>
		just = [left top]
		z_priority = 10.0
		Pos = <Pos>
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
	}
	CreateScreenElement {
		Type = TextElement
		parent = <rotContainer>
		id = <prefixId>
		font = fontgrid_title_gh3
		Scale = 0.8
		rgba = $loginTextColor
		text = ""
		just = [left top]
		z_priority = 10.0
		Pos = (300.0, 300.0)
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
	}
	CreateScreenElement {
		Type = TextElement
		parent = <rotContainer>
		id = <cursorId>
		font = fontgrid_title_gh3
		Scale = (0.5, 0.800000011920929)
		rgba = $loginTextColor
		text = "I"
		just = [left top]
		z_priority = 10.0
		Pos = (400.0, 300.0)
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
	}
	CreateScreenElement {
		Type = TextElement
		parent = <rotContainer>
		id = <suffixId>
		font = fontgrid_title_gh3
		Scale = 0.8
		rgba = $loginTextColor
		text = ""
		just = [left top]
		z_priority = 10.0
		Pos = (500.0, 300.0)
		Shadow
		shadow_offs = (3.0, 3.0)
		shadow_rgba = [0 0 0 255]
	}
	RunScriptOnScreenElement id = <cursorId> winport_cursor_blinker params = {blinkId = <cursorId>}
endscript

script update_winport_login_field
	if NOT (ScreenElementExists id = <labelId>)
		return
	endif
	NetSessionFunc func = GetLoginField params = {Field = <Field>}
	if (<Field> = username)
		Change textinput_username = <prefix>
	endif
	if (<Active> = 1)
		SetScreenElementProps id = <prefixId> text = <prefix>
		SetScreenElementProps id = <cursorId> text = "_"
		SetScreenElementProps id = <suffixId> text = <suffix>
	else
		SetScreenElementProps id = <prefixId> text = <prefix>
		SetScreenElementProps id = <cursorId> text = ""
		SetScreenElementProps id = <suffixId> text = ""
	endif
	GetScreenElementDims id = <labelId>
	GetScreenElementPosition id = <labelId>
	Pos = (<ScreenElementPos> + ((1.0, 0.0) * <width>))
	SetScreenElementProps id = <prefixId> Pos = <Pos>
	GetScreenElementPosition id = <prefixId>
	GetScreenElementDims id = <prefixId>
	Pos = (<ScreenElementPos> + ((1.0, 0.0) * <width>))
	SetScreenElementProps id = <cursorId> Pos = <Pos>
	GetScreenElementPosition id = <cursorId>
	GetScreenElementDims id = <cursorId>
	Pos = (<ScreenElementPos> + ((1.0, 0.0) * <width>))
	SetScreenElementProps id = <suffixId> Pos = <Pos>
endscript

script winport_cursor_blinker
	begin
		if NOT (ScreenElementExists id = <blinkId>)
			return
		endif
		DoScreenElementMorph id = <blinkId> alpha = 0 time = 0.5
		wait \{0.5 seconds}
		if NOT (ScreenElementExists id = <blinkId>)
			return
		endif
		DoScreenElementMorph id = <blinkId> alpha = 1.0 time = 0.5
		wait \{0.5 seconds}
	repeat
endscript

script create_winport_account_create_status_screen
	create_winport_account_management_status_screen
endscript

script destroy_winport_account_create_status_screen
	destroy_winport_account_management_status_screen
endscript

script create_winport_account_login_status_screen
	create_winport_account_management_status_screen
endscript

script destroy_winport_account_login_status_screen
	destroy_winport_account_management_status_screen
endscript

script create_winport_account_change_status_screen
	create_winport_account_management_status_screen
endscript

script destroy_winport_account_change_status_screen
	destroy_winport_account_management_status_screen
endscript

script create_winport_account_reset_status_screen
	create_winport_account_management_status_screen
endscript

script destroy_winport_account_reset_status_screen
	destroy_winport_account_management_status_screen
endscript

script create_winport_account_delete_status_screen
	create_winport_account_management_status_screen
endscript

script destroy_winport_account_delete_status_screen
	destroy_winport_account_management_status_screen
endscript

script create_account_change_submenu_status_screen
	create_winport_account_management_status_screen
endscript

script destroy_account_change_submenu_status_screen
	destroy_winport_account_management_status_screen
endscript

script create_account_delete_submenu_status_screen
	create_winport_account_management_status_screen
endscript

script destroy_account_delete_submenu_status_screen
	destroy_winport_account_management_status_screen
endscript

script executeJoinAttempt
	NetSessionFunc \{func = GeneratePrivateMatchId}
	Change gPrivateMatchId = <privateMatchId>
	ui_flow_manager_respond_to_action \{action = attempt_join}
endscript

script destroy_join_private_menu
	NetSessionFunc \{func = DestroyLoginFields}
	DestroyScreenElement \{id = private_menu_container}
	clean_up_user_control_helpers
	destroy_menu_backdrop
endscript

script executeLogout
	NetSessionFunc \{func = ResetNetwork}
	wait \{1.0 Second}
	destroy_logout_submenu
	start_flow_manager \{flow_state = main_menu_fs}
endscript
