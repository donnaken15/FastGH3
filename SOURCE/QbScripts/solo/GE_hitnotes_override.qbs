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
	set_solo_hit_buffer(player=%player);
	FormatText(checksumName=sa_p, 'solo_active_p%d', d = %player);
	update_text = 1;
	if (*%sa_p == 1)
	{
		if (%player == 1)
		{
			// cheap cutoff
			// why did i even put +1,
			// because of note index??
			// whatver it jus w0rx
			if (*last_solo_index_p1 < (*last_solo_total_p1+1))
			{
				num = (*last_solo_hits_p1 + 1);
				change(last_solo_hits_p1 = %num);
			}
			else
			{
				update_text = 0;
			}
		}
		elseif (%player == 2)
		{
			if (*last_solo_index_p2 < (*last_solo_total_p2+1))
			{
				num = (*last_solo_hits_p2 + 1);
				change(last_solo_hits_p2 = %num);
			}
			else
			{
				update_text = 0;
			}
		}
		if (%update_text == 1)
		{
			solo_ui_update(player=%player);
		}
	}
}

//printf('%d',d=%array_entry);
if (GuitarEvent_HitNotes_CFunc())
{
	UpdateGuitarVolume();
}
if (GotParam(open))
{
	Open_NoteFX(player=%player,player_status=%player_status);
}

}