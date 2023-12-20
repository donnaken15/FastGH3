
script stars
	begin
		printf \{channel = SFX '*******************************************************'}
	repeat 5
endscript
InteriorPanningRadius = 10
Global_User_SFX_Number = 10
Guitar_Always_Volume_100 = 0
Star_power_verb_is_on = 0
sfx_adjusted_guitar_volume = 100
highpass_cutoff_freq_modulated = 2000
lowpass_cutoff_freq_modulated = 1000
phaser_delay_time_modulated = 10
auto_wah_is_on = 0
wah_cutoff_freq_modulated = 900
current_audio_effect_type = HighPass
guitar_audio_effects_are_on = 0
guitar_audio_effects_are_on_p1 = 0
guitar_audio_effects_are_on_p2 = 0
Debug_Audible_Downbeat = 0
Debug_Audible_Open = 0
Debug_Audible_Close = 0
Debug_Audible_HitNote = 0
CrowdListenerStateClapOn1234 = 0
CrowdLevelForSurges = 1.66
temp_language_hack = lang_english
StreamPriorityLow = 10
StreamPriorityLowMid = 30
StreamPriorityMid = 50
StreamPriorityMidHigh = 70
StreamPriorityHigh = 90
StreamPriorityHighest = 95
StreamPrioritySystem = 109
Global_SoundEvent_Default_Priority = 50
Global_SoundEvent_Default_Buss = Default
Global_SoundEvent_NoRepeatFor = 0.1
Global_SoundEvent_InstanceManagement = stop_furthest
Global_SoundEvent_InstanceLimit = 1
GuitarVolumeFullStereoLevel = 100
GuitarVolumePartialStereoLevel = 85
GuitarVolumeRamptimeUp = 0.0
GuitarVolumeRamptimeDown = 0.02
Player1Pan = {
	panLCR1 = -100
	panLCR2 = -100
}
Player2Pan = {
	panLCR1 = 100
	panLCR2 = 100
}

script SoundEvent
	SoundEventFast <...>
endscript

script RegisterSoundEvent
	AddSoundEventScript SoundEvent_EventID = <SoundEvent_EventID>
	OnExitRun DeRegisterSoundEvent params = {SoundEvent_EventID = <SoundEvent_EventID>}
	<event> <...>
endscript

script DeRegisterSoundEvent
	RemoveSoundEventScript SoundEvent_EventID = <SoundEvent_EventID>
endscript

script Master_SFX_Adding_Sound_Busses
	CreateBussSystem \{$BussTree}
	SetSoundBussParams \{$Default_BussSet}
	SetSoundBussParams \{$Default_BussSet time = 0.5}
	SoundBussLock \{Master}
	SoundBussLock \{User_Guitar}
	SoundBussLock \{User_Band}
	SoundBussLock \{User_Sfx}
	SoundBussLock \{User_Music}
	SoundBussLock \{Crowd_Beds}
	SoundBussLock \{Crowd_Singalong}
	SoundBussLock \{Band_Balance}
	SoundBussLock \{Guitar_Balance}
	SoundBussLock \{Music_Setlist}
	createsoundbusseffects \{Guitar_Balance = {effect = $Echo_Guitar_Buss_Dry effect2 = $Reverb_Guitar_Buss_Dry}}
	createsoundbusseffects \{Crowd_W_Reverb = {effect = $Echo_Crowd_Buss effect2 = $Reverb_Crowd_Buss}}
endscript

script GH3_Change_crowd_reverb_settings_by_Venue
endscript

script PrintPushPopDebugInfo
	if NOT GotParam \{push}
		if NOT GotParam \{pop}
			printf \{'Did not specify push or pop!'}
			return
		endif
	endif
	if GotParam \{push}
		pushPop = 'push'
	else
		pushPop = 'pop'
	endif
	if NOT GotParam \{name}
		printf \{'Did not specify script name!'}
		return
	endif
	printf "%c %a %b" a = <name> b = <pushPop> c = '=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-='
endscript

