g_flash_red_going_p1 = 0
g_flash_red_going_p2 = 0
g_hud_2d_struct_used = career_hud_2d_elements

script create_2d_hud_elements\{player_text = 'p1'}
	Change \{g_flash_red_going_p1 = 0}
	Change \{g_flash_red_going_p2 = 0}
	Change \{old_animate_bulbs_star_power_p1 = 0.0}
	Change \{old_animate_bulbs_star_power_p2 = 0.0}
	if StructureContains structure=($g_hud_2d_struct_used) compressed
		ExtendCrc (($g_hud_2d_struct_used).compressed) '_load' out = decomp_scr
		if ScriptExists <decomp_scr>
			<decomp_scr>
		endif
	endif
	hud_struct = ($g_hud_2d_struct_used)
	GetArraySize (<hud_struct>.elements)
	parent_scale = (<hud_struct>.Scale)
	old_parent = <parent>
	parent_z = (<hud_struct>.z)
	i = 0
	begin
		just = [left top]
		myscale = 1.0
		zoff = 0.0
		rot = 0.0
		alpha = 1
		pos_off = (0.0, 0.0)
		blend = blend
		AddParams (<hud_struct>.elements[<i>])
		element_struct = (<hud_struct>.elements[<i>])
		if StructureContains structure = <element_struct> parent_container
			if StructureContains structure = <element_struct> element_parent
				ExtendCrc <element_parent> <player_text> out = container_parent
				if NOT ScreenElementExists id = <container_parent>
					ExtendCrc <element_parent> 'p1' out = container_parent
				endif
			else
				container_parent = <old_parent>
			endif
			container_pos = (0.0, 0.0)
			if StructureContains structure = <element_struct> pos_type
				<container_pos> = (<hud_struct>.<pos_type>)
				if (<player_text> = 'p2')
					ExtendCrc <pos_type> '_p2' out = new_pos_type
					<container_pos> = (<hud_struct>.<new_pos_type>)
				else
					if ($current_num_players = 2)
						ExtendCrc <pos_type> '_p1' out = new_pos_type
						<container_pos> = (<hud_struct>.<new_pos_type>)
					endif
				endif
			endif
			if StructureContains structure = <element_struct> note_streak_bar
				pos_name = offscreen_note_streak_bar_off
				if NOT StructureContains structure = <hud_struct> offscreen_note_streak_bar_off
					ExtendCrc <pos_name> ('_'+<player_text>) out = pos_name
				endif
				<container_pos> = (<container_pos> + (<hud_struct>.<pos_name>))
			endif
			<container_pos> = (<container_pos> + <pos_off>)
			ExtendCrc <element_id> <player_text> out = new_id
			<create_it> = 1
			if StructureContains structure = <element_struct> create_once
				ExtendCrc <element_id> 'p1' out = p1_id
				if ScreenElementExists id = <p1_id>
					<create_it> = 0
				endif
			endif
			if ((StructureContains structure = <element_struct> rot_p2)& (<player_text> = 'p2'))
				<rot> = <rot_p2>
			endif
			if (<create_it>)
				CreateScreenElement {
					Type = ContainerElement
					parent = <container_parent>
					id = <new_id>
					Pos = <container_pos>
					rot_angle = <rot>
					z_priority = <z_off>
				}
			endif
			parent = <new_id>
		endif
		if StructureContains structure = <element_struct> container
			if NOT StructureContains structure = <element_struct> parent_container
				ExtendCrc <element_id> <player_text> out = new_id
				ExtendCrc <element_parent> <player_text> out = myparent
				if StructureContains structure = <element_struct> small_bulb
					scaled_dims = (<element_dims> * (<hud_struct>.small_bulb_scale))
				else
					scaled_dims = (<element_dims> * (<hud_struct>.big_bulb_scale))
				endif
				if ((StructureContains structure = <element_struct> pos_off_p2)& (<player_text> = 'p2'))
					<pos_off> = <pos_off_p2>
				endif
				<create_it> = 1
				if StructureContains structure = <element_struct> create_once
					ExtendCrc <element_id> 'p1' out = p1_id
					if ScreenElementExists id = <p1_id>
						<create_it> = 0
					endif
				endif
				if (<create_it>)
					CreateScreenElement {
						Type = SpriteElement
						parent = <myparent>
						id = <new_id>
						texture = <texture>
						Pos = <pos_off>
						just = <just>
						rgba = [255 255 255 255]
						rot_angle = <rot>
						z_priority = <zoff>
						alpha = <alpha>
						dims = <scaled_dims>
					}
					<new_id> ::SetTags morph = 0
					<new_id> ::SetTags index = <i>
					<parent> = <id>
					<rot> = 0.0
					<Pos> = (0.0, 0.0)
					if StructureContains structure = <element_struct> initial_pos
						if ((StructureContains structure = <element_struct> initial_pos_p2)& (<player_text> = 'p2'))
							SetScreenElementProps id = <new_id> Pos = <initial_pos_p2>
							<new_id> ::SetTags final_pos = <pos_off_p2>
							<new_id> ::SetTags initial_pos = <initial_pos_p2>
							<new_id> ::SetTags morph = 1
						else
							SetScreenElementProps id = <new_id> Pos = <initial_pos>
							<new_id> ::SetTags final_pos = <pos_off>
							<new_id> ::SetTags initial_pos = <initial_pos>
							<new_id> ::SetTags morph = 1
						endif
					endif
				endif
			endif
		else
			if NOT StructureContains structure = <element_struct> parent_container
				ExtendCrc <element_id> <player_text> out = new_id
				if StructureContains structure = <element_struct> initial_pos
					<pos_off> = <initial_pos>
				endif
				if StructureContains structure = <element_struct> battle_pos
					if (<player_text> = 'p2')
						<container_pos> = (<hud_struct>.rock_pos_p2)
						ExtendCrc <pos_type> '_p2' out = new_pos_type
						<pos_off> = ((<hud_struct>.<new_pos_type>))
					else
						<container_pos> = (<hud_struct>.rock_pos_p1)
						ExtendCrc <pos_type> '_p1' out = new_pos_type
						<pos_off> = ((<hud_struct>.<new_pos_type>))
					endif
				endif
				ExtendCrc <element_parent> <player_text> out = myparent
				flags = {}
				if StructureContains structure = <element_struct> flags
					if StructureContains structure = (<element_struct>.flags)flip_v
						if StructureContains structure = (<element_struct>.flags)p1
							if (<player_text> = 'p1')
								<flags> = flip_v
							endif
						endif
					endif
					if StructureContains structure = (<element_struct>.flags)flip_h
						if StructureContains structure = (<element_struct>.flags)p1
							if (<player_text> = 'p1')
								<flags> = flip_h
							endif
						endif
						if StructureContains structure = (<element_struct>.flags)p2
							if (<player_text> = 'p2')
								<flags> = flip_h
							endif
						endif
					endif
				endif
				mydims = {}
				if StructureContains structure = <element_struct> dims
					<mydims> = <dims>
				endif
				<create_it> = 1
				if StructureContains structure = <element_struct> create_once
					ExtendCrc <element_id> 'p1' out = p1_id
					if ScreenElementExists id = <p1_id>
						<create_it> = 0
					endif
				endif
				if ((StructureContains structure = <element_struct> initial_pos_p2)& (<player_text> = 'p2'))
					<pos_off> = <initial_pos_p2>
				elseif ((StructureContains structure = <element_struct> pos_off_p2)& (<player_text> = 'p2'))
					<pos_off> = <pos_off_p2>
				endif
				my_rgba = [255 255 255 255]
				if StructureContains structure = <element_struct> rgba
					<my_rgba> = <rgba>
				endif
				if (<create_it>)
					CreateScreenElement {
						Type = SpriteElement
						parent = <myparent>
						id = <new_id>
						texture = <texture>
						Pos = <pos_off>
						rgba = <my_rgba>
						just = <just>
						z_priority = <zoff>
						alpha = <alpha>
						<flags>
						rot_angle = <rot>
						dims = <mydims>
						blend = <blend>
					}
				endif
				if StructureContains structure = <element_struct> Scale
					if (<create_it>)
						GetScreenElementDims id = <new_id>
						new_width = (<width> * <Scale>)
						new_height = (<height> * <Scale>)
						SetScreenElementProps id = <new_id> dims = (((1.0, 0.0) * <new_width>)+ ((0.0, 1.0) * <new_height>))
					endif
				endif
			endif
		endif
		if StructureContains structure = <element_struct> tube
			ExtendCrc <new_id> 'tube' out = new_child_id
			<zoff> = (<tube>.zoff)
			<alpha> = (<tube>.alpha)
			ExtendCrc <element_parent> <player_text> out = myparent
			if StructureContains structure = <element_struct> small_bulb
				scaled_dims = (<tube>.element_dims * (<hud_struct>.small_bulb_scale))
			else
				scaled_dims = (<tube>.element_dims * (<hud_struct>.big_bulb_scale))
			endif
			my_rgba = [255 255 255 255]
			if StructureContains structure = <element_struct> rgba
				<my_rgba> = <rgba>
			endif
			if ScreenElementExists id = <myparent>
				CreateScreenElement {
					Type = SpriteElement
					parent = <myparent>
					id = <new_child_id>
					texture = (<tube>.texture)
					Pos = (<pos_off> + (<tube>.pos_off))
					rgba = <my_rgba>
					blend = <blend>
					dims = <scaled_dims>
					just = [center bottom]
					z_priority = <zoff>
					alpha = <alpha>
				}
				<parent> = <id>
				<new_child_id> ::SetTags morph = 0
				<new_child_id> ::SetTags old_dims = <element_dims>
				if StructureContains structure = <element_struct> initial_pos
					SetScreenElementProps id = <new_child_id> Pos = (<initial_pos> + (<tube>.pos_off))
					<new_child_id> ::SetTags {
						final_pos = (<pos_off> + (<tube>.pos_off))
						initial_pos = (<initial_pos> + (<tube>.pos_off))
						morph = 1
					}
				endif
			endif
		endif
		if StructureContains structure = <element_struct> full
			ExtendCrc <new_id> 'full' out = new_child_id
			<zoff> = (<full>.zoff)
			<alpha> = (<full>.alpha)
			ExtendCrc <element_parent> <player_text> out = myparent
			if StructureContains structure = <element_struct> small_bulb
				scaled_dims = (<element_dims> * (<hud_struct>.small_bulb_scale))
			else
				scaled_dims = (<element_dims> * (<hud_struct>.big_bulb_scale))
			endif
			if ScreenElementExists id = <myparent>
				CreateScreenElement {
					Type = SpriteElement
					parent = <myparent>
					id = <new_child_id>
					texture = (<full>.texture)
					Pos = <pos_off>
					rgba = [255 255 255 255]
					dims = <scaled_dims>
					blend = <blend>
					just = <just>
					z_priority = <zoff>
					alpha = <alpha>
				}
				<new_child_id> ::SetTags morph = 0
				if StructureContains structure = <element_struct> initial_pos
					SetScreenElementProps id = <new_child_id> Pos = <initial_pos>
					<new_child_id> ::SetTags final_pos = <pos_off>
					<new_child_id> ::SetTags initial_pos = <initial_pos>
					<new_child_id> ::SetTags morph = 1
				endif
			endif
		endif
		<i> = (<i> + 1)
	repeat <array_Size>
	create_score_text <...>
