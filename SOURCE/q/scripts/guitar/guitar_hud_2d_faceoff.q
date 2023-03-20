faceoff_hud_2d_elements = {
	offscreen_rock_pos = (1024.0, -400.0)
	offscreen_score_pos_p1 = (-500.0, 480.0)
	rock_pos = (1024.0, 620.0)
	score_pos_p1 = (450.0, 480.0)
	counter_pos_p1 = (470.0, 650.0)
	offscreen_score_pos_p2 = (2800.0, 480.0)
	score_pos_p2 = (1850.0, 480.0)
	counter_pos_p2 = (1830.0, 650.0)
	offscreen_note_streak_bar_off_p1 = (-1000.0, 0.0)
	offscreen_note_streak_bar_off_p2 = (1000.0, 0.0)
	use_note_streak_morph_pos = 1
	offscreen_gamertag_pos = (0.0, -400.0)
	final_gamertag_pos = (0.0, 0.0)
	Scale = 0.5
	small_bulb_scale = 0.6
	big_bulb_scale = 0.9
	z = 0
	score_frame_width = 175.0
	#"0x936bb5fe" = $#"0x28381025"
	elements = [
		{
			parent_container
			element_id = #"0xa90fc148"
			pos_type = #"0x936bb5fe"
		}
		{
			element_id = #"0x99dd87cc"
			element_parent = #"0xa90fc148"
			texture = $#"0x1d52cdca"
			dims = $#"0x8d974f74"
			rot = -0.1
			rgba = $#"0x902ecc17"
			zoff = -2147483648
		}
		{
			parent_container
			element_id = HUD2D_rock_container
			pos_type = offscreen_rock_pos
			create_once
		}
		{
			element_id = HUD2D_rock_body
			element_parent = HUD2D_rock_container
			texture = #"0x10999827"
			pos_off = (0.0, 0.0)
			zoff = 20
			Scale = 2.0
			create_once
		}
		{
			element_id = HUD2D_rock_BG_p1
			element_parent = HUD2D_rock_body
			texture = #"0x3f41a821"
			pos_off = (0.0, 0.0)
			zoff = 16
			alpha = 0
			create_once
		}
		{
			element_id = HUD2D_rock_BG_p2
			element_parent = HUD2D_rock_body
			texture = #"0xa648f99b"
			pos_off = (0.0, 0.0)
			zoff = 16
			alpha = 0
			create_once
		}
		{
			element_id = HUD2D_rock_BG_off
			element_parent = HUD2D_rock_body
			texture = #"0x0a07ba45"
			pos_off = (0.0, 0.0)
			zoff = 15
			create_once
		}
		{
			element_id = HUD2D_rock_needle
			element_parent = HUD2D_rock_body
			texture = #"0x2438b25a"
			pos_off = (132.0, 145.0)
			zoff = 19
			just = [
				0.5
				0.75
			]
			dims = (16.0, 100.0)
			create_once
		}
		{
			element_id = HUD2D_rock_crystal_p1
			element_parent = HUD2D_rock_body
			texture = #"0xc9aa7a01"
			pos_off = (64.0, 64.0)
			zoff = 21
			alpha = 0
			create_once
		}
		{
			element_id = HUD2D_rock_crystal_p2
			element_parent = HUD2D_rock_body
			texture = #"0x50a32bbb"
			pos_off = (64.0, 64.0)
			zoff = 21
			alpha = 0
			create_once
		}
		{
			element_id = HUD2D_rock_crystal_off
			element_parent = HUD2D_rock_body
			texture = #"0x319f715f"
			pos_off = (64.0, 64.0)
			zoff = 20
			create_once
		}
		{
			parent_container
			element_id = HUD2D_score_container
			pos_type = offscreen_score_pos
		}
		{
			element_id = HUD2D_score_body
			element_parent = HUD2D_score_container
			texture = #"0xe4334497"
			pos_type = score_pos
			pos_off = (0.0, 0.0)
			zoff = 5
		}
		{
			parent_container
			element_id = HUD2D_bulb_container
			element_parent = HUD2D_score_container
			pos_off = (0.0, 0.0)
			rot = 90
			rot_p2 = 270
		}
		{
			element_id = HUD2D_rock_tube_1
			element_parent = HUD2D_bulb_container
			texture = #"0xd944d7e8"
			pos_off = (218.0, -260.0)
			pos_off_p2 = (-218.0, 10.0)
			element_dims = (64.0, 128.0)
			small_bulb
			zoff = 0
			just = [
				center
				center
			]
			container
			tube = {
				texture = #"0x351b676f"
				star_texture = #"0xaf2cf767"
				element_dims = (64.0, 16.0)
				pos_off = (0.0, 40.0)
				zoff = 0.1
				alpha = 1
			}
			full = {
				texture = #"0x20273d7b"
				star_texture = #"0x0a3c8de4"
				zoff = 0.2
				alpha = 0
			}
		}
		{
			element_id = HUD2D_rock_tube_2
			element_parent = HUD2D_bulb_container
			texture = #"0xd944d7e8"
			pos_off = (191.0, -260.0)
			pos_off_p2 = (-191.0, 10.0)
			element_dims = (64.0, 128.0)
			small_bulb
			zoff = 0
			just = [
				center
				center
			]
			container
			tube = {
				texture = #"0x351b676f"
				star_texture = #"0xaf2cf767"
				element_dims = (64.0, 16.0)
				pos_off = (0.0, 40.0)
				zoff = 0.1
				alpha = 1
			}
			full = {
				texture = #"0x20273d7b"
				star_texture = #"0x0a3c8de4"
				zoff = 0.2
				alpha = 0
			}
		}
		{
			element_id = HUD2D_rock_tube_3
			element_parent = HUD2D_bulb_container
			texture = #"0xd944d7e8"
			pos_off = (164.0, -260.0)
			pos_off_p2 = (-164.0, 10.0)
			element_dims = (64.0, 128.0)
			small_bulb
			zoff = 0
			just = [
				center
				center
			]
			container
			tube = {
				texture = #"0x351b676f"
				star_texture = #"0xaf2cf767"
				element_dims = (64.0, 16.0)
				pos_off = (0.0, 40.0)
				zoff = 0.1
				alpha = 1
			}
			full = {
				texture = #"0x20273d7b"
				star_texture = #"0x0a3c8de4"
				zoff = 0.2
				alpha = 0
			}
		}
		{
			element_id = HUD2D_rock_tube_4
			element_parent = HUD2D_bulb_container
			texture = #"0xd944d7e8"
			pos_off = (132.0, -270.0)
			initial_pos = (132.0, -100.0)
			pos_off_p2 = (-132.0, 0.0)
			initial_pos_p2 = (-132.0, 100.0)
			element_dims = (64.0, 128.0)
			big_bulb
			zoff = 0
			just = [
				center
				center
			]
			container
			tube = {
				texture = #"0x351b676f"
				star_texture = #"0xaf2cf767"
				element_dims = (64.0, 16.0)
				pos_off = (0.0, 32.0)
				zoff = 0.1
				alpha = 1
			}
			full = {
				texture = #"0x20273d7b"
				star_texture = #"0x0a3c8de4"
				zoff = 0.2
				alpha = 1
			}
		}
		{
			element_id = HUD2D_rock_tube_5
			element_parent = HUD2D_bulb_container
			texture = #"0xd944d7e8"
			pos_off = (92.0, -270.0)
			initial_pos = (92.0, -100.0)
			pos_off_p2 = (-92.0, 0.0)
			initial_pos_p2 = (-92.0, 100.0)
			element_dims = (64.0, 128.0)
			big_bulb
			zoff = 0
			just = [
				center
				center
			]
			container
			tube = {
				texture = #"0x351b676f"
				star_texture = #"0xaf2cf767"
				element_dims = (64.0, 16.0)
				pos_off = (0.0, 32.0)
				zoff = 0.1
				alpha = 1
			}
			full = {
				texture = #"0x20273d7b"
				star_texture = #"0x0a3c8de4"
				zoff = 0.2
				alpha = 1
			}
		}
		{
			element_id = HUD2D_rock_tube_6
			element_parent = HUD2D_bulb_container
			texture = #"0xd944d7e8"
			pos_off = (52.0, -270.0)
			initial_pos = (52.0, -100.0)
			pos_off_p2 = (-52.0, 0.0)
			initial_pos_p2 = (-52.0, 100.0)
			element_dims = (64.0, 128.0)
			big_bulb
			zoff = 0
			just = [
				center
				center
			]
			container
			tube = {
				texture = #"0x351b676f"
				star_texture = #"0xaf2cf767"
				element_dims = (64.0, 16.0)
				pos_off = (0.0, 32.0)
				zoff = 0.1
				alpha = 1
			}
			full = {
				texture = #"0x20273d7b"
				star_texture = #"0x0a3c8de4"
				zoff = 0.2
				alpha = 1
			}
		}
		{
			parent_container
			element_id = HUD2D_score_lights_container
			element_parent = HUD2D_score_container
			pos_off = (0.0, 0.0)
			rot = 0
			rot_p2 = 180
		}
		{
			element_id = HUD2D_score_light_unlit_1
			element_parent = HUD2D_score_lights_container
			texture = #"0xb2f82657"
			pos_type = score_pos
			pos_off = (0.0, 200.0)
			pos_off_p2 = (-268.0, -232.0)
			zoff = 5
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_light_unlit_2
			element_parent = HUD2D_score_lights_container
			texture = #"0xb2f82657"
			pos_type = score_pos
			pos_off = (0.0, 170.0)
			pos_off_p2 = (-268.0, -202.0)
			zoff = 5
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_light_unlit_3
			element_parent = HUD2D_score_lights_container
			texture = #"0xb2f82657"
			pos_type = score_pos
			pos_off = (0.0, 140.0)
			pos_off_p2 = (-268.0, -172.0)
			zoff = 5
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_light_unlit_4
			element_parent = HUD2D_score_lights_container
			texture = #"0xb2f82657"
			pos_type = score_pos
			pos_off = (0.0, 110.0)
			pos_off_p2 = (-268.0, -142.0)
			zoff = 5
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_light_unlit_5
			element_parent = HUD2D_score_lights_container
			texture = #"0xb2f82657"
			pos_type = score_pos
			pos_off = (0.0, 80.0)
			pos_off_p2 = (-268.0, -112.0)
			zoff = 5
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_light_halflit_1
			element_parent = HUD2D_score_lights_container
			texture = #"0xc5ff16c1"
			pos_type = score_pos
			pos_off = (0.0, 200.0)
			pos_off_p2 = (-268.0, -232.0)
			zoff = 5.0999999
			alpha = 0
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_light_halflit_2
			element_parent = HUD2D_score_lights_container
			texture = #"0xc5ff16c1"
			pos_type = score_pos
			pos_off = (0.0, 170.0)
			pos_off_p2 = (-268.0, -202.0)
			zoff = 5.0999999
			alpha = 0
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_light_halflit_3
			element_parent = HUD2D_score_lights_container
			texture = #"0xc5ff16c1"
			pos_type = score_pos
			pos_off = (0.0, 140.0)
			pos_off_p2 = (-268.0, -172.0)
			zoff = 5.0999999
			alpha = 0
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_light_halflit_4
			element_parent = HUD2D_score_lights_container
			texture = #"0xc5ff16c1"
			pos_type = score_pos
			pos_off = (0.0, 110.0)
			pos_off_p2 = (-268.0, -142.0)
			zoff = 5.0999999
			alpha = 0
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_light_halflit_5
			element_parent = HUD2D_score_lights_container
			texture = #"0xc5ff16c1"
			pos_type = score_pos
			pos_off = (0.0, 80.0)
			pos_off_p2 = (-268.0, -112.0)
			zoff = 5.0999999
			alpha = 0
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_light_allwaylit_1
			element_parent = HUD2D_score_lights_container
			texture = #"0x5cf6477b"
			pos_type = score_pos
			pos_off = (0.0, 200.0)
			pos_off_p2 = (-268.0, -232.0)
			zoff = 5.1999998
			alpha = 0
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_light_allwaylit_2
			element_parent = HUD2D_score_lights_container
			texture = #"0x5cf6477b"
			pos_type = score_pos
			pos_off = (0.0, 170.0)
			pos_off_p2 = (-268.0, -202.0)
			zoff = 5.1999998
			alpha = 0
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_light_allwaylit_3
			element_parent = HUD2D_score_lights_container
			texture = #"0x5cf6477b"
			pos_type = score_pos
			pos_off = (0.0, 140.0)
			pos_off_p2 = (-268.0, -172.0)
			zoff = 5.1999998
			alpha = 0
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_light_allwaylit_4
			element_parent = HUD2D_score_lights_container
			texture = #"0x5cf6477b"
			pos_type = score_pos
			pos_off = (0.0, 110.0)
			pos_off_p2 = (-268.0, -142.0)
			zoff = 5.1999998
			alpha = 0
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_light_allwaylit_5
			element_parent = HUD2D_score_lights_container
			texture = #"0x5cf6477b"
			pos_type = score_pos
			pos_off = (0.0, 80.0)
			pos_off_p2 = (-268.0, -112.0)
			zoff = 5.1999998
			alpha = 0
			flags = {
				p2
				flip_h
			}
		}
		{
			element_id = HUD2D_score_nixie_1a
			element_parent = HUD2D_score_container
			texture = #"0xb373f287"
			pos_type = score_pos
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_2a
			element_parent = HUD2D_score_container
			texture = #"0x985ea144"
			pos_type = score_pos
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_2b
			element_parent = HUD2D_score_container
			texture = #"0x0157f0fe"
			pos_type = score_pos
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_3a
			element_parent = HUD2D_score_container
			texture = #"0x81459005"
			pos_type = score_pos
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_4a
			element_parent = HUD2D_score_container
			texture = #"0xce0406c2"
			pos_type = score_pos
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_4b
			element_parent = HUD2D_score_container
			texture = #"0x570d5778"
			pos_type = score_pos
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_6b
			element_parent = HUD2D_score_container
			texture = #"0x653b35fa"
			pos_type = score_pos
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_8b
			element_parent = HUD2D_score_container
			texture = #"0xfbb81874"
			pos_type = score_pos
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			parent_container
			element_id = HUD2D_note_container
			pos_type = counter_pos
			note_streak_bar
			pos_off = (0.0, 0.0)
		}
		{
			element_id = HUD2D_counter_body
			element_parent = HUD2D_note_container
			texture = #"0x38b63489"
			pos_off = (0.0, 0.0)
			zoff = 9
		}
		{
			element_id = #"0x4020ac1b"
			element_parent = HUD2D_note_container
			texture = #"0x4020ac1b"
			pos_off = (4.0, 40.0)
			zoff = 8
		}
		{
			element_id = HUD2D_counter_drum_icon
			element_parent = HUD2D_note_container
			texture = #"0x262aa716"
			pos_off = (44.0, 40.0)
			zoff = 26
		}
		{
			element_id = HUD2D_score_flash
			element_parent = HUD2D_score_container
			texture = #"0x36f7ff86"
			just = [
				center
				center
			]
			pos_type = score_pos
			pos_off = (128.0, 128.0)
			zoff = 20
			alpha = 0
		}
	]
}
