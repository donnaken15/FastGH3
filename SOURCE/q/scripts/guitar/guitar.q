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
coop_tracks = 0
autostart_coop = 0
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
diff_index = { easy = 0 medium = 1 hard = 2 expert = 3 }
modes = [
	p1_quickplay
	training
	p2_coop
	p2_faceoff
	p2_pro_faceoff
	p2_battle
]
mode_index = {
	p1_quickplay = 0
	p1_career = 0 // lol
	training = 1
	p2_coop = 2
	p2_career = 2
	p2_faceoff = 3
	p2_pro_faceoff = 4
	p2_battle = 5
}

fastgh3_build = '1.1-999011043'
fastgh3_branch = main
bleeding_edge = 1
build_timestamp = [  9  8 2024]

random_seed = -1
// ^ originally 107482099
// @script | guitar_startup | Initialization script
script guitar_startup
	GetTrueStartTime
	bg_path = 'gameplay_BG'
	if not FileExists (<bg_path>+'.img.xen')
		bg_path = 'zones/load_scr'
	else
		bg_path = <bg_path>
	endif
	bg_path = ('../../'+<bg_path>)
	DisplayLoadingScreen <bg_path> spin_texture = '../../zones/load_disc' spin_x = 554 spin_y = 296
	StopRendering
	begin
		GetTrueElapsedTime startTime = <startTime>
		if (<ElapsedTime> >= 40)
			break
		endif
		Wait \{1 gameframe}
		// just to get loading screen to display
	repeat
	printf \{'####### FASTGH3 INITIALIZING... #######'}
	printf \{'Version %v' v=$fastgh3_build}
	if ($bleeding_edge = 1)
		//printf \{'[91mOn developmental build[0m'}
		printf \{'On developmental build'}
		pad ($build_timestamp[0])
		d = <pad>
		pad ($build_timestamp[1])
		printf 'Timestamp: %f.%d.%e' d=<d> e=<pad> f=($build_timestamp[2])
		RemoveComponent \{d}
		RemoveComponent \{pad}
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
	//SetConfig \{NotCD GotExtraMemory}
	//if NotCD
	//	printf \{'isn\'t CD'}
	//endif
	// region player init struct and deflate file size :/
		change \{player1_status = { controller = 0 Player = 1 text = 'p1' part = guitar bot_play = 0 bot_pattern = 0 bot_strum = 0 bot_star_power = 0 star_power_usable = 0 star_power_amount = 0.0 star_tilt_threshold = 16.0 playline_song_measure_time = 0 star_power_used = 0 current_run = 0 resting_whammy_position = -0.76 lefthanded_gems = 0 lefthanded_button_ups = 0 lefthanded_gems_flip_save = 0 lefthanded_button_ups_flip_save = 0 current_song_gem_array = None current_song_fretbar_array = None current_song_star_array = None current_star_array_entry = 0 current_song_beat_time = 0 playline_song_beat_time = 0 current_song_measure_time = 0 current_detailedstats_array = None current_detailedstats_max_array = None current_detailedstats_array_entry = 0 time_in_lead = 0.0 hammer_on_tolerance = 0.0 check_time_early = 0.0 check_time_late = 0.0 whammy_on = 0 star_power_sequence = 0 star_power_note_count = 0 score = 0.0 notes_hit = 0 total_notes = 0 best_run = 0 max_notes = 0 base_score = 0.0 stars = 0 sp_phrases_hit = 0 sp_phrases_total = 0 multiplier_count = 0 num_multiplier = 0 sim_bot_score = 0.0 scroll_time = 5.0 game_speed = 1.5 highway_speed = 0.0 highway_material = sys_Highway2D_sys_Highway2D current_highway = none guitar_volume = 100 last_guitar_volume = 100 last_faceoff_note = 100 is_local_client = 1 highway_layout = default_highway net_id_first = 0 net_id_second = 0 battlemode_creation_selection = -1 current_num_powerups = 0 final_blow_powerup = -1 battle_text_count = 0 shake_notes = -1 double_notes = -1 diffup_notes = -1 lefty_notes = -1 whammy_attack = -1 stealing_powerup = -1 death_lick_attack = -1.0 last_hit_note = None broken_string_mask = 0 broken_string_green = 0 broken_string_red = 0 broken_string_yellow = 0 broken_string_blue = 0 broken_string_orange = 0 last_selected_attack = -1 battle_num_attacks = 0 hold_difficulty_up = 0.0 save_health = 0.0 save_num_powerups = 0 gem_filler_enabled_time_on = -1 gem_filler_enabled_time_off = -1 current_health = 0.0 health_invincible_time = 0.0 button_checker_up_time = -1.0 last_playline_song_beat_time = 1.0 last_playline_song_beat_change_time = 1.0 }}
		change \{player2_status = { controller = 1 Player = 2 text = 'p2' part = rhythm bot_play = 0 bot_pattern = 0 bot_strum = 0 bot_star_power = 0 star_power_usable = 0 star_power_amount = 0.0 star_tilt_threshold = 16.0 playline_song_measure_time = 0 star_power_used = 0 current_run = 0 resting_whammy_position = -0.76 lefthanded_gems = 0 lefthanded_button_ups = 0 lefthanded_gems_flip_save = 0 lefthanded_button_ups_flip_save = 0 current_song_gem_array = None current_song_fretbar_array = None current_song_star_array = None current_star_array_entry = 0 current_song_beat_time = 0 playline_song_beat_time = 0 current_song_measure_time = 0 current_detailedstats_array = None current_detailedstats_max_array = None current_detailedstats_array_entry = 0 time_in_lead = 0.0 hammer_on_tolerance = 0.0 check_time_early = 0.0 check_time_late = 0.0 whammy_on = 0 star_power_sequence = 0 star_power_note_count = 0 score = 0.0 notes_hit = 0 total_notes = 0 best_run = 0 max_notes = 0 base_score = 0.0 stars = 0 sp_phrases_hit = 0 sp_phrases_total = 0 multiplier_count = 0 num_multiplier = 0 sim_bot_score = 0.0 scroll_time = 5.0 game_speed = 1.5 highway_speed = 0.0 highway_material = sys_Highway2D_sys_Highway2D current_highway = none guitar_volume = 100 last_guitar_volume = 100 last_faceoff_note = 100 is_local_client = 1 highway_layout = default_highway net_id_first = 0 net_id_second = 0 battlemode_creation_selection = -1 current_num_powerups = 0 final_blow_powerup = -1 battle_text_count = 0 shake_notes = -1 double_notes = -1 diffup_notes = -1 lefty_notes = -1 whammy_attack = -1 stealing_powerup = -1 death_lick_attack = -1.0 last_hit_note = None broken_string_mask = 0 broken_string_green = 0 broken_string_red = 0 broken_string_yellow = 0 broken_string_blue = 0 broken_string_orange = 0 last_selected_attack = -1 battle_num_attacks = 0 hold_difficulty_up = 0.0 save_health = 0.0 save_num_powerups = 0 gem_filler_enabled_time_on = -1 gem_filler_enabled_time_off = -1 current_health = 0.0 health_invincible_time = 0.0 button_checker_up_time = -1.0 last_playline_song_beat_time = 1.0 last_playline_song_beat_change_time = 1.0 }}
	// endregion
	
	// region useless
		ProfilingStart
		printf \{'Initializing unneeded stuff'}
		//CompositeObjectManager_startup
		//MemCardSystemInitialize // probably destroyed and broke save functionality
		InitAnimSystem \{AnimHeapSize = 0 CacheBlockAlign = 0 AnimNxBufferSize = 1 DefCacheType = fullres MaxAnimStages = 0 MaxAnimSubsets = 0 MaxDegenerateAnims = 0}
		//InitLightManager \{max_lights = 1 max_model_lights = 0 max_groups = 1 max_render_verts_per_geom = 0}
		LightShow_Init \{notes = $nullArray nodeflags = $nullArray ColorOverrideExclusions = $nullArray}
		printf \{'Initializing Replay buffer'}
		AllocateDataBuffer \{name = replay kb = 5120}
		ProfilingEnd <...> 'init things'
	// endregion
	printf \{'Creating sound busses'}
	Master_SFX_Adding_Sound_Busses
	
	// region user config
		printf \{'Loading user config'}
		ProfilingStart
		//migrate = 0
		if FileExists \{'config.qb'}
			LoadQB \{'config.qb'}
			//migrate = 1
		elseif FileExists \{'user.pak'}
			LoadPak \{'user.pak'}
			//migrate = 1
		endif
		if FileExists \{'gameplay_BG.img.xen'}
			LoadTexture \{'../gameplay_BG'}
		elseif FileExists \{'bkgd.pak.xen'} // deprecated, BTFO'd by above
			LoadPak \{'bkgd.pak' Heap = heap_global_pak}
		endif
		ProfilingEnd <...> 'load config files'
		
		printf \{'Reading INI'}
		ProfilingStart
		
		icc = [ // ini_common_config
			// BLOATED BY 4KB IF GLOBAL
			// takes 0.038ms |:|
			// 0 = default if not specified
			{ sect='Player' [
				{'Hyperspeed' out=Cheat_Hyperspeed #"0x1ca1ff20"=3}
				{'Autostart' out=autolaunch_startnow #"0x1ca1ff20"=-1}
				{'ExitOnSongEnd' out=exit_on_song_end}
				{'FCMode' out=FC_MODE}
				{'EasyExpert' out=Cheat_EasyExpert}
				{'Precision' out=Cheat_PrecisionMode}
				{'EarlySustains' out=anytime_sustain_activation}
				{'NoFail' out=Cheat_NoFail}
				{'CoopTracks' out=coop_tracks} // effective only when chart actually has both co-op parts
				//{'Speed' out=current_speedfactor #"0x1ca1ff20"=1.0}
				{'OutputStats' out=output_song_stats}
				{'OverlappingSP' out=overlapping_starpower #"0x1ca1ff20"=1}
				{'Speed' out=current_speedfactor #"0x1ca1ff20"=1.0}
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
				FGH3Config sect=<sect> (<jj>.#"0x00000000") #"0x1ca1ff20"=<k>
				change globalname=(<jj>.out) newvalue=<value>
				Increment \{j}
			repeat <array_size>
			Increment \{i}
			// 2MS >:(
		repeat <array_size>
		if NOT ($current_speedfactor > 0.0)
			if FGH3Config \{sect='Player' 'Speed' #"0x1ca1ff20"=1.0}
				printf \{'Can\'t have zero percent speed!!!!!'}
				FGH3Config \{sect='Player' 'Speed' set=1.0}
			endif
			change \{current_speedfactor = 1.0}
		endif
		
		FGH3Config \{sect='Player' 'Mode' #"0x1ca1ff20"=0}
		if (<value> < 6 & <value> >= 0)
			change game_mode = ($modes[<value>])
		else
			printf \{'Invalid game mode index!!!!!!!!'}
		endif
		if (<value> = 2)
			change \{autostart_coop = 1}
		endif
		FGH3Config \{sect='Player' '2Player' #"0x1ca1ff20"=0}
		if (<value> = 1)
			change \{current_num_players = 2}
		else
			change \{current_num_players = 1}
		endif
		
		// PLAYER 1 CONFIG
		FGH3Config \{sect='Player1' 'Diff' #"0x1ca1ff20"=3}
		change current_difficulty=($difficulty_list[<value>])
		FGH3Config \{sect='Player1' 'Part' #"0x1ca1ff20"=0}
		change structurename=player1_status part=($parts[<value>])
		FGH3Config \{sect='Player1' 'Bot' #"0x1ca1ff20"=0}
		change structurename=player1_status bot_play=<value>
		// PLAYER 2 CONFIG
		FGH3Config \{sect='Player2' 'Diff' #"0x1ca1ff20"=3}
		change current_difficulty2=($difficulty_list[<value>])
		FGH3Config \{sect='Player2' 'Part' #"0x1ca1ff20"=1}
		change structurename=player2_status part=($parts[<value>])
		FGH3Config \{sect='Player2' 'Bot' #"0x1ca1ff20"=0}
		change structurename=player2_status bot_play=<value>
		FGH3Config \{sect='GFX' 'GemScale' #"0x1ca1ff20"=1.0}
		ProfilingEnd <...> 'INI read'
		change gem_scalar = <value>
		change \{gem_scale_orig1 = $gem_start_scale1}
		change \{gem_scale_orig2 = $gem_start_scale2}
		change gem_start_scale1 = ($gem_start_scale1 * <value>)
		change gem_start_scale2 = ($gem_start_scale2 * <value>)
		
		if ScriptExists \{startup}
			startup // optional thing to load from config.qb/user.pak
			// also [Mods] AutoExec to execute raw line(s) of code using eval
		endif
	// endregion
	
	// region mod load
		ProfilingStart
		printf \{'Loading user mods'}
		search_for \{'MODS\*.qb.xen'}
		
		if NOT (<array_size> = 0)
			m = 0
			begin
				change \{mod_info = {}}
				AddParams (<array>[<m>])
				printf 'Loading %f.qb' f = <basename>
				formattext textname = file 'MODS/%f.qb' f = <basename>
				LoadQB <file>
				FastFormatCrc a = <basename> b = '_mod_info' out = mod_info_name
				if GlobalExists name = <mod_info_name> type = structure
					mod_info = ($<mod_info_name>)
				elseif GlobalExists \{name = mod_info type = structure}
					mod_info = ($mod_info)
				else
					mod_info = {failed}
				endif
				continue = 1
				if StructureContains \{structure=mod_info requires}
					requires = (<mod_info>.requires)
					GetArraySize \{requires}
					if NOT (<array_size> = 0)
						i = 0
						begin
							FormatText textname = target 'mods/%s' s = (<requires>[<i>])
							if NOT exists <target>
								printf 'Required file of this mod cannot be found: %s' s = (<requires>[<i>])
								UnloadQB <file>
								continue = 0
								break
							endif
							Increment \{i}
						repeat <array_size>
					endif
				endif
				if (<continue>)
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
					FastFormatCrc a = <basename> b = '_startup' out = startup_script
					if ScriptExists <startup_script>
						SpawnScriptNow <startup_script> params = { filename = <filename> basename = <basename> }
					else
						if ScriptExists \{mod_startup}
							SpawnScriptNow mod_startup params = { filename = <filename> basename = <basename> }
						endif
					endif
				endif
				// get rid of ambiguously named mod_info global struct after loading?
				Increment \{m}
			repeat <array_size>
		endif
		ProfilingEnd <...> 'mod load'
		
	// endregion
	
	// region grafisxs and snoud
		printf \{'Loading Paks'}
		ProfilingStart
		LoadPak \{'zones/global.pak' Heap = heap_global_pak splitfile}
		//if NOT ($fastgh3_branch = unpak)
			SetScenePermanent \{scene = 'zones/global/global_gfx.scn' permanent}
		//else
		//	AddToMaterialLibrary \{scene = 'zones/global/global_gfx.scn'}
		//endif
		// test time to load
		ProfilingEnd <...> 'LoadPak global.pak'
		
		if IsTextureInDictionary \{texture = Controller_2p_BG}
			change \{old_2p_background = 1}
		endif
		if IsTextureInDictionary \{texture = hud_2p_c_rock_shadow}
			change \{old_2p_shadow = 1}
		endif
		
		ProfilingStart
		LoadPak \{'zones/default.pak'}
		ProfilingEnd <...> 'LoadPak default.pak'
		
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
		ProfilingEnd <...> 'LoadPak global_sfx.pak'
		CreatePakManMap \{map = zones links = GH3Zones folder = 'zones/' uselinkslots}
	// endregion
	
	// region initialize big stuff
		printf \{'Allocating new big arrays'}
		// sick of seeing a bunch of zeroes :/
		ProfilingStart
		AllocArray \{size = 500 p1_last_song_detailed_stats}
		AllocArray \{size = 500 p2_last_song_detailed_stats}
		AllocArray \{size = 500 p1_last_song_detailed_stats_max}
		AllocArray \{size = 500 p2_last_song_detailed_stats_max}
		AllocArray \{size = 136 WhammyWibble0 set = 1.0}
		AllocArray \{size = 136 WhammyWibble1 set = 1.0}
		AllocArray \{size = 32 solo_hit_buffer_p1}
		AllocArray \{size = 32 solo_hit_buffer_p2}
		AllocArray \{size = $highway_lines set = 0.0 gem_time_table512}
		AllocArray \{size = $highway_lines set = 0.0 rowHeightNormalizedDistance}
		AllocArray \{size = $highway_lines set = 0.0 rowHeight}
		AllocArray \{size = $highway_lines set = 0.0 time_accum_table}
		ProfilingEnd <...> 'AllocArray x12'
		
		ProfilingStart
		create_loading_strings
		
		change mode_buttons = [
			{ range = 5 param = mode texts = mode_text id = select_gamemode }
			{ range = 1 param = players texts = playercount_text id = select_playercount
				cont = { pos_off = (10,0) just = [center top] }
			}
			{ text = 'Bind' id = select_players button }
			{ range = 3 param = diff
				texts = diff_text id = select_diff
				cont = { pos_off = (60,0) just = [center top] }
			}
			{ range = 3 param = diff2
				texts = diff_text id = select_diff2
				cont = { pos_off = (200,-50) just = [center top] }
			}
			{ range = 1 param = part
				texts = part_text id = select_part
				cont = { pos_off = ( 60,-50) just = [center top] }
			}
			{ range = 1 param = part2
				texts = part_text id = select_part2
				cont = { pos_off = (200,-100) just = [center top] }
			}
			{ range = 1 param = bot
				texts = toggle_text id = select_bot
				cont = { pos_off = ( 60,-100) just = [center top] }
			}
			{ range = 1 param = bot2
				texts = toggle_text id = select_bot2
				cont = { pos_off = (200,-150) just = [center top] }
			}
			{ text = 'Save Settings' id = select_save button
				cont = { pos_off = (0,-150) just = [left top] }
			}
			{ text = 'Start!' id = select_start button
				cont = { pos_off = (0,-150) just = [left top] }
			}
		]
		
		change extras_menu = [
			// guide
			// (NO NAME) = variable to set
			// name = display name
			// type = type of item (bool, int, etc)
			// min = minimum value allowed (int)
			// max = maximum value allowed (int)
			// sect = INI section (default: Misc)
			// key = INI key
			// restart = (1) requires restarting the song (2) requires restarting game?
			{
				Cheat_Hyperspeed
				name='Hyperspeed'
				sect='Player'
				type=int min=-13 max=10
				restart=1
			}
			{
				fps_max
				name='Frame Rate'
				sect='GFX' key='MaxFPS'
				type=int min=0 max=1000 step=5
			}
			{
				disable_particles
				name='Particles'
				sect='GFX' key='NoParticles'
				type=int min=0 max=2
			}
			{
				hudless
				name='No HUD'
				type=bool sect='GFX' key='NoHUD'
				restart=1
			}
			{
				disable_intro
				name='No Intro'
				type=bool sect='GFX' key='NoIntro'
				restart=1
			}
			{
				disable_shake
				name='No Highway Shake'
				type=bool sect='GFX' key='NoShake'
			}
			{
				exit_on_song_end
				name='Exit on Song End'
				type=bool sect='Player' key='ExitOnSongEnd'
			}
			{
				kill_gems_on_hit
				name='Hide Gems Upon Hit'
				type=bool sect='GFX' key='KillGemsHit'
			}
			{
				disable_notestreak_notif
				name='Hide Note Streak Heads Up'
				type=bool sect='GFX' key='NoStreakDisp'
			}
			{
				enable_button_cheats
				name='Debug Menu'
				type=bool key='Debug'
			}
			{
				Cheat_NoFail
				name='No Fail'
				type=bool sect='Player' key='NoFail'
			}
			{
				Cheat_EasyExpert
				name='Easy Expert'
				type=bool sect='Player' key='EasyExpert'
				restart=1
			}
			{
				Cheat_PrecisionMode
				name='Precision'
				type=bool sect='Player' key='Precision'
				restart=1
			}
			{
				FC_MODE
				name='FC Mode'
				type=bool sect='Player' key='FCMode'
				restart=1
			}
			{
				gem_scalar
				name='Gem Scale'
				sect='GFX' key='GemScale'
				type=int min=0.0 max=100.0 step=0.05
				restart=1
			}
			{
				current_speedfactor
				name='Speed Factor'
				sect='Player' key='Speed'
				type=int min=0.05 max=100.0 step=0.05
			}
		]
		ProfilingEnd <...> 'test'
	// endregion
	
	//Load_Venue
	SetPakManCurrentBlock \{map = zones pak = z_viewer block_scripts = 0}
	
	ProfilingStart
	printf \{'Initializing screen element system'}
	ScreenElementSystemInit
	CreateScreenElement \{Type = SpriteElement id = gameplay_BG texture = gameplay_BG parent = root_window rgba = $BGCol z_priority = -2147483648 pos = (640, 360) dims = (1280, 720)}
	SetShadowProjectionTexture \{texture = white}
	CreateScreenElement \{Type = ContainerElement id = dead_particle_container parent = root_window Pos = (0.0, 0.0)}
	Init2DParticles \{parent = dead_particle_container}
	setup_sprites
	ProfilingEnd <...> 'screen element stuff'
	
	ProfilingStart
	printf \{'Done initializing - into game...'}
	InitAtoms
	//SetProgressionMaxDifficulty \{difficulty = 3}
	/*if IsWinPort
		WinPortGetConfigNumber \{name = "Sound.ClapDelay" defaultValue = 0}
		Change winport_clap_delay = <value>
	endif*///
	setup_globaltags
	kill_start_key_binding
	Player = 1
	begin
		FormatText checksumName = player_status 'player%i_status' i = <Player> AddToStringLookup
		FormatText textname = player_text 'p%i' i = <Player> AddToStringLookup
		SpawnScriptLater create_guitar_events params = { <...> }
		Increment \{player}
	repeat ($max_num_players)
	Change primary_controller = ($startup_controller)
	Change player1_device = ($startup_controller)
	Change player2_device = ($startup_controller2)
	Change StructureName = player1_status controller = ($primary_controller)
	Change structurename = player2_status controller = ($startup_controller2)
	KillSpawnedScript \{name = empty_script}
	if ($player1_status.bot_play = 1)
		change \{autolaunch_startnow = 1} // stuck on press any button screen when player 1 bot is on
		// and on practice mode warning
	endif
	switch ($autolaunch_startnow)
		case 0
			HideLoadingScreen
			start_flow_manager \{flow_state = bootup_sequence_fs}
		case -1
			printf \{'---- First play ----'}
			HideLoadingScreen
			StartRendering
			start_flow_manager \{flow_state = first_launch_fs}
		default
			StartRendering
			SpawnScriptLater \{autolaunch_spawned}
	endswitch
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
	FastFormatCrc sys_ a = <name> b = '_1_highway' c = '_sys_' d = <name> e = '_1_highway' out = highway_material
	//FormatText checksumName = highway_material 'sys_%a_1_highway_sys_%a_1_highway' a = <name>
	Change StructureName = <player_status> highway_material = <highway_material>
endscript

script search_for \{'*.pak.xen'}
	array = []
	array_size = 0
	StartWildcardSearch wildcard = <#"0x00000000">
	begin
		if NOT GetWildcardFile
			break
		endif
		// i'm stupid
		AddArrayElement array = <array> element = {
			filename = <filename>
			basename = <basename>
			filesize = <filesize>
		}
		Increment \{array_size}
	repeat
	EndWildcardSearch
	return {array = <array> array_size = <array_size>}
endscript


script autolaunch_spawned
	NewShowStorageSelector
	Change primary_controller = ($startup_controller)
	Change player1_device = ($startup_controller)
	Change player2_device = ($startup_controller2)
	//Change structurename = player2_status controller = ($startup_controller2)
	flow = quickplay_play_song_fs
	switch $game_mode
		case training
			flow = practice_play_song_fs
		case p2_coop
		case p2_career
			flow = coop_career_play_song_fs
		case p2_faceoff
			flow = mp_faceoff_play_song_fs
		case p2_battle
		case p1_quickplay
		default
			flow = quickplay_play_song_fs
	endswitch
	start_flow_manager flow_state = <flow>
	WinPortCreateLaptopUi
	SpawnScriptLater \{start_song params = {device_num = $startup_controller}}
endscript
kill_dummy_bg_camera = $EmptyScript
restore_dummy_bg_camera = $EmptyScript
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


script blank_chart
	ExtendCrc \{$current_song '_song_expert' out = track}
	getarraysize ($<track>)
	if (<array_size> >= 3)
		if NOT ($<track>[0] = 2100000000)
			return
		endif
	endif
	flicker = 0
	CreateScreenElement {
		id = blank_chart parent = gem_containerp1 pos = ((640.0, 230.0) + ((1.0, 0.0) * ($x_offset_p2 * ($current_num_players = 2))))
		just = [center center] rgba = [ 255 0 0 255 ] type = textelement text = 'No chart inserted! Open the launcher to play a chart.' font = text_a11
	}
	begin
		flicker = (1 - <flicker>)
		SetScreenElementProps id = blank_chart alpha = <flicker>
		Wait \{0.4 seconds}
		if NOT ScreenElementExists id = blank_chart
			break
		endif
	repeat 200
endscript



nullStruct = {}
nullArray = []
nullNoteArray = [2100000000 0 0]
nullPhraseArray = [[0 0 0]]

fastgh3_song_easy = $nullNoteArray
fastgh3_song_medium = $nullNoteArray
fastgh3_song_hard = $nullNoteArray
fastgh3_song_expert = $nullNoteArray
fastgh3_song_rhythm_easy = $nullArray
fastgh3_song_rhythm_medium = $nullArray
fastgh3_song_rhythm_hard = $nullArray
fastgh3_song_rhythm_expert = $nullArray
fastgh3_song_guitarcoop_easy = $nullNoteArray
fastgh3_song_guitarcoop_medium = $nullNoteArray
fastgh3_song_guitarcoop_hard = $nullNoteArray
fastgh3_song_guitarcoop_expert = $nullNoteArray
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
fastgh3_fretbars = [ 2147483646 2147483647 ]
fastgh3_markers = [{time = 0 marker = ''}]
fastgh3_scripts = [{time = 0 scr = blank_chart}]
/**///