endscript

script create_score_text
	if NOT ($game_mode = p2_battle || $boss_battle = 1)
		ExtendCrc HUD2D_Score_Text <player_text> out = new_id
		ExtendCrc HUD2D_score_container <player_text> out = new_score_container
		if StructureContains structure=<hud_struct> score_text_pos
			score_text_pos = (<hud_struct>.score_text_pos)
		else
			score_text_pos = (222.0, 70.0)
			if ($game_mode = p2_career || $game_mode = p2_coop)
				<score_text_pos> = (226.0, 85.0)
			endif
		endif
		// has to be a more efficient way to do this
		if StructureContains structure=<hud_struct> streak_text_pos
			streak_text_pos = (<hud_struct>.streak_text_pos)
		else
			streak_text_pos = (222.0, 78.0)
		endif
		if StructureContains structure=<hud_struct> streak_num_spacing
			streak_num_spacing = (<hud_struct>.streak_num_spacing)
		else
			streak_num_spacing = 37.0
		endif
		if StructureContains structure=<hud_struct> streak_num_color
			streak_num_color = (<hud_struct>.streak_num_color)
		else
			streak_num_color = [
				[230 230 230 200]
				[15 15 70 200]
			]
		endif
		if StructureContains structure=<hud_struct> score_text_spacing
			score_text_spacing = (<hud_struct>.score_text_spacing)
		else
			score_text_spacing = 5
		endif
		if StructureContains structure=<hud_struct> score_text_scale
			score_text_scale = (<hud_struct>.score_text_scale)
		else
			score_text_scale = 1.1
		endif
		if StructureContains structure=<hud_struct> score_text_rgba
			score_text_rgba = (<hud_struct>.score_text_rgba)
		else
			score_text_rgba = [255 255 255 255]
		endif
		if StructureContains structure=<hud_struct> score_z
			score_z = (<hud_struct>.score_z)
		else
			score_z = 7
			if ($game_mode = p2_career || $game_mode = p2_coop)
				score_z = 20
			endif
		endif
		if StructureContains structure=<hud_struct> score_rot
			score_rot = (<hud_struct>.score_rot)
		else
			score_rot = 0
		endif
		if ScreenElementExists id = <new_score_container>
			displayText {
				parent = <new_score_container>
				id = <new_id>
				font = num_a9
				Pos = <score_text_pos>
				z = <score_z>
				Scale = <score_text_scale>
				just = [right right]
				rgba = <score_text_rgba>
			}
			SetScreenElementProps id = <id> font_spacing = <score_text_spacing> rot_angle = <score_rot>
		endif
		i = 1
		begin
			FormatText checksumName = note_streak_text_id 'HUD2D_Note_Streak_Text_%d' d = <i>
			ExtendCrc <note_streak_text_id> <player_text> out = new_id
			ExtendCrc HUD2D_note_container <player_text> out = new_note_container
			if ScreenElementExists id = <new_note_container>
				rgba = (<streak_num_color>[(<i> = 1)])
				space = (<streak_text_pos> + (<i> * <streak_num_spacing> * (-1.0, 0.0)))
				displayText {
					parent = <new_note_container>
					id = <new_id>
					font = num_a7
					text = '0'
					Pos = <space>
					z = 25
					just = [center center]
					rgba = <rgba>
					noshadow
				}
				<id> ::SetTags intial_pos = <space>
			endif
			Increment \{i}
		repeat 4
	endif
