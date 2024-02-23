winport_bb_device_num = 0
winport_bb_text_color = [
	202
	243
	113
	255
]
winport_bb_text_dropshadow_color = [
	0
	0
	0
	255
]
winport_bb_text_highlight_color = [
	64
	184
	246
	255
]
winport_bb_text_disable_color = [
	139
	198
	17
	255
]
winport_bb_kb_menuItems = [
	{
		text = "Green Fret / Confirm"
		handler = winport_bb_choose_control
		actionNum = 0
	}
	{
		text = "Red Fret / Cancel"
		handler = winport_bb_choose_control
		actionNum = 1
	}
	{
		text = "Yellow Fret"
		handler = winport_bb_choose_control
		actionNum = 2
	}
	{
		text = "Blue Fret"
		handler = winport_bb_choose_control
		actionNum = 3
	}
	{
		text = "Orange Fret"
		handler = winport_bb_choose_control
		actionNum = 4
	}
	{
		text = "Star Power"
		handler = winport_bb_choose_control
		actionNum = 5
	}
	{
		text = "Whammy"
		handler = winport_bb_choose_control
		actionNum = 12
	}
	{
		text = "Mouse Whammy"
		controlName = "X-Axis"
		handler = winport_null_script
		disable
	}
	{
		text = "Strum Up / Menu Up"
		handler = winport_bb_choose_control
		actionNum = 10
	}
	{
		text = "Strum Down / Menu Down"
		handler = winport_bb_choose_control
		actionNum = 9
	}
	{
		text = ""
		handler = winport_null_script
		disable
	}
	{
		text = "Reset to Default Keyboard/Mouse"
		handler = winport_bb_reset_to_config1
	}
	{
		text = "Reset to Default Keyboard"
		handler = winport_bb_reset_to_config2
	}
]
winport_bb_menuItems = [
]

script winport_null_script
endscript

