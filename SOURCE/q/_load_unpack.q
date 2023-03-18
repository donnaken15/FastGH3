player1_status = {
}
player2_status = {
}

script init
	printf \{'Q Unpack'}
	printf \{'Loading scripts...'}
	qdir = [
		'nodeflags.qb'
		'aaaaloopchecker.qb'
		'misclightutils.qb'
		'profile_ped_params.qb'
		'debugger/anim_grove.qb'
		'debugger/debugger.qb'
		'debugger/debugger_scripts.qb'
		'debugger/mouse.qb'
		'discord/activity.qb'
		'engine/buttonscripts.qb'
		'engine/camera.qb'
		'engine/controller_pulling.qb'
		'engine/debug.qb'
		'engine/eventlog.qb'
		'engine/gfxutils.qb'
		'engine/movies.qb'
		'engine/quadtree.qb'
		'engine/reverb.qb'
		'engine/screenelemmasks.qb'
		'engine/sfxutils.qb'
		'engine/softassert.qb'
		'engine/system_notifications.qb'
		'engine/tod_manager.qb'
		'engine/tod_profiles.qb'
		'engine/tod_proxims.qb'
		'engine/viewports.qb'
		'engine/viewport_params.qb'
		'engine/menu/consolemessage.qb'
		'engine/menu/dialogbox.qb'
		'engine/menu/graphic_test.qb'
		'engine/menu/helper_text.qb'
		'engine/menu/keyboard.qb'
		'engine/menu/lighttool.qb'
		'engine/menu/lighttool_launcher.qb'
		'engine/menu/menubuttonremap.qb'
		'engine/menu/menu_stack.qb'
		'engine/menu/misctools.qb'
		'engine/menu/panelmessage.qb'
		'engine/menu/sliderbar.qb'
		'engine/menu/structure_control_menu.qb'
		'fastgh3/hacking.qb'
		'fx/env_fx.qb'
		'fx/lightshow.qb'
		'fx/misc_fx.qb'
		'fx/particle_default_params.qb'
		'fx/particle_scripts.qb'
		'fx/particle_update_scripts.qb'
		'fx/shatter_data.qb'
		'fx/splat_data.qb'
		'fx/particles/particle_assets.qb'
		'game/animevents.qb'
		'game/coim.qb'
		'game/load_level.qb'
		'game/object.qb'
		'game/object_creation.qb'
		'game/pass_startup.qb'
		'game/skeleton.qb'
		'game/skutils.qb'
		'game/startup.qb'
		'game/utils.qb'
		'game/zone_links.qb'
		'game/zone_management.qb'
		'game/audio/audio_effects_settings.qb'
		'game/audio/backgrounds_logic.qb'
		'game/audio/global_sound_events.qb'
		'game/audio/global_sound_logic.qb'
		'game/audio/sound_buss.qb'
		'game/igc/igccameradetails.qb'
		'game/menu/animpreview.qb'
		'game/menu/buttons.qb'
		'game/menu/gamemenu_helpers.qb'
		'game/menu/metachars.qb'
		'game/menu/tiled_background.qb'
		'game/menu/uistatemachine.qb'
		'game/net/guitar_net.qb'
		'game/net/menu_net_character_select.qb'
		'game/net/menu_net_choose_part.qb'
		'game/net/menu_net_custom_create.qb'
		'game/net/menu_net_detailed_stats.qb'
		'game/net/menu_net_final_setlist.qb'
		'game/net/menu_net_guitar_select.qb'
		'game/net/menu_net_joining_server.qb'
		'game/net/menu_net_matchtype.qb'
		'game/net/menu_net_newspaper.qb'
		'game/net/menu_net_num_songs.qb'
		'game/net/menu_net_options.qb'
		'game/net/menu_net_privatematch.qb'
		'game/net/menu_net_quickmatch.qb'
		'game/net/menu_net_select_difficulty.qb'
		'game/net/menu_net_server_list.qb'
		'game/net/menu_net_setlist.qb'
		'game/net/menu_net_signin.qb'
		'game/net/menu_net_song_select.qb'
		'game/net/menu_net_tiebreaker.qb'
		'game/net/netoptions.qb'
		'game/net/net_guitar_battle.qb'
		'game/net/net_guitar_hud.qb'
		'game/net/net_guitar_hud_2d_battle.qb'
		'game/net/net_guitar_hud_2d_faceoff.qb'
		'game/net/net_settings.qb'
		'game/net/net_signin.qb'
		'game/net/xenon_net.qb'
		'game/skater/physics.qb'
		'guitar/guitar.qb'
		'guitar/guitar_animation_data.qb'
		'guitar/guitar_anim_tree.qb'
		'guitar/guitar_band_profile.qb'
		'guitar/guitar_band_profile_data.qb'
		'guitar/guitar_battle.qb'
		'guitar/guitar_battle_hud_icons.qb'
		'guitar/guitar_boss.qb'
		'guitar/guitar_callback.qb'
		'guitar/guitar_cameras.qb'
		'guitar/guitar_character.qb'
		'guitar/guitar_character_pak_funcs.qb'
		'guitar/guitar_crowd.qb'
		'guitar/guitar_debug.qb'
		'guitar/guitar_debug_menu.qb'
		'guitar/guitar_difficulty.qb'
		'guitar/guitar_events.qb'
		'guitar/guitar_faceoff.qb'
		'guitar/guitar_fretbar.qb'
		'guitar/guitar_gems.qb'
		'guitar/guitar_globaltags.qb'
		'guitar/guitar_hand_events.qb'
		'guitar/guitar_highway.qb'
		'guitar/guitar_hud.qb'
		'guitar/guitar_hud_2d.qb'
		'guitar/guitar_hud_2d_battle.qb'
		'guitar/guitar_hud_2d_career.qb'
		'guitar/guitar_hud_2d_coop_career.qb'
		'guitar/guitar_hud_2d_faceoff.qb'
		'guitar/guitar_input.qb'
		'guitar/guitar_intro.qb'
		'guitar/guitar_memcard.qb'
		'guitar/guitar_menu.qb'
		'guitar/guitar_movies.qb'
		'guitar/guitar_notemaps.qb'
		'guitar/guitar_pause.qb'
		'guitar/guitar_practice.qb'
		'guitar/guitar_progression.qb'
		'guitar/guitar_score.qb'
		'guitar/guitar_solo.qb'
		'guitar/guitar_song.qb'
		'guitar/guitar_starpower.qb'
		'guitar/guitar_training.qb'
		'guitar/guitar_transitions.qb'
		'guitar/guitar_tweaks.qb'
		'guitar/highway_2d.qb'
		'guitar/songlist.qb'
		'guitar/store_data.qb'
		'guitar/menu/bootup_menu_flow.qb'
		'guitar/menu/career_menu_flow.qb'
		'guitar/menu/coop_career_menu_flow.qb'
		'guitar/menu/gamma_brightness_menu.qb'
		'guitar/menu/guitar_training_battle_tutorial.qb'
		'guitar/menu/guitar_training_funcs.qb'
		'guitar/menu/guitar_training_star_power_tutorial.qb'
		'guitar/menu/loading_screen.qb'
		'guitar/menu/main_menu_flow.qb'
		'guitar/menu/menus_whammy_star_calibration.qb'
		'guitar/menu/menu_alert_popup.qb'
		'guitar/menu/menu_audio_settings.qb'
		'guitar/menu/menu_beat_game.qb'
		'guitar/menu/menu_bonus_videos.qb'
		'guitar/menu/menu_boss_confirmation.qb'
		'guitar/menu/menu_calibrate_lag.qb'
		'guitar/menu/menu_calibrate_lag_warning.qb'
		'guitar/menu/menu_cash_reward.qb'
		'guitar/menu/menu_cheats.qb'
		'guitar/menu/menu_choose_band.qb'
		'guitar/menu/menu_choose_part.qb'
		'guitar/menu/menu_choose_practice_part.qb'
		'guitar/menu/menu_choose_practice_section.qb'
		'guitar/menu/menu_choose_practice_speed.qb'
		'guitar/menu/menu_confirm_band_delete.qb'
		'guitar/menu/menu_controller_disconnect.qb'
		'guitar/menu/menu_controller_settings.qb'
		'guitar/menu/menu_credits.qb'
		'guitar/menu/menu_data_settings.qb'
		'guitar/menu/menu_detailed_stats.qb'
		'guitar/menu/menu_encore_confirmation.qb'
		'guitar/menu/menu_fail_song.qb'
		'guitar/menu/menu_flow_manager.qb'
		'guitar/menu/menu_guitar_battle_help.qb'
		'guitar/menu/menu_lefty_flip_warning.qb'
		'guitar/menu/menu_login_settings.qb'
		'guitar/menu/menu_manage_band.qb'
		'guitar/menu/menu_memcard_messages.qb'
		'guitar/menu/menu_mp_select_mode.qb'
		'guitar/menu/menu_newspaper.qb'
		'guitar/menu/menu_no_band_name.qb'
		'guitar/menu/menu_options.qb'
		'guitar/menu/menu_popup.qb'
		'guitar/menu/menu_practice_end.qb'
		'guitar/menu/menu_practice_pause.qb'
		'guitar/menu/menu_practice_warning.qb'
		'guitar/menu/menu_press_any_button.qb'
		'guitar/menu/menu_quit_warning.qb'
		'guitar/menu/menu_restart_warning.qb'
		'guitar/menu/menu_select_controller.qb'
		'guitar/menu/menu_select_difficulty.qb'
		'guitar/menu/menu_select_practice_mode.qb'
		'guitar/menu/menu_signin_changed.qb'
		'guitar/menu/menu_song_ended.qb'
		'guitar/menu/menu_top_rockers.qb'
		'guitar/menu/menu_transitions.qb'
		'guitar/menu/menu_tutorial_select.qb'
		'guitar/menu/menu_unlock.qb'
		'guitar/menu/menu_using_guitar_controller.qb'
		'guitar/menu/menu_venue.qb'
		'guitar/menu/menu_video_settings.qb'
		'guitar/menu/menu_wuss_out.qb'
		'guitar/menu/multiplayer_menu_flow.qb'
		'guitar/menu/options_menu_flow.qb'
		'guitar/menu/practice_menu_flow.qb'
		'guitar/menu/quickplay_menu_flow.qb'
		'guitar/menu/winport_menu_bind_buttons.qb'
		'guitar/menu/winport_menu_graphics.qb'
		'guitar/menu/winport_menu_song_skew.qb'
		'guitar/menu/winport_menu_song_skew_warning.qb'
		'songs/bossbattle_scripts.qb'
		'songs/improv2_scripts.qb'
		'songs/improv_scripts.qb'
	]
	GetArraySize \{qdir}
	i = 0
	begin
		formattext textname=path 'scripts/%q' q = (<qdir>[<i>])
		printf 'Loading %q' q = <path>
		LoadQB <path>
		i = (<i> + 1)
	repeat <array_size>
	spawnscriptnow \{guitar_startup}
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
tilt_default_settings = {
}
tilt_params = {
}
viewport_params = {
	perm_viewports = [
		{
			id = UI
			Priority = 0
			has_ui = true
			has_ui_only = true
			clear_colorbuffer = FALSE
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
			rect = [
				0.0
				0.0
				1.0
				1.0
			]
			resolve_rect = [
				0
				0
				1280
				720
			]
			resolve_to_texture_with_alpha
			resolution = 1.0
		}
		highway_fader_2p = {
			rect = [
				0.0
				0.0
				1.0
				1.0
			]
			resolve_rect = [
				0
				0
				1280
				720
			]
			resolve_to_texture_with_alpha
			resolution = 1.0
		}
		highway_fader_ps3 = {
			rect = [
				0.0
				0.0
				1.0
				1.0
			]
			resolve_rect = [
				0
				0
				1040
				592
			]
			resolve_to_texture_with_alpha
			resolution = 1.0
		}
		highway_fader_2p_ps3 = {
			rect = [
				0.0
				0.0
				1.0
				1.0
			]
			resolve_rect = [
				0
				0
				1040
				592
			]
			resolve_to_texture_with_alpha
			resolution = 1.0
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
