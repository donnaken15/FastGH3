button_up_models = {
	green = {
		name = button_g
		name_string = 'button_g'
		material_lip = sys_NowBar_Button01_Green_Lip_sys_NowBar_Button01_Green_Lip
		material_mid = sys_NowBar_Button01_Green_Mid2_sys_NowBar_Button01_Green_Mid2
		material_head = sys_NowBar_Head_Green_sys_NowBar_Head_Green
		material_head_lit = sys_NowBar_Head_GreenL_sys_NowBar_Head_GreenL
		material_neck = sys_NowBar_Neck01_sys_NowBar_Neck01
		material_down = sys_NowBar_Button01_Green_Down_sys_NowBar_Button01_Green_Down
	}
	red = {
		name = button_r
		name_string = 'button_r'
		material_lip = sys_NowBar_Button01_Red_Lip_sys_NowBar_Button01_Red_Lip
		material_mid = sys_NowBar_Button01_Red_Mid2_sys_NowBar_Button01_Red_Mid2
		material_head = sys_NowBar_Head_Red_sys_NowBar_Head_Red
		material_head_lit = sys_NowBar_Head_RedL_sys_NowBar_Head_RedL
		material_neck = sys_NowBar_Neck01_sys_NowBar_Neck01
		material_down = sys_NowBar_Button01_Red_Down_sys_NowBar_Button01_Red_Down
	}
	yellow = {
		name = button_y
		name_string = 'button_y'
		material_lip = sys_NowBar_Button01_Yellow_Lip_sys_NowBar_Button01_Yellow_Lip
		material_mid = sys_NowBar_Button01_Yellow_Mid2_sys_NowBar_Button01_Yellow_Mid2
		material_head = sys_NowBar_Head_Yellow_sys_NowBar_Head_Yellow
		material_head_lit = sys_NowBar_Head_YellowL_sys_NowBar_Head_YellowL
		material_neck = sys_NowBar_Neck01_sys_NowBar_Neck01
		material_down = sys_NowBar_Button01_Yellow_Down_sys_NowBar_Button01_Yellow_Down
	}
	blue = {
		name = button_b
		name_string = 'button_b'
		material_lip = sys_NowBar_Button01_Blue_Lip_sys_NowBar_Button01_Blue_Lip
		material_mid = sys_NowBar_Button01_Blue_Mid2_sys_NowBar_Button01_Blue_Mid2
		material_head = sys_NowBar_Head_Blue_sys_NowBar_Head_Blue
		material_head_lit = sys_NowBar_Head_BlueL_sys_NowBar_Head_BlueL
		material_neck = sys_NowBar_Neck01_sys_NowBar_Neck01
		material_down = sys_NowBar_Button01_Blue_Down_sys_NowBar_Button01_Blue_Down
	}
	orange = {
		name = button_o
		name_string = 'button_o'
		material_lip = sys_NowBar_Button01_Orange_Lip_sys_NowBar_Button01_Orange_Lip
		material_mid = sys_NowBar_Button01_Orange_Mid2_sys_NowBar_Button01_Orange_Mid2
		material_head = sys_NowBar_Head_Orange_sys_NowBar_Head_Orange
		material_head_lit = sys_NowBar_Head_OrangeL_sys_NowBar_Head_OrangeL
		material_neck = sys_NowBar_Neck01_sys_NowBar_Neck01
		material_down = sys_NowBar_Button01_Orange_Down_sys_NowBar_Button01_Orange_Down
	}
}