endscript

script rock_meter_star_power_on
	SetSpawnInstanceLimits \{Max = $current_num_players management = ignore_spawn_request}
	if ($game_mode = p2_career)
		<player_status> = player1_status
	endif
	FormatText textname = player_text 'p%d' d = ($<player_status>.Player)
	spawnscriptnow rock_back_and_forth_star_meter params = {player_status = <player_status> player_text = <player_text>}
	FormatText checksumName = player_spawned_scriptid 'player_spawned_scriptid_p%d' d = ($<player_status>.Player)
	spawnscriptnow {
		pulsate_all_star_power_bulbs params = {Player = ($<player_status>.Player)player_status = <player_status> player_text = <player_text>}
		id = <player_spawned_scriptid>
	}
	i = 1
	begin
		FormatText checksumName = id 'HUD2D_rock_tube_%d' d = <i>
		ExtendCrc <id> <player_text> out = parent_id
		if ScreenElementExists id = <parent_id>
			<parent_id> ::GetTags
			if (<morph> = 1)
				DoScreenElementMorph id = <parent_id> Pos = <final_pos> time = 0.4
			endif
			ExtendCrc <parent_id> 'tube' out = child_id
			<child_id> ::GetTags
			SetScreenElementProps id = <child_id> texture = (($g_hud_2d_struct_used).elements[<index>].tube.star_texture)
			if (<morph> = 1)
				DoScreenElementMorph id = <child_id> Pos = <final_pos> time = 0.4
			endif
			ExtendCrc <parent_id> 'full' out = child_id
			<child_id> ::GetTags
			SetScreenElementProps id = <child_id> texture = (($g_hud_2d_struct_used).elements[<index>].full.star_texture)
			if (<morph> = 1)
				DoScreenElementMorph id = <child_id> Pos = <final_pos> time = 0.4
				wait \{0.2 seconds}
			endif
		endif
		<i> = (<i> + 1)
	repeat 6
endscript

script kill_pulsate_star_power_bulbs
	FormatText checksumName = player_spawned_scriptid 'player_spawned_scriptid_p%d' d = <Player>
	killspawnedscript id = <player_spawned_scriptid>
	KillPulsateStarPowerBulbs Player = <Player>
endscript

