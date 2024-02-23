
script EmptyScript
endscript
nullscript = $EmptyScript
empty_script = $EmptyScript

script WhyAmIBeingCalled
	printstruct <...>
	printf 'MY PRESENCE IS RUINING THIS GAME'
endscript

guitarist_info = $nullStruct
bassist_info = $nullStruct
vocalist_info = $nullStruct
drummer_info = $nullStruct

//Strum_iterator = $WhyAmIBeingCalled
//FretPos_iterator = $WhyAmIBeingCalled
//FretFingers_iterator = $WhyAmIBeingCalled
//WatchForStartPlaying_iterator = $WhyAmIBeingCalled
//Drum_iterator = $WhyAmIBeingCalled
//Drum_cymbal_iterator = $WhyAmIBeingCalled

// region fx/particle_update_scripts
/*align_scale_to_vel_update = $WhyAmIBeingCalled
align_scale_size_to_vel_update = $WhyAmIBeingCalled
align_to_vel_update = $WhyAmIBeingCalled
align_to_obj_orient = $WhyAmIBeingCalled
emitRate_Speed = $WhyAmIBeingCalled
emitRate_Size_Speed = $WhyAmIBeingCalled
rotDir_Turn = $WhyAmIBeingCalled
starPower_Butterflies = $WhyAmIBeingCalled*///
// endregion

// region fx/particle_default_params
/**/Default_Particle_LOD_Dist1 = 0
Default_Particle_LOD_Dist2 = 0
Default_Particle_Suspend_Dist = 0
Default_Particle_LOD_Dist_Pair = (0.0, 0.0)
Default_Fast_Particle_LOD_Dist1 = 0
Default_Fast_Particle_LOD_Dist2 = 0
Default_Fast_Particle_Suspend_Dist = 0
Default_Fast_Particle_LOD_Dist_Pair = (0.0, 0.0)/**///
// endregion

// region fx/lightshow
//lightshow_enabled = 0
//lightvolume_flarecutoff_low = 0.2
//lightvolume_flarecutoff_high = 0.35
//lightvolume_flarematerialcrc = FlareMaterial_FlareMaterial
//lightvolume_flaresaturate = 0.6
//lightshow_defaultblendtime = 0.15
//lightshow_coloroverrideblend = 0.4
//lightshow_offset_ms = 100
/**///
script LS_AllOff
	killspawnedscript \{id = LightShow}
	WhyAmIBeingCalled
endscript
//LS_AllOff = $WhyAmIBeingCalled

LightShow_StateNodeFlagMapping = {
	performance = {
		poor = $nullArray
		medium = $nullArray
		good = $nullArray
	}
	mood = {
		blackout = $nullArray
	}
}
/**///

//lightshow_iterator = $WhyAmIBeingCalled
// endregion

// misclightutils
/*script SafeKill
	if IsCreated <nodeName>
		kill name = <nodeName>
	endif
endscript*///

// engine/menu/keyboard
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
	GetArraySize \{$Profile_Pages}
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
						printf \{"Current CPU %c" c = $current_cpu}
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
endscript*///

// engine/menu/lighttool_launcher
/*Shadow_Volume_Settings = {
	Intensity = 0.3
	Type = modulate
	softness = 0.5
	Color = [
		0
		0
		0
	]
}
White_Noise_Settings = {
	On = 0
	Intensity = 20
	Color = [
		128
		128
		128
	]
}
ZoomBlur_Settings = {
	focus_center = [
		0.5
		0.5
	]
	scales = [
		1.5
		0.0
	]
	Angles = [
		0.0
		0.0
	]
	inner_color = [
		0.0
		0.0
		0.0
	]
	inner_alpha = 0.0
	outer_color = [
		1.0
		1.0
		1.0
	]
	outer_alpha = 0.0
}
ShaderOverrideSettings = {
	override_static = 0
	override_skinned = 0
	override_normalmapped = 0
	override_envmapped = 0
	override_uvwibble = 0
	override_pass = 0
	override_shader = 0
}*///

