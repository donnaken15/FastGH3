current_crowd = 1.0
average_crowd = 1.0
total_crowd = 0.0
max_crowd = 0.0
crowd_scale = 2.0
health_scale = 2.0
last_hscale = -1.0
crowd_debug_mode = 0
viewercam_nofail = 0

FC_MODE = 0

script crowd_reset
	if ($game_mode = tutorial)
		return
	endif
	if GetNodeFlag \{LS_ENCORE_POST}
		Change \{current_crowd = 1.6666}
		Change \{average_crowd = 1.6666}
	else
		Change \{current_crowd = 1.0}
		Change \{average_crowd = 1.0}
	endif
	Change \{total_crowd = 0.0}
	Change \{max_crowd = 0.0}
	Change \{last_time_in_lead = 0.0}
	Change \{last_time_in_lead_player = -1}
	if (<Player> = 1)
		StopSoundEvent \{$#"0x3a716cc4"}
		if ($game_mode = training)
			BG_Crowd_Front_End_Silence \{immediate = 1}
		elseif ($end_credits = 1 ||
			GetNodeFlag LS_ENCORE_POST)
			printf \{channel = SFX "crowd_reset LS_ENCORE_POST"}
			Change_Crowd_Looping_SFX \{crowd_looping_state = good}
		else
			printf \{channel = SFX "NOT - crowd_reset LS_ENCORE_POST"}
			Change_Crowd_Looping_SFX \{crowd_looping_state = neutral}
		endif
	endif
	if GetNodeFlag \{LS_ENCORE_POST}
		if NOT ($game_mode = p2_battle)
			Change StructureName = <player_status> current_health = 1.6666
		else
			Change StructureName = <player_status> current_health = 1.0
		endif
	else
		Change StructureName = <player_status> current_health = 1.0
	endif
	if ($game_mode = p2_battle & $battle_sudden_death = 1)
		Change StructureName = <player_status> current_health = ($<player_status>.save_health)
	endif
	if ($FC_MODE = 1)
		if ($last_hscale = -1.0)
			Change last_hscale = ($health_scale)
		endif
		Change \{health_scale = 0.00000000000000001}
		Change StructureName = <player_status> current_health = 0.0000000000000000001
	else
		if NOT ($last_hscale = -1.0)
			Change health_scale = ($last_hscale)
			Change {last_hscale = -1.0}
		endif
	endif
	CrowdReset
endscript

script forcescore
	switch $debug_forcescore
		case poor
			health = ($health_poor_medium / 2)
		case medium
			health = (($health_poor_medium + $health_medium_good)/ 2)
		case good
			health = (($health_medium_good + $health_scale)/ 2)
		default
			health = ($health_poor_medium / 2)
	endswitch
	Change StructureName = <player_status> current_health = <health>
	Change current_crowd = <health>
endscript

script create_crowd_models
endscript

script update_crowd_model_cam
endscript

script destroy_crowd_models
endscript
set_crowd_hand = $EmptyScript
Crowd_SetHand = $EmptyScript
Crowd_StartLighters = $EmptyScript
crowd_monitor_performance = $EmptyScript
Crowd_StopLighters = $EmptyScript
Crowd_AllSetHand = $EmptyScript
Crowd_AllPlayAnim = $EmptyScript
Crowd_PlayAnim = $EmptyScript
Crowd_Create_Lighters = $EmptyScript
Crowd_ToggleLighters = $EmptyScript
Crowd_StageDiver_Hide = $EmptyScript
Crowd_StageDiver_Jump = $EmptyScript
