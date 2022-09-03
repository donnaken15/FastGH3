script({
	int $00000000 = 1;
}) {

if (%$00000000 == 1)
{
	change(note_index_p1 = 0);
	change(last_solo_index_p1 = 0);
}
elseif (%$00000000 == 2)
{
	change(note_index_p2 = 0);
	change(last_solo_index_p2 = 0);
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