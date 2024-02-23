check_for_unplugged_controllers = 0
AnimLODInterleave2 = 12
AnimLODInterleave4 = 9
PS3_AnimLODInterleave2 = 20
PS3_AnimLODInterleave4 = 12
Xenon_AnimLODInterleave2 = 20
Xenon_AnimLODInterleave4 = 12

/*script autolaunch
	if GotParam \{level}
		Change current_level = <level>
		startnow = 2
	endif
	if GotParam \{song}
		Change current_song = <song>
		startnow = 1
	endif
	if GotParam \{difficulty}
		Change current_difficulty = <difficulty>
		startnow = 1
	endif
	if GotParam \{difficulty2}
		Change current_difficulty2 = <difficulty2>
		startnow = 1
	endif
	if GotParam \{startTime}
		Change current_starttime = <startTime>
		startnow = 1
	endif
	if GotParam \{controller}
		Change StructureName = player1_status controller = <controller>
		Change player1_device = <controller>
		Change primary_controller = <controller>
		startnow = 1
	endif
	if GotParam \{controller2}
		Change StructureName = player2_status controller = <controller2>
		startnow = 1
	endif
	if GotParam \{game_mode}
		Change game_mode = <game_mode>
		if ($game_mode = p2_faceoff || $game_mode = p2_pro_faceoff)
			Change \{current_num_players = 2}
		endif
		startnow = 1
	endif
	if GotParam \{startnow}
		SetGlobalTags \{Progression params = {current_tier = 1}}
		SetGlobalTags \{Progression params = {current_song_count = 0}}
		Change autolaunch_startnow = <startnow>
	endif
	translate_gamemode
endscript

script change_level
	script_assert \{"This is now gone..."}
endscript*///

script KillElement3d
	wait \{1 gameframe}
	Die
endscript

script setup_ped_speech
endscript

script script_assert
	printf \{"ASSERT MESSAGE:"}
	ScriptAssert <...>
endscript

script nullscript
endscript

script DumpMetrics
	GetMetrics // crashing
	printf
	printf \{"Dumping Metrics Structure"}
	printstruct <...>
endscript
dummy_metrics_struct = {
	mainscene = 0
	skyscene = 0
	metrics = 0
	Sectors = 0
	ColSectors = 0
	Verts = 0
	BasePolys = 0
	TextureMemory = 0
}

script SetSkaterCamOverride
	GetSkaterCam
	<skatercam> ::SC_SetSkaterCamOverride <...>
endscript

script ClearSkaterCamOverride
	GetSkaterCam
	<skatercam> ::SC_ClearSkaterCamOverride <...>
endscript

script empty_script
endscript

script restore_start_key_binding
	printf \{"+++ RESTORE START KEY"}
	SetScreenElementProps \{id = root_window event_handlers = [{pad_start gh3_start_pressed}] replace_handlers}
endscript

script kill_start_key_binding
	printf \{"--- KILL START KEY"}
	SetScreenElementProps \{id = root_window event_handlers = [{pad_start null_script}] replace_handlers}
endscript

script BlockPendingPakManLoads\{map = all block_scripts = 0 noparse = 0}
	if (<block_scripts> = 1)
		PendingPakManLoads map = <map> block_scripts = 1 noparse = <noparse>
		if GotParam \{loaderror}
			return \{FALSE}
		endif
		return \{true}
	endif
	begin
		if NOT (PendingPakManLoads map = <map> noparse = <noparse>)
			break
		endif
		wait \{1 gameframe}
	repeat
	if GotParam \{loaderror}
		return \{FALSE}
	endif
	return \{true}
endscript

script SetPakManCurrentBlock\{block_scripts = 0 noparse = 0}
	SetPakManCurrent map = <map> pak = <pak> pakname = <pakname>
	if NOT BlockPendingPakManLoads map = <map> block_scripts = <block_scripts> noparse = <noparse>
		return \{FALSE}
	endif
	GetPakManCurrentName \{map = zones}
	if GotParam \{pakname}
		FormatText checksumName = zone_setup '%s_setup' s = <pakname>
		if ScriptExists <zone_setup>
			spawnscriptnow <zone_setup>
		endif
	endif
	set_hidebytype
	return \{true}
endscript

script RefreshPakManCurrent
	SetPakManCurrentBlock map = <map> pak = <pak> pakname = <pakname>
endscript