script Generic_Reverb_Functionality_Script\{NewEchoSettings = $Echo_Generic_Outside_Slap EchoFadeTime = 0.5 NewReverbSettings = $Reverb_Generic_Outside_Verb ReverbFadeTime = 0.5}
	if inside
		if GotParam \{NewEchoSettings}
			if GotParam \{EchoFadeTime}
				setsoundbusseffects effect = <NewEchoSettings> time = <EchoFadeTime>
			else
				setsoundbusseffects effect = <NewEchoSettings>
			endif
		endif
		if GotParam \{NewReverbSettings}
			if GotParam \{ReverbFadeTime}
				setsoundbusseffects effect = <NewReverbSettings> time = <ReverbFadeTime>
			else
				setsoundbusseffects effect = <NewReverbSettings>
			endif
		endif
	else
		if GotParam \{Destroyed}
		else
			if GotParam \{Created}
			else
				if GotParam \{ExitEchoSettings}
					if GotParam \{ExitEchoFadeTime}
						setsoundbusseffects effect = <ExitEchoSettings> time = <ExitEchoFadeTime>
					else
						setsoundbusseffects effect = <ExitEchoSettings>
					endif
				endif
				if GotParam \{ExitReverbSettings}
					if GotParam \{ExitReverbFadeTime}
						setsoundbusseffects effect = <ExitReverbSettings> time = <ExitReverbFadeTime>
					else
						setsoundbusseffects effect = <ExitReverbSettings>
					endif
				endif
			endif
		endif
	endif
endscript

script GH_Guitar_Battle_DSP_Effects_Player1
	switch <attack_effect>
		case double_note_flange
			printf \{channel = SFX 'setting to doublenote flange'}
			setsoundbusseffects \{effect = $Flange_DoubleNotes1}
			printf \{channel = SFX 'changing p1 balance buss'}
			SetSoundBussParams \{Guitar_Balance_First_Player = {vol = 2}}
		case overload_highpass
			printf \{channel = SFX 'setting to overload highpass'}
			setsoundbusseffects \{effect = $HighPass_Thin1}
			printf \{channel = SFX 'changing p1 balance buss'}
			SetSoundBussParams \{Guitar_Balance_First_Player = {vol = 3}}
		case brokenstring_chorus
			printf \{channel = SFX 'setting to broken string chorus'}
			setsoundbusseffects \{effect = $Chorus_Generic1}
			printf \{channel = SFX 'changing p1 balance buss'}
			SetSoundBussParams \{Guitar_Balance_First_Player = {vol = 0}}
		case lefty_eq
			printf \{channel = SFX 'setting to lefty eq'}
			setsoundbusseffects \{effect = $LowPass_Muffled1}
			printf \{channel = SFX 'changing p1 balance buss'}
			SetSoundBussParams \{Guitar_Balance_First_Player = {vol = 6}}
		case diffup_eq
			printf \{channel = SFX 'setting to diffup eq'}
			setsoundbusseffects \{effect = $EQ_Wah1}
			printf \{channel = SFX 'changing p1 balance buss'}
			SetSoundBussParams \{Guitar_Balance_First_Player = {vol = -6}}
		default
			printf \{channel = SFX 'default'}
	endswitch
endscript

script GH_Guitar_Battle_DSP_Effects_Player2
	switch <attack_effect>
		case double_note_flange
			printf \{channel = SFX 'setting to doublenote flange'}
			setsoundbusseffects \{effect = $Flange_DoubleNotes2}
			printf \{channel = SFX 'changing p2 balance buss'}
			SetSoundBussParams \{Guitar_Balance_Second_Player = {vol = 2}}
		case overload_highpass
			printf \{channel = SFX 'setting to overload highpass'}
			setsoundbusseffects \{effect = $HighPass_Thin2}
			printf \{channel = SFX 'changing p2 balance buss'}
			SetSoundBussParams \{Guitar_Balance_Second_Player = {vol = 3}}
		case brokenstring_chorus
			printf \{channel = SFX 'setting to broken string chorus'}
			setsoundbusseffects \{effect = $Chorus_Generic2}
			printf \{channel = SFX 'changing p2 balance buss'}
			SetSoundBussParams \{Guitar_Balance_Second_Player = {vol = 0}}
		case lefty_eq
			printf \{channel = SFX 'setting to lefty eq'}
			setsoundbusseffects \{effect = $LowPass_Muffled2}
			printf \{channel = SFX 'changing p2 balance buss'}
			SetSoundBussParams \{Guitar_Balance_Second_Player = {vol = 6}}
		case diffup_eq
			printf \{channel = SFX 'setting to diffup eq'}
			setsoundbusseffects \{effect = $EQ_Wah2}
			printf \{channel = SFX 'changing p2 balance buss'}
			SetSoundBussParams \{Guitar_Balance_Second_Player = {vol = -6}}
		default
			printf \{channel = SFX 'default'}
	endswitch
endscript

script GH3_Change_Guitar_Audio_Effects_Guitar_Single_Player\{}
endscript

script GH3_Guitar_Effects_Wait
endscript

script GH3_Battle_Attack_Finished_SFX
	if (<Player> = 1)
		SoundEvent \{event = GH_SFX_BattleMode_Attack_Over_P1}
	else
		SoundEvent \{event = GH_SFX_BattleMode_Attack_Over_P2}
	endif
