
script kill_panel_message_if_it_exists
	if ScreenElementExists id = <id>
		DestroyScreenElement id = <id>
	endif
endscript

script kill_panel_messages
	kill_panel_message_if_it_exists \{id = panel_message_layer}
endscript

script hide_panel_messages
	if ScreenElementExists \{id = panel_message_layer}
		DoScreenElementMorph \{id = panel_message_layer alpha = 0}
	endif
endscript

script show_panel_messages
	if ScreenElementExists \{id = panel_message_layer}
		DoScreenElementMorph \{id = panel_message_layer alpha = 1}
	endif
endscript

script create_panel_message_layer_if_needed
	if NOT ScreenElementExists \{id = panel_message_layer}
		SetScreenElementLock \{id = root_window OFF}
		CreateScreenElement \{Type = ContainerElement parent = root_window id = panel_message_layer}
	endif
endscript

script create_panel_message\{text = "Default panel message" Pos = (320.0, 70.0) rgba = [100 90 80 255] font_face = text_a1 time = 1500 z_priority = -5 just = [center center] parent = panel_message_layer Scale = 0.65}
	if NOT (<font_face> = text_a1)
		<font_face> = text_a1
	endif
	if GotParam \{id}
		kill_panel_message_if_it_exists id = <id>
	endif
	create_panel_message_layer_if_needed
	SetScreenElementLock id = <parent> OFF
	CreateScreenElement {
		Type = TextElement
		parent = <parent>
		id = <id>
		font = <font_face>
		text = <text>
		Scale = <Scale>
		Pos = <Pos>
		just = <just>
		rgba = <rgba>
		z_priority = <z_priority>
		Shadow
		shadow_offs = (2.0, 2.0)
		shadow_rgba = [0 0 0 255]
		font_spacing = 2
		not_focusable
	}
	if GotParam \{style}
		if GotParam \{params}
			RunScriptOnScreenElement id = <id> <style> params = <params>
		else
			RunScriptOnScreenElement id = <id> <style> params = <...>
		endif
	else
		RunScriptOnScreenElement id = <id> panel_message_wait_and_die params = {time = <time>}
	endif
endscript

script create_panel_sprite\{Pos = (320.0, 60.0) rgba = [128 128 128 100] z_priority = -5 parent = panel_message_layer just = [center center]}
	if GotParam \{id}
		if ScreenElementExists id = <id>
			RunScriptOnScreenElement id = <id> kill_panel_message
		endif
	endif
	create_panel_message_layer_if_needed
	SetScreenElementLock id = <parent> OFF
	CreateScreenElement {
		Type = SpriteElement
		parent = <parent>
		texture = <texture>
		id = <id>
		Scale = <Scale>
		Pos = <Pos>
		just = <just>
		rgba = <rgba>
		z_priority = <z_priority>
		blend = <blend>
	}
	if GotParam \{style}
		if GotParam \{params}
			RunScriptOnScreenElement id = <id> <style> params = <params>
		else
			RunScriptOnScreenElement id = <id> <style> params = <...>
		endif
	else
		if GotParam \{time}
			RunScriptOnScreenElement id = <id> panel_message_wait_and_die params = {time = <time>}
		endif
	endif
endscript

script create_panel_block\{text = "Default panel message" Pos = (320.0, 240.0) dims = (250.0, 0.0) rgba = [100 90 80 255] font_face = text_a1 time = 2000 just = [center center] internal_just = [center center] z_priority = -5 Scale = 0.125 parent = panel_message_layer}
	create_panel_message_layer_if_needed
	SetScreenElementLock id = <parent> OFF
	if GotParam \{id}
		if ScreenElementExists id = <id>
			DestroyScreenElement id = <id>
		endif
	endif
	CreateScreenElement {
		Type = TextBlockElement
		parent = <parent>
		id = <id>
		font = <font_face>
		text = <text>
		dims = <dims>
		Pos = <Pos>
		just = <just>
		internal_just = <internal_just>
		line_spacing = <line_spacing>
		rgba = <rgba>
		Scale = <Scale>
		Shadow
		shadow_rgba = $UI_text_shadow_color
		shadow_offs = $UI_text_shadow_offset
		allow_expansion
		z_priority = <z_priority>
	}
	if GotParam \{style}
		if GotParam \{params}
			RunScriptOnScreenElement id = <id> <style> params = <params>
		else
			RunScriptOnScreenElement id = <id> <style> params = <...>
		endif
	else
		if NOT GotParam \{hold}
			RunScriptOnScreenElement id = <id> panel_message_wait_and_die params = {time = <time>}
		endif
	endif
