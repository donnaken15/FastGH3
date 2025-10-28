net_current_flow_state = None
net_can_send_approval = 1
net_safe_to_enter_net_play = 1
player1_song_selections = [
	fastgh3
	NULL
	NULL
]
player2_song_selections = [
	fastgh3
	NULL
	NULL
]
tie_breaker_song = bullsonparade
match_type = Player
opponent_gamertag = NULL
online_song_count = 0
player2_present = 0
player1_max_song_selections = 0
player1_current_song_selections = 0
player2_max_song_selections = 0
player2_current_song_selections = 0
player1_selected_guitar = Instrument_Les_Paul_Black
player1_selected_bass = Instrument_LP_VBRST
player2_selected_guitar = Instrument_Les_Paul_Black
player2_selected_bass = Instrument_LP_VBRST
retrieved_message_of_the_day = 0
message_of_the_day = ""
OptionsGameModeValue = 0
OptionsDifficultyValue = 0
OptionsNumSongsValue = 0
OptionsTieBreakerValue = 0
OptionsHighwayValue = 0
LeaderboardSearchValue = 0
LeaderboardSongTypeValue = 0
LeaderboardDiffValue = 3
CopyOfGlobal = 0
SearchMatchTypeValue = 0
SearchGameModeValue = 0
SearchDifficultyValue = 0
SearchNumSongsValue = 0
SearchTieBreakerValue = 0
TempGameModeValue = 0
TempDifficultyValue = 0
TempNumSongsValue = 0
TempTieBreakerValue = 0
TempHighwayValue = 0
NO_NET_MODE = 1
LAN_MODE = 0
INTERNET_MODE = 0
new_net_logic = 0
pitch_dirty = 1
prev_len = 0
bPS3SingleSignOnCheckComplete = 0

xenon_singleplayer_session_init = $EmptyScript
begin_singleplayer_game = $EmptyScript
xenon_singleplayer_session_begin_uninit = $EmptyScript
xenon_singleplayer_session_complete_uninit = $EmptyScript
send_leader_board_message = $EmptyScript
net_write_single_player_stats = $EmptyScript
net_retrieve_primary_controller_score = $EmptyScript
summation_career_score = $EmptyScript
online_song_end_write_stats = $EmptyScript
online_match_end_write_stats = $EmptyScript
online_set_win_losses_streak = $EmptyScript
prepare_player_list_array = $EmptyScript
get_match_type_leaderboard_info = $EmptyScript
gameinvite_server_unavailable = $EmptyScript
destroy_join_refuse_dialog = $EmptyScript
append_animating_dots = $EmptyScript
destroy_net_popup = $EmptyScript
ShowJoinTimeoutNotice = $EmptyScript
timeout_connection_attempt = $EmptyScript
FailedToCreateGame = $EmptyScript
destroy_connection_dialog_scroller = $EmptyScript
create_timeout_dialog = $EmptyScript
create_failed_connection_dialog = $EmptyScript
net_repeat_last_search = $EmptyScript
check_if_selecting_tie_breaker = $EmptyScript
connection_lost_end_song = $EmptyScript