endscript

script Reset_Battle_DSP_Effects
	if (<Player> = 1)
		Reset_Battle_DSP_Effects_Player1
	else
		Reset_Battle_DSP_Effects_Player2
	endif
endscript

script Reset_Battle_DSP_Effects_Player1
	setsoundbusseffects \{effect = $LowPass_Default1 time = 0.15}
	setsoundbusseffects \{effect = $HighPass_Default1 time = 0.15}
	setsoundbusseffects \{effect = $Flange_Default1 time = 0.15}
	setsoundbusseffects \{effect = $Chorus_Default1 time = 0.15}
	setsoundbusseffects \{effect = $EQ_Default1 time = 0.15}
	printf \{channel = SFX 'RESTTING p1 balance buss'}
	SetSoundBussParams \{Guitar_Balance_First_Player = {vol = 0}}
endscript

script Reset_Battle_DSP_Effects_Player2
	setsoundbusseffects \{effect = $LowPass_Default2 time = 0.15}
	setsoundbusseffects \{effect = $HighPass_Default2 time = 0.15}
	setsoundbusseffects \{effect = $Flange_Default2 time = 0.15}
	setsoundbusseffects \{effect = $Chorus_Default2 time = 0.15}
	setsoundbusseffects \{effect = $EQ_Default2 time = 0.15}
	printf \{channel = SFX 'RESTTING p2 balance buss'}
	SetSoundBussParams \{Guitar_Balance_Second_Player = {vol = 0}}
endscript

script Check_And_Reset_Effects
endscript

script cleanup_spawned_scripts_for_effects
endscript

script turn_off_current_audio_effect
endscript

script Profiling_FMOD_EFFECTS
endscript

script GH_Star_Power_Verb_On
	if ($Star_power_verb_is_on = 1)
		return
	endif
	Change \{Star_power_verb_is_on = 1}
	SoundEvent \{event = Star_Power_Deployed_SFX}
	if ($game_mode != tutorial)
		SoundEvent \{event = Star_Power_Deployed_Cheer_SFX}
	endif
	PushSoundBussParams
	SetSoundBussParams \{$Star_Power_BussSet time = 0.5}
	get_song_tempo_cfunc
	if (<beat_duration> > 400)
		beat_duration = (<beat_duration> / 2)
	endif
	if (<beat_duration> > 400)
		beat_duration = (<beat_duration> / 2)
	endif
	if (<beat_duration> > 400)
		beat_duration = (<beat_duration> / 2)
	endif
	if (<beat_duration> > 400)
		beat_duration = 400
	endif
	setsoundbusseffects effect = {effect = echo name = GuitarEcho1 Delay = <beat_duration>}
	setsoundbusseffects \{effect = {effect = echo name = GuitarEcho1 Drymix = 1.0 Wetmix = 0.5}time = 0.1}
	setsoundbusseffects \{effect = {effect = sfxreverb name = GuitarReverb1 ReflectionsLevel = -1200.0 ReverbLevel = -550.0}time = 0.1}
endscript

script GH_Star_Power_Verb_Off
	if ($Star_power_verb_is_on = 1)
		PopSoundBussParams
	endif
	setsoundbusseffects \{effect = {effect = echo name = GuitarEcho1 Wetmix = 0.0}time = 0.1}
	setsoundbusseffects \{effect = {effect = sfxreverb name = GuitarReverb1 ReflectionsLevel = -10000.0 ReverbLevel = -10000.0}time = 0.5}
	Change \{Star_power_verb_is_on = 0}
endscript

script GH3_Set_Guitar_Verb_And_Echo_to_Dry
	setsoundbusseffects \{effect = $Echo_Guitar_Buss_Dry}
	setsoundbusseffects \{effect = $Reverb_Guitar_Buss_Dry}
endscript

script GH_SFX_Overloaded_Static_Player1
endscript

script GH_SFX_wait_then_kill_Overloaded_Static_Player1
endscript

script GH_SFX_Overloaded_Static_Player2
endscript

script GH_SFX_wait_then_kill_Overloaded_Static_Player2
endscript

script GH_BattleMode_Modulate_HPF_Cutoff
endscript

script gh_battlemode_modulate_HPF_value
endscript

script GH_BattleMode_Modulate_LPF_Cutoff
endscript

script gh_battlemode_modulate_LPF_value
endscript

script GH_BattleMode_Modulate_Phaser_Delay
endscript

script gh_modulate_Phaser_Delay_Value
endscript

script gh_battlemode_modulate_Wah_value
endscript

