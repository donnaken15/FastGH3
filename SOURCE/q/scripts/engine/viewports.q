
script viewport_debug_follow_cam_gen_ids
	if NOT GotParam \{camera_id}
		MangleChecksums a = <object_id> b = debug_follow_camera
		<camera_id> = <mangled_ID>
	endif
	if NOT GotParam \{viewport_id}
		MangleChecksums a = <object_id> b = debug_follow_viewport
		<viewport_id> = <mangled_ID>
	endif
	return <...>
endscript

script viewport_debug_follow_cam_create\{object_id = skater}
	viewport_debug_follow_cam_gen_ids <...>
	<camera_object_params> = {
		components = [
			{component = CinematicCamera Enabled = true}
			{component = Camera}
		]
		params = {
			name = <camera_id>
		}
	}
	if IsCompositeObjectManagerEnabled
		CreateCompositeObject <camera_object_params>
	else
		CreateCompositeObjectInstance <camera_object_params> Priority = COIM_Priority_Permanent Heap = Generic OldHeap = COM
	endif
	<camera_id> ::CCam_DoMorph {
		LockTo = <object_id>
		Pos = (0.00865700002759695, 2.08274507522583, -2.1572048664093018)
		Quat = (0.09862200170755386, -0.0007249999325722456, -0.012636999599635601)
		FOV = 72.0
	}
	<camera_id> ::CCam_SetSmoothing Type = all fast_lerp_factor = 0.89
	CreateDebugViewport id = <viewport_id>
	SetActiveCamera id = <camera_id> viewport = <viewport_id>
endscript

script viewport_debug_follow_cam_destroy\{object_id = skater}
	viewport_debug_follow_cam_gen_ids <...>
	DestroyDebugViewport id = <viewport_id>
	<camera_id> ::Die
endscript
