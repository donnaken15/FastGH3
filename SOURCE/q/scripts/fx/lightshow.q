lightshow_enabled = 0
lightvolume_flarecutoff_low = 0.2
lightvolume_flarecutoff_high = 0.35
lightvolume_flarematerialcrc = FlareMaterial_FlareMaterial
lightvolume_flaresaturate = 0.6
lightshow_defaultblendtime = 0.15
lightshow_coloroverrideblend = 0.4
lightshow_offset_ms = 100

script LightShow_CreatePermModels
endscript

script LS_AllOff
	killspawnedscript \{id = LightShow}
endscript

script LS_SetupVenueLights
endscript

script LS_ResetVenueLights
	LS_AllOff
	LS_KillFX
	GetPakManCurrent \{map = zones}
endscript

script LS_KillFX
endscript
LightShow_ColorOverrideExcludeLights = [
	#"0x00000000"
]
LightShow_StateNodeFlags = [
	#"0x00000000"
]
LightShow_StateNodeFlagMapping = {
	performance = {
		poor = [
		]
		medium = [
		]
		good = [
		]
	}
	mood = {
		blackout = [
		]
	}
}
LightShow_NoteMapping = [
	{
		MidiNote = 39
		Scr = EmptyScript
		params = {
			Default
		}
	}
]
LightShow_SharedProcessors = [
]

script lightshow_iterator
endscript

script LightShow_Shutdown
endscript

script Kill_LightShow_FX
endscript

script LightShow_WaitAndEnableSpotlights
endscript
