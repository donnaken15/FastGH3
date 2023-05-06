
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

/*script DisplayAnimCacheState
	priority_ranges = [
		{Range = (0.0, 10.0) bar = CachedRange0}
		{Range = (11.0, 50.0) bar = CachedRange1}
		{Range = (51.0, 100.0) bar = CachedRange2}
		{Range = (101.0, 500.0) bar = CachedRange3}
		{Range = (501.0, 1000.0) bar = CachedRange4}
		{Range = (1001.0, 10000.0) bar = CachedRange5}
		{Range = (10001.0, -1.0) bar = CachedRange6}
	]
	GetArraySize \{priority_ranges}
	if ObjectExists \{id = AnimCacheAnchor}
		killspawnedscript \{name = UpdateAnimCacheState}
		DestroyScreenElement \{id = AnimCacheAnchor}
		return
	endif
	if NOT ObjectExists \{id = AnimCacheAnchor}
		SetScreenElementLock \{id = root_window OFF}
		<root_pos> = (<display_offset> + (25.0, 40.0))
		CreateScreenElement {
			Type = ContainerElement
			parent = root_window
			id = AnimCacheAnchor
			Pos = <root_pos>
			just = [center center]
			internal_just = [left center]
		}
		CreateScreenElement \{Type = TextElement parent = AnimCacheAnchor id = PriCachedText Pos = (0.0, -30.0) text = "Animation Cache Priority Distribution:" font = dialog rgba = [120 120 120 255] just = [left top]}
		CreateScreenElement \{Type = TextElement parent = AnimCacheAnchor id = PriCachedLine Pos = (0.0, -21.0) text = "-----------------------------------------" font = dialog rgba = [120 120 120 255] just = [left top]}
		<i> = 0
		begin
			<bar_id> = ((<priority_ranges> [<i>]).bar)
			<bar_pos> = ((0.0, 0.0) + (<i> * (0.0, 30.0)))
			<bar_rgba> = [255 0 0 50]
			SetArrayElement ArrayName = bar_rgba index = 0 NewValue = (255 - (<i> * 30))
			SetArrayElement ArrayName = bar_rgba index = 1 NewValue = ((<i> * 30))
			CreateScreenElement {
				Type = SpriteElement
				parent = AnimCacheAnchor
				id = <bar_id>
				Pos = <bar_pos>
				Scale = (50.0, 5.0)
				texture = white
				font = dialog
				rgba = <bar_rgba>
				just = [left top]
			}
			<i> = (<i> + 1)
		repeat <array_Size>
		<txt_pos> = ((0.0, 0.0) + (<i> * (0.0, 30.0)))
		CreateScreenElement {
			Type = TextElement
			parent = AnimCacheAnchor
			id = NumCachedText
			Pos = <txt_pos>
			text = "-- Total Cached Anims:"
			font = dialog
			rgba = [120 0 120 255]
			just = [left top]
		}
		<i> = (<i> + 1)
		<txt_pos> = ((0.0, 0.0) + (<i> * (0.0, 30.0)))
		CreateScreenElement {
			Type = TextElement
			parent = AnimCacheAnchor
			id = HitsCachedText
			Pos = <txt_pos>
			text = "-- Cache Hits:"
			font = dialog
			rgba = [20 255 20 255]
			just = [left top]
		}
		<i> = (<i> + 1)
		<txt_pos> = ((0.0, 0.0) + (<i> * (0.0, 30.0)))
		CreateScreenElement {
			Type = TextElement
			parent = AnimCacheAnchor
			id = MissesCachedText
			Pos = <txt_pos>
			text = "-- Cache Misses:"
			font = dialog
			rgba = [255 20 20 255]
			just = [left top]
		}
		SetScreenElementLock \{id = root_window On}
	endif
	SpawnScriptLater UpdateAnimCacheState params = {priority_ranges = <priority_ranges>}
endscript

script UpdateAnimCacheState
	begin
		if ObjectExists \{id = AnimCacheAnchor}
			GetArraySize <priority_ranges>
			<i> = 0
			begin
				GetAnimCacheState priority_range = ((<priority_ranges> [<i>]).Range)
				<d> = (((<priority_ranges> [<i>]).Range).(1.0, 0.0))
				<e> = (((<priority_ranges> [<i>]).Range).(0.0, 1.0))
				<bar_id> = ((<priority_ranges> [<i>]).bar)
				<new_scale> = ((1.0, 5.0) + (<priority_count> * (10.0, 0.0)))
				<bar_id> ::DoMorph Scale = <new_scale> time = 0.2
				<i> = (<i> + 1)
			repeat <array_Size>
			FormatText textname = num_cached_text "-- Total cached anims: %g" g = <num_cached>
			FormatText textname = hits_cached_text "-- Cache Hits: %g" g = <cache_hits>
			FormatText textname = misses_cached_text "-- Cache Misses: %g" g = <cache_misses>
			SetScreenElementProps id = NumCachedText text = <num_cached_text>
			SetScreenElementProps id = HitsCachedText text = <hits_cached_text>
			SetScreenElementProps id = MissesCachedText text = <misses_cached_text>
		endif
		wait \{1 Frame}
	repeat
endscript

script launch_toggle_animcache_state\{display_offset = (0.0, 0.0)}
	DisplayAnimCacheState <...>
endscript

script DisplayFeelerStats
	if ObjectExists \{id = FeelerStatsAnchor}
		killspawnedscript \{name = UpdateFeelerStats}
		DestroyScreenElement \{id = FeelerStatsAnchor}
		return
	endif
	if NOT ObjectExists \{id = FeelerStatsAnchor}
		SetScreenElementLock \{id = root_window OFF}
		<root_pos> = (<display_offset> + (25.0, 40.0))
		CreateScreenElement {
			Type = ContainerElement
			parent = root_window
			id = FeelerStatsAnchor
			Pos = <root_pos>
			just = [center center]
			internal_just = [left center]
		}
		CreateScreenElement \{Type = TextElement parent = FeelerStatsAnchor id = PriCachedText Pos = (0.0, -30.0) text = "Feeler Stats:" font = dialog rgba = [120 120 120 255] just = [left top]}
		CreateScreenElement \{Type = TextElement parent = FeelerStatsAnchor id = PriCachedLine Pos = (0.0, -21.0) text = "-----------------------------------------" font = dialog rgba = [120 120 120 255] just = [left top]}
		<i> = 1
		<txt_pos> = ((0.0, 0.0) + (<i> * (0.0, 30.0)))
		CreateScreenElement {
			Type = TextElement
			parent = FeelerStatsAnchor
			id = NumFeelersText
			Pos = <txt_pos>
			text = "-- Total Feelers Cast:"
			font = dialog
			rgba = [120 0 120 255]
			just = [left top]
		}
		<i> = (<i> + 1)
		<txt_pos> = ((0.0, 0.0) + (<i> * (0.0, 30.0)))
		CreateScreenElement {
			Type = TextElement
			parent = FeelerStatsAnchor
			id = NumFeelersTimeText
			Pos = <txt_pos>
			text = "---- Time:"
			font = dialog
			rgba = [120 0 120 255]
			just = [left top]
		}
		<i> = (<i> + 1)
		<txt_pos> = ((0.0, 0.0) + (<i> * (0.0, 30.0)))
		CreateScreenElement {
			Type = TextElement
			parent = FeelerStatsAnchor
			id = HitsCachedText
			Pos = <txt_pos>
			text = "-- Cached Feelers:"
			font = dialog
			rgba = [20 255 20 255]
			just = [left top]
		}
		<i> = (<i> + 1)
		<txt_pos> = ((0.0, 0.0) + (<i> * (0.0, 30.0)))
		CreateScreenElement {
			Type = TextElement
			parent = FeelerStatsAnchor
			id = HitsCachedTimeText
			Pos = <txt_pos>
			text = "---- Time:"
			font = dialog
			rgba = [20 255 20 255]
			just = [left top]
		}
		<i> = (<i> + 1)
		<txt_pos> = ((0.0, 0.0) + (<i> * (0.0, 30.0)))
		CreateScreenElement {
			Type = TextElement
			parent = FeelerStatsAnchor
			id = UnCachedText
			Pos = <txt_pos>
			text = "-- Uncached Feelers:"
			font = dialog
			rgba = [255 20 20 255]
			just = [left top]
		}
		<i> = (<i> + 1)
		<txt_pos> = ((0.0, 0.0) + (<i> * (0.0, 30.0)))
		CreateScreenElement {
			Type = TextElement
			parent = FeelerStatsAnchor
			id = UnCachedTimeText
			Pos = <txt_pos>
			text = "---- Time:"
			font = dialog
			rgba = [255 20 20 255]
			just = [left top]
		}
		SetScreenElementLock \{id = root_window On}
	endif
	SpawnScriptLater \{UpdateFeelerStats}
endscript

script UpdateFeelerStats
	<max_cast_feelers> = 0
	<min_cast_feelers> = 1000
	<max_cached_feelers> = 0
	<min_cached_feelers> = 1000
	<max_uncached_feelers> = 0
	<min_uncached_feelers> = 1000
	<max_cast_time> = 0.0
	<min_cast_time> = 1000.0
	<max_cached_time> = 0.0
	<min_cached_time> = 1000.0
	<max_uncached_time> = 0.0
	<min_uncached_time> = 1000.0
	begin
		if ObjectExists \{id = FeelerStatsAnchor}
			GetCurrentFeelerStats
			<cur_total_feelers> = (<num_cached_checks> + <num_uncached_checks>)
			<cur_total_time> = (<cached_time> + <uncached_time>)
			if (<cur_total_feelers> < <min_cast_feelers>)
				<min_cast_feelers> = <cur_total_feelers>
			endif
			if (<cur_total_feelers> > <max_cast_feelers>)
				<max_cast_feelers> = <cur_total_feelers>
			endif
			if (<num_cached_checks> < <min_cached_feelers>)
				<min_cached_feelers> = <num_cached_checks>
			endif
			if (<num_cached_checks> > <max_cached_feelers>)
				<max_cached_feelers> = <num_cached_checks>
			endif
			if (<num_uncached_checks> < <min_uncached_feelers>)
				<min_uncached_feelers> = <num_uncached_checks>
			endif
			if (<num_uncached_checks> > <max_uncached_feelers>)
				<max_uncached_feelers> = <num_uncached_checks>
			endif
			if (<cur_total_time> < <min_cast_time>)
				<min_cast_time> = <cur_total_time>
			endif
			if (<cur_total_time> > <max_cast_time>)
				<max_cast_time> = <cur_total_time>
			endif
			if (<cached_time> < <min_cached_time>)
				<min_cached_time> = <cached_time>
			endif
			if (<cached_time> > <max_cached_time>)
				<max_cached_time> = <cached_time>
			endif
			if (<uncached_time> < <min_uncached_time>)
				<min_uncached_time> = <uncached_time>
			endif
			if (<uncached_time> > <max_uncached_time>)
				<max_uncached_time> = <uncached_time>
			endif
			FormatText textname = num_cached_text "-- Total Cast Feelers: %g (%n %m)" g = <cur_total_feelers> n = <min_cast_feelers> m = <max_cast_feelers>
			FormatText textname = num_cached_time_text "---- Time: %g (%n %m)" g = <cur_total_time> n = <min_cast_time> m = <max_cast_time>
			FormatText textname = hits_cached_text "-- Cached Feelers: %g (%n %m)" g = <num_cached_checks> n = <min_cached_feelers> m = <max_cached_feelers>
			FormatText textname = hits_cached_time_text "---- Time: %g (%n %m)" g = <cached_time> n = <min_cached_time> m = <max_cached_time>
			FormatText textname = misses_cached_text "-- Uncached Feelers: %g (%n %m)" g = <num_uncached_checks> n = <min_uncached_feelers> m = <max_uncached_feelers>
			FormatText textname = misses_cached_time_text "---- Time: %g (%n %m)" g = <uncached_time> n = <min_uncached_time> m = <max_uncached_time>
			SetScreenElementProps id = NumFeelersText text = <num_cached_text>
			SetScreenElementProps id = HitsCachedText text = <hits_cached_text>
			SetScreenElementProps id = UnCachedText text = <misses_cached_text>
			SetScreenElementProps id = NumFeelersTimeText text = <num_cached_time_text>
			SetScreenElementProps id = HitsCachedTimeText text = <hits_cached_time_text>
			SetScreenElementProps id = UnCachedTimeText text = <misses_cached_time_text>
		endif
		wait \{1 Frame}
	repeat
endscript

script launch_toggle_feeler_stats\{display_offset = (0.0, 0.0)}
	DisplayFeelerStats <...>
endscript*?
