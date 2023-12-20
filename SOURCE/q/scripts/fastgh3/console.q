
toggle_console = 0
might_hold_shift = 0
console_pause = 1
script create_keyboard_input
	EnableInput OFF ($player1_status.controller)
	CreateScreenElement {
		parent = root_window
		id = console_text
		text = ""
		type = textblockelement
		font = text_a1
		scale = 1.0
		rgba = [ 255 255 255 255 ]
		just = [ left bottom ]
		internal_just = [ left bottom ]
		pos = (72.0, 720.0)
		dims = (960.0, 320.0)
		z_priority = 200
	}
	update_console_input
	if ($console_pause = 1)
		change old_speed = ($current_speedfactor)
		sv_speed 0.0
	endif
	spawnscriptnow \{check_user_input}
endscript
script destroy_keyboard_input
	EnableInput ($player1_status.controller)
	if ScreenElementExists \{id = console_text}
		DestroyScreenElement \{id = console_text}
	endif
	KillSpawnedScript \{name = check_user_input}
	change \{console_input = ""}
	if ($console_pause = 1)
		sv_speed ($old_speed)
		change old_speed = -1.0
	endif
endscript
script update_console_input
	formattext textname = con "%t_" t = ($console_input)
	SetScreenElementProps id = console_text text = <con>
endscript
script check_user_input
	capslock = 0
	shift = 0
	begin
		WinPortSioGetControlPress \{deviceNum = $player1_device}
		if NOT (<controlNum> = -1)
			if NOT ($last_key = <controlNum>)
				if ord <controlNum>
					if IsCapsLockOn
						capslock = 1
					else
						capslock = 0
					endif
					if ($might_hold_shift = 1)
						shift = 1
					else
						shift = 0
					endif
					shift = (<shift> - <capslock>)
					if (<shift> = 0)
						GetLowerCaseString <char>
						char = <lowercasestring>
						ExtendCrc #"0xFFFFFFFF" <char> out = <id>
						if StructureContains structure=($key_chars_lower) <id>
							char = ($key_chars_lower.<id>)
						endif
					endif
					change console_input = ($console_input + <char>)
					update_console_input
				else
					//if (<controlNum> = 219) // Back
					//	
					//endif
					if (<controlNum> = 229) // Delete
						trim ($console_input)
						change console_input = <trim>
					endif
					if (<controlNum> = 293) // Enter
						spawnscriptnow eval params = { ($console_input) }
						change \{console_input = ""}
					endif
					update_console_input
				endif
			endif
		endif
		wait \{1 gameframe}
	repeat
endscript
script ord // lol
	if (<#"0x00000000"> = -1)
		return \{false}
	endif
	formattext checksumname = id "%a" a = <#"0x00000000">
	if StructureContains structure=($key_chars) <id>
		return true char = ($key_chars.<id>)
	endif
	return \{false}
endscript
script trim \{c = 1}
	StringToCharArray string = <#"0x00000000">
	getarraysize \{char_array}
	if (<array_size> > 1)
		AddParams \{ trim = "" i = 0 } // stupid
		begin
			trim = (<trim> + <char_array>[<i>])
			Increment \{i}
		repeat (<array_size> - <c>)
		return trim = <trim>
	elseif (<array_size> = 1)
		return \{trim = ""}
	endif
endscript
console_input = ""
key_chars_lower = {
	#"0xf89d5196" = "'" // "
	#"0xd6295c17" = "-" // _
}
key_chars = {}
script decompress_chars
	change key_chars = {
		#"304" = "Q"
		#"331" = "W"
		#"232" = "E"
		#"305" = "R"
		#"322" = "T"
		#"341" = "Y"
		#"324" = "U"
		#"256" = "I"
		#"295" = "O"
		#"297" = "P"
		
		#"210" = "A"
		#"313" = "S"
		#"227" = "D"
		#"236" = "F"
		#"252" = "G"
		#"254" = "H"
		#"258" = "J"
		#"259" = "K"
		#"262" = "L"
		
		#"343" = "Z"
		#"340" = "X"
		#"221" = "C"
		#"328" = "V"
		#"218" = "B"
		#"277" = "N"
		#"269" = "M"
		
		#"200" = "0"
		#"201" = "1"
		#"202" = "2"
		#"203" = "3"
		#"204" = "4"
		#"205" = "5"
		#"206" = "6"
		#"207" = "7"
		#"208" = "8"
		#"209" = "9"
		
		#"273" = "_"
		#"234" = "="
		#"263" = "["
		#"306" = "]"
		#"213" = "+"
		#"225" = ","
		#"299" = "."
		#"316" = "?"
		#"318" = " "
		#"345" = ";"
		#"214" = "\""
		#"220" = "\\"
	}
endscript
