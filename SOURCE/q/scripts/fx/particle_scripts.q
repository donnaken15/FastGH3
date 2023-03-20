Force_Particle_Update_Time = 1.0

script JOW_RGBAToVector\{rgba = [0 0 0 0]}
	return rgb = (<rgba> [0] * (1.0, 0.0, 0.0) + <rgba> [1] * (0.0, 1.0, 0.0) + <rgba> [2] * (0.0, 0.0, 1.0))a = (<rgba> [3])
endscript

script JOW_VectorToRGBA\{rgb = (0.0, 0.0, 0.0) a = 0}
	rgba = [0 0 0 0]
	val = (<rgb>.(1.0, 0.0, 0.0))
	casttointeger \{val}
	SetArrayElement ArrayName = rgba index = 0 NewValue = <val>
	val = (<rgb>.(0.0, 1.0, 0.0))
	casttointeger \{val}
	SetArrayElement ArrayName = rgba index = 1 NewValue = <val>
	val = (<rgb>.(0.0, 0.0, 1.0))
	casttointeger \{val}
	SetArrayElement ArrayName = rgba index = 2 NewValue = <val>
	casttointeger \{a}
	SetArrayElement ArrayName = rgba index = 3 NewValue = <a>
	return rgba = <rgba>
endscript

script GetParticleType\{params_Script}
	Type = FLEXIBLE
	if CheckFlexibleParticleStructure <params_Script>
		if GlobalExists name = <params_Script> Type = structure
			if StructureContains structure = (<params_Script>)ParticleType
				switch (<params_Script>.ParticleType)
					case FlexParticle
						Type = FLEXIBLE
					case SplineParticle
						Type = FAST
				endswitch
			else
				if StructureContains structure = (<params_Script>)Class
					if ((<params_Script>.Class)= ParticleObject)
						Type = FAST
					endif
				endif
			endif
		endif
	endif
	if CheckSplineParticleStructure <params_Script>
		if GlobalExists name = <params_Script> Type = structure
			if StructureContains structure = (<params_Script>)ParticleType
				switch (<params_Script>.ParticleType)
					case FlexParticle
						Type = FLEXIBLE
					case SplineParticle
						Type = FAST
				endswitch
			else
				if StructureContains structure = (<params_Script>)Class
					if ((<params_Script>.Class)= ParticleObject)
						Type = FAST
					endif
				endif
			endif
		endif
	endif
	return Type = <Type>
endscript
