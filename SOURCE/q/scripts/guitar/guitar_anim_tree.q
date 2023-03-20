
script Obj_GetPosition
endscript

script Obj_GetOrientation
endscript

script #"0x2ff0c88a"
	CreateCompositeObject {
		components = [{
				component = ragdoll
			}]
		params = <params>
	}
	return <...>
endscript

script create_band_member\{name = GUITARIST LightGroup = Band async = 0 animpak = 1}
	create_band_member_wait_for_lock
	printf "Create_Band_Member name=%a............." a = <name>
	FormatText checksumName = bandmember_body_pak '%s_%p_pak_file' s = ($character_pak_crc_to_text.<name>)p = ($character_pak_crc_to_text.Body)
	FormatText checksumName = bandmember_anim_pak '%s_%p_pak_file' s = ($character_pak_crc_to_text.<name>)p = ($character_pak_crc_to_text.anim)
	FormatText checksumName = bandmember_instrument_pak '%s_%p_pak_file' s = ($character_pak_crc_to_text.<name>)p = ($character_pak_crc_to_text.instrument)
	Pos = (0.0, 0.0, 0.0)
	Dir = (0.0, 0.0, 1.0)
	if GotParam \{start_node}
		if DoesWaypointExist name = <start_node>
			GetWaypointPos name = <start_node>
			GetWaypointDir name = <start_node>
		endif
	endif
	if CompositeObjectExists <name>
		if GotParam \{useoldpos}
			<name> ::Obj_GetPosition
			<name> ::Obj_GetOrientation
			Dir = ((1.0, 0.0, 0.0) * <X> + (0.0, 1.0, 0.0) * <y> + (0.0, 0.0, 1.0) * <z>)
		endif
		<name> ::Die
	endif
	unload_musician_pak_file desc_id = ($<bandmember_body_pak>)async = <async> Type = Body
	unload_musician_pak_file desc_id = ($<bandmember_anim_pak>)async = <async> Type = anim
	unload_musician_pak_file desc_id = ($<bandmember_instrument_pak>)async = <async> Type = instrument
	Change GlobalName = <bandmember_body_pak> NewValue = no_pak_id
	Change GlobalName = <bandmember_anim_pak> NewValue = no_pak_id
	Change GlobalName = <bandmember_instrument_pak> NewValue = no_pak_id
	if (<name> = GUITARIST || <name> = BASSIST)
		startslot = 0
	else
		startslot = 2
	endif
	body_asset_context = 0
	if (<name> = GUITARIST)
		if CompositeObjectExists \{name = BASSIST}
			BASSIST ::hero_pause_anim
		endif
	elseif (<name> = BASSIST)
		if CompositeObjectExists \{name = GUITARIST}
			GUITARIST ::hero_pause_anim
		endif
	endif
	if StructureContains structure = <Profile> musician_body
		if NOT load_musician_pak_file Profile = <Profile> async = <async> Type = Body
			create_band_member_unlock
			return \{FALSE}
		endif
		Change GlobalName = <bandmember_body_pak> NewValue = <filename_crc>
		body_asset_context = <AssetContext>
		if (<animpak> = 1)
			if NOT load_musician_pak_file Profile = <Profile> async = <async> Type = anim startslot = <startslot>
				create_band_member_unlock
				return \{FALSE}
			endif
			Change GlobalName = <bandmember_anim_pak> NewValue = <filename_crc>
		endif
	endif
	if StructureContains structure = <Profile> musician_instrument
		if NOT load_musician_pak_file Profile = <Profile> async = <async> Type = instrument
			create_band_member_unlock
			return \{FALSE}
		endif
		Change GlobalName = <bandmember_instrument_pak> NewValue = <filename_crc>
	endif
	if (<name> = GUITARIST)
		if CompositeObjectExists \{name = BASSIST}
			BASSIST ::hero_unpause_anim
		endif
	elseif (<name> = BASSIST)
		if CompositeObjectExists \{name = GUITARIST}
			GUITARIST ::hero_unpause_anim
		endif
	endif
	dump_pak_info
	GetPakManCurrent \{map = zones}
	switch <pak>
		case z_training
		case z_viewer
			LightGroup = None
		default
			if (<name> = GUITARIST)
				LightGroup = Alt_Band
			endif
	endswitch
	if ($soundcheck_in_store = 1)
		<LightGroup> = Guitar_Center_Band
	endif
	skeleton_name = (<Profile>.Skeleton)
	ragdoll_name = (<Profile>.ragdoll)
	collision_group = (<Profile>.ragdoll_collision_group)
	if StructureContains structure = <Profile> outfit
		if (<Profile>.outfit = 2)
			skeleton_name = (<Profile>.skeleton2)
			ragdoll_name = (<Profile>.ragdoll2)
			collision_group = (<Profile>.ragdoll_collision_group2)
		endif
	endif
	if StructureContains structure = <Profile> ik_params
		ik_params = (<Profile>.ik_params)
	else
		ik_params = Hero_Ik_params
	endif
	#"0x2ff0c88a" {
		components = [
			{
				component = ragdoll
				initialize_empty = FALSE
				disable_collision_callbacks
				skeletonname = <skeleton_name>
				ragdollName = <ragdoll_name>
				RagdollCollisionGroup = $<collision_group>
			}
			{
				component = SetDisplayMatrix
			}
			{
				component = AnimTree
				animEventTableName = ped_animevents
			}
			{
				component = Skeleton
				skeletonname = <skeleton_name>
			}
			{
				component = Model
				LightGroup = <LightGroup>
			}
			{
				component = motion
			}
		]
		params = {
			name = <name>
			Pos = <Pos>
			AssetContext = <body_asset_context>
			<Profile>
			object_type = bandmember
			profilebudget = 800
		}
	}
	<name> ::EmptyScript Dir = <Dir>
	<name> ::EmptyScript struct = <Profile> buildscript = create_ped_model_from_appearance params = {LightGroup = <LightGroup>}
	switch (<name>)
		case vocalist
			desired_tree = vocalist_static_tree
		case drummer
			desired_tree = drummer_static_tree
		default
			desired_tree = guitarist_static_tree
	endswitch
	<name> ::EmptyScript {
		Tree = $<desired_tree>
		animEventTableName = ped_animevents
		NodeIdDeclaration = [
			Base
			Body
			BodyTimer
			StrumTimer
			FretTimer
			FingerTimer
			FacialTimer
			Ik
			Standard_Branch
			Turn_Branch
			LeftArmPartial
			LeftHandPartial
			RightArmPartial
			DrummerLeftArm
			DrummerRightArm
			leftarm_timer
			rightarm_timer
			LeftArm
			LeftHand
			RightArm
			Face
			cymbal1
			cymbal2
			cymbal3
			cymbal4
			#"0x97442ca8"
			CymbalTimer2
			CymbalTimer3
			CymbalTimer4
			leftfoot
			leftfoot_timer
			rightfoot
			rightfoot_timer
			BodyTwist
			bodytwist_timer
			bodytwist_branch
			arm_branch
			left_arm_branch
			right_arm_branch
		]
		params = {
			ik_params = <ik_params>
		}
	}
	create_band_member_unlock
	return \{true}
