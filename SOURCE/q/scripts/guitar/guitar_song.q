stream_config = gh1
song_fsb_id = -1
song_fsb_name = 'none'
song_stream_id = NULL
song_unique_id = NULL
guitar_player1_stream_id = NULL
guitar_player1_unique_id = NULL
guitar_player2_stream_id = NULL
guitar_player2_unique_id = NULL
extra_stream_id = NULL
extra_unique_id = NULL
band_stream_id = NULL
band_unique_id = NULL
crowd_stream_id = NULL
crowd_unique_id = NULL
song_paused = 0

script preload_song\{startTime = 0 fadeintime = 0.0}
	printf "song %s" s = <song_name>
	Change \{song_stream_id = NULL}
	Change \{song_unique_id = NULL}
	Change \{guitar_player1_stream_id = NULL}
	Change \{guitar_player1_unique_id = NULL}
	Change \{guitar_player2_stream_id = NULL}
	Change \{guitar_player2_unique_id = NULL}
	Change \{extra_stream_id = NULL}
	Change \{extra_unique_id = NULL}
	Change \{band_stream_id = NULL}
	Change \{band_unique_id = NULL}
	Change \{crowd_stream_id = NULL}
	Change \{crowd_unique_id = NULL}
	get_song_prefix song = <song_name>
	get_song_struct song = <song_name>
	if StructureContains structure = <song_struct> streamname
		song_prefix = (<song_struct>.streamname)
	endif
	if NOT SongLoadFSB song_prefix = <song_prefix>
		DownloadContentLost
		return
	endif
	stream_config = gh1
	get_song_struct song = <song_name>
	if StructureContains structure = <song_struct> name = version
		stream_config = (<song_struct>.version)
	endif
	SoundBussUnlock \{Band_Balance}
	SoundBussUnlock \{Guitar_Balance}
	if StructureContains structure = <song_struct> name = band_playback_volume
		SetSoundBussParams {Band_Balance = {vol = ((<song_struct>.band_playback_volume)- 1.5)}}time = <fadeintime>
	else
		SetSoundBussParams {Band_Balance = {vol = -1.5}}time = <fadeinttime>
	endif
	if StructureContains structure = <song_struct> name = guitar_playback_volume
		SetSoundBussParams {Guitar_Balance = {vol = ((<song_struct>.guitar_playback_volume)- 1.5)}}time = <fadeintime>
	else
		SetSoundBussParams {Guitar_Balance = {vol = -1.5}}time = <fadeintime>
	endif
	SoundBussLock \{Band_Balance}
	SoundBussLock \{Guitar_Balance}
	Change stream_config = <stream_config>
	stream_infix = '_'
	//FormatText checksumName = song_stream '%s_song' s = <song_prefix> AddToStringLookup
	//FormatText checksumName = guitar_stream '%s_guitar' s = <song_prefix> AddToStringLookup
	//FormatText checksumName = rhythm_stream '%s_rhythm' s = <song_prefix> AddToStringLookup
	//FormatText checksumName = crowd_stream '%s_crowd' s = <song_prefix> AddToStringLookup
	if ($game_mode = p2_career || $game_mode = p2_coop ||
		($game_mode = training & ($player1_status.part = rhythm)))
		if StructureContains structure = <song_struct> use_coop_stream // :(
			if ($coop_tracks = 1)
				//FastFormatCrc <song_name> a = '_coop_' b = 'song' out = song_stream
				//FastFormatCrc <song_name> a = '_coop_' b = 'guitar' out = guitar_stream
				//FastFormatCrc <song_name> a = '_coop_' b = 'rhythm' out = rhythm_stream
				stream_infix = '_coop_'
				//FormatText checksumName = song_stream '%s_coop_song' s = <song_prefix> AddToStringLookup
				//FormatText checksumName = guitar_stream '%s_coop_guitar' s = <song_prefix> AddToStringLookup
				//FormatText checksumName = rhythm_stream '%s_coop_rhythm' s = <song_prefix> AddToStringLookup
			endif
		endif
	endif
	FastFormatCrc <song_name> a = <stream_infix> b = 'song' out = song_stream
	FastFormatCrc <song_name> a = <stream_infix> b = 'guitar' out = guitar_stream
	FastFormatCrc <song_name> a = <stream_infix> b = 'rhythm' out = rhythm_stream
	Change song_stream_id = <song_stream>
	if PreloadStream <song_stream> buss = Master useForSongTimeSync = 1
		Change song_unique_id = <unique_id>
	else
		ScriptAssert "Could not load song track for %s" s = <song_prefix>
	endif
	extra_stream = NULL
	if (<stream_config> = gh3)
		//Change crowd_stream_id = <crowd_stream>
		//if PreloadStream <crowd_stream> buss = Master
		//	Change crowd_unique_id = <unique_id>
		//endif
		<extra_stream> = <rhythm_stream>
	endif
	if StructureContains structure = <song_struct> name = extra_stream
		FastFormatCrc <song_name> a = '_' b = (<song_struct>.extra_stream) out = extra_stream
	endif
	if ($current_num_players = 1)
		if (($player1_status.part)= rhythm & (<stream_config> != gh1))
			if NOT PreloadStream <extra_stream> buss = Master
				ScriptAssert "Could not load player1 guitar track for %s" s = <song_prefix>
			endif
			Change guitar_player1_unique_id = <unique_id>
			<extra_stream> = <guitar_stream>
		else
			if NOT PreloadStream <guitar_stream> buss = Master
				ScriptAssert "Could not load player1 guitar track for %s" s = <song_prefix>
			endif
			Change guitar_player1_unique_id = <unique_id>
			<extra_stream> = <rhythm_stream>
		endif
		if NOT (<extra_stream> = NULL)
			Change extra_stream_id = <extra_stream>
			if PreloadStream <extra_stream> buss = Master
				Change extra_unique_id = <unique_id>
			endif
		endif
	else
		if (($player1_status.part)= rhythm & (<stream_config> != gh1))
			Change guitar_player1_stream_id = <extra_stream>
			if NOT PreloadStream <extra_stream> buss = Master
				ScriptAssert "Could not load player1 guitar track for %s" s = <song_prefix>
			endif
		else
			Change guitar_player1_stream_id = <guitar_stream>
			if NOT PreloadStream <guitar_stream> buss = Master
				ScriptAssert "Could not load player1 guitar track for %s" s = <song_prefix>
			endif
		endif
		Change guitar_player1_unique_id = <unique_id>
		if (($player2_status.part)= rhythm & (<stream_config> != gh1))
			Change guitar_player2_stream_id = <extra_stream>
			if NOT PreloadStream <extra_stream> buss = Master
				ScriptAssert "Could not load player2 guitar track for %s" s = <song_prefix>
			endif
		else
			Change guitar_player2_stream_id = <guitar_stream>
			if NOT PreloadStream <guitar_stream> buss = Master
				ScriptAssert "Could not load player2 guitar track for %s" s = <song_prefix>
			endif
		endif
		Change guitar_player2_unique_id = <unique_id>
		if (<stream_config> != gh1)
			if NOT ((($player1_status.part)= rhythm)|| (($player2_status.part)= rhythm))
				Change extra_stream_id = <extra_stream>
				if PreloadStream <extra_stream> buss = Master
					Change extra_unique_id = <unique_id>
				endif
			endif
		endif
	endif
	waitforpreload_song <...>
	Change \{song_paused = 1}
	SetLastGuitarVolume \{Player = 1 last_guitar_volume = 100}
	SetLastGuitarVolume \{Player = 2 last_guitar_volume = 100}
	startpreloadpaused_song
	WinPortGetSongSkew
	startTime = (<startTime> - <value>)
	SetSeekPosition_Song position = <startTime>
