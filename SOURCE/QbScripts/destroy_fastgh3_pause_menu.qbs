script() {

//destroy_menu(menu_id=fastgh3_smenu);
//destroy_menu(menu_id=fastgh3_menu);
restore_start_key_binding();
if (screenelementexists({id: fastgh3_smenu})) {
    destroyscreenelement({id: fastgh3_smenu});
}
/*if (screenelementexists({id: fastgh3_menu})) {
    destroyscreenelement({id: fastgh3_menu});
}*/
if (screenelementexists({id: pausehead})) {
    destroyscreenelement({id: pausehead});
}
if (screenelementexists({id: resume})) {
    destroyscreenelement({id: resume});
}
if (screenelementexists({id: restart})) {
    destroyscreenelement({id: restart});
}
if (screenelementexists({id: difficulty})) {
    destroyscreenelement({id: difficulty});
}
if (screenelementexists({id: practice})) {
    destroyscreenelement({id: practice});
}
if (screenelementexists({id: options})) {
    destroyscreenelement({id: options});
}
if (screenelementexists({id: exit})) {
    destroyscreenelement({id: exit});
}
//clean_up_user_control_helpers();
disable_pause();

}