endscript

script preload_band_member\{name = GUITARIST async = 0}
	create_band_member_wait_for_lock
	filename_crc = None
	instrument_crc = None
	create_guitarist_profile <...>
	if (<found> = 1)
		if StructureContains structure = <Profile> musician_instrument
			if NOT load_musician_pak_file Profile = <Profile> async = <async> Type = instrument
				create_band_member_unlock
				return \{FALSE}
			endif
			instrument_crc = <filename_crc>
		endif
		if StructureContains structure = <Profile> musician_body
			if NOT load_musician_pak_file Profile = <Profile> async = <async> Type = Body
				create_band_member_unlock
				return \{FALSE}
			endif
		endif
	endif
	create_band_member_unlock
	return filename_crc = <filename_crc> instrument_crc = <instrument_crc> true
endscript

script preload_band_member_finish\{name = GUITARIST async = 0}
	create_band_member_wait_for_lock
	if NOT (<instrument_crc> = None)
		unload_musician_pak_file desc_id = <instrument_crc> async = <async> Type = instrument
	endif
	if NOT (<filename_crc> = None)
		unload_musician_pak_file desc_id = <filename_crc> async = <async> Type = Body
	endif
	create_band_member_unlock
endscript
create_band_member_lock_queue = 0
create_band_member_lock = 0