endscript

script SongUnLoadFSBIfDownloaded
	GetContentFolderIndexFromFile ($song_fsb_name)
	if NOT ($song_fsb_id = -1)
		if (<device> = content)
			UnLoadFSB \{fsb_index = $song_fsb_id}
			Downloads_CloseContentFolder content_index = <content_index>
			Change \{song_fsb_id = -1}
			Change \{song_fsb_name = 'none'}
		endif
	endif
endscript

script SongUnLoadFSB
	SongUnLoadFSBIfDownloaded
	if NOT ($song_fsb_id = -1)
		UnLoadFSB \{fsb_index = $song_fsb_id}
		Change \{song_fsb_id = -1}
		Change \{song_fsb_name = 'none'}
	endif
endscript

script SongLoadFSB
	FormatText keep_case textname = FileName '%n.fsb' n = <song_prefix>
	if ($song_fsb_name = <FileName>)
		return \{true}
	endif
	SongUnLoadFSB
	FormatText keep_case textname = fsbfilename '%n' n = <song_prefix>
	GetContentFolderIndexFromFile <FileName>
	if (<device> = content)
		if NOT Downloads_OpenContentFolder content_index = <content_index>
			return \{FALSE}
		endif
	else
		FormatText keep_case textname = fsbfilename 'music/%n' n = <song_prefix>
	endif
	if NOT LoadFSB FileName = <fsbfilename> numstreams = 5 encryptionkey = '5atu6w4zaw' device = <device>
		return \{FALSE}
	endif
	if (<fsb_index> = -1)
		Change \{song_fsb_id = -1}
		Change \{song_fsb_name = 'none'}
		ScriptAssert "could not load FSB for: %s" s = <song_prefix>
	else
		Change song_fsb_id = <fsb_index>
		Change song_fsb_name = <FileName>
	endif
	return \{true}
