loaded_body_heaps = [
	None
	None
	None
	None
]
loaded_body_paks = [
	None
	None
	None
	None
]
loaded_body_paks_ref_counts = [
	0
	0
	0
	0
]
loaded_anim_heaps = [
	None
	None
	None
	None
]
loaded_anim_paks = [
	None
	None
	None
	None
]
loaded_anim_paks_ref_counts = [
	0
	0
	0
	0
]
loaded_instrument_heaps = [
	None
	None
	None
	None
]
loaded_instrument_paks = [
	None
	None
	None
	None
]
loaded_instrument_paks_ref_counts = [
	0
	0
	0
	0
]
guitarist_body_pak_file = no_pak_id
guitarist_anim_pak_file = no_pak_id
guitarist_instrument_pak_file = no_pak_id
bassist_body_pak_file = no_pak_id
bassist_anim_pak_file = no_pak_id
bassist_instrument_pak_file = no_pak_id
vocalist_body_pak_file = no_pak_id
vocalist_anim_pak_file = no_pak_id
vocalist_instrument_pak_file = no_pak_id
drummer_body_pak_file = no_pak_id
drummer_anim_pak_file = no_pak_id
drummer_instrument_pak_file = no_pak_id
character_pak_crc_to_text = {
	GUITARIST = 'guitarist'
	BASSIST = 'bassist'
	vocalist = 'vocalist'
	drummer = 'drummer'
	Body = 'body'
	anim = 'anim'
	instrument = 'instrument'
}
musician_arrays = {
	Body = {
		pak_type = musician_body
		size_func = get_musician_body_size
		access_func = get_musician_body_struct
		element = pak
	}
	anim = {
		pak_type = musician_body
		size_func = get_musician_body_size
		access_func = get_musician_body_struct
		element = anims_pak
	}
	instrument = {
		pak_type = musician_instrument
		size_func = get_musician_instrument_size
		access_func = get_musician_instrument_struct
		element = pak
	}
}

script get_num_free_character_pak_slots
	pak_type = ($character_pak_crc_to_text.<Type>)
	FormatText checksumName = loaded_paks_ref_counts 'loaded_%p_paks_ref_counts' p = <pak_type>
	GetArraySize $<loaded_paks_ref_counts>
	index = 0
	freeslots = (<freeslots> + 1)
	begin
		ref_count = ($<loaded_paks_ref_counts> [<index>])
		if (<ref_count> = 0)
			freeslots = (<freeslots> + 1)
		endif
		index = (<index> + 1)
	repeat <array_Size>
	return freeslots = <freeslots>
endscript

script get_pak_filename
	AddParams ($musician_arrays.<Type>)
	<size_func>
	found = 0
	index = 0
	begin
		<access_func> index = <index>
		if ((<info_struct>.desc_id)= <desc_id>)
			if StructureContains structure = (<info_struct>)<element>
				pak_name = (<info_struct>.<element>)
				found = 1
			else
				return found = 0 pak_index = <index>
			endif
			break
		endif
		index = (<index> + 1)
	repeat <array_Size>
	if (<found> = 0)
		if ($Cheat_AirGuitar = 1)
			return found = 0 pak_index = <index>
		endif
		printstruct <...>
		printf \{"Pak filename not found"}
	endif
	return found = <found> pak_index = <index> pak_name = <pak_name>
endscript

script get_pak_filename_using_filename_crc
	AddParams ($musician_arrays.<Type>)
	<size_func>
	found = 0
	index = 0
	begin
		<access_func> index = <index>
		FormatText checksumName = filename_crc '%s' s = (<info_struct>.<element>)
		if (<filename_crc> = <pak_crc>)
			if StructureContains structure = (<info_struct>)<element>
				pak_name = (<info_struct>.<element>)
				found = 1
			else
				return found = 0 pak_index = <index>
			endif
			break
		endif
		index = (<index> + 1)
	repeat <array_Size>
	return found = <found> pak_index = <index> pak_name = <pak_name>
endscript

script unload_musician_pak_file
	pak_type = ($character_pak_crc_to_text.<Type>)
	FormatText checksumName = loaded_paks_ref_counts 'loaded_%p_paks_ref_counts' p = <pak_type>
	if NOT (<desc_id> = no_pak_id)
		find_loaded_pak_file desc_id = <desc_id> Type = <Type>
		if (<found> = 1)
			ref_count = ($<loaded_paks_ref_counts> [<pak_index>])
			new_ref_count = (<ref_count> - 1)
			SetArrayElement ArrayName = <loaded_paks_ref_counts> GlobalArray index = <pak_index> NewValue = <new_ref_count>
		else
			FormatText checksumName = loaded_paks 'loaded_%p_paks' p = <pak_type>
			FormatText checksumName = loaded_heaps 'loaded_%p_heaps' p = <pak_type>
			printstruct <...>
			printstruct ($<loaded_heaps>)
			printstruct ($<loaded_paks>)
			printstruct ($<loaded_paks_ref_counts>)
			ScriptAssert \{"Loaded Asset not found"}
		endif
	endif
