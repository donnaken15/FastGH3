Thread0SkaterBudget = 30
Thread0RenderBudget = 30
Thread0AIBudget = 30
Thread0AIAgentBudget = 3
Thread0AINavigationBudget = 4
Thread0AIBehaviorSystemBudget = 4
Thread0AISeekBudget = 3
Thread0AIAnimTreeBudget = 10
Thread0AINavCollisionBudget = 1
Thread0BudgetAlwaysOn = 0
profiler_vblanks = -1
poly_count_on = 0

script show_poly_count
	if ($poly_count_on = 0)
		Change \{poly_count_on = 1}
		GetCurrentLevel
		refresh_map_data
	else
		Change \{poly_count_on = 0}
		if ScreenElementExists \{id = map_data_anchor}
			DestroyScreenElement \{id = map_data_anchor}
		endif
		if ScreenElementExists \{id = texture_list}
			DestroyScreenElement \{id = texture_list}
		endif
	endif
endscript

script show_render_metrics_toggle
	ToggleRenderMetrics
	if ScreenElementExists \{id = render_metric_anchor}
		DestroyScreenElement \{id = render_metric_anchor}
		DoScreenElementMorph \{id = the_score_sprite Scale = 1}
		DoScreenElementMorph \{id = the_score Scale = 1}
		show_compass_anchor
	else
		DoScreenElementMorph \{id = the_score_sprite Scale = 0}
		DoScreenElementMorph \{id = the_score Scale = 0}
	endif
endscript
force_nodelistman_metrics = 0
nodelistman_metrics_mode = 0
hi_def_globalscale = 0.6
hi_def_globalscale_gap = 0.4
low_def_globalscale = 0.8
low_def_globalscale_gap = 0.7
globalscale = 0.8
globalscale_gap = 0.7

script NodelistManMonitor_ConsoleOnly
	Change \{force_nodelistman_metrics = 1}
	Change \{nodelistman_metrics_mode = 2}
endscript

script NodelistManMonitor
	Change \{force_nodelistman_metrics = 1}
	Change \{nodelistman_metrics_mode = 0}
endscript
