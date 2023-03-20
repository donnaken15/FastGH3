graphic_test_selection = test_graphic1
graphic_test_speed = 5
graphic_test_axis = 0

script launch_graphic_test
	generic_ui_destroy
	skater ::KillSkater \{no_node}
	skater ::DisablePlayerInput
	Change \{graphic_test_selection = test_graphic1}
	DoScreenElementMorph \{id = player1_panel_container alpha = 0}
	lock = OFF
	if AreAssetsLocked
		AllowAssetLoading \{On}
		lock = On
	endif
	LoadTexture \{'Test\graphic_test'}
	LoadTexture \{'Test\graphic_test2'}
	LoadTexture \{'Test\graphic_test3'}
	LoadTexture \{'Test\graphic_test4'}
	if (<lock> = On)
		AllowAssetLoading \{OFF}
	endif
	kill_start_key_binding
	SetAnalogStickActiveForMenus \{1}
	SetScreenElementLock \{id = root_window OFF}
	if NOT ScreenElementExists \{id = graphic_test_anchor}
		CreateScreenElement \{id = graphic_test_anchor Type = ContainerElement parent = root_window Pos = (0.0, 0.0) z_priority = 5000 alpha = 1 Scale = 1}
	endif
	SetScreenElementProps \{id = graphic_test_anchor event_handlers = [{pad_start destroy_graphic_test}{pad_space test_graphic_switch params = {selection = test_graphic1}}{pad_back test_graphic_switch params = {selection = test_graphic2}}{pad_choose test_graphic_switch params = {selection = test_graphic3}}{pad_square test_graphic_switch params = {selection = test_graphic4}}{pad_up test_graphic_move params = {Dir = up}}{pad_right test_graphic_move params = {Dir = right}}{pad_down test_graphic_move params = {Dir = down}}{pad_left test_graphic_move params = {Dir = left}}{pad_R2 test_graphic_scale params = {Dir = up}}{pad_L2 test_graphic_scale params = {Dir = down}}{pad_R3 test_graphic_toggle_axis}{pad_R1 test_graphic_z params = {up}}{pad_L1 test_graphic_z params = {down}}{pad_L3 test_graphic_toggle_speed}] replace_handlers}
	DoScreenElementMorph \{id = graphic_test_anchor alpha = 1}
	LaunchEvent \{Type = focus target = graphic_test_anchor}
	PauseGame
	<elements> = [test_graphic1 test_graphic2 test_graphic3 test_graphic4]
	<textures> = [graphic_test graphic_test2 graphic_test3 graphic_test4]
	<i> = 0
	begin
		<element> = (<elements> [<i>])
		if NOT ScreenElementExists id = <element>
			CreateScreenElement {
				id = <element>
				parent = graphic_test_anchor
				Type = SpriteElement
				Pos = (320.0, 224.0)
				texture = (<textures> [<i>])
			}
		endif
		<i> = (<i> + 1)
	repeat 4
endscript

script test_graphic_switch
	Change graphic_test_selection = <selection>
endscript

script test_graphic_move
	switch <Dir>
		case up
			<delta> = ((0.0, -1.0) * $graphic_test_speed)
		case right
			<delta> = ((1.0, 0.0) * $graphic_test_speed)
		case down
			<delta> = ((0.0, 1.0) * $graphic_test_speed)
		case left
			<delta> = ((-1.0, 0.0) * $graphic_test_speed)
	endswitch
	GetScreenElementProps id = ($graphic_test_selection)
	DoScreenElementMorph id = ($graphic_test_selection)Pos = (<delta> + <Pos>)time = 0
endscript

script test_graphic_scale
	GetScreenElementProps id = ($graphic_test_selection)
	GetScreenElementDims id = ($graphic_test_selection)
	if NOT (IsPair <Scale>)
		<Scale> = (<Scale> * (1.0, 1.0))
	endif
	if ($graphic_test_axis = 0)
		<delta> = ((1.0, 0.0) * ($graphic_test_speed / (<width> / <Scale> [0])))
	else
		<delta> = ((0.0, 1.0) * ($graphic_test_speed / (<height> / <Scale> [1])))
	endif
	if (<Dir> = up)
		DoScreenElementMorph id = ($graphic_test_selection)Scale = (<Scale> + <delta>)time = 0
	else
		DoScreenElementMorph id = ($graphic_test_selection)Scale = (<Scale> - <delta>)time = 0
	endif
endscript

script test_graphic_z
	GetScreenElementProps id = ($graphic_test_selection)
	if GotParam \{up}
		SetScreenElementProps id = ($graphic_test_selection)z_priority = (<z_priority> + 1)
	else
		SetScreenElementProps id = ($graphic_test_selection)z_priority = (<z_priority> - 1)
	endif
endscript

script test_graphic_toggle_axis
	if ($graphic_test_axis = 0)
		Change \{graphic_test_axis = 1}
		printf \{"$graphic_test_axis = y"}
	else
		Change \{graphic_test_axis = 0}
		printf \{"$graphic_test_axis = x"}
	endif
endscript

script test_graphic_toggle_speed
	if ($graphic_test_speed = 1)
		Change \{graphic_test_speed = 5}
	else
		Change \{graphic_test_speed = 1}
	endif
	printf "$graphic_test_speed = %d" d = ($graphic_test_speed)
endscript

script destroy_graphic_test
	restore_start_key_binding
	UnPauseGame
	skater ::EnablePlayerInput
	DoScreenElementMorph \{id = player1_panel_container alpha = 1}
	if ScreenElementExists \{id = graphic_test_anchor}
		DoScreenElementMorph \{id = graphic_test_anchor alpha = 0}
		LaunchEvent \{Type = unfocus target = graphic_test_anchor}
		SetAnalogStickActiveForMenus \{0}
	endif
endscript
