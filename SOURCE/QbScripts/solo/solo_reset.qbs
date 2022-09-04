script({
	int $00000000 = 1;
}) {

if (%$00000000 == 1)
{
	change(solo_active_p1 = 0);
	change(last_solo_hits_p1 = 0); // number of notes hit
	change(last_solo_index_p1 = 0); // current note of solo
	change(last_solo_total_p1 = 0); // total number of notes
	change(note_index_p1 = 0); // overall note index tracked to catch notes hit just before solo executes
}
elseif (%$00000000 == 2)
{
	change(solo_active_p2 = 0);
	change(last_solo_hits_p2 = 0);
	change(last_solo_index_p2 = 0);
	change(last_solo_total_p2 = 0);
	change(note_index_p2 = 0);
}
if (GotParam(reset_hud))
{
	KillSpawnedScript(name=solo_ui_end);
	if (screenelementexists({id: %solotxt}))
	{
		destroyscreenelement({id: %solotxt});
	}
}

}