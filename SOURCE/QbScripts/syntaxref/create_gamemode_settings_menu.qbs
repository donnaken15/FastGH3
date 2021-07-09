script() {

create_generic_backdrop();
disable_pause();

new_menu({
    QbKey scrollid = set_gamemode_smenu;
    QbKey vmenuid = set_gamemode_menu;
    Vector2 menu_pos = (500.0, 200.0);
    QbKey _ = text_left;
});

createscreenelement({
    type: textelement,
    parent: set_gamemode_menu,
    id: career,
    font: fontgrid_title_gh3,
    scale: 0.8,
    rgba: [210,210,210,250],
    text: "Singleplayer Career",
    just: [left, top],
    z_priority: 100,
    shadow_offs: (3.0, 3.0),
    shadow_rgba: [0,0,0,255],
    event_handlers: [
        { focus, menu_focus },
        { unfocus, menu_unfocus },
		{ pad_choose, ui_flow_manager_respond_to_action,
		  params: {
            action: p1career
          }
		}
	]
});

createscreenelement({
    type: textelement,
    parent: set_gamemode_menu,
    id: coop,
    font: fontgrid_title_gh3,
    scale: 0.8,
    rgba: [210,210,210,250],
    text: "Co-op Career",
    just: [left, top],
    z_priority: 100,
    shadow_offs: (3.0, 3.0),
    shadow_rgba: [0,0,0,255],
    event_handlers: [
        { focus, menu_focus },
        { unfocus, menu_unfocus },
		{ pad_choose, ui_flow_manager_respond_to_action,
		  params: {
            action: p2career
          }
		}
	]
});

createscreenelement({
    type: textelement,
    parent: set_gamemode_menu,
    id: quickplay,
    font: fontgrid_title_gh3,
    scale: 0.8,
    rgba: [210,210,210,250],
    text: "Quickplay",
    just: [left, top],
    z_priority: 100,
    shadow_offs: (3.0, 3.0),
    shadow_rgba: [0,0,0,255],
    event_handlers: [
        { focus, menu_focus },
        { unfocus, menu_unfocus },
        { pad_choose, %func,
          params: {
            func: %func,
            setting: %setting,
            text_id: %id,
            index: 2
          }
        }
    ]
});


entry = (*cmes_settings[3]);
text = (%entry.text);
setting = (%entry.setting);
func = cmes_toggle_setting;
id = star_sequence_text;
cmes_format_text(text=%text, setting=%setting, func=%func);

createscreenelement({
    type: textelement,
    parent: cm_extra_settings_menu,
    id: %id,
    font: fontgrid_title_gh3,
    scale: 0.8,
    rgba: [210,210,210,250],
    text: %text,
    just: [left, top],
    z_priority: 100,
    shadow_offs: (3.0, 3.0),
    shadow_rgba: [0,0,0,255],
    event_handlers: [
        { focus, menu_focus },
        { unfocus, menu_unfocus },
        { pad_choose, %func,
          params: {
            func: %func,
            setting: %setting,
            text_id: %id,
            index: 3
          }
        }
    ]
});

entry = (*cmes_settings[4]);
text = (%entry.text);
setting = (%entry.setting);
func = cmes_toggle_setting;
id = star_lightning_text;
cmes_format_text(text=%text, setting=%setting, func=%func);

createscreenelement({
    type: textelement,
    parent: cm_extra_settings_menu,
    id: %id,
    font: fontgrid_title_gh3,
    scale: 0.8,
    rgba: [210,210,210,250],
    text: %text,
    just: [left, top],
    z_priority: 100,
    shadow_offs: (3.0, 3.0),
    shadow_rgba: [0,0,0,255],
    event_handlers: [
        { focus, menu_focus },
        { unfocus, menu_unfocus },
        { pad_choose, %func,
          params: {
            func: %func,
            setting: %setting,
            text_id: %id,
            index: 4
          }
        }
    ]
});

entry = (*cmes_settings[5]);
text = (%entry.text);
setting = (%entry.setting);
func = cmes_toggle_setting;
id = hand_flames_text;
cmes_format_text(text=%text, setting=%setting, func=%func);

createscreenelement({
    type: textelement,
    parent: cm_extra_settings_menu,
    id: %id,
    font: fontgrid_title_gh3,
    scale: 0.8,
    rgba: [210,210,210,250],
    text: %text,
    just: [left, top],
    z_priority: 100,
    shadow_offs: (3.0, 3.0),
    shadow_rgba: [0,0,0,255],
    event_handlers: [
        { focus, menu_focus },
        { unfocus, menu_unfocus },
        { pad_choose, %func,
          params: {
            func: %func,
            setting: %setting,
            text_id: %id,
            index: 5
          }
        }
    ]
});



entry = (*cmes_settings[6]);
text = (%entry.text);
setting = (%entry.setting);
func = cmes_toggle_setting;
id = first_note_text;
cmes_format_text(text=%text, setting=%setting, func=%func);

createscreenelement({
    type: textelement,
    parent: cm_extra_settings_menu,
    id: %id,
    font: fontgrid_title_gh3,
    scale: 0.8,
    rgba: [210,210,210,250],
    text: %text,
    just: [left, top],
    z_priority: 100,
    shadow_offs: (3.0, 3.0),
    shadow_rgba: [0,0,0,255],
    event_handlers: [
        { focus, menu_focus },
        { unfocus, menu_unfocus },
        { pad_choose, %func,
          params: {
            func: %func,
            setting: %setting,
            text_id: %id,
            index: 6
          }
        }
    ]
});



launchevent({type: focus, target: p1_hyperspeed_text});
}