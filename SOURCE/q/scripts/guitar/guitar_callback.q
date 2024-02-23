
script timer_callback_script
	if ($input_mode = Play)
		playback_timer
	endif
endscript

script script_callback_script
	change \{replay_suspend = 1}
	if ($input_mode = Play)
		if ($playback_do_frame = 1)
			change \{replay_suspend = 0}
			change \{structurename = player1_status bot_play = 0}
			change \{structurename = player2_status bot_play = 0}
			Change StructureName = player1_status controller = ($playback_ctrl1)
			Change StructureName = player2_status controller = ($playback_ctrl2)
			//change \{disable_note_input = 1}
		endif
	endif
	script_callback_script_cfunc
	if ($input_mode = Play)
		if ($playback_do_frame = 1)
			//printf 'got frame'
			change \{playback_do_frame = 0}
			//change \{disable_note_input = 0}
			GetHeldPattern controller = ($player1_status.controller) nobrokenstring
			//change structurename = player1_status bot_pattern = <hold_pattern>
			change playback_pattern_p1 = <hold_pattern>
			GetHeldPattern controller = ($player2_status.controller) nobrokenstring
			//change structurename = player2_status bot_pattern = <hold_pattern>
			change playback_pattern_p2 = <hold_pattern>
			debug_gem_text text = "" pattern = ($playback_pattern_p1) prefix = ""
			printf <text>
			
			change \{structurename = player1_status bot_play = 1}
			change \{structurename = player2_status bot_play = 1}
			GetInputHandlerBotIndex \{Player = 1}
			Change StructureName = player1_status controller = <controller>
			GetInputHandlerBotIndex \{Player = 2}
			Change StructureName = player2_status controller = <controller>
		endif
	endif
endscript

script script_postcallback_script
	UpdateGuitarFuncs
	if NOT GameIsPaused
		GetDeltaTime
		Update2DParticleSystems delta_time = <delta_time>
		RunQueuedPulseEvents
		CheckBossCutoff
		/*if ($output_gpu_log = 1)
			if isps3
				GetProfileData \{cpu = 2 name = gpu}
			else
				GetProfileData \{cpu = 6 name = gpu}
			endif
			milliseconds = (<microseconds> / 1000.0)
			getsongtime
			FormatText textname = text "GPU Time; %s; %m" s = <songtime> m = <milliseconds> DontAssertForChecksums
			TextOutput text = <text>
		endif*///
	endif
endscript

script screenelement_postcallback_script
endscript
