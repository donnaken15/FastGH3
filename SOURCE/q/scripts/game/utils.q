
// some cool muh t00lz

// for floats
script Modulo \{mod = 10}
	// do if (v < 0) v+= mod???
	begin
		if (<#"0x00000000"> >= <mod>)
			#"0x00000000" = (<#"0x00000000"> - <mod>)
		else
			return mod = <#"0x00000000">
		endif
	repeat
endscript
script Sum
	getarraysize \{#"0x00000000"}
	sum = 0.0
	i = 0
	begin
		sum = (<sum> + (<#"0x00000000">[<i>] * 1.0))
		Increment \{i}
	repeat <array_size>
	return sum = <sum>
endscript
script Avg
	// todo for optimization if slow: use goto and addparam?
	Sum <#"0x00000000">
	getarraysize \{#"0x00000000"}
	return avg = (<sum> / <array_size>)
endscript
script Max \{a = 0 b = 0}
	if (<a> < <b>)
		return max = <b>
	else
		return max = <a>
	endif
endscript

// fancifying
// @script | AllocArray | create new array with a defined size and element to fill with
// thanks q
// @parm name | set | the element and it's type to set the array with (floats don't work >:(   )
// @parm name | size | size of the array
script AllocArray \{size = 10}
	if NOT GotParam \{set}
		//set = 0
		CreateIndexArray <size>
		change globalname = <#"0x00000000"> newvalue = <index_array>
		return
	endif
	// basically memset lol
	element = <set>
	RemoveComponent \{set}
	array = []
	begin
		AddArrayElement <...>
	repeat <size>
	change globalname = <#"0x00000000"> newvalue = <array>
endscript
// CreateIndexArray CFunc creates an integer array
// where each item is incremented after another

// @script | FSZ | convert exact file size to a readable string
// @parm name | | integer of file size
script FSZ \{1024}
	AddParams \{units = [' bytes' 'Kb' 'Mb' 'Gb' 'Tb'] u = 0}
	begin
		if (<#"0x00000000"> >= 1024)
			<#"0x00000000"> = (<#"0x00000000"> / 1024.0)
			Increment \{u}
		else
			FormatText textname=text '%d%u' d = <#"0x00000000"> u = (<units>[<u>])
			break
		endif
	repeat
	return textsize = <text>
endscript

// @script | IndexOf | find the earliest occurrence of an item in an array
// @parm name | | the item to match
// @parm name | array | the array to find the item in
// @parm name | delegate | the function to compare the item to other items in the array
// @return name | | status of whether the item was found or not
// @return name | indexof | index of the item in the array, if not found, it is set to -1
script IndexOf \{delegate = IntegerEquals #"0x00000000" = 0 array = []}
	;if NOT ArrayContains array = <array> contains = <#"0x00000000">
	;	return
	;endif
	GetArraySize \{array}
	if (<array_size> > 0)
		i = 0
		begin
			if <delegate> a = <#"0x00000000"> b = (<array>[<i>])
				return true indexof = <i>
			endif
			Increment \{i}
		repeat <array_size>
		// repeat (with 0 explicitly typed out, or in variable) means infinite :/
	endif
	return \{ false indexof = -1 }
endscript

// @script | pad | format a number with leading zeroes (or custom char)
// @parm name | | the integer to pad
// @parm name | count | total width of the number as a string
// @parm name | pad | the character used to fill the width of the string
// @return name | pad | the padded number
script pad \{#"0x00000000" = 0 count = 2 pad = '0'}
	pad_chars = ""
	formattext textname = pad_char "%d" d = <pad>
	if (<#"0x00000000"> < 0 & <pad_char> = "0")
		pad_chars = "-"
		#"0x00000000" = (<#"0x00000000"> * -1)
		count = (<count> - 1)
	endif
	formattext textname = text "%d" d = <#"0x00000000">
	DestroyComponent \{pad}
	StringToCharArray string = <text> // STRINGLENGTH IS BROKEN
	getarraysize \{char_array}
	pad = (<count> - <array_size>)
	if (<pad> > 0)
		begin
			pad_chars = (<pad_chars> + <pad_char>)
		repeat <pad>
	endif
	return pad = (<pad_chars> + <text>)
endscript

// @script | timestamp | get a string for the current time
// @return name | timestamp | current time and date
script timestamp \{format = $timestamp_format}
	ProfilingStart
	GetLocalSystemTime
	AddParams <localsystemtime>
	pad (<month>+1) // why is it one less
	month = <pad>
	pad <dayofmonth>
	dayofmonth = <pad>
	pad <hour>
	hour = <pad>
	pad <minute>
	minute = <pad>
	pad <second>
	second = <pad>
	pad <millisecond> count = 3
	millisecond = <pad>
	ProfilingEnd <...> 'timestamp'
	FormatText { textname = timestamp <format>
		// format guide
		y = <year> m = <month> d = <dayofmonth>
		h = <hour> n = <minute> s = <second> t = <millisecond> }
	return timestamp = <timestamp>
endscript
timestamp_format = '%y-%m-%d_%h-%n-%s.%t'
// wstring bloat
// more like lstring
// it is literally written in C++ as L""

script screen_shot
	get_song_title \{song = $current_song}
	get_song_artist \{song = $current_song with_year = 0}
	timestamp
	formattext textname = filename "scrsh_%a_-_%t_%n" a = <song_artist> t = <song_title> n = <timestamp>
	if ScreenShot FileName = <FileName>
		printf '%f saved' f = <filename>
	else
		printf \{'Failed to save screenshot'}
	endif
endscript

script FileExists \{#"0x00000000" = ''}
	if exists <#"0x00000000">
		return \{true}
	endif
	GetPlatformExt
	// would concatenation be faster than this
	// but also cstr and wstr can't be concat together
	Formattext textname = xen "%s.%x" s = <#"0x00000000"> x = <platform_ext>
	if exists <xen>
		return \{true}
	endif
	return \{false}
endscript
script exists \{#"0x00000000" = ''}
	StartWildcardSearch wildcard = <#"0x00000000">
	begin
		if GetWildcardFile
			EndWildcardSearch
			return \{true}
		else
			break
		endif
	repeat
	EndWildcardSearch
	return \{false}
endscript

script wait_beats \{1}
	begin
		last_beat_flip = $beat_flip
		begin
			cur_beat_flip = $beat_flip
			if NOT (<last_beat_flip> = <cur_beat_flip>)
				break
			endif
			wait \{1 gameframe}
		repeat
	repeat <#"0x00000000">
endscript

script script_assert
	printf \{'ASSERT MESSAGE:'}
	ScriptAssert <...>
endscript

script restore_start_key_binding
	printf \{'+++ RESTORE START KEY'}
	SetScreenElementProps \{id = root_window event_handlers = [{pad_start gh3_start_pressed}] replace_handlers}
endscript

script kill_start_key_binding
	printf \{'--- KILL START KEY'}
	SetScreenElementProps \{id = root_window event_handlers = [{pad_start null_script}] replace_handlers}
endscript

script reload_sounds
	EnableRemoveSoundEntry \{enable}
	//stars
	//printf \{'Flashing global_sfx pak'}
	UnLoadPak \{'zones/global_sfx.pak' Heap = heap_audio}
	WaitUnloadPak \{'zones/global_sfx.pak'}
	ProfilingStart
	LoadPak \{'zones/global_sfx.pak' no_vram Heap = heap_audio}
	ProfilingEnd <...> 'LoadPak global_sfx.pak'
	//stars
	printf \{'Sfx Pak flashing done.'}
endscript

script SetValueFromConfig
	/*if NOT StructureContains structure=<...> #"0x1ca1ff20"
		#"0x1ca1ff20" = ($<out>)
		printstruct <...>
		// not working :(
	endif*///
	FGH3Config sect=<sect> <#"0x00000000"> #"0x1ca1ff20"=<#"0x1ca1ff20">
	change globalname=<out> newvalue=<value>
endscript
