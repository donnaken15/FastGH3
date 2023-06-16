lightshow_enabled = 0
lightvolume_flarecutoff_low = 0.2
lightvolume_flarecutoff_high = 0.35
lightvolume_flarematerialcrc = FlareMaterial_FlareMaterial
lightvolume_flaresaturate = 0.6
lightshow_defaultblendtime = 0.15
lightshow_coloroverrideblend = 0.4
lightshow_offset_ms = 100

script LS_AllOff
	killspawnedscript \{id = LightShow}
endscript

LightShow_ColorOverrideExcludeLights = []
LightShow_StateNodeFlags = []
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
LightShow_NoteMapping = []
LightShow_SharedProcessors = []

lightshow_iterator = $WhyAmIBeingCalled
