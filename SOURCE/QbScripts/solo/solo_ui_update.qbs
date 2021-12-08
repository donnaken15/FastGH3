script() {

if (screenelementexists({id: solotxt1})) {
	num = ((100 / *last_solo_hits) * *last_solo_total);
	scale = (0.8 + (%num * 100.0 * 2));
	FormatText(textname=text, '%d\\%', d = %num);
	SetScreenElementProps(
		id = solotxt1,
		text = %text
	);
	DoScreenElementMorph(
		id=solotxt1,
		scale=1.1
	);
	DoScreenElementMorph(
		id=solotxt1,
		scale=%scale,
		relative_scale
	);
	DoScreenElementMorph(
		id=solotxt1,
		time=0.08,
		scale=0.9
	);
	DoScreenElementMorph(
		id=solotxt1,
		time=0.08,
		scale=%scale,
		relative_scale
	);
}

}