script GH_BattleMode_Player1_SFX_DiffUp_Start
	SoundEvent \{event = GH_SFX_BattleMode_DiffUp_P1}
endscript

script GH_BattleMode_Player2_SFX_DiffUp_Start
	SoundEvent \{event = GH_SFX_BattleMode_DiffUp_P2}
endscript

script GH_BattleMode_Player1_SFX_DoubleNotes_Start
	SoundEvent \{event = GH_SFX_BattleMode_DoubleNote_P1}
endscript

script GH_BattleMode_Player2_SFX_DoubleNotes_Start
	SoundEvent \{event = GH_SFX_BattleMode_DoubleNote_P2}
endscript

script GH_BattleMode_Player1_SFX_Shake_Start
	SoundEvent \{event = GH_SFX_BattleMode_Lightning_Player1}
endscript

script GH_BattleMode_Player2_SFX_Shake_Start
	SoundEvent \{event = GH_SFX_BattleMode_Lightning_Player2}
endscript

script GH_BattleMode_Player1_SFX_LeftyNotes_Start
	SoundEvent \{event = GH_SFX_BattleMode_Lefty_P1}
endscript

script GH_BattleMode_Player2_SFX_LeftyNotes_Start
	SoundEvent \{event = GH_SFX_BattleMode_Lefty_P2}
endscript

script GH_BattleMode_Player1_SFX_BrokenString_Start
	SoundEvent \{event = GH_SFX_BattleMode_StringBreak_P1}
endscript

script GH_BattleMode_Player2_SFX_BrokenString_Start
	SoundEvent \{event = GH_SFX_BattleMode_StringBreak_P2}
endscript

script GH_BattleMode_Player1_SFX_Steal
	SoundEvent \{event = GH_SFX_BattleMode_Steal_P1}
endscript

script GH_BattleMode_Player2_SFX_Steal
	SoundEvent \{event = GH_SFX_BattleMode_Steal_P2}
endscript

script GH_BattleMode_Player1_SFX_Whammy_Start
	SoundEvent \{event = GH_SFX_BattleMode_WhammyAttack_P1}
endscript

script GH_BattleMode_Player2_SFX_Whammy_Start
	SoundEvent \{event = GH_SFX_BattleMode_WhammyAttack_P2}
endscript

script GH_BattleMode_Player1_SFX_Death_Drain
	SoundEvent \{event = GH_SFX_BattleMode_Death_Drain_P1}
endscript

script GH_BattleMode_Player2_SFX_Death_Drain
	SoundEvent \{event = GH_SFX_BattleMode_Death_Drain_P2}
endscript

script GH_BattleMode_Start_Heartbeat_P1
	SoundEvent \{event = Battlemode_HeartBeat_P1}
endscript

script GH_BattleMode_Stop_Heartbeat_P1
	StopSoundEvent \{Battlemode_HeartBeat_P1}
endscript

script GH_BattleMode_Start_Heartbeat_P2
	SoundEvent \{event = Battlemode_HeartBeat_P2}
endscript

script GH_BattleMode_Stop_Heartbeat_P2
	StopSoundEvent \{Battlemode_HeartBeat_P2}
endscript

script GH_BattleMode_SFX_Sudden_Death
	SoundEvent \{event = GH_SFX_BattleMode_Sudden_Death}
endscript

script GH3_Battle_Play_Crowd_Reaction_SFX
endscript

script Battle_Attack_Cheer_Based_On_Venue_P1
endscript

script Battle_Attack_Cheer_Based_On_Venue_P2
endscript

script GH3_Battle_Play_Whammy_Pitch_Up_Sound
	num_strums = ($<other_player_status>.whammy_attack)
	player_pan = ($<other_player_status>.Player)
	if (<player_pan> = 1)
		<pan1x> = -0.762
		<pan1y> = 0.6470001
		<pan2x> = -0.448
		<pan2y> = 0.894
	else
		<pan1x> = 0.47
		<pan1y> = 0.883
		<pan2x> = 0.728
		<pan2y> = 0.685
	endif
	switch <difficulty>
		case easy
			<total_strums> = ($battlemode_powerups [6].easy_repair)
		case medium
			<total_strums> = ($battlemode_powerups [6].medium_repair)
		case hard
			<total_strums> = ($battlemode_powerups [6].hard_repair)
		case expert
			<total_strums> = ($battlemode_powerups [6].expert_repair)
		default
			printf \{'moron'}
	endswitch
	<change_pitch> = (1.3 * <num_strums> / <total_strums>)
	<local_pitch> = (100.0 - (10.0 * <change_pitch>))
	PlaySound #"0x3c372545" vol = 50 pitch = <local_pitch> pan1x = <pan1x> pan1y = <pan1y> pan2x = <pan2x> pan2y = <pan2y>
