script() {

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
set_solo_hit_buffer(/*player=%player,1*//*lol default params*/);
FormatText(checksumName=sa_p, 'solo_active_p%d', d = %player);
if (*%sa_p == 1)
{
	if (%player == 1)
	{
		num = (*last_solo_hits_p1 + 1);
		change(last_solo_hits_p1 = %num);
	}
	elseif (%player == 2)
	{
		num = (*last_solo_hits_p2 + 1);
		change(last_solo_hits_p2 = %num);
	}
	solo_ui_update(player=%player);
}
//printf('%d',d=%array_entry);
if (GuitarEvent_HitNotes_CFunc())
{
	UpdateGuitarVolume();
}
}