/*script test_events\{passed_in_value = 'test value'}
	printf \{'test_events'}
	printstruct <...>
	NetSessionFunc \{Obj = stats func = write_key_value params = {wtf_value = 'test value' key = 'test key'}}
endscript

script xenon_auto_load_progress
	printf \{'--- xenon_auto_load_progress'}
	if (($ui_flow_manager_state [0])= online_signin_fs)
		if ($online_signin_autoload_required = 1)
			Change \{online_signin_autoload_required = 0}
			Change \{respond_to_signin_changed = 0}
			fadetoblack \{On time = 0 alpha = 1.0 z_priority = 20000 id = invite_screenfader}
			wait \{1 gameframe}
			StopRendering
			shutdown_game_for_signin_change \{signin_change = 1}
			LaunchEvent \{Type = unfocus target = root_window}
			StartRendering
			wait \{1 gameframe}
			fadetoblack \{OFF time = 0 id = invite_screenfader}
			wait \{1 gameframe}
			Change invite_controller = ($primary_controller)
			start_flow_manager \{flow_state = bootup_press_any_button_fs}
		else
			ui_flow_manager_respond_to_action \{action = online_enabled}
		endif
	endif
endscript

script get_my_highway_layout
	Player = 1
	begin
		FormatText checksumName = player_status 'player%p_status' p = <Player>
		if ($<player_status>.is_local_client)
			return my_highway = ($<player_status>.highway_layout)
		endif
		<Player> = (<Player> + 1)
	repeat 2
endscript

script agora_update
	if ($coop_dlc_active = 1)
		return
	endif
	get_game_mode_name
	get_current_band_info
	GetGlobalTags <band_info>
	band_id = <band_unique_id>
	FormatText textname = band_name '%s' s = <name>
	if NOT GotParam \{new_band}
		get_difficulty_text_nl difficulty = ($current_difficulty)
		if (<game_mode_name> = p2_career)
			coop_difficulty = <difficulty_text_nl>
			get_diff_completion_percentage \{for_p2_career = 1}
		else
			career_difficulty = <difficulty_text_nl>
			get_diff_completion_percentage
		endif
		if ($game_mode = p2_career)
			coop_percent_complete_easy = (<diff_completion_percentage> [0])
			coop_score_overall_easy = (<diff_completion_score> [0])
			coop_percent_complete_medium = (<diff_completion_percentage> [1])
			coop_score_overall_medium = (<diff_completion_score> [1])
			coop_percent_complete_hard = (<diff_completion_percentage> [2])
			coop_score_overall_hard = (<diff_completion_score> [2])
			coop_percent_complete_expert = (<diff_completion_percentage> [3])
			coop_score_overall_expert = (<diff_completion_score> [3])
		else
			career_percent_complete_easy = (<diff_completion_percentage> [0])
			career_score_overall_easy = (<diff_completion_score> [0])
			career_percent_complete_medium = (<diff_completion_percentage> [1])
			career_score_overall_medium = (<diff_completion_score> [1])
			career_percent_complete_hard = (<diff_completion_percentage> [2])
			career_score_overall_hard = (<diff_completion_score> [2])
			career_percent_complete_expert = (<diff_completion_percentage> [3])
			career_score_overall_expert = (<diff_completion_score> [3])
		endif
	endif
	GetGlobalTags \{achievement_info}
	printstruct <...>
	casttointeger \{total_points_in_career_mode_easy}
	campaign_score_easy = <total_points_in_career_mode_easy>
	casttointeger \{total_points_in_career_mode_medium}
	campaign_score_medium = <total_points_in_career_mode_medium>
	casttointeger \{total_points_in_career_mode_hard}
	campaign_score_hard = <total_points_in_career_mode_hard>
	casttointeger \{total_points_in_career_mode_expert}
	campaign_score_expert = <total_points_in_career_mode_expert>
	campaign_score_overall = (<total_points_in_career_mode_expert> + <total_points_in_career_mode_hard> + <total_points_in_career_mode_medium> + <total_points_in_career_mode_easy>)
	achievements = 'what achievements?'
	purchases = 'test purchases'
	WriteUpdate <...>
endscript

script WritePerformance\{band_id = default_band_id venue = 'test venue' mode = 'test mode' submode = 'test submode' cheats = 'all cheats' title = 'killing me softly' difficulty = 'test' speed = 'test' star_power_available = 0 player_id = 0 part = 'guitar' score = 1 stars = 0 notes_hit = 2 notes_missed = 0 best_streak = 5 star_power_achieved = 1 lefty = true character_name = 'test' character_color = 1 guitar = 'test' skin = 'test' outfit = 'test'}
	if ($Cheat_AirGuitar = 1)
		air_guitar_active = air_guitar_active
	endif
	if ($Cheat_PerformanceMode = 1)
		performance_mode = performance_mode
	endif
	if ($Cheat_Hyperspeed > 0)
		hyper_speed = hyper_speed
	endif
	if ($Cheat_NoFail = 1)
		no_fail = no_fail
	endif
	if ($Cheat_EasyExpert = 1)
		easy_expert = easy_expert
	endif
	if ($Cheat_PrecisionMode = 1)
		precision_mode = precision_mode
	endif
	if ($Cheat_BretMichaels = 1)
		bret_michaels = bret_michaels
	endif
	printf \{'WritePerformance'}
	NetSessionFunc Obj = stats func = write_performance params = {<...> }
endscript

script WriteMultiPerformance\{winner = 'participant_1' venue = 'test venue' mode = 'test mode' cheats = 'all cheats' title = 'killing me softly' difficulty = 'test' speed = 'test' star_power_available = 0 player_id = 0 part = 'guitar' score = 1 stars = 0 notes_hit = 2 notes_missed = 0 best_streak = 5 star_power_achieved = 0 lefty = true character_name = 'test' character_color = 1 guitar = 'test' skin = 'test' outfit = 'test' player_id2 = 1 part2 = 'bass' score2 = 1 stars2 = 0 notes_hit2 = 2 notes_missed2 = 0 best_streak2 = 5 star_power_achieved2 = 1 lefty2 = true character_name2 = 'test' character_color2 = 'test' guitar2 = 'test' skin2 = 'test' outfit2 = 'test'}
	NetSessionFunc Obj = stats func = write_multi_match params = {<...> }
endscript

script WriteUpdate\{band_id = 0 band_name = 'test name' cash = 100 campaign_score_easy = 0 campaign_score_medium = 0 campaign_score_hard = 0 campaign_score_expert = 0 campaign_score_overall = 0 achievements = 'temp achievement string'}
	NetSessionFunc Obj = stats func = write_update params = {<...> }
endscript

script invite_accepted
	if ($primary_controller_assigned = 0)
		Change invite_controller = <controllerid>
		return
	elseif ($primary_controller != <controllerid>)
		Change invite_controller = <controllerid>
	endif
	if ((($is_network_game = 0)& ($playing_song))&
		(($game_mode = p2_battle)|| ($game_mode = p2_faceoff)|| ($game_mode = p2_pro_faceoff)|| ($game_mode = p2_career)))
		if (GameIsPaused)
			destroy_pause_menu
		endif
		create_popup_warning_menu {
			textblock = {
				text = 'Are you sure you want to leave this game session?'
				Pos = (640.0, 380.0)
			}
			player_device = <controllerid>
			menu_pos = (640.0, 465.0)
			dialog_dims = (275.0, 64.0)
			options = [
				{
					func = accepted_invite_agree
					text = 'YES'
				}
				{
					func = accepted_invite_disagree
					text = 'NO'
				}
			]
			no_background
		}
	else
		do_join_invite_stuff <...> accepted_invite
	endif
endscript

script accepted_invite_agree
	if (GameIsPaused)
		unpausegh3
	endif
	do_join_invite_stuff <...> accepted_invite
endscript

script accepted_invite_disagree
	destroy_popup_warning_menu
	if (GameIsPaused)
		create_pause_menu
	else
		pausegh3
	endif
endscript

script send_fail_song_message\{wait_frames = 30 quit_early = 0}
	if (IsHost)
		loser = 0
	else
		loser = 1
	endif
	SendNetMessage {
		Type = fail_song
		stars = ($player1_status.stars)
		note_streak = ($player1_status.best_run)
		notes_hit = ($player1_status.notes_hit)
		total_notes = ($player1_status.total_notes)
		quit_early_flag = <quit_early>
		loser = <loser>
	}
	wait <wait_frames> gameframes
endscript

script do_join_invite_stuff
endscript

script destroy_gamertags
	if ScreenElementExists \{id = gamertag_container}
		DestroyScreenElement \{id = gamertag_container}
	endif
	if ScreenElementExists \{id = gamertag_container_p1}
		DestroyScreenElement \{id = gamertag_container_p1}
	endif
	if ScreenElementExists \{id = gamertag_container_p2}
		DestroyScreenElement \{id = gamertag_container_p2}
	endif
	if ScreenElementExists \{id = debug_gamertag_container_p1}
		DestroyScreenElement \{id = debug_gamertag_container_p1}
	endif
	if ScreenElementExists \{id = debug_gamertag_container_p2}
		DestroyScreenElement \{id = debug_gamertag_container_p2}
	endif
endscript

script destroy_gamertag_container\{Player = 1}
	FormatText checksumName = gamertag_container 'gamertag_container_p%d' d = <Player>
	if ScreenElementExists id = <gamertag_container>
		DestroyScreenElement id = <gamertag_container>
	endif
endscript

script morph_gamertags
	if ScreenElementExists \{id = gamertag_container}
		move_gamertag_pos = ((1.0 - <delta>)* (($g_hud_2d_struct_used).offscreen_gamertag_pos)+ (<delta> * ((($g_hud_2d_struct_used).final_gamertag_pos)+ <off_set>)))
		DoScreenElementMorph id = gamertag_container Pos = <move_gamertag_pos> time = <time_to_move>
		if ScreenElementExists \{id = gamertag_icon_container}
			SetScreenElementProps \{id = gamertag_icon_container alpha = 0}
		endif
	endif
endscript
net_star_power_pending = 0

script coop_attempt_star_power
	if ($net_star_power_pending)
		return
	endif
	Change \{net_star_power_pending = 1}
	SendNetMessage \{Type = coop_star_power_notify}
	wait \{30 frames}
	Change \{net_star_power_pending = 0}
endscript

script test_write_leaderboards
	printf \{'test_write_leaderboards'}
	begin_singleplayer_game
	wait \{0.3 seconds ignoreslomo}
	if NOT should_update_stats_leader_board
		return
	endif
	NetSessionFunc Obj = stats func = write_stats params = {leaderboard_id = anarchy_in_the_uk score = 10000 rating = <rating_val>}
endscript

script test_read_leaderboards
	NetSessionFunc \{Obj = stats func = get_stats params = {leaderboard_id = m_test_gh3 callback = test_callback num_rows = 10 listType = rating rating_val = 5 columns = 0}}
endscript

script menu_show_gamercard
	if NOT (($is_network_game)& (isXenon))
		return
	endif
	retrieve_player_net_id \{Player = 2}
	NetSessionFunc func = showGamerCard params = {player_xuid = <net_id>}
endscript

script menu_show_gamercard_from_netid
	if NOT ($is_network_game = 1)
		return
	endif
	if GotParam \{net_id}
		NetSessionFunc func = showGamerCard params = {player_xuid = <net_id>}
	endif
endscript

script new_net_logic_init
	Change boss_controller = ($player2_status.controller)
	Change \{boss_pattern = 0}
	Change \{boss_strum = 0}
	Change \{boss_lastwhammytime = 0}
	Change \{boss_lastbrokenstringtime = 0}
	Change \{boss_hammer_count = 0}
endscript

script new_net_logic_deinit
	if ($is_network_game)
		Change StructureName = player2_status controller = ($boss_oldcontroller)
		Change \{boss_pattern = 0}
		Change \{boss_strum = 0}
		Change \{boss_lastwhammytime = 0}
		Change \{boss_lastbrokenstringtime = 0}
		Change \{boss_hammer_count = 0}
	endif
endscript

new_message_of_the_day = 0

script splash_callback
	printf \{'splash_callback'}
	printstruct <...>
	if GotParam \{motd_text}
		Change \{new_message_of_the_day = 1}
	else
		Change \{new_message_of_the_day = 0}
	endif
endscript

script test_send
	test1 = 'does this get sent?'
	test2 = DoesThisGetSent
	test3 = DoesThisGetSent2
	printstruct <...>
	SendStructure callback = test_callback data_to_send = <...>
endscript

script test_callback
	printf \{'test_callback'}
	printstruct <...>
endscript

script cleanup_online_lobby_select
	shut_down_character_hub
	destroy_pause_menu_frame \{container_id = net_quit_warning}
	if ScreenElementExists \{id = ready_container_p1}
		DestroyScreenElement \{id = ready_container_p1}
	endif
	if ScreenElementExists \{id = ready_container_p2}
		DestroyScreenElement \{id = ready_container_p2}
	endif
	destroy_pause_menu_frame
	if ScreenElementExists \{id = warning_message_container}
		DestroyScreenElement \{id = warning_message_container}
	endif
	if ScreenElementExists \{id = leaving_lobby_dialog_menu}
		DestroyScreenElement \{id = leaving_lobby_dialog_menu}
	endif
	destroy_gamertags
	shut_down_flow_manager \{Player = 2}
	clean_up_user_control_helpers
	destroy_menu \{menu_id = scrolling_character_hub_p1}
	destroy_menu \{menu_id = character_hub_p1_container}
	destroy_menu \{menu_id = scrolling_character_hub_p2}
	destroy_menu \{menu_id = character_hub_p2_container}
	KillCamAnim \{name = gs_view_cam}
	<Player> = 1
	begin
		FormatText checksumName = scrolling_select_outfit 'scrolling_select_outfit_p%i' i = <Player>
		FormatText checksumName = s_container 's_container_p%i' i = <Player>
		destroy_menu menu_id = <scrolling_select_outfit>
		destroy_menu menu_id = <s_container>
		<Player> = (<Player> + 1)
	repeat 2
	<Player> = 1
	begin
		FormatText checksumName = scrolling_select_style 'scrolling_select_style_p%i' i = <Player>
		FormatText checksumName = s_container 's_container_p%i' i = <Player>
		destroy_menu menu_id = <scrolling_select_style>
		destroy_menu menu_id = <s_container>
		<Player> = (<Player> + 1)
	repeat 2
	destroy_menu \{menu_id = scrolling_select_guitar_p1}
	destroy_menu \{menu_id = scrolling_guitar_finish_menu_p1}
	destroy_menu \{menu_id = gs_instrument_info_scroll_window}
	destroy_menu \{menu_id = select_guitar_container}
	destroy_menu \{menu_id = select_finish_container}
	destroy_menu \{menu_id = scrolling_select_guitar_p2}
	destroy_menu \{menu_id = scrolling_guitar_finish_menu_p2}
	destroy_menu \{menu_id = select_guitar_container_p2}
	destroy_menu \{menu_id = select_finish_container_p2}
	<Player> = 1
	begin
		FormatText checksumName = player_status 'player%i_status' i = <Player>
		<band_member> = ($<player_status>.band_member)
		if CompositeObjectExists name = <band_member>
			if <band_member> ::Anim_AnimNodeExists id = BodyTimer
				<band_member> ::Anim_Command target = BodyTimer Command = Timer_SetSpeed params = {speed = 1.0}
			endif
		endif
		<Player> = (<Player> + 1)
	repeat 2
	<Player> = 1
	begin
		FormatText checksumName = scrolling_select_finish 'scrolling_select_finish_p%i' i = <Player>
		destroy_menu menu_id = <scrolling_select_finish>
		<Player> = (<Player> + 1)
	repeat 2
	ui_flow_manager_respond_to_action \{action = continue}
endscript
gSavedElementInFocus = 0

script connection_lost_resume_play
	printf \{'---connection_lost_resume_play'}
	DestroyScreenElement \{id = connectionLostContainer}
	RestoreFocus
	UnPauseGame
	Change \{g_connection_loss_dialogue = 0}
	if ($winport_is_in_online_menu_system = 1)
		shut_down_flow_manager
		start_flow_manager \{flow_state = main_menu_fs}
	endif
endscript

script RemoveObserverBG
endscript

script coop_fail_song
	if ($ui_flow_manager_state [0] = online_pause_fs)
		net_unpausegh3
	endif
	disable_pause
	if (<quit_early>)
		Change \{player2_present = 0}
		FormatText textname = notification_text "%n\n has quit" n = ($opponent_gamertag)
		create_net_popup popup_text = <notification_text>
		wait \{3 seconds}
		destroy_net_popup
	endif
	Change StructureName = <player_status> stars = <stars>
	Change StructureName = <player_status> best_run = <note_streak>
	Change StructureName = <player_status> total_notes = <total_notes>
	Change StructureName = <player_status> notes_hit = <notes_hit>
	player_text = (<player_status>.text)
	killspawnedscript \{name = GuitarEvent_SongWon_Spawned}
	spawnscriptnow \{GuitarEvent_SongFailed_Spawned}
endscript

script add_searching_menu_item\{z = 2.1}
	if GotParam \{vmenu_id}
		CreateScreenElement {
			Type = ContainerElement
			parent = <vmenu_id>
			dims = (210.0, 35.0)
			Pos = (0.0, 0.0)
			just = [center top]
			internal_just = [center top]
		}
		<container_element> = <id>
		<id> ::SetProps {
			event_handlers = [
				{focus searching_menu_focus params = {parent = <id>}}
				{unfocus searching_menu_unfocus params = {parent = <id>}}
				{pad_choose <choose_script>}
			]
		}
		CreateScreenElement {
			Type = TextElement
			parent = <container_element>
			local_id = text_string
			font = fontgrid_title_gh3
			Scale = 0.65
			rgba = ($online_light_blue)
			text = <text>
			just = [center top]
			Pos = (105.0, 0.0)
			z_priority = <z>
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = <container_element>
			local_id = highlight_bar
			texture = white
			dims = (250.0, 35.0)
			rgba = ($online_light_blue)
			Pos = (105.0, -3.0)
			just = [center top]
			z_priority = <z>
			alpha = 0.0
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = <container_element>
			local_id = left_bookend
			texture = character_hub_hilite_bookend
			dims = (35.0, 35.0)
			rgba = ($online_light_blue)
			Pos = (-20.0, -3.0)
			just = [center top]
			z_priority = <z>
			alpha = 0.0
		}
		CreateScreenElement {
			Type = SpriteElement
			parent = <container_element>
			local_id = right_bookend
			texture = character_hub_hilite_bookend
			dims = (35.0, 35.0)
			rgba = ($online_light_blue)
			Pos = (240.0, -3.0)
			just = [center top]
			z_priority = <z>
			alpha = 0.0
		}
	endif
endscript

script start_final_song
	Change current_song = ($net_setlist_songs [($net_song_num)])
	SpawnScriptLater \{load_and_sync_timing params = {start_delay = 3000 player_status = player1_status}}
endscript

script server_disconnection_cleanup
	printf \{'---server_disconnection_cleanup'}
	determine_if_game_over
	Change \{player2_present = 0}
	if ($ui_flow_manager_state [0] = online_loading_fs)
	elseif ($playing_song = 0)
		if (($ui_flow_manager_state [0] = online_win_song_fs)|| ($ui_flow_manager_state [0] = online_fail_song_fs)|| ($ui_flow_manager_state [0] = online_match_stats_fs))
			if NOT ScreenElementExists \{net_popup_container}
				get_number_of_songs
				if NOT (<game_over>)
					create_connection_lost_dialog \{player_quit}
				endif
			endif
		else
			create_connection_lost_dialog \{player_quit}
		endif
	endif
endscript

script searching_menu_focus
	Obj_GetID
	if ScreenElementExists id = {<objID> child = text_string}
		DoScreenElementMorph id = {<objID> child = text_string}rgba = ($online_dark_purple)
	endif
	if ScreenElementExists id = {<objID> child = highlight_bar}
		DoScreenElementMorph id = {<objID> child = highlight_bar}alpha = 1.0
	endif
	if ScreenElementExists id = {<objID> child = left_bookend}
		DoScreenElementMorph id = {<objID> child = left_bookend}alpha = 1.0
	endif
	if ScreenElementExists id = {<objID> child = right_bookend}
		DoScreenElementMorph id = {<objID> child = right_bookend}alpha = 1.0
	endif
endscript

script searching_menu_unfocus
	Obj_GetID
	if ScreenElementExists id = {<objID> child = text_string}
		DoScreenElementMorph id = {<objID> child = text_string}rgba = ($online_light_blue)
	endif
	if ScreenElementExists id = {<objID> child = highlight_bar}
		DoScreenElementMorph id = {<objID> child = highlight_bar}alpha = 0.0
	endif
	if ScreenElementExists id = {<objID> child = left_bookend}
		DoScreenElementMorph id = {<objID> child = left_bookend}alpha = 0.0
	endif
	if ScreenElementExists id = {<objID> child = right_bookend}
		DoScreenElementMorph id = {<objID> child = right_bookend}alpha = 0.0
	endif
endscript

script set_other_player_present
	printf \{'set_other_player_present'}
	if NOT ($player2_present)
		Change \{player2_present = 1}
		spawnscriptnow \{net_hub_stream}
	endif
	if ScreenElementExists \{id = character_hub_p1_continue}
		character_hub_p1_continue ::SetProps \{rgba = [180 100 60 255] unblock_events}
	endif
	ui_print_gamertag name = ($opponent_gamertag)start_pos = (1045.0, 50.0) Color = ($player2_color)Player = 2 just = [right top] dims = (450.0, 35.0)
endscript

script test_multi_leaderboards
	Player_list = [
		{
			leaderboards = [
				{
					write_type = Max
					leaderboard_id = anarchyintheuk
					rating = 4
					score = 100
					columns = [
						{
							score = 100
						}
						{
							score = 200
						}
						{
							score = 300
						}
					]
				}
				{
					write_type = Max
					leaderboard_id = avalancha
					rating = 3
					score = 100
					columns = [
						{
							score = 100
						}
						{
							score = 200
						}
						{
							score = 300
						}
					]
				}
			]
		}
	]
	NetSessionFunc Obj = stats func = stats_write_multiplayer params = {DontEndSessionAfterWrite <...> }
endscript

script retrieve_player_net_id
	net_id = [0 0]
	if GotParam \{Player}
		FormatText checksumName = player_status 'player%i_status' i = <Player>
		SetArrayElement ArrayName = net_id index = 0 NewValue = ($<player_status>.net_id_first)
		SetArrayElement ArrayName = net_id index = 1 NewValue = ($<player_status>.net_id_second)
	else
		SetArrayElement ArrayName = net_id index = 0 NewValue = ($player1_status.net_id_first)
		SetArrayElement ArrayName = net_id index = 1 NewValue = ($player1_status.net_id_second)
	endif
	printf \{'retrieve_player_net_id'}
	printstruct <...>
	return net_id = <net_id>
endscript

script drop_client_from_character_select
	destroy_gamertags
	if (NetSessionFunc Obj = match func = get_gamertag)
		ui_print_gamertag name = <name> start_pos = (235.0, 50.0) Color = ($player1_color)Player = 1 just = [left top] dims = (450.0, 35.0)
	endif
	killspawnedscript \{name = cs_rotate_hilites_p2}
	Change \{g_cs_scroll_ready_p2 = 1}
	Change \{g_cs_choose_ready_p2 = 0}
	destroy_menu \{menu_id = char_select_character_container_p2}
	destroy_menu \{menu_id = char_select_container_p2}
	destroy_menu \{menu_id = char_select_hilite_container_p2}
	destroy_menu \{menu_id = scrolling_character_select_p2}
	Change \{player2_present = 0}
	Change \{opponent_gamertag = NULL}
	destroy_menu \{menu_id = ready_container_p2}
	if CompositeObjectExists \{name = BASSIST}
		BASSIST ::Hide
	endif
endscript

script debug_print_coop_stats\{identifier = ""}
	printf "TMR ---------------------------- %s -------------------------" s = <identifier>
	p1_score = ($player1_status.score)
	p2_score = ($player2_status.score)
	p1_health = ($player1_status.current_health)
	p2_health = ($player2_status.current_health)
	p1_note_streak = ($player1_status.best_run)
	p2_note_streak = ($player2_status.best_run)
	p1_total_notes = ($player1_status.total_notes)
	p2_total_notes = ($player2_status.total_notes)
	<p1_percent_complete> = (100 * $player1_status.notes_hit / $player1_status.total_notes)
	<p2_percent_complete> = (100 * $player2_status.notes_hit / $player2_status.total_notes)
	printstruct <...>
endscript

script get_musician_instrument_type
	get_musician_instrument_size
	index = 0
	begin
		get_musician_instrument_struct index = <index>
		if (<desc_id> = <info_struct>.desc_id)
			return instrument_type = (<info_struct>.Type)
		endif
		index = (<index> + 1)
	repeat <array_Size>
endscript

script scale_element_width_to_size\{max_text_width = 400}
	if NOT GotParam \{id}
		return
	endif
	GetScreenElementDims id = <id>
	if (<width> > <max_text_width>)
		SetScreenElementProps {
			id = <id>
			Scale = ((1.0, 0.0) + (0.0, 1.0) * (<text_scale>.(0.0, 1.0)))
		}
		scale_element_to_size {
			id = <id>
			target_width = <max_text_width>
		}
	endif
endscript

script net_dl_content_compatabilty_warning_fade_out
	wait \{10 seconds}
	if ScreenElementExists id = <id>
		<id> ::DoMorph alpha = 0.0 time = 1.0
	endif
	wait \{1 Frame}
	if ScreenElementExists \{id = dl_content_warning}
		DestroyScreenElement \{id = dl_content_warning}
	endif
endscript

script net_dl_content_compatabilty_warning
endscript

script fit_text_into_menu_item
	if ScreenElementExists id = <id>
		GetScreenElementDims id = <id>
		if (<width> > <max_width>)
			SetScreenElementProps {
				id = <id>
				Scale = 1.0
			}
			scale_element_to_size {
				id = <id>
				target_width = <max_width>
				target_height = <height>
			}
		endif
	endif
endscript

script net_coop_init_star_power
	printf \{'Trying to init star power'}
	if NOT (($player1_status.star_power_used = 1)|| ($player2_status.star_power_used = 1))
		spawnscriptnow \{star_power_activate_and_drain params = {player_status = player1_status Player = 1 player_text = 'p1'}}
		spawnscriptnow \{star_power_activate_and_drain params = {player_status = player2_status Player = 2 player_text = 'p2'}}
	endif
endscript
DEMONWARE_IS_READY = 1

script set_ready_for_input
	Change \{DEMONWARE_IS_READY = 1}
endscript

script set_demonware_failed
	Change \{DEMONWARE_IS_READY = 1}
endscript

script set_disable_demonware_input
	Change \{DEMONWARE_IS_READY = 0}
endscript
gHandlingWindowClosed = 0
gIsInNetGame = 0

script netNotifyWindowClosed
	printf \{'GTB - netNotifyWindowClosed'}
	if ($gIsInNetGame = 1)
		if ($gHandlingWindowClosed = 0)
			Change \{gHandlingWindowClosed = 1}
			create_connection_lost_dialog
		endif
	endif
endscript