// region engine/menu/misctools
/*Thread0SkaterBudget = 30
Thread0RenderBudget = 30
Thread0AIBudget = 30
Thread0AIAgentBudget = 3
Thread0AINavigationBudget = 4
Thread0AIBehaviorSystemBudget = 4
Thread0AISeekBudget = 3
Thread0AIAnimTreeBudget = 10
Thread0AINavCollisionBudget = 1
Thread0BudgetAlwaysOn = 0
profiler_vblanks = -1
poly_count_on = 0

script show_poly_count
	if ($poly_count_on = 0)
		Change \{poly_count_on = 1}
		GetCurrentLevel
		refresh_map_data
	else
		Change \{poly_count_on = 0}
		if ScreenElementExists \{id = map_data_anchor}
			DestroyScreenElement \{id = map_data_anchor}
		endif
		if ScreenElementExists \{id = texture_list}
			DestroyScreenElement \{id = texture_list}
		endif
	endif
endscript

script show_render_metrics_toggle
	ToggleRenderMetrics
	if ScreenElementExists \{id = render_metric_anchor}
		DestroyScreenElement \{id = render_metric_anchor}
		DoScreenElementMorph \{id = the_score_sprite Scale = 1}
		DoScreenElementMorph \{id = the_score Scale = 1}
		show_compass_anchor
	else
		DoScreenElementMorph \{id = the_score_sprite Scale = 0}
		DoScreenElementMorph \{id = the_score Scale = 0}
	endif
endscript
force_nodelistman_metrics = 0
nodelistman_metrics_mode = 0
hi_def_globalscale = 0.6
hi_def_globalscale_gap = 0.4
low_def_globalscale = 0.8
low_def_globalscale_gap = 0.7
globalscale = 0.8
globalscale_gap = 0.7

script NodelistManMonitor_ConsoleOnly
	Change \{force_nodelistman_metrics = 1}
	Change \{nodelistman_metrics_mode = 2}
endscript

script NodelistManMonitor
	Change \{force_nodelistman_metrics = 1}
	Change \{nodelistman_metrics_mode = 0}
endscript*///
// endregion

