player1_status = {}
player2_status = {}
p1_lefty = 0
p2_lefty = 0
show_gpu_time = 1
output_gpu_log = 0
show_cpu_time = 1
show_play_log = 0
play_log_lines = 10
show_guitar_tilt = 0
nxwatson_channels = 1
output_song_stats = 1
show_sensor_debug = 0
player1_device = 0
player2_device = 1
current_song = fastgh3
current_difficulty = expert
current_difficulty2 = expert
current_level = load_z_viewer
current_highway = highway
current_time = 0.0
current_deltatime = 0.0167
current_starttime = 0
current_endtime = 0
current_looppoint = -1000000
current_speedfactor = 1.0
autolaunch_startnow = 1
current_song_qpak = None
current_band = 1
current_transition = fastintro
current_num_players = 1
max_num_players = 2
num_players_finished = 0
disable_band = 1
disable_crowd = 1
disable_note_input = 0
tutorial_disable_hud = 0
is_network_game = 0
net_ready_to_start = 0
rich_presence_context = presence_main_menu
game_mode = p1_quickplay
skip_boot_menu = 0
show_movies = 0
is_demo_mode = 0
downloadcontent_enabled = 1
input_mode = record
replay_suspend = 1
current_boss = Boss_Props
boss_battle = 0
boss_controller = 0
boss_oldcontroller = 0
boss_pattern = 0
boss_strum = 0
boss_lastwhammytime = 0
boss_lastbrokenstringtime = 0
last_bossresponse_array_entry = 0
faceoff_enabled = 0
faceoff_note_array_p1 = None
faceoff_note_array_p2 = None
faceoff_note_array_count_p1 = 0
faceoff_note_array_count_p2 = 0
faceoff_note_array_size_p1 = 0
faceoff_note_array_size_p2 = 0
faceoff_note_time_p1 = 0
faceoff_note_time_p2 = 0
faceoff_time_offset_p1 = 0
faceoff_time_offset_p2 = 0
faceoffv_note_array_p1 = None
faceoffv_note_array_p2 = None
faceoffv_note_array_count_p1 = 0
faceoffv_note_array_count_p2 = 0
faceoffv_note_array_size_p1 = 0
faceoffv_note_array_size_p2 = 0
faceoffv_note_time_p1 = 0
faceoffv_note_time_p2 = 0
faceoffv_note_on_p1 = 0
faceoffv_note_on_p2 = 0
faceoffv_time_offset_p1 = 0
faceoffv_time_offset_p2 = 0
boss_play = 0
input_debug_display = 0
display_debug_input = 0
output_log_file = 0
practice_start_time = 0
practice_end_time = 0
startup_song = fastgh3
startup_difficulty = expert
startup_controller = 0
startup_controller2 = 1
time_gem_offset = 0.0
time_input_offset = 0.0
p1_ready = 0
p2_ready = 0
max_num_powerups = 3
current_powerups_p1 = [ 0 0 0 ]
current_powerups_p2 = [ 0 0 0 ]
current_battle_text_p1 = [ id id id ]
current_battle_text_p2 = [ id id id ]
battle_p1_highway_hammer = 0
battle_p2_highway_hammer = 0
battle_flicker_difficulty_p1 = 2
battle_flicker_difficulty_p2 = 2
show_battle_text = 1
devil_finish = 0
save_current_powerups_p1 = [ 0 0 0 ]
save_current_powerups_p2 = [ 0 0 0 ]
battle_sudden_death = 0
Cheat_AirGuitar = 0
Cheat_PerformanceMode = 0
Cheat_Hyperspeed = 3
Cheat_NoFail = 0
Cheat_EasyExpert = 0
Cheat_PrecisionMode = 0
Cheat_BretMichaels = 0
boss_wuss_out = 0
crowd_model_array = None
//p1_last_song_detailed_stats = [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ]
p1_last_song_detailed_stats = []
p2_last_song_detailed_stats = []
p1_last_song_detailed_stats_max = []
p2_last_song_detailed_stats_max = []
failed_song_time = 0.0
current_section_array = None
current_section_array_entry = 0
last_time_in_lead = 0.0
last_time_in_lead_player = -1
enable_saving = 0
primary_controller = 0
primary_controller_assigned = 0
invite_controller = -1
num_career_bands = 5
streamall_fsb_index = -1
enable_button_cheats = 1
whammy_mania_achievement_invalidated = 0
fps_max = 1000
gem_scalar = 1.0
gem_scale_orig1 = 0.0
gem_scale_orig2 = 0.0

