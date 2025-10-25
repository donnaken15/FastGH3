
script UnloadPakAsync
	//printf 'UnloadPakAsync : %s on heap %a async=%i' s = <pak_name> a = <Heap> i = <async>
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
	//printf 'LoadPakAsync : %s on heap %a async=%i' s = <pak_name> a = <Heap> i = <async>
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
			printf \{'Downloads_OpenContentFolder FAILED'}
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
	printf \{'LoadPakAsync_callback'}
	//printstruct <...>
	if NOT (<result> = 0)
		Change \{character_pak_loadpak_done = 1}
		Change \{character_pak_loadpak_failed = 1}
	endif
	if GotParam \{end}
		Change \{character_pak_loadpak_done = 1}
	endif
endscript
