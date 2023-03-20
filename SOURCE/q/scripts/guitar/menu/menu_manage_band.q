manage_band_menu_font = #"0x35c0114b"

script create_manage_band_menu
	get_band_game_mode_name
	FormatText checksumName = bandname_id 'band%i_info_%g' i = ($current_band)g = <game_mode_name>
	GetGlobalTags <bandname_id>
	FormatText textname = the_bands_name "''%n''" n = <name>
	new_menu \{scrollid = mb_scroll vmenuid = mb_vmenu use_backdrop = 0 menu_pos = (732.0, 314.0) rot_angle = -2 spacing = 1}
	create_menu_backdrop \{texture = #"0xc9cd1c15"}
	CreateScreenElement \{Type = ContainerElement id = mb_helper_container parent = root_window Pos = (0.0, 0.0)}
	CreateScreenElement \{Type = ContainerElement id = mb_menu_container parent = mb_vmenu Pos = (0.0, 0.0) not_focusable}
	CreateScreenElement \{Type = SpriteElement parent = mb_helper_container id = light_overlay texture = #"0xf6c8349f" Pos = (640.0, 360.0) dims = (1280.0, 720.0) just = [center center] z_priority = 99}
	CreateScreenElement \{Type = SpriteElement parent = mb_helper_container id = ticket_image texture = #"0x6bdca25b" rgba = [255 255 255 255] Pos = (640.0, 360.0) dims = (1280.0, 720.0) just = [center center] z_priority = 1}
	CreateScreenElement {
		Type = SpriteElement
		parent = mb_helper_container
		id = mb_random_image
		texture = #"0x494b5879"
		rgba = [255 255 255 255]
		Pos = (($enter_band_name_big_vals).right_side_img_pos)
		dims = (($enter_band_name_big_vals).right_side_img_dims)
		z_priority = 2
	}
	<rand> = 0
	GetRandomValue \{name = rand integer a = 0 b = 2}
	if (<rand> = 0)
		SetScreenElementProps \{id = mb_random_image texture = #"0xa7453955"}
	elseif (<rand> = 1)
		SetScreenElementProps \{id = mb_random_image texture = #"0x3e4c68ef"}
	elseif (<rand> = 2)
		SetScreenElementProps \{id = mb_random_image texture = #"0x494b5879"}
	endif
	<manage_band_pos> = (725.0, 190.0)
	CreateScreenElement {
		Type = TextElement
		parent = mb_helper_container
		Pos = <manage_band_pos>
		font = #"0x2274df42"
		rgba = [90 25 5 255]
		text = "MANAGE BAND"
		Scale = 1.75
		z_priority = 3
		rot_angle = -2
	}
	fit_text_in_rectangle id = <id> dims = (850.0, 200.0) Pos = <manage_band_pos>
	CreateScreenElement {
		Type = TextElement
		parent = mb_helper_container
		Pos = (<manage_band_pos> + (0.0, 110.0))
		font = ($choose_band_menu_font)
		rgba = [230 230 200 255]
		text = <the_bands_name>
		Scale = (1.75, 1.25)
		z_priority = 3
		rot_angle = -2
	}
	GetScreenElementDims id = <id>
	if (<width> > 600)
		fit_text_in_rectangle id = <id> dims = (1000.0, 70.0) Pos = (<manage_band_pos> + (0.0, 110.0))
	endif
	displaySprite {
		parent = mb_helper_container
		tex = white
		rgba = [90 25 5 255]
		Pos = (<manage_band_pos> + (-325.0, 92.0))
		dims = (656.0, 48.0)
		z = 3
		rot_angle = -2
	}
	<mb_hlBar_pos_1> = (408.0, 385.0)
	<mb_hlBar_pos_2> = (408.0, 441.0)
	<mb_hlBar_dims> = (654.0, 58.0)
	displaySprite {
		id = mb_hlBarID
		parent = mb_helper_container
		tex = white
		rgba = [205 105 110 255]
		Pos = <mb_hlBar_pos_1>
		dims = <mb_hlBar_dims>
		z = 3
		rot_angle = -2
	}
	CreateScreenElement {
		id = mb_rename_band_id
		parent = mb_menu_container
		Type = TextElement
		font = ($choose_band_menu_font)
		rgba = ($menu_unfocus_color)
		text = "RENAME	BAND"
		just = [center top]
	}
	CreateScreenElement {
		parent = mb_vmenu
		Type = TextElement
		font = ($choose_band_menu_font)
		text = ""
		Scale = 1.3
		just = [center top]
		event_handlers = [
			{focus SetScreenElementProps params = {
					id = mb_hlBarID
					Pos = <mb_hlBar_pos_1>
				}
			}
			{focus manage_band_highlighter params = {id = mb_rename_band_id select}}
			{unfocus manage_band_highlighter params = {id = mb_rename_band_id unselect}}
			{pad_choose menu_manage_band_rename_band}
		]
	}
	CreateScreenElement {
		id = mb_delete_band_id
		parent = mb_menu_container
		Type = TextElement
		font = ($choose_band_menu_font)
		rgba = [90 25 5 255]
		text = "DELETE	BAND"
		just = [center top]
		Pos = (0.0, 56.0)
	}
	CreateScreenElement {
		parent = mb_vmenu
		Type = TextElement
		font = ($choose_band_menu_font)
		text = ""
		just = [center top]
		event_handlers = [
			{focus SetScreenElementProps params = {
					id = mb_hlBarID
					Pos = <mb_hlBar_pos_2>
				}
			}
			{focus SetScreenElementProps params = {
					id = mb_delete_band_id
					Scale = 1.3
					rgba = [255 220 140 255]
				}
			}
			{unfocus SetScreenElementProps params = {
					id = mb_delete_band_id
					Scale = 1.0
					rgba = [90 25 5 255]
				}
			}
			{pad_choose menu_manage_band_delete_band}
		]
	}
	add_user_control_helper \{text = "SELECT" button = green z = 100}
	add_user_control_helper \{text = "BACK" button = red z = 100}
	add_user_control_helper \{text = "UP/DOWN" button = strumbar z = 100}
endscript

script manage_band_highlighter
	if GotParam \{select}
		SetScreenElementProps id = <id> Scale = 1.3 rgba = [255 220 140 255]
		GetScreenElementDims id = <id>
		if (<width> > 634)
			fit_text_in_rectangle id = <id> dims = ((626.0, 0.0) + ((0.0, 1.0) * <height>))start_x_scale = 1.3 start_y_scale = 1.3
		endif
	elseif GotParam \{unselect}
		SetScreenElementProps id = <id> Scale = 1.0 rgba = [90 25 5 255]
		GetScreenElementDims id = <id>
		if (<width> > 634)
			fit_text_in_rectangle id = <id> dims = ((626.0, 0.0) + ((0.0, 1.0) * <height>))start_x_scale = 1.0 start_y_scale = 1.0
		endif
	endif
endscript

script destroy_manage_band_menu
	destroy_menu \{menu_id = mb_scroll}
	destroy_menu \{menu_id = mb_helper_container}
	destroy_menu \{menu_id = mb_menu_container}
	destroy_menu_backdrop
	clean_up_user_control_helpers
endscript

script menu_manage_band_rename_band
	ui_flow_manager_respond_to_action \{action = select_rename_band}
endscript

script menu_manage_band_delete_band
	ui_flow_manager_respond_to_action \{action = select_delete_band}
endscript
