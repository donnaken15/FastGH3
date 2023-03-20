button_array = [
	"0"
	"1"
	"2"
	"3"
	"4"
	"5"
	"6"
	"7"
	"8"
	"9"
	"a"
	"b"
	"c"
	"d"
	"e"
	"f"
	"g"
	"h"
	"i"
	"j"
	"k"
	"l"
]
meta_array = [
	"0"
	"1"
	"2"
	"3"
	"4"
	"5"
	"6"
	"7"
	"8"
	"9"
	"a"
	"b"
	"c"
	"d"
	"e"
	"f"
	"g"
	"h"
	"i"
	"j"
	"k"
	"l"
	"m"
	"n"
	"o"
	"p"
	"q"
	"r"
	"s"
	"t"
	"u"
	"v"
]

script debug_show_buttons\{Scale = 0.8 z_priority = 100 padding_scale = 1.5}
	SetScreenElementLock \{OFF id = root_window}
	if ScreenElementExists \{id = button_container}
		DestroyScreenElement \{id = button_container}
		return
	endif
	CreateScreenElement \{Type = ContainerElement parent = root_window id = button_container Pos = (320.0, 240.0) dims = (640.0, 480.0) event_handlers = [{pad_back debug_kill_buttons params = {}}]}
	CreateScreenElement \{Type = SpriteElement parent = button_container texture = #"0x34d3e9ce" rgba = [0 0 0 100] Scale = (80.0, 30.0) Pos = (320.0, 210.0)}
	CreateScreenElement \{Type = TextElement parent = button_container text = "buttons" font = #"0x45aae5c4" Scale = 1 Pos = (320.0, 120.0) z_priority = 101}
	CreateScreenElement {
		Type = HMenu
		parent = button_container
		id = debug_buttons
		Pos = (320.0, 160.0)
		just = [center bottom]
		internal_just = [left center]
		padding_scale = <padding_scale>
		spacing_between = <spacing_between>
		Scale = <Scale>
		z_priority = <z_priority>
	}
	GetArraySize \{button_array}
	index = 0
	begin
		FormatText textname = text "%i" i = (button_array [<index>])
		FormatText textname = button "\b%i" i = (button_array [<index>])
		create_debug_button_item text = <text> button = <button> parent = debug_buttons
		index = (<index> + 1)
	repeat <array_Size>
	CreateScreenElement \{Type = TextElement parent = button_container text = "meta chars" font = #"0x45aae5c4" Scale = 1 Pos = (320.0, 200.0) z_priority = 101}
	CreateScreenElement {
		Type = HMenu
		parent = button_container
		id = debug_meta1
		Pos = (320.0, 240.0)
		just = [center bottom]
		internal_just = [left center]
		padding_scale = <padding_scale>
		spacing_between = <spacing_between>
		Scale = <Scale>
		z_priority = <z_priority>
	}
	GetArraySize \{meta_array}
	index = 0
	begin
		FormatText textname = text "%i" i = (meta_array [<index>])
		FormatText textname = button "\m%i" i = (meta_array [<index>])
		create_debug_button_item text = <text> button = <button> parent = debug_meta1
		index = (<index> + 1)
	repeat 16
	CreateScreenElement {
		Type = HMenu
		parent = button_container
		id = debug_meta2
		Pos = (320.0, 280.0)
		just = [center bottom]
		internal_just = [left center]
		padding_scale = <padding_scale>
		spacing_between = <spacing_between>
		Scale = <Scale>
		z_priority = <z_priority>
	}
	begin
		FormatText textname = text "%i" i = (meta_array [<index>])
		FormatText textname = button "\m%i" i = (meta_array [<index>])
		create_debug_button_item text = <text> button = <button> parent = debug_meta2
		index = (<index> + 1)
	repeat (<array_Size> -16)
	LaunchEvent \{Type = focus target = button_container}
endscript

script create_debug_button_item
	CreateScreenElement {
		Type = ContainerElement
		parent = <parent>
		Pos = (0.0, 0.0)
		dims = (20.0, 20.0)
		internal_just = [center center]
		just = [center center]
	}
	parent_id = <id>
	CreateScreenElement {
		Type = TextElement
		parent = <parent_id>
		text = <text>
		font = #"0x45aae5c4"
		Pos = (0.0, 0.0)
		just = [center center]
	}
	CreateScreenElement {
		Type = TextElement
		parent = <parent_id>
		text = <button>
		font = #"0x45aae5c4"
		Pos = (0.0, 15.0)
		just = [center center]
	}
	GetScreenElementDims id = <id>
	if GotParam \{width}
		if (<width> > 30)
			SetScreenElementProps id = <parent_id> dims = (55.0, 20.0)
			SetScreenElementProps id = <id> Pos = (15.0, 15.0)
		endif
	endif
endscript

script debug_kill_buttons
	if ScreenElementExists \{id = button_container}
		DestroyScreenElement \{id = button_container}
	endif
endscript

script rebuild_panel_stuff
	destroy_panel_stuff
	create_panel_stuff
endscript
