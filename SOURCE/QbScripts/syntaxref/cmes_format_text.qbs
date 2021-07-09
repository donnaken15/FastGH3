script() {

    if ((%func == cmes_toggle_setting)) {
        if ((*%setting == 1)) {
            formattext(textname=text, "%c : ON", c=%text);
        }
        else {
            formattext(textname=text, "%c : OFF", c=%text);
        }
    }
    elseif ((%func == cmes_update_hyperspeed)) {
        if ((*%setting > 0) && (*%setting <= 5)) {
            formattext(textname=text, "%c: ON, %d", c=%text, d=(*%setting));
        }
        else {
            formattext(textname=text, "%c: OFF", c=%text);
        }
    }
    
    return(text=%text);
}