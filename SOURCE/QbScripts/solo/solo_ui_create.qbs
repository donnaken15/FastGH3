script() {

num = ((100 / *last_solo_hits) * *last_solo_total);
FormatText(textname=text, '%d\\%', d = %num);
if (screenelementexists({id: solotxt1})) {
	destroyscreenelement({id: solotxt1});
}
createscreenelement({
	type: textelement,
	parent: gem_containerp1,
	id: solotxt1,
	font: fontgrid_title_gh3,
	scale: 0.9,
	rgba: [255,255,255,255],
	text: %text,
	just: [center, center],
	z_priority: 20,
    pos: (640.0, 296.0)
});

}