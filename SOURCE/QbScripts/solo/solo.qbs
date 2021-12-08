script({
	int note_count = 100;
}) {

change(solo_active = 1);
change(last_solo_hits = 0);
change(last_solo_total = %note_count);
SpawnScriptNow({
	qbkey $00000000 = solo_ui_create;
	struct params = {};
});

}