// region engine/menu/panelmessage
/*
script kill_panel_message_if_it_exists
	if ScreenElementExists id = <id>
		DestroyScreenElement id = <id>
	endif
endscript

script kill_panel_messages
	kill_panel_message_if_it_exists \{id = panel_message_layer}
endscript

script hide_panel_messages
	if ScreenElementExists \{id = panel_message_layer}
		DoScreenElementMorph \{id = panel_message_layer alpha = 0}
	endif
endscript

script show_panel_messages
	if ScreenElementExists \{id = panel_message_layer}
		DoScreenElementMorph \{id = panel_message_layer alpha = 1}
	endif
endscript

script create_panel_message_layer_if_needed
	if NOT ScreenElementExists \{id = panel_message_layer}
		SetScreenElementLock \{id = root_window OFF}
		CreateScreenElement \{Type = ContainerElement parent = root_window id = panel_message_layer}
	endif
endscript

script create_panel_message\{text = "Default panel message" Pos = (320.0, 70.0) rgba = [100 90 80 255] font_face = text_a1 time = 1500 z_priority = -5 just = [center center] parent = panel_message_layer Scale = 0.65}
	if NOT (<font_face> = text_a1)
		<font_face> = text_a1
	endif
	if GotParam \{id}
		kill_panel_message_if_it_exists id = <id>
	endif
	create_panel_message_layer_if_needed
	SetScreenElementLock id = <parent> OFF
	CreateScreenElement {
		Type = TextElement
		parent = <parent>
		id = <id>
		font = <font_face>
		text = <text>
		Scale = <Scale>
		Pos = <Pos>
		just = <just>
		rgba = <rgba>
		z_priority = <z_priority>
		Shadow
		shadow_offs = (2.0, 2.0)
		shadow_rgba = [0 0 0 255]
		font_spacing = 2
		not_focusable
	}
	if GotParam \{style}
		if GotParam \{params}
			RunScriptOnScreenElement id = <id> <style> params = <params>
		else
			RunScriptOnScreenElement id = <id> <style> params = <...>
		endif
	else
		RunScriptOnScreenElement id = <id> panel_message_wait_and_die params = {time = <time>}
	endif
endscript

script create_panel_sprite\{Pos = (320.0, 60.0) rgba = [128 128 128 100] z_priority = -5 parent = panel_message_layer just = [center center]}
	if GotParam \{id}
		if ScreenElementExists id = <id>
			RunScriptOnScreenElement id = <id> kill_panel_message
		endif
	endif
	create_panel_message_layer_if_needed
	SetScreenElementLock id = <parent> OFF
	CreateScreenElement {
		Type = SpriteElement
		parent = <parent>
		texture = <texture>
		id = <id>
		Scale = <Scale>
		Pos = <Pos>
		just = <just>
		rgba = <rgba>
		z_priority = <z_priority>
		blend = <blend>
	}
	if GotParam \{style}
		if GotParam \{params}
			RunScriptOnScreenElement id = <id> <style> params = <params>
		else
			RunScriptOnScreenElement id = <id> <style> params = <...>
		endif
	else
		if GotParam \{time}
			RunScriptOnScreenElement id = <id> panel_message_wait_and_die params = {time = <time>}
		endif
	endif
endscript

script create_panel_block\{text = "Default panel message" Pos = (320.0, 240.0) dims = (250.0, 0.0) rgba = [100 90 80 255] font_face = text_a1 time = 2000 just = [center center] internal_just = [center center] z_priority = -5 Scale = 0.125 parent = panel_message_layer}
	create_panel_message_layer_if_needed
	SetScreenElementLock id = <parent> OFF
	if GotParam \{id}
		if ScreenElementExists id = <id>
			DestroyScreenElement id = <id>
		endif
	endif
	CreateScreenElement {
		Type = TextBlockElement
		parent = <parent>
		id = <id>
		font = <font_face>
		text = <text>
		dims = <dims>
		Pos = <Pos>
		just = <just>
		internal_just = <internal_just>
		line_spacing = <line_spacing>
		rgba = <rgba>
		Scale = <Scale>
		Shadow
		shadow_rgba = $UI_text_shadow_color
		shadow_offs = $UI_text_shadow_offset
		allow_expansion
		z_priority = <z_priority>
	}
	if GotParam \{style}
		if GotParam \{params}
			RunScriptOnScreenElement id = <id> <style> params = <params>
		else
			RunScriptOnScreenElement id = <id> <style> params = <...>
		endif
	else
		if NOT GotParam \{hold}
			RunScriptOnScreenElement id = <id> panel_message_wait_and_die params = {time = <time>}
		endif
	endif
endscript

script create_intro_panel_block\{text = "Default intro panel message" Pos = (320.0, 60.0) dims = (250.0, 0.0) rgba = [100 90 80 255] font_face = text_a1 time = 2000 just = [center center] internal_just = [center center] z_priority = -5 Scale = 0.5 parent = panel_message_layer}
	create_panel_message_layer_if_needed
	SetScreenElementLock id = <parent> OFF
	if GotParam \{id}
		if ScreenElementExists id = <id>
			DestroyScreenElement id = <id>
		endif
	endif
	CreateScreenElement {
		Type = ContainerElement
		parent = <parent>
		id = <id>
		Pos = (0.0, 0.0)
	}
	<the_id> = <id>
	CreateScreenElement {
		Type = TextBlockElement
		parent = <the_id>
		font = <font_face>
		text = <text>
		dims = <dims>
		Pos = <Pos>
		just = <just>
		internal_just = <internal_just>
		line_spacing = <line_spacing>
		rgba = <rgba>
		Scale = <Scale>
		Shadow
		shadow_rgba = $UI_text_shadow_color
		shadow_offs = $UI_text_shadow_offset
		allow_expansion
		z_priority = (<z_priority> + 3)
	}
	grad_color = [17 67 92 255]
	if GotParam \{create_bg}
		CreateScreenElement {
			Type = SpriteElement
			parent = <the_id>
			texture = goal_grad
			Pos = (<Pos> + (300.0, 0.0))
			Scale = (21.0, 10.0)
			just = [center center]
			rgba = <grad_color>
			alpha = 0.4
			z_priority = (<z_priority> + 1)
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = <the_id>
			texture = goal_grad
			Pos = (<Pos> + (300.0, -20.0))
			Scale = (21.0, 1.0)
			just = [center center]
			rgba = <grad_color>
			alpha = 0.6
			z_priority = (<z_priority> + 1)
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = <the_id>
			texture = goal_grad
			Pos = (<Pos> + (300.0, 20.0))
			Scale = (21.0, 1.0)
			just = [center center]
			rgba = <grad_color>
			alpha = 0.6
			flip_v
			z_priority = (<z_priority> + 1)
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = <the_id>
			Pos = (<Pos> + (320.0, 0.0))
			just = [center center]
			Scale = (13.0, 1.0)
			texture = roundbar_middle
			z_priority = (<z_priority> + 2)
			rgba = [128 128 128 20]
		}
		GetScreenElementPosition id = <id>
		GetScreenElementDims id = <id>
		CreateScreenElement {
			Type = SpriteElement
			parent = <the_id>
			Pos = (<ScreenElementPos> + (-16.0, 16.0))
			just = [center center]
			Scale = 1
			texture = roundbar_tip_left
			z_priority = (<z_priority> + 2)
			rgba = [128 128 128 20]
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = <the_id>
			Pos = (<ScreenElementPos> + <width> * (1.0, 0.0) + (16.0, 16.0))
			just = [center center]
			Scale = 1
			texture = roundbar_tip_right
			z_priority = (<z_priority> + 2)
			rgba = [128 128 128 20]
		}
	endif
	if GotParam \{style}
		if GotParam \{params}
			RunScriptOnScreenElement id = <the_id> <style> params = <params>
		else
			RunScriptOnScreenElement id = <the_id> <style> params = <...>
		endif
	else
		RunScriptOnScreenElement id = <the_id> panel_message_wait_and_die params = {time = <time>}
	endif
endscript

script panel_message_wait_and_die\{time = 1500}
	wait <time> ignoreslomo
	Die
endscript

script kill_panel_message
	Die
endscript

script hide_panel_message
	if ScreenElementExists id = <id>
		SetScreenElementProps {
			id = <id>
			Hide
		}
		<id> ::DoMorph alpha = 0
	endif
endscript

script show_panel_message
	if ScreenElementExists id = <id>
		SetScreenElementProps {
			id = <id>
			unhide
		}
		<id> ::DoMorph alpha = 1
	endif
endscript

script destroy_panel_message
	if ScreenElementExists id = <id>
		<id> ::Die
	endif
endscript*///
// endregion

// engine/movies
//script MovieDisplaySubtitles
//endscript

// engine/animevents
AnimTagTable = {
}
PreloadWinAnimStream_GuitaristID = -1
PreloadWinAnimStream_BassistID = -1

script PreloadWinAnimStream
endscript

script PlayPreLoadedWinAnimStream
endscript

// region engine/load_level
fake_net = 0
AssertOnMissingScripts = 0
AssertOnMissingAssets = 1
AlwaysDump = 0
next_level_script = nullscript
ClassicModeNavMeshLoaded = 0
dont_call_zone_init_hack = 0
levels_initialize_goals = 1

/*script zone_init
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
	GetArraySize \{$LOD_LoadedPaks}
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
endscript*///
// endregion

// region game/igc/igccameradetails
//debug_igc_camera = 0
//igc_camera_show_frame_info = 0
// endregion

// game/menu/animpreview
//ReloadAnimation = $WhyAmIBeingCalled

