CameraCuts_Good_Array = None
CameraCuts_Normal_Array = None
CameraCuts_Poor_Array = None
CameraCuts_Performance = None
CameraCuts_LastArray = None
CameraCuts_LastPerformance = None
CameraCuts_Enabled = FALSE
CameraCuts_LastIndex = 0
CameraCuts_LastType = None
CameraCuts_LastDownbeatIndex = 0
CameraCuts_ChangeTime = 0
CameraCuts_ChangeNow = FALSE
CameraCuts_ForceTime = 0
CameraCuts_NextTime = 0
CameraCuts_ArrayPrefix = 'Cameras'
CameraCuts_ForceType = None
CameraCuts_NextName = None
CameraCuts_ChangeCamEnable = FALSE
CameraCuts_AllowNoteScripts = FALSE
CameraCuts_LastCameraStartTime = 0.0
CameraCuts_ForceChangeTime = 0.0
CameraCuts_ShadowCasters = None
CameraCuts_NextNoteCameraTime = -1
CameraCuts_NoteMapping = [
]

script cameracuts_iterator
	printf "Cameras Iterator started with time %d" d = <time_offset>
	Change \{CameraCuts_NextNoteCameraTime = -1}
	get_song_prefix song = <song_name>
	FormatText checksumName = event_array '%s_cameras_notes' s = <song_prefix> AddToStringLookup
	if NOT GlobalExists name = <event_array> Type = array
		return
	endif
	array_entry = 0
	fretbar_count = 0
	GetArraySize $<event_array>
	GetSongTimeMs time_offset = <time_offset>
	if NOT (<array_Size> = 0)
		begin
			if ((<time> - <skipleadin>)< $<event_array> [<array_entry>] [0])
				break
			endif
			<array_entry> = (<array_entry> + 1)
		repeat <array_Size>
		array_Size = (<array_Size> - <array_entry>)
		if NOT (<array_Size> = 0)
			begin
				Change CameraCuts_NextNoteCameraTime = ($<event_array> [<array_entry>] [0] - <time_offset>)
				TimeMarkerReached_SetParams time_offset = <time_offset> array = <event_array> array_entry = <array_entry> ArrayOfArrays
				begin
					if TimeMarkerReached
						GetSongTimeMs time_offset = <time_offset>
						break
					endif
					wait \{1 gameframe}
				repeat
				TimeMarkerReached_ClearParams
				note = ($<event_array> [<array_entry>] [1])
				if ($CameraCuts_AllowNoteScripts = true)
					if GetNoteMapping section = cameras note = <note>
						spawnscriptnow (<note_data>.Scr)params = {(<note_data>.params)length = ($<event_array> [<array_entry>] [2])}
					endif
				endif
				<array_entry> = (<array_entry> + 1)
			repeat <array_Size>
		endif
	endif
	Change \{CameraCuts_NextNoteCameraTime = -1}
endscript

script CameraCuts_GetNextNoteCameraTime
	return camera_time = ($CameraCuts_NextNoteCameraTime)
endscript

script CameraCuts_SetArray\{Type = good array = Default_Cameras_Good}
	if (<Type> = good)
		Change CameraCuts_Good_Array = <array>
	endif
	if (<Type> = medium)
		Change CameraCuts_Normal_Array = <array>
	endif
	if (<Type> = poor)
		Change CameraCuts_Poor_Array = <array>
	endif
endscript

script CameraCuts_SetParams
endscript

script CameraCuts_SetArrayPrefix
endscript

script set_defaultcameracut_perf
endscript

script set_defaultcameracuts
endscript

script create_cameracuts
endscript

script CameraCuts_GetNextDownbeat
	get_song_prefix song = ($current_song)
	FormatText checksumName = event_array '%s_lightshow_notes' s = <song_prefix> AddToStringLookup
	if NOT GlobalExists name = <event_array> Type = array
		return endtime = <endtime>
	endif
	GetArraySize $<event_array>
	array_count = ($CameraCuts_LastDownbeatIndex)
	array_Size = (<array_Size> - <array_count>)
	if (<array_Size> > 0)
		begin
			if ($<event_array> [<array_count>] [1] = 58)
				if ($<event_array> [<array_count>] [0] > <endtime>)
					Change CameraCuts_LastDownbeatIndex = <array_count>
					return endtime = ($<event_array> [<array_count>] [0])
				endif
			endif
			array_count = (<array_count> + 1)
		repeat <array_Size>
	endif
	return endtime = <endtime>
endscript

script CameraCuts_StartCallback
endscript

script CameraCuts_UpdateDebugCameraName
endscript

script CameraCuts_OutputGPULog
endscript

script destroy_cameracuts
	Change \{CameraCuts_Enabled = FALSE}
	killspawnedscript \{name = CameraCuts_StartCallback}
	KillCamAnim \{name = CameraCutCam}
	kill_dummy_bg_camera
	ClearNoteMappings \{section = cameras}
	killspawnedscript \{name = cameracuts_iterator}
endscript
profiling_cameracuts = FALSE

script profile_camera_cuts
endscript

script profile_cameracut
endscript

script profile_camera_gpu
endscript
gWinportCameraLocked = 1

script winportLockCamera
	Change \{gWinportCameraLocked = 1}
endscript

script winportUnlockCamera
	Change \{gWinportCameraLocked = 0}
endscript
