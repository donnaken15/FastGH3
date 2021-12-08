script() {
if (*solo_active == 1)
{
	num = (*last_solo_hits + 1);
	change(last_solo_hits = %num);
	SpawnScriptNow({
		qbkey $00000000 = solo_ui_update;
		struct params = {};
	});
}
if (GuitarEvent_HitNotes_CFunc())
{
	UpdateGuitarVolume();
}
}