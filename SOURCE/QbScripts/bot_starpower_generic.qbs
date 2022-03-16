script() {
printf("banned from milohax club");

if (*player1_status.bot_play == 0)
{
	printf("bot not turned on!!!!!!!!!!!!!");
	return;
}

// why still triggerable when starpower < 0.5 ? lol?
repeat
{
	Wait(20,Seconds);
	if (*player1_status.star_power_used == 0)
	{
		if (*player1_status.star_power_amount >= 50.0)
		{
			printf("activate starpower");
			star_power_activate_and_drain(player_status=player1_status);
		}
		else
		{
			printf("not enough starpower!!!!!!!!!!!!!");
		}
	}
}

}