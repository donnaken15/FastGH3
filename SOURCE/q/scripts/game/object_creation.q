viewercam_composite_structure = [
]

script ProcessorGroup_RegisterDefault
	RegisterProcessorGroupDesc \{name = ProcessorGroup_CompositeSystem processors = [{name = Processor_Default task = {name = PTask_Default}}]}
	ProcessorMgr_Init \{group = ProcessorGroup_CompositeSystem}
endscript

script PassGroup_RegisterDefault
	RegisterPassGroupDesc \{name = PassGroup_CompositeSystem passes = [{name = Pass_Default processors = [Processor_Default]}{name = Pass_Agent processors = [Processor_Default]}{name = Pass_Behavior processors = [Processor_Default]}{name = Pass_Anim processors = [Processor_Default]}{name = Pass_Move processors = [Processor_Default]}{name = Pass_Model processors = [Processor_Default]}]}
	PassMgr_Init \{group = PassGroup_CompositeSystem}
endscript

script CompositeObjects_RegisterDefault
	PassDefault_components = [
		{name = Suspend}
		{name = BBox}
		{name = ObjectProximity}
		{name = Sound}
		{name = Stream}
	]
	RegisterCompositeObjectDesc {
		name = CompositeHuman
		callback = CompositeAgent_CustomizeComponents
		passes =
		[
			{pass = Pass_Default
				components = <PassDefault_components>
			}
			{pass = Pass_Agent
				components = [{name = PedLife}
					{name = AiInfo}
					{name = Agent}
					{name = FAM}
					{name = Locator}
					{name = ItemControl}
					{name = Vision}
					{name = CollisionCache
						params = {bbox_min = (-0.10000000149011612, -20.0, -0.10000000149011612)
							bbox_max = (0.10000000149011612, 10.0, 0.10000000149011612)
							layer = static_geometry_feeler}}
					{name = navigation}
					{name = motion}
					{name = ragdoll}
				]
			}
			{pass = Pass_Behavior
				components = [{name = EventCache}
					{name = BehaviorSystem}
					{name = inventory}
					{name = Seek}
					{name = Passenger}
					{name = Targetable}
					{name = Proximity}
					{name = Interact}
					{name = SkaterLoopingSound}
					{name = AnimTree}
					{name = LockObj
						params = {lock_to_object_matrix
							OFF}}
					{name = NavCollision}
					{name = AlignToGround
						params = {OFF}}
				]
			}
			{pass = Pass_Model
				components = [{name = Skeleton}
					{name = Model}
					{name = SpecialItem}
					{name = proximtrigger
						params = {trigger_checksum = Ped , cube_length = 0.4}}
				]
			}
		]
	}
	RegisterCompositeObjectDesc {
		name = CompositeVehicle
		callback = CompositeAgent_CustomizeComponents
		passes =
		[
			{pass = Pass_Default
				components = <PassDefault_components>
			}
			{pass = Pass_Agent
				components = [{name = PedLife}
					{name = AiInfo}
					{name = Agent}
					{name = FAM}
					{name = Locator}
					{name = ItemControl}
					{name = CollisionCache
						params = {bbox_min = (-0.10000000149011612, -20.0, -0.10000000149011612)
							bbox_max = (0.10000000149011612, 10.0, 0.10000000149011612)
							layer = static_geometry_feeler}}
					{name = navigation}
					{name = motion}
				]
			}
			{pass = Pass_Behavior
				components = [{name = EventCache}
					{name = BehaviorSystem}
					{name = Seek}
					{name = Interact}
					{name = VehiclePhysics}
					{name = AnimTree}
					{name = Input
						params = {controller = 1}}
				]
			}
			{pass = Pass_Model
				components = [{name = Skeleton}
					{name = Model}
					{name = proximtrigger
						params = {trigger_checksum = Vehicle , cube_length = 0.4}}
				]
			}]
	}
	RegisterCompositeObjectDesc \{name = CompositeGameObject_SimpleHover callback = nullscript passes = [{pass = Pass_Default components = [{name = Suspend}]}{pass = Pass_Move components = [{name = Hover}]}{pass = Pass_Model components = [{name = ObjectProximity}{name = Model}]}]}
	RegisterCompositeObjectDesc \{name = CompositeGameObject_StandardRigidBody callback = nullscript passes = [{pass = Pass_Default components = [{name = Suspend}]}{pass = Pass_Move components = [{name = rigidbody}]}{pass = Pass_Model components = [{name = Sound}{name = Model}]}]}
	AdObject_components = [{name = Model}
		{name = motion}
	]
	Massive_components = [{name = MassiveAd}]
	AdObject_components = (<AdObject_components> + <Massive_components>)
	RegisterCompositeObjectDesc {
		name = CompositeGameObject_AdObject
		callback = nullscript
		passes =
		[
			{pass = Pass_Default
				components = <AdObject_components>
			}
		]
	}
endscript

script CompositeAgent_CustomizeComponents
	if GotParam \{CompassBlipType}
		CreateComponentFromStructure component = CompassBlip <...>
	endif
	if GotParam \{voice_profile}
		if StructureContains \{structure = appearance voice_profile}
			voice_profile = (<appearance>.voice_profile)
		else
			voice_profile = (<Profile>.voice_profile)
		endif
		if StructureContains structure = $NoticeVoVoiceProfiles <voice_profile>
			has_notice_vo = ($NoticeVoVoiceProfiles.<voice_profile>)
		else
			has_notice_vo = FALSE
		endif
		SetTags {
			Profile = <Profile>
			voice_profile = <voice_profile>
			has_notice_vo = <has_notice_vo>
		}
	endif
endscript
