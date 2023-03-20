
script sliderbar_rescale_to_bar
	<target1> = ((<value> - <min>)/ (<Max> - <min>))
	<target2> = (<right> - <left>)
	<target3> = (<target1> * <target2>)
	<rescaled_value> = (<target3> + <left>)
	return x_val = <rescaled_value>
endscript

script sliderbar_add_item\{tab = tab1 font = #"0x45aae5c4" icon_rgba = [127 102 0 128] icon_scale = 0 icon_pos = (22.0, 9.0) text_just = [center center] text_pos = (0.0, 0.0) arrow_pos_up = (0.0, 8.0) arrow_pos_down = (0.0, -8.0) arrow_rgba = [100 90 80 255] up_arrow_texture = up_arrow down_arrow_texture = down_arrow dims = (0.0, 20.0)}
	if GotParam \{is_enabled_script}
		<is_enabled_script>
		if (<success> = 0)
			return
		endif
	endif
	switch <tab>
		case tab1
			<bar_scale> = (0.9199999570846558, 1.2000000476837158)
		case tab2
			<bar_scale> = (0.8500000238418579, 1.2000000476837158)
		case tab3
			<bar_scale> = (0.7799999713897705, 1.2000000476837158)
			<font> = dialog
	endswitch
	SetScreenElementLock \{id = current_menu OFF}
	if NOT GotParam \{pad_choose_params}
		<pad_choose_params> = <...>
	endif
	if GotParam \{index}
		if GotParam \{pad_choose_params}
			<pad_choose_params> = (<pad_choose_params> + {parent_index = <index>})
		else
			<pad_choose_params> = {parent_index = <index>}
		endif
	endif
	<z_priority> = 300
	CreateScreenElement {
		Type = ContainerElement
		parent = current_menu
		id = <anchor_id>
		dims = <dims>
		event_handlers = [{focus <focus_script> params = <focus_params>}
			{unfocus <unfocus_script> params = <unfocus_params>}
			{pad_choose <pad_choose_script> params = <pad_choose_params>}
		]
		<not_focusable>
		z_priority = <z_priority>
	}
	<parent_id> = <id>
	if GotParam \{index}
		SetScreenElementProps {
			id = <parent_id>
			tags = {tag_grid_x = <index>}
		}
	endif
	if GotParam \{not_focusable}
		<rgba> = [60 60 60 100]
	else
		rgba = [128 128 128 240]
	endif
	CreateScreenElement {
		Type = TextElement
		parent = <parent_id>
		font = #"0x45aae5c4"
		text = <text>
		Scale = 0.5
		rgba = [128 , 128 , 128 , 255]
		just = <text_just>
		Pos = <text_pos>
		Shadow
		shadow_rgba = $UI_text_shadow_color
		shadow_offs = (1.0, 1.0)
		replace_handlers
		<not_focusable>
	}
	highlight_angle = 0
	CreateScreenElement {
		Type = SpriteElement
		parent = <parent_id>
		texture = DE_highlight_bar
		Pos = (-25.0, -7.0)
		rgba = [0 0 0 0]
		just = [center center]
		Scale = (1.899999976158142, 0.699999988079071)
		z_priority = 3 rot_angle = <highlight_angle>
	}
	<Pos> = (-9.0, 0.0)
	if GotParam \{bar_pos}
		<Pos> = <bar_pos>
	endif
	bar_rgba = [100 90 80 255]
	CreateScreenElement {
		Type = SpriteElement
		parent = <parent_id>
		z_priority = 1
		Pos = <Pos>
		Scale = (8.0, 0.75)
		texture = roundbar_middle
		rgba = <bar_rgba>
	}
	DoScreenElementMorph id = <id> alpha = 0 time = 0
	CreateScreenElement {
		Type = ContainerElement
		parent = <anchor_id>
		just = [center bottom]
		dims = {200 , 200}
		Pos = <arrow_pos_down>
	}
	CreateScreenElement {
		Type = SpriteElement
		parent = <id>
		id = <down_arrow_id>
		texture = <down_arrow_texture>
		rgba = <arrow_rgba>
		Scale = 0.0
	}
	CreateScreenElement {
		Type = ContainerElement
		parent = <anchor_id>
		just = [center top]
		dims = {200 , 200}
		Pos = <arrow_pos_up>
	}
	CreateScreenElement {
		Type = SpriteElement
		parent = <id>
		id = <up_arrow_id>
		texture = <up_arrow_texture>
		rgba = <arrow_rgba>
		Scale = 0.0
	}
	if GotParam \{child_texture}
		CreateScreenElement {
			Type = SpriteElement
			parent = <parent_id>
			texture = <child_texture>
			Pos = <icon_pos>
			rgba = <icon_rgba>
			Scale = <icon_scale>
			id = <icon_id>
		}
	endif
	SetScreenElementLock \{id = current_menu On}
endscript

script sliderbar_add_text_item
	SetScreenElementLock \{id = current_menu OFF}
	CreateScreenElement {
		Type = ContainerElement
		parent = current_menu
		event_handlers = [{focus sliderbar_focus_text_item params = <focus_params>}
			{unfocus sliderbar_unfocus_text_item}
			{pad_choose <pad_choose_script> params = <pad_choose_params>}
		]
		dims = (0.0, 20.0)
	}
	<parent_id> = <id>
	CreateScreenElement {
		Type = TextElement
		parent = <parent_id>
		font = #"0x45aae5c4"
		text = <text>
		Scale = 0.5
		rgba = [128 , 128 , 128 , 255]
		just = [center top]
		Pos = (-6.0, -6.0)
		Shadow
		shadow_rgba = $UI_text_shadow_color
		shadow_offs = (1.0, 1.0)
	}
	bar_rgba = [100 90 80 255]
	CreateScreenElement {
		Type = SpriteElement
		parent = <parent_id>
		z_priority = 1
		Scale = (8.0, 0.75)
		Pos = (-34.0, 2.0)
		texture = roundbar_middle
		rgba = <bar_rgba>
	}
	DoScreenElementMorph id = <id> alpha = 0 time = 0
	SetScreenElementLock \{id = current_menu On}
endscript

script sliderbar_focus_text_item
	create_helper_text helper_pos = <helper_pos> $generic_helper_text_cas_z Scale = 0.9
	Obj_GetID
	id = <objID>
	on_color = [128 123 20 255]
	SetScreenElementProps {
		id = {<id> child = 0}
		rgba = [90 80 70 255]
		shadow_rgba = [0 , 0 , 0 , 0]
	}
	DoScreenElementMorph id = {<id> child = 1}alpha = 1 time = 0
endscript

script sliderbar_unfocus_text_item
	Obj_GetID
	id = <objID>
	SetScreenElementProps {
		id = {<id> child = 0}
		rgba = [110 110 110 255]
		shadow_rgba = $UI_text_shadow_color
	}
	DoScreenElementMorph id = {<id> child = 1}alpha = 0 time = 0
endscript