script winport_create_bind_buttons
	Change \{winport_bb_menuItems = $winport_bb_kb_menuItems}
	menuDim = (600.0, 500.0)
	menuPos = (640.0, 370.0)
	menuItemDim = (600.0, 32.0)
	menuItemOptionDim = (250.0, 32.0)
	menuItemOptionPos = (0.0, 16.0)
	menuItemOptionJust = [left center]
	menuItemValueDim = (300.0, 32.0)
	menuItemValuePos = (630.0, 16.0)
	menuItemValueJust = [right center]
	menuItemHiliteDim = (665.0, 50.0)
	menuItemHilitePos = (-25.0, 34.0)
	menuItemHiliteJust = [left center]
	menuItemHiliteRot = -0.5
	CreateScreenElement \{Type = ContainerElement parent = root_window id = screen_container Pos = (0.0, 0.0) just = [left top]}
	create_menu_backdrop \{texture = Venue_BG}
	CreateScreenElement \{Type = SpriteElement id = light_overlay parent = screen_container texture = Venue_Overlay Pos = (640.0, 360.0) dims = (1280.0, 720.0) just = [center center] z_priority = 100}
	displaySprite \{parent = screen_container tex = controller_config_poster Pos = (640.0, 360.0) Scale = (1.5, 1.7000000476837158) just = [center center] z = 1 rot_angle = -2}
	CreateScreenElement \{Type = TextElement parent = screen_container text = "KEYBOARD" Pos = (830.0, 100.0) Scale = (1.5099999904632568, 1.2999999523162842) just = [center center] rgba = [202 243 113 255] font = #"0x42c721dd" z_priority = 10 rot_angle = -2.8 Shadow shadow_rgba = [0 0 0 255] shadow_offs = (-3.0, 3.0)}
	//displaySprite \{parent = screen_container tex = Tape_V_01 Pos = (205.0, 65.0) dims = (96.0, 192.0) z = 5 rot_angle = -1}
	//displaySprite \{parent = screen_container tex = Tape_V_01 rgba = [0 0 0 128] Pos = (202.0, 68.0) dims = (96.0, 192.0) z = 4 rot_angle = -1}
	//displaySprite \{parent = screen_container tex = tape_H_02 Pos = (945.0, 550.0) dims = (132.0, 64.0) z = 5 rot_angle = 8}
	//displaySprite \{parent = screen_container tex = tape_H_02 rgba = [0 0 0 128] Pos = (942.0, 553.0) dims = (132.0, 64.0) z = 4 rot_angle = 8}
	CreateScreenElement {
		Type = VMenu
		id = menu
		parent = screen_container
		Pos = <menuPos>
		dims = <menuDim>
		rot_angle = -2
		just = [center center]
		event_handlers = $default_event_handlers
	}
	menuTextProps = {
		Type = TextElement
		font = text_a11
		Scale = (0.699999988079071, 0.5)
		rgba = $winport_bb_text_color
		z_priority = 20
		Shadow
		shadow_rgba = $winport_bb_text_dropshadow_color
		shadow_offs = (-1.5, 1.5)
	}
	GetArraySize \{$winport_bb_menuItems}
	i = 0
	begin
		FormatText checksumName = itemId 'item%d' d = <i>
		FormatText checksumName = actionId 'action%d' d = <i>
		FormatText checksumName = controlId 'control%d' d = <i>
		FormatText checksumName = hiliteId 'hilite%d' d = <i>
		CreateScreenElement {
			Type = ContainerElement
			id = <itemId>
			parent = menu
			dims = <menuItemDim>
		}
		SetScreenElementProps {
			id = <itemId>
			event_handlers = [
				{pad_choose (($winport_bb_menuItems [<i>]).handler)params = {index = <i> menuItem = ($winport_bb_menuItems [<i>])}}
				{focus winport_bb_focus params = {index = <i>}}
				{unfocus winport_bb_unfocus params = {index = <i>}}
			]
		}
		CreateScreenElement {
			Type = SpriteElement
			id = <hiliteId>
			parent = <itemId>
			texture = controller_config_highlight
			Pos = <menuItemHilitePos>
			dims = <menuItemHiliteDim>
			just = <menuItemHiliteJust>
			rot_angle = <menuItemHiliteRot>
			alpha = 0
			z_priority = 3
		}
		CreateScreenElement {
			<menuTextProps>
			id = <actionId>
			text = (($winport_bb_menuItems [<i>]).text)
			parent = <itemId>
			dims = <menuItemOptionDim>
			Pos = <menuItemOptionPos>
			just = <menuItemOptionJust>
		}
		CreateScreenElement {
			<menuTextProps>
			id = <controlId>
			text = ""
			parent = <itemId>
			dims = <menuItemValueDim>
			Pos = <menuItemValuePos>
			just = <menuItemValueJust>
		}
		if StructureContains structure = ($winport_bb_menuItems [<i>])name = disable
			SetScreenElementProps id = <itemId> not_focusable
			SetScreenElementProps id = <actionId> rgba = $winport_bb_text_disable_color
			SetScreenElementProps id = <controlId> rgba = $winport_bb_text_disable_color
		endif
		i = (<i> + 1)
	repeat <array_Size>
	winport_bb_update_option_values
	LaunchEvent \{Type = focus target = menu}
	Change \{user_control_pill_text_color = [0 0 0 255]}
	Change \{user_control_pill_color = [180 180 180 255]}
	common_control_helpers \{select back nav}
endscript

script winport_destroy_bind_buttons
	DestroyScreenElement \{id = screen_container}
	clean_up_user_control_helpers
endscript

script winport_bb_update_option_values
	GetArraySize \{$winport_bb_menuItems}
	i = 0
	begin
		FormatText checksumName = controlId 'control%d' d = <i>
		if StructureContains structure = ($winport_bb_menuItems [<i>])name = actionNum
			WinPortSioGetControlBinding deviceNum = $winport_bb_device_num actionNum = (($winport_bb_menuItems [<i>]).actionNum)
			WinPortSioGetControlName deviceNum = $winport_bb_device_num controlNum = <controlNum>
			SetScreenElementProps id = <controlId> text = <controlName>
		elseif StructureContains structure = ($winport_bb_menuItems [<i>])name = controlName
			SetScreenElementProps id = <controlId> text = (($winport_bb_menuItems [<i>]).controlName)
		endif
		i = (<i> + 1)
	repeat <array_Size>
endscript

script winport_bb_choose_control
	LaunchEvent \{Type = unfocus target = menu}
	winport_bb_focus index = <index>
	FormatText checksumName = controlId 'control%d' d = <index>
	SetScreenElementProps id = <controlId> rgba = $winport_bb_text_highlight_color
	winport_wait_for_no_control_press deviceNum = $winport_bb_device_num actionNum = (<menuItem>.actionNum)
	winport_wait_for_control_press deviceNum = $winport_bb_device_num actionNum = (<menuItem>.actionNum)
	winport_wait_for_no_control_press deviceNum = $winport_bb_device_num actionNum = (<menuItem>.actionNum)
	WinPortSioSetControlBinding deviceNum = $winport_bb_device_num actionNum = (<menuItem>.actionNum)controlNum = <controlNum>
	SetScreenElementProps id = <controlId> rgba = $winport_bb_text_color
	winport_bb_update_option_values
	LaunchEvent \{Type = focus target = menu}
endscript

script winport_bb_reset_to_config1
	GetArraySize \{$winport_bb_menuItems}
	i = 0
	begin
		if StructureContains structure = ($winport_bb_menuItems [<i>])name = actionNum
			WinPortSioSetControlBinding deviceNum = $winport_bb_device_num actionNum = (($winport_bb_menuItems [<i>]).actionNum)controlNum = -1
		endif
		i = (<i> + 1)
	repeat <array_Size>
	winport_bb_update_option_values
endscript

script winport_bb_reset_to_config2
	GetArraySize \{$winport_bb_menuItems}
	i = 0
	begin
		if StructureContains structure = ($winport_bb_menuItems [<i>])name = actionNum
			WinPortSioSetControlBinding deviceNum = $winport_bb_device_num actionNum = (($winport_bb_menuItems [<i>]).actionNum)controlNum = -2
		endif
		i = (<i> + 1)
	repeat <array_Size>
	winport_bb_update_option_values
endscript

script winport_bb_focus
	FormatText checksumName = hiliteId 'hilite%d' d = <index>
	SetScreenElementProps id = <hiliteId> alpha = 1
endscript

script winport_bb_unfocus
	FormatText checksumName = hiliteId 'hilite%d' d = <index>
	SetScreenElementProps id = <hiliteId> alpha = 0
endscript

script winport_wait_for_no_control_press
	begin
		if NOT WinPortSioGetControlPress deviceNum = <deviceNum> actionNum = <actionNum>
			break
		endif
		wait \{1 gameframe}
	repeat
endscript

script winport_wait_for_control_press
	begin
		if WinPortSioGetControlPress deviceNum = <deviceNum> actionNum = <actionNum>
			break
		endif
		wait \{1 gameframe}
	repeat
	return controlNum = <controlNum>
endscript
