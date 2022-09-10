script() {

if (*enable_solos == 1)
{
	if ((*%player_status.text) == 'p1')
	{
		player = 1;
		change(note_index_p1 = %array_entry);
	}
	elseif ((*%player_status.text) == 'p2')
	{
		player = 2;
		change(note_index_p2 = %array_entry);
	}
	set_solo_hit_buffer(player=%player,0);
}

}