
script RefreshCurrentZones
	SpawnScriptLater \{reload_zones}
endscript

script reload_zones
	pauseskaters
	StopMusic
	StopAudioStreams
	wait \{2 gameframes}
	SetSaveZoneNameToCurrent
	SetEnableMovies \{1}
	kill_blur
	SetPakManCurrentBlock \{map = zones pak = None}
	RefreshPakManSizes \{map = zones}
	ScriptCacheDeleteZeroUsage
	GetSaveZoneName
	SetPakManCurrentBlock map = zones pakname = <save_zone>
	if NOT ($view_mode = 1)
		unpauseskaters
	endif
endscript

