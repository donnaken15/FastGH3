/*current_page = 0
current_cpu = 0

script handle_keyboard_input
	if GotParam \{got_escape}
		if ($show_gpu_time = 1)
			ToggleMetrics \{mode = 5}
			if isps3
				Change \{current_cpu = 2}
			else
				Change \{current_cpu = 6}
			endif
		else
			ToggleMetrics \{mode = 0}
		endif
	endif
	if GotParam \{got_f1}
		ToggleMetrics \{mode = 1}
	endif
	if GotParam \{got_f2}
		ToggleMetrics \{mode = 2}
	endif
	if GotParam \{got_f3}
		ToggleMetrics \{mode = 3}
	endif
	if GotParam \{got_f4}
		ToggleMetrics \{mode = 4}
	endif
	GetMetricsMode
	GetArraySize \{$#"0x285f8558"}
	num_pages = <array_Size>
	num_cpus = 7
	if isps3
		<num_cpus> = 3
	endif
	if GotParam \{text}
		<key> = 1
		begin
			FormatText textname = key_name "%k" k = <key>
			if (<text> = <key_name>)
				if (<mode> = 2)
					if ((<key> - 1)< <num_cpus>)
						Change current_cpu = (<key> -1)
						printf \{"Current CPU %c" c = $#"0x4c8350e7"}
						break
					endif
				endif
				if (<mode> = 3)
					if ((<key> - 1)< <num_pages>)
						Change current_page = (<key> -1)
						break
					endif
				endif
			endif
			<key> = (<key> + 1)
		repeat 9
		if (<mode> >= 2)
			if (<text> = " ")
				MoveProfileCursor cpu = ($current_cpu)freeze
			endif
		endif
		if (<mode> = 2)
			if (<text> = "d")
				dumpprofilestart
				dumpprofile cpu = ($current_cpu)title = "Profile Dump:"
				dumpprofileend \{output_text output_file}
			endif
		endif
		if (<text> = "g")
			Change show_gpu_time = (1 - $show_gpu_time)
			if ($show_gpu_time = 1)
				ToggleMetrics \{mode = 5}
				if isps3
					Change \{current_cpu = 2}
				else
					Change \{current_cpu = 6}
				endif
			else
				ToggleMetrics \{mode = 0}
			endif
		endif
		user_keyboard_script text = <text>
	endif
	if (<mode> = 2)
		if GotParam \{got_left}
			MoveProfileCursor cpu = ($current_cpu)left
		endif
		if GotParam \{got_right}
			MoveProfileCursor cpu = ($current_cpu)right
		endif
		if GotParam \{got_up}
			MoveProfileCursor cpu = ($current_cpu)up
		endif
		if GotParam \{got_down}
			MoveProfileCursor cpu = ($current_cpu)down
		endif
	endif
endscript*/
