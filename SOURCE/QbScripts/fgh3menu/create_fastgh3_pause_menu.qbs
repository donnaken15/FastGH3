script({
	int player = 1;
}) {

player_device = (*last_start_pressed_device);
if (*player1_device == %player_device)
{
	player = 1;
}
else
{
	player = 2;
}
enable_pause();
safe_create_gh3_pause_menu();
kill_start_key_binding();

printf('paused');
// rewrite from controller_unplugged
/*if (*playing_song == 1)
{
	if (!GameIsPaused())
	{
		ui_flow_manager_respond_to_action({
			qbkey action = pause_game;
		});
	}
}
if (!GameIsPaused())
{
	gh3_start_pressed({
		qbkey $00000000 = no_back;
	});
}*/

/*new_menu({
	scrollid: fastgh3_pause_smenu,
	vmenuid: fastgh3_pause_menu,
	menu_pos: (120.0, 224.0),
	event_handlers: [
		{ pad_back, ui_flow_manager_respond_to_action,
			params: { action: go_back }
		}
	],
	spacing: -65,
	use_backdrop: ( 0 ),
	exclusive_device: %player_device
});*/

createscreenelement({
	type: vscrollingmenu,
	parent: root_window,
	id: fastgh3_pause_smenu,
	just: [left, top],
	dims: (600.0, 700.0),
    pos: (120.0, 224.0)
});/**/

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

// why is this breaking
//add_user_control_helper('SELECT', button = green, z = 100);

createscreenelement({
	type: textelement,
	parent: fastgh3_pause_menu,
	id: resume,
	font: fontgrid_title_gh3,
	scale: 0.8,
	rgba: [210,210,210,250],
	text: "RESUME",
	just: [left, center],
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
	just: [left, center],
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
	just: [left, center],
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
	just: [left, center],
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
	just: [left, center],
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
	just: [left, center],
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