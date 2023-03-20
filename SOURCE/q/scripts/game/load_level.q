fake_net = 0
AssertOnMissingScripts = 0
AssertOnMissingAssets = 1
AlwaysDump = 0
next_level_script = nullscript
ClassicModeNavMeshLoaded = 0
dont_call_zone_init_hack = 0
levels_initialize_goals = 1

script zone_init
	printf "zone_init: %s" s = <zone_string_name>
	if (<zone_string_name> = 'z_viewer')
		printf \{"AssertOnMissingScripts = 0"}
		Change \{AssertOnMissingScripts = 0}
	endif
	MemPushContext \{TopDownHeap}
	FormatText textname = zone_editable_text checksumName = zone_editable_list '%a%b' a = <zone_string_name> b = '_editable_list'
	if GlobalExists name = <zone_editable_list> Type = array
		AddEditableList <zone_editable_list>
	endif
	MemPopContext
	MemPushContext \{BottomUpHeap}
	ParseNodeArray {
		queue
		zone_name = <zone_name>
		array_name = <array_name>
	}
	if GotParam \{sfx_array_name}
		ParseNodeArray {
			queue
			zone_name = <sfx_zone_name>
			array_name = <sfx_array_name>
		}
	endif
	if GotParam \{gfx_array_name}
		ParseNodeArray {
			queue
			zone_name = <gfx_zone_name>
			array_name = <gfx_array_name>
		}
	endif
	if GotParam \{lfx_array_name}
		ParseNodeArray {
			queue
			zone_name = <lfx_zone_name>
			array_name = <lfx_array_name>
		}
	endif
	if GotParam \{mfx_array_name}
		ParseNodeArray {
			queue
			zone_name = <mfx_zone_name>
			array_name = <mfx_array_name>
		}
	endif
	if NOT ($disable_global_pedestrians = 1)
		if NOT InNetGame
			if IsCOIMInited
			endif
		endif
	endif
	MemPopContext
endscript

script zone_init_wait_run_setup
	begin
		if NOT NodeArrayBusy
			break
		endif
		wait \{1 gameframe}
	repeat
	if ScriptExists <zone_setup_script>
		<zone_setup_script>
	endif
endscript

script goal_pak_init
	printf "goal_pak_init: %s" s = <goal_pak_string_name>
	MemPushContext \{TopDownHeap}
	FormatText textname = goal_pak_editable_text checksumName = goal_pak_editable_list '%a%b' a = <goal_pak_string_name> b = '_editable_list'
	if GlobalExists name = <goal_pak_editable_list> Type = array
		AddEditableList <goal_pak_editable_list>
	endif
	MemPopContext
	MemPushContext <heap_name>
	ParseNodeArray {
		queue
		zone_name = <goal_pak_name>
		array_name = <array_name>
		Heap = <heap_name>
	}
	if GotParam \{sfx_array_name}
		ParseNodeArray {
			queue
			zone_name = <sfx_goal_pak_name>
			array_name = <sfx_array_name>
			Heap = <heap_name>
		}
	endif
	if GotParam \{gfx_array_name}
		ParseNodeArray {
			queue
			zone_name = <gfx_goal_pak_name>
			array_name = <gfx_array_name>
			Heap = <heap_name>
		}
	endif
	if GotParam \{lfx_array_name}
		ParseNodeArray {
			queue
			zone_name = <lfx_goal_pak_name>
			array_name = <lfx_array_name>
			Heap = <heap_name>
		}
	endif
	if GotParam \{mfx_array_name}
		ParseNodeArray {
			queue
			zone_name = <mfx_goal_pak_name>
			array_name = <mfx_array_name>
			Heap = <heap_name>
		}
	endif
	MemPopContext
endscript

script zone_deinit
	printf "zone_deinit: %s" s = <zone_string_name>
	ParseNodeArray abort array_name = <array_name>
	if GotParam \{sfx_array_name}
		ParseNodeArray abort array_name = <sfx_array_name>
	endif
	if GotParam \{gfx_array_name}
		ParseNodeArray abort array_name = <gfx_array_name>
	endif
	if GotParam \{lfx_array_name}
		ParseNodeArray abort array_name = <lfx_array_name>
	endif
	if GotParam \{mfx_array_name}
		ParseNodeArray abort array_name = <mfx_array_name>
	endif
	FormatText textname = zone_editable_text checksumName = zone_editable_list '%a%b' a = <zone_string_name> b = '_editable_list'
	if GlobalExists name = <zone_editable_list> Type = array
		RemoveEditableList <zone_editable_list>
	endif
endscript

script SetupCOIM
	PushMemProfile \{'COIM'}
	InitCOIM {
		size = <size>
		BlockAlign = $Generic_COIM_BlockAlign
		COIM_Min_Scratch_Blocks
		$Generic_COIM_Params
	}
	PopMemProfile
endscript

script LOD_InLevelList
	GetArraySize <level_list>
	<index> = 0
	begin
		FormatText checksumName = nameone '%s' s = <name>
		FormatText checksumName = nametwo '%s' s = (<level_list> [<index>])
		if (<nameone> = <nametwo>)
			printf "Found %s in LOD list! So using lods..." s = <name>
			return \{true}
		endif
		<index> = (<index> + 1)
	repeat <array_Size>
	return \{FALSE}
endscript

script LoadLODPaks
	MemPushContext \{BottomUpHeap}
	printf "LoadLODPaks - %s" s = <name>
	GetUpperCaseString <name>
	if LOD_InLevelList name = <uppercasestring> level_list = <level_list>
		GetArraySize <level_list>
		<index> = 0
		begin
			level = (<level_list> [<index>])
			FormatText textname = lod_pak 'zones/%s_lod/%s_lod.pak' s = <level>
			printf "Loading - %s" s = <lod_pak>
			FormatText checksumName = lod_name '%s_lod' s = <level>
			LoadPak <lod_pak>
			ParseNodeArray
			<index> = (<index> + 1)
		repeat <array_Size>
		Change LOD_LoadedPaks = <level_list>
	endif
	MemPopContext
endscript

script UnloadLODPaks
	GetArraySize \{$#"0x13e0579f"}
	if NOT (<array_Size> = 0)
		<index> = 0
		begin
			level = ($LOD_LoadedPaks [<index>])
			FormatText textname = lod_pak 'zones/%s_lod/%s_lod.pak' s = <level>
			printf "Unloading - %s" s = <lod_pak>
			UnLoadPak <lod_pak>
			<index> = (<index> + 1)
		repeat <array_Size>
		Change \{LOD_LoadedPaks = []}
	endif
endscript
