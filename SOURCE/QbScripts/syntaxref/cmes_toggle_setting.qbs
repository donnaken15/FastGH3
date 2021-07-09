script() {

if (*%setting == 0) {
    change(globalname=%setting, newvalue=1);
}
else {
    change(globalname=%setting, newvalue=0);
}

entry=(*cmes_settings[%index]);
cmes_format_text(text=(%entry.text), setting=%setting, func=%func);
setscreenelementprops(id=%text_id, text=%text);

}