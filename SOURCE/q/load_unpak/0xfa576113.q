player1_status = {}
player2_status = {}

qdir = []

// todo: recursive wildcard?
script init
	printf \{'Q Unpack'}
	printf \{'Loading scripts...'}
	qdir = [
		'aaaaloopchecker'
		'discord/activity'
		'engine/buttonscripts'
		'engine/camera'
		'engine/controller_pulling'
		'engine/debug'
		'engine/eventlog'
		'engine/gfxutils'
		'engine/menu/dialogbox'
		'engine/menu/helper_text'
		'engine/menu/lighttool'
		'engine/menu/menubuttonremap'
		'engine/menu/menu_stack'
		'engine/quadtree'
		'engine/reverb'
		'engine/screenelemmasks'
		'engine/sfxutils'
		'engine/softassert'
		'engine/system_notifications'
		'engine/tod_profiles'
		'engine/tod_proxims'
		'engine/viewports'
		'engine/viewport_params'
		'fastgh3/hacking'
		'fastgh3/console'
		'fastgh3/convars'
		'fastgh3/eval'
		'fx/misc_fx'
		'fx/particle_scripts'
		'game/audio/audio_effects_settings'
		'game/audio/backgrounds_logic'
		'game/audio/global_sound_events'
		'game/audio/global_sound_logic'
		'game/audio/sound_buss'
		'game/menu/buttons'
		'game/menu/gamemenu_helpers'
		'game/menu/metachars'
		'game/menu/tiled_background'
		'game/net/guitar_net'
		'game/net/menu_net_character_select'
		'game/net/menu_net_choose_part'
		'game/net/menu_net_custom_create'
		'game/net/menu_net_detailed_stats'
		'game/net/menu_net_final_setlist'
		'game/net/menu_net_guitar_select'
		'game/net/menu_net_joining_server'
		'game/net/menu_net_matchtype'
		'game/net/menu_net_newspaper'
		'game/net/menu_net_num_songs'
		'game/net/menu_net_options'
		'game/net/menu_net_privatematch'
		'game/net/menu_net_quickmatch'
		'game/net/menu_net_select_difficulty'
		'game/net/menu_net_server_list'
		'game/net/menu_net_setlist'
		'game/net/menu_net_signin'
		'game/net/menu_net_song_select'
		'game/net/menu_net_tiebreaker'
		'game/net/netoptions'
		'game/net/net_guitar_battle'
		'game/net/net_guitar_hud'
		'game/net/net_guitar_hud_2d_battle'
		'game/net/net_guitar_hud_2d_faceoff'
		'game/net/net_settings'
		'game/net/net_signin'
		'game/net/xenon_net'
		'game/object'
		'game/object_creation'
		'game/pass_startup'
		'game/skater/physics'
		'game/skeleton'
		'game/skutils'
		'game/startup'
		'game/useless'
		'game/utils'
		'game/zone_links'
		'game/zone_management'
		'guitar/guitar'
		'guitar/guitar_animation_data'
		'guitar/guitar_band_profile_data'
		'guitar/guitar_battle'
		'guitar/guitar_battle_hud_icons'
		'guitar/guitar_boss'
		'guitar/guitar_callback'
		'guitar/guitar_character_pak_funcs'
		'guitar/guitar_crowd'
		'guitar/guitar_debug'
		'guitar/guitar_debug_menu'
		'guitar/guitar_difficulty'
		'guitar/guitar_events'
		'guitar/guitar_faceoff'
		'guitar/guitar_fretbar'
		'guitar/guitar_gems'
		'guitar/guitar_globaltags'
		'guitar/guitar_highway'
		'guitar/guitar_hud'
		'guitar/guitar_hud_2d'
		'guitar/guitar_hud_2d_battle'
		'guitar/guitar_hud_2d_career'
		'guitar/guitar_hud_2d_coop_career'
		'guitar/guitar_hud_2d_faceoff'
		'guitar/guitar_input'
		'guitar/guitar_intro'
		'guitar/guitar_memcard'
		'guitar/guitar_menu'
		'guitar/guitar_movies'
		'guitar/guitar_notemaps'
		'guitar/guitar_pause'
		'guitar/guitar_practice'
		'guitar/guitar_progression'
		'guitar/guitar_score'
		'guitar/guitar_solo'
		'guitar/guitar_song'
		'guitar/guitar_starpower'
		'guitar/guitar_training'
		'guitar/guitar_transitions'
		'guitar/guitar_tweaks'
		'guitar/highway_2d'
		'guitar/menu/bootup_menu_flow'
		'guitar/menu/career_menu_flow'
		'guitar/menu/coop_career_menu_flow'
		'guitar/menu/gamma_brightness_menu'
		'guitar/menu/guitar_training_battle_tutorial'
		'guitar/menu/guitar_training_funcs'
		'guitar/menu/guitar_training_star_power_tutorial'
		'guitar/menu/loading_screen'
		'guitar/menu/main_menu_flow'
		'guitar/menu/menus_whammy_star_calibration'
		'guitar/menu/menu_alert_popup'
		'guitar/menu/menu_audio_settings'
		'guitar/menu/menu_beat_game'
		'guitar/menu/menu_bonus_videos'
		'guitar/menu/menu_boss_confirmation'
		'guitar/menu/menu_calibrate_lag'
		'guitar/menu/menu_calibrate_lag_warning'
		'guitar/menu/menu_choose_band'
		'guitar/menu/menu_choose_part'
		'guitar/menu/menu_choose_practice_part'
		'guitar/menu/menu_choose_practice_section'
		'guitar/menu/menu_choose_practice_speed'
		'guitar/menu/menu_confirm_band_delete'
		'guitar/menu/menu_controller_disconnect'
		'guitar/menu/menu_controller_settings'
		'guitar/menu/menu_credits'
		'guitar/menu/menu_data_settings'
		'guitar/menu/menu_detailed_stats'
		'guitar/menu/menu_encore_confirmation'
		'guitar/menu/menu_fail_song'
		'guitar/menu/menu_flow_manager'
		'guitar/menu/menu_guitar_battle_help'
		'guitar/menu/menu_lefty_flip_warning'
		'guitar/menu/menu_login_settings'
		'guitar/menu/menu_manage_band'
		'guitar/menu/menu_memcard_messages'
		'guitar/menu/menu_mp_select_mode'
		'guitar/menu/menu_newspaper'
		'guitar/menu/menu_no_band_name'
		'guitar/menu/menu_options'
		'guitar/menu/menu_popup'
		'guitar/menu/menu_practice_end'
		'guitar/menu/menu_practice_pause'
		'guitar/menu/menu_practice_warning'
		'guitar/menu/menu_press_any_button'
		'guitar/menu/menu_quit_warning'
		'guitar/menu/menu_restart_warning'
		'guitar/menu/menu_select_controller'
		'guitar/menu/menu_select_difficulty'
		'guitar/menu/menu_select_practice_mode'
		'guitar/menu/menu_signin_changed'
		'guitar/menu/menu_song_ended'
		'guitar/menu/menu_top_rockers'
		'guitar/menu/menu_transitions'
		'guitar/menu/menu_tutorial_select'
		'guitar/menu/menu_using_guitar_controller'
		'guitar/menu/menu_venue'
		'guitar/menu/menu_video_settings'
		'guitar/menu/menu_wuss_out'
		'guitar/menu/multiplayer_menu_flow'
		'guitar/menu/options_menu_flow'
		'guitar/menu/practice_menu_flow'
		'guitar/menu/quickplay_menu_flow'
		'guitar/menu/winport_menu_bind_buttons'
		'guitar/menu/winport_menu_graphics'
		'guitar/menu/winport_menu_song_skew'
		'guitar/menu/winport_menu_song_skew_warning'
		'guitar/songlist'
		'guitar/store_data'
	]
	change qdir = <qdir>
	GetArraySize \{qdir}
	i = 0
	begin
		FormatText textname = path 'scripts/%q.qb' q = (<qdir>[<i>])
		printf 'Loading %q' q = <path>
		LoadQB <path>
		Increment \{i}
	repeat <array_Size>
	guitar_startup
