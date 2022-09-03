script({
	int player = 1;
}) {

FormatText(checksumname=solotxt, 'solotxt%d', d = %player);
FormatText(checksumName=lsh_p, 'last_solo_hits_p%d', d = %player);
FormatText(checksumName=lst_p, 'last_solo_total_p%d', d = %player);
if (screenelementexists({id: %solotxt})) {
	scale = (0.8 + (%num * 100.0 * 2));
	if (*solo_display_type == 0)
	{
		num = ((100.0 / *%lsh_p) * *%lst_p);
		MathFloor(%num);
		FormatText(textname=text, '%d\\%', d = %floor);
	}
	else
	{
		fractional = (*%lsh_p);
		denum = (*%lst_p);
		FormatText(textname=text, '%d / %e', d = %fractional, e = %denum);
	}
	SetScreenElementProps(
		id = %solotxt,
		text = %text
	);
	DoScreenElementMorph(
		id=%solotxt,
		scale=1.1
	);
	DoScreenElementMorph(
		id=%solotxt,
		scale=%scale,
		relative_scale
	);
	DoScreenElementMorph(
		id=%solotxt,
		time=0.08,
		scale=0.9
	);
	DoScreenElementMorph(
		id=%solotxt,
		time=0.08,
		scale=%scale,
		relative_scale
	);
}

}