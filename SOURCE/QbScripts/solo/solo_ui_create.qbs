script({
	int player = 1;
}) {

FormatText(checksumName=lsh_p, 'last_solo_hits_p%d', d = %player);
FormatText(checksumName=lst_p, 'last_solo_total_p%d', d = %player);
num = ((100 / *%lsh_p) * *%lst_p);
FormatText(textname=text, '%d\\%', d = %num);
FormatText(checksumname=solotxt, 'solotxt%d', d = %player);
FormatText(checksumname=gemcont, 'gem_containerp%d', d = %player);
solo_reset(%player);
createscreenelement({
	type: textelement,
	parent: %gemcont,
	id: %solotxt,
	font: fontgrid_title_gh3,
	scale: 0.8,
	rgba: [255,255,255,255],
	text: %text,
	just: [center, center],
	z_priority: 20,
    pos: (640.0, 296.0)
});

}