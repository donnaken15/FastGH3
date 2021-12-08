script({
	int player = 1;
}) {

num = ((100 / *last_solo_hits_p1) * *last_solo_total_p1);
FormatText(textname=text, '%d\\%', d = %num);
FormatText(checksumname=solotxt, 'solotxt%d', d = %player);
FormatText(checksumname=gemcont, 'gem_containerp%d', d = %player);
if (screenelementexists({id: solotxt})) {
	destroyscreenelement({id: solotxt});
}
createscreenelement({
	type: textelement,
	parent: %gemcont,
	id: %solotxt,
	font: fontgrid_title_gh3,
	scale: 0.9,
	rgba: [255,255,255,255],
	text: %text,
	just: [center, center],
	z_priority: 20,
    pos: (640.0, 296.0)
});

}