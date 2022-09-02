script({
	int note_count = 100;
	qbkey part = guitar;
}) {

if (*game_mode == p2_battle)
{
	return;
}

GetSongTimeMs();
CastToInteger(time);
printf('time: %d',d=%time);

i = 1;
repeat(*current_num_players)
{
	FormatText(checksumName=player_status, 'player%d_status', d = %i);
	if (%part == (*%player_status.part))
	{
		song_array = *%player_status.current_song_gem_array;
		//
		if (%i == 1) // tedious because neversoft
		{
			// how do i change global stuff using formattext checksum
			change(solo_active_p1 = 1);
			change(last_solo_hits_p1 = 0);
			change(last_solo_total_p1 = %note_count);
		}
		elseif (%i == 2)
		{
			change(solo_active_p2 = 1);
			change(last_solo_hits_p2 = 0);
			change(last_solo_total_p2 = %note_count);
		}
		solo_ui_create(player=%i);
	}
	i = (%i + 1);
}

}