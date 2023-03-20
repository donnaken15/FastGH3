battle_explanation_color_white = [
	245
	220
	200
	255
]
battle_explanation_color_yellow = [
	237
	169
	0
	255
]
battle_explanation_bullet_materials = [
	sys_BattleGEM_Green01_sys_BattleGEM_Green01
	sys_BattleGEM_RED01_sys_BattleGEM_RED01
	sys_BattleGEM_Yellow01_sys_BattleGEM_Yellow01
	sys_BattleGEM_Blue01_sys_BattleGEM_Blue01
	sys_BattleGEM_Orange01_sys_BattleGEM_Orange01
]
battle_explanation_text = {
	fastgh3 = {
		image = #"0x767a45d7"
		title = "BOSS TIME!"
		bullets = [
			{
				text = "Instead of Star Power, you get BATTLE POWER"
			}
			{
				text = "Hit the BATTLE GEMS to get a POWER-UP"
			}
			{
				text = "Tilt your guitar upward to attack your opponent and make them miss"
			}
			{
				text = "You HAVE to make them FAIL before the end or else YOU LOSE"
			}
			{
				text = "Be careful, they can battle back"
			}
		]
		prompt = "Ready to Rock?"
	}
	Generic = {
		title = "BATTLE MODE!"
		bullets = [
			{
				text = "Instead of Star Power, you get BATTLE POWER"
			}
			{
				text = "Hit the BATTLE GEMS to get a POWER-UP"
			}
			{
				text = "Tilt your guitar upward to attack the other player and make them miss"
			}
			{
				text = "You HAVE to make your opponent FAIL before the end or else you go to SUDDEN DEATH"
			}
			{
				text = "In SUDDEN DEATH all the power-ups become the devastating DEATH DRAIN"
			}
		]
		prompt = "Ready to Rock?"
	}
}