endscript

script waitforpreload_song
	waitforpreload_stream \{Stream = extra_unique_id}
	waitforpreload_stream \{Stream = song_unique_id}
	waitforpreload_stream \{Stream = crowd_unique_id}
	waitforpreload_stream \{Stream = guitar_player1_unique_id}
	waitforpreload_stream \{Stream = guitar_player2_unique_id}
endscript

script waitforpreload_stream\{Stream = None}
	if NOT ($<Stream> = NULL)
		begin
			if PreloadStreamDone $<Stream>
				break
			endif
			wait \{1 gameframe}
			printf "Waiting for preload %s" s = <Stream>
		repeat
	endif
endscript

script waitforseek_song
	return true
endscript

script setslomo_song
	if NOT ($song_unique_id = NULL)
		SetSoundParams unique_id = $song_unique_id pitch = (<slomo> * 100)
	endif
	if NOT ($guitar_player1_unique_id = NULL)
		SetSoundParams unique_id = $guitar_player1_unique_id pitch = (<slomo> * 100)
	endif
	if NOT ($extra_unique_id = NULL)
		SetSoundParams unique_id = $extra_unique_id pitch = (<slomo> * 100)
	endif
	if NOT ($crowd_unique_id = NULL)
		SetSoundParams unique_id = $crowd_unique_id pitch = (<slomo> * 100)
	endif
	if NOT ($guitar_player2_unique_id = NULL)
		SetSoundParams unique_id = $guitar_player2_unique_id pitch = (<slomo> * 100)
	endif
endscript
Player1Effects = {
	effect = $PitchShiftEffect1
	effect2 = $Flange_Default1
	effect3 = $Chorus_Default1
	effect4 = $Echo_Default1
	effect5 = $HighPass_Default1
	effect6 = $LowPass_Default1
	effect7 = $EQ_Default1
}
Player2Effects = {
	effect = $PitchShiftEffect2
	effect2 = $Flange_Default2
	effect3 = $Chorus_Default2
	effect4 = $Echo_Default2
	effect5 = $HighPass_Default2
	effect6 = $LowPass_Default2
	effect7 = $EQ_Default2
}
PitchShiftEffect1 = {
	effect = FastPitchShift
	name = Guitar1PitchShift
	pitch = 1.0
	maxchannels = 0
}
PitchShiftEffect2 = {
	effect = FastPitchShift
	name = Guitar2PitchShift
	pitch = 1.0
	maxchannels = 0
}
Player1PracticeEffects = {
	effect = $PitchShiftSlow1
	effect2 = $PitchShiftEffect1
}
PitchShiftSlow1 = {
	effect = PitchShift
	name = SlowGuitar1PitchShift
	pitch = 1.0
	maxchannels = 2
	fftsize = 4096
}