script create_band_member_unlock
	Change \{create_band_member_lock = 0}
endscript

script create_band_member_wait_for_lock
	begin
		if ($create_band_member_lock_queue = 0)
			break
		endif
		wait \{1 gameframe}
	repeat
	Change \{create_band_member_lock_queue = 1}
	begin
		if ($create_band_member_lock = 0)
			break
		endif
		wait \{1 gameframe}
	repeat
	Change \{create_band_member_lock_queue = 0}
	Change \{create_band_member_lock = 1}
endscript

script destroy_band
	destroy_band_member \{name = GUITARIST}
	destroy_band_member \{name = BASSIST}
	destroy_band_member \{name = drummer}
	destroy_band_member \{name = vocalist}
	if GotParam \{unload_paks}
		force_unload_all_character_paks
	endif
endscript

script destroy_band_member
	if CompositeObjectExists name = <name>
		<name> ::Die
		FormatText checksumName = bandmember_body_pak '%s_%p_pak_file' s = ($character_pak_crc_to_text.<name>)p = ($character_pak_crc_to_text.Body)
		FormatText checksumName = bandmember_anim_pak '%s_%p_pak_file' s = ($character_pak_crc_to_text.<name>)p = ($character_pak_crc_to_text.anim)
		FormatText checksumName = bandmember_instrument_pak '%s_%p_pak_file' s = ($character_pak_crc_to_text.<name>)p = ($character_pak_crc_to_text.instrument)
		unload_musician_pak_file desc_id = ($<bandmember_body_pak>)async = <async> Type = Body
		unload_musician_pak_file desc_id = ($<bandmember_anim_pak>)async = <async> Type = anim
		unload_musician_pak_file desc_id = ($<bandmember_instrument_pak>)async = <async> Type = instrument
		Change GlobalName = <bandmember_body_pak> NewValue = no_pak_id
		Change GlobalName = <bandmember_anim_pak> NewValue = no_pak_id
		Change GlobalName = <bandmember_instrument_pak> NewValue = no_pak_id
	endif
endscript

script kill_character_scripts
	printf \{"kill character scripts......."}
	if CompositeObjectExists \{name = GUITARIST}
		GUITARIST ::Obj_SwitchScript \{EmptyScript}
	endif
	if CompositeObjectExists \{name = BASSIST}
		BASSIST ::Obj_SwitchScript \{EmptyScript}
	endif
	if CompositeObjectExists \{name = vocalist}
		vocalist ::Obj_SwitchScript \{EmptyScript}
	endif
	if CompositeObjectExists \{name = drummer}
		drummer ::Obj_SwitchScript \{EmptyScript}
	endif
endscript

script EmptyScript
endscript
hero_pause_anim = $WhyAmIBeingCalled
hero_unpause_anim = $WhyAmIBeingCalled
hero_play_turn_anim = $WhyAmIBeingCalled
hero_play_blended_anim = $WhyAmIBeingCalled
hero_play_strum_anim = $WhyAmIBeingCalled
hero_play_fret_anim = $WhyAmIBeingCalled
hero_play_finger_anim = $WhyAmIBeingCalled
hero_play_drum_anim = $WhyAmIBeingCalled
hero_cymbal_anim = $WhyAmIBeingCalled
hero_play_facial_anim = $WhyAmIBeingCalled
hero_wait_until_anim_finished = $WhyAmIBeingCalled
hero_anim_complete = $WhyAmIBeingCalled
hero_wait_until_anim_near_end = $WhyAmIBeingCalled
hero_anim_near_end = $WhyAmIBeingCalled
hero_disable_arms = $WhyAmIBeingCalled
hero_enable_arms = $WhyAmIBeingCalled
hero_toggle_arms = $WhyAmIBeingCalled
drummer_twist = $WhyAmIBeingCalled
hero_ConstraintBones = [
]