endscript
GH3_Crowd_Manipulate_SFX = $EmptyScript
GH3_Crowd_Event_Listener = $EmptyScript
GH3_Play_A_Fast_Crowd_Swell_Based_On_Venue = $EmptyScript
GH3_Play_A_Crowd_Applause_Based_On_Venue = $EmptyScript
GH3_Play_A_Crowd_OneShot_Positive_Based_On_Venue = $EmptyScript
GH3_Play_A_Crowd_OneShot_Negative_Based_On_Venue = $EmptyScript
GH3_SFX_Encore_Accept = $EmptyScript

script GH3_SFX_Encore_Decline
endscript

script GH3_AdjustCrowdSingingVolumeUp
endscript

script GH3_AdjustCrowdSingingVolumeDown
endscript

script GH3_AdjustCrowdFastSurge
endscript

script GH3_AdjustCrowdSlowSurge
endscript

script Crowd_Singalong_Volume_Up
endscript

script Crowd_Singalong_Volume_Down
endscript

script Menu_Music_On
endscript

script Menu_music_Checking
endscript

script Menu_Music_Off
	//EnableUserMusic \{disable}
	//killspawnedscript \{name = Menu_Music_On}
	//StopSoundEvent \{Menu_Music_SE}
endscript

script PlayEncoreStreamSFX
endscript

script Song_Intro_Kick_SFX_Waiting
	printingtext = ($current_intro.hud_move_time)
	wait ($current_intro.hud_move_time / 1000.0)seconds
	SoundEvent \{event = Song_Intro_Kick_SFX}
endscript

script Song_Intro_Highway_Up_SFX_Waiting
	printingtext = ($current_intro.highway_move_time)
	waitTime = (($current_intro.highway_move_time / 1000.0)- 1.5)
	if (<waitTime> < 0)
		waitTime = 0
	endif
	wait <waitTime> seconds
	SoundEvent \{event = Song_Intro_Highway_Up}
endscript

script Change_Crowd_Looping_SFX
endscript

script do_actual_changing_of_looping_sound
endscript

script Change_Crowd_Looping_SFX_Bad
endscript

script Change_Crowd_Looping_SFX_Neutral
endscript

script Change_Crowd_Looping_SFX_Good
endscript

script Crowd_Transition_SFX_Poor_To_Medium
endscript

script Crowd_Transition_SFX_Medium_To_Good
endscript

script Crowd_Transition_SFX_Medium_To_Poor
endscript

script Crowd_Transition_SFX_Good_To_Medium
endscript

script Crowd_generic_transition_sfx
endscript

script transition_sfx_left_side
endscript

script transition_sfx_right_side
endscript

script transition_sfx_both_sides
endscript

script Do_Actual_Transition_SFX_Poor_To_Medium
endscript

script Do_Actual_Transition_SFX_Poor_To_Medium_P1
endscript

script Do_Actual_Transition_SFX_Poor_To_Medium_P2
endscript

script Do_Actual_Transition_SFX_Medium_To_Good
endscript

script Do_Actual_Transition_SFX_Medium_To_Good_P1
endscript

script Do_Actual_Transition_SFX_Medium_To_Good_P2
endscript

script Do_Actual_Transition_SFX_Medium_To_Poor
endscript

script Do_Actual_Transition_SFX_Medium_To_Poor_P1
endscript

script Do_Actual_Transition_SFX_Medium_To_Poor_P2
endscript

script Do_Actual_Transition_SFX_Good_To_Medium
endscript

script Do_Actual_Transition_SFX_Good_To_Medium_P1
endscript

script Do_Actual_Transition_SFX_Good_To_Medium_P2
endscript

script You_Rock_Waiting_Crowd_SFX
endscript
save_check_time_early = 0.0
save_check_time_late = 0.0

script Audio_Sync_Test_Disable_Highway
	disable_bg_viewport
	Change \{save_check_time_early = $check_time_early}
	Change \{save_check_time_late = $check_time_late}
	Change \{check_time_early = 1.0}
	Change \{check_time_late = 1.0}
endscript

script Audio_Sync_Test_Enable_Highway
	enable_bg_viewport
	Change \{check_time_early = $save_check_time_early}
	Change \{check_time_late = $save_check_time_late}
endscript

script GH_SFX_Intro_WarmUp
endscript

script PreEncore_Crowd_Build_SFX
endscript

script PreEncore_Crowd_Build_SFX_STOP
endscript

script GH_BossDevil_Death_Transition_SFX
	SoundEvent \{event = Devil_Die_Transition_SFX}
endscript