script pulsate_star_power_bulb
	begin
		alpha_time = Random (@ 0.1 @*2 0.5)
		if ScreenElementExists id = <bulb_checksum>
			ExtendCrc <bulb_checksum> 'tube' out = child_id
			DoScreenElementMorph id = <child_id> alpha = 0.3 time = <alpha_time> motion = ease_in
			ExtendCrc <bulb_checksum> 'full' out = child_id
			DoScreenElementMorph id = <child_id> alpha = 0.3 time = <alpha_time> motion = ease_in
		endif
		wait <alpha_time> seconds
		alpha_time = Random (@ 0.1 @*2 0.5)
		if ScreenElementExists id = <bulb_checksum>
			ExtendCrc <bulb_checksum> 'tube' out = child_id
			<child_id> ::GetTags
			DoScreenElementMorph id = <child_id> alpha = <old_alpha> time = <alpha_time> motion = ease_out
			ExtendCrc <bulb_checksum> 'full' out = child_id
			<child_id> ::GetTags
			DoScreenElementMorph id = <child_id> alpha = <old_alpha> time = <alpha_time> motion = ease_out
		endif
		wait <alpha_time> seconds
	repeat
endscript

script pulsate_big_glow
	ExtendCrc HUD2D_rock_glow <player_text> out = parent_id
	if NOT ScreenElementExists id = <parent_id>
		return
	endif
	begin
		if NOT ScreenElementExists id = <parent_id>
			return
		endif
		<parent_id> ::DoMorph alpha = 0 rgba = [95 205 255 255] time = 1 motion = ease_in
		if NOT ScreenElementExists id = <parent_id>
			return
		endif
		<parent_id> ::DoMorph alpha = 1 rgba = [255 255 255 255] time = 1 motion = ease_out
	repeat
endscript

script pulsate_all_star_power_bulbs
	<i> = 1
	begin
		FormatText checksumName = id 'HUD2D_rock_tube_%d' d = <i>
		ExtendCrc <id> <player_text> out = parent_id
		if ScreenElementExists id = <parent_id>
			FormatText checksumName = player_spawned_scriptid 'player_spawned_scriptid_p%d' d = <Player>
			spawnscriptnow {
				pulsate_star_power_bulb params = {bulb_checksum = <parent_id>}
				id = <player_spawned_scriptid>
			}
		endif
		<i> = (<i> + 1)
	repeat 6
	ExtendCrc HUD2D_rock_glow <player_text> out = parent_id
	if ScreenElementExists id = <parent_id>
		FormatText checksumName = player_spawned_scriptid 'player_spawned_scriptid_p%d' d = <Player>
		spawnscriptnow {
			pulsate_big_glow params = {<...> }
			id = <player_spawned_scriptid>
		}
	endif
endscript

script rock_back_and_forth_star_meter
	SetSpawnInstanceLimits \{Max = $current_num_players management = ignore_spawn_request}
	move_up_and_down = 1
	if ($game_mode = p1_career || $game_mode = p1_quickplay || $game_mode = p2_career || $game_mode = p2_coop)
		ExtendCrc HUD2D_rock_container <player_text> out = shake_container
	elseif ($game_mode = p2_faceoff || $game_mode = p2_pro_faceoff)
		ExtendCrc HUD2D_score_container <player_text> out = shake_container
		<move_up_and_down> = 0
	endif
	if ScreenElementExists id = <shake_container>
		GetScreenElementProps id = <shake_container>
		time_to_shake = 0.15
		if (<move_up_and_down> = 1)
			if ScreenElementExists id = <shake_container>
				DoScreenElementMorph id = <shake_container> Pos = (<Pos> - (0.0, 50.0))Scale = 1.5 rot_angle = 10 time = <time_to_shake> motion = ease_in
				wait <time_to_shake> seconds
			endif
			if ScreenElementExists id = <shake_container>
				DoScreenElementMorph id = <shake_container> Pos = (<Pos> + (0.0, 75.0))Scale = 0.5 rot_angle = -15 time = <time_to_shake> motion = ease_in
				wait <time_to_shake> seconds
			endif
			if ScreenElementExists id = <shake_container>
				DoScreenElementMorph id = <shake_container> Pos = (<Pos>)Scale = 1.0 rot_angle = 0 time = <time_to_shake>
			endif
		else
			if ScreenElementExists id = <shake_container>
				DoScreenElementMorph id = <shake_container> Pos = (<Pos> - (50.0, 0.0))Scale = 1.5 rot_angle = 10 time = <time_to_shake> motion = ease_in
				wait <time_to_shake> seconds
			endif
			if ScreenElementExists id = <shake_container>
				DoScreenElementMorph id = <shake_container> Pos = (<Pos> + (75.0, 0.0))Scale = 0.5 rot_angle = -15 time = <time_to_shake> motion = ease_in
				wait <time_to_shake> seconds
			endif
			if ScreenElementExists id = <shake_container>
				DoScreenElementMorph id = <shake_container> Pos = (<Pos>)Scale = 1.0 rot_angle = 0 time = <time_to_shake> motion = ease_out
			endif
		endif
	endif
endscript

script rock_meter_star_power_off\{player_text = 'p1'}
	if ($game_mode = p2_battle || $boss_battle = 1)
		return
	endif
	SetSpawnInstanceLimits \{Max = $current_num_players management = ignore_spawn_request}
	j = 6
	begin
		FormatText checksumName = id 'HUD2D_rock_tube_%d' d = <j>
		ExtendCrc <id> <player_text> out = parent_id
		if ScreenElementExists id = <parent_id>
			<parent_id> ::GetTags
			if (<morph> = 1)
				if ScreenElementExists id = <parent_id>
					DoScreenElementMorph id = <parent_id> Pos = (<final_pos> + <final_pos> * 0.1)time = 0.1
				endif
				wait \{0.1 seconds}
				if ScreenElementExists id = <parent_id>
					DoScreenElementMorph id = <parent_id> Pos = <initial_pos> time = 0.4
				endif
				wait \{0.1 seconds}
			endif
			ExtendCrc <parent_id> 'tube' out = child_id
			if ScreenElementExists id = <child_id>
				<child_id> ::GetTags
				SetScreenElementProps id = <child_id> texture = (($g_hud_2d_struct_used).elements [<index>].tube.texture)
				if (<morph>)
					SetScreenElementProps id = <child_id> Pos = <initial_pos>
				endif
			endif
			ExtendCrc <parent_id> 'full' out = child_id
			if ScreenElementExists id = <child_id>
				<child_id> ::GetTags
				SetScreenElementProps id = <child_id> texture = (($g_hud_2d_struct_used).elements [<index>].full.texture)
				if (<morph>)
					SetScreenElementProps id = <child_id> Pos = <initial_pos>
				endif
			endif
		endif
		<j> = (<j> -1)
	repeat 6
