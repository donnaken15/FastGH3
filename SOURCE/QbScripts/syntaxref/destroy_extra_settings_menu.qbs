script() {

if (screenelementexists({id: cm_extra_settings_smenu})) {
    destroyscreenelement({id: cm_extra_settings_smenu});
}
destroy_generic_backdrop();
enable_pause();

}