endscript

script force_unload_all_character_paks\{async = 0}
	force_unload_all_character_paks_by_type <...> Type = Body
	force_unload_all_character_paks_by_type <...> Type = anim
	force_unload_all_character_paks_by_type <...> Type = instrument
endscript

script force_unload_all_character_paks_by_type
	pak_type = ($character_pak_crc_to_text.<Type>)
	FormatText checksumName = loaded_paks 'loaded_%p_paks' p = <pak_type>
	FormatText checksumName = loaded_paks_ref_counts 'loaded_%p_paks_ref_counts' p = <pak_type>
	GetArraySize $<loaded_paks>
	index = 0
	begin
		next_pak = ($<loaded_paks> [<index>])
		if NOT (<next_pak> = None)
			get_pak_filename_using_filename_crc pak_crc = <next_pak> Type = <Type>
			if (<found> = 1)
				UnloadPakAsync pak_name = <pak_name> Heap = BottomUpHeap async = <async>
			endif
			SetArrayElement ArrayName = <loaded_paks_ref_counts> GlobalArray index = <index> NewValue = 0
			SetArrayElement ArrayName = <loaded_paks> GlobalArray index = <index> NewValue = None
		endif
		index = (<index> + 1)
	repeat <array_Size>
endscript

script load_musician_pak_file\{startslot = 0}
	if NOT (GotParam Profile)
		ScriptAssert \{"Need profile of musician type"}
	endif
	pak_type = ($character_pak_crc_to_text.<Type>)
	FormatText checksumName = loaded_paks_ref_counts 'loaded_%p_paks_ref_counts' p = <pak_type>
	FormatText checksumName = loaded_paks 'loaded_%p_paks' p = <pak_type>
	FormatText checksumName = loaded_heaps 'loaded_%p_heaps' p = <pak_type>
	AddParams ($musician_arrays.<Type>)
	desc_id = ((<Profile>.<pak_type>).desc_id)
	get_pak_filename desc_id = <desc_id> Type = <Type>
	if (<found> = 0)
		return \{filename_crc = no_pak_id AssetContext = 0 true}
	endif
	FormatText checksumName = filename_crc '%s' s = <pak_name> AddToStringLookup = true
	if (<Type> = Body)
		get_musician_body_struct index = <pak_index>
		AssetContext = (<info_struct>.asset_context)
		printf channel = AnimInfo "loaded pak has asset context %a ................" a = <AssetContext>
	else
		AssetContext = 0
	endif
	find_loaded_pak_file desc_id = <filename_crc> Type = <Type>
	if (<found> = 1)
		ref_count = ($<loaded_paks_ref_counts> [<pak_index>])
		if (<ref_count> = 0)
		endif
		new_ref_count = (<ref_count> + 1)
		SetArrayElement ArrayName = <loaded_paks_ref_counts> GlobalArray index = <pak_index> NewValue = <new_ref_count>
	else
		GetArraySize $<loaded_paks_ref_counts>
		index = <startslot>
		begin
			ref_count = ($<loaded_paks_ref_counts> [<index>])
			if (<ref_count> = 0)
				unused_pak = ($<loaded_paks> [<index>])
				SetArrayElement ArrayName = <loaded_paks_ref_counts> GlobalArray index = <index> NewValue = 0
				SetArrayElement ArrayName = <loaded_paks> GlobalArray index = <index> NewValue = None
				if NOT (<unused_pak> = None)
					get_pak_filename_using_filename_crc pak_crc = <unused_pak> Type = <Type>
					if (<found> = 1)
						UnloadPakAsync pak_name = <pak_name> Heap = BottomUpHeap async = <async>
					endif
				else
					printf \{"slot not yet assigned...."}
				endif
				break
			endif
			index = (<index> + 1)
		repeat <array_Size>
		if (<index> = <array_Size>)
			ScriptAssert \{"Spare slot not found"}
		endif
		get_pak_filename desc_id = <desc_id> Type = <Type>
		if (<found> = 1)
			if NOT LoadPakAsync pak_name = <pak_name> Heap = ($<loaded_heaps> [<index>])async = <async>
				return \{FALSE}
			else
				SetArrayElement ArrayName = <loaded_paks_ref_counts> GlobalArray index = <index> NewValue = 1
				SetArrayElement ArrayName = <loaded_paks> GlobalArray index = <index> NewValue = <filename_crc>
			endif
		endif
	endif
	return filename_crc = <filename_crc> AssetContext = <AssetContext> true
