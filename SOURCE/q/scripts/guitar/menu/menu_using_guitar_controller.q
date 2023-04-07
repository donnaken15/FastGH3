menu_using_guitar_controller_font = #"0x35c0114b"
menu_using_guitar_controller_kb = 0

script create_using_guitar_controller_menu\{keyboard = 0}
	Change menu_using_guitar_controller_kb = <keyboard>
	create_menu_backdrop \{texture = #"0x767cd482"}
	CreateScreenElement \{Type = ContainerElement parent = root_window id = ugc_container Pos = (0.0, 0.0)}
	guitar_tex = #"0x4de11b10"
	if ($menu_using_guitar_controller_kb = 1)
		if NotIsMacPort
			guitar_tex = #"0x4b646edf"
		else
			guitar_tex = #"0x125cf8ca"
		endif
	endif
	if ($menu_using_guitar_controller_kb = 1)
		displaySprite parent = ugc_container tex = <guitar_tex> Pos = (665.0, 510.0) just = [center center] z = 1 Scale = (1.2000000476837158, 1.2000000476837158)
		displaySprite \{parent = ugc_container tex = #"0x25ea173f" Pos = (640.0, 240.0) just = [center center] z = 1}
	else
		displaySprite parent = ugc_container tex = <guitar_tex> Pos = (660.0, 530.0) just = [center center] z = 1
		displaySprite \{parent = ugc_container tex = #"0x471aaafa" Pos = (640.0, 270.0) just = [center center] z = 1}
	endif
	displaySprite \{parent = ugc_container id = bg_helper tex = white rgba = [83 95 147 255] dims = (221.0, 40.0) just = [center top] z = 0.5}
	displayText \{parent = ugc_container id = bg_helper_text font = #"0x35c0114b" rgba = [223 223 223 255] Scale = 0.5 just = [center top] z = 0.6 noshadow}
	if ($menu_using_guitar_controller_kb = 0)
		menu_using_guitar_controller_add_text_start
		menu_using_guitar_controller_add_text_back
		menu_using_guitar_controller_add_text_continue
		menu_using_guitar_controller_add_text_up_down
		menu_using_guitar_controller_add_text_tilt_starpower
	endif
	menu_using_guitar_controller_add_text_header
	spawnscriptnow \{go_through_using_guitar_text}
	spawnscriptnow \{check_for_any_input params = {use_primary_controller button1 = start button2 = X}}
	return \{play_sound = 0}
endscript

script destroy_using_guitar_controller_menu
	destroy_menu \{menu_id = ugc_container}
	destroy_menu_backdrop
	killspawnedscript \{name = go_through_using_guitar_text}
	killspawnedscript \{name = check_for_any_input}
endscript

script go_through_using_guitar_text
	max_width = 200
	begin
		if ScreenElementExists \{id = bg_helper}
			SetScreenElementProps \{id = bg_helper Pos = (406.0, 135.0)}
		endif
		if ScreenElementExists \{id = bg_helper_text}
			if ($menu_using_guitar_controller_kb = 1)
				SetScreenElementProps \{id = bg_helper_text Pos = (407.0, 130.0) text = "1) BOOT UP"}
			else
				SetScreenElementProps \{id = bg_helper_text Pos = (407.0, 130.0) text = "1) STRAP ON"}
			endif
			GetScreenElementDims \{id = bg_helper_text}
			SetScreenElementProps \{id = bg_helper_text Scale = 1}
			if (<width> > <max_width>)
				fit_text_in_rectangle id = bg_helper_text dims = (<max_width> * (1.0, 0.0) + <height> * (0.0, 1.0))
			else
				SetScreenElementProps \{id = bg_helper_text Scale = 0.5}
			endif
		endif
		wait \{2 seconds}
		if ScreenElementExists \{id = bg_helper}
			SetScreenElementProps \{id = bg_helper Pos = (639.0, 135.0)}
		endif
		if ScreenElementExists \{id = bg_helper_text}
			SetScreenElementProps \{id = bg_helper_text Pos = (640.0, 130.0) text = "2) BANG HEAD"}
			GetScreenElementDims \{id = bg_helper_text}
			SetScreenElementProps \{id = bg_helper_text Scale = 1}
			if (<width> > <max_width>)
				fit_text_in_rectangle id = bg_helper_text dims = (<max_width> * (1.0, 0.0) + <height> * (0.0, 1.0))
			else
				SetScreenElementProps \{id = bg_helper_text Scale = 0.5}
			endif
		endif
		wait \{2 seconds}
		if ScreenElementExists \{id = bg_helper}
			SetScreenElementProps \{id = bg_helper Pos = (872.0, 135.0)}
		endif
		if ScreenElementExists \{id = bg_helper_text}
			SetScreenElementProps \{id = bg_helper_text Pos = (873.0, 130.0) text = "3) LOSE CONTROL"}
			GetScreenElementDims \{id = bg_helper_text}
			SetScreenElementProps \{id = bg_helper_text Scale = 1}
			if (<width> > <max_width>)
				fit_text_in_rectangle id = bg_helper_text dims = (<max_width> * (1.0, 0.0) + <height> * (0.0, 1.0))
			else
				SetScreenElementProps \{id = bg_helper_text Scale = 0.5}
			endif
		endif
		wait \{2 seconds}
	repeat
endscript

script menu_using_guitar_controller_add_text_start
	text1 = "START"
	text1_pos = (785.0, 594.0)
	text2 = "button"
	text2_pos = (785.0, 627.0)
	CreateScreenElement {
		Type = TextElement
		text = <text1>
		Pos = <text1_pos>
		parent = ugc_container
		rgba = [0 0 0 255]
		font = ($menu_using_guitar_controller_font)
		just = [right top]
		Scale = (0.7, 0.7)
	}
	GetScreenElementDims id = <id>
	if (<width> > 80)
		extra_space = (<width> - 80)
		GetScreenElementProps id = <id>
		SetScreenElementProps id = <id> Pos = (<Pos> - <extra_space> * (0.5, 0.0))
	endif
	CreateScreenElement {
		Type = TextElement
		text = <text2>
		Pos = <text2_pos>
		parent = ugc_container
		rgba = [0 0 0 255]
		font = ($menu_using_guitar_controller_font)
		just = [right top]
		Scale = 0.6
	}
endscript

script menu_using_guitar_controller_add_text_back
	text1 = "BACK"
	text1_pos = (459.0, 592.0)
	text2 = "Red Button"
	text2_pos = (459.0, 625.0)
	GetEnterButtonAssignment
	if (<assignment> = Circle)
		text1 = "CONTINUE"
		text1_pos = (459.0, 592.0)
		text2 = "Red Button"
		text2_pos = (459.0, 625.0)
	endif
	CreateScreenElement {
		Type = TextElement
		text = <text1>
		Pos = <text1_pos>
		parent = ugc_container
		rgba = [0 0 0 255]
		font = ($menu_using_guitar_controller_font)
		just = [left top]
		Scale = (0.7, 0.7)
	}
	CreateScreenElement {
		Type = TextElement
		text = <text2>
		Pos = <text2_pos>
		parent = ugc_container
		rgba = [165 70 70 255]
		font = ($menu_using_guitar_controller_font)
		just = [left top]
		Scale = 0.6
	}
endscript

script menu_using_guitar_controller_add_text_continue
	text1 = "CONTINUE"
	text1_pos = (397.0, 592.0)
	text2 = "Green Button"
	text2_pos = (397.0, 625.0)
	GetEnterButtonAssignment
	if (<assignment> = Circle)
		text1 = "BACK"
		text1_pos = (397.0, 592.0)
		text2 = "Green Button"
		text2_pos = (397.0, 625.0)
	endif
	CreateScreenElement {
		Type = TextElement
		text = <text1>
		Pos = <text1_pos>
		parent = ugc_container
		rgba = [0 0 0 255]
		font = ($menu_using_guitar_controller_font)
		just = [right top]
		Scale = (0.7, 0.7)
	}
	GetScreenElementDims id = <id>
	if (<width> > 125)
		extra_space = (<width> - 125)
		GetScreenElementProps id = <id>
		SetScreenElementProps id = <id> Pos = (<Pos> - <extra_space> * (0.5, 0.0))
	endif
	CreateScreenElement {
		Type = TextElement
		text = <text2>
		Pos = <text2_pos>
		parent = ugc_container
		rgba = [80 145 105 255]
		font = ($menu_using_guitar_controller_font)
		just = [right top]
		Scale = 0.6
	}
endscript

script menu_using_guitar_controller_add_text_up_down
	text1 = "UP/DOWN"
	text1_pos = (565.0, 409.0)
	text2 = "Strum Bar"
	text2_pos = (565.0, 442.0)
	CreateScreenElement {
		Type = TextElement
		text = <text1>
		Pos = <text1_pos>
		parent = ugc_container
		rgba = [0 0 0 255]
		font = ($menu_using_guitar_controller_font)
		just = [center top]
		Scale = (0.7, 0.7)
	}
	GetScreenElementDims id = <id>
	if (<width> > 180)
		SetScreenElementProps id = <id> Scale = 1
		fit_text_in_rectangle id = <id> only_if_larger_x = 1 dims = ((180.0, 0.0) + <height> * (0.0, 1.0))
	endif
	CreateScreenElement {
		Type = TextElement
		text = <text2>
		Pos = <text2_pos>
		parent = ugc_container
		rgba = [0 0 0 255]
		font = ($menu_using_guitar_controller_font)
		just = [center top]
		Scale = 0.6
	}
	GetScreenElementDims id = <id>
	if (<width> > 180)
		SetScreenElementProps id = <id> Scale = 1
		fit_text_in_rectangle id = <id> only_if_larger_x = 1 dims = ((180.0, 0.0) + <height> * (0.0, 1.0))
	endif
endscript

script menu_using_guitar_controller_add_text_tilt_starpower
	text1 = "TILT UP"
	text1_pos = (290.0, 390.0)
	text2 = "for Star Power"
	text2_pos = (290.0, 423.0)
	CreateScreenElement {
		Type = TextElement
		text = <text1>
		Pos = <text1_pos>
		parent = ugc_container
		rgba = [0 0 0 255]
		font = ($menu_using_guitar_controller_font)
		just = [left top]
		Scale = (0.7, 0.7)
	}
	GetScreenElementDims id = <id>
	if (<width> > 180)
		SetScreenElementProps id = <id> Scale = 1
		fit_text_in_rectangle id = <id> only_if_larger_x = 1 dims = ((180.0, 0.0) + <height> * (0.0, 1.0))
	endif
	CreateScreenElement {
		Type = TextElement
		text = <text2>
		Pos = <text2_pos>
		parent = ugc_container
		rgba = [0 0 0 255]
		font = ($menu_using_guitar_controller_font)
		just = [left top]
		Scale = 0.6
	}
	GetScreenElementDims id = <id>
	if (<width> > 180)
		SetScreenElementProps id = <id> Scale = 1
		fit_text_in_rectangle id = <id> only_if_larger_x = 1 dims = ((180.0, 0.0) + <height> * (0.0, 1.0))
	endif
	CreateScreenElement \{Type = SpriteElement parent = ugc_container texture = #"0x05400020" Pos = (275.0, 480.0) just = [right center]}
endscript

script menu_using_guitar_controller_add_text_header
	text1 = "IN THE EVENT OF ROCK"
	text1_pos = (660.0, 55.0)
	if ($menu_using_guitar_controller_kb = 1)
		text2 = "USING THE KEYBOARD AND MOUSE"
	else
		text2 = "USING THE GUITAR CONTROLLER"
	endif
	text2_pos = (660.0, 95.0)
	CreateScreenElement {
		Type = TextElement
		text = <text1>
		Pos = <text1_pos>
		parent = ugc_container
		rgba = [100 110 145 255]
		font = ($menu_using_guitar_controller_font)
		just = [center top]
		Scale = (1.4, 1.0)
	}
	CreateScreenElement {
		Type = TextElement
		text = <text2>
		Pos = <text2_pos>
		parent = ugc_container
		rgba = [0 0 0 255]
		font = ($menu_using_guitar_controller_font)
		just = [center top]
		Scale = (0.9, 0.7)
	}
endscript
