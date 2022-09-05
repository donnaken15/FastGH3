script({
	int player = 1;
}) {

FormatText(checksumname=solotxt, 'solotxt%d', d = %player);
FormatText(checksumName=lsh_p, 'last_solo_hits_p%d', d = %player);
FormatText(checksumName=lst_p, 'last_solo_total_p%d', d = %player);
FormatText(checksumName=lsi_p, 'last_solo_index_p%d', d = %player);
if (screenelementexists({id: %solotxt})) {
	if (*solo_display_type == 0)
	{
		num = ((100.0 / *%lsh_p) * *%lst_p);
		MathFloor(%num);
		FormatText(textname=text, '%d\\%', d = %floor);
		scale = (0.8 + (%num * 100.0 * 2));
	}
	else
	{
		// debug purposes or seeing how many notes we're hit of how many in the solo or what the current note is
		// yes perfect very explanation yes yeah whoo
		fractional = (*%lsh_p);
		denum = (*%lst_p);
		index = (*%lsi_p);
		num = ((100.0 / %fractional) * %denum);
		scale = (0.8 + (%num * 100.0 * 2));
		FormatText(textname=text, '%d / %e, %f / %e', d = %fractional, e = %denum, f = %index);
	}
	SetScreenElementProps(
		id = %solotxt,
		text = %text,
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