script Battle_SFX_Repair_Broken_String
	if GotParam \{num_strums}
		if GotParam \{player_pan}
			if GotParam \{difficulty}
				if (<player_pan> = 1)
					<pan1x> = -0.762
					<pan1y> = 0.6470001
					<pan2x> = -0.448
					<pan2y> = 0.894
				else
					<pan1x> = 0.47
					<pan1y> = 0.883
					<pan2x> = 0.728
					<pan2y> = 0.685
				endif
				switch <difficulty>
					case easy
						<total_strums> = ($battlemode_powerups [5].easy_repair)
					case medium
						<total_strums> = ($battlemode_powerups [5].medium_repair)
					case hard
						<total_strums> = ($battlemode_powerups [5].hard_repair)
					case expert
						<total_strums> = ($battlemode_powerups [5].expert_repair)
					default
						printf \{'moron'}
				endswitch
				<change_pitch> = (1.0 * <num_strums> / <total_strums>)
				<local_pitch> = (100.0 - (10.0 * <change_pitch>))
				PlaySound gh3_battlemode_stringtune_2 vol = 50 pitch = <local_pitch> pan1x = <pan1x> pan1y = <pan1y> pan2x = <pan2x> pan2y = <pan2y>
			endif
		endif
	endif
endscript

script GH_SFX_Play_Encore_Audio_From_Zone_Memory
endscript
Tom_Intro_Front_Speakers_unique_id = NULL
Tom_Intro_Back_Speakers_unique_id = NULL
Slash_Intro_Front_Speakers_unique_id = NULL
Slash_Intro_Back_Speakers_unique_id = NULL
Lou_Intro_Front_Speakers_unique_id = NULL
Lou_Intro_Back_Speakers_unique_id = NULL

script GH_SFX_Preload_Boss_Intro_Audio
endscript

script GH_SFX_Play_Boss_Audio_From_Zone_Memory
endscript

script GH3_SFX_fail_song_stop_sounds
	StopSoundsByBuss \{Crowd}
	StopSoundsByBuss \{UI_Star_Power}
	StopSoundsByBuss \{UI_Battle_Mode}
	StopSoundsByBuss \{Wrong_Notes_Player1}
	StopSoundsByBuss \{Wrong_Notes_Player2}
	StopSoundsByBuss \{Practice_Band_Playback}
	StopSoundsByBuss \{BinkCutScenes}
	BG_Crowd_Front_End_Silence \{immediate = 1}
endscript

script GH3_SFX_Stop_Sounds_For_KillSong
	StopSoundEvent \{Song_Intro_Kick_SFX}
	StopSoundEvent \{Notes_Ripple_Up_SFX}
	StopSoundEvent \{Song_Intro_Highway_Up}
	StopSoundEvent \{GH_SFX_BattleMode_Lightning_Player1}
	StopSoundEvent \{GH_SFX_BattleMode_Lightning_Player2}
	StopSoundEvent \{GH_SFX_BattleMode_DeathOf_P1}
	StopSoundEvent \{GH_SFX_BattleMode_DeathOf_P2}
	StopSoundEvent \{GH_SFX_BattleMode_DiffUp_P1}
	StopSoundEvent \{GH_SFX_BattleMode_DiffUp_P2}
	StopSoundEvent \{GH_SFX_BattleMode_DoubleNote_P1}
	StopSoundEvent \{GH_SFX_BattleMode_DoubleNote_P2}
	StopSoundEvent \{GH_SFX_BattleMode_Lefty_P1}
	StopSoundEvent \{GH_SFX_BattleMode_Lefty_P2}
	StopSoundEvent \{GH_SFX_BattleMode_Steal_P1}
	StopSoundEvent \{GH_SFX_BattleMode_Steal_P2}
	StopSoundEvent \{GH_SFX_BattleMode_StringBreak_P1}
	StopSoundEvent \{GH_SFX_BattleMode_StringBreak_P2}
	StopSoundEvent \{GH_SFX_BattleMode_WhammyAttack_P1}
	StopSoundEvent \{GH_SFX_BattleMode_WhammyAttack_P2}
	StopSoundEvent \{GH_SFX_BossBattle_PlayerDies}
	StopSoundEvent \{GH_SFX_BattleMode_Attack_Over_P1}
	StopSoundEvent \{GH_SFX_BattleMode_Attack_Over_P2}
	StopSoundEvent \{Battle_Power_Awarded_SFX_P1}
	StopSoundEvent \{Battle_Power_Awarded_SFX_P2}
	StopSoundEvent \{GH_SFX_BattleMode_WhammyAttack_Received_P1}
	StopSoundEvent \{GH_SFX_BattleMode_WhammyAttack_Received_P2}
	StopSoundEvent \{GH_SFX_BattleMode_Death_Drain_P1}
	StopSoundEvent \{GH_SFX_BattleMode_Death_Drain_P2}
	StopSoundEvent \{Battlemode_HeartBeat_P1}
	StopSoundEvent \{Battlemode_HeartBeat_P2}
	StopSoundsByBuss \{Practice_Band_Playback}
	StopSoundEvent \{UI_SFX_Lose_Multiplier_2X}
	StopSoundEvent \{UI_SFX_Lose_Multiplier_3X}
	StopSoundEvent \{UI_SFX_Lose_Multiplier_4X}