endscript

script find_loaded_pak_file
	pak_type = ($character_pak_crc_to_text.<Type>)
	FormatText checksumName = loaded_paks 'loaded_%p_paks' p = <pak_type>
	GetArraySize $<loaded_paks>
	found = 0
	index = 0
	begin
		if (($<loaded_paks> [<index>])= <desc_id>)
			found = 1
			break
		endif
		index = (<index> + 1)
	repeat <array_Size>
	return found = <found> pak_index = <index>
endscript

script dump_pak_info
	dump_pak_info_by_type \{Type = Body}
	dump_pak_info_by_type \{Type = anim}
	dump_pak_info_by_type \{Type = instrument}
endscript

script dump_pak_info_by_type
	pak_type = ($character_pak_crc_to_text.<Type>)
	printf \{"------------------------------------------------------------"}
	printf "dumping %t pak information" t = <pak_type>
	printf \{" "}
	FormatText checksumName = loaded_paks_ref_counts 'loaded_%p_paks_ref_counts' p = <pak_type>
	FormatText checksumName = loaded_paks 'loaded_%p_paks' p = <pak_type>
	FormatText checksumName = loaded_heaps 'loaded_%p_heaps' p = <pak_type>
	index = 0
	begin
		body_pak = ($<loaded_paks> [<index>])
		ref_count = ($<loaded_paks_ref_counts> [<index>])
		printf "loaded_%t_paks[%a] = %b (%c) ...." a = <index> b = <body_pak> c = <ref_count> t = <pak_type>
		index = (<index> + 1)
	repeat 4
endscript

script UnloadPakAsync
	printf "UnloadPakAsync : %s on heap %a async=%i" s = <pak_name> a = <Heap> i = <async>
	UnLoadPak <pak_name> Heap = <Heap>
	if (<async> = 1)
		begin
			if WaitUnloadPak <pak_name> noblock
				break
			endif
			wait \{1 gameframe}
		repeat
	else
		WaitUnloadPak <pak_name> Block
	endif
endscript
character_pak_loadpak_lock = 0
character_pak_loadpak_done = 0
character_pak_loadpak_failed = 0

script LoadPakAsync
	printf "LoadPakAsync : %s on heap %a async=%i" s = <pak_name> a = <Heap> i = <async>
	begin
		if ($character_pak_loadpak_lock = 0)
			break
		endif
		wait \{1 gameframe}
	repeat
	Change \{character_pak_loadpak_lock = 1}
	Change \{character_pak_loadpak_done = 0}
	Change \{character_pak_loadpak_failed = 0}
	GetContentFolderIndexFromFile <pak_name>
	if (<device> = content)
		if NOT Downloads_OpenContentFolder content_index = <content_index>
			printf \{"Downloads_OpenContentFolder FAILED"}
			Change \{character_pak_loadpak_lock = 0}
			Change \{character_pak_loadpak_done = 0}
			return \{FALSE}
		endif
	endif
	if (<async> = 0)
		if (GotParam no_vram)
			if NOT LoadPak <pak_name> Heap = <Heap> device = <device> no_vram
				Change \{character_pak_loadpak_failed = 1}
			endif
		else
			if NOT LoadPak <pak_name> Heap = <Heap> device = <device>
				Change \{character_pak_loadpak_failed = 1}
			endif
		endif
		Change \{character_pak_loadpak_done = 1}
	else
		if (GotParam no_vram)
			LoadPak <pak_name> Heap = <Heap> load_callback = LoadPakAsync_callback callback_data = None device = <device> no_vram
		else
			LoadPak <pak_name> Heap = <Heap> load_callback = LoadPakAsync_callback callback_data = None device = <device>
		endif
	endif
	begin
		if ($character_pak_loadpak_done = 1)
			break
		endif
		wait \{1 gameframe}
	repeat
	if (<device> = content)
		Downloads_CloseContentFolder content_index = <content_index>
		if ($character_pak_loadpak_failed = 1)
			Change \{character_pak_loadpak_lock = 0}
			Change \{character_pak_loadpak_done = 0}
			return \{FALSE}
		endif
	endif
	Change \{character_pak_loadpak_lock = 0}
	Change \{character_pak_loadpak_done = 0}
	return \{true}
endscript

script LoadPakAsync_callback
	printf \{"LoadPakAsync_callback"}
	printstruct <...>
	if NOT (<result> = 0)
		Change \{character_pak_loadpak_done = 1}
		Change \{character_pak_loadpak_failed = 1}
	endif
	if GotParam \{end}
		Change \{character_pak_loadpak_done = 1}
	endif
endscript
