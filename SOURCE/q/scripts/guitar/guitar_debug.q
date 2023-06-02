
script init_play_log
	if ($show_play_log = 1)
		<Pos> = (256.0, 32.0)
		<name> = log_line
		<line> = 0
		begin
			FormatText checksumName = id 'log_line_%l' l = <line> DontAssertForChecksums
			CreateScreenElement {
				Type = TextElement
				parent = root_window
				id = <id>
				font = fontgrid_title_gh3
				Pos = <Pos>
				just = [left top]
				Scale = (0.5, 0.5)
				rgba = [210 210 210 250]
				text = "Some Text"
				z_priority = 1000.0
				alpha = 1
			}
			<Pos> = (<Pos> + (0.0, 24.0))
			<line> = (<line> + 1)
		repeat $play_log_lines
		<blank_text> = " "
		Change log_strings = ($log_strings + {log_line_0 = <blank_text>})
		Change log_strings = ($log_strings + {log_line_1 = <blank_text>})
		Change log_strings = ($log_strings + {log_line_2 = <blank_text>})
		Change log_strings = ($log_strings + {log_line_3 = <blank_text>})
		Change log_strings = ($log_strings + {log_line_4 = <blank_text>})
		Change log_strings = ($log_strings + {log_line_5 = <blank_text>})
		Change log_strings = ($log_strings + {log_line_6 = <blank_text>})
		Change log_strings = ($log_strings + {log_line_7 = <blank_text>})
		Change log_strings = ($log_strings + {log_line_8 = <blank_text>})
		Change log_strings = ($log_strings + {log_line_9 = <blank_text>})
		<line> = 0
		begin
			FormatText checksumName = id 'log_line_%l' l = <line> DontAssertForChecksums
			SetScreenElementProps id = <id> text = ($log_strings.<id>)
			<line> = (<line> + 1)
		repeat $play_log_lines
	endif
endscript

script kill_debug_elements
	<line> = 0
	begin
		FormatText checksumName = id 'log_line_%l' l = <line> DontAssertForChecksums
		if ScreenElementExists id = <id>
			DestroyScreenElement id = <id>
		endif
		<line> = (<line> + 1)
	repeat $play_log_lines
	if ScreenElementExists \{id = guitar_tilt_debug}
		DestroyScreenElement \{id = guitar_tilt_debug}
	endif
endscript
log_strings = {
	log_line_0 = " "
	log_line_1 = " "
	log_line_2 = " "
	log_line_3 = " "
	log_line_4 = " "
	log_line_5 = " "
	log_line_6 = " "
	log_line_7 = " "
	log_line_8 = " "
	log_line_9 = " "
	log_line_0_color = green
	log_line_1_color = green
	log_line_2_color = green
	log_line_3_color = green
	log_line_4_color = green
	log_line_5_color = green
	log_line_6_color = green
	log_line_7_color = green
	log_line_8_color = green
	log_line_9_color = green
}

