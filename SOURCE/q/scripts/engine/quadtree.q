useoldsort = 0
quadtreedebug = 1
frustumdebugtype = 3
render2d = 1
renderscreenfx = 1
quadtreedensity_alpha_inc = 1
onlyrender_meshid = -1
max_occluders = 2
vsync_interval_perc = 8
tempcamerafarplane = 400
quaddbg_2 = 0

script toggle_one_zone_only
	if ($renderZoneMode = 1)
		Change \{renderZoneMode = 2}
	else
		Change \{renderZoneMode = 1}
	endif
endscript

script toggle_draworder_view
	if ($draworderview = 0)
		Change \{draworderview = 1}
		setshaderoverride \{shader = '_OverrideConstantColor' Type = 1 uvremap = 0 samplerremap = 0}
	else
		Change \{draworderview = 0}
		setshaderoverride \{shader = 'disable' Type = 0 uvremap = 0 samplerremap = 0}
	endif
endscript

script inc_density
	quadtreedensity_alpha_inc = quadtreedensity_alpha_inc + 1
endscript

script dec_density
	if ($quadtreedensity_alpha_inc > 0)
		quadtreedensity_alpha_inc = quadtreedensity_alpha_inc - 1
	endif
endscript

script toggle_density
	if ($renderquadtreedensity = 0)
		Change \{renderquadtreedensity = 1}
		Change \{renderscreenfx = 0}
		Change \{rendergeoms = 0}
		Change \{renderinstances = 0}
	else
		Change \{renderquadtreedensity = 0}
		Change \{renderscreenfx = 1}
		Change \{rendergeoms = 1}
		Change \{renderinstances = 1}
	endif
endscript

script toggle_sky_sector
	if ($norender_overridechecksum = 0)
		Change \{norender_overridechecksum = -899986957}
	else
		Change \{norender_overridechecksum = 0}
	endif
endscript

script show_instances_only_toggle
	if ($showinstancesonly = 0)
		Change \{rendergeoms = 0}
		Change \{renderinstances = 1}
		Change \{quadtreedebug = 1}
		Change \{lockfrustums = 1}
		Change \{showinstancesonly = 1}
	else
		Change \{rendergeoms = 1}
		Change \{renderinstances = 1}
		Change \{quadtreedebug = 0}
		Change \{lockfrustums = 0}
		Change \{showinstancesonly = 0}
	endif
endscript

script lock_frustums_toggle
	if ($lockfrustums = 0)
		Change \{lockfrustums = 1}
		Change \{quadtreedebug = 1}
	else
		Change \{lockfrustums = 0}
		Change \{quadtreedebug = 0}
	endif
endscript

script quadtree_debug_toggle
	if NOT ($quadtreedebug = 1)
		Change \{quadtreedebug = 1}
	else
		Change \{quadtreedebug = 0}
	endif
endscript