// hate me
part_index = { guitar = 0 rhythm = 1 }
parts = [ guitar rhythm ]
part_names = { guitar = 'Guitar' rhythm = 'Rhythm' }

fastgh3_build = '1.0-999010889'
bleeding_edge = 0
build_timestamp = [07 04 2023]

script FileExists \{#"0x00000000" = ''}
	if exists <#"0x00000000">
		return \{true}
	endif
	Formattext textname = xen '%s.xen' s = <#"0x00000000">
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

// fancifying
// @script | AllocArray | create new array with a defined size and element to fill with
// thanks q
// @parm name | set | the element and it's type to set the array with
// @parm name | size | size of the array
script AllocArray \{set = 0 size = 10}
	// basically memset lol
	element = <set>
	array = []
	begin
		AddArrayElement <...>
	repeat <size>
	change globalname = <#"0x00000000"> newvalue = <array>
endscript
script FSZ \{1024}
	AddParams \{units = [' ' 'K' 'M' 'G'] u = 0}
	begin
		if (<#"0x00000000"> >= 1024)
			<#"0x00000000"> = (<#"0x00000000"> / 1024.0)
			Increment \{u}
		else
			FormatText textname=text '%d%ub' d = <#"0x00000000"> u = (<units>[<u>])
			break
		endif
	repeat
	return textsize = <text>
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
random_seed = -1
// ^ originally 107482099
// @script | guitar_startup | Initialization script
script guitar_startup
	HideLoadingScreen
	printf \{'####### FASTGH3 INITIALIZING... #######'}
	printf \{'Version %v' v=$fastgh3_build}
	if ($bleeding_edge = 1)
		printf \{'On developmental build'}
		pad ($build_timestamp[0])
		d = <pad>
		pad ($build_timestamp[1])
		e = <pad>
		printf 'Timestamp: %f.%d.%e' d=<d> e=<e> f=($build_timestamp[2])
	endif
	if IntegerEquals \{a=$random_seed b=-1}
		Randomize
	else
		Randomize \{$random_seed}
		// boss speedruns when
	endif
	//if CD
	//	printf \{'is CD'}
	//endif
	SetConfig \{NotCD GotExtraMemory}
	//if NotCD
	//	printf \{'isn\'t CD'}
	//endif
	ProfilingStart
	change player1_status = { controller = 0 Player = 1 text = 'p1' part = guitar bot_play = 0 bot_pattern = 0 bot_strum = 0 bot_star_power = 0 star_power_usable = 0 star_power_amount = 0.0 star_tilt_threshold = 16.0 playline_song_measure_time = 0 star_power_used = 0 current_run = 0 resting_whammy_position = -0.76 lefthanded_gems = 0 lefthanded_button_ups = 0 lefthanded_gems_flip_save = 0 lefthanded_button_ups_flip_save = 0 current_song_gem_array = None current_song_fretbar_array = None current_song_star_array = None current_star_array_entry = 0 current_song_beat_time = 0 playline_song_beat_time = 0 current_song_measure_time = 0 current_detailedstats_array = None current_detailedstats_max_array = None current_detailedstats_array_entry = 0 time_in_lead = 0.0 hammer_on_tolerance = 0.0 check_time_early = 0.0 check_time_late = 0.0 whammy_on = 0 star_power_sequence = 0 star_power_note_count = 0 score = 0.0 notes_hit = 0 total_notes = 0 best_run = 0 max_notes = 0 base_score = 0.0 stars = 0 sp_phrases_hit = 0 sp_phrases_total = 0 multiplier_count = 0 num_multiplier = 0 sim_bot_score = 0.0 scroll_time = 5.0 game_speed = 1.5 highway_speed = 0.0 highway_material = #"0xce5b3c9f" guitar_volume = 100 last_guitar_volume = 100 last_faceoff_note = 100 is_local_client = 1 highway_layout = default_highway net_id_first = 0 net_id_second = 0 battlemode_creation_selection = -1 current_num_powerups = 0 final_blow_powerup = -1 battle_text_count = 0 shake_notes = -1 double_notes = -1 diffup_notes = -1 lefty_notes = -1 whammy_attack = -1 stealing_powerup = -1 death_lick_attack = -1.0 last_hit_note = None broken_string_mask = 0 broken_string_green = 0 broken_string_red = 0 broken_string_yellow = 0 broken_string_blue = 0 broken_string_orange = 0 last_selected_attack = -1 battle_num_attacks = 0 hold_difficulty_up = 0.0 save_health = 0.0 save_num_powerups = 0 gem_filler_enabled_time_on = -1 gem_filler_enabled_time_off = -1 current_health = 0.0 health_invincible_time = 0.0 button_checker_up_time = -1.0 last_playline_song_beat_time = 1.0 last_playline_song_beat_change_time = 1.0 }
	change player2_status = { controller = 1 Player = 2 text = 'p2' part = rhythm bot_play = 0 bot_pattern = 0 bot_strum = 0 bot_star_power = 0 star_power_usable = 0 star_power_amount = 0.0 star_tilt_threshold = 16.0 playline_song_measure_time = 0 star_power_used = 0 current_run = 0 resting_whammy_position = -0.76 lefthanded_gems = 0 lefthanded_button_ups = 0 lefthanded_gems_flip_save = 0 lefthanded_button_ups_flip_save = 0 current_song_gem_array = None current_song_fretbar_array = None current_song_star_array = None current_star_array_entry = 0 current_song_beat_time = 0 playline_song_beat_time = 0 current_song_measure_time = 0 current_detailedstats_array = None current_detailedstats_max_array = None current_detailedstats_array_entry = 0 time_in_lead = 0.0 hammer_on_tolerance = 0.0 check_time_early = 0.0 check_time_late = 0.0 whammy_on = 0 star_power_sequence = 0 star_power_note_count = 0 score = 0.0 notes_hit = 0 total_notes = 0 best_run = 0 max_notes = 0 base_score = 0.0 stars = 0 sp_phrases_hit = 0 sp_phrases_total = 0 multiplier_count = 0 num_multiplier = 0 sim_bot_score = 0.0 scroll_time = 5.0 game_speed = 1.5 highway_speed = 0.0 highway_material = #"0xce5b3c9f" guitar_volume = 100 last_guitar_volume = 100 last_faceoff_note = 100 is_local_client = 1 highway_layout = default_highway net_id_first = 0 net_id_second = 0 battlemode_creation_selection = -1 current_num_powerups = 0 final_blow_powerup = -1 battle_text_count = 0 shake_notes = -1 double_notes = -1 diffup_notes = -1 lefty_notes = -1 whammy_attack = -1 stealing_powerup = -1 death_lick_attack = -1.0 last_hit_note = None broken_string_mask = 0 broken_string_green = 0 broken_string_red = 0 broken_string_yellow = 0 broken_string_blue = 0 broken_string_orange = 0 last_selected_attack = -1 battle_num_attacks = 0 hold_difficulty_up = 0.0 save_health = 0.0 save_num_powerups = 0 gem_filler_enabled_time_on = -1 gem_filler_enabled_time_off = -1 current_health = 0.0 health_invincible_time = 0.0 button_checker_up_time = -1.0 last_playline_song_beat_time = 1.0 last_playline_song_beat_change_time = 1.0 }
	printf \{'Initializing unneeded stuff'}
	//CompositeObjectManager_startup
	//MemCardSystemInitialize // probably destroyed and broke save functionality
	InitAnimSystem \{ AnimHeapSize = 0 CacheBlockAlign = 0 AnimNxBufferSize = 1 DefCacheType = fullres MaxAnimStages = 0 MaxAnimSubsets = 0 MaxDegenerateAnims = 0 }
	//InitLightManager \{max_lights = 1 max_model_lights = 0 max_groups = 1 max_render_verts_per_geom = 0}
	LightShow_Init \{notes = $LightShow_NoteMapping nodeflags = $LightShow_StateNodeFlags ColorOverrideExclusions = $LightShow_ColorOverrideExcludeLights}
	printf \{'Initializing Replay buffer'}
	AllocateDataBuffer \{name = replay kb = 5120}
	ProfilingEnd <...> 'init things'
	printf \{'Creating sound busses'}
	Master_SFX_Adding_Sound_Busses
	printf \{'Loading user config'}
	ProfilingStart
	migrate = 0
	if FileExists \{'config.qb'}
		LoadQB \{'config.qb'}
		migrate = 1
	elseif FileExists \{'user.pak'}
		LoadPak \{'user.pak'}
		migrate = 1
	endif
	if FileExists \{'gameplay_BG.img.xen'}
		LoadTexture \{'../gameplay_BG'}
	elseif FileExists \{'bkgd.pak.xen'} // deprecated, BTFO'd by above
		LoadPak \{'bkgd.pak' Heap = heap_global_pak}
	endif
	ProfilingEnd <...> 'load config files'
	// move old (common) config values over from QB since this will be used less now
	// i'll probably have to package release with MigratedConfig values set for new users
	if IsTrue <migrate>
		ProfilingStart
		FGH3Config \{sect='Temp' 'MigratedConfig' #"0x1ca1ff20"=0}
		ProfilingEnd <...> 'INI read x1'
		if NOT IsTrue <value>
			ProfilingStart
			FGH3Config sect='Player' 'Hyperspeed' set=($Cheat_Hyperspeed)
			FGH3Config sect='Player' 'Autostart' set=($autolaunch_startnow)
			if GlobalExists \{name=p1_part type=int}
				FGH3Config sect='Player1' 'Part' set=($p1_part) // this is my fault but because i had limited resources
			else
				FGH3Config sect='Player1' 'Part' set=($part_index.($player1_status.part))
			endif
			if GlobalExists \{name=p2_part type=int}
				FGH3Config sect='Player2' 'Part' set=($p2_part)
			else
				FGH3Config sect='Player2' 'Part' set=($part_index.($player2_status.part))
			endif
			FGH3Config sect='Player1' 'Device' set=($startup_controller)
			FGH3Config sect='Player2' 'Device' set=($startup_controller2)
			FGH3Config sect='Player1' 'Diff' set=($difficulty_list_props.$current_difficulty.index)
			FGH3Config sect='Player2' 'Diff' set=($difficulty_list_props.$current_difficulty2.index)
			FGH3Config sect='GFX' 'MaxFPS' set=($fps_max)
			FGH3Config sect='GFX' 'NoIntro' set=($disable_intro)
			FGH3Config sect='Player' 'ExitOnSongEnd' set=($exit_on_song_end)
			FGH3Config sect='Player' 'FCMode' set=($FC_MODE)
			FGH3Config sect='Player' 'EasyExpert' set=($Cheat_EasyExpert)
			FGH3Config sect='Player' 'Precision' set=($Cheat_PrecisionMode)
			FGH3Config sect='Player' 'EarlySustains' set=($anytime_sustain_activation)
			FGH3Config sect='Player' 'NoFail' set=($Cheat_NoFail)
			FGH3Config sect='GFX' 'NoIntroReadyTime' set=($nointro_ready_time)
			FGH3Config sect='GFX' 'BGVideo' set=($enable_video)
			FGH3Config sect='GFX' 'NoHUD' set=($hudless)
			FGH3Config sect='GFX' 'KillGemsHit' set=($kill_gems_on_hit)
			FGH3Config sect='GFX' 'NoStreakDisp' set=($disable_notestreak_notif)
			FGH3Config sect='GFX' 'NoParticles' set=($disable_particles)
			FGH3Config sect='GFX' 'Performance' set=($Cheat_PerformanceMode)
			FGH3Config sect='Misc' 'Debug' set=($enable_button_cheats)
			ProfilingEnd <...> 'INI write x24'
			FGH3Config \{sect='Temp' 'MigratedConfig' set=1}
		endif
	endif
	
	printf \{'Reading INI'}
	ProfilingStart
	
	icc = [ // ini_common_config
		// BLOATED BY 4KB IF GLOBAL
		// takes 0.038ms |:|
		// 0 = default if not specified
		{ sect='Player' [
			{'Hyperspeed' out=Cheat_Hyperspeed #"0x1ca1ff20"=3}
			{'Autostart' out=autolaunch_startnow #"0x1ca1ff20"=1}
			{'ExitOnSongEnd' out=exit_on_song_end}
			{'FCMode' out=FC_MODE}
			{'EasyExpert' out=Cheat_EasyExpert}
			{'Precision' out=Cheat_PrecisionMode}
			{'EarlySustains' out=anytime_sustain_activation}
			{'NoFail' out=Cheat_NoFail}
			//{'Speed' out=current_speedfactor #"0x1ca1ff20"=1.0}
		] }
		{ sect='GFX' [
			{'MaxFPS' out=fps_max #"0x1ca1ff20"=1000}
			{'NoIntro' out=disable_intro}
			{'NoIntroReadyTime' out=nointro_ready_time #"0x1ca1ff20"=400}
			{'BGVideo' out=enable_video}
			{'BGVideoStartTime' out=video_start_on_time}
			{'BGVideoLoop' out=video_looping}
			{'BGVideoHold' out=video_hold_last_frame}
			{'NoHUD' out=hudless}
			{'KillGemsHit' out=kill_gems_on_hit}
			{'NoStreakDisp' out=disable_notestreak_notif}
			{'NoParticles' out=disable_particles}
			{'Performance' out=Cheat_PerformanceMode}
			{'NoShake' out=disable_shake}
		] }
		{ sect='Misc' [
			{'Debug' out=enable_button_cheats}
		] }
		{ sect='Player1' [
			{'Device' out=startup_controller}
			{'Lefty' out=p1_lefty}
		] }
		{ sect='Player2' [
			{'Device' out=startup_controller2 #"0x1ca1ff20"=1}
			{'Lefty' out=p2_lefty}
		] }
	]
	GetArraySize \{icc}
	i = 0
	begin
		ii = (<icc>[<i>].#"0x00000000")
		sect = (<icc>[<i>].sect)
		j = 0
		GetArraySize \{ii}
		begin
			jj = (<ii>[<j>])
			k = 0
			if StructureContains \{structure=jj #"0x1ca1ff20"}
				k = (<jj>.#"0x1ca1ff20")
			endif
			SetValueFromConfig sect=<sect> (<jj>.#"0x00000000") #"0x1ca1ff20"=<k> out=(<jj>.out)
			Increment \{j}
		repeat <array_size>
		Increment \{i}
		// 2MS >:(
	repeat <array_size>
	FGH3Config \{sect='Player' 'Speed' #"0x1ca1ff20"=1.0}
	change current_speedfactor = <value>
	if ($current_speedfactor <= 0.0)
		if FGH3Config \{sect='Player' 'Speed' #"0x1ca1ff20"=1.0}
			printf \{'Can\'t have zero percent speed!!!!!'}
			FGH3Config \{sect='Player' 'Speed' set=1.0}
		endif
		change \{current_speedfactor = 1.0}
	endif
	
	// PLAYER 1 CONFIG
	FGH3Config \{sect='Player1' 'Diff' #"0x1ca1ff20"=3}
	change current_difficulty=($difficulty_array[<value>])
	FGH3Config \{sect='Player1' 'Part' #"0x1ca1ff20"=0}
	change structurename=player1_status part=($parts[<value>])
	// PLAYER 2 CONFIG
	FGH3Config \{sect='Player2' 'Diff' #"0x1ca1ff20"=3}
	change current_difficulty2=($difficulty_array[<value>])
	FGH3Config \{sect='Player2' 'Part' #"0x1ca1ff20"=1}
	change structurename=player2_status part=($parts[<value>])
	FGH3Config \{sect='GFX' 'GemScale' #"0x1ca1ff20"=1.0}
	ProfilingEnd <...> 'INI read'
	change gem_scalar = <value>
	change \{gem_scale_orig1 = $gem_start_scale1}
	change \{gem_scale_orig2 = $gem_start_scale2}
	change gem_start_scale1 = ($gem_start_scale1 * <value>)
	change gem_start_scale2 = ($gem_start_scale2 * <value>)
	
	ProfilingStart
	if ScriptExists \{startup}
		startup
	endif
	printf \{'Loading user mods'}
	StartWildcardSearch \{wildcard = 'MODS\*.qb.xen'}
	begin
		if NOT GetWildcardFile
			break
		endif
		change \{mod_info = {}}
		printf 'Loading %f.qb' f = <basename>
		formattext textname = file 'MODS/%f.qb' f = <basename>
		LoadQB <file>
		formattext checksumname = mod_info_name '%f_mod_info' f = <basename>
		if GlobalExists name = <mod_info_name> type = structure
			mod_info = ($<mod_info_name>)
		elseif GlobalExists \{name = mod_info type = structure}
			mod_info = $mod_info
		else
			mod_info = {failed}
		endif
		//printstruct <mod_info>
		name = 'Untitled'
		author = 'Unknown'
		version = 'unknown'
		if StructureContains \{structure=mod_info name}
			name = (<mod_info>.name)
		endif
		if StructureContains \{structure=mod_info author}
			author = (<mod_info>.author)
		endif
		if StructureContains \{structure=mod_info version}
			version = (<mod_info>.version)
		endif
		FSZ <filesize>
		printf "Mod info: %t by %a / version %v, size: %s" t=<name> a=<author> v=<version> s=<textsize>
		if StructureContains \{structure=mod_info desc}
			printf "Description: %d" d=(<mod_info>.desc)
		endif
		formattext checksumname = startup_script '%f_startup' f = <basename>
		if ScriptExists <startup_script>
			SpawnScriptNow <startup_script> params = { filename = <filename> basename = <basename> }
		else
			if ScriptExists \{mod_startup}
				SpawnScriptNow mod_startup params = { filename = <filename> basename = <basename> }
			endif
		endif
	repeat
	EndWildcardSearch
	ProfilingEnd <...> 'mod load'
	
	printf \{'Loading Paks'}
	ProfilingStart
	LoadPak \{'zones/global.pak' Heap = heap_global_pak splitfile}
	SetScenePermanent \{scene = 'zones/global/global_gfx.scn' permanent}
	// test time to load
	ProfilingEnd <...> 'LoadPak global.pak'
	ProfilingStart
	LoadPak \{'zones/default.pak'}
	ProfilingEnd <...> 'LoadPak default.pak'
	printf \{'Loading unpacked images'}
	ProfilingStart
	StartWildcardSearch \{wildcard = 'IMAGES\*.img.xen'}
	begin
		if NOT GetWildcardFile
			break
		endif
		printf 'Loading images/%f.img' f = <basename>
		LoadTexture <basename>
	repeat
	EndWildcardSearch
	ProfilingEnd <...> 'LoadTexture *'
	
	ProfilingStart
	SetFontProperties \{'text_A1' color_tab = $Default_Font_Colors}
	SetFontProperties \{'ButtonsXenon' buttons_font}
	SetFontProperties \{'text_a3' color_tab = $Default_Font_Colors}
	SetFontProperties \{'text_a4' color_tab = $Default_Font_Colors}
	SetFontProperties \{'text_a6' color_tab = $Default_Font_Colors}
	SetFontProperties \{'num_a7' color_tab = $Default_Font_Colors}
	SetFontProperties \{'num_a9' color_tab = $Default_Font_Colors}
	SetFontProperties \{'text_a10' color_tab = $Default_Font_Colors}
	SetFontProperties \{'text_a11' color_tab = $Default_Font_Colors}
	SetFontProperties \{'fontgrid_title_gh3' color_tab = $Default_Font_Colors}
	ProfilingEnd <...> 'font properties'
	
	ProfilingStart
	if IsFmodEnabled
		EnableRemoveSoundEntry \{enable}
		LoadPak \{'zones/global_sfx.pak' Heap = heap_audio}
	endif
	CreatePakManMap \{map = zones links = GH3Zones folder = 'zones/' uselinkslots}
	
	printf \{'Initializing screen element system'}
	ScreenElementSystemInit
	SetShadowProjectionTexture \{texture = white}
	CreateScreenElement \{Type = ContainerElement id = dead_particle_container parent = root_window Pos = (0.0, 0.0)}
	Init2DParticles \{parent = dead_particle_container}
	setup_sprites
	ProfilingEnd <...> 'screen element stuff'
	
	printf \{'Allocating new big arrays'}
	// sick of seeing a bunch of zeroes :/
	ProfilingStart
	// {
	AllocArray \{size = 97 p1_last_song_detailed_stats}
	AllocArray \{size = 97 p2_last_song_detailed_stats}
	AllocArray \{size = 97 p1_last_song_detailed_stats_max}
	AllocArray \{size = 97 p2_last_song_detailed_stats_max}
	AllocArray \{WhammyWibble0 set = 1.0 size = 136}
	AllocArray \{WhammyWibble1 set = 1.0 size = 136}
	// } ran for 0.3ms
	AllocArray \{size = 32 solo_hit_buffer_p1}
	AllocArray \{size = 32 solo_hit_buffer_p2}
	AllocArray \{size = $highway_lines set = 0.0 gem_time_table512}
	AllocArray \{size = $highway_lines set = 0.0 rowHeightNormalizedDistance}
	AllocArray \{size = $highway_lines set = 0.0 rowHeight}
	AllocArray \{size = $highway_lines set = 0.0 time_accum_table}
	ProfilingEnd <...> 'AllocArray x12'
	// 5 ms (michael scott gif)
	
	ProfilingStart
	printf \{'Done initializing - into game...'}
	InitAtoms
	SetProgressionMaxDifficulty \{difficulty = 3}
	setup_globaltags
	kill_start_key_binding
	Player = 1
	begin
		FormatText checksumName = player_status 'player%i_status' i = <Player> AddToStringLookup
		FormatText textname = player_text 'p%i' i = <Player> AddToStringLookup
		SpawnScriptLater create_guitar_events params = { <...> }
		Increment \{player}
	repeat ($max_num_players)
	if ($autolaunch_startnow = 0)
		start_flow_manager \{flow_state = bootup_sequence_fs}
	else
		StartRendering
		SpawnScriptLater \{autolaunch_spawned}
	endif
	ProfilingEnd <...> 'start game'	
	ProfilingStart
	if FileExists \{'hway.pak'}
		load_highway
	elseif FileExists \{'pak/player.pak'}
		load_highway \{player_status = player1_status filename = 'pak/player.pak'}
	endif
	if FileExists \{'hway2.pak'}
		// wait, how did this even work if there's conflicting material names
		// ps: ok, now it doesn't apparently
		load_highway \{player_status = player2_status filename = 'hway2.pak'}
	elseif FileExists \{'pak/player.pak'}
		load_highway \{player_status = player2_status filename = 'pak/player.pak'}
	elseif FileExists \{'hway.pak'}
		load_highway \{player_status = player2_status filename = 'hway.pak'}
	endif
	ProfilingEnd <...> 'load highways'
	Change \{tutorial_disable_hud = 0}
endscript
// @script | load_highway | load highway pak
// @parm name | axel | name of the highway,
// wrapped in sys_(name)_1_highway_sys_(name)_1_highway
// @parm name | filename | path of the pak
script load_highway \{player_status = player1_status name = 'axel' filename = 'hway.pak'}
	Formattext textname = xen '%s.xen' s = <filename>
	if NOT FileExists <xen>
		return \{FALSE}
	endif
	if NOT LoadPakAsync pak_name = <filename> Heap = none async = 0
		return \{FALSE}
	endif
	FormatText textname = highway_name 'Guitarist_%n_Outfit%o_Style%s' n = <name> o = 1 s = 1
	AddToMaterialLibrary scene = <highway_name>
	FormatText checksumName = highway_material 'sys_%a_1_highway_sys_%a_1_highway' a = <name>
	Change StructureName = <player_status> highway_material = <highway_material>
endscript

script autolaunch_spawned
	NewShowStorageSelector
	start_flow_manager \{flow_state = quickplay_play_song_fs}
	Change \{primary_controller = $startup_controller}
	SpawnScriptLater \{start_song params = {device_num = $startup_controller}}
endscript
kill_dummy_bg_camera = $EmptyScript
restore_dummy_bg_camera = $EmptyScript

dummy = {zone = z_viewer name = 'z_viewer' title = "viewer"}
LevelZones = {
	viewer = {$dummy}
	load_z_viewer = {$dummy}
}
Terrain_Actions = $nullArray
Terrain_Types = $nullArray

script InFrontEnd
	return \{FALSE}
endscript
script StartRendering
	StartRendering_C
	Change \{pause_no_render = 0}
endscript
script StopRendering
	StopRendering_C
	Change \{pause_no_render = 1}
endscript

nullStruct = {}
nullArray = []
nullNoteArray = [0 0 0]
nullPhraseArray = [[0 0 0]]

/*fastgh3_song_easy = $nullArray
fastgh3_song_medium = $nullArray
fastgh3_song_hard = $nullArray
fastgh3_song_expert = $nullArray
fastgh3_song_rhythm_easy = $nullArray
fastgh3_song_rhythm_medium = $nullArray
fastgh3_song_rhythm_hard = $nullArray
fastgh3_song_rhythm_expert = $nullArray
fastgh3_song_guitarcoop_easy = $nullArray
fastgh3_song_guitarcoop_medium = $nullArray
fastgh3_song_guitarcoop_hard = $nullArray
fastgh3_song_guitarcoop_expert = $nullArray
fastgh3_song_rhythmcoop_easy = $nullArray
fastgh3_song_rhythmcoop_medium = $nullArray
fastgh3_song_rhythmcoop_hard = $nullArray
fastgh3_song_rhythmcoop_expert = $nullArray
fastgh3_easy_star = $nullPhraseArray
fastgh3_medium_star = $nullPhraseArray
fastgh3_hard_star = $nullPhraseArray
fastgh3_expert_star = $nullPhraseArray
fastgh3_rhythm_easy_star = $nullPhraseArray
fastgh3_rhythm_medium_star = $nullPhraseArray
fastgh3_rhythm_hard_star = $nullPhraseArray
fastgh3_rhythm_expert_star = $nullPhraseArray
fastgh3_guitarcoop_easy_star = $nullPhraseArray
fastgh3_guitarcoop_medium_star = $nullPhraseArray
fastgh3_guitarcoop_hard_star = $nullPhraseArray
fastgh3_guitarcoop_expert_star = $nullPhraseArray
fastgh3_rhythmcoop_easy_star = $nullPhraseArray
fastgh3_rhythmcoop_medium_star = $nullPhraseArray
fastgh3_rhythmcoop_hard_star = $nullPhraseArray
fastgh3_rhythmcoop_expert_star = $nullPhraseArray
fastgh3_easy_starbattlemode = $nullPhraseArray
fastgh3_medium_starbattlemode = $nullPhraseArray
fastgh3_hard_starbattlemode = $nullPhraseArray
fastgh3_expert_starbattlemode = $nullPhraseArray
fastgh3_rhythm_easy_starbattlemode = $nullPhraseArray
fastgh3_rhythm_medium_starbattlemode = $nullPhraseArray
fastgh3_rhythm_hard_starbattlemode = $nullPhraseArray
fastgh3_rhythm_expert_starbattlemode = $nullPhraseArray
fastgh3_guitarcoop_easy_starbattlemode = $nullPhraseArray
fastgh3_guitarcoop_medium_starbattlemode = $nullPhraseArray
fastgh3_guitarcoop_hard_starbattlemode = $nullPhraseArray
fastgh3_guitarcoop_expert_starbattlemode = $nullPhraseArray
fastgh3_rhythmcoop_easy_starbattlemode = $nullPhraseArray
fastgh3_rhythmcoop_medium_starbattlemode = $nullPhraseArray
fastgh3_rhythmcoop_hard_starbattlemode = $nullPhraseArray
fastgh3_rhythmcoop_expert_starbattlemode = $nullPhraseArray
fastgh3_faceoffp1 = [ [ 0 2147483647 ] ]
fastgh3_faceoffp2 = [ [ 0 2147483647 ] ]
fastgh3_bossbattlep1 = []
fastgh3_bossbattlep2 = []
fastgh3_timesig = [ [ 0 4 4 ] ]
fastgh3_fretbars = [ 0 999999999 ]
fastgh3_markers = []*/