script output_log_text
	if ($show_play_log = 1)
		FormatText textname = text_string <...>
		<line_1> = ($log_strings.log_line_1)
		<line_2> = ($log_strings.log_line_2)
		<line_3> = ($log_strings.log_line_3)
		<line_4> = ($log_strings.log_line_4)
		<line_5> = ($log_strings.log_line_5)
		<line_6> = ($log_strings.log_line_6)
		<line_7> = ($log_strings.log_line_7)
		<line_8> = ($log_strings.log_line_8)
		<line_9> = ($log_strings.log_line_9)
		Change log_strings = ($log_strings + {log_line_0 = <line_1>})
		Change log_strings = ($log_strings + {log_line_1 = <line_2>})
		Change log_strings = ($log_strings + {log_line_2 = <line_3>})
		Change log_strings = ($log_strings + {log_line_3 = <line_4>})
		Change log_strings = ($log_strings + {log_line_4 = <line_5>})
		Change log_strings = ($log_strings + {log_line_5 = <line_6>})
		Change log_strings = ($log_strings + {log_line_6 = <line_7>})
		Change log_strings = ($log_strings + {log_line_7 = <line_8>})
		Change log_strings = ($log_strings + {log_line_8 = <line_9>})
		<color_1> = ($log_strings.log_line_1_color)
		<color_2> = ($log_strings.log_line_2_color)
		<color_3> = ($log_strings.log_line_3_color)
		<color_4> = ($log_strings.log_line_4_color)
		<color_5> = ($log_strings.log_line_5_color)
		<color_6> = ($log_strings.log_line_6_color)
		<color_7> = ($log_strings.log_line_7_color)
		<color_8> = ($log_strings.log_line_8_color)
		<color_9> = ($log_strings.log_line_9_color)
		Change log_strings = ($log_strings + {log_line_0_color = <color_1>})
		Change log_strings = ($log_strings + {log_line_1_color = <color_2>})
		Change log_strings = ($log_strings + {log_line_2_color = <color_3>})
		Change log_strings = ($log_strings + {log_line_3_color = <color_4>})
		Change log_strings = ($log_strings + {log_line_4_color = <color_5>})
		Change log_strings = ($log_strings + {log_line_5_color = <color_6>})
		Change log_strings = ($log_strings + {log_line_6_color = <color_7>})
		Change log_strings = ($log_strings + {log_line_7_color = <color_8>})
		Change log_strings = ($log_strings + {log_line_8_color = <color_9>})
		switch ($play_log_lines)
			case 1
				Change log_strings = ($log_strings + {log_line_0 = <text_string>})
				Change log_strings = ($log_strings + {log_line_0_color = <Color>})
			case 2
				Change log_strings = ($log_strings + {log_line_1 = <text_string>})
				Change log_strings = ($log_strings + {log_line_1_color = <Color>})
			case 3
				Change log_strings = ($log_strings + {log_line_2 = <text_string>})
				Change log_strings = ($log_strings + {log_line_2_color = <Color>})
			case 4
				Change log_strings = ($log_strings + {log_line_3 = <text_string>})
				Change log_strings = ($log_strings + {log_line_3_color = <Color>})
			case 5
				Change log_strings = ($log_strings + {log_line_4 = <text_string>})
				Change log_strings = ($log_strings + {log_line_4_color = <Color>})
			case 6
				Change log_strings = ($log_strings + {log_line_5 = <text_string>})
				Change log_strings = ($log_strings + {log_line_5_color = <Color>})
			case 7
				Change log_strings = ($log_strings + {log_line_6 = <text_string>})
				Change log_strings = ($log_strings + {log_line_6_color = <Color>})
			case 8
				Change log_strings = ($log_strings + {log_line_7 = <text_string>})
				Change log_strings = ($log_strings + {log_line_7_color = <Color>})
			case 9
				Change log_strings = ($log_strings + {log_line_8 = <text_string>})
				Change log_strings = ($log_strings + {log_line_8_color = <Color>})
			case 10
				Change log_strings = ($log_strings + {log_line_9 = <text_string>})
				Change log_strings = ($log_strings + {log_line_9_color = <Color>})
		endswitch
		<line> = 0
		begin
			FormatText checksumName = id 'log_line_%l' l = <line> DontAssertForChecksums
			SetScreenElementProps id = <id> text = ($log_strings.<id>)
			FormatText checksumName = col 'log_line_%l_color' l = <line> DontAssertForChecksums
			switch ($log_strings.<col>)
				case green
					SetScreenElementProps id = <id> rgba = [48 210 48 250]
				case darkgreen
					SetScreenElementProps id = <id> rgba = [16 160 16 250]
				case red
					SetScreenElementProps id = <id> rgba = [210 48 48 250]
				case darkred
					SetScreenElementProps id = <id> rgba = [160 16 16 250]
				case orange
					SetScreenElementProps id = <id> rgba = [210 128 16 250]
				default
					SetScreenElementProps id = <id> rgba = [210 210 210 250]
			endswitch
			<line> = (<line> + 1)
		repeat $play_log_lines
	endif
endscript

script guitar_tilt_debug_display
	if ($show_guitar_tilt = 1)
		if NOT ScreenElementExists \{id = guitar_tilt_debug}
			CreateScreenElement \{Type = TextElement parent = root_window id = guitar_tilt_debug font = text_a1 Pos = (640.0, 400.0) just = [center center] Scale = 2.0 rgba = [210 210 210 250] text = "Tilt!" z_priority = 10.0 alpha = 1}
		endif
		FormatText \{textname = text_string " ???"}
		controller = 0
		begin
			if IsGuitarController controller = <controller>
				GuitarGetAnalogueInfo controller = <controller>
				FormatText textname = text_string "Tilt: %d" d = <righty>
			endif
			<controller> = (<controller> + 1)
		repeat 4
		SetScreenElementProps id = guitar_tilt_debug text = <text_string>
	endif
endscript

