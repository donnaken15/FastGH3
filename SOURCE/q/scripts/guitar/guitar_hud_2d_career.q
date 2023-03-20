career_hud_2d_elements = {
	offscreen_rock_pos = (2000.0, 610.0)
	offscreen_score_pos = (-500.0, 560.0)
	rock_pos = (1260.0, 692.0)
	score_pos = (300.0, 650.0)
	counter_pos = (330.0, 810.0)
	offscreen_rock_pos_p1 = (-500.0, 100.0)
	offscreen_score_pos_p1 = (-500.0, 40.0)
	rock_pos_p1 = (550.0, 100.0)
	score_pos_p1 = (250.0, 40.0)
	counter_pos_p1 = (-2000.0, 200.0)
	offscreen_rock_pos_p2 = (2000.0, 100.0)
	offscreen_score_pos_p2 = (2000.0, 40.0)
	rock_pos_p2 = (1200.0, 100.0)
	score_pos_p2 = (900.0, 40.0)
	counter_pos_p2 = (-2000.0, 200.0)
	offscreen_note_streak_bar_off = (0.0, 800.0)
	#"0x936bb5fe" = $#"0x28381025"
	Scale = 0.7
	small_bulb_scale = 0.7
	big_bulb_scale = 1.0
	z = 0
	score_frame_width = 175.0
	offscreen_gamertag_pos = (0.0, -400.0)
	final_gamertag_pos = (0.0, 0.0)
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
			just = [
				left
				top
			]
			rgba = $#"0x902ecc17"
			zoff = -2147483648
		}
		{
			parent_container
			element_id = HUD2D_rock_container
			pos_type = offscreen_rock_pos
		}
		{
			element_id = HUD2D_rock_glow
			element_parent = HUD2D_rock_container
			texture = #"0x6e5168a0"
			pos_off = (-50.0, -100.0)
			dims = (350.0, 350.0)
			rgba = [
				95
				205
				255
				255
			]
			alpha = 0
			zoff = -10
		}
		{
			element_id = HUD2D_rock_body
			element_parent = HUD2D_rock_container
			texture = #"0xffdc02c4"
			pos_off = (0.0, 0.0)
			zoff = 22
		}
		{
			element_id = HUD2D_rock_BG_green
			element_parent = HUD2D_rock_body
			texture = #"0x450cea2a"
			pos_off = (0.0, 0.0)
			zoff = 16
		}
		{
			element_id = HUD2D_rock_BG_red
			element_parent = HUD2D_rock_body
			texture = #"0x08c26d99"
			pos_off = (0.0, 0.0)
			zoff = 14
		}
		{
			element_id = HUD2D_rock_BG_yellow
			element_parent = HUD2D_rock_body
			texture = #"0x95414c9e"
			pos_off = (0.0, 0.0)
			zoff = 15
		}
		{
			element_id = HUD2D_rock_lights_all
			element_parent = HUD2D_rock_body
			texture = #"0x79a0865d"
			pos_off = (0.0, 0.0)
			zoff = 17
		}
		{
			element_id = HUD2D_rock_lights_green
			element_parent = HUD2D_rock_body
			texture = #"0x89194192"
			pos_off = (128.0, 0.0)
			zoff = 18
			just = [
				left
				top
			]
			alpha = 0
		}
		{
			element_id = HUD2D_rock_lights_red
			element_parent = HUD2D_rock_body
			texture = #"0xb8d9a80f"
			pos_off = (0.0, 0.0)
			zoff = 18
			just = [
				left
				top
			]
			alpha = 0
		}
		{
			element_id = HUD2D_rock_lights_yellow
			element_parent = HUD2D_rock_body
			texture = #"0x5037628b"
			pos_off = (128.0, 0.0)
			zoff = 18
			just = [
				center
				top
			]
			alpha = 0
		}
		{
			element_id = HUD2D_rock_needle
			element_parent = HUD2D_rock_body
			texture = #"0x2438b25a"
			pos_off = (132.0, 165.0)
			zoff = 19
			just = [
				0.5
				0.8
			]
		}
		{
			element_id = #"0x87004517"
			element_parent = HUD2D_rock_body
			texture = #"0x03ef05a1"
			pos_off = (0.0, 0.0)
			zoff = $#"0x67cf1f5d"
		}
		{
			element_id = #"0x5b77b0ef"
			element_parent = HUD2D_rock_body
			texture = #"0x79a0865d"
			pos_off = (0.0, 0.0)
			zoff = $#"0xdd6ab3d6"
		}
		{
			parent_container
			element_id = HUD2D_bulb_container_1
			element_parent = HUD2D_rock_container
			pos_off = (128.0, 128.0)
			rot = -47.5
		}
		{
			element_id = HUD2D_rock_tube_1
			element_parent = HUD2D_bulb_container_1
			texture = #"0xd944d7e8"
			pos_off = (0.0, -160.0)
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
			parent_container
			element_id = HUD2D_bulb_container_2
			element_parent = HUD2D_rock_container
			pos_off = (128.0, 128.0)
			rot = -33
		}
		{
			element_id = HUD2D_rock_tube_2
			element_parent = HUD2D_bulb_container_2
			texture = #"0xd944d7e8"
			pos_off = (0.0, -160.0)
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
			parent_container
			element_id = HUD2D_bulb_container_3
			element_parent = HUD2D_rock_container
			pos_off = (128.0, 128.0)
			rot = -18.5
		}
		{
			element_id = HUD2D_rock_tube_3
			element_parent = HUD2D_bulb_container_3
			texture = #"0xd944d7e8"
			pos_off = (0.0, -160.0)
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
			parent_container
			element_id = HUD2D_bulb_container_4
			element_parent = HUD2D_rock_container
			pos_off = (128.0, 128.0)
			rot = 0
		}
		{
			element_id = HUD2D_rock_tube_4
			element_parent = HUD2D_bulb_container_4
			texture = #"0xd944d7e8"
			pos_off = (0.0, -170.0)
			initial_pos = (0.0, 0.0)
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
			element_id = HUD2D_bulb_container_5
			element_parent = HUD2D_rock_container
			pos_off = (128.0, 128.0)
			rot = 21
		}
		{
			element_id = HUD2D_rock_tube_5
			element_parent = HUD2D_bulb_container_5
			texture = #"0xd944d7e8"
			pos_off = (0.0, -170.0)
			initial_pos = (0.0, 0.0)
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
			element_id = HUD2D_bulb_container_6
			element_parent = HUD2D_rock_container
			pos_off = (128.0, 128.0)
			rot = 42
		}
		{
			element_id = HUD2D_rock_tube_6
			element_parent = HUD2D_bulb_container_6
			texture = #"0xd944d7e8"
			pos_off = (0.0, -170.0)
			initial_pos = (0.0, 0.0)
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
			element_id = HUD2D_score_light_unlit_1
			element_parent = HUD2D_score_container
			texture = #"0xb2f82657"
			pos_off = (0.0, 200.0)
			zoff = 5
		}
		{
			element_id = HUD2D_score_light_unlit_2
			element_parent = HUD2D_score_container
			texture = #"0xb2f82657"
			pos_off = (0.0, 170.0)
			zoff = 5
		}
		{
			element_id = HUD2D_score_light_unlit_3
			element_parent = HUD2D_score_container
			texture = #"0xb2f82657"
			pos_off = (0.0, 140.0)
			zoff = 5
		}
		{
			element_id = HUD2D_score_light_unlit_4
			element_parent = HUD2D_score_container
			texture = #"0xb2f82657"
			pos_off = (0.0, 110.0)
			zoff = 5
		}
		{
			element_id = HUD2D_score_light_unlit_5
			element_parent = HUD2D_score_container
			texture = #"0xb2f82657"
			pos_off = (0.0, 80.0)
			zoff = 5
		}
		{
			element_id = HUD2D_score_light_halflit_1
			element_parent = HUD2D_score_container
			texture = #"0xc5ff16c1"
			pos_off = (0.0, 200.0)
			zoff = 5.0999999
			alpha = 0
		}
		{
			element_id = HUD2D_score_light_halflit_2
			element_parent = HUD2D_score_container
			texture = #"0xc5ff16c1"
			pos_off = (0.0, 170.0)
			zoff = 5.0999999
			alpha = 0
		}
		{
			element_id = HUD2D_score_light_halflit_3
			element_parent = HUD2D_score_container
			texture = #"0xc5ff16c1"
			pos_off = (0.0, 140.0)
			zoff = 5.0999999
			alpha = 0
		}
		{
			element_id = HUD2D_score_light_halflit_4
			element_parent = HUD2D_score_container
			texture = #"0xc5ff16c1"
			pos_off = (0.0, 110.0)
			zoff = 5.0999999
			alpha = 0
		}
		{
			element_id = HUD2D_score_light_halflit_5
			element_parent = HUD2D_score_container
			texture = #"0xc5ff16c1"
			pos_off = (0.0, 80.0)
			zoff = 5.0999999
			alpha = 0
		}
		{
			element_id = HUD2D_score_light_allwaylit_1
			element_parent = HUD2D_score_container
			texture = #"0x5cf6477b"
			pos_off = (0.0, 200.0)
			zoff = 5.1999998
			alpha = 0
		}
		{
			element_id = HUD2D_score_light_allwaylit_2
			element_parent = HUD2D_score_container
			texture = #"0x5cf6477b"
			pos_off = (0.0, 170.0)
			zoff = 5.1999998
			alpha = 0
		}
		{
			element_id = HUD2D_score_light_allwaylit_3
			element_parent = HUD2D_score_container
			texture = #"0x5cf6477b"
			pos_off = (0.0, 140.0)
			zoff = 5.1999998
			alpha = 0
		}
		{
			element_id = HUD2D_score_light_allwaylit_4
			element_parent = HUD2D_score_container
			texture = #"0x5cf6477b"
			pos_off = (0.0, 110.0)
			zoff = 5.1999998
			alpha = 0
		}
		{
			element_id = HUD2D_score_light_allwaylit_5
			element_parent = HUD2D_score_container
			texture = #"0x5cf6477b"
			pos_off = (0.0, 80.0)
			zoff = 5.1999998
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_1a
			element_parent = HUD2D_score_container
			texture = #"0xb373f287"
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_2a
			element_parent = HUD2D_score_container
			texture = #"0x985ea144"
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_2b
			element_parent = HUD2D_score_container
			texture = #"0x0157f0fe"
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_3a
			element_parent = HUD2D_score_container
			texture = #"0x81459005"
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_4a
			element_parent = HUD2D_score_container
			texture = #"0xce0406c2"
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_4b
			element_parent = HUD2D_score_container
			texture = #"0x570d5778"
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_6b
			element_parent = HUD2D_score_container
			texture = #"0x653b35fa"
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_nixie_8b
			element_parent = HUD2D_score_container
			texture = #"0xfbb81874"
			pos_off = (70.0, 90.0)
			zoff = 4
			alpha = 0
		}
		{
			element_id = HUD2D_score_flash
			element_parent = HUD2D_score_container
			texture = #"0x36f7ff86"
			just = [
				center
				center
			]
			pos_off = (128.0, 128.0)
			zoff = 20
			alpha = 0
		}
	]
}
