script() {

if (*player1_status.bot_play == 0 &&
	*player2_status.bot_play == 0)
{
	printf('bot not turned on!!!!!!!!!!!!!');
	return;
}
// GHPCED mode LOL v
change(autowhammy=1);
// TODO, fix autowhammy for individual players

// was player_status.bot_star_power used to trigger it, or was it a setting?
// since values before are used to hit notes (bot_pattern/bot_strum)

// why still triggerable when starpower < 0.5 ? lol?
repeat
{
	wait_beats(16);
	// lazy to use format
	if (*player1_status.star_power_sequence == 0 ||
		*player2_status.star_power_sequence == 0)
	{
		if (*player1_status.star_power_used == 0 ||
			*player1_status.bot_play == 0 ||
			*player1_status.bot_star_power == 1)
		{
			if (*player1_status.star_power_amount >= 50.0)
			{
				printf('activate starpower');
				spawnscriptnow(
					star_power_activate_and_drain,
					params={
						player_status: player1_status,
						player: 1,
						player_text: 'p1'
					});
			}
			else
			{
				printf('not enough starpower!!!!!!!!!!!!!');
			}
		}
		if (*player2_status.star_power_used == 0 ||
			*player2_status.bot_play == 0 ||
			*player2_status.bot_star_power == 1)
		{
			if (*player2_status.star_power_amount >= 50.0)
			{
				printf('activate starpower (p2)');
				spawnscriptnow(
					star_power_activate_and_drain,
					params={
						player_status: player2_status,
						player: 2,
						player_text: 'p2'
					});
			}
		}
	}
}

}