script setup_highway\{Player = 1}
	generate_pos_table
	SetScreenElementLock \{id = root_window OFF}
	if ($current_num_players = 1)
		<Pos> = (0.0, 0.0)
		<Scale> = (1.0, 1.0)
	else
		if (<Player> = 1)
			<Pos> = ((0 - $x_offset_p2)* (1.0, 0.0))
		else
			if NOT ($devil_finish = 1)
				<Pos> = ($x_offset_p2 * (1.0, 0.0))
			else
				<Pos> = (1000.0, 0.0)
			endif
		endif
		<Scale> = (1.0, 1.0)
	endif
	if ($#"0xdf7ff31b" = 0)
		<container_pos> = (<Pos> + (0.0, 720.0))
	endif
	ExtendCrc gem_container <player_text> out = container_id
	CreateScreenElement {
		Type = ContainerElement
		id = <container_id>
		parent = root_window
		Pos = <container_pos>
		just = [left top]
		Scale = <Scale>
		z_priority = 0
	}
	if ($Cheat_PerformanceMode = 1)
		disable_bg_viewport
	else
		enable_bg_viewport
	endif
	hpos = ((640.0 - ($highway_top_width / 2.0))* (1.0, 0.0))
	hDims = ($highway_top_width * (1.0, 0.0))
	<highway_material> = ($<player_status>.highway_material)
	ExtendCrc Highway_2D <player_text> out = highway_name
	CreateScreenElement {
		Type = SpriteElement
		id = <highway_name>
		parent = <container_id>
		clonematerial = <highway_material>
		rgba = $highway_normal
		Pos = <hpos>
		dims = <hDims>
		just = [left left]
		z_priority = 0.1
	}
	highway_speed = (0.0 - ($gHighwayTiling / ($<player_status>.scroll_time - $destroy_time)))
	printf "Setting highway speed to: %h" h = <highway_speed>
	Set2DHighwaySpeed speed = <highway_speed> id = <highway_name> player_status = <player_status>
	fe = ($highway_playline - $highway_height)
	fs = (<fe> + $highway_fade)
	Set2DHighwayFade start = <fs> end = <fe> id = <highway_name> Player = <Player>
	Pos = ((640 * (1.0, 0.0))+ ($highway_playline * (0.0, 1.0)))
	now_scale = (($nowbar_scale_x * (1.0, 0.0))+ ($nowbar_scale_y * (0.0, 1.0)))
	lpos = (($sidebar_x * (1.0, 0.0))+ ($sidebar_y * (0.0, 1.0)))
	langle = ($sidebar_angle)
	rpos = ((((640.0 - $sidebar_x)+ 640.0)* (1.0, 0.0))+ ($sidebar_y * (0.0, 1.0)))
	rangle = (0.0 - ($sidebar_angle))
	Scale = (($sidebar_x_scale * (1.0, 0.0))+ ($sidebar_y_scale * (0.0, 1.0)))
	rscale = (((0 - $sidebar_x_scale)* (1.0, 0.0))+ ($sidebar_y_scale * (0.0, 1.0)))
	ExtendCrc sidebar_container_left <player_text> out = cont
	CreateScreenElement {
		Type = ContainerElement
		id = <cont>
		parent = <container_id>
		Pos = <lpos>
		rot_angle = <langle>
		just = [center bottom]
		z_priority = 3
	}
	ExtendCrc sidebar_left <player_text> out = name
	CreateScreenElement {
		Type = SpriteElement
		id = <name>
		parent = <cont>
		material = sys_sidebar2D_sys_sidebar2D
		rgba = [255 255 255 255]
		Pos = (0.0, 0.0)
		Scale = <Scale>
		just = [center bottom]
		z_priority = 3
	}
	Set2DGemFade id = <name> Player = <Player>
	if ($Cheat_PerformanceMode = 0)
		ExtendCrc starpower_container_left <player_text> out = cont
		CreateScreenElement {
			Type = ContainerElement
			id = <cont>
			parent = <container_id>
			Pos = <lpos>
			rot_angle = <langle>
			just = [center bottom]
			z_priority = 3
		}
		starpower_pos = (((-55.0 * $starpower_fx_scale)* (1.0, 0.0))+ ((55.0 * $starpower_fx_scale)* (0.0, 1.0)))
		starpower_scale = (((1.0 * $starpower_fx_scale)* (1.0, 0.0))+ ((1.1 * $starpower_fx_scale)* (0.0, 1.0)))
		ExtendCrc sidebar_left_glow <player_text> out = name
		CreateScreenElement {
			Type = SpriteElement
			id = <name>
			parent = <cont>
			material = sys_Starpower_SDGLOW_sys_Starpower_SDGLOW
			rgba = [255 255 255 255]
			Pos = <starpower_pos>
			Scale = <starpower_scale>
			just = [center bottom]
			z_priority = 0
		}
		starpower_pos = (((0.0 * $starpower_fx_scale)* (1.0, 0.0))+ ((0 * $starpower_fx_scale)* (0.0, 1.0)))
		starpower_scale = (((-0.5 * $starpower_fx_scale)* (1.0, 0.0))+ ((0.9 * $starpower_fx_scale)* (0.0, 1.0)))
		ExtendCrc sidebar_left_Lightning01 <player_text> out = name
		CreateScreenElement {
			Type = SpriteElement
			id = <name>
			parent = <cont>
			material = sys_Big_Bolt01_sys_Big_Bolt01
			rgba = [0 0 128 128]
			Pos = <starpower_pos>
			rot_angle = (180)
			Scale = <starpower_scale>
			just = [center top]
			z_priority = 4
		}
		starpower_pos = (((0.0 * $starpower_fx_scale)* (1.0, 0.0))+ ((0.0 * $starpower_fx_scale)* (0.0, 1.0)))
		starpower_scale = (((2.0 * $starpower_fx_scale)* (1.0, 0.0))+ ((0.9 * $starpower_fx_scale)* (0.0, 1.0)))
		ExtendCrc sidebar_left_Lightning02 <player_text> out = name
		CreateScreenElement {
			Type = SpriteElement
			id = <name>
			parent = <cont>
			material = sys_Big_Bolt01_sys_Big_Bolt01
			rgba = [255 255 255 255]
			Pos = <starpower_pos>
			rot_angle = (180)
			Scale = <starpower_scale>
			just = [center top]
			z_priority = 0.02
		}
	endif
	ExtendCrc sidebar_container_right <player_text> out = cont
	CreateScreenElement {
		Type = ContainerElement
		id = <cont>
		parent = <container_id>
		Pos = <rpos>
		rot_angle = <rangle>
		just = [center bottom]
		z_priority = 3
	}
	ExtendCrc sidebar_right <player_text> out = name
	CreateScreenElement {
		Type = SpriteElement
		id = <name>
		parent = <cont>
		material = sys_sidebar2D_sys_sidebar2D
		rgba = [255 255 255 255]
		Pos = (0.0, 0.0)
		Scale = <rscale>
		just = [center bottom]
		z_priority = 3
	}
	Set2DGemFade id = <name> Player = <Player>
	if ($Cheat_PerformanceMode = 0)
		ExtendCrc starpower_container_right <player_text> out = cont
		CreateScreenElement {
			Type = ContainerElement
			id = <cont>
			parent = <container_id>
			Pos = <rpos>
			rot_angle = <rangle>
			just = [center bottom]
			z_priority = 3
		}
		starpower_pos = (((55.0 * $starpower_fx_scale)* (1.0, 0.0))+ ((55.0 * $starpower_fx_scale)* (0.0, 1.0)))
		starpower_scale = (((-1.0 * $starpower_fx_scale)* (1.0, 0.0))+ ((1.1 * $starpower_fx_scale)* (0.0, 1.0)))
		ExtendCrc sidebar_Right_glow <player_text> out = name
		CreateScreenElement {
			Type = SpriteElement
			id = <name>
			parent = <cont>
			material = sys_Starpower_SDGLOW_sys_Starpower_SDGLOW
			rgba = [255 255 255 255]
			Pos = <starpower_pos>
			Scale = <starpower_scale>
			just = [center bottom]
			z_priority = 0
		}
		starpower_pos = (((0.0 * $starpower_fx_scale)* (1.0, 0.0))+ ((0 * $starpower_fx_scale)* (0.0, 1.0)))
		starpower_scale = (((0.5 * $starpower_fx_scale)* (1.0, 0.0))+ ((0.9 * $starpower_fx_scale)* (0.0, 1.0)))
		ExtendCrc sidebar_Right_Lightning01 <player_text> out = name
		CreateScreenElement {
			Type = SpriteElement
			id = <name>
			parent = <cont>
			material = sys_Big_Bolt01_sys_Big_Bolt01
			rgba = [0 0 128 128]
			Pos = <starpower_pos>
			rot_angle = (180)
			Scale = <starpower_scale>
			just = [center top]
			z_priority = 4
		}
		starpower_pos = (((0.0 * $starpower_fx_scale)* (1.0, 0.0))+ ((0.0 * $starpower_fx_scale)* (0.0, 1.0)))
		starpower_scale = (((2.0 * $starpower_fx_scale)* (1.0, 0.0))+ ((0.9 * $starpower_fx_scale)* (0.0, 1.0)))
		ExtendCrc sidebar_Right_Lightning02 <player_text> out = name
		CreateScreenElement {
			Type = SpriteElement
			id = <name>
			parent = <cont>
			material = sys_Big_Bolt01_sys_Big_Bolt01
			rgba = [255 255 255 255]
			Pos = <starpower_pos>
			rot_angle = (180)
			Scale = <starpower_scale>
			just = [center top]
			z_priority = 0.02
		}
		ExtendCrc starpower_container_left <player_text> out = cont
		DoScreenElementMorph id = <cont> alpha = 0
		ExtendCrc starpower_container_right <player_text> out = cont
		DoScreenElementMorph id = <cont> alpha = 0
	endif
	GetArraySize \{$gem_colors}
	array_count = 0
	begin
		Color = ($gem_colors [<array_count>])
		if StructureContains structure = ($button_up_models.<Color>)name = name
			if ($<player_status>.lefthanded_button_ups = 1)
				<pos2d> = ($button_up_models.<Color>.left_pos_2d)
			else
				<pos2d> = ($button_up_models.<Color>.pos_2d)
			endif
			Pos = (640.0, 643.0)
			FormatText checksumName = name_base '%s_base%p' s = ($button_up_models.<Color>.name_string)p = <player_text> AddToStringLookup = true
			FormatText checksumName = name_string '%s_string%p' s = ($button_up_models.<Color>.name_string)p = <player_text> AddToStringLookup = true
			FormatText checksumName = name_lip '%s_lip%p' s = ($button_up_models.<Color>.name_string)p = <player_text> AddToStringLookup = true
			FormatText checksumName = name_mid '%s_mid%p' s = ($button_up_models.<Color>.name_string)p = <player_text> AddToStringLookup = true
			FormatText checksumName = name_neck '%s_neck%p' s = ($button_up_models.<Color>.name_string)p = <player_text> AddToStringLookup = true
			FormatText checksumName = name_head '%s_head%p' s = ($button_up_models.<Color>.name_string)p = <player_text> AddToStringLookup = true
			<Pos> = (((<pos2d>.(1.0, 0.0))* (1.0, 0.0))+ (1024 * (0.0, 1.0)))
			if ($<player_status>.lefthanded_button_ups = 1)
				<playline_scale> = (((0 - <now_scale>.(1.0, 0.0))* (1.0, 0.0))+ (<now_scale>.(0.0, 1.0) * (0.0, 1.0)))
			else
				<playline_scale> = <now_scale>
			endif
			CreateScreenElement {
				Type = ContainerElement
				id = <name_base>
				parent = <container_id>
				Pos = (0.0, 0.0)
				just = [center bottom]
				z_priority = 3
			}
			CreateScreenElement {
				Type = SpriteElement
				id = <name_lip>
				parent = <name_base>
				material = ($button_up_models.<Color>.material_lip)
				rgba = [255 255 255 255]
				Pos = <pos2d>
				Scale = <playline_scale>
				just = [center bottom]
				z_priority = 3.9
			}
			CreateScreenElement {
				Type = SpriteElement
				id = <name_mid>
				parent = <name_base>
				material = ($button_up_models.<Color>.material_mid)
				rgba = [255 255 255 255]
				Pos = <pos2d>
				Scale = <playline_scale>
				just = [center bottom]
				z_priority = 3.6
			}
			<y_scale> = ($neck_lip_add / $neck_sprite_size)
			<Pos> = (<pos2d> - ($neck_lip_base * (0.0, 1.0)))
			<neck_scale> = (((<playline_scale>.(1.0, 0.0))* (1.0, 0.0))+ (<y_scale> * (0.0, 1.0)))
			CreateScreenElement {
				Type = SpriteElement
				id = <name_neck>
				parent = <name_base>
				material = ($button_up_models.<Color>.material_neck)
				rgba = [255 255 255 255]
				Pos = <Pos>
				Scale = <neck_scale>
				just = [center bottom]
				z_priority = 3.7
			}
			CreateScreenElement {
				Type = SpriteElement
				id = <name_head>
				parent = <name_base>
				material = ($button_up_models.<Color>.material_head)
				rgba = [255 255 255 255]
				Pos = <pos2d>
				Scale = <playline_scale>
				just = [center bottom]
				z_priority = 3.8
			}
			string_pos2d = ($button_up_models.<Color>.pos_2d)
			<string_scale> = (($string_scale_x * (1.0, 0.0))+ ($string_scale_y * (0.0, 1.0)))
			CreateScreenElement {
				Type = SpriteElement
				id = <name_string>
				parent = <container_id>
				material = sys_String01_sys_String01
				rgba = [200 200 200 200]
				Scale = <string_scale>
				rot_angle = ($button_models.<Color>.angle)
				Pos = <string_pos2d>
				just = [center bottom]
				z_priority = 2
			}
		endif
		array_count = (<array_count> + 1)
	repeat <array_Size>
	SpawnScriptLater move_highway_2d params = {<...> }
	create_highway_prepass <...>
	SetScreenElementLock \{id = root_window On}
endscript

script destroy_highway
	killspawnedscript \{name = MoveGem}
	destroy_highway_prepass <...>
	ExtendCrc Highway_2D <player_text> out = name
	if ScreenElementExists id = <name>
		DestroyScreenElement id = <name>
	endif
	ExtendCrc gem_container <player_text> out = name
	if ScreenElementExists id = <name>
		DestroyScreenElement id = <name>
	endif
	ExtendCrc Gem_basebar <player_text> out = name
	if ScreenElementExists id = <name>
		DestroyScreenElement id = <name>
	endif
	GetArraySize \{$gem_colors}
	array_count = 0
	begin
		Color = ($gem_colors [<array_count>])
		if StructureContains structure = ($button_up_models.<Color>)name = name_string
			ExtendCrc ($button_up_models.<Color>.name) <player_text> out = name
			if ScreenElementExists id = <name>
				DestroyScreenElement id = <name>
			endif
		endif
		array_count = (<array_count> + 1)
	repeat <array_Size>
endscript
prepass_camera_pos = (0.0, 0.0, 0.0)
prepass_border = 0

script calculate_prepass_poly_params
endscript

script calculate_prepass_offset
endscript

script update_prepass_position
endscript

script update_highway_prepass
endscript

script create_highway_prepass_object
endscript

script create_highway_prepass
endscript

script destroy_highway_prepass
endscript

script disable_highway_prepass
	GetDisplaySettings
	if (<widescreen> = true)
		if ViewportExists \{id = bg_viewport}
			if PrepassViewportExists \{viewport = bg_viewport}
				SetViewportProperties \{viewport = bg_viewport clear_colorbuffer = true}
				SetViewportProperties \{viewport = bg_viewport clear_depthstencilbuffer = true}
				SetViewportProperties \{viewport = bg_viewport prepass = 0 Active = FALSE}
				SetViewportProperties \{viewport = bg_viewport prepass = 1 Active = FALSE}
			endif
		endif
	endif
endscript

script enable_highway_prepass
	GetDisplaySettings
	if (<widescreen> = true)
		if ViewportExists \{id = bg_viewport}
			if PrepassViewportExists \{viewport = bg_viewport}
				SetViewportProperties \{viewport = bg_viewport clear_colorbuffer = FALSE}
				SetViewportProperties \{viewport = bg_viewport clear_depthstencilbuffer = FALSE}
				SetViewportProperties \{viewport = bg_viewport prepass = 0 Active = true}
				SetViewportProperties \{viewport = bg_viewport prepass = 1 Active = true}
			endif
		endif
	endif
endscript
start_2d_move = 0

PC_HIGHWAY_ANIM = 0
script move_highway_2d
	Change \{start_2d_move = 0}
	begin
		if ($start_2d_move = 1)
			break
		endif
		wait \{1 gameframe}
	repeat
	if ($PC_HIGHWAY_ANIM = 0)
		// a bit slow
		GetDeltaTime \{ignore_slomo}
		interval = (1.0/<delta_time>/$current_speedfactor)
		if (<interval> < 60)
			interval = 60
		endif
		if (<interval> > 144)
			interval = 144
		endif
		pos_start_orig = 0
		GetSongTimeMs
		MathPow ((<interval>)/60.0) exp = 2
		movetime = ($current_intro.highway_move_time / 2200.0)
		if (<movetime> < 0.001)
			SetScreenElementProps id = <container_id> Pos = (((<container_pos>.(1.0, 0.0))* (1.0, 0.0)) + (<pos_start_orig> * (0.0, 1.0)))
			return
		endif
		i1000 = (1000.0 / <interval>)
		start_time = (<time> - (400.0 * <movetime>)) // instantly appear animating into screen
		last_time = -1
		begin
			GetSongTimeMs
			time2 = (((<time> - <start_time>) / <i1000>) / <movetime>)
			CastToInteger \{time2}
			if NOT (<last_time> = <time2>)
				//ProfilingStart
				highway_start_y = 720
				pos_add = -720
				pos_sub = 1.0
				pos_sub_add = (0.0004386 / <pow>)
				last_time = <time2>
				if (<time2> > 0)
					begin
						// there needs to be some optimization for this sort of thing
						<highway_start_y> = (<highway_start_y> + (<pos_add> * (1.0/<interval>)))
						<pos_add> = (<pos_add> * <pos_sub>)
						<pos_sub> = (<pos_sub> - <pos_sub_add>)
						if (<highway_start_y> <= <pos_start_orig> || <pos_add> >= -0.002)
							break
						endif
					repeat <time2>
					//printf '%d' d = <highway_start_y>
				endif
				SetScreenElementProps id = <container_id> Pos = (((<container_pos>.(1.0, 0.0))* (1.0, 0.0))+ (<highway_start_y> * (0.0, 1.0)))
				//ProfilingEnd <...> 'highway move'
			endif
			if (<highway_start_y> <= <pos_start_orig> || <pos_add> >= -0.002)
				//printf '%d' d = <highway_start_y>
				SetScreenElementProps id = <container_id> Pos = (((<container_pos>.(1.0, 0.0))* (1.0, 0.0))+ (<pos_start_orig> * (0.0, 1.0)))
				break
			endif
			wait \{1 gameframe}
		repeat
	/**/else
		highway_start_y = 720
		pos_start_orig = 0
		pos_add = -720
		elapsed_time = 0.0
		begin
			<Pos> = (((<container_pos>.(1.0, 0.0))* (1.0, 0.0))+ (<highway_start_y> * (0.0, 1.0)))
			SetScreenElementProps id = <container_id> Pos = <Pos>
			GetDeltaTime \{ignore_slomo}
			<elapsed_time> = (<elapsed_time> + <delta_time>)
			<scaled_time> = (<elapsed_time> / 1.3)
			if (<scaled_time> > 1.0)
				<scaled_time> = 1.0
			endif
			ln (1.005 - <scaled_time>)
			<speed_modifier> = ((<ln> * 0.25)+ 1.0)
			if (<speed_modifier> < 0.05)
				<speed_modifier> = 0.05
			endif
			<highway_start_y> = (<highway_start_y> + (<pos_add> * <delta_time> * <speed_modifier>))
			if (<highway_start_y> <= <pos_start_orig>)
				<Pos> = (((<container_pos>.(1.0, 0.0))* (1.0, 0.0))+ (<pos_start_orig> * (0.0, 1.0)))
				SetScreenElementProps id = <container_id> Pos = <Pos>
				break
			endif
			wait \{1 gameframe}
		repeat
	endif/**//
endscript

script move_highway_camera_to_default\{Player = 1}
	Change \{start_2d_move = 1}
endscript

script disable_bg_viewport_properties
	SetViewportProperties \{viewport = bg_viewport clear_colorbuffer = true}
	SetViewportProperties \{viewport = bg_viewport clear_depthstencilbuffer = true}
	if PrepassViewportExists \{viewport = bg_viewport}
		SetViewportProperties \{viewport = bg_viewport prepass = 0 Active = FALSE}
		SetViewportProperties \{viewport = bg_viewport prepass = 1 Active = FALSE}
	endif
endscript

script disable_highway
	if ScreenElementExists \{id = gem_containerp1}
		DoScreenElementMorph \{id = gem_containerp1 alpha = 0}
	endif
	if ScreenElementExists \{id = gem_containerp2}
		DoScreenElementMorph \{id = gem_containerp2 alpha = 0}
	endif
	if ScreenElementExists \{id = HUD_2D_Containerp1}
		DoScreenElementMorph \{id = HUD_2D_Containerp1 alpha = 0}
	endif
	if ScreenElementExists \{id = HUD_2D_Containerp2}
		DoScreenElementMorph \{id = HUD_2D_Containerp2 alpha = 0}
	endif
	if ScreenElementExists \{id = battle_alert_containerp1}
		DoScreenElementMorph \{id = battle_alert_containerp1 alpha = 0}
	endif
	if ScreenElementExists \{id = battle_alert_containerp2}
		DoScreenElementMorph \{id = battle_alert_containerp2 alpha = 0}
	endif
endscript

script disable_bg_viewport
	disable_highway <...>
	kill_dummy_bg_camera
	ui_clip_root ::SetProps \{Hide}
	disable_bg_viewport_properties
	SetActiveCamera \{id = viewer_cam viewport = bg_viewport}
endscript

script enable_bg_viewport_properties
	if PrepassViewportExists \{viewport = bg_viewport}
		SetViewportProperties \{viewport = bg_viewport clear_colorbuffer = FALSE}
		SetViewportProperties \{viewport = bg_viewport clear_depthstencilbuffer = FALSE}
		SetViewportProperties \{viewport = bg_viewport no_resolve_depthstencilbuffer = true}
		SetViewportProperties \{viewport = bg_viewport no_resolve_colorbuffer = true}
		SetViewportProperties \{viewport = bg_viewport prepass = 0 Active = true}
		SetViewportProperties \{viewport = bg_viewport prepass = 1 Active = true}
	else
		SetViewportProperties \{viewport = bg_viewport clear_colorbuffer = true}
		SetViewportProperties \{viewport = bg_viewport clear_depthstencilbuffer = true}
		SetViewportProperties \{viewport = bg_viewport no_resolve_depthstencilbuffer = true}
		SetViewportProperties \{viewport = bg_viewport no_resolve_colorbuffer = true}
	endif
	TOD_Proxim_Update_LightFX_Viewport \{fxParam = $Default_TOD_Manager viewport = bg_viewport time = 0}
endscript

script enable_highway
	if ScreenElementExists \{id = gem_containerp1}
		DoScreenElementMorph \{id = gem_containerp1 alpha = 1}
	endif
	if ScreenElementExists \{id = gem_containerp2}
		DoScreenElementMorph \{id = gem_containerp2 alpha = 1}
	endif
	if ScreenElementExists \{id = HUD_2D_Containerp1}
		DoScreenElementMorph \{id = HUD_2D_Containerp1 alpha = 1}
	endif
	if ScreenElementExists \{id = HUD_2D_Containerp2}
		DoScreenElementMorph \{id = HUD_2D_Containerp2 alpha = 1}
	endif
	if ScreenElementExists \{id = battle_alert_containerp1}
		DoScreenElementMorph \{id = battle_alert_containerp1 alpha = 1}
	endif
	if ScreenElementExists \{id = battle_alert_containerp2}
		DoScreenElementMorph \{id = battle_alert_containerp2 alpha = 1}
	endif
endscript

script enable_bg_viewport
	enable_highway <...>
	enable_bg_viewport_properties
	ui_clip_root ::SetProps \{unhide}
endscript

script destroy_bg_viewport
	kill_dummy_bg_camera
	if ScreenElementExists \{id = ui_clip_root}
		DestroyScreenElement \{id = ui_clip_root}
	endif
	SetScreenMode \{one_camera}
	SetViewportProperties \{viewport = 0 clear_colorbuffer = true}
	SetViewportProperties \{viewport = 0 no_resolve_depthstencilbuffer = FALSE}
endscript
Highway_Fader_Params = {
	style = highway_fader
	rt_size = (1280.0, 720.0)
	rt_offset = (0.0, 0.0)
	clip_dims = (256.0, 256.0)
	clip_offset = (0.0, -64.0)
	mask_dims = (512.0, 200.0)
}
Highway_Fader_Params_2p = {
	style = highway_fader_2p
	rt_size = (1280.0, 720.0)
	rt_offset = (0.0, 0.0)
	clip_dims = (1024.0, 200.0)
	clip_offset = (0.0, 0.0)
	mask_dims = (1280.0, 200.0)
}

script setup_bg_viewport
	printf \{"Setting bg viewport"}
	destroy_bg_viewport
	if isXenon
		if ($current_num_players = 1)
			AddParams \{$Highway_Fader_Params}
		else
			AddParams \{$Highway_Fader_Params_2p}
		endif
	else
		if ($current_num_players = 1)
			AddParams \{$Highway_Fader_Params_ps3}
		else
			AddParams \{$Highway_Fader_Params_2p_ps3}
		endif
	endif
	Pos = (2000.0, 300.0)
	Pos = (<Pos> + <clip_offset>)
	mask_pos = (<clip_dims> * 0.5 - <clip_offset>)
	bg_pos = (<clip_dims> * 0.5 - <Pos> + <rt_offset>)
	if NOT ScreenElementExists \{id = ui_clip_root}
		CreateScreenElement {
			parent = root_window
			Type = WindowElement
			id = ui_clip_root
			just = [center center]
			Pos = <Pos>
			dims = <clip_dims>
		}
		CreateMaskedScreenElements {
			z_priority = -10
			mask_element = {
				id = viewport_mask_sprite
				parent = ui_clip_root
				Type = SpriteElement
				Pos = <mask_pos>
				just = [center center]
				dims = <mask_dims>
				rgba = [255 255 255 255]
				alpha = 1
				z_priority = 110
				texture = white2
				rot_angle = -180
			}
			elements = [
				{
					parent = ui_clip_root
					Type = ViewportElement
					id = bg_viewport
					texture = viewport0
					Pos = <bg_pos>
					just = [left top]
					dims = <rt_size>
					rgba = [128 128 128 255]
					alpha = 1
					has_shadow = true
					draw_debug_lines = true
					show_lightvolumes = true
					style = <style>
				}
			]
		}
	endif
	enable_bg_viewport_properties
	printf \{"Setting bg viewport end"}
endscript
highway_pulse_p1 = 0
highway_pulse_p2 = 0

disable_shake = 0
script highway_pulse_multiplier_loss\{player_text = 'p1' multiplier = 1}
	if ($Cheat_PerformanceMode = 1 || $disable_shake = 1)
		return
	endif
	if ($game_mode = p2_battle || $boss_battle = 1)
		return
	endif
	time = 0.1
	switch <multiplier>
		case 1
			push_pos = (0.0, 3.0)
		case 2
			push_pos = (0.0, 4.0)
		case 3
			push_pos = (0.0, 10.0)
		case 4
			push_pos = (0.0, 15.0)
			time = 0.11
		default
			push_pos = (0.0, 3.0)
	endswitch
	if (($game_mode = p2_faceoff)|| ($game_mode = p2_pro_faceoff)|| ($game_mode = p2_career)|| ($game_mode = p2_coop))
		<push_pos> = (<push_pos> * 0.6)
	endif
	extendcrc highway_pulse_ <player_text> out = pulse_var
	highway_pulse = $<pulse_var>
	if (<highway_pulse> = 1)
		return
	endif
	change globalname = <pulse_var> newvalue = 1
	ExtendCrc gem_container <player_text> out = container_id
	GetScreenElementPosition id = <container_id>
	original_position = <ScreenElementPos>
	GetRandomValue \{name = random_x a = -7 b = 7 integer}
	DoScreenElementMorph {id = <container_id> Pos = (<original_position> + <push_pos> + ((1.0, 0.0) * <random_x>))just = [center bottom] time = <time>}
	wait <time> seconds
	GetRandomValue \{name = random_x a = -7 b = 7 integer}
	DoScreenElementMorph {id = <container_id> Pos = (<original_position> - (<push_pos> * 0.7)+ ((1.0, 0.0) * <random_x>))just = [center bottom] time = <time>}
	wait <time> seconds
	GetRandomValue \{name = random_x a = -5 b = 5 integer}
	DoScreenElementMorph {id = <container_id> Pos = (<original_position> + (<push_pos> * 0.4)+ ((1.0, 0.0) * <random_x>))just = [center bottom] time = <time>}
	wait <time> seconds
	GetRandomValue \{name = random_x a = -5 b = 5 integer}
	DoScreenElementMorph {id = <container_id> Pos = (<original_position> - (<push_pos> * 0.3)+ ((1.0, 0.0) * <random_x>))just = [center bottom] time = <time>}
	wait <time> seconds
	GetRandomValue \{name = random_x a = -3 b = 3 integer}
	DoScreenElementMorph {id = <container_id> Pos = (<original_position> + (<push_pos> * 0.2)+ ((1.0, 0.0) * <random_x>))just = [center bottom] time = <time>}
	wait <time> seconds
	DoScreenElementMorph {id = <container_id> Pos = <original_position> just = [center bottom] time = <time>}
	change globalname = <pulse_var> newvalue = 0
endscript

script highway_visible
	Change \{highwayvisible = On}
endscript

script highway_invisible
	Change \{highwayvisible = OFF}
endscript