script startpreloadpaused_song
	both_players_lead = 0
	if (($player1_status.part)= ($player2_status.part))
		both_players_lead = 1
	endif
	if ($current_num_players = 1)
		if ($game_mode = training & $in_menu_choose_practice_section = 0)
			StartPreLoadedStream $guitar_player1_unique_id startpaused = 1 buss = First_Player_Lead_Playback pitch = ($current_speedfactor * 100)$Player1PracticeEffects
		else
			StartPreLoadedStream $guitar_player1_unique_id startpaused = 1 buss = First_Player_Lead_Playback pitch = ($current_speedfactor * 100)$Player1Effects
		endif
	else
		if (<both_players_lead> = 1)
			StartPreLoadedStream $guitar_player1_unique_id startpaused = 1 buss = First_Player_Lead_Playback pitch = ($current_speedfactor * 100)$Player1Effects $Player1Pan volL = 100 volR = 0
			StartPreLoadedStream $guitar_player2_unique_id startpaused = 1 buss = Second_Player_Lead_Playback pitch = ($current_speedfactor * 100)$Player2Effects $Player2Pan volL = 0 volR = 100
		else
			StartPreLoadedStream $guitar_player1_unique_id startpaused = 1 buss = First_Player_Lead_Playback pitch = ($current_speedfactor * 100)$Player1Effects
			StartPreLoadedStream $guitar_player2_unique_id startpaused = 1 buss = Second_Player_Rhythm_Playback pitch = ($current_speedfactor * 100)$Player2Effects
		endif
	endif
	StartPreLoadedStream $song_unique_id startpaused = 1 buss = Band_Playback pitch = ($current_speedfactor * 100)
	if NOT ($extra_stream_id = NULL)
		StartPreLoadedStream $extra_unique_id startpaused = 1 buss = Single_Player_Rhythm_Playback pitch = ($current_speedfactor * 100)
	endif
	if NOT ($crowd_unique_id = NULL)
		StartPreLoadedStream $crowd_unique_id startpaused = 1 buss = Crowd_Singalong pan1x = -1 pan1y = -0.5 pan2x = 1 pan2y = -0.5 pitch = ($current_speedfactor * 100)
	endif
endscript

no_sync = 0
script begin_song_after_intro
	WinPortGetSongSkew
	begin
		GetSongTimeMs
		time = (<time> + <value>)
		if (<time> >= <starttimeafterintro>)
			break
		endif
		wait \{1 gameframe}
	repeat
	begin_song
	if ($no_sync = 0)
		WinPortSongHighwaySync \{sync = 1}
	endif
endscript
script begin_video_after_intro
	if ($enable_video = 0)
		return
	endif
	starttimeafterintro = (<starttimeafterintro> + $video_start_on_time)
	begin
		GetSongTimeMs
		if (<time> >= <starttimeafterintro>)
			break
		endif
		wait \{1 gameframe}
	repeat
	preload_bgbink
	spawnscriptnow \{bgbink_calc_fps}
	begin
		if isMoviePreLoaded \{textureSlot = 2}
			StartPreLoadedMovie \{textureSlot = 2}
			return
		endif
		Wait \{1 gameframe}
	repeat
endscript

script begin_song\{Pause = 0}
	lockdsp
	PauseSound unique_id = $song_unique_id Pause = <Pause>
	PauseSound unique_id = $guitar_player1_unique_id Pause = <Pause>
	if NOT ($extra_stream_id = NULL)
		PauseSound unique_id = $extra_unique_id Pause = <Pause>
	endif
	if NOT ($crowd_stream_id = NULL)
		PauseSound unique_id = $crowd_unique_id Pause = <Pause>
	endif
	if NOT ($guitar_player2_stream_id = NULL)
		PauseSound unique_id = $guitar_player2_unique_id Pause = <Pause>
	endif
	unlockdsp
	Change \{song_paused = 0}
endscript

script SetSeekPosition_Song\{position = 0}
	WinPortGetSongSkew
	position = (<position> + <value>)
	//printstruct <...>
	if NOT ($song_unique_id = NULL)
		SetSoundSeekPosition unique_id = $song_unique_id position = <position>
	endif
	if NOT ($guitar_player1_unique_id = NULL)
		if ($game_mode = training & $in_menu_choose_practice_section = 0)
			SetSoundSeekPosition unique_id = $guitar_player1_unique_id position = (<position> - ($default_practice_mode_pitchshift_offset_song))
		else
			SetSoundSeekPosition unique_id = $guitar_player1_unique_id position = <position>
		endif
	endif
	if NOT ($extra_unique_id = NULL)
		SetSoundSeekPosition unique_id = $extra_unique_id position = <position>
	endif
	if NOT ($crowd_unique_id = NULL)
		SetSoundSeekPosition unique_id = $crowd_unique_id position = <position>
	endif
	if NOT ($guitar_player2_unique_id = NULL)
		SetSoundSeekPosition unique_id = $guitar_player2_unique_id position = <position>
	endif
endscript
Waiting_For_Pitching = 0

script Failed_Song_Pitch_Down
	SoundBussUnlock \{Guitar_Balance}
	SoundBussUnlock \{Band_Balance}
	SetSoundBussParams \{Band_Balance = {vol = -20 pitch = -8}time = 3}
	SetSoundBussParams \{Guitar_Balance = {vol = -20 pitch = -8}time = 3}
	Change \{Waiting_For_Pitching = 1}
	SoundBussLock \{Band_Balance}
	SoundBussLock \{Guitar_Balance}
	wait \{3 seconds}
	spawnscriptnow \{end_song}
