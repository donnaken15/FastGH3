script({
	int player = 1;
}) {

if (%player == 1)
{
	change(solo_active_p1 = 0);
	change(last_solo_hits_p1 = 0); // number of notes hit
	change(last_solo_index_p1 = 0); // current note of solo
	change(last_solo_total_p1 = 0); // total number of notes
	change(note_index_p1 = 0); // overall note index tracked to catch notes hit just before solo executes
}
elseif (%player == 2)
{
	change(solo_active_p2 = 0);
	change(last_solo_hits_p2 = 0);
	change(last_solo_index_p2 = 0);
	change(last_solo_total_p2 = 0);
	change(note_index_p2 = 0);
}
//KillSpawnedScript(name=solo);
//KillSpawnedScript(name=soloend);
if (GotParam(reset_hud))
{
	FormatText(checksumname=solotxt, 'solotxt%d', d = %player);
	if (screenelementexists({id: %solotxt})) {
		destroyscreenelement({id: %solotxt});
		//KillSpawnedScript(name=solo_ui_end);
	}
}

}