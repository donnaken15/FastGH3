
script create_snazzy_dialog_box\{title = "Title" text = "Default text" anchor_id = dialog_box_anchor vmenu_id = dialog_box_vmenu container_id = dialog_box_container title_font = #"0x45aae5c4" font = #"0x45aae5c4" text_font = #"0x45aae5c4" Pos = (320.0, 230.0) just = [center top] Scale = 0.8 line_spacing = 1 title_scale = 0.7 text_scale = 0.6 text_dims = (530.0, 0.0) exclusive_device = -1 pos_tweak = (0.0, -50.0) bg_rgba = [8 15 24 170] title_rgba = [90 90 70 255] text_rgba = [90 70 50 255] bg_scale = 1 hmenu_pos = (0.0, 50.0) z_priority = 40 no_bg destroy_on_event = 1}
	if ScreenElementExists id = <anchor_id>
		dialog_box_exit anchor_id = <anchor_id>
	endif
	if NOT InNetGame
		if NOT InFrontEnd
		endif
	endif
	SetScreenElementLock \{id = root_window OFF}
	CreateScreenElement {
		Type = ContainerElement
		parent = root_window
		id = <anchor_id>
		dims = (640.0, 480.0)
		Pos = <Pos>
		just = [center center]
		z_priority = <z_priority>
		Priority = <Priority>
		exclusive_device = <exclusive_device>
	}
	CreateScreenElement {
		Type = ContainerElement
		id = <container_id>
		parent = <anchor_id>
		dims = (640.0, 480.0)
		Pos = <Pos>
		just = [center center]
		z_priority = <z_priority>
		Priority = <Priority>
	}
	CreateScreenElement {
		Type = ContainerElement
		parent = <anchor_id>
		dims = (640.0, 480.0)
		Pos = (320.0, 240.0)
		just = [center center]
		z_priority = <z_priority>
	}
	<bg_anchor_id> = <id>
	if GotParam \{from_cas}
		make_cas_bg_elements parent = <bg_anchor_id>
	else
		if InFrontEnd
			if NOT GotParam \{no_bg}
			endif
		endif
	endif
	if GotParam \{forced_pos}
		Pos = <forced_pos>
	endif
	CreateScreenElement {
		Type = VMenu
		parent = <container_id>
		id = <vmenu_id>
		Pos = <Pos>
		just = [center top]
		internal_just = [center top]
		Scale = <Scale>
		z_priority = <z_priority>
		padding_scale = 0.8
		exclusive_device = <exclusive_device>
	}
	if NOT GotParam \{no_helper_text}
		if GotParam \{buttons}
			GetArraySize <buttons>
			if GotParam \{pad_back_script}
				if (<array_Size> = 1)
					create_helper_text {anchor_id = <helper_text_anchor_id>
						parent = <bg_anchor_id>
						$generic_dialog_helper_text3
						bg_rgba = <helper_text_bg_rgba>
						z_priority = <z_priority>
					}
				else
					create_helper_text {anchor_id = <helper_text_anchor_id>
						parent = <bg_anchor_id>
						$generic_helper_text
						bg_rgba = <helper_text_bg_rgba>
						z_priority = <z_priority>
					}
				endif
			else
				if (<array_Size> = 1)
					create_helper_text {anchor_id = <helper_text_anchor_id>
						parent = <bg_anchor_id>
						$generic_dialog_helper_text
						bg_rgba = <helper_text_bg_rgba>
						z_priority = <z_priority>
					}
				else
					create_helper_text {anchor_id = <helper_text_anchor_id>
						parent = <bg_anchor_id>
						$generic_dialog_helper_text2
						bg_rgba = <helper_text_bg_rgba>
						z_priority = <z_priority>
					}
				endif
			endif
		endif
	endif
	CreateScreenElement {
		Type = TextElement
		parent = <vmenu_id>
		local_id = dbox_title
		font = <title_font>
		text = <title>
		just = [center top]
		rgba = <title_rgba>
		Scale = <title_scale>
		z_priority = <z_priority>
		not_focusable
		padding_scale = 0.55
	}
	<title_id> = <id>
	GetScreenElementDims id = <title_id>
	if GotParam \{use_goalmenu_bg}
		bg_rgba = [20 30 40 80]
		/*CreateScreenElement {
			Type = SpriteElement
			parent = {<vmenu_id> child = dbox_title}
			texture = #"0xc94d6a2a"
			just = [center top]
			Pos = (85.0, -20.0)
			rgba = [0 10 20 255]
			Scale = (2.125, 1.0)
			z_priority = (<z_priority> -1)
			flip_v
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = {<vmenu_id> child = dbox_title}
			texture = #"0x729037cf"
			just = [center top]
			Pos = (85.0, 10.0)
			rgba = [0 10 20 255]
			Scale = (2.125, 1.5)
			z_priority = (<z_priority> -1)
			flip_v
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = {<vmenu_id> child = dbox_title}
			texture = #"0x5c93cccc"
			just = [center top]
			Pos = (85.0, 30.0)
			rgba = [0 10 20 255]
			Scale = (2.125, 1.0)
			z_priority = (<z_priority> -1)
			flip_v
		}*/
		CreateScreenElement {
			Type = SpriteElement
			parent = {<vmenu_id> child = dbox_title}
			texture = menu_selection_white_02
			just = [center top]
			Pos = (85.0, 50.0)
			rgba = [5 15 25 70]
			Scale = (1.5, 1.0)
			z_priority = (<z_priority> -1)
		}
		/*CreateScreenElement {
			Type = SpriteElement
			parent = {<vmenu_id> child = dbox_title}
			texture = #"0x5c93cccc"
			just = [center top]
			Pos = (85.0, 103.0)
			rgba = [5 15 25 100]
			Scale = (2.125, 0.25)
			z_priority = (<z_priority> -1)
		}*/
	endif
	CreateScreenElement {
		Type = TextBlockElement
		parent = <vmenu_id>
		font = <text_font>
		text = <text>
		just = [center top]
		dims = <text_dims>
		rgba = <text_rgba>
		Scale = <text_scale>
		line_spacing = <line_spacing>
		allow_expansion
		not_focusable
		padding_scale = 0.65
	}
	<text_id> = <id>
	GetScreenElementDims id = <text_id>
	if GotParam \{buttons}
		CreateScreenElement {
			Type = ContainerElement
			parent = <vmenu_id>
			dims = (<text_dims> + (50.0, 40.0))
			not_focusable
		}
	endif
	if GotParam \{logo}
		CreateScreenElement {
			Type = ContainerElement
			parent = <vmenu_id>
			just = [center center]
			dims = (0.0, 88.0)
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = <id>
			texture = <logo>
			just = [center top]
			rgba = [100 100 100 255]
			Scale = ((1.399999976158142, 1.2999999523162842) * 1.4)
		}
		no_icon = no_icon
	endif
	if GotParam \{pad_back_script}
		SetScreenElementProps {
			id = <vmenu_id>
			event_handlers = [{pad_back <pad_back_script> params = <pad_back_params>}]
			replace_handlers
		}
	endif
	SetScreenElementLock id = <vmenu_id> On
	SetScreenElementLock id = <vmenu_id> OFF
	GetScreenElementDims id = <vmenu_id>
	section_width = ((<width> / 100.0)+ 0.0)
	if GotParam \{buttons}
		ForEachIn <buttons> do = create_dialog_button params = {
			font = <font>
			parent = <vmenu_id>
			z_priority = (<z_priority> + 4)
			width = <section_width>
			pad_focus_script = <pad_focus_script>
			destroy_on_event = <destroy_on_event>
		}
		GetArraySize <buttons>
		if (<array_Size> > 1)
			SetScreenElementProps {
				id = <vmenu_id>
				event_handlers = [
					{pad_up generic_menu_up_or_down_sound params = {up}}
					{pad_down generic_menu_up_or_down_sound params = {down}}
				]
			}
		endif
	endif
	if GotParam \{sub_logo}
		CreateScreenElement {
			Type = SpriteElement
			parent = <vmenu_id>
			texture = <sub_logo>
			just = [center center]
			rgba = [128 128 128 88]
			Scale = (1.25, 1.0)
			not_focusable
		}
		no_icon = no_icon
	endif
	SetScreenElementLock id = <vmenu_id> On
	SetScreenElementLock id = <vmenu_id> OFF
	GetScreenElementDims id = <vmenu_id>
	section_width = ((<width> / 100.0)+ 0.0)
	section_height = 32
	num_parts = (((<height> * 1.0)/ (<section_height> * 1.0))-1.0)
	if NOT GotParam \{forced_pos}
		centered_pos = ((320.0, 0.0) + ((0.0, 1.0) * (480 - <height>)/ 2)+ <pos_tweak>)
		SetScreenElementProps id = <vmenu_id> Pos = <centered_pos>
	else
		centered_pos = <forced_pos>
	endif
	<bg_x_scale> = 1.2
	/*CreateScreenElement {
		Type = SpriteElement
		parent = <anchor_id>
		Pos = <centered_pos>
		just = [center bottom]
		texture = #"0xc94d6a2a"
		Scale = ((1.0, 0.0) * <bg_x_scale> + (0.0, 1.0))
		rgba = <bg_rgba>
		z_priority = 38
	}*/
	CreateScreenElement {
		Type = SpriteElement
		parent = <anchor_id>
		texture = #"0x729037cf"
		Pos = (<centered_pos> - (0.0, 16.0))
		Scale = (((1.0, 0.0) * <bg_x_scale>)+ (0.0, 1.0) * (<height> / 16.0))
		just = [center top]
		rgba = <bg_rgba>
		z_priority = 38
	}
	/*CreateScreenElement {
		Type = SpriteElement
		parent = <anchor_id>
		Pos = (<centered_pos> + (0.0, 1.0) * (<height>)+ (0.0, 15.0))
		just = [center bottom]
		texture = #"0x5c93cccc"
		Scale = ((1.0, 0.0) * <bg_x_scale> + (0.0, 1.0))
		rgba = <bg_rgba>
		z_priority = 38
	}*/
	kill_start_key_binding
	if ObjectExists \{id = no_button}
		LaunchEvent Type = focus target = <vmenu_id> data = {child_id = no_button}
	else
		LaunchEvent Type = focus target = <vmenu_id>
	endif
	if GotParam \{delay_input}
		RunScriptOnScreenElement id = <anchor_id> dialog_box_delay_input params = {delay_input_time = <delay_input_time>}
	endif
	if NOT GotParam \{no_animate}
		if GotParam \{style}
			RunScriptOnScreenElement id = <anchor_id> <style> params = <...>
		else
			if NOT GotParam \{full_animate}
				RunScriptOnScreenElement id = <container_id> animate_dialog_box_in params = <...>
			else
				RunScriptOnScreenElement id = <anchor_id> animate_dialog_box_in params = <...>
			endif
		endif
	endif
	if ObjectExists \{id = current_menu_anchor}
		LaunchEvent \{Type = unfocus target = current_menu_anchor}
	endif
	if ObjectExists \{id = current_menu}
		LaunchEvent \{Type = unfocus target = current_menu}
	endif
endscript

script create_dialog_box
	create_snazzy_dialog_box <...>
endscript

script animate_dialog_box_in
	if GotParam \{full_animate}
		SetScreenElementProps {
			id = <bg_anchor_id>
			Hide
		}
	endif
	if NOT GotParam \{delay_input}
		<bg_anchor_id> ::Obj_SpawnScriptLater dialog_box_delay_input params = {delay_input_time = 300}
	endif
	DoMorph \{time = 0 Scale = (0.0, 0.0) alpha = 0.1}
	DoMorph \{time = 0.15 Scale = (1.0, 0.0) alpha = 0.4}
	DoMorph \{time = 0.15 Scale = (1.0, 1.0) alpha = 1.0}
	// is this the infamous THUG1-P8 menu animation
	if GotParam \{full_animate}
		SetScreenElementProps {
			id = <bg_anchor_id>
			unhide
		}
	endif
endscript
