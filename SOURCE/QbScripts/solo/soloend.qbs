script({
	qbkey part = guitar;
}) {

if (*game_mode == p2_battle || *enable_solos == 0)
{
	return;
}

i = 1;
repeat(*current_num_players)
{
	FormatText(checksumName=player_status, 'player%d_status', d = %i);
	if (%part == (*%player_status.part))
	{
		repeat
		{
			if (%i == 1)
			{
				if (*last_solo_index_p1 >= *last_solo_total_p1 || *solo_active_p1 == 0)
				{
					break;
				}
			}
			elseif (%i == 2)
			{
				if (*last_solo_index_p2 >= *last_solo_total_p2 || *solo_active_p2 == 0)
				{
					break;
				}
			}
			printf('waiting for something to happen to the last few notes');
			wait(1,gameframe);
		}
		if (%i == 1)
		{
			//change(solo_active_p1 = 0);
			num = (*player1_status.score + (*last_solo_hits_p1 / *solo_bonus_pts));
			change(structurename=player1_status,score = %num);
			num1 = *last_solo_hits_p1;
			num2 = *last_solo_total_p1;
			SpawnScriptNow(solo_ui_end,params={player:1});
			change(last_solo_hits_p1 = 0);
			change(last_solo_total_p1 = 0);
		}
		elseif (%i == 2)
		{
			//change(solo_active_p2 = 0);
			num = (*player2_status.score + (*last_solo_hits_p2 / *solo_bonus_pts));
			change(structurename=player2_status,score = %num);
			num1 = *last_solo_hits_p2;
			num2 = *last_solo_total_p2;
			SpawnScriptNow(solo_ui_end,params={player:2});
			change(last_solo_hits_p2 = 0);
			change(last_solo_total_p2 = 0);
		}
		solo_reset(i=%i);
	}
	i = (%i + 1);
}

}