endscript

script GH_SFX_Countoff_Logic
	printf 'does this even get called'
	printstruct <...>
	return
	/*get_song_struct song = ($current_song)
	if StructureContains structure = <song_struct> name = countoff
		countoff_sound = (<song_struct>.countoff)
	else
		countoff_sound = 'sticks_normal'
	endif
	if (<velocity> > 99)
		velocity = 'Hard'
		;FormatText checksumName = sound_event_name 'Countoff_SFX_%s_Hard' s = <countoff_sound>
	else
		if (<velocity> > 74)
			velocity = 'Med'
			;FormatText checksumName = sound_event_name 'Countoff_SFX_%s_Med' s = <countoff_sound>
		else
			velocity = 'Soft'
			; ????
			;if (<velocity> > 49)
			;	FormatText checksumName = sound_event_name 'Countoff_SFX_%s_Soft' s = <countoff_sound>
			;else
			;	FormatText checksumName = sound_event_name 'Countoff_SFX_%s_Soft' s = <countoff_sound>
			;endif
		endif
	endif
	// as if this script will even matter because i got rid of most stuff not pertaining so much to gameplay
	FastFormatCrc Countoff_SFX_ a = <velocity> b = '_' c = <countoff_sound> out = sound_event_name
	SoundEvent event = <sound_event_name>*///
endscript

script GH_SFX_Training_Tuning_Strings
	switch <note_played>
		case 0
			switch <training_notes_strummed>
				case 1
					PlaySound \{e_tuning vol = 90 pitch = 80}
				case 2
					PlaySound \{e_tuning vol = 90 pitch = 90}
				case 3
					PlaySound \{e_string vol = 90 pitch = 90}
			endswitch
		case 1
			switch <training_notes_strummed>
				case 1
					PlaySound \{a_tuning vol = 90 pitch = 80}
				case 2
					PlaySound \{a_tuning vol = 90 pitch = 90}
				case 3
					PlaySound \{a_string vol = 90 pitch = 90}
			endswitch
		case 2
			switch <training_notes_strummed>
				case 1
					PlaySound \{d_tuning vol = 90 pitch = 80}
				case 2
					PlaySound \{d_tuning vol = 90 pitch = 90}
				case 3
					PlaySound \{d_string vol = 90 pitch = 90}
			endswitch
		case 3
			switch <training_notes_strummed>
				case 1
					PlaySound \{g_tuning vol = 90 pitch = 80}
				case 2
					PlaySound \{g_tuning vol = 90 pitch = 90}
				case 3
					PlaySound \{g_string vol = 90 pitch = 90}
			endswitch
		case 4
			switch <training_notes_strummed>
				case 1
					PlaySound \{b_tuning vol = 90 pitch = 80}
				case 2
					PlaySound \{b_tuning vol = 90 pitch = 90}
				case 3
					PlaySound \{b_string vol = 90 pitch = 90}
			endswitch
	endswitch
endscript

script GH_SFX_Note_Streak_SinglePlayer
	if (<combo> = 50)
		SoundEvent \{event = UI_SFX_50_Note_Streak_SinglePlayer}
	else
		SoundEvent \{event = UI_SFX_100_Note_Streak_SinglePlayer}
	endif
endscript

script GH_SFX_Note_Streak_P1
	if (<combo> = 50)
		SoundEvent \{event = UI_SFX_50_Note_Streak_P1}
	else
		SoundEvent \{event = UI_SFX_100_Note_Streak_P1}
	endif
endscript

script GH_SFX_Note_Streak_P2
	if (<combo> = 50)
		SoundEvent \{event = UI_SFX_50_Note_Streak_P2}
	else
		SoundEvent \{event = UI_SFX_100_Note_Streak_P2}
	endif
endscript

