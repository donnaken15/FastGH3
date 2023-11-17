
script flashsounds
	EnableRemoveSoundEntry \{enable}
	stars
	printf \{'Flashing global_sfx pak'}
	UnLoadPak \{'zones/global/global_sfx.pak' Heap = heap_audio localized}
	WaitUnloadPak \{'zones/global/global_sfx.pak'}
	LoadPak \{'zones/global/global_sfx.pak' no_vram Heap = heap_audio localized}
	stars
	printf \{'Sfx Pak flashing done.'}
endscript
SfxPreviewEventTree_FAM = {
	Type = FAM
	[
		{
			Type = Source
			anim = sk9_skater_Default
		}
	]
}

script SfxCreateTestFAMObject
	if CompositeObjectExists \{SfxPreviewEventObject}
		SfxPreviewEventObject ::Die
	endif
	skater ::Obj_GetPosition
	skater ::Obj_GetQuat
	CreateCompositeObject Priority = COIM_Priority_Permanent Heap = Generic {
		components = [{component = SetDisplayMatrix}{component = AnimTree}
			{component = Skeleton}{component = Model}
			{component = Agent}{component = FAM}{component = Stream}]
		params = {name = SfxPreviewEventObject Pos = <Pos> orientation = <Quat> cloneFrom = skater
			skeletonname = sk9_skater species = human voice_profile = TeenMaleSkater1 sex = male
			notice_radius = 6.0 agent_stats = stats_player faction = $faction_test}
	}
	SfxPreviewEventObject ::Anim_InitTree \{Tree = SfxPreviewEventTree_FAM NodeIdDeclaration = [FAM]}
endscript

script SfxCreateTestObject
	if CompositeObjectExists \{SfxPreviewEventObject}
		SfxPreviewEventObject ::Die
	endif
	GetCurrentCameraObject
	<camid> ::Obj_GetPosition
	<camid> ::Obj_GetQuat
	Pos = (<Pos> + (10 * <Quat>))
	CreateCompositeObject Priority = COIM_Priority_Permanent Heap = Generic {
		components = [{component = Sound}]
		params = {name = SfxPreviewEventObject Pos = <Pos> orientation = <Quat>}
	}
endscript

script SfxDestroyTestObject
	if CompositeObjectExists \{SfxPreviewEventObject}
		SfxPreviewEventObject ::Die
	endif
endscript

script PreviewSoundEvent
	ExtendCrc <event> '_container' out = container_name
	if StructureContains structure = $<container_name> Command
		printf 'Previewing SoundEvent %s' s = <event>
		if checksumequals a = ($<container_name>.Command)b = PlaySound
			printf \{'Playsound!'}
			SoundEvent event = <event>
		elseif checksumequals a = ($<container_name>.Command)b = Obj_PlaySound
			printf \{'Obj_Playsound!'}
			SfxCreateTestObject
			SoundEvent event = <event> object = SfxPreviewEventObject
		elseif checksumequals a = ($<container_name>.Command)b = Agent_PlayVO
			printf \{'Agent_PlayVO!'}
			<stream_priority> = 1
			<logic_priority> = 50
			<animate_mouth> = true
			<buss_id> =
			<no_pitch_mod> = FALSE
			<use_pos_info> = true
			<can_use_stream> = true
			<dropoff> = 50
			<dropoff_function> = standard
			SfxCreateTestFAMObject
			SoundEvent event = <event> object = SfxPreviewEventObject <...>
		else
			printf \{'Sound Event Command is invalid'}
		endif
		waitTime = 0
		begin
			if NOT (IsSoundEventPlaying <event>)
				break
			endif
			if (<waitTime> > 200)
				StopSoundEvent <event>
				break
			endif
			wait \{0.1 seconds}
			waitTime = (<waitTime> + 1)
		repeat
		SfxDestroyTestObject
	else
		printf 'sound event does not exist: %s' s = <container_name>
	endif
endscript
