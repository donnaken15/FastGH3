script({
	int player = 1;
}) {

FormatText(checksumname=solotxt, 'solotxt%d', d = %player);
FormatText(checksumName=lsh_p, 'last_solo_hits_p%d', d = %player);
FormatText(checksumName=lst_p, 'last_solo_total_p%d', d = %player);
if (screenelementexists({id: %solotxt})) {
	bonus = (*%lsh_p / *solo_bonus_pts);
	perf = ((100 / *%lsh_p) * *%lst_p);
	DoScreenElementMorph(
		id=%solotxt,
		time=0.3,
		scale=1.8,
		relative_scale // is this key working??
	);
	Wait(1.5,Seconds);
	perf_text = 'BAD';
	if (%perf <= 56)
	{
		perf_text = 'POOR';
	}
	elseif (%perf <= 64)
	{
		perf_text = 'OKAY';
	}
	elseif (%perf <= 76)
	{
		perf_text = 'GOOD';
	}
	elseif (%perf <= 88)
	{
		perf_text = 'GREAT';
	}
	elseif (%perf < 100)
	{
		perf_text = 'AWESOME';
	}
	elseif (%perf >= 100)
	{
		perf_text = 'PERFECT';
	}
	FormatText(textname=text, '%t SOLO!', t = %perf_text);
	if (screenelementexists({id: %solotxt}))
	{ // script is still alive when restarting song lol
		SetScreenElementProps(
			id = %solotxt,
			text = %text
		);
		DoScreenElementMorph(
			id=%solotxt,
			scale=0
		);
		DoScreenElementMorph(
			id=%solotxt,
			time=0.1,
			scale=1
		);
	}
	Wait(1.5,Seconds);
	FormatText(textname=text, '%d POINTS!', d = %bonus);
	if (screenelementexists({id: %solotxt}))
	{
		SetScreenElementProps(
			id = %solotxt,
			text = %text
		);
		DoScreenElementMorph(
			id=%solotxt,
			scale=0
		);
		DoScreenElementMorph(
			id=%solotxt,
			time=0.1,
			scale=1
		);
		Wait(1.5,Seconds);
		DoScreenElementMorph(
			id=%solotxt,
			time=0.1,
			scale=0
		);
	}
	Wait(0.1,Seconds);
	if (screenelementexists({id: %solotxt}))
	{
    	destroyscreenelement({id: %solotxt});
	}
}

}