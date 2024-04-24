

battle_hud_2d_elements = {
	compressed = battle_hud_2d_elements
	Scale = 0.75
	z = 0
}
script battle_hud_2d_elements_load
	change battle_hud_2d_elements = {
		offscreen_rock_pos_p1 = (-220.0, 100.0)
		offscreen_rock_pos_p2 = (1680.0, 100.0)
		rock_pos_p1 = (280.0, 100.0)
		card_1_off_p1 = (26.0, 114.0)
		card_2_off_p1 = (-44.0, 11.0)
		card_3_off_p1 = (-53.0, 37.0)
		card_default_2_p1 = (72.0, 196.0)
		card_default_3_p1 = (60.0, 234.0)
		rock_pos_p2 = (1180.0, 100.0)
		card_1_off_p2 = (-200.0, 114.0)
		card_2_off_p2 = (44.0, 11.0)
		card_3_off_p2 = (53.0, 37.0)
		card_default_2_p2 = (184.0, 196.0)
		card_default_3_p2 = (200.0, 234.0)
		Scale = 0.75
		z = 0
		buttons_p2_offset = (510.0, 0.0)
		string_offset = (100.0, 0.0)
		green_button_pos = (185.0, 620.0)
		lefty_green_button_pos = (585.0, 620.0)
		attack_ready_text_pos_p1 = (347.0, 224.0)
		attack_ready_text_pos_p2 = (941.0, 224.0)
		whammy_bottom_bar_pos_p1 = (640.0, 643.0)
		whammy_bottom_bar_pos_p2 = (635.0, 643.0)
		offscreen_gamertag_pos = (0.0, -400.0)
		final_gamertag_pos = (0.0, 0.0)
		#"0x936bb5fe" = $gameplaybg_pos
		#"0x53c9001c" = (0.0, 0.0)
		elements = [
			{
				parent_container
				element_id = #"0xa90fc148"
				pos_type = #"0x936bb5fe"
			}
			{
				element_id = #"0x99dd87cc"
				element_parent = #"0xa90fc148"
				texture = $gameplaybg_texture
				dims = $gameplaybg_dims
				rot = -0.1
				rgba = $BGCol
				zoff = -2147483648
			}
			{
				parent_container
				element_id = HUD2D_rock_container
				pos_type = offscreen_rock_pos
			}
			{
				element_id = HUD2D_rock_body
				element_parent = HUD2D_rock_container
				texture = hud_2p_battle_frame
				pos_off = (0.0, 10.0)
				zoff = 20
				flags = {
					p1
					flip_v
				}
			}
			{
				element_id = HUD2D_rock_BG_green
				element_parent = HUD2D_rock_container
				texture = hud_rock_bg_green
				pos_off = (0.0, 0.0)
				zoff = 16
			}
			{
				element_id = HUD2D_rock_BG_red
				element_parent = HUD2D_rock_container
				texture = hud_rock_bg_red
				zoff = 14
			}
			{
				element_id = HUD2D_rock_BG_yellow
				element_parent = HUD2D_rock_container
				texture = hud_rock_bg_yellow
				zoff = 15
			}
			{
				element_id = HUD2D_rock_lights_all
				element_parent = HUD2D_rock_container
				texture = hud_rock_lights_all
				zoff = 17
			}
			{
				element_id = HUD2D_rock_lights_green
				element_parent = HUD2D_rock_container
				texture = hud_rock_lights_green
				pos_off = (128.0, 0.0)
				zoff = 18
				just = [ left top ]
				alpha = 0
			}
			{
				element_id = HUD2D_rock_lights_red
				element_parent = HUD2D_rock_container
				texture = hud_rock_lights_red
				pos_off = (128.0, 0.0)
				zoff = 18
				just = [ right top ]
				alpha = 0
			}
			{
				element_id = HUD2D_rock_lights_yellow
				element_parent = HUD2D_rock_container
				texture = hud_rock_lights_yellow
				pos_off = (128.0, 0.0)
				zoff = 18
				just = [ center top ]
				alpha = 0
			}
			{
				element_id = HUD2D_rock_needle
				element_parent = HUD2D_rock_container
				texture = hud_rock_needle
				pos_off = (132.0, 165.0)
				zoff = 18.5
				just = [
					0.5
					0.8
				]
			}
			{
				element_id = HUD2D_battle_default_icon2_1
				element_parent = HUD2D_rock_container
				texture = icon_attack_default2
				zoff = 18.8999996
				pos_off = (90.0, 150.0)
				dims = (74.0, 74.0)
			}
			{
				element_id = HUD2D_battle_default_icon2_2
				element_parent = HUD2D_rock_container
				texture = icon_attack_default2
				zoff = 18.8999996
				battle_pos
				pos_type = card_default_2
				dims = (48.0, 48.0)
				just = [
					center
					center
				]
			}
			{
				element_id = HUD2D_battle_default_icon2_3
				element_parent = HUD2D_rock_container
				texture = icon_attack_default2
				zoff = 18.8999996
				battle_pos
				pos_type = card_default_3
				dims = (28.0, 28.0)
				just = [
					center
					center
				]
			}
		]
	}
endscript