script guitar_sensor_debug
	if ($show_sensor_debug)
		if NOT ScreenElementExists \{id = guitar_sensor_debug}
			CreateScreenElement \{Type = TextBlockElement parent = root_window id = guitar_sensor_debug font = text_a1 Scale = 0.75 Pos = (64.0, 64.0) dims = (256.0, 256.0) just = [left top] rgba = [210 210 210 255] z_priority = 10.0 alpha = 0.8}
		endif
		control = -1
		if IsGuitarController \{controller = 0}
			<control> = 0
		else
			if IsGuitarController \{controller = 1}
				<control> = 1
			endif
		endif
		if (<control> >= 0)
			GuitarGetAnalogueInfo controller = <control>
			FormatText {
				textname = text_string
				"Tilt: %a\nLean: %b\nNeck: %c\nWhammy: %d"
				a = <r2raw>
				b = <l2raw>
				c = <righty>
				d = <rightx>
			}
			SetScreenElementProps id = guitar_sensor_debug text = <text_string>
		endif
	endif
endscript

script check_input_debug
	GetHeldPattern controller = <controller> player_status = <player_status>
	pressed = 0
	switch hold_pattern
		case 65536
			if (<button> = X)
				<pressed> = 1
			endif
		case 4096
			if (<button> = Circle)
				<pressed> = 1
			endif
		case 256
			if (<button> = Triangle)
				<pressed> = 1
			endif
		case 16
			if (<button> = Square)
				<pressed> = 1
			endif
		case 1
			if (<button> = L1)
				<pressed> = 1
			endif
	endswitch
	if (<pressed> = 1)
		FormatText textname = text "%t%c" t = <text> c = <char>
	else
		FormatText textname = text "%t." t = <text>
	endif
	return <...>
endscript

script get_input_debug_text
	<text> = "* "
	check_input_debug <...> controller = ($<player_status>.controller)button = X char = "G"
	check_input_debug <...> controller = ($<player_status>.controller)button = Circle char = "R"
	check_input_debug <...> controller = ($<player_status>.controller)button = Triangle char = "Y"
	check_input_debug <...> controller = ($<player_status>.controller)button = Square char = "B"
	check_input_debug <...> controller = ($<player_status>.controller)button = L1 char = "O"
	if IsGuitarController controller = ($<player_status>.controller)
		FormatText textname = text "%t *+* " t = <text>
	else
		FormatText textname = text "%t *-*" t = <text>
	endif
	return input_text = <text>
endscript

script input_debug
	get_input_debug_text <...>
	GuitarGetAnalogueInfo controller = ($<player_status>.controller)
	FormatText textname = input_text "%t %l %r %d %x %y" t = <input_text> l = <LeftTrigger> r = <RightTrigger> d = <VerticalDist> X = <rightx> y = <righty>
	if ScreenElementExists \{id = input_textp1}
		SetScreenElementProps id = input_textp1 text = <input_text>
	endif
endscript

script debug_gem_text
	if (<pattern> & 65536)
		FormatText textname = text "%t%pG" t = <text> p = <prefix>
	else
		FormatText textname = text "%t%p." t = <text> p = <prefix>
	endif
	if (<pattern> & 4096)
		FormatText textname = text "%tR" t = <text>
	else
		FormatText textname = text "%t." t = <text>
	endif
	if (<pattern> & 256)
		FormatText textname = text "%tY" t = <text>
	else
		FormatText textname = text "%t." t = <text>
	endif
	if (<pattern> & 16)
		FormatText textname = text "%tB" t = <text>
	else
		FormatText textname = text "%t." t = <text>
	endif
	if (<pattern> & 1)
		FormatText textname = text "%tO " t = <text>
	else
		FormatText textname = text "%t. " t = <text>
	endif
	return <...>
endscript

