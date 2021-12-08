script() {

enable_pause();

/*new_menu({
	QbKey scrollid = fastgh3_pause_smenu;
	QbKey vmenuid = fastgh3_pause_menu;
	Vector2 menu_pos = (120.0, 224.0);
	QbKey _ = text_left;
});*/

createscreenelement({
	type: vscrollingmenu,
	parent: root_window,
	id: fastgh3_pause_smenu,
	just: [left, top],
	dims: (600.0, 700.0),
    pos: (120.0, 224.0)
});

createscreenelement({
	type: vmenu,
	parent: fastgh3_pause_smenu,
	id: fastgh3_pause_menu,
	pos: (0.0, 0.0),
	just: [left, top],
	event_handlers: [
		{ pad_up, generic_menu_up_or_down_sound,
			params: { up }
		},
		{ pad_down, generic_menu_up_or_down_sound,
			params: { down }
		},
		{ pad_back, ui_flow_manager_respond_to_action,
			params: { action: go_back }
		}
	]
});

createscreenelement({
	type: textelement,
	parent: root_window,
	id: pausehead,
	font: fontgrid_title_gh3,
	scale: 1.5,
	rgba: [210,210,210,250],
	text: "PAUSED",
	just: [center, center],
	z_priority: 100,
    pos: (640.0, 192.0),
	shadow_offs: (6.0, 6.0),
	shadow_rgba: [0,0,0,255]
});

// why is this breaking and not destroying
//add_user_control_helper("SELECT", button = green, z = 100);

createscreenelement({
	type: textelement,
	parent: fastgh3_pause_menu,
	id: resume,
	font: fontgrid_title_gh3,
	scale: 0.8,
	rgba: [210,210,210,250],
	text: "RESUME",
	just: [center, center],
	z_priority: 100,
	shadow_offs: (3.0, 3.0),
	shadow_rgba: [0,0,0,255],
	event_handlers: [
		{ focus, menu_focus },
		{ unfocus, menu_unfocus },
		{ pad_choose, ui_flow_manager_respond_to_action,
			params: {
				action: select_resume
			}
		}
	]
});

createscreenelement({
	type: textelement,
	parent: fastgh3_pause_menu,
	id: restart,
	font: fontgrid_title_gh3,
	scale: 0.8,
	rgba: [210,210,210,250],
	text: "RESTART",
	just: [center, center],
	z_priority: 100,
	shadow_offs: (3.0, 3.0),
	shadow_rgba: [0,0,0,255],
	event_handlers: [
		{ focus, menu_focus },
		{ unfocus, menu_unfocus },
		{ pad_choose, ui_flow_manager_respond_to_action,
			params: {
                action: select_restart
			}
		}
	]
});

createscreenelement({
	type: textelement,
	parent: fastgh3_pause_menu,
	id: difficulty,
	font: fontgrid_title_gh3,
	scale: 0.8,
	rgba: [210,210,210,250],
	text: "DIFFICULTY",
	just: [center, center],
	z_priority: 100,
	shadow_offs: (3.0, 3.0),
	shadow_rgba: [0,0,0,255],
	event_handlers: [
		{ focus, menu_focus },
		{ unfocus, menu_unfocus },
		{ pad_choose, ui_flow_manager_respond_to_action,
			params: {
                action: select_difficulty
			}
		}
	]
});

createscreenelement({
	type: textelement,
	parent: fastgh3_pause_menu,
	id: practice,
	font: fontgrid_title_gh3,
	scale: 0.8,
	rgba: [210,210,210,250],
	text: "PRACTICE",
	just: [center, center],
	z_priority: 100,
	shadow_offs: (3.0, 3.0),
	shadow_rgba: [0,0,0,255],
	event_handlers: [
		{ focus, menu_focus },
		{ unfocus, menu_unfocus },
		{ pad_choose, ui_flow_manager_respond_to_action,
			params: {
                action: select_practice
			}
		}
	]
});

createscreenelement({
	type: textelement,
	parent: fastgh3_pause_menu,
	id: options,
	font: fontgrid_title_gh3,
	scale: 0.8,
	rgba: [210,210,210,250],
	text: "OPTIONS",
	just: [center, center],
	z_priority: 100,
	shadow_offs: (3.0, 3.0),
	shadow_rgba: [0,0,0,255],
	event_handlers: [
		{ focus, menu_focus },
		{ unfocus, menu_unfocus },
		{ pad_choose, ui_flow_manager_respond_to_action,
			params: {
                action: select_options
			}
		}
	]
});

createscreenelement({
	type: textelement,
	parent: fastgh3_pause_menu,
	id: exit,
	font: fontgrid_title_gh3,
	scale: 0.8,
	rgba: [210,210,210,250],
	text: "EXIT",
	just: [center, center],
	z_priority: 100,
	shadow_offs: (3.0, 3.0),
	shadow_rgba: [0,0,0,255],
	event_handlers: [
		{ focus, menu_focus },
		{ unfocus, menu_unfocus },
		{ pad_choose, ui_flow_manager_respond_to_action,
			params: {
                action: select_quit
			}
		}
	]
});

launchevent({type: focus, target: fastgh3_pause_menu});

}