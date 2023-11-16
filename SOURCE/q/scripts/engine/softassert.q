enable_soft_asserts = 1
soft_assert_active = 0

script soft_assert
	Dumpheaps
	printstruct <...>
	printf "SOFT ASSERT: %s" s = <reason>
	if IsTrue \{$#"0x4f659345"}
		if IsTrue \{$soft_assert_active}
			printf \{'Soft Assert already active, ignoring!'}
		else
			pause_game = 1
			if GlobalExists \{Type = integer name = view_mode}
				if ($view_mode > 0)
					pause_game = 0
				endif
			endif
			if (<pause_game> = 1)
				if GameIsPaused
					FormatText textname = full_message "SOFT ASSERT: %r (game was paused, so promoted to hard assert)" r = <reason>
					ScriptAssert <full_message>
				endif
				PauseMusic \{1}
				PauseStream \{1}
				PauseGame
			endif
			Change \{soft_assert_active = 1}
			StartRendering
			HideLoadingScreen
			ScreenShot \{FileName = 'Assert'}
			soft_assert_message <...>
		endif
	endif
endscript

script soft_assert_keep_player_paused
	MangleChecksums \{a = 0 b = 0}
	begin
		if CompositeObjectExists name = <mangled_ID>
			<mangled_ID> ::Pause
		endif
		wait \{1 gameframes}
	repeat
endscript

script soft_assert_confirm
	unpause_game = 1
	if GlobalExists \{Type = integer name = view_mode}
		if ($view_mode > 0)
			unpause_game = 0
		endif
	endif
	if (<unpause_game> = 1)
		UnPauseGame
		PauseMusic \{0}
		PauseStream \{0}
	endif
	Change \{soft_assert_active = 0}
	DestroyScreenElement \{id = soft_assert_anchor}
endscript

script soft_assert_message\{message = ""}
	if GotParam \{file}
		FormatText textname = message "%m\c2File:\c0 %f\n" m = <message> f = <file>
	endif
	if GotParam \{line}
		FormatText textname = message "%m\c2Line:\c0 %l\n" m = <message> l = <line>
	endif
	if GotParam \{sig}
		FormatText textname = message "%m\c2Signature:\c0 %s\n" m = <message> s = <sig>
	endif
	if GotParam \{reason}
		FormatText textname = message "%m\n\c2Message:\c0 %r\n" m = <message> r = <reason>
	endif
	if ScreenElementExists \{id = soft_assert_anchor}
		DestroyScreenElement \{id = soft_assert_anchor}
	endif
	SetScreenElementLock \{id = root_window OFF}
	top = (0.0, 40.0)
	CreateScreenElement \{Type = ContainerElement id = soft_assert_anchor parent = root_window z_priority = 10000}
	CreateScreenElement \{Type = SpriteElement parent = soft_assert_anchor rgba = [0 0 0 70] dims = (1280.0, 720.0) Pos = (0.0, 0.0) just = [left top]}
	CreateScreenElement {
		Type = TextElement
		parent = soft_assert_anchor
		font = text_a1
		text = "\c2ASSERTION:"
		rgba = [255 255 255 255]
		alpha = 1
		Scale = 0.65
		Pos = ((640.0, 0.0) + <top>)
		just = [center top]
		z_priority = 10002
	}
	if ($highdefviewer = 1)
		<this_text_scale> = 0.45
	else
		<this_text_scale> = 0.6
	endif
	CreateScreenElement {
		Type = TextBlockElement
		parent = soft_assert_anchor
		font = text_a1
		text = <message>
		rgba = [255 255 255 255]
		alpha = 1
		Scale = <this_text_scale>
		Pos = ((100.0, 50.0) + <top>)
		dims = (880.0, 0.0)
		allow_expansion
		just = [left top]
		internal_just = [left top]
	}
	GetScreenElementDims id = <id>
	if GotParam \{callstack}
		dim_h = (325 - <height>)
		if (<dim_h> < 100)
			dim_h = 100
		endif
		CreateScreenElement {
			Type = VScrollingMenu
			parent = soft_assert_anchor
			id = soft_assert_callstack_v
			just = [left top]
			Pos = ((120.0, 90.0) + (<height> * (0.0, 0.8500000238418579)))
			dims = ((840.0, 0.0) + (<dim_h> * (0.0, 1.0)))
			z_priority = 10005
		}
		CreateScreenElement \{Type = VMenu id = soft_assert_callstack parent = soft_assert_callstack_v internal_just = [left top] dont_allow_wrap}
		GetArraySize <callstack>
		i = 0
		begin
			CreateScreenElement {
				Type = TextBlockElement
				parent = soft_assert_callstack
				font = text_a1
				text = (<callstack> [<i>])
				rgba = [160 160 255 255]
				Scale = <this_text_scale>
				just = [left top]
				dims = (880.0, 0.0)
				allow_expansion
				internal_just = [left top]
			}
			i = (<i> + 1)
		repeat <array_Size>
		height = 330
		LaunchEvent \{Type = focus target = soft_assert_callstack}
	endif
	CreateScreenElement {
		Type = SpriteElement
		parent = soft_assert_anchor
		rgba = [0 0 0 70]
		dims = (1100.0, 720.0)
		Pos = ((640.0, 0.0) + <top>)
		just = [center top]
	}
	create_helper_text \{helper_text_elements = [{text = "\be - \bf - \be = Continue"}] parent = soft_assert_anchor z_priority = 10004}
	soft_assert_input
	LaunchEvent \{Type = focus target = soft_assert_anchor}
	RunScriptOnScreenElement \{id = soft_assert_anchor soft_assert_keep_player_paused}
endscript

script soft_assert_input\{step = 0}
	steps = [
		{event_name = pad_L1 button_name = L1}
		{event_name = pad_R1 button_name = R1}
		{event_name = pad_L1 button_name = L1}
	]
	if GotParam \{wait}
		wait <wait> seconds
	endif
	GetArraySize <steps>
	if NOT (<step> < <array_Size>)
		i = 0
		begin
			Debounce (<steps> [<i>].button_name)
			ControllerDebounce (<steps> [<i>].button_name)
			i = (<i> + 1)
		repeat <array_Size>
		Goto \{soft_assert_confirm}
	endif
	i = 0
	begin
		if (<step> = <i>)
			event_handlers = [{(<steps> [<i>].event_name)soft_assert_input params = {step = (<step> + 1)}}]
		else
			event_handlers = [{(<steps> [<i>].event_name)nullscript}]
		endif
		soft_assert_anchor ::SetProps event_handlers = <event_handlers> replace_handlers
		i = (<i> + 1)
		if GotParam \{reset}
			if NOT (<i> < <array_Size>)
				Goto \{soft_assert_input}
			endif
		else
			if (<i> > <step>)
				break
			endif
		endif
	repeat
	soft_assert_anchor ::Obj_KillSpawnedScript \{name = soft_assert_input}
	soft_assert_anchor ::Obj_SpawnScriptLater \{soft_assert_input params = {wait = 0.3 reset}}
endscript
