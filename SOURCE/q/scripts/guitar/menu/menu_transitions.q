transitions_locked = 0

script destroy_menu_transition
	if ScreenElementExists \{id = transition_container}
		root_window ::SetProps \{just = [left top]}
		root_window ::SetProps \{alpha = 1 Scale = (1.0, 1.0) Pos = (0.0, 0.0)}
		DestroyScreenElement \{id = transition_container}
		Change \{transitions_locked = 0}
	endif
endscript

script menu_transition_out_right\{transition_time = 0.125}
	destroy_menu_transition
	Change \{transitions_locked = 1}
	CreateScreenElement \{id = transition_container Type = ContainerElement parent = root_window Pos = (0.0, 0.0) alpha = 0}
	CreateScreenElement \{Type = SpriteElement parent = transition_container texture = white just = [left top] Pos = (0.0, 0.0) rgba = [0 0 0 255] dims = (1280.0, 720.0) z_priority = 5000}
	if IsWinPort
	else
		root_window ::SetProps \{just = [right top]}
		RunScriptOnScreenElement id = root_window fade_element params = {Pos = (1280.0, 0.0) alpha = 1 time = <transition_time> Scale = (2.0, 1.0)}
		transition_container ::DoMorph alpha = 1 time = <transition_time>
	endif
endscript

script menu_transition_in_right\{transition_time = 0.125}
	root_window ::SetProps \{just = [left top]}
	root_window ::SetProps \{alpha = 1 Scale = (2.0, 1.0) Pos = (0.0, 0.0)}
	RunScriptOnScreenElement id = transition_container fade_element params = {Pos = (0.0, 0.0) alpha = 0 time = <transition_time>}
	if IsWinPort
		root_window ::DoMorph alpha = 1 Scale = 1 Pos = (0.0, 0.0) time = <transition_time>
	else
		root_window ::DoMorph alpha = 1 Scale = 1 time = <transition_time>
	endif
	Change \{transitions_locked = 0}
	destroy_menu_transition
endscript

script menu_transition_out_left\{transition_time = 0.125}
	destroy_menu_transition
	Change \{transitions_locked = 1}
	CreateScreenElement \{id = transition_container Type = ContainerElement parent = root_window Pos = (0.0, 0.0) alpha = 0}
	CreateScreenElement \{Type = SpriteElement parent = transition_container texture = white just = [left top] Pos = (0.0, 0.0) rgba = [0 0 0 255] dims = (1280.0, 720.0) z_priority = 5000}
	root_window ::SetProps \{just = [left top]}
	if IsWinPort
		RunScriptOnScreenElement id = root_window fade_element params = {Pos = (0.0, 0.0) alpha = 1 time = <transition_time> Scale = (2.0, 1.0)}
		transition_container ::DoMorph Pos = (0.0, 0.0) alpha = 1 time = <transition_time>
	else
		RunScriptOnScreenElement id = root_window fade_element params = {alpha = 1 time = <transition_time> Scale = (2.0, 1.0)}
		transition_container ::DoMorph alpha = 1 time = <transition_time>
	endif
endscript

script menu_transition_in_left\{transition_time = 0.125}
	if IsWinPort
		root_window ::SetProps \{just = [right top]}
		root_window ::SetProps \{Pos = (1280.0, 0.0) alpha = 1 Scale = (2.0, 1.0)}
		RunScriptOnScreenElement id = transition_container fade_element params = {Pos = (0.0, 0.0) alpha = 0 time = <transition_time>}
		root_window ::DoMorph alpha = 1 Scale = 1 Pos = (1280.0, 0.0) time = <transition_time>
	endif
	destroy_menu_transition
	Change \{transitions_locked = 0}
endscript

script fade_element\{time = 0 Pos = (0.0, 0.0) alpha = 0 Scale = 1}
	DoMorph id = <id> alpha = <alpha> time = <time> Pos = <Pos> Scale = <Scale>
endscript