endscript

nullArray = []
Terrain_Actions = $nullArray
Terrain_Types = $nullArray

nullStruct = {}
permanent_songlist_props = $nullStruct
guitarist_finger_anims_small = $nullStruct
guitarist_finger_anims_medium = $nullStruct
guitarist_finger_anims_large = $nullStruct
fret_anims = $nullStruct
fret_anims_sml = $nullStruct
fret_anims_med = $nullStruct
fret_anims_lrg = $nullStruct
drummer_anims = $nullStruct
drummer_left_arm_twist_factors = $nullStruct
drummer_right_arm_twist_factors = $nullStruct
tilt_default_settings = {}
tilt_params = {}
viewport_base = {
	rect = [
		0.0
		0.0
		1.0
		1.0
	]
	resolve_to_texture_with_alpha
	resolution = 1.0
}
viewport_params = {
	perm_viewports = [
		{
			id = UI
			Priority = 0
			has_ui = true
			has_ui_only = true
			clear_colorbuffer = true
			clear_depthstencilbuffer = FALSE
		}
	]
	default_screen_mode = one_camera
	screen_modes = [
		{
			id = one_camera
			viewports = [
				{
					id = UI
					Active = true
					style = fullscreen
				}
			]
			shadow_map_size = (1024.0, 512.0)
		}
	]
	styles = {
		fullscreen = {
			rect = [
				0.0
				0.0
				1.0
				1.0
			]
		}
		cutscene_movie_surface = {
			rect = [
				0.0
				0.0
				1.0
				1.0
			]
			render_to_texture_with_alpha
			width = 768
			height = 320
			copy_to_main
			resolution = 1.0
			discard_previous_frame
		}
		cutscene_movie_surface_fs = {
			rect = [
				0.0
				0.0
				1.0
				1.0
			]
			render_to_texture_with_alpha
			copy_to_main
			resolution = 0.5
			discard_previous_frame
		}
		viewport_element = {
			rect = [
				0.0
				0.0
				1.0
				1.0
			]
			render_to_texture
			ignore_alpha_channel
			resolution = 0.5
		}
		viewport_photo = {
			rect = [
				0.0
				0.0
				1.0
				1.0
			]
			render_to_texture
			ignore_alpha_channel
			resolution = 0.75
		}
		viewport_element_square = {
			rect = [
				0.0
				0.0
				0.5625
				1.0
			]
			render_to_texture
			ignore_alpha_channel
			resolution = 0.5
		}
		fullscreen_with_debug = {
			rect = [
				0.0
				0.0
				0.75
				0.75
			]
			discard_previous_frame
		}
		shadow_big = {
			rect = [
				0.0
				0.0
				1.0
				1.0
			]
			width = 1024
			height = 1024
			depth_only
		}
		shadow_small = {
			rect = [
				0.0
				0.0
				1.0
				1.0
			]
			width = 512
			height = 512
			depth_only
		}
		imposter_rendering = {
			rect = [
				0.0
				0.0
				1.0
				1.0
			]
			width = 128
			height = 256
			render_to_texture_with_alpha
			mipmap
			resolution = 1.0
		}
		imposter_rendering_highres = {
			rect = [
				0.0
				0.0
				1.0
				1.0
			]
			width = 256
			height = 512
			render_to_texture_with_alpha
			mipmap
			resolution = 1.0
		}
		highway_fader = {
			$viewport_base
			resolve_rect = [
				0
				0
				1280
				720
			]
		}
		highway_fader_2p = {
			$viewport_base
			resolve_rect = [
				0
				0
				1280
				720
			]
		}
		highway_fader_ps3 = {
			$viewport_base
			resolve_rect = [
				0
				0
				1280
				720
			]
			resolve_rect = [
				0
				0
				1040
				592
			]
		}
		debug_0 = {
			rect = [
				0.75
				0.0
				0.25
				0.25
			]
		}
		debug_1 = {
			rect = [
				0.75
				0.25
				0.25
				0.25
			]
		}
		debug_2 = {
			rect = [
				0.75
				0.5
				0.25
				0.25
			]
		}
		debug_3 = {
			rect = [
				0.75
				0.75
				0.25
				0.25
			]
		}
		debug_4 = {
			rect = [
				0.5
				0.75
				0.25
				0.25
			]
		}
		debug_5 = {
			rect = [
				0.25
				0.75
				0.25
				0.25
			]
		}
		debug_6 = {
			rect = [
				0.0
				0.75
				0.25
				0.25
			]
		}
	}
}
Default_Particle_LOD_Dist_Pair = (0.0, 0.0)
Default_Fast_Particle_LOD_Dist_Pair = (0.0, 0.0)
guitarist_info = $nullStruct
bassist_info = $nullStruct
vocalist_info = $nullStruct
drummer_info = $nullStruct