script create_battle_helper_menu\{device_num = 0 popup = 0}
	if GameIsPaused
		UnPauseGame
	endif
	if GotParam \{boss}
		if ($game_mode = p2_battle)
			<boss_structure> = ($battle_explanation_text.Generic)
		else
			<boss_structure> = ($battle_explanation_text.<boss>)
		endif
	else
		GetGlobalTags \{Progression}
		<boss_structure> = ($battle_explanation_text.<boss_song>)
	endif
	menu_z = 10
	CreateScreenElement \{Type = ContainerElement parent = root_window id = battle_explanation_container}
	CreateScreenElement \{Type = SpriteElement parent = battle_explanation_container id = battle_explanation_screen Pos = (640.0, 360.0) texture = #"0x9c6ca60a" rgba = [223 223 223 255] just = [center center] dims = (1280.0, 720.0) z_priority = 0}
	CreateScreenElement \{parent = battle_explanation_container Type = VMenu id = bullet_spacer Pos = (545.0, 205.0) just = [left top] internal_just = [left top]}
	GetArraySize \{$#"0xb4f147fa"}
	<num_materials> = <array_Size>
	GetArraySize (<boss_structure>.bullets)
	<num_bullets> = <array_Size>
	<i> = 0
	begin
		CreateScreenElement \{parent = bullet_spacer Type = ContainerElement dims = (100.0, 100.0) just = [left top]}
		<container_id> = <id>
		CreateScreenElement {
			parent = <container_id>
			Type = TextBlockElement
			text = (<boss_structure>.bullets [<i>].text)
			local_id = text
			dims = (480.0, 0.0)
			Pos = (0.0, 0.0)
			allow_expansion
			rgba = $battle_explanation_color_white
			z_priority = 50
			line_spacing = 0.9
			font = #"0x35c0114b"
			just = [left top]
			internal_just = [left top]
			internal_scale = 0.625
			Shadow
			shadow_rgba = [0 0 0 255]
			shadow_offs = (3.0, 3.0)
			alpha = 0
		}
		GetScreenElementDims id = <id>
		<container_id> ::SetProps dims = ((1.0, 0.0) * <width> + (0.0, 1.0) * <height> + (0.0, 20.0))
		Mod a = <i> b = <num_materials>
		CreateScreenElement {
			Type = SpriteElement
			parent = <container_id>
			rgba = [255 255 255 255]
			just = [right top]
			z_priority = 40
			local_id = gem
			Pos = (12.0, 7.0)
			Scale = 0.5
			material = ($battle_explanation_bullet_materials [<Mod>])
			alpha = 0
			MaterialProps = [
				{
					name = m_startFade
					property = 1.0
				}
				{
					name = m_endFade
					property = 1.0
				}
				{
					name = m_playerIndex
					property = 1.0
				}
			]
		}
		RunScriptOnScreenElement id = <container_id> battle_fly_in_anim params = {idx = <i> container_id = <container_id>}
		<i> = (<i> + 1)
	repeat <num_bullets>
	if isps3
		Change \{gHighwayStartFade = 1.0}
		Change \{gHighwayEndFade = 1.0}
	endif
	if IsWinPort
		Change \{gHighwayStartFade = 1.0}
		Change \{gHighwayEndFade = 1.0}
	endif
	if StructureContains \{structure = boss_structure image}
		CreateScreenElement {
			Type = SpriteElement
			id = who_wants_to_battle_image
			parent = battle_explanation_container
			rgba = [255 255 255 255]
			Pos = (640.0, 360.0)
			dims = (1280.0, 720.0)
			texture = (<boss_structure>.image)
			just = [center center]
			z_priority = 5
			alpha = 1
		}
	endif
	<title_offset> = (-10.0, -20.0)
	displaySprite {
		parent = battle_explanation_container
		tex = #"0x549393a8"
		Pos = ((770.0, 165.0) + <title_offset>)
		dims = (384.0, 96.0)
		just = [center bottom]
		z = 50
	}
	<id> ::DoMorph alpha = 0.5
	displaySprite {
		parent = battle_explanation_container
		tex = #"0x549393a8"
		Pos = ((770.0, 145.0) + <title_offset>)
		just = [center top]
		dims = (384.0, 96.0)
		z = 50
		flip_h
	}
	<id> ::DoMorph alpha = 0.5
	CreateScreenElement {
		Type = TextElement
		parent = battle_explanation_container
		id = who_wants_to_battle_text
		text = (<boss_structure>.title)
		font = #"0xba959ce0"
		Scale = 1
		Pos = ((770.0, 120.0) + <title_offset>)
		rgba = [237 169 0 255]
		just = [center top]
		z_priority = 51
		font_spacing = 5
		Shadow
		shadow_rgba = [0 0 0 255]
		shadow_offs = (3.0, 3.0)
		event_handlers = [
			{pad_choose battle_helper_continue params = {device_num = <device_num>}}
			{pad_back battle_helper_back}
		]
		exclusive_device = ($primary_controller)
	}
	displayText {
		parent = bullet_spacer
		text = (<boss_structure>.prompt)
		font = #"0x35c0114b"
		Scale = 0.7
		Pos = (575.0, 580.0)
		rgba = [237 169 0 255]
		just = [left top]
		z = 50
	}
	RunScriptOnScreenElement id = <id> wait_and_show_ready
	LaunchEvent \{Type = focus target = who_wants_to_battle_text}
	Change \{user_control_pill_text_color = [0 0 0 255]}
	Change \{user_control_pill_color = [180 180 180 255]}
	add_user_control_helper \{text = "BATTLE" button = green z = 100}
	add_user_control_helper \{text = "DECLINE" button = red z = 100}
endscript

script battle_helper_continue
	ui_flow_manager_respond_to_action action = continue device_num = <device_num>
endscript

script battle_helper_back
	if ($game_mode = p1_career)
		WriteAchievements \{achievement = WUSS_OUT}
	endif
	ui_flow_manager_respond_to_action \{action = go_back}
endscript

script destroy_battle_helper_menu
	clean_up_user_control_helpers
	destroy_menu \{menu_id = battle_explanation_container}
endscript

script battle_fly_in_anim
	ResolveScreenElementID id = {<container_id> child = text}
	<text_id> = <resolved_id>
	ResolveScreenElementID id = {<container_id> child = gem}
	<gem_id> = <resolved_id>
	wait \{0.15 seconds}
	wait (<idx> * 0.4)seconds
	<gem_id> ::GetProps
	<gem_final_pos> = <Pos>
	SoundEvent \{event = GH3_Star_FlyIn}
	<gem_id> ::DoMorph Pos = (<gem_final_pos> + (-600.0, 0.0))alpha = 1
	<gem_id> ::DoMorph Pos = <gem_final_pos> time = 0.35 motion = ease_in
	<text_id> ::DoMorph time = 0.2 motion = ease_in rgba = [255 255 255 255] alpha = 1
	<text_id> ::DoMorph time = 0.1 motion = ease_out rgba = $battle_explanation_color_white
endscript

script wait_and_show_ready
	DoMorph \{alpha = 0}
	wait \{2.8 seconds}
	DoMorph \{time = 0.2 motion = ease_in rgba = [255 255 255 255] alpha = 1}
	DoMorph \{time = 0.1 motion = ease_in rgba = $#"0x7d84dbc4"}
endscript
