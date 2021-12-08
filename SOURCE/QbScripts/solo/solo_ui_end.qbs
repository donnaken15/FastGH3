script() {

if (screenelementexists({id: solotxt1})) {
	bonus = (*last_solo_hits / *solo_bonus_pts);
	perf = ((100 / *last_solo_hits) * *last_solo_total);
	DoScreenElementMorph(
		id=solotxt1,
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
	SetScreenElementProps(
		id = solotxt1,
		text = %text
	);
	DoScreenElementMorph(
		id=solotxt1,
		scale=0
	);
	DoScreenElementMorph(
		id=solotxt1,
		time=0.1,
		scale=1
	);
	Wait(1.5,Seconds);
	FormatText(textname=text, '%d POINTS!', d = %bonus);
	SetScreenElementProps(
		id = solotxt1,
		text = %text
	);
	DoScreenElementMorph(
		id=solotxt1,
		scale=0
	);
	DoScreenElementMorph(
		id=solotxt1,
		time=0.1,
		scale=1
	);
	Wait(1.5,Seconds);
	DoScreenElementMorph(
		id=solotxt1,
		time=0.1,
		scale=0
	);
	Wait(0.1,Seconds);
    destroyscreenelement({id: solotxt1});
}

}