script GH_SFX_Training_Hammer_On_Lesson_2
	switch <note_played>
		case 0
			switch <training_notes_strummed>
				case 1
					PlaySound \{e_tuning vol = 90 pitch = 80}
				case 2
					PlaySound \{e_tuning vol = 90 pitch = 90}
				case 3
					PlaySound \{e_string vol = 90 pitch = 90}
			endswitch
		case 1
			switch <training_notes_strummed>
				case 1
					PlaySound \{a_tuning vol = 90 pitch = 80}
				case 2
					PlaySound \{a_tuning vol = 90 pitch = 90}
				case 3
					PlaySound \{a_string vol = 90 pitch = 90}
			endswitch
		case 2
			switch <training_notes_strummed>
				case 1
					PlaySound \{d_tuning vol = 90 pitch = 80}
				case 2
					PlaySound \{d_tuning vol = 90 pitch = 90}
				case 3
					PlaySound \{d_string vol = 90 pitch = 90}
			endswitch
		case 3
			switch <training_notes_strummed>
				case 1
					PlaySound \{g_tuning vol = 90 pitch = 80}
				case 2
					PlaySound \{g_tuning vol = 90 pitch = 90}
				case 3
					PlaySound \{g_string vol = 90 pitch = 90}
			endswitch
		case 4
			switch <training_notes_strummed>
				case 1
					PlaySound \{b_tuning vol = 90 pitch = 80}
				case 2
					PlaySound \{b_tuning vol = 90 pitch = 90}
				case 3
					PlaySound \{b_string vol = 90 pitch = 90}
			endswitch
	endswitch
endscript

script StopNotes_01
	if IsSoundEventPlaying \{tutorial_string_1_strum_free}
		SetSoundParams \{tutorial_string_1_strum_free vol = 100}
		wait \{0.05 seconds}
		SetSoundParams \{tutorial_string_1_strum_free vol = 50}
		wait \{0.05 seconds}
		SetSoundParams \{tutorial_string_1_strum_free vol = 10}
		StopSoundEvent \{tutorial_string_1_strum_free}
	endif
endscript

script StopNotes_02
	if IsSoundEventPlaying \{tutorial_string_2_hopo_free}
		SetSoundParams \{tutorial_string_2_hopo_free vol = 100}
		wait \{0.05 seconds}
		SetSoundParams \{tutorial_string_2_hopo_free vol = 50}
		wait \{0.05 seconds}
		SetSoundParams \{tutorial_string_2_hopo_free vol = 10}
		StopSoundEvent \{tutorial_string_2_hopo_free}
	endif
endscript

script StopNotes_03
	if IsSoundEventPlaying \{tutorial_string_3_hopo_free}
		SetSoundParams \{tutorial_string_3_hopo_free vol = 100}
		wait \{0.05 seconds}
		SetSoundParams \{tutorial_string_3_hopo_free vol = 50}
		wait \{0.05 seconds}
		SetSoundParams \{tutorial_string_3_hopo_free vol = 10}
		StopSoundEvent \{tutorial_string_3_hopo_free}
	endif
endscript

script StopNotes_04
	if IsSoundEventPlaying \{tutorial_string_3_strum_free}
		SetSoundParams \{tutorial_string_3_strum_free vol = 100}
		wait \{0.05 seconds}
		SetSoundParams \{tutorial_string_3_strum_free vol = 50}
		wait \{0.05 seconds}
		SetSoundParams \{tutorial_string_3_strum_free vol = 10}
		StopSoundEvent \{tutorial_string_3_strum_free}
	endif
endscript

script StopNotes_05
	if IsSoundEventPlaying \{tutorial_string_2_hopo_free}
		SetSoundParams \{tutorial_string_2_hopo_free vol = 100}
		wait \{0.05 seconds}
		SetSoundParams \{tutorial_string_2_hopo_free vol = 50}
		wait \{0.05 seconds}
		SetSoundParams \{tutorial_string_2_hopo_free vol = 10}
		StopSoundEvent \{tutorial_string_2_hopo_free}
	endif
endscript

script StopNotes_06
	if IsSoundEventPlaying \{tutorial_string_1_hopo_free}
		SetSoundParams \{tutorial_string_1_hopo_free vol = 100}
		wait \{0.05 seconds}
		SetSoundParams \{tutorial_string_1_hopo_free vol = 50}
		wait \{0.05 seconds}
		SetSoundParams \{tutorial_string_1_hopo_free vol = 10}
		StopSoundEvent \{tutorial_string_1_hopo_free}
	endif
endscript

script Tutorial_Mode_Finish_Chord_02
	wait \{1 seconds}
	SoundEvent \{event = Tutorial_Mode_Finish_Chord}
endscript

script Tutorial_Mode_Finish_Chord_03
	wait \{0.3 seconds}
	SoundEvent \{event = Tutorial_Mode_Finish_Chord}
endscript