endscript

script hud_activated_star_power\{Player = 1 time = 0.2}
	spawnscriptnow hud_activated_star_power_spawned params = {<...> }
endscript

script hud_activated_star_power_spawned
	wait \{1 gameframe}
	if (<Player> = 1)
		player_text = 'p1'
	elseif (<Player> = 2)
		player_text = 'p2'
	else
		return
	endif
	spawnscriptnow kill_pulsate_star_power_bulbs params = {Player = <Player>}
	ExtendCrc HUD2D_score_flash <player_text> out = new_flash
	if ScreenElementExists id = <new_flash>
		DoScreenElementMorph id = <new_flash> alpha = 1 Scale = 5 time = <time>
		wait <time> seconds
		if ScreenElementExists id = <new_flash>
			DoScreenElementMorph id = <new_flash> alpha = 0 Scale = 1 time = (<time> / 2.0)
		endif
		UpdateNixie Player = <Player>
	endif
endscript

script hud_move_note_scorebar\{Player = 1 time = 0.5 in = 1}
	if ($game_mode = p2_battle || $boss_battle = 1 || $end_credits = 1 || $Cheat_PerformanceMode = 1)
		return
	endif
	if (($game_mode = p2_career || $game_mode = p2_coop)& (<Player> = 2))
		return
	endif
	if NOT StructureContains structure = ($g_hud_2d_struct_used) offscreen_note_streak_bar_off
		if NOT StructureContains structure = ($g_hud_2d_struct_used) offscreen_note_streak_bar_off_p1
			return
		endif
	endif
	morph_miss_off = (0.0, 60.0)
	ease_off = (0.0, 10.0)
	count_off = offscreen_note_streak_bar_off
	if (<Player> = 1)
		player_text = 'p1'
		if ($game_mode = p2_career || $game_mode = p2_coop)
			count_pos = counter_pos
		else
			if ($current_num_players = 2)
				count_pos = counter_pos_p1
				morph_miss_off = (60.0, 0.0)
				ease_off = (10.0, 0.0)
				count_off = offscreen_note_streak_bar_off_p1
			else
				count_pos = counter_pos
			endif
		endif
	elseif (<Player> = 2)
		player_text = 'p2'
		count_pos = counter_pos_p2
		morph_miss_off = (-60.0, 0.0)
		ease_off = (-10.0, 0.0)
		count_off = offscreen_note_streak_bar_off_p2
	else
		return
	endif
	if (<in> = 1)
		ExtendCrc HUD2D_note_container <player_text> out = new_container
		if ScreenElementExists id = <new_container>
			DoScreenElementMorph id = <new_container> Pos = ((($g_hud_2d_struct_used).<count_pos>)- <morph_miss_off>)time = <time> motion = ease_out
			wait <time> seconds
			if ScreenElementExists id = <new_container>
				DoScreenElementMorph id = <new_container> Pos = (($g_hud_2d_struct_used).<count_pos>)time = (<time> / 3)motion = ease_in
				<new_container> ::DoMorph Pos = {<ease_off> relative}time = 0.1 motion = ease_out
				<new_container> ::DoMorph Pos = {(<ease_off> * -1)relative}time = 0.1 motion = ease_in
			endif
		endif
	else
		ExtendCrc HUD2D_note_container <player_text> out = new_container
		if ScreenElementExists id = <new_container>
			if ($game_mode = p1_career || $game_mode = p2_career || $game_mode = p1_quickplay || $game_mode = p2_coop)
				DoScreenElementMorph id = <new_container> Pos = ((($g_hud_2d_struct_used).<count_pos>)- <morph_miss_off>)time = (<time> / 2.0)motion = ease_out
			else
				DoScreenElementMorph id = <new_container> Pos = ((($g_hud_2d_struct_used).<count_pos>)+ <morph_miss_off>)time = (<time> / 2.0)motion = ease_in
			endif
			wait <time> seconds
			if ScreenElementExists id = <new_container>
				DoScreenElementMorph id = <new_container> Pos = ((($g_hud_2d_struct_used).<count_pos>)+ (($g_hud_2d_struct_used).<count_off>))time = <time>
			endif
		endif
	endif
endscript
old_animate_bulbs_star_power_p1 = 0.0
old_animate_bulbs_star_power_p2 = 0.0

script hud_flash_red_bg_p1\{time = 0.2}
	if ($g_flash_red_going_p1 = 1)
		return
	else
		Change \{g_flash_red_going_p1 = 1}
	endif
	if ($game_mode = p2_career || $game_mode = p2_coop)
		ExtendCrc \{HUD2D_rock_lights_red 'p1' out = new_bg}
		<time> = 0.15
	else
		ExtendCrc \{HUD2D_rock_BG_red 'p1' out = new_bg}
	endif
	begin
		if ($game_mode = p2_career || $game_mode = p2_coop)
			if ScreenElementExists id = <new_bg>
				DoScreenElementMorph id = <new_bg> rgba = [0 0 0 255] time = <time>
				wait <time> seconds
			endif
			if ScreenElementExists id = <new_bg>
				DoScreenElementMorph id = <new_bg> rgba = [225 225 225 255] time = <time>
			endif
			wait <time> seconds
		else
			if ScreenElementExists id = <new_bg>
				DoScreenElementMorph id = <new_bg> rgba = [0 0 0 255] time = <time>
				wait <time> seconds
			endif
			if ScreenElementExists id = <new_bg>
				DoScreenElementMorph id = <new_bg> rgba = [225 225 225 255] time = <time>
				wait <time> seconds
			endif
			if ScreenElementExists id = <new_bg>
				DoScreenElementMorph id = <new_bg> rgba = [0 0 0 255] time = <time>
				wait <time> seconds
			endif
			if ScreenElementExists id = <new_bg>
				DoScreenElementMorph id = <new_bg> rgba = [225 225 225 255] time = <time>
			endif
			wait (<time> * 2.5)seconds
		endif
	repeat
