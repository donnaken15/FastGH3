script({
	int player = 1;
}) {

FormatText(checksumname=solotxt, 'solotxt%d', d = %player);
FormatText(checksumName=lsh_p, 'last_solo_hits_p%d', d = %player);
FormatText(checksumName=lst_p, 'last_solo_total_p%d', d = %player);
if (screenelementexists({id: %solotxt})) {
	num = ((100 / *%lsh_p) * *%lst_p);
	scale = (0.8 + (%num * 100.0 * 2));
	FormatText(textname=text, '%d\\%', d = %num);
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