/*script Zones_PakMan_Init
	printf \{"Zones_PakMan_Init"}
	zone_name = <pak_name>
	zone_string_name = <pak_string_name>
	FormatText checksumName = sfx_zone_name '%z_sfx' z = <zone_string_name>
	FormatText checksumName = gfx_zone_name '%z_gfx' z = <zone_string_name>
	FormatText checksumName = lfx_zone_name '%z_lfx' z = <zone_string_name>
	FormatText checksumName = mfx_zone_name '%z_mfx' z = <zone_string_name>
	FormatText checksumName = array_name '%z_NodeArray' z = <zone_string_name>
	FormatText checksumName = sfx_array_name '%z_SFX_NodeArray' z = <zone_string_name>
	FormatText checksumName = gfx_array_name '%z_GFX_NodeArray' z = <zone_string_name>
	FormatText checksumName = lfx_array_name '%z_LFX_NodeArray' z = <zone_string_name>
	FormatText checksumName = mfx_array_name '%z_MFX_NodeArray' z = <zone_string_name>
	zone_init <...>
	FormatText checksumName = script_zone_init '%z_init' z = <zone_string_name>
	FormatText checksumName = script_zone_sfx_init '%z_sfx_init' z = <zone_string_name>
	FormatText checksumName = script_zone_gfx_init '%z_gfx_init' z = <zone_string_name>
	FormatText checksumName = script_zone_lfx_init '%z_lfx_init' z = <zone_string_name>
	FormatText checksumName = script_zone_mfx_init '%z_mfx_init' z = <zone_string_name>
	if ScriptExists <script_zone_init>
		<script_zone_init>
	endif
	if ScriptExists <script_zone_sfx_init>
		<script_zone_sfx_init>
	endif
	if ScriptExists <script_zone_gfx_init>
		<script_zone_gfx_init>
	endif
	if ScriptExists <script_zone_lfx_init>
		<script_zone_lfx_init>
	endif
	if ScriptExists <script_zone_mfx_init>
		<script_zone_mfx_init>
	endif
	UpdatePakManVisibility \{map = zones}
	printf \{"Zones_PakMan_Init end"}
endscript

script Zones_PakMan_DeInit
	printf \{"Zones_PakMan_DeInit"}
	zone_name = <pak_name>
	zone_string_name = <pak_string_name>
	FormatText checksumName = sfx_zone_name '%z_sfx' z = <zone_string_name>
	FormatText checksumName = gfx_zone_name '%z_gfx' z = <zone_string_name>
	FormatText checksumName = lfx_zone_name '%z_lfx' z = <zone_string_name>
	FormatText checksumName = mfx_zone_name '%z_mfx' z = <zone_string_name>
	FormatText checksumName = array_name '%z_NodeArray' z = <zone_string_name>
	FormatText checksumName = sfx_array_name '%z_SFX_NodeArray' z = <zone_string_name>
	FormatText checksumName = gfx_array_name '%z_GFX_NodeArray' z = <zone_string_name>
	FormatText checksumName = lfx_array_name '%z_LFX_NodeArray' z = <zone_string_name>
	FormatText checksumName = mfx_array_name '%z_MFX_NodeArray' z = <zone_string_name>
	zone_deinit <...>
	FormatText checksumName = script_zone_deinit '%z_deinit' z = <zone_string_name>
	FormatText checksumName = script_zone_sfx_deinit '%z_sfx_deinit' z = <zone_string_name>
	FormatText checksumName = script_zone_gfx_deinit '%z_gfx_deinit' z = <zone_string_name>
	FormatText checksumName = script_zone_lfx_deinit '%z_lfx_deinit' z = <zone_string_name>
	FormatText checksumName = script_zone_mfx_deinit '%z_mfx_deinit' z = <zone_string_name>
	if ScriptExists <script_zone_deinit>
		<script_zone_deinit>
	endif
	if ScriptExists <script_zone_sfx_deinit>
		<script_zone_sfx_deinit>
	endif
	if ScriptExists <script_zone_gfx_deinit>
		<script_zone_gfx_deinit>
	endif
	if ScriptExists <script_zone_lfx_deinit>
		<script_zone_lfx_deinit>
	endif
	if ScriptExists <script_zone_mfx_deinit>
		<script_zone_mfx_deinit>
	endif
	DestroyParticlesByGroupID \{groupID = zoneparticles}
	DestroyZoneEntities zone_name = <zone_name> zone_string_name = <zone_string_name>
	UpdatePakManVisibility \{map = zones}
	printf \{"Zones_PakMan_DeInit end"}
endscript*///
