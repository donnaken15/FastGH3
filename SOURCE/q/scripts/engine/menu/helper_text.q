
script create_helper_text\{anchor_id = helper_text_anchor parent = root_window helper_pos = (640.0, 720.0) spacing_between = 3 bg_rgba = [2 0 1 98] z_priority = 1000 font = text_a1}
	if ObjectExists id = <anchor_id>
		DestroyScreenElement id = <anchor_id>
	endif
	CreateScreenElement {
		Type = ContainerElement
		parent = <parent>
		id = <anchor_id>
		just = [center center]
		Pos = (640.0, 360.0)
		dims = (1280.0, 720.0)
		rot_angle = 0
	}
	if NOT GotParam \{no_bar}
		CreateScreenElement {
			Type = SpriteElement
			parent = <anchor_id>
			texture = white2
			Pos = <helper_pos>
			just = [center bottom]
			rgba = [0 0 0 255]
			Scale = (160.0, 4.0)
			z_priority = (<z_priority> -1)
			rot_angle = -0.125
		}
	endif
	CreateScreenElement {
		Type = HMenu
		parent = <anchor_id>
		Pos = (<helper_pos> - (0.0, 4.0))
		just = [center bottom]
		internal_just = [center center]
		padding_scale = 1.1
		spacing_between = <spacing_between>
		Scale = <Scale>
	}
	<menu_id> = <id>
	if GotParam \{helper_text_elements}
		ForEachIn <helper_text_elements> do = helper_text_update_element params = {font = <font> menu_id = <menu_id> z_priority = <z_priority>}
	endif
endscript

script helper_text_update_element
	if GotParam \{id}
		if ObjectExists <id>
			SetScreenElementProps {
				id = <id>
				text = <text>
			}
			return
		endif
	endif
	GetUpperCaseString <text>
	CreateScreenElement {
		Type = TextElement
		parent = <menu_id>
		id = <id>
		font = <font>
		text = <uppercasestring>
		rgba = [90 90 90 255]
		Scale = 0.4
		z_priority = <z_priority>
		not_focusable
	}
endscript
generic_helper_text = {
	helper_text_elements = [
		{
			text = "\b7/\b4 SELECT"
		}
		{
			text = "\m1 BACK"
		}
		{
			text = "\m0 ACCEPT"
		}
	]
}
generic_helper_text_no_back = {
	helper_text_elements = [
		{
			text = "\b7/\b4 SELECT"
		}
		{
			text = "\m0 ACCEPT"
		}
	]
}
generic_helper_text_no_accept = {
	helper_text_elements = [
		{
			text = "\b7/\b4 SELECT"
		}
		{
			text = "\m1 BACK"
		}
	]
}
generic_helper_text_cas = {
	helper_text_elements = [
		{
			text = "\b7/\b4 SELECT"
		}
		{
			text = "\m1 BACK"
		}
		{
			text = "\m0 ACCEPT"
		}
		{
			text = "\be/\bf ROTATE"
		}
	]
}
generic_helper_text_cas_z = {
	helper_text_elements = [
		{
			text = "\b7/\b4 SELECT"
		}
		{
			text = "\m1 BACK"
		}
		{
			text = "\m0 ACCEPT"
		}
		{
			text = "\be/\bf ROTATE"
		}
		{
			text = "\mj ZOOM"
		}
	]
}
generic_helper_text_left_right = {
	helper_text_elements = [
		{
			text = "\b6/\b5 SELECT"
		}
		{
			text = "\m1 BACK"
		}
		{
			text = "\m0 ACCEPT"
		}
	]
}
generic_helper_text_left_right_no_back = {
	helper_text_elements = [
		{
			text = "\b6/\b5 SELECT"
		}
		{
			text = "\m0 ACCEPT"
		}
	]
}
generic_helper_text_up_down_left_right = {
	helper_text_elements = [
		{
			text = "\b7/\b4/\b6/\b5 SELECT"
		}
		{
			text = "\m1 BACK"
		}
		{
			text = "\m0 ACCEPT"
		}
	]
}
generic_helper_text_left_right_up_down = {
	helper_text_elements = [
		{
			text = "\b7/\b4 SELECT"
		}
		{
			text = "\b6/\b5 ADJUST"
		}
		{
			text = "\m1 BACK"
		}
		{
			text = "\m0 ACCEPT"
		}
	]
}
generic_dialog_helper_text = {
	helper_text_elements = [
		{
			text = "\m0 ACCEPT"
		}
	]
}
generic_dialog_helper_text2 = {
	helper_text_elements = [
		{
			text = "\b7/\b4 SELECT"
		}
		{
			text = "\m0 ACCEPT"
		}
	]
}
generic_dialog_helper_text3 = {
	helper_text_elements = [
		{
			text = "\m1 BACK"
		}
		{
			text = "\m0 ACCEPT"
		}
	]
}