endscript

script end_song\{song_failed_pitch_streams = 0}
	if IsWinPort
		WinPortSongHighwaySync \{sync = 0}
	endif
	if NOT (<song_failed_pitch_streams> = 1)
		killspawnedscript \{name = Failed_Song_Pitch_Down}
		if ($Waiting_For_Pitching = 1)
			Change \{Waiting_For_Pitching = 0}
			SoundBussUnlock \{Guitar_Balance}
			SoundBussUnlock \{Band_Balance}
			SetSoundBussParams {Band_Balance = {vol = (($Default_BussSet.Band_Balance.vol)- 2.5)pitch = ($Default_BussSet.Band_Balance.pitch)}}
			SetSoundBussParams {Guitar_Balance = {vol = (($Default_BussSet.Guitar_Balance.vol)- 2.5)pitch = ($Default_BussSet.Guitar_Balance.pitch)}}
			SoundBussLock \{Band_Balance}
			SoundBussLock \{Guitar_Balance}
		endif
		StopStream \{unique_id = $song_unique_id}
		StopStream \{unique_id = $guitar_player1_unique_id}
	else
		printf \{channel = SFX "We are pitching the stream down because we failed"}
		spawnscriptnow \{Failed_Song_Pitch_Down}
	endif
	if NOT ($extra_unique_id = NULL)
		StopStream \{unique_id = $extra_unique_id}
	endif
	if NOT ($crowd_unique_id = NULL)
		StopStream \{unique_id = $crowd_unique_id}
	endif
	if NOT ($guitar_player2_unique_id = NULL)
		StopStream \{unique_id = $guitar_player2_unique_id}
	endif
	Change \{song_paused = 0}
endscript
p1_whammy_control = 0.0

script set_whammy_pitchshift
	if ($<player_status>.Player = 1)
		setsoundbusseffects effect = {effect = PitchShift name = Guitar1PitchShift pitch = (1 - (<control> * 0.057))}
		Change p1_whammy_control = <control>
	else
		setsoundbusseffects effect = {effect = PitchShift name = Guitar2PitchShift pitch = (1 - (<control> * 0.057))}
	endif
endscript

script PauseGh3Sounds
	lockdsp
	PauseSoundsByBuss \{Master}
	unlockdsp
	if NOT GotParam \{no_seek}
		GetSongTimeMs
		casttointeger \{time}
		if (<time> > $current_starttime)
			if NOT GotParam \{seek_on_unpause}
				SetSeekPosition_Song position = <time>
			endif
		endif
	endif
endscript

script UnpauseGh3Sounds
	if GotParam \{seek_on_unpause}
		GetSongTimeMs
		casttointeger \{time}
		if (<time> > $current_starttime)
			SetSeekPosition_Song position = <time>
		endif
	endif
	lockdsp
	if ($song_paused = 0)
		UnpauseSoundsByBuss \{Master}
	else
		UnpauseSoundsByBuss \{UI}
		UnpauseSoundsByBuss \{Crowd_One_Shots}
		UnpauseSoundsByBuss \{Crowd_One_Shots_Negative}
		UnpauseSoundsByBuss \{Crowd_Beds}
		UnpauseSoundsByBuss \{Crowd_Cheers}
		UnpauseSoundsByBuss \{Crowd_Boos}
		UnpauseSoundsByBuss \{Crowd_Nuetral}
		UnpauseSoundsByBuss \{}
		UnpauseSoundsByBuss \{Test_Tones}
		UnpauseSoundsByBuss \{Practice_Band_Playback}
		UnpauseSoundsByBuss \{Test_Tones_DSP}
		UnpauseSoundsByBuss \{Right_Notes_Player2}
		UnpauseSoundsByBuss \{Wrong_Notes_Player1}
		UnpauseSoundsByBuss \{Wrong_Notes_Player2}
		UnpauseSoundsByBuss \{User_Vocal}
		UnpauseSoundsByBuss \{User_Music}
		UnpauseSoundsByBuss \{Encore_Events}
		UnpauseSoundsByBuss \{BinkCutScenes}
	endif
	unlockdsp
endscript
exit_on_song_end = 0

script ExitOnSongEnd
	if ($exit_on_song_end = 1)
		ResetEngine
	endif
endscript
