Default_TOD_Manager = {
	screen_FX = [
		{
			scefName = BnS
			Type = Bright_Sat
			On = 1
			Contrast = 1
			Red_Mix = [
				1
				0
				0
			]
			Green_Mix = [
				0
				1
				0
			]
			Blue_Mix = [
				0
				0
				1
			]
			Brightness = 1
			Saturation = 1
			Hue = 1
		}
	]
}
DOF_Off_TOD_Manager = {
	screen_FX = [
		{
			scefName = DOF
			Type = DOF
			On = 1
			BackDist = 1
			FrontDist = 0
			strength = 0
			BlurRadius = 0
			BlurResolution = quarter
		}
	]
}
ScreenFlash_tod_manager = {
	atmosphere = {
		SmallParticlesRGB = [
			27
			51
			255
		]
		LargeParticlesRGB = [
			187
			153
			137
		]
		phase = 1.05
		strength = 0.45
		atmosphere = ph_dome
		SmallScale = 55
		LargeScale = 1
	}
	screen_FX = [
		{
			scefName = BS
			Type = Bright_Sat
			On = 1
			Contrast = 0.6
			Red_Mix = [
				1
				0
				0
			]
			Green_Mix = [
				0
				1
				0
			]
			Blue_Mix = [
				0
				0
				1
			]
			Brightness = 2.5
			Saturation = 1
			Hue = 1
		}
	]
}
ScreenToBlack_tod_manager = {
	atmosphere = {
		SmallParticlesRGB = [
			128
			128
			128
		]
		LargeParticlesRGB = [
			128
			128
			128
		]
		phase = 0
		strength = 0
		atmosphere = ph_dome
		SmallScale = 10
		LargeScale = 10
	}
	screen_FX = [
		{
			scefName = VG
			Type = Vignette
			On = 1
			inner_radius = 1.0
			Outer_Radius = 1.5
			alpha = 0
		}
	]
}
