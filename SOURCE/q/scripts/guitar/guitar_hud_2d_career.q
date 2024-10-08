
// desperate
career_hud_2d_elements = {
/**/
	compressed = career_hud_2d_elements
	Scale = 0.7
	z = 0
}
script career_hud_2d_elements_load
	rock_light_base = {
		element_parent = HUD2D_rock_body
		pos_off = (128.0, 0.0)
		zoff = 18
		alpha = 0
	}
	tube_base = {
		texture = hud_rock_tube
		element_dims = (64.0, 128.0)
		zoff = 0
		just = [ center center ]
		container
	}
	small_bulb = {
		<tube_base>
		pos_off = (0.0, -160.0)
		small_bulb
		tube = {
			texture = hud_rock_tube_glow_fill
			star_texture = hud_rock_tube_glow_fill_b
			element_dims = (64.0, 16.0)
			pos_off = (0.0, 40.0)
			zoff = 0.1
			alpha = 1
		}
		full = {
			texture = hud_rock_tube_glow_full
			star_texture = hud_rock_tube_glow_full_b
			zoff = 0.2
			alpha = 0
		}
	}
	big_bulb = {
		<tube_base>
		pos_off = (0.0, -170.0)
		initial_pos = (0.0, 0.0)
		big_bulb
		tube = {
			texture = hud_rock_tube_glow_fill
			star_texture = hud_rock_tube_glow_fill_b
			element_dims = (64.0, 16.0)
			pos_off = (0.0, 32.0)
			zoff = 0.1
			alpha = 1
		}
		full = {
			texture = hud_rock_tube_glow_full
			star_texture = hud_rock_tube_glow_full_b
			zoff = 0.2
			alpha = 1
		}
	}
	change career_hud_2d_elements = {/**/
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
		Scale = 0.7
		small_bulb_scale = 0.7
		big_bulb_scale = 1.0
		z = 0
		score_frame_width = 175.0
		score_text_pos = (222.0, 70.0)
		score_text_spacing = 5
		score_text_scale = 1.1
		score_text_rgba = [255 255 255 255]
		score_z = 7
		streak_text_pos = (222.0, 78.0)
		streak_num_spacing = 37.0
		streak_num_color = [
			[230 230 230 200]
			[15 15 70 200]
		]
		offscreen_gamertag_pos = (0.0, -400.0)
		final_gamertag_pos = (0.0, 0.0)
		elements = [
			{
				parent_container
				element_id = HUD2D_rock_container
				pos_type = offscreen_rock_pos
			}
			{
				element_id = HUD2D_rock_glow
				element_parent = HUD2D_rock_container
				texture = Char_Select_Hilite1
				pos_off = (-50.0, -100.0)
				dims = (350.0, 350.0)
				rgba = [ 95 205 255 255 ]
				alpha = 0
				zoff = -10
			}
			{
				element_id = HUD2D_rock_body
				element_parent = HUD2D_rock_container
				texture = hud_rock_body
				pos_off = (0.0, 0.0)
				zoff = 22
			}
			{
				element_id = HUD2D_rock_BG_green
				element_parent = HUD2D_rock_body
				texture = hud_rock_bg_green
				zoff = 16
			}
			{
				element_id = HUD2D_rock_BG_red
				element_parent = HUD2D_rock_body
				texture = hud_rock_bg_red
				zoff = 14
			}
			{
				element_id = HUD2D_rock_BG_yellow
				element_parent = HUD2D_rock_body
				texture = hud_rock_bg_yellow
				zoff = 15
			}
			{
				element_id = HUD2D_rock_lights_all
				element_parent = HUD2D_rock_body
				texture = hud_rock_lights_all
				zoff = 17
			}
			{
				element_id = HUD2D_rock_lights_green
				texture = hud_rock_lights_green
				<rock_light_base>
				just = [ left top ]
			}
			{
				element_id = HUD2D_rock_lights_red
				texture = hud_rock_lights_red
				<rock_light_base>
				just = [ right top ]
			}
			{
				element_id = HUD2D_rock_lights_yellow
				texture = hud_rock_lights_yellow
				<rock_light_base>
				just = [ center top ]
			}
			{
				element_id = HUD2D_rock_needle
				element_parent = HUD2D_rock_body
				texture = hud_rock_needle
				pos_off = (132.0, 165.0)
				zoff = 19
				just = [ 0.5 0.8 ]
			}
			{
				element_id = hud2d_rock_bg_nofail
				element_parent = HUD2D_rock_body
				texture = HUD_rock_bg_null
				pos_off = (0.0, 0.0)
				zoff = 20
				alpha = $Cheat_NoFail // why didnt i do it like this before
			}
			{
				element_id = HUD2D_rock_lights_nofail
				element_parent = HUD2D_rock_body
				texture = HUD_rock_lights_all
				pos_off = (0.0, 0.0)
				zoff = 21
				alpha = $Cheat_NoFail
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
				<small_bulb>
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
				<small_bulb>
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
				<small_bulb>
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
				<big_bulb>
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
				<big_bulb>
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
				<big_bulb>
			}
			{
				parent_container
				element_id = HUD2D_score_container
				pos_type = offscreen_score_pos
			}
			{
				element_id = HUD2D_score_body
				element_parent = HUD2D_score_container
				texture = hud_score_body
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
				texture = hud_counter_body
				pos_off = (0.0, 0.0)
				zoff = 9
			}
			{
				element_id = hud_counter_drum
				element_parent = HUD2D_note_container
				texture = hud_counter_drum
				pos_off = (4.0, 40.0)
				zoff = 8
			}
			{
				element_id = HUD2D_counter_drum_icon
				element_parent = HUD2D_note_container
				texture = hud_counter_drum_icon
				pos_off = (44.0, 40.0)
				zoff = 26
			}
			{
				element_id = HUD2D_score_light_unlit_1
				element_parent = HUD2D_score_container
				texture = hud_score_light_0
				pos_off = (0.0, 200.0)
				zoff = 5
			}
			{
				element_id = HUD2D_score_light_unlit_2
				element_parent = HUD2D_score_container
				texture = hud_score_light_0
				pos_off = (0.0, 170.0)
				zoff = 5
			}
			{
				element_id = HUD2D_score_light_unlit_3
				element_parent = HUD2D_score_container
				texture = hud_score_light_0
				pos_off = (0.0, 140.0)
				zoff = 5
			}
			{
				element_id = HUD2D_score_light_unlit_4
				element_parent = HUD2D_score_container
				texture = hud_score_light_0
				pos_off = (0.0, 110.0)
				zoff = 5
			}
			{
				element_id = HUD2D_score_light_unlit_5
				element_parent = HUD2D_score_container
				texture = hud_score_light_0
				pos_off = (0.0, 80.0)
				zoff = 5
			}
			{
				element_id = HUD2D_score_light_halflit_1
				element_parent = HUD2D_score_container
				texture = hud_score_light_1
				pos_off = (0.0, 200.0)
				zoff = 5.1
				alpha = 0
			}
			{
				element_id = HUD2D_score_light_halflit_2
				element_parent = HUD2D_score_container
				texture = hud_score_light_1
				pos_off = (0.0, 170.0)
				zoff = 5.1
				alpha = 0
			}
			{
				element_id = HUD2D_score_light_halflit_3
				element_parent = HUD2D_score_container
				texture = hud_score_light_1
				pos_off = (0.0, 140.0)
				zoff = 5.1
				alpha = 0
			}
			{
				element_id = HUD2D_score_light_halflit_4
				element_parent = HUD2D_score_container
				texture = hud_score_light_1
				pos_off = (0.0, 110.0)
				zoff = 5.1
				alpha = 0
			}
			{
				element_id = HUD2D_score_light_halflit_5
				element_parent = HUD2D_score_container
				texture = hud_score_light_1
				pos_off = (0.0, 80.0)
				zoff = 5.1
				alpha = 0
			}
			{
				element_id = HUD2D_score_light_allwaylit_1
				element_parent = HUD2D_score_container
				texture = hud_score_light_2
				pos_off = (0.0, 200.0)
				zoff = 5.2
				alpha = 0
			}
			{
				element_id = HUD2D_score_light_allwaylit_2
				element_parent = HUD2D_score_container
				texture = hud_score_light_2
				pos_off = (0.0, 170.0)
				zoff = 5.2
				alpha = 0
			}
			{
				element_id = HUD2D_score_light_allwaylit_3
				element_parent = HUD2D_score_container
				texture = hud_score_light_2
				pos_off = (0.0, 140.0)
				zoff = 5.2
				alpha = 0
			}
			{
				element_id = HUD2D_score_light_allwaylit_4
				element_parent = HUD2D_score_container
				texture = hud_score_light_2
				pos_off = (0.0, 110.0)
				zoff = 5.2
				alpha = 0
			}
			{
				element_id = HUD2D_score_light_allwaylit_5
				element_parent = HUD2D_score_container
				texture = hud_score_light_2
				pos_off = (0.0, 80.0)
				zoff = 5.2
				alpha = 0
			}
			{
				element_id = HUD2D_score_nixie_1a
				element_parent = HUD2D_score_container
				texture = hud_score_nixie_1a
				pos_off = (70.0, 90.0)
				zoff = 4
				alpha = 0
			}
			{
				element_id = HUD2D_score_nixie_2a
				element_parent = HUD2D_score_container
				texture = hud_score_nixie_2a
				pos_off = (70.0, 90.0)
				zoff = 4
				alpha = 0
			}
			{
				element_id = HUD2D_score_nixie_2b
				element_parent = HUD2D_score_container
				texture = hud_score_nixie_2b
				pos_off = (70.0, 90.0)
				zoff = 4
				alpha = 0
			}
			{
				element_id = HUD2D_score_nixie_3a
				element_parent = HUD2D_score_container
				texture = hud_score_nixie_3a
				pos_off = (70.0, 90.0)
				zoff = 4
				alpha = 0
			}
			{
				element_id = HUD2D_score_nixie_4a
				element_parent = HUD2D_score_container
				texture = hud_score_nixie_4a
				pos_off = (70.0, 90.0)
				zoff = 4
				alpha = 0
			}
			{
				element_id = HUD2D_score_nixie_4b
				element_parent = HUD2D_score_container
				texture = hud_score_nixie_4b
				pos_off = (70.0, 90.0)
				zoff = 4
				alpha = 0
			}
			{
				element_id = HUD2D_score_nixie_6b
				element_parent = HUD2D_score_container
				texture = hud_score_nixie_6b
				pos_off = (70.0, 90.0)
				zoff = 4
				alpha = 0
			}
			{
				element_id = HUD2D_score_nixie_8b
				element_parent = HUD2D_score_container
				texture = hud_score_nixie_8b
				pos_off = (70.0, 90.0)
				zoff = 4
				alpha = 0
			}
			{
				element_id = HUD2D_score_flash
				element_parent = HUD2D_score_container
				texture = hud_score_flash
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
endscript

