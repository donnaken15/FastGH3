script() {

// 1024 sprite limit test

i = 0;

repeat
{
	createscreenelement({
		type: spriteelement,
		parent: root_window,
		texture: logo_GH3_LoR_256,
		scale: 0.7,
		rgba: [255,255,255,255],
		just: [left, top],
		z_priority: 100,
		pos: (90.0, 10.0)
	});
	i = (%i + 1);
	if (%i == 1695)
	{
		break;
	}
}
repeat
{
	printf('%i', i = %i);
	createscreenelement({
		type: spriteelement,
		parent: root_window,
		texture: logo_GH3_LoR_256,
		scale: 0.7,
		rgba: [255,255,255,255],
		just: [left, top],
		z_priority: 100,
		pos: (90.0, 10.0)
	});
	/*createscreenelement({
		type: textelement,
		parent: root_window,
		id: useless,
		font: fontgrid_title_gh3,
		scale: 0.7,
		rgba: [255,255,255,255],
		text: "text copy",
		just: [left, top],
		z_priority: 100,
		pos: (90.0, 10.0)
	});*/
	i = (%i + 1);
	Wait(1,Seconds);
}

}