endscript

script hud_flash_red_bg_p2\{time = 0.2}
	if ($g_flash_red_going_p2 = 1)
		return
	else
		Change \{g_flash_red_going_p2 = 1}
	endif
	ExtendCrc \{HUD2D_rock_BG_red 'p2' out = new_bg}
	begin
		if ScreenElementExists id = <new_bg>
			DoScreenElementMorph id = <new_bg> rgba = [0 0 0 255] time = <time>
			wait <time> seconds
		endif
		if ScreenElementExists id = <new_bg>
			DoScreenElementMorph id = <new_bg> rgba = [225 225 225 255] time = <time>
			wait <time> seconds
		endif
		if ScreenElementExists id = <new_bg>
			DoScreenElementMorph id = <new_bg> rgba = [0 0 0 255] time = <time>
			wait <time> seconds
		endif
		if ScreenElementExists id = <new_bg>
			DoScreenElementMorph id = <new_bg> rgba = [225 225 225 255] time = <time>
		endif
		wait (<time> * 2.5)seconds
	repeat
endscript

script hud_flash_red_bg_kill\{Player = 1}
	if (<Player> = 1)
		if ($g_flash_red_going_p1 = 0)
			return
		endif
		player_text = 'p1'
	elseif (<Player> = 2)
		if ($g_flash_red_going_p2 = 0)
			return
		endif
		player_text = 'p2'
	else
		return
	endif
	ExtendCrc HUD2D_rock_BG_red <player_text> out = new_bg
	if ScreenElementExists id = <new_bg>
		SetScreenElementProps id = <new_bg> rgba = [225 225 225 255]
		if (<Player> = 1)
			killspawnedscript \{name = hud_flash_red_bg_p1}
		else
			killspawnedscript \{name = hud_flash_red_bg_p2}
		endif
	endif
	if (<Player> = 1)
		Change \{g_flash_red_going_p1 = 0}
	else
		Change \{g_flash_red_going_p2 = 0}
	endif
endscript

script two_message_test
	spawnscriptnow \{hud_show_note_streak_combo params = {Player = 1}}
	spawnscriptnow \{show_star_power_ready params = {player_status = player1_status}}
	spawnscriptnow \{hud_show_note_streak_combo params = {Player = 2}}
	spawnscriptnow \{show_star_power_ready params = {player_status = player2_status}}
endscript

disable_notestreak_notif = 0
script hud_show_note_streak_combo\{Player = 1 combo = 0}
	if ($end_credits = 1 || $Cheat_PerformanceMode = 1 || $disable_notestreak_notif != 0)
		return
	endif
	if ($game_mode = p2_career || $game_mode = p2_coop)
		<Player> = 1
	endif
	begin
		if (<Player> = 1)
			if ($star_power_ready_on_p1 = 0)
				break
			endif
		else
			if ($star_power_ready_on_p2 = 0)
				break
			endif
		endif
		wait \{1 gameframe}
	repeat
	FormatText checksumName = player_container 'HUD_Note_Streak_Combo%d' d = <Player>
	if ScreenElementExists id = <player_container>
		return
	endif
	if (<Player> = 1)
		player_status = player1_status
	else
		player_status = player2_status
	endif
	ExtendCrc hud_destroygroup_window ($<player_status>.text)out = hud_destroygroup
	CreateScreenElement {
		Type = ContainerElement
		parent = <hud_destroygroup>
		id = <player_container>
	}
	base_scale = 0.8
	s = 0.8
	if (<Player> = 1)
		if isSinglePlayerGame
			Pos = (640.0, 211.0)
			<base_scale> = 1.0
			spawnscriptnow GH_SFX_Note_Streak_SinglePlayer params = {combo = <combo>}
		elseif ($game_mode = p2_career)
			Pos = (640.0, 170.0)
			<base_scale> = 1.0
			spawnscriptnow GH_SFX_Note_Streak_P1 params = {combo = <combo>}
		elseif ($is_network_game & $game_mode = p2_coop)
			Pos = (640.0, 170.0)
			<base_scale> = 1.0
			spawnscriptnow GH_SFX_Note_Streak_P1 params = {combo = <combo>}
		else
			<s> = 0.35
			Pos = (415.0, 170.0)
			spawnscriptnow GH_SFX_Note_Streak_P1 params = {combo = <combo>}
		endif
	else
		if ($game_mode = p2_career)
			Pos = (640.0, 170.0)
			<base_scale> = 1.0
			spawnscriptnow GH_SFX_Note_Streak_P2 params = {combo = <combo>}
		elseif ($is_network_game & $game_mode = p2_coop)
			Pos = (640.0, 170.0)
			<base_scale> = 1.0
			spawnscriptnow GH_SFX_Note_Streak_P2 params = {combo = <combo>}
		else
			<s> = 0.35
			Pos = (865.0, 170.0)
			spawnscriptnow GH_SFX_Note_Streak_P2 params = {combo = <combo>}
		endif
	endif
	FormatText textname = text "%d Note Streak!" d = <combo>
	FormatText checksumName = note_streak_alert 'note_streak_alert_%d' d = <Player>
	CreateScreenElement {
		Type = TextElement
		id = <note_streak_alert>
		parent = <player_container>
		font = text_a6
		text = <text>
		rgba = $hud_notif_streak1
		Pos = <Pos>
		Scale = (<base_scale> * 3)
		just = [center top]
		z_priority = 50
		alpha = 0
		Shadow
		shadow_offs = (2.0, 2.0)
		shadow_rgba = [0 0 0 255]
	}
	<id> ::DoMorph Scale = <base_scale> time = 0.2 alpha = 1 motion = ease_in
	if NOT ScreenElementExists id = <id>
		destroy_menu menu_id = <player_container>
		return
	endif
	spawnscriptnow hud_glowburst_alert params = {player_status = <player_status>}
	color0 = $hud_notif_streak2
	color1 = $hud_notif_streak3
	if ScreenElementExists id = <id>
		<id> ::DoMorph Scale = (<base_scale> + <s>)time = 0.4 rgba = <color1> rot_angle = 3 motion = ease_out
	endif
	if ScreenElementExists id = <id>
		<id> ::DoMorph Scale = <base_scale> time = 0.4 rgba = <color0> rot_angle = 2 motion = ease_in
	endif
	if ScreenElementExists id = <id>
		<id> ::DoMorph Scale = (<base_scale> + (<s> / 1.5))time = 0.3 rgba = <color1> rot_angle = -2 motion = ease_out
	endif
	if ScreenElementExists id = <id>
		<id> ::DoMorph Scale = <base_scale> time = 0.3 rgba = <color0> rot_angle = -1 motion = ease_in
	endif
	if ScreenElementExists id = <id>
		<id> ::DoMorph Scale = (<base_scale> + (<s> / 2.0))time = 0.2 rgba = <color1> rot_angle = 2 motion = ease_out
	endif
	if ScreenElementExists id = <id>
		<id> ::DoMorph Scale = <base_scale> time = 0.2 rgba = <color0> rot_angle = 1 motion = ease_in
	endif
	if ScreenElementExists id = <id>
		<id> ::DoMorph Scale = (<base_scale> + (<s> / 2.5))time = 0.1 rgba = <color1> rot_angle = -1 motion = ease_out
	endif
	if ScreenElementExists id = <id>
		<id> ::DoMorph Scale = <base_scale> time = 0.1 rgba = <color0> rot_angle = 1 motion = ease_in
	endif
	if ScreenElementExists id = <id>
		<id> ::DoMorph rot_angle = 0 Scale = <base_scale> motion = gentle
	endif
	if ScreenElementExists id = <id>
		<id> ::DoMorph Pos = (<Pos> - (0.0, 230.0))Scale = (<base_scale> * 0.8)time = 0.35 motion = ease_in
	endif
	destroy_menu menu_id = <player_container>
endscript

script hud_lightning_alert
	// OPTIMIZE, also missing frames compared to PS2
	if NOT ScreenElementExists id = <alert_id>
		return
	endif
	FormatText checksumName = HUD_lightning_01 'HUD_lightning_01_%d' d = <Player>
	FormatText checksumName = HUD_lightning_03 'HUD_lightning_03_%d' d = <Player>
	FormatText checksumName = HUD_lightning_05 'HUD_lightning_05_%d' d = <Player>
	FormatText checksumName = HUD_lightning_07 'HUD_lightning_07_%d' d = <Player>
	GetScreenElementProps id = <alert_id>
	lightning_pos = (<Pos> - (0.0, 20.0))
	lightning_dims = (800.0, 100.0)
	lightning_time = 0.2
	if ScreenElementExists id = <HUD_lightning_01>
		DestroyScreenElement id = <HUD_lightning_01>
	endif
	CreateScreenElement {
		Type = SpriteElement
		id = <HUD_lightning_01>
		texture = HUD_lightning_01
		parent = <player_container>
		Pos = <lightning_pos>
		dims = <lightning_dims>
		just = [center top]
		z_priority = 45
		alpha = 0
	}
	if ScreenElementExists id = <HUD_lightning_03>
		DestroyScreenElement id = <HUD_lightning_03>
	endif
	CreateScreenElement {
		Type = SpriteElement
		id = <HUD_lightning_03>
		texture = HUD_lightning_03
		parent = <player_container>
		Pos = <lightning_pos>
		dims = <lightning_dims>
		just = [center top]
		z_priority = 45
		alpha = 0
	}
	if ScreenElementExists id = <HUD_lightning_05>
		DestroyScreenElement id = <HUD_lightning_05>
	endif
	CreateScreenElement {
		Type = SpriteElement
		id = <HUD_lightning_05>
		texture = HUD_lightning_05
		parent = <player_container>
		Pos = <lightning_pos>
		dims = <lightning_dims>
		just = [center top]
		z_priority = 45
		alpha = 0
	}
	if ScreenElementExists id = <HUD_lightning_07>
		DestroyScreenElement id = <HUD_lightning_07>
	endif
	CreateScreenElement {
		Type = SpriteElement
		id = <HUD_lightning_07>
		texture = HUD_lightning_07
		parent = <player_container>
		Pos = <lightning_pos>
		dims = <lightning_dims>
		just = [center top]
		z_priority = 45
		alpha = 0
	}
	if ScreenElementExists id = <HUD_lightning_01>
		DoScreenElementMorph id = <HUD_lightning_01> alpha = 1 time = <lightning_time>
		wait <lightning_time> seconds
	endif
	if ScreenElementExists id = <HUD_lightning_01>
		DoScreenElementMorph id = <HUD_lightning_01> alpha = 0 time = <lightning_time>
		if ScreenElementExists id = <HUD_lightning_03>
			DoScreenElementMorph id = <HUD_lightning_03> alpha = 1 time = <lightning_time>
		endif
		wait <lightning_time> seconds
	endif
	if ScreenElementExists id = <HUD_lightning_03>
		DoScreenElementMorph id = <HUD_lightning_03> alpha = 0 time = <lightning_time>
		if ScreenElementExists id = <HUD_lightning_05>
			DoScreenElementMorph id = <HUD_lightning_05> alpha = 1 time = <lightning_time>
		endif
		wait <lightning_time> seconds
	endif
	if ScreenElementExists id = <HUD_lightning_05>
		DoScreenElementMorph id = <HUD_lightning_05> alpha = 0 time = <lightning_time>
		if ScreenElementExists id = <HUD_lightning_07>
			DoScreenElementMorph id = <HUD_lightning_07> alpha = 1 time = <lightning_time>
		endif
		wait <lightning_time> seconds
	endif
	if ScreenElementExists id = <HUD_lightning_07>
		DoScreenElementMorph id = <HUD_lightning_07> alpha = 0 time = <lightning_time>
		wait <lightning_time> seconds
	endif
	if ScreenElementExists id = <HUD_lightning_01>
		DestroyScreenElement id = <HUD_lightning_01>
	endif
	if ScreenElementExists id = <HUD_lightning_03>
		DestroyScreenElement id = <HUD_lightning_03>
	endif
	if ScreenElementExists id = <HUD_lightning_05>
		DestroyScreenElement id = <HUD_lightning_05>
	endif
	if ScreenElementExists id = <HUD_lightning_07>
		DestroyScreenElement id = <HUD_lightning_07>
	endif
