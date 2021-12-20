script({
	int player = 1;
}) {

num = 0; // just set it raw idot '0%'
FormatText(textname=text, '%d\\%', d = %num);
FormatText(checksumname=solotxt, 'solotxt%d', d = %player);
FormatText(checksumname=gemcont, 'gem_containerp%d', d = %player);
if (screenelementexists({id: %solotxt})) {
	destroyscreenelement({id: %solotxt});
	KillSpawnedScript(name=solo_ui_end);
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
    pos: (640.0, 296.0)//,
	//shadow_offs: (6.0, 6.0),
	//shadow_rgba: [0,0,0,255]
});

}