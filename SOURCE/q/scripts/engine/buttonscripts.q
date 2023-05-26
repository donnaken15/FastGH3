select_shift = 0
memcard_screenshots = 0
skater_cam_0_mode = 2
skater_cam_1_mode = 2
screenshotmode = 0
select_text = root_text

script set_select_text\{text = $#"0x83a9e10f"}
endscript

script refresh_analog_options
	hide_analog_options
	show_analog_options
endscript

script UserSelectSelect
endscript

script UserSelectSelect2
endscript
view_mode = 0
render_mode = 0
wireframe_mode = 0
drop_in_car = 0
drop_in_car_setup = MiniBajaCarSetup

script UserSelectTriangle
endscript
viewer_taking_screenshot = 0

script do_screenshot
	Change \{viewer_taking_screenshot = 1}
	hide_analog_options
	if toggle2d \{OFF}
		wait \{2 frames}
		hide_analog_options
		wait \{2 frames}
		ScreenShot
		wait \{2 frames}
		toggle2d \{On}
		Change \{viewer_taking_screenshot = 0}
	else
		wait \{2 frames}
		hide_analog_options
		wait \{2 frames}
		ScreenShot
		wait \{2 frames}
		Change \{viewer_taking_screenshot = 0}
	endif
endscript

script UserSelectSquare
	//SpawnScriptLater do_screenshot
endscript

script UserSelectCircle
endscript

script UserSelectStart
endscript

script show_analog_options
endscript

script hide_analog_options
	//if ScreenElementExists \{id = viewer_options_anchor}
	//	DestroyScreenElement \{id = viewer_options_anchor}
	//endif
endscript
toggleviewmode_enabled = FALSE

script ToggleViewMode
endscript
NEWSCREENSHOTMODE = 0

script UserSelectX
endscript

script UserSelectRightAnalogUp
	toggle2d
endscript

script UserSelectRightAnalogDown
	ToggleMetrics
endscript

script flip_crowd_debug_mode
	if ($crowd_debug_mode = 1)
		Change \{crowd_debug_mode = 0}
	else
		Change \{crowd_debug_mode = 1}
	endif
endscript
pak_mode = 0

script UserSelectRightAnalogLeft
	battlemode_fill
endscript
toggle_nav_view_mode = 0

script UserSelectRightAnalogRight
endscript

script UserSelectLeftAnalogUp
endscript

script UserSelectLeftAnalogDown
endscript

script UserSelectLeftAnalogLeft
endscript

script UserSelectLeftAnalogRight
endscript
viewer_rotation_angle = 0

script UserViewerX
endscript

script UserViewerSquare
endscript
Viewer_move_mode = 1
Obj_Viewer_move_mode = 0
Env_Viewer_move_mode = 2
viewer_speed = env
USER_VIEWER_TRIANGLE_TOD = 1

script UserViewerTriangle
endscript

script switch_to_env_speed
endscript

script switch_to_obj_speed
endscript

script set_viewer_speed
endscript

script UserViewerL1
endscript

script UserViewerL2
endscript

script show_wireframe_mode
endscript

script wireframe_message
endscript

script wireframe_style
endscript

script ViewerLeft
endscript

script ViewerRight
endscript

script ViewerUp
	printf \{"ViewerUp - Deprecated"}
endscript

script ViewerDown
	printf \{"ViewerDown - Deprecated"}
endscript

script viewer_print_debug_info
endscript