endscript

disable_starpower_notif = 0
script hud_glowburst_alert\{player_status = player1_status}
	if NOT ($disable_starpower_notif = 0)
		return
	endif
	FormatText checksumName = star_power_ready_glow 'star_power_ready_glow_%d' d = ($<player_status>.Player)
	ExtendCrc hud_destroygroup_window ($<player_status>.text)out = hud_destroygroup
	if ScreenElementExists id = <star_power_ready_glow>
		DestroyScreenElement id = <star_power_ready_glow>
	endif
	if (($game_mode = p2_faceoff)|| ($game_mode = p2_pro_faceoff))
		offset = ((1.0, 0.0) * ($x_offset_p2))
		if (($<player_status>.Player)= 1)
			original_pos = (($hud_screen_elements [0].Pos) - (0.0, 37.0) - <offset>)
		else
			original_pos = (($hud_screen_elements [0].Pos) + (0.0, -37.0) + <offset>)
		endif
		base_scale = (7.5, 0.5)
		scale2 = (10.0, 2.5)
		scale3 = (7.5, 0.25)
		scale4 = (40.0, 0.0)
	else
		if ($game_mode = p2_career || $game_mode = p2_coop)
			original_pos = (($hud_screen_elements [0].Pos) - (0.0, 36.0))
		else
			original_pos = (($hud_screen_elements [0].Pos) + (0.0, 7.0))
		endif
		base_scale = (15.0, 1.0)
		scale2 = (20.0, 5.0)
		scale3 = (15.0, 0.5)
		scale4 = (80.0, 0.0)
	endif
	if ScreenElementExists id = <hud_destroygroup>
		CreateScreenElement {
			Type = SpriteElement
			id = <star_power_ready_glow>
			parent = <hud_destroygroup>
			texture = Char_Select_Hilite1
			just = [center center]
			Pos = <original_pos>
			rgba = [245 255 200 255]
			Scale = <base_scale>
			alpha = 1
			z_priority = 50
		}
	endif
	if ScreenElementExists id = <star_power_ready_glow>
		<star_power_ready_glow> ::DoMorph Scale = <scale2> alpha = 0.5 motion = ease_out time = 0.1
	endif
	if ScreenElementExists id = <star_power_ready_glow>
		<star_power_ready_glow> ::DoMorph Scale = <scale3> alpha = 0.5 rgba = [245 255 160 255] motion = ease_out time = 0.1
	endif
	if ScreenElementExists id = <star_power_ready_glow>
		<star_power_ready_glow> ::DoMorph Scale = <scale4> alpha = 0 motion = ease_in time = 0.8
	endif
	if ScreenElementExists id = <star_power_ready_glow>
		DestroyScreenElement id = <star_power_ready_glow>
	endif
endscript

script hud_flip_note_streak_num
	FormatText checksumName = id 'HUD2D_Note_Streak_Text_%dp%i' d = <dial_num> i = <Player>
	if NOT ScreenElementExists id = <id>
		return
	endif
	<id> ::GetTags
	GetScreenElementProps id = <id>
	basePos = <Pos>
	DoScreenElementMorph id = <id> Pos = (<basePos> + (0.0, 10.0))alpha = 0
	DoScreenElementMorph id = <id> Pos = <intial_pos> alpha = 1 time = 0.1
endscript

script create_game_backdrop2\{texture = gameplay_BG rgba = [255 255 255 255]}
	if ScreenElementExists \{id = #"0x6b9ddabb"}
		DestroyScreenElement \{id = #"0x6b9ddabb"}
	endif
	CreateScreenElement \{Type = ContainerElement parent = root_window id = #"0x6b9ddabb" Pos = (0.0, 0.0) just = [left top]}
	CreateScreenElement {
		Type = SpriteElement
		parent = #"0x6b9ddabb"
		id = menu_backdrop
		texture = <texture>
		rgba = <rgba>
		Pos = (640.0, 360.0)
		dims = (1280.0, 720.0)
		just = [center center]
		z_priority = -2147483648
	}
endscript

script destroy_game_backdrop2
	if ScreenElementExists \{id = #"0x6b9ddabb"}
		DestroyScreenElement \{id = #"0x6b9ddabb"}
	endif
endscript
gameplaybg_texture = none // DEPRECATED, REALIZED THE FAILURES OF THIS SYSTEM
gameplaybg_pos = (-100.0, -100.0)
gameplaybg_dims = (0.0, 0.0)
BGCol = [255 255 255 255]
Nofailvis = -20
Nofailvis2 = -21