script debug_output
	if ($output_log_file = 1)
		<showtime> = (<time> - ($check_time_early * 1000.0))
		FormatText textname = text "%t: %d:(%c)" t = <showtime> d = ($<song> [<array_entry>] [6])c = ($<player_status>.controller)
		if (<ignore_time> >= 0)
			debug_gem_text text = <text> pattern = <ignore_strum> prefix = "Ig: "
		else
			FormatText textname = text "%tIg: ..... " t = <text>
		endif
		GetHeldPattern controller = ($<player_status>.controller)nobrokenstring
		debug_gem_text text = <text> pattern = <strummed_pattern> prefix = "LS: "
		debug_gem_text text = <text> pattern = <original_strum> prefix = "Or: "
		debug_gem_text text = <text> pattern = <hold_pattern> prefix = "He: "
		if (<hit_strum> = 1)
			if (<fake_strum> = 1)
				FormatText textname = text "%t H " t = <text>
			else
				FormatText textname = text "%t S " t = <text>
			endif
		else
			if (<fake_strum> = 1)
				FormatText textname = text "%t F " t = <text>
			else
				FormatText textname = text "%t . " t = <text>
			endif
		endif
		if (<strummed_before_forming> >= 0.0)
			FormatText textname = text "%t T " t = <text>
		else
			FormatText textname = text "%t	 " t = <text>
		endif
		get_input_debug_text <...>
		FormatText textname = text "%t%h%m%u%l%i" t = <text> h = <action_hit> m = <action_mis> u = <action_unn> l = <action_tol> i = <input_text>
		FormatText textname = text "%t :%o:" t = <text> o = ($<player_status>.hammer_on_tolerance)
		<check_entry> = <array_entry>
		if (<time> >= $<song> [<check_entry>] [0])
			begin
				GetStrumPattern song = <song> entry = <check_entry>
				<hammer> = ($<song> [<check_entry>] [6])
				if (<hammer> = 1)
					debug_gem_text text = <text> pattern = <strum> prefix = "h"
				else
					debug_gem_text text = <text> pattern = <strum> prefix = ">"
				endif
				if ((<check_entry> + 1)< <song_array_size>)
					<check_entry> = (<check_entry> + 1)
				else
					break
				endif
				if (<time> < ($<song> [<check_entry>] [0]))
					break
				endif
			repeat
		endif
		GetArraySize <strum_hits>
		if (<array_Size> > 0)
			FormatText textname = text "%t S(" t = <text>
			<index> = 0
			begin
				<strum> = (<strum_hits> [<index>])
				debug_gem_text text = <text> pattern = <strum> prefix = ""
				<index> = (<index> + 1)
			repeat <array_Size>
			FormatText textname = text "%t)" t = <text>
		endif
		GetArraySize <hammer_hits>
		if (<array_Size> > 0)
			FormatText textname = text "%t H(" t = <text>
			<index> = 0
			begin
				<strum> = (<hammer_hits> [<index>])
				debug_gem_text text = <text> pattern = <strum> prefix = ""
				<index> = (<index> + 1)
			repeat <array_Size>
			FormatText textname = text "%t)" t = <text>
		endif
		ExtendCrc log ($<player_status>.text)out = log_channel
		printf channel = <log_channel> <text>
	endif
endscript

script start_sensor_debug_output
	killspawnedscript \{name = sensor_debug_output}
	if NOT GotParam \{controller}
		controller = $primary_controller
	endif
	spawnscriptnow sensor_debug_output params = <...>
endscript

script stop_sensor_debug_output
	killspawnedscript \{name = sensor_debug_output}
endscript

script sensor_debug_output
	last_righty = 0.0
	drighty = 0.0
	last_drighty = 0.0
	ddrighty = 0.0
	spike_threshold = 0.3
	begin
		GuitarGetAnalogueInfo controller = <controller>
		printf "Sensor Value %v" v = <righty>
		drighty = (<righty> - <last_righty>)
		ddrighty = (<drighty> - <last_drighty>)
		if (<drighty> > <spike_threshold> || <drighty> < -1.0 * <spike_threshold>)
			printf \{"Velocity Spike!!!"}
		endif
		if (<ddrighty> > 2.0 * <spike_threshold> || <ddrighty> < -2.0 * <spike_threshold>)
			printf \{"Acceleration Spike!!!"}
		endif
		<last_righty> = (<righty>)
		<last_drighty> = (<drighty>)
		wait \{1 gameframe}
	repeat
endscript

script FlexParticleWarning
	SetScreenElementLock \{id = root_window OFF}
	if ObjectExists \{id = particle_warn_anchor}
		DestroyScreenElement \{id = particle_warn_anchor}
	endif
	CreateScreenElement \{Type = ContainerElement parent = root_window id = particle_warn_anchor Pos = (25.0, 80.0) just = [center center] internal_just = [left center]}
	CreateScreenElement \{Type = TextElement parent = particle_warn_anchor id = particle_warn_text Pos = (0.0, 0.0) text = "Particle failed: Too many at once" font = text_a1 rgba = [255 0 0 255] just = [left top]}
	SetScreenElementLock \{id = root_window On}
	wait \{2 seconds}
	if ObjectExists \{id = particle_warn_anchor}
		DestroyScreenElement \{id = particle_warn_anchor}
	endif
endscript