endscript

script create_intro_panel_block\{text = "Default intro panel message" Pos = (320.0, 60.0) dims = (250.0, 0.0) rgba = [100 90 80 255] font_face = text_a1 time = 2000 just = [center center] internal_just = [center center] z_priority = -5 Scale = 0.5 parent = panel_message_layer}
	create_panel_message_layer_if_needed
	SetScreenElementLock id = <parent> OFF
	if GotParam \{id}
		if ScreenElementExists id = <id>
			DestroyScreenElement id = <id>
		endif
	endif
	CreateScreenElement {
		Type = ContainerElement
		parent = <parent>
		id = <id>
		Pos = (0.0, 0.0)
	}
	<the_id> = <id>
	CreateScreenElement {
		Type = TextBlockElement
		parent = <the_id>
		font = <font_face>
		text = <text>
		dims = <dims>
		Pos = <Pos>
		just = <just>
		internal_just = <internal_just>
		line_spacing = <line_spacing>
		rgba = <rgba>
		Scale = <Scale>
		Shadow
		shadow_rgba = $UI_text_shadow_color
		shadow_offs = $UI_text_shadow_offset
		allow_expansion
		z_priority = (<z_priority> + 3)
	}
	grad_color = [17 67 92 255]
	if GotParam \{create_bg}
		CreateScreenElement {
			Type = SpriteElement
			parent = <the_id>
			texture = goal_grad
			Pos = (<Pos> + (300.0, 0.0))
			Scale = (21.0, 10.0)
			just = [center center]
			rgba = <grad_color>
			alpha = 0.4
			z_priority = (<z_priority> + 1)
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = <the_id>
			texture = goal_grad
			Pos = (<Pos> + (300.0, -20.0))
			Scale = (21.0, 1.0)
			just = [center center]
			rgba = <grad_color>
			alpha = 0.6
			z_priority = (<z_priority> + 1)
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = <the_id>
			texture = goal_grad
			Pos = (<Pos> + (300.0, 20.0))
			Scale = (21.0, 1.0)
			just = [center center]
			rgba = <grad_color>
			alpha = 0.6
			flip_v
			z_priority = (<z_priority> + 1)
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = <the_id>
			Pos = (<Pos> + (320.0, 0.0))
			just = [center center]
			Scale = (13.0, 1.0)
			texture = roundbar_middle
			z_priority = (<z_priority> + 2)
			rgba = [128 128 128 20]
		}
		GetScreenElementPosition id = <id>
		GetScreenElementDims id = <id>
		CreateScreenElement {
			Type = SpriteElement
			parent = <the_id>
			Pos = (<ScreenElementPos> + (-16.0, 16.0))
			just = [center center]
			Scale = 1
			texture = roundbar_tip_left
			z_priority = (<z_priority> + 2)
			rgba = [128 128 128 20]
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = <the_id>
			Pos = (<ScreenElementPos> + <width> * (1.0, 0.0) + (16.0, 16.0))
			just = [center center]
			Scale = 1
			texture = roundbar_tip_right
			z_priority = (<z_priority> + 2)
			rgba = [128 128 128 20]
		}
	endif
	if GotParam \{style}
		if GotParam \{params}
			RunScriptOnScreenElement id = <the_id> <style> params = <params>
		else
			RunScriptOnScreenElement id = <the_id> <style> params = <...>
		endif
	else
		RunScriptOnScreenElement id = <the_id> panel_message_wait_and_die params = {time = <time>}
	endif
endscript

script panel_message_wait_and_die\{time = 1500}
	wait <time> ignoreslomo
	Die
endscript

script kill_panel_message
	Die
endscript

script hide_panel_message
	if ScreenElementExists id = <id>
		SetScreenElementProps {
			id = <id>
			Hide
		}
		<id> ::DoMorph alpha = 0
	endif
endscript

script show_panel_message
	if ScreenElementExists id = <id>
		SetScreenElementProps {
			id = <id>
			unhide
		}
		<id> ::DoMorph alpha = 1
	endif
endscript

script destroy_panel_message
	if ScreenElementExists id = <id>
		<id> ::